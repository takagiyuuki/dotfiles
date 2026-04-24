{
  description = "Home Manager configuration of yuki";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Starship prompt module for Git and Jujutsu
    jj-starship = {
      url = "github:dmmulroy/jj-starship";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      jj-starship,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      jj-starship-pkg = jj-starship.packages.${system}.default;
    in
    {
      homeConfigurations."yuki" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit jj-starship-pkg; };
      };
    };
}
