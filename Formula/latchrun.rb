class Latchrun < Formula
  desc "Local command sessions with scoped credentials"
  homepage "https://github.com/niklas-heer/latchrun"
  license "MIT"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.2.0/latchrun-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "d6d065d2c9bcdc382960a3c978f834c12a661ae57417550a9c3a4425cfcae7d8"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.2.0/latchrun-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "59d9f04a0770af5497fa83816e768eefbee54a741e7024bfd20edf086bf9a53a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.2.0/latchrun-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "15d23fd4c857c11dda5ed4c98fbff9ee54cfe70787c61a4f7c6df2bf2333fb04"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.2.0/latchrun-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3f31b5b0a6ec5c87f426d098cde8580bd61c5e606c7adda908983a1fab11a39a"
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
