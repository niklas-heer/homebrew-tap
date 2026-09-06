class Quirl < Formula
  desc "Everything you need, mixed in"
  homepage "https://github.com/niklas-heer/quirl"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.3.0/quirl-v0.3.0-aarch64-apple-darwin.tar"
      sha256 "ab116b02c2bc41143453d09c679eb99dcb7312234ec10057d4fd347de5f343c2"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.3.0/quirl-v0.3.0-x86_64-apple-darwin.tar"
      sha256 "33c425720b2efacf83911ac1e97be8b814165f30f70e76f0124e100b4b53a7f0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.3.0/quirl-v0.3.0-aarch64-unknown-linux-gnu.tar"
      sha256 "01a2abdbc86743ded1cda5f9ed154d9c3796a126112c70c5ad4f0917be03da29"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.3.0/quirl-v0.3.0-x86_64-unknown-linux-gnu.tar"
      sha256 "97935d3d0cf7de72c84f3b1b17855fff97b5d9a086037e325b19788329573148"
    end
  end

  def install
    bin.install "bin/quirl"
    (pkgshare/"licenses").install "LICENSE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.txt"
  end

  test do
    assert_match "quirl 0.3.0", shell_output("#{bin}/quirl --version")
    %w[LICENSE THIRD_PARTY_NOTICES.md THIRD_PARTY_LICENSES.txt].each do |notice|
      assert_path_exists pkgshare/"licenses"/notice
    end
  end
end
