cask "serialconverter" do
  arch arm: "arm64", intel: "intel"

  version "0.2.18"
  sha256 arm:   "df41eda5f3c25e3e5e218f5a0fff1742f01d2bd3c58fe1b6353541453f0813c5",
         intel: "b5299dcbd43d358c76074decace01dacb7a1af7127c301ea6d3812577223b156"

  url "https://github.com/seishio/homebrew-serialconverter/releases/download/v#{version}/SerialConverter-#{version}-macos-#{arch}.dmg"
  name "SerialConverter"
  desc "Extracts serial numbers from PDF files and converts certificate serial numbers"
  homepage "https://github.com/seishio/SerialConverter"

  livecheck do
    url "https://github.com/seishio/homebrew-serialconverter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  conflicts_with cask: [
    "serialconverter-beta",
    "serialconverter-dev",
  ]
  depends_on macos: :catalina

  app "SerialConverter.app"

  # Remove quarantine attribute to avoid security warnings
  postflight do
    system_command "xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/SerialConverter.app"]
  end

  zap trash: [
    "~/Library/Application Support/SerialConverter",
    "~/Library/Caches/dev.serialconverter",
    "~/Library/Logs/SerialConverter",
    "~/Library/Preferences/com.serialconverter.*",
    "~/Library/Saved Application State/dev.serialconverter.savedState",
  ]
end
