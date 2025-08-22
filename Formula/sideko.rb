class Sideko < Formula
  desc "CLI for Sideko"
  homepage "https://sideko.dev"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.6.1/sideko-aarch64-apple-darwin.tar.xz"
      sha256 "61a5250ac124ffb8826df5af4fbcf56ffb2648c3d73fb8e93f9b887961861e4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.6.1/sideko-x86_64-apple-darwin.tar.xz"
      sha256 "adab3a3eda6ecd638c3c702b4890b68c1e66188ac307b344ea7cd3aa44ae50ba"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Sideko-Inc/sideko/releases/download/v1.6.1/sideko-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4b031d291421e7e0887c9e40aaaafd27712dd4974dbfabed0952abd92ebdf5a4"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "sideko" if OS.mac? && Hardware::CPU.arm?
    bin.install "sideko" if OS.mac? && Hardware::CPU.intel?
    bin.install "sideko" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
