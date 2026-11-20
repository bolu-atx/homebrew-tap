class Chattrs < Formula
  desc "Distributed client/server messaging for cross-agent coordination"
  homepage "https://github.com/bolu-atx/chattrs"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bolu-atx/chattrs/releases/download/v0.3.0/chattrs-aarch64-apple-darwin.tar.xz"
    sha256 "871284c82153ec2e027212062c1eea1109eba279cbb08838d035410eb37d0113"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.3.0/chattrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "692709ecfab44a0b122cc13a5371d0a8e39fed938fd0ff7a0b61d0f26a7567f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bolu-atx/chattrs/releases/download/v0.3.0/chattrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bfdb1e732069a20d12e7879d159f894c47cfb2ca98ff1e642313c008b05fcf88"
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
