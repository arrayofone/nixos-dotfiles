{ ... }:
{
  networking = {
    computerName = "mingabook";
    dns = [
      "1.1.1.1"
    ];
    hostName = "mingabook";
    localHostName = "mingabook";
    knownNetworkServices = [
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    wg-quick = {
      interfaces = { };
    };
  };
}
