class Latchrun < Formula
  desc "Local command sessions with scoped credentials"
  homepage "https://github.com/niklas-heer/latchrun"
  license "MIT"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.2/latchrun-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "8448ea54b8091c57a26923f3fd4235eae3c6e47b308adcd64dc3835396ee83fb"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.2/latchrun-v0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "f0aece7a3d31fa56390e2ae78f3b8fbf8abfe3700d4598670fd5ebd0f44ed6d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.2/latchrun-v0.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e65ce4176994ef2e315ab78677e74342c41d2508c01f732b2f197d4e27ae4a78"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.2/latchrun-v0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "388678671fdb3e362c3c33876372da8c0da9b052e4c58fb14d5c4e508b932675"
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
