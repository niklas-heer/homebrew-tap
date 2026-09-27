require "json"

module SideporchFormula
  TARGETS = %w[aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-musl x86_64-unknown-linux-musl].freeze

  def self.render(release, manifest)
    tag = release.fetch("tag_name")
    raise "Expected a published stable vX.Y.Z release" unless tag.match?(/\Av\d+\.\d+\.\d+\z/) &&
                                                            release["draft"] == false && release["prerelease"] == false

    version = tag.delete_prefix("v")
    names = TARGETS.map { |target| "sideporch-#{version}-#{target}.tar.gz" }
    assets = release.fetch("assets").map { |asset| asset.fetch("name") }
    raise "Release is missing required assets" unless (names + ["SHA256SUMS"] - assets).empty?

    checksums = {}
    manifest.each_line do |line|
      match = line.chomp.match(/\A([a-f0-9]{64})  (?:\.\/)?([^\/]+)\z/)
      raise "Invalid checksum entry" unless match
      raise "Duplicate checksum" if checksums.key?(match[2])

      checksums[match[2]] = match[1]
    end
    raise "Checksums must cover exactly the four release archives" unless checksums.keys.sort == names.sort

    stanzas = TARGETS.each_slice(2).with_index.map do |targets, index|
      platform = index.zero? ? "macos" : "linux"
      architectures = targets.each_with_index.map do |target, arch|
        name = "sideporch-#{version}-#{target}.tar.gz"
        <<~RUBY.chomp
          on_#{arch.zero? ? "arm" : "intel"} do
            url "https://github.com/niklas-heer/sideporch/releases/download/#{tag}/#{name}"
            sha256 "#{checksums.fetch(name)}"
          end
        RUBY
      end.join("\n\n").lines.map { |line| line.strip.empty? ? "\n" : "    #{line}" }.join
      "  on_#{platform} do\n#{architectures}\n  end"
    end.join("\n\n")

    <<~RUBY
      class Sideporch < Formula
        desc "Small, self-hosted team chat that ships as one binary"
        homepage "https://github.com/niklas-heer/sideporch"
        license "MIT"

        head do
          url "https://github.com/niklas-heer/sideporch.git", branch: "main"

          depends_on "rust" => :build
        end

      #{stanzas}

        def install
          if build.head?
            system "cargo", "install", *std_cargo_args
          else
            bin.install "sideporch"
          end
        end

        service do
          run [opt_bin/"sideporch", "--data", var/"sideporch"]
          keep_alive true
          log_path var/"log/sideporch.log"
          error_log_path var/"log/sideporch.log"
        end

        test do
          expected = build.head? ? "sideporch " : "sideporch \#{version}"
          assert_match expected, shell_output("\#{bin}/sideporch --version")
          port = free_port
          pid = spawn bin/"sideporch", "--data", testpath/"data", "--listen", "127.0.0.1:\#{port}"
          begin
            healthy = 20.times.any? do
              sleep 0.5
              quiet_system "curl", "-fsS", "http://127.0.0.1:\#{port}/healthz"
            end
            assert healthy, "sideporch did not answer on its health endpoint"
            assert_path_exists testpath/"data/sideporch.db"
            assert_match "/setup/", shell_output("\#{bin}/sideporch setup-link --data \#{testpath}/data")
          ensure
            Process.kill("TERM", pid)
            Process.wait(pid)
          end
        end
      end
    RUBY
  end
end

if $PROGRAM_NAME == __FILE__
  abort "Usage: ruby sideporch-formula.rb release.json SHA256SUMS" unless ARGV.length == 2
  puts SideporchFormula.render(JSON.parse(File.read(ARGV[0])), File.read(ARGV[1]))
end
