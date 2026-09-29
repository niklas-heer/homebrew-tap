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
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.4.1/sideporch-0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "7365da5679db15a66bc534540069e43a33f14d2220394b32a13e1f2291afca2d"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.4.1/sideporch-0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "c79fc974b43b28cfb6a70451c1e876708a0165f831f92c1f7d15ec67f8bcb028"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.4.1/sideporch-0.4.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c2ec44981f3b88376b10eeabb2225290cdd682402ddb156d722bc774da73976d"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.4.1/sideporch-0.4.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1e1685d066c96ecc300e0327de85e16e606c5e2cce0bb19a4a0008e47a4053e5"
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
