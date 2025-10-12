cask "serialconverter" do
  version "0.2.12"
  sha256 arm:   "15ff171b4d0e30902f17117d9081337830e1fdaa7d6839c46b27269fe6aa22a4",
         intel: "6ea8c445411ede7e0c659d533f72c6f0123cb9504f110c3e54c1685017ddd8d5"

  url "https://github.com/seishio/homebrew-serialconverter/releases/download/v#{version}/SerialConverter-#{version}-macos-#{Hardware::CPU.arm? ? "arm64" : "intel"}.dmg"
  name "SerialConverter"
  desc "Serial Converter is a powerful tool that extracts serial numbers from PDF files and converts certificate serial numbers."
  homepage "https://github.com/seishio/SerialConverter"
  
  depends_on macos: ">= :catalina"
  
  conflicts_with cask: [
    "serialconverter-beta",
    "serialconverter-dev",
  ]

  livecheck do
    url "https://github.com/seishio/homebrew-serialconverter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  app "SerialConverter.app"

  # Remove quarantine attribute to avoid security warnings
  postflight do
    system_command "xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/SerialConverter.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.serialconverter.*",
    "~/Library/Application Support/SerialConverter",
    "~/Library/Caches/dev.serialconverter",
    "~/Library/Logs/SerialConverter",
    "~/Library/Saved Application State/dev.serialconverter.savedState",
  ]
end
