class Kindred < Formula
  desc "Local family-history graph built from your notes"
  homepage "https://github.com/niklas-heer/kindred"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/kindred/releases/download/v0.1.0/kindred-aarch64-apple-darwin.tar.xz"
      sha256 "ba95b326a9805eec11273d6159f17d1eb9ba9a9bf601102a237e63a081e1dd6a"
    end

    on_intel do
      url "https://github.com/niklas-heer/kindred/releases/download/v0.1.0/kindred-x86_64-apple-darwin.tar.xz"
      sha256 "559ce0547c4925528e1c80956a24d4bce8d9dab5521c8f3736162af4a7e34bc3"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    on_intel do
      url "https://github.com/niklas-heer/kindred/releases/download/v0.1.0/kindred-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "417fb02ed6f70c7b77c79bf85ecd54eb84942b21818a4f384b82e345cf0b7df5"
    end
  end

  def install
    bin.install "kindred"
    pkgshare.install "examples", "LICENSE"
    doc.install "README.md", "CHANGELOG.md", "CONTRIBUTING.md", "docs"
    doc.install_symlink pkgshare/"examples", pkgshare/"LICENSE"
  end

  def caveats
    return unless OS.linux?

    "Linux release binaries require host glibc 2.35 or newer."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kindred --version")
    assert_path_exists doc/"docs/SCHEMA.md"
    assert_path_exists doc/"examples/historical/european-dynasties/people/p_charlemagne.md"
    system bin/"kindred", "init", testpath/"family"
    (testpath/"family/people/elin.md").write <<~YAML
      ---
      version: 1
      id: elin
      type: person
      name: Elin Example
      born: "1900"
      parents: []
      ---
      A fictional Homebrew test record.
    YAML
    result = JSON.parse(shell_output("#{bin}/kindred check #{testpath}/family --json"))
    assert_empty result.fetch("diagnostics")
    assert_equal 2, result.fetch("records")
    assert_equal "missing_sources", result.fetch("warnings").first.fetch("code")
    system bin/"kindred", "check", pkgshare/"examples/fictional"
    system bin/"kindred", "check", pkgshare/"examples/historical/european-dynasties"
  end
end
