{
  description = "system configuration for game capture host";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    common.url = "github:stary2001/nix-common";
  };

  outputs = inputs:
    let system = "x86_64-linux";
    in {
      formatter.x86_64-linux =
        inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      formatter.aarch64-linux =
        inputs.nixpkgs.legacyPackages.aarch64-linux.nixfmt;

      nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          (import ./hardware-configuration.nix)
          (import ./nanopi-r2s.nix)
          (import ./nginx.nix)
          (import ./go2rtc.nix)
          (import ./capture.nix)

          inputs.common.nixosModules.base
          inputs.common.nixosModules.avahi
          inputs.common.nixosModules.wait-online-any
        ];
      };
    };
}
