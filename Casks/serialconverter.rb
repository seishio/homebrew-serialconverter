cask "serialconverter" do
  version "0.2.12"
  sha256 arm:   "d3ead26c5f70264cf9e34e64de23c01972f33ad21566a0fee665ec8135e8d9ab",
         intel: "41e10489330f33f472481a83944373342b924e53714a4d38f2c9516212b21c54"

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
