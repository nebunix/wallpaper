{
  config,
  lib,
  pkgs,
  systemInformation,
  ...
}:

let
  cfg = config.nebunix.wallpaper;
in
{
  options.nebunix.wallpaper = {
    path = lib.mkOption {
      type = with lib.types; path;
      description = "The path to the wallpaper.";
    };
  };

  config = {
    home-manager.users."${systemInformation.userName}" =
      { ... }:
      {
        home.packages = with pkgs; [ swww ];

        systemd.user = {
          startServices = "sd-switch";

          services = {
            swww-daemon = {
              Unit = {
                Description = "Start the swww daemon";
                After = [ "graphical-session.target" ];
              };

              Service = {
                Type = "simple";
                ExecStart = "${pkgs.swww}/bin/swww-daemon";
                ExecStartPost = "${pkgs.swww}/bin/swww restore";
              };

              Install = {
                WantedBy = [ "graphical-session.target" ];
              };
            };

            swww = {
              Unit = {
                Description = "Apply a wallpaper using swww";
                After = [ "graphical-session.target" ];
                Requires = [ "swww-daemon.service" ];
              };

              Service = {
                Type = "simple";
                ExecStart = "${pkgs.swww}/bin/swww img --transition-type wave ${cfg.path}";
              };

              Install = {
                WantedBy = [ "graphical-session.target" ];
              };
            };
          };
        };
      };
  };
}
