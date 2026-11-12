class Quirl < Formula
  desc "Everything you need, mixed in"
  homepage "https://github.com/niklas-heer/quirl"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.7.0/quirl-v0.7.0-aarch64-apple-darwin.tar"
      sha256 "07fcd148d4b5a8c9c469b7963dda9dc21c8caaa788b7a06e12cc29641c16d128"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.7.0/quirl-v0.7.0-x86_64-apple-darwin.tar"
      sha256 "8a0570355da9c41cd90cbb152962d5b2752a1337e4e4972cc60c247ec3efbc7a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.7.0/quirl-v0.7.0-aarch64-unknown-linux-gnu.tar"
      sha256 "ef7b8b566bb4328bc8fa76dd80ea2fb740bc296c9d5ce848932baf0eddaf98c2"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.7.0/quirl-v0.7.0-x86_64-unknown-linux-gnu.tar"
      sha256 "24baa09e1e750b561fce40f6060a63638134b42e736a1713188c1e4a2582e024"
    end
  end

  def install
    bin.install "bin/quirl"
    (pkgshare/"licenses").install "LICENSE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.txt"
  end

  test do
    assert_match "quirl 0.7.0", shell_output("#{bin}/quirl --version")
    %w[LICENSE THIRD_PARTY_NOTICES.md THIRD_PARTY_LICENSES.txt].each do |notice|
      assert_path_exists pkgshare/"licenses"/notice
    end
  end
end
