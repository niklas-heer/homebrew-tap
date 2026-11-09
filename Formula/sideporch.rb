class Sideporch < Formula
  desc "Small, self-hosted team chat that ships as one binary"
  homepage "https://github.com/niklas-heer/sideporch"
  license "MIT"

  head do
    url "https://github.com/niklas-heer/sideporch.git", branch: "main"

    depends_on "rust" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.7.0/sideporch-0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "745354aaca1dfb600ca7d222029376067a58105e8ffe5d404d97d4806597a081"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.7.0/sideporch-0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "2941e9a5d96699e93b1798b6df7cff010d6a7ac85db1f401f0f068bcf6d507d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.7.0/sideporch-0.7.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "84165d01092c028c7b875ea72720754598b1f3ecb437d34ae8ce45ac133c1df2"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.7.0/sideporch-0.7.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4d5c3078250b43d7c626d8d8f679954e08d714d4c81b3b1f51460c4b9c1872ed"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "sideporch"
    end
  end

  service do
    run [opt_bin/"sideporch", "--data", var/"sideporch"]
    keep_alive true
    log_path var/"log/sideporch.log"
    error_log_path var/"log/sideporch.log"
  end

  test do
    expected = build.head? ? "sideporch " : "sideporch #{version}"
    assert_match expected, shell_output("#{bin}/sideporch --version")
    port = free_port
    pid = spawn bin/"sideporch", "--data", testpath/"data", "--listen", "127.0.0.1:#{port}"
    begin
      healthy = 20.times.any? do
        sleep 0.5
        quiet_system "curl", "-fsS", "http://127.0.0.1:#{port}/healthz"
      end
      assert healthy, "sideporch did not answer on its health endpoint"
      assert_path_exists testpath/"data/sideporch.db"
      assert_match "/setup", shell_output("#{bin}/sideporch setup-link --data #{testpath}/data")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
