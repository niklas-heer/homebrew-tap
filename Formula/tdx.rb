class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "ba965381b0901c64e1769e79e7793f2b68f45795e5dce7cd0df3f32791f9d0cf"
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-amd64"
      sha256 "fc1edd2acc5e5ebde6e0a5a3df370fecdd4022b5f355a88d383c34128241dfa8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "a3f784b7e93dbaf5117b1929f38fac4b039c7d8804b7f0471954df865ab26ac2"
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-amd64"
      sha256 "25e5ee1738f1d48a6feb09d4e2efe4b45088430028c38f749bef69747b4d3308"
    end
  end

  def install
    bin.install Dir["tdx-*"].first => "tdx"
  end

  test do
    system bin/"tdx", "--help"
  end
end
