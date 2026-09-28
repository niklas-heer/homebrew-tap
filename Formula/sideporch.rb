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
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.3.0/sideporch-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "79e02090a3347ed2db79b5d316f393260341c92553f49cad359bbaae3c9e1cf6"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.3.0/sideporch-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "09ffa8b9e18e0b87214aa781ffcfebfd50eddd422abe17390c2c849360e80e58"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.3.0/sideporch-0.3.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ada9a74eace5b887ff82cdc14ae255b207974112ef0fcc09dd02a4c8c83128d5"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.3.0/sideporch-0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "99a4a84314b2209804fcdfabdd496518bf4a19577757ea2de6d674df119e85df"
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
