class Quirl < Formula
  desc "Everything you need, mixed in"
  homepage "https://github.com/niklas-heer/quirl"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.5.1/quirl-v0.5.1-aarch64-apple-darwin.tar"
      sha256 "c10017d5e4db0dc40b439beac0d4718bbf6c3fd1cad4634971fd4733a06a7d85"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.5.1/quirl-v0.5.1-x86_64-apple-darwin.tar"
      sha256 "58cd0ee7ea214d95e6b1eeb2b2a15f3e941a86f853bc667482df3fab9a9e4172"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.5.1/quirl-v0.5.1-aarch64-unknown-linux-gnu.tar"
      sha256 "f2646746d77686bc5e0a51049c0f538d93e2e389435bbbd7e026e912ea7ed844"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.5.1/quirl-v0.5.1-x86_64-unknown-linux-gnu.tar"
      sha256 "70e1e0e321eff2af339dc5dfe71c1bf54ac86f1c0177324a10669ad2f7ee4867"
    end
  end

  def install
    bin.install "bin/quirl"
    (pkgshare/"licenses").install "LICENSE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.txt"
  end

  test do
    assert_match "quirl 0.5.1", shell_output("#{bin}/quirl --version")
    %w[LICENSE THIRD_PARTY_NOTICES.md THIRD_PARTY_LICENSES.txt].each do |notice|
      assert_path_exists pkgshare/"licenses"/notice
    end
  end
end
