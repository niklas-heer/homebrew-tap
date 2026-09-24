cask "spokn" do
  version "0.4.0,9"
  sha256 "b3662d576e60ac8d91251a702248ddad8021539914f2940cde05abc268e2a58f"

  url "https://github.com/niklas-heer/spokn-tts/releases/download/v#{version.csv.first}/Spokn-#{version.csv.first}-#{version.csv.second}.zip"
  name "Spokn"
  desc "Text-to-speech reader with karaoke-style highlighting"
  homepage "https://github.com/niklas-heer/spokn-tts"

  livecheck do
    url "https://github.com/niklas-heer/spokn-tts/releases/latest/download/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Spokn.app"

  zap trash: [
    "~/Library/Application Support/Spokn",
    "~/Library/Caches/com.niklasheer.spokn",
    "~/Library/HTTPStorages/com.niklasheer.spokn",
    "~/Library/HTTPStorages/com.niklasheer.spokn.binarycookies",
    "~/Library/Preferences/com.niklasheer.spokn.plist",
  ]
end
