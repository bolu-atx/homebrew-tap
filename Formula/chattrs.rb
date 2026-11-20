class Chattrs < Formula
  desc "Distributed client/server messaging for cross-agent coordination"
  homepage "https://github.com/bolu-atx/chattrs"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bolu-atx/chattrs/releases/download/v0.8.0/chattrs-aarch64-apple-darwin.tar.xz"
    sha256 "0b1a8345125dbb1ee068a0a6aa1a9391b7fdfda779ea4cbc0ed404cce779cf94"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.8.0/chattrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f7667e93ee496637fe96d30e1690a66f2f28b751590e844bde0bc0d56c11a16f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.8.0/chattrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f15c89f45b8534c31e4980149951c93cb5e860acdad4b07838b6bf4b68d881ef"
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
