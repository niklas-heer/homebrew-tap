require "json"

module RepotFormula
  TARGETS = %w[aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu x86_64-unknown-linux-gnu].freeze

  def self.render(release, manifest)
    tag = release.fetch("tag_name")
    raise "Expected a published stable vX.Y.Z release" unless tag.match?(/\Av\d+\.\d+\.\d+\z/) &&
                                                            release["draft"] == false && release["prerelease"] == false

    version = tag.delete_prefix("v")
    names = TARGETS.map { |target| "repot-#{version}-#{target}.tar.gz" }
    assets = release.fetch("assets").map { |asset| asset.fetch("name") }
    raise "Release is missing required assets" unless (names + ["SHA256SUMS"] - assets).empty?

    checksums = {}
    manifest.each_line do |line|
      match = line.chomp.match(/\A([a-f0-9]{64})  (?:\.\/)?([^\/]+)\z/)
      raise "Invalid checksum entry" unless match
      raise "Duplicate checksum" if checksums.key?(match[2])

      checksums[match[2]] = match[1]
    end
    # Releases up to v0.1.0 also listed a generated repot.rb; only archives matter here.
    archives = checksums.keys.select { |name| name.end_with?(".tar.gz") }
    raise "Checksums must cover exactly the four release archives" unless archives.sort == names.sort

    stanzas = TARGETS.each_slice(2).with_index.map do |targets, index|
      platform = index.zero? ? "macos" : "linux"
      architectures = targets.each_with_index.map do |target, arch|
        name = "repot-#{version}-#{target}.tar.gz"
        <<~RUBY.chomp
          on_#{arch.zero? ? "arm" : "intel"} do
            url "https://github.com/niklas-heer/repot/releases/download/#{tag}/#{name}"
            sha256 "#{checksums.fetch(name)}"
          end
        RUBY
      end.join("\n\n").lines.map { |line| line.strip.empty? ? "\n" : "    #{line}" }.join
      "  on_#{platform} do\n#{architectures}\n  end"
    end.join("\n\n")

    <<~RUBY
      class Repot < Formula
        desc "Keep Git repositories organised, current and portable"
        homepage "https://github.com/niklas-heer/repot"
        version "#{version}"
        license "MIT"

        head do
          url "https://github.com/niklas-heer/repot.git", branch: "main"

          depends_on "rust" => :build
        end

        depends_on "git"

      #{stanzas}

        def install
          if build.head?
            system "cargo", "install", *std_cargo_args
          else
            bin.install "repot"
          end
          generate_completions_from_executable(bin/"repot", "completions")
        end

        test do
          expected = build.head? ? "repot " : "repot \#{version}"
          assert_match expected, shell_output("\#{bin}/repot --version")
          ENV["HOME"] = testpath
          ENV["GHQ_ROOT"] = testpath/"repos"
          ENV["XDG_CONFIG_HOME"] = testpath/"config"
          mkdir "repos"
          system "git", "init", "--quiet", testpath/"repos/example.test/team/project"
          listed = JSON.parse(shell_output("\#{bin}/repot list --json"))
          assert_equal [(testpath/"repos/example.test/team/project").realpath.to_s], listed.map { |entry| entry["path"] }
          assert_match "Usage:", shell_output("\#{bin}/repot --help")
        end
      end
    RUBY
  end
end

if $PROGRAM_NAME == __FILE__
  abort "Usage: ruby repot-formula.rb release.json SHA256SUMS" unless ARGV.length == 2
  puts RepotFormula.render(JSON.parse(File.read(ARGV[0])), File.read(ARGV[1]))
end
