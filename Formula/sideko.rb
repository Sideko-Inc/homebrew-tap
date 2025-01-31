class Sideko < Formula
  desc "CLI for Sideko"
  homepage "https://sideko.dev"
  version "1.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.0.5/sideko-aarch64-apple-darwin.tar.xz"
      sha256 "00c1b6fdef74948f41b384de8b4d0a8bee97b18a150d7cc23502c4b3793fbdce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Sideko-Inc/sideko/releases/download/v1.0.5/sideko-x86_64-apple-darwin.tar.xz"
      sha256 "e5edfc2369e6253ce8247c6d33b5f6ee7cab3dfe294df33b5f115f7751c1f4af"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Sideko-Inc/sideko/releases/download/v1.0.5/sideko-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d7fa08ce9da9b8461fe7a695651828a1fb8af235863335a781e3e602b55e0461"
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
