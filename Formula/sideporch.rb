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
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.5.0/sideporch-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "48b8a4b0c43f89447f6db579f962ee73d53621fb4f1baf1e29931eaf85d62cf9"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.5.0/sideporch-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "1c7b740a2f3646bc94b4642dfbe6448b126f781fad73965c9a7319776f8fccba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.5.0/sideporch-0.5.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ca414b3a33ada071b31dfd8a2c70d878437d40faaa62d25ee950fd1b0cfd5edf"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.5.0/sideporch-0.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7de0a4e774aa217e4ea0042ae14a1fddaa140ebfdd6d4a80209baa6a7e1420ca"
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
