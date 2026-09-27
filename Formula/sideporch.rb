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
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.1.1/sideporch-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "77728303f1cefd3cdc2dc28789eb0aaf66cf7b3b54f77b6b49339ba47e613091"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.1.1/sideporch-0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "7b85d1edbed8e0d217cbd22e54cc4393fb8f8e33182982c59719b272f0d3d362"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.1.1/sideporch-0.1.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "098ed82ed7b0079e8692e957e1409c54fd9e05c0437a70aba0ad2169444d1057"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.1.1/sideporch-0.1.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3b7b57eaae7146820089ff201295b62b1d3684a4641e8b9fc6756c98a1f57825"
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
      assert_match "/setup/", shell_output("#{bin}/sideporch setup-link --data #{testpath}/data")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
