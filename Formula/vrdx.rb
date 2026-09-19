class Vrdx < Formula
  desc "Engineering decisions in portable Markdown"
  homepage "https://github.com/niklas-heer/vrdx"
  version "0.3.0"
  license "MIT"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/niklas-heer/vrdx/releases/download/v0.3.0/vrdx-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "8c8d40545db399b0e73f90c302c30054ad5a1b3b88664941e53c52536d76a0fa"
    end

    on_intel do
      url "https://github.com/niklas-heer/vrdx/releases/download/v0.3.0/vrdx-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "139c63775ca357807508e5f27387d98b0161cccfce2d8c3112c18896833a25c5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/vrdx/releases/download/v0.3.0/vrdx-v0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bec25d3b1b2a2a52d102c9fb232293b728475b7277e5fc24b9f1f969bc8dfc77"
    end

    on_intel do
      url "https://github.com/niklas-heer/vrdx/releases/download/v0.3.0/vrdx-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "17ec3df7845804332ceb3088373093611683afb8026397cf654512dd8448b44c"
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
