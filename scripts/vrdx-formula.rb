require "json"

module VrdxFormula
  TARGETS = %w[aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu x86_64-unknown-linux-gnu].freeze

  def self.render(release, manifest)
    tag = release.fetch("tag_name")
    raise "Expected a published stable vX.Y.Z release" unless tag.match?(/\Av\d+\.\d+\.\d+\z/) &&
                                                            release["draft"] == false && release["prerelease"] == false

    names = TARGETS.map { |target| "vrdx-#{tag}-#{target}.tar.gz" }
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
      requirement = index.zero? ? "    depends_on macos: :sequoia\n\n" : ""
      architectures = targets.each_with_index.map do |target, arch|
        name = "vrdx-#{tag}-#{target}.tar.gz"
        <<~RUBY.chomp
            on_#{arch.zero? ? "arm" : "intel"} do
              url "https://github.com/niklas-heer/vrdx/releases/download/#{tag}/#{name}"
              sha256 "#{checksums.fetch(name)}"
            end
        RUBY
      end.join("\n\n").lines.map { |line| line.strip.empty? ? "\n" : "    #{line}" }.join
      "  on_#{platform} do\n#{requirement}#{architectures}\n  end"
    end.join("\n\n")

    <<~RUBY
      class Vrdx < Formula
        desc "Engineering decisions in portable Markdown"
        homepage "https://github.com/niklas-heer/vrdx"
        version "#{tag.delete_prefix('v')}"
        license "MIT"

      #{stanzas}

        def install
          bin.install "vrdx"
        end

        test do
          assert_match version.to_s, shell_output("\#{bin}/vrdx --version")
          guide = JSON.parse(shell_output("\#{bin}/vrdx guide --json"))
          assert guide.fetch("ok")
          (testpath/"decision.json").write guide.fetch("data").fetch("new_input").fetch("example").to_json
          system bin/"vrdx", "new", "--from-json", "decision.json", "--json"
          system bin/"vrdx", "validate"
          system bin/"vrdx", "fmt", "--check"
        end
      end
    RUBY
  end
end

if $PROGRAM_NAME == __FILE__
  abort "Usage: ruby vrdx-formula.rb release.json SHA256SUMS" unless ARGV.length == 2
  puts VrdxFormula.render(JSON.parse(File.read(ARGV[0])), File.read(ARGV[1]))
end
