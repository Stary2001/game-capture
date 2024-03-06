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
      #formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt;

      nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          (import ./hardware-configuration.nix)
          (import ./boot-configuration.nix)
          (import ./nginx.nix)

          inputs.common.nixosModules.base
          inputs.common.nixosModules.auto-upgrade
          inputs.common.nixosModules.wait-online-any

          ({ inputs, lib, config, ... }: {
            networking = {
              useDHCP = false;
              hostName = "vita"; # Define your hostname.

              useNetworkd = true;
              interfaces = { 
                "end0" = { useDHCP = true; };
                "enu1" = { useDHCP = true; };
              };

              nameservers = [ "8.8.8.8" ];
            };

            networking.firewall.enable = true;
            networking.firewall.allowedTCPPorts = [
              22 # ssh
              80 # http
              443 # https
            ];

            networking.firewall.allowedUDPPorts = [
              67 # dhcp
            ];

            services.openssh.enable = true;

            users.users.root = { hashedPassword = "$y$j9T$J6Hn9P7o9KnSFHYX4HwY1/$ymgGRaP9WrddORmItFbchjRH7gOUcEXFrcO6BV7nei2"; };
            users.users.stary = {
              isNormalUser = true;
              createHome = true;
              extraGroups = [ "wheel" ];
              hashedPassword = "$y$j9T$yDLqPFbKg8FiwR5WUgZnj0$mClgbU5c3.4hflIFXRWnXGDNp3kv36/Z20npoC7U/x/";
            };

            services.udev.extraRules = ''
              SUBSYSTEM=="net", ACTION=="add", DRIVRES=="r8152", NAME="eth-internal"
              SUBSYSTEM=="net", ACTION=="add", DRIVERS=="rk_gmac-dwmac", NAME="eth-external"
            '';

            system.configurationRevision =
              lib.mkIf (inputs.self ? rev) inputs.self.rev;
            system.stateVersion = "23.11";
          })
        ];
      };
    };
}
