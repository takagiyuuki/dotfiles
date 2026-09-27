{
  description = "Home Manager configuration of yuki";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-WSL module
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Starship prompt module for Git and Jujutsu
    jj-starship.url = "github:dmmulroy/jj-starship";

    # Terminal agent multiplexer
    herdr.url = "github:ogulcancelik/herdr";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-wsl,
      jj-starship,
      herdr,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      jj-starship-pkg = jj-starship.packages.${system}.default;
      herdr-pkg = herdr.packages.${system}.default;

      root = ./.;
      user = import ./data/user.nix;
    in
    {
      homeConfigurations.${user.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home
          ./modules/unfree.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit
            jj-starship-pkg
            herdr-pkg
            user
            root
            ;
        };
      };

      nixosConfigurations.wsl-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit user; };

        # Specify your NixOS-WSL configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/wsl-desktop/configuration.nix
          ./modules/unfree.nix
          {
            nixpkgs.hostPlatform = system;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit
                  jj-starship-pkg
                  herdr-pkg
                  user
                  root
                  ;
              };
              users.${user.username} = import ./home;
            };
          }
        ];
      };
    };
}
