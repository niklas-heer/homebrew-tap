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
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.6.0/sideporch-0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "d308e562c01ef5305d25dd9a8d92921369fb57e30e290f6b16bfcd821b591783"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.6.0/sideporch-0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "738940538ee5b10cdf9e4d0c4c5239fdfb10931ff24027aca9cca632c600ba0b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.6.0/sideporch-0.6.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1cf2b24e27de6f40f303ba48620e1602b33e21eaea62f48835eb8a18cd9091dd"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.6.0/sideporch-0.6.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ae2b3634be17a87876853e637c378d45b5d5764e51141253f90c1000a312c050"
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
