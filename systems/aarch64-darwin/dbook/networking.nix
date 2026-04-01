{ ... }:
{
  networking = {
    computerName = "dbook";
    dns = [
      "1.1.1.1"
    ];
    hostName = "dbook";
    localHostName = "dbook";
    knownNetworkServices = [
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
  };
}
