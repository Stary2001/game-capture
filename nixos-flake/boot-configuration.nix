{ config, lib, pkgs, ... }: {
  # Serial console
  boot.kernelParams = [ "console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0" ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.consoleLogLevel = lib.mkDefault 7;
}
