{ ... }:
{
  networking = {
    computerName = "digibook";
    dns = [
      "8.8.8.8"
    ];
    hostName = "digibook";
    localHostName = "digibook";
    knownNetworkServices = [
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    wg-quick = {
      interfaces = { };
    };
  };
}
