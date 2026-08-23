class Quirl < Formula
  desc "Everything you need, mixed in"
  homepage "https://github.com/niklas-heer/quirl"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.1.0/quirl-v0.1.0-aarch64-apple-darwin.tar"
      sha256 "1c9737b3efafe23da4eba1f833b34f692ff549651062a052263405e7e1f8951e"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.1.0/quirl-v0.1.0-x86_64-apple-darwin.tar"
      sha256 "dfd96b405eeebceedf6c050cbb71b33b878cfdcd600a38fbe262a3a9538e0a54"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.1.0/quirl-v0.1.0-aarch64-unknown-linux-gnu.tar"
      sha256 "d2725da8c92325009fcec93570ab3563851dee9a3508fc8ea344a034e7bb3c8e"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.1.0/quirl-v0.1.0-x86_64-unknown-linux-gnu.tar"
      sha256 "5f30bea27c7d25e766de90471503397c31c61806d327cc974f6b2d0d9e2fa0f2"
    end
  end

  def install
    bin.install "bin/quirl"
    (pkgshare/"licenses").install "LICENSE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.txt"
  end

  test do
    assert_match "quirl 0.1.0", shell_output("#{bin}/quirl --version")
    %w[LICENSE THIRD_PARTY_NOTICES.md THIRD_PARTY_LICENSES.txt].each do |notice|
      assert_path_exists pkgshare/"licenses"/notice
    end
  end
end
