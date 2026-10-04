class Quirl < Formula
  desc "Everything you need, mixed in"
  homepage "https://github.com/niklas-heer/quirl"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.5.0/quirl-v0.5.0-aarch64-apple-darwin.tar"
      sha256 "f10f0874a2b77c267fdb4b5486acceb9c54f330b52e7f9cc88d7bb760d1cbb30"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.5.0/quirl-v0.5.0-x86_64-apple-darwin.tar"
      sha256 "0fa661c876a3b5761300e5e0518dd1770598ff3f7b54058a6f273f66ce2fe1d7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.5.0/quirl-v0.5.0-aarch64-unknown-linux-gnu.tar"
      sha256 "51f31fc09ec8ecc5aa1cb6bd0945a16d45e6944e7f6bb4a783848a624530f93d"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.5.0/quirl-v0.5.0-x86_64-unknown-linux-gnu.tar"
      sha256 "93550819ec3fb6b3d406c48ed270f0b9fc0bf4e466fbb49fd2e27e147b66d31d"
    end
  end

  def install
    bin.install "bin/quirl"
    (pkgshare/"licenses").install "LICENSE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.txt"
  end

  test do
    assert_match "quirl 0.5.0", shell_output("#{bin}/quirl --version")
    %w[LICENSE THIRD_PARTY_NOTICES.md THIRD_PARTY_LICENSES.txt].each do |notice|
      assert_path_exists pkgshare/"licenses"/notice
    end
  end
end
