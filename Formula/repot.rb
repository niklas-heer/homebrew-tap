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
      url "https://github.com/niklas-heer/repot/releases/download/v0.2.0/repot-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "aa1294083b1ec7e674726a4ea33bd0666052300711b0ecc2dbcc414832ebf08c"
    end

    on_intel do
      url "https://github.com/niklas-heer/repot/releases/download/v0.2.0/repot-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "65e42e0a773941c025c92addb993bb1acfda43915e6f2076c53087247f54cce3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/repot/releases/download/v0.2.0/repot-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6a14c3a6e2a9993219954cca9f10091805d9d129e402b8f7fa1f986bd9dc9eaf"
    end

    on_intel do
      url "https://github.com/niklas-heer/repot/releases/download/v0.2.0/repot-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d3eec2307801358e03e36f2dfcf0928305efe5b6f246612276e807aef8129c01"
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
