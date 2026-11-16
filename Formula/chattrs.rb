class Chattrs < Formula
  desc "Distributed client/server messaging for cross-agent coordination"
  homepage "https://github.com/bolu-atx/chattrs"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bolu-atx/chattrs/releases/download/v0.2.2/chattrs-aarch64-apple-darwin.tar.xz"
    sha256 "d1289f335bee3299122d48a6e69b3bd3e22f8e66e7898a4a78e0deb78b53e6c3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.2.2/chattrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "508840522a7f7c95d5c464112c5286d5c291a8cc8a415c814f2f3540cb0e9c7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.2.2/chattrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18022d0980ef8a4e61aa1c40de1a5b26d4a01a122f092b7079acacdd5681ab2f"
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
