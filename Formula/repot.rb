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
      url "https://github.com/niklas-heer/repot/releases/download/v0.3.0/repot-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "3afee677c1214a2ce7b6d2d9fcb47f6f203ccfc339dfedae97779e340da4b90c"
    end

    on_intel do
      url "https://github.com/niklas-heer/repot/releases/download/v0.3.0/repot-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "9b95487e5b5c61384b537da4e52a368b575d16a293a8406021946195d2b99938"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/repot/releases/download/v0.3.0/repot-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b1f36501942f71b0630464d9aa193ad6813d2de7f97b5c6bd86b553ad216bb3d"
    end

    on_intel do
      url "https://github.com/niklas-heer/repot/releases/download/v0.3.0/repot-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a90686a9a220694917f1f3f2b2607258daea606e999fea6551471c1f439becfd"
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
