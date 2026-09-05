class Quirl < Formula
  desc "Everything you need, mixed in"
  homepage "https://github.com/niklas-heer/quirl"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.2.0/quirl-v0.2.0-aarch64-apple-darwin.tar"
      sha256 "d843364ef13c80deed3b9b25c92340dd751997d033f9e620638519e6d36ea9ae"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.2.0/quirl-v0.2.0-x86_64-apple-darwin.tar"
      sha256 "0c2ab2d4f4ece3a4c5f946bcdaebd8e93f9973a9ccc058cc42c5dfa0f1411e9f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.2.0/quirl-v0.2.0-aarch64-unknown-linux-gnu.tar"
      sha256 "77c8ac4b41fed8b6b1ae2e195c6c7add06a7a463482bf75b050a40b0c142b2f2"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.2.0/quirl-v0.2.0-x86_64-unknown-linux-gnu.tar"
      sha256 "c7b641943960d1e702ec26f60baccd7b26048acf491553e9708c0dc96d1cd4af"
    end
  end

  def install
    bin.install "bin/quirl"
    (pkgshare/"licenses").install "LICENSE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.txt"
  end

  test do
    assert_match "quirl 0.2.0", shell_output("#{bin}/quirl --version")
    %w[LICENSE THIRD_PARTY_NOTICES.md THIRD_PARTY_LICENSES.txt].each do |notice|
      assert_path_exists pkgshare/"licenses"/notice
    end
  end
end
