class Quirl < Formula
  desc "Everything you need, mixed in"
  homepage "https://github.com/niklas-heer/quirl"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.6.1/quirl-v0.6.1-aarch64-apple-darwin.tar"
      sha256 "4af60e7c0954613da38e95b771ff3b998deacecd21be8f2f8e48a2a13cb9f8fc"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.6.1/quirl-v0.6.1-x86_64-apple-darwin.tar"
      sha256 "0908536268ca23d0a89e1d0d729474581c5a00eb76b257fe4a2d398cf0b04dee"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.6.1/quirl-v0.6.1-aarch64-unknown-linux-gnu.tar"
      sha256 "2a7bd6be3b0c33c7a3681c3aee4101205efb0eebd321f4d708daea25ed5be96c"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.6.1/quirl-v0.6.1-x86_64-unknown-linux-gnu.tar"
      sha256 "ec3431ac924fc5a59be5d3627afd21c7215b405d3f92eb7cc7b1bb64d9624b72"
    end
  end

  def install
    bin.install "bin/quirl"
    (pkgshare/"licenses").install "LICENSE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.txt"
  end

  test do
    assert_match "quirl 0.6.1", shell_output("#{bin}/quirl --version")
    %w[LICENSE THIRD_PARTY_NOTICES.md THIRD_PARTY_LICENSES.txt].each do |notice|
      assert_path_exists pkgshare/"licenses"/notice
    end
  end
end
