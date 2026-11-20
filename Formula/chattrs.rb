class Chattrs < Formula
  desc "Distributed client/server messaging for cross-agent coordination"
  homepage "https://github.com/bolu-atx/chattrs"
  version "0.6.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bolu-atx/chattrs/releases/download/v0.6.0/chattrs-aarch64-apple-darwin.tar.xz"
    sha256 "db093d7fc75dc6ad5547ca21cd9dedc22e0ded3799078eebca6cd9139f347770"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.6.0/chattrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f29535cb5ac28269f9264b9bcd157169f303060ba0acf33e6a926a26c30ffe31"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.6.0/chattrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "441357c02872be3d33d867052463ca2f2e1efa52947cda1eb1a46b9a83c0484a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "chattrs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "chattrs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "chattrs"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
