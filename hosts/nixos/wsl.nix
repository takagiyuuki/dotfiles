{ user, ... }:
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
}
