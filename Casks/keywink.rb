cask "keywink" do
  version "0.2.1,4"
  sha256 "8f24a81f8cb1a9984df9971e254ee88c8741aecaa232cbe0076a8ab9e16527c3"

  url "https://github.com/niklas-heer/Keywink/releases/download/v#{version.csv.first}/Keywink-#{version.csv.first}-#{version.csv.second}.zip"
  name "Keywink"
  desc "Command launcher with memorable key sequences and an on-screen key guide"
  homepage "https://github.com/niklas-heer/Keywink"

  livecheck do
    url "https://github.com/niklas-heer/Keywink/releases/latest/download/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: :ventura

  app "Keywink.app"

  zap trash: [
    "~/Library/Application Support/Keywink",
    "~/Library/Caches/de.niklas-heer.Keywink",
    "~/Library/HTTPStorages/de.niklas-heer.Keywink",
    "~/Library/Preferences/de.niklas-heer.Keywink.plist",
  ]
end
