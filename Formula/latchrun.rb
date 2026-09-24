class Latchrun < Formula
  desc "Local command sessions with scoped credentials"
  homepage "https://github.com/niklas-heer/latchrun"
  license "MIT"

  on_macos do
    depends_on macos: :sequoia

    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.3/latchrun-v0.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "0797d15d2ec50fb6a4c3ef00146cd7aca4063f2d1163e17ca1fdb64cd424a9a1"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.3/latchrun-v0.1.3-x86_64-apple-darwin.tar.gz"
      sha256 "8847ebb161524bb551c8ef34bbdb261e52acd9f58f327e0dab1b3590aeb30cc6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.3/latchrun-v0.1.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "583bd6dde524147c1c799e1f026684fa7a691c40d3dd5aca384c5ae24bef60a2"
    end

    on_intel do
      url "https://github.com/niklas-heer/latchrun/releases/download/v0.1.3/latchrun-v0.1.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1496c337a4c72328f47465a9a9d1425df42137309fe2de2de69099df875aded4"
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
