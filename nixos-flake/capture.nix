{ inputs, lib, config, ... }: {
  networking = {
    useDHCP = false;

    useNetworkd = true;
    # board specific should setup interfaces
    nameservers = [ "8.8.8.8" ];
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    22 # ssh
    80 # http
    443 # https
    1984 # temp: go2rtc
    8555 # webrtc
  ];

  networking.firewall.allowedUDPPorts = [
    67 # dhcp
    8555 # webrtc
    51914 # gimx
  ];

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  users.mutableUsers = false;
  users.users.root = {
    hashedPassword =
      "$y$j9T$J6Hn9P7o9KnSFHYX4HwY1/$ymgGRaP9WrddORmItFbchjRH7gOUcEXFrcO6BV7nei2";
  };
  users.users.stary = {
    uid = 1000;
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "video" "plugdev" "dialout" ];
    hashedPassword =
      "$y$j9T$yDLqPFbKg8FiwR5WUgZnj0$mClgbU5c3.4hflIFXRWnXGDNp3kv36/Z20npoC7U/x/";
  };

  system.configurationRevision = lib.mkIf (inputs.self ? rev) inputs.self.rev;
  system.stateVersion = "23.11";
}
