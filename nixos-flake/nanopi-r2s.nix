{ inputs, lib, config, ... }: {
  # Serial console
  boot.kernelParams =
    [ "console=ttyS2,1500000" "earlycon=uart8250,mmio32,0xff130000" ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.consoleLogLevel = lib.mkDefault 7;

  networking = {
    interfaces = {
      "end0" = { useDHCP = true; };
      "enu1" = { useDHCP = true; };
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", DRIVERS=="r8152", NAME="eth-internal"
    SUBSYSTEM=="net", ACTION=="add", DRIVERS=="rk_gmac-dwmac", NAME="eth-external"
  '';

  hardware.deviceTree.overlays = [{
    name = "enable-uart1";
    dtsFile = ./enable-uart1.dts;
  }];

  # originally from hardware-configuration.nix
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
