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
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.4.0/sideporch-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "9b227d9c8551b493b0189d10f97c063df0f918ec7ddfbd8e87e48495b731de11"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.4.0/sideporch-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "15679dab71800639b29a8748674f48e4a1737d745922c58b61103c3e2dd05cdc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.4.0/sideporch-0.4.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4b99f491f4eb5ccf838cbefc1fc9e52035b060d64b92eeccff8d2970425679b2"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.4.0/sideporch-0.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3fab42b929f9a5f7a8014e3f1c1c56332cd4e2809c4da96a5d8a8a32212cf22a"
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
