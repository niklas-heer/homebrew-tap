class Vrdx < Formula
  desc "Engineering decisions in portable Markdown"
  homepage "https://github.com/niklas-heer/vrdx"
  version "0.4.0"
  license "MIT"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/niklas-heer/vrdx/releases/download/v0.4.0/vrdx-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "dfe164e112fa14b2c928977dd33bb268049bb2d3ebcb9fa9b68cb39f1245e214"
    end

    on_intel do
      url "https://github.com/niklas-heer/vrdx/releases/download/v0.4.0/vrdx-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "2ae5cb93bdde5d7950fea8caadea8ceb0d8d56f9a1dc0c92e73bec2832bc370f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/vrdx/releases/download/v0.4.0/vrdx-v0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "16b16ee2e4874f5cefc4f19cad21d05970bed31a649fe28e507d0725a2ba3790"
    end

    on_intel do
      url "https://github.com/niklas-heer/vrdx/releases/download/v0.4.0/vrdx-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "449167da6a68f01413d70c0d1411342ebc9802d797e0a9f7603ed13be708be87"
    end
  end

  def install
    bin.install "vrdx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vrdx --version")
    guide = JSON.parse(shell_output("#{bin}/vrdx guide --json"))
    assert guide.fetch("ok")
    (testpath/"decision.json").write guide.fetch("data").fetch("new_input").fetch("example").to_json
    system bin/"vrdx", "new", "--from-json", "decision.json", "--json"
    system bin/"vrdx", "validate"
    system bin/"vrdx", "fmt", "--check"
  end
end
