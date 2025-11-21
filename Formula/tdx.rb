class Tdx < Formula
  desc "Your todos, in markdown, at terminal speed"
  homepage "https://github.com/niklas-heer/tdx"
  version "0.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-arm64.zip"
      sha256 "c2315821147c0d093b2cab72b1db65b45369cbf704d8434480a76a06cda8e728"

      def install
        bin.install "tdx-darwin-arm64" => "tdx"
        bin.install "yoga.wasm"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-darwin-x64.zip"
      sha256 "61da7721736cc34b4e91be290a2c8d79b24785fa2e48e5e486e5390f23e60518"

      def install
        bin.install "tdx-darwin-x64" => "tdx"
        bin.install "yoga.wasm"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-arm64.zip"
      sha256 "86fecf8e1a401f4bfeb00cdf64bb9ab202d550679827a08e9522b49d4337d0da"

      def install
        bin.install "tdx-linux-arm64" => "tdx"
        bin.install "yoga.wasm"
      end
    end

    on_intel do
      url "https://github.com/niklas-heer/tdx/releases/download/v#{version}/tdx-linux-x64.zip"
      sha256 "7cf688c4f965efcb91a0a8217c30f686bb8914bd2249eb4327e4438c87164462"

      def install
        bin.install "tdx-linux-x64" => "tdx"
        bin.install "yoga.wasm"
      end
    end
  end

  test do
    system "#{bin}/tdx", "--help"
  end
end
