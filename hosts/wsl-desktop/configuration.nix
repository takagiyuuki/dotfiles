{ pkgs, user, ... }:
{
  wsl = {
    enable = true;
    defaultUser = user.username;
    wslConf = {
      # Keep Windows PATH out: faster zsh startup, fewer name collisions
      interop.appendWindowsPath = false;
    };
    interop.includePath = false;
  };

  networking.hostName = "wsl-desktop";
  programs.nix-ld.enable = true; # FHS workaround
  programs.zsh.enable = true;
  users.users.${user.username}.shell = pkgs.zsh;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05"; # match installed NixOS-WSL release
}
