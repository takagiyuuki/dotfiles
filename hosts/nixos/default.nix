{ pkgs, user, ... }:
{
  networking.hostName = "dev";
  programs.nix-ld.enable = true; # FHS workaround
  programs.zsh.enable = true;
  users.users.${user.username}.shell = pkgs.zsh;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05"; # match installed NixOS-WSL release
}
