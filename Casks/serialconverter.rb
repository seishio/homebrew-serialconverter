cask "serialconverter" do
  version "0.2.16"
  sha256 arm:   "bd7d4a046493f7010bed9d05a5062c0daa06aff3b47f898b45be6cc77d09b53c",
         intel: "0b5010a04b0c25804eef0cef13100ebf1cc5ec174f51e29a511e1511e2431290"

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
