{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    cargo2nix.url = "github:cargo2nix/cargo2nix";
    rust-overlay.follows = "cargo2nix/rust-overlay";
  };
  outputs = { self, nixpkgs, flake-utils, cargo2nix, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            cargo2nix.overlays.default
            rust-overlay.overlays.default
          ];
        };

        rustVersion = "1.75.0";

      in {
        devShell =
          pkgs.mkShell {
            buildInputs = [
              (pkgs.rust-bin.stable.${rustVersion}.default.override {
                extensions = [
                  "cargo"
                  "clippy"
                  "rustc"
                  "rust-src"
                  "rustfmt"
                  "rust-analyzer"
                ];
              })
              cargo2nix.packages.${system}.default
            ];
          };

        packages = rec {
          columnize =
            let
              rustPkgs = pkgs.rustBuilder.makePackageSet {
                inherit rustVersion;
                packageFun = import ./Cargo.nix;
              };
            in
              rustPkgs.workspace.columnize {};
          default = columnize;
        };
      }
    );
}
