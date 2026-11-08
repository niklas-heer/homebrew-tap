class Repot < Formula
  desc "Keep Git repositories organised, current and portable"
  homepage "https://github.com/niklas-heer/repot"
  license "MIT"

  head do
    url "https://github.com/niklas-heer/repot.git", branch: "main"

    depends_on "rust" => :build
  end

  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/repot/releases/download/v0.4.0/repot-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "1c9e0b454c278e48cfef3c1a3009b4614a3be9d20f83836bbb582c378625e8b4"
    end

    on_intel do
      url "https://github.com/niklas-heer/repot/releases/download/v0.4.0/repot-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "440a79999681897ca53c1af9ee23b38a367df0ae0556ae538726e94046ba95fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/repot/releases/download/v0.4.0/repot-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "17fa6810b9397d035252fff45e9b9e5c5312ef0d92e668f192e3a1611f5de8ea"
    end

    on_intel do
      url "https://github.com/niklas-heer/repot/releases/download/v0.4.0/repot-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "384b268b32403219cdffe8f4e76f34fd9142bda3238a8cbe8745343b9958f209"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "repot"
    end
    generate_completions_from_executable(bin/"repot", "completions")
  end

  test do
    expected = build.head? ? "repot " : "repot #{version}"
    assert_match expected, shell_output("#{bin}/repot --version")
    ENV["HOME"] = testpath
    ENV["GHQ_ROOT"] = testpath/"repos"
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    mkdir "repos"
    system "git", "init", "--quiet", testpath/"repos/example.test/team/project"
    listed = JSON.parse(shell_output("#{bin}/repot list --json"))
    assert_equal [(testpath/"repos/example.test/team/project").realpath.to_s], listed.map { |entry| entry["path"] }
    assert_match "Usage:", shell_output("#{bin}/repot --help")
  end
end
