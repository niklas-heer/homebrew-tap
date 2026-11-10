class Quirl < Formula
  desc "Everything you need, mixed in"
  homepage "https://github.com/niklas-heer/quirl"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.6.0/quirl-v0.6.0-aarch64-apple-darwin.tar"
      sha256 "8aa391a41aa1b410ebf425c7c8ee49300791dd052cc08675426a7263ef142614"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.6.0/quirl-v0.6.0-x86_64-apple-darwin.tar"
      sha256 "596ec002c23767ff4dea2b3ab18e94590bdfe94462e805a8a781f265d41ab362"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/niklas-heer/quirl/releases/download/v0.6.0/quirl-v0.6.0-aarch64-unknown-linux-gnu.tar"
      sha256 "01df26a565ff6b7dd90d8820031d77f52939e2cb08d3b24a77ac6903191046f5"
    else
      url "https://github.com/niklas-heer/quirl/releases/download/v0.6.0/quirl-v0.6.0-x86_64-unknown-linux-gnu.tar"
      sha256 "27f864e4628dfe1c1c786e1391099f7b3f3ed6e2891e83d7c01d4147048d8d1f"
    end
  end

  def install
    bin.install "bin/quirl"
    (pkgshare/"licenses").install "LICENSE", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.txt"
  end

  test do
    assert_match "quirl 0.6.0", shell_output("#{bin}/quirl --version")
    %w[LICENSE THIRD_PARTY_NOTICES.md THIRD_PARTY_LICENSES.txt].each do |notice|
      assert_path_exists pkgshare/"licenses"/notice
    end
  end
end
