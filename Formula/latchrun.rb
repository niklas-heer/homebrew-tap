class Latchrun < Formula
  desc "Local command sessions with scoped credentials"
  homepage "https://github.com/niklas-heer/latchrun"
  license "MIT"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.1/latchrun-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "bfa6e17c5ca7da97040dd5c0c940dc333904588b413a5c1765f244756cd65f16"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.1/latchrun-v0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "061b71444f7531e2b567d8dc8dfe2e9b4b7f003558fc89152eaa50278e74f60e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.1/latchrun-v0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "324df5f6bdb27b2cb703355ede7a1c93b6dba69de3477d2b687dbe0b619449ae"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.1/latchrun-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "df6546ff8721f686d4ecf0f928fa42542e6e8b59d87313e1cecceca384308a1c"
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
