class Latchrun < Formula
  desc "Local command sessions with scoped credentials"
  homepage "https://github.com/niklas-heer/latchrun"
  license "MIT"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.0/latchrun-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "ad468c1d6c3b547979d774e3c226b109de2c63b4fe5948e939bc949e3d557094"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.0/latchrun-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "113002d7a12e6dc5267aec26abd752f6102860fdff6ec40940e7879745e91eeb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.0/latchrun-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a5833c73c9095e9a5c9231ef20f582e0f177b61ec2335a23859c43cfde755258"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.0/latchrun-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5c6f070834e1332abf0169c8a9e084adee4a599e41355199fac05cd97d879383"
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
