class Quirl < Formula
  desc "Everything you need, mixed in"
  homepage "https://github.com/niklas-heer/quirl"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.4.0/quirl-v0.4.0-aarch64-apple-darwin.tar"
      sha256 "bb8d82bfb5f141c8607f71a151abf89042e60af23a61ce28e02666c273fa59d7"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.4.0/quirl-v0.4.0-x86_64-apple-darwin.tar"
      sha256 "7c1571a0a023a4eb79e76340b8faf07814aaac6613ef11fc1cf1fa412b4b2b1a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.4.0/quirl-v0.4.0-aarch64-unknown-linux-gnu.tar"
      sha256 "a2edd277d258a3131f5aad62b2cb8d2a530d4b4d9c592dba5ef69984ab9b4739"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.4.0/quirl-v0.4.0-x86_64-unknown-linux-gnu.tar"
      sha256 "afeef6fee59c35479636cac01fb309f3b6309f4a62da1a587339c1245515000e"
    end
  end

  def install
    bin.install "bin/quirl"
    (pkgshare/"licenses").install "LICENSE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.txt"
  end

  test do
    assert_match "quirl 0.4.0", shell_output("#{bin}/quirl --version")
    %w[LICENSE THIRD_PARTY_NOTICES.md THIRD_PARTY_LICENSES.txt].each do |notice|
      assert_path_exists pkgshare/"licenses"/notice
    end
  end
end
