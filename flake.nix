{
  description = "Arrayofone's systems flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    hyprland.url = "github:hyprwm/Hyprland";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    catppuccin.url = "github:catppuccin/nix";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # darwin = {
    #   url = "github:lnl7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { 
    self, 
    nixpkgs,
    home-manager,
    hyprland,
    hypridle,
    hyprlock,
    hyprland-plugins,
    catppuccin,
    nixos-wsl,
    sops-nix,
    # darwin,
    ... 
  } @ inputs: let
    inherit (self) outputs;

    sharedModules = [
      home-manager.nixosModules.home-manager
      sops-nix.nixosModules.sops
      
      ./users
      ./modules/shared/fonts
      ./modules/shared/system
      ./modules/shared/home-manager
    ];

    baradurModules = sharedModules ++ [
      catppuccin.nixosModules.catppuccin
      ./modules/gui/desktop
      ./modules/gui/applications/firefox
    ];
    wslModules = sharedModules ++ [];

    # darwinModules = [
    #   home-manager.darwinModules.home-manager
    # ];
  in {
    # darwinConfigurations = {
    #   darwin = darwin.lib.darwinSystem {
    #     specialArgs = {inherit inputs outputs;};
    #     modules = darwinModules ++ [./hosts/darwin]; # todo: this
    #   };
    # };

    nixosConfigurations = {
      baradur = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = baradurModules ++ [./hosts/baradur];
      };
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = wslModules ++ [./hosts/wsl]; # todo: this
      };
    };
  };
}
