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
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.2.0/sideporch-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "5dc4d191b329ae98924ed1f99ca18cf238673d4a8bb6da58de7d3e9f1d5207f1"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.2.0/sideporch-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "ea9af127a58df7251a6789f67d7593b5240e45248f2c1d9dc7f6298163e2d65e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.2.0/sideporch-0.2.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e25b21bc0e5dbbe082ec98bbe5224a77d478460c1d720177162c97e2d184483f"
    end

    on_intel do
      url "https://github.com/niklas-heer/sideporch/releases/download/v0.2.0/sideporch-0.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "652bd372023084cbd8068911feab6d4935e8b92c1bfd8e02956d2137016fe25c"
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
