{...}: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "vita.console.9net.org" = {
         # todo: some kind of abomination
      };
    };
  };
}
