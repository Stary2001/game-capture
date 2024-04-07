{
  description = "system configuration for game capture host";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    common.url = "github:stary2001/nix-common";
  };

  outputs = inputs:
    {
      formatter.x86_64-linux =
        inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      formatter.aarch64-linux =
        inputs.nixpkgs.legacyPackages.aarch64-linux.nixfmt;

      nixosConfigurations.vita = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
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
          ({...}: { networking.hostName = "vita"; networking.interfaces.end0.macAddress = "de:47:97:c1:4d:bc"; networking.interfaces.enu1.macAddress = "de:47:97:c1:4d:bd"; })
        ];
      };
      nixosConfigurations.wii = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
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
          ({...}: { networking.hostName = "wii"; networking.interfaces.end0.macAddress = "c2:de:b4:2a:cc:2a"; networking.interfaces.enu1.macAddress = "c2:de:b4:2a:cc:2b"; })
        ];
      };
    };
}
