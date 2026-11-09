class Latchrun < Formula
  desc "Local command sessions with scoped credentials"
  homepage "https://github.com/niklas-heer/latchrun"
  license "MIT"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.3.1/latchrun-v0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "63fcd306c8a8238bbd500b64054fc8384e8cd3489ccbab39f4fcd9420d50ab3a"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.3.1/latchrun-v0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "d5a1a218e0ba6809243fdd16969f41e992cdc4145d2fa0b0c5d708d11630f398"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.3.1/latchrun-v0.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "583a4c0780c7d19dcc60864aadc88bf88e9a58ef2333457f8d603f3f09071b76"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.3.1/latchrun-v0.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "737e7058e323482d8baef58a0bf559beade7721005d4f67c2a7520e0c7fff770"
    end
  end

  def install
    bin.install "latchrun"
    pkgshare.install "LICENSE", "THIRD_PARTY_LICENSES.txt"
    pkgshare.install "examples"
    doc.install "README.md", "CHANGELOG.md", "BUILD_BRIEF.md", "AGENTS.md", "docs"
    doc.install_symlink pkgshare/"LICENSE", pkgshare/"THIRD_PARTY_LICENSES.txt", pkgshare/"examples"
  end

  def caveats
    return unless OS.linux?

    <<~EOS
      Linux release binaries require host glibc 2.39 or newer.
      Optional sandboxing also requires /usr/bin/bwrap and permitted user namespaces.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/latchrun --version")
    assert_path_exists doc/"docs/shells.md"
    assert_path_exists doc/"examples/fake.json"
    assert_path_exists doc/"LICENSE"
    runtime = testpath/"runtime"
    (testpath/"profile.json").write <<~JSON
      {
        "project": "#{testpath}",
        "purpose": "Homebrew fake credential smoke",
        "provider": "fake",
        "credentials": {"TEST_SECRET": "fake://homebrew"},
        "commands": [{"executable": "/usr/bin/printenv", "args": ["TEST_SECRET"]}],
        "ttl_seconds": 60,
        "timeout_seconds": 10
      }
    JSON
    system bin/"latchrun", "--runtime-dir", runtime, "service", "start"
    begin
      system bin/"latchrun", "--runtime-dir", runtime, "session", "start", "test",
             "--profile", testpath/"profile.json"
      output = shell_output("#{bin}/latchrun --runtime-dir #{runtime} run test " \
                            "--operation brew-test -- /usr/bin/printenv TEST_SECRET")
      assert_equal "[REDACTED]\n", output
    ensure
      system bin/"latchrun", "--runtime-dir", runtime, "service", "stop"
    end
  end
end
