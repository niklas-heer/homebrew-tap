cask "focal" do
  version "0.1.0,1"
  sha256 "ed54ce9c02afddfaced27a6d5d13f4919ee028526f59c603ad2f1d8293c8549a"

  url "https://github.com/niklas-heer/focal/releases/download/v#{version.csv.first}/Focal-#{version.csv.first}-#{version.csv.second}.zip"
  name "Focal"
  desc "Focused Markdown editor with live rendering, opened from the terminal"
  homepage "https://github.com/niklas-heer/focal"

  livecheck do
    url "https://github.com/niklas-heer/focal/releases/latest/download/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Focal.app"
  binary "#{appdir}/Focal.app/Contents/MacOS/focal"

  zap trash: [
    "~/Library/Application Support/Focal",
    "~/Library/Caches/com.niklasheer.focal",
    "~/Library/HTTPStorages/com.niklasheer.focal",
    "~/Library/Preferences/com.niklasheer.focal.plist",
  ]
end
