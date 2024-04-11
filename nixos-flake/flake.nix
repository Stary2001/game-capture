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
          ({...}: {
            networking.hostName = "vita";
            networking.interfaces.end0.macAddress = "de:47:97:c1:4d:bc";
            networking.interfaces.enu1.macAddress = "de:47:97:c1:4d:bd"; 
            services.go2rtc.settings.streams.vita = "ffmpeg:device?video=/dev/v4l/by-id/usb-MACROSILICON_USB_Video-video-index0&resolution=1920x1080&input_format=mjpeg#video=copy";
          })
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
          ({...}: {
            networking.hostName = "wii";
            networking.interfaces.end0.macAddress = "c2:de:b4:2a:cc:2a";
            networking.interfaces.enu1.macAddress = "c2:de:b4:2a:cc:2b"; 
            services.go2rtc.settings.streams.wii = "ffmpeg:device?video=/dev/v4l/by-id/usb-MACROSILICON_USB_Video-video-index0&resolution=1920x1080&input_format=mjpeg#video=copy";
          })
        ];
      };

      nixosConfigurations.wiiu = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          (import ./beelink.nix)
          (import ./nginx.nix)
          (import ./go2rtc.nix)
          (import ./capture.nix)

          inputs.common.nixosModules.base
          inputs.common.nixosModules.avahi
          inputs.common.nixosModules.wait-online-any
          ({...}: {
            networking.hostName = "wiiu";
            services.go2rtc.settings.streams.wiiu = "ffmpeg:device?video= /dev/v4l/by-id/usb-VXIS_Inc_FHD_Capture-video-index0&input_format=yuyv422&video_size=1920x1080#video=h264#hardware=vaapi";
          })
        ];
      };
    };
}
