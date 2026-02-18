{
  description = "Flake providing a development shell for the workshop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
        url = "github:oxalica/rust-overlay";
        inputs = {
            nixpkgs.follows = "nixpkgs";
        };
    };
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustToolchain = with pkgs; rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        wr = pkgs.rustPlatform.buildRustPackage {
          pname = "workshop-runner";
          version = "0.2.5";
          src = pkgs.fetchCrate {
            pname = "workshop-runner";
            version = "0.2.5";
            hash = "sha256-OCLDGVctfJoMQ1LwZmGrOOPLnNB+FBhWJ909+DpqL5Q=";
          };
          cargoHash = "sha256-/Oj4B2W+fprOML1KdiU8fHkeGj1JXq8o0GlKxa46/64=";
        };
      in
      {
        devShells.default = with pkgs; mkShell rec {
          name = "k23-dev";
          buildInputs = [
            # compilers
            rustToolchain

            # inspecting wasm
            wasm-tools
            binaryen
            wizer

            # wasm components
            cargo-component

            fermyon-spin

            # workshop runner
            wr

            # devtools
            mdbook
            jujutsu
            typos
            dprint
          ];
        };
      }
    );
}
