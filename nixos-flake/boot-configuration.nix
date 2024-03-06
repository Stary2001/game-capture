{ config, lib, pkgs, ... }: {
  # Serial console
  boot.kernelParams = [ "console=ttyS2,1500000" "earlycon=uart8250,mmio32,0xff130000" ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.consoleLogLevel = lib.mkDefault 7;
}
