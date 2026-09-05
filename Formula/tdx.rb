class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.14.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64"
      sha256 "55fbfd3d0654ff8b7f8b074ad32c6631ad11df7e8c180f5f11dd39c0456af473"
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-amd64"
      sha256 "a73360897a3dd478b0ee3e560d7317f4a3060bf116424676d08ac07c51103716"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64"
      sha256 "1ddb7d866014b35f5265d8647a92d18259601e9660915610bab23bf15e8dfa51"
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-amd64"
      sha256 "a21f4b83d7731b946e4820f8f52e373197efd8cd0eae0e8dbfd905b3e9e16e2a"
    end
  end

  def install
    bin.install Dir["tdx-*"].first => "tdx"
  end

  test do
    system bin/"tdx", "--help"
  end
end
