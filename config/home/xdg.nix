{
  pkgs,
  config,
  username,
  lib,
  host,
  ...
}: {
  home.packages = with pkgs; [
    xdg-utils # provides cli tools such as `xdg-mime` `xdg-open`
    xdg-user-dirs
  ];
  xdg.configFile."mimeapps.list".force = true;
  xdg = {
    enable = true;

    cacheHome = "/home/${username}/.cache";
    configHome = "/home/${username}/.config";
    dataHome = "/home/${username}/.local/share";
    stateHome = "/home/${username}/.local/state";

    # manage $XDG_CONFIG_HOME/mimeapps.list
    # xdg search all desktop entries from $XDG_DATA_DIRS, check it by command:
    #  echo $XDG_DATA_DIRS
    # the system-level desktop entries can be list by command:
    #   ls -l /run/current-system/sw/share/applications/
    # the user-level desktop entries can be list by command(user ryan):
    #  ls /etc/profiles/per-user/ryan/share/applications/
    mimeApps = {
      enable = true;
      # let `xdg-open` to open the url with the correct application.
      defaultApplications = let
        browser = ["firefox.desktop"];
        editor = ["nvim.desktop" "code.desktop" "code-insiders.desktop"];
      in {
        "application/json" = browser;
        "application/pdf" = browser; # TODO: pdf viewer

        "text/html" = browser;
        "text/xml" = browser;
        "text/plain" = editor;
        "application/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/xhtml_xml" = browser;
        "application/rdf+xml" = browser;
        "application/rss+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-wine-extension-ini" = editor;

        # define default applications for some url schemes.
        "x-scheme-handler/about" = browser; # open `about:` url with `browser`
        "x-scheme-handler/ftp" = browser; # open `ftp:` url with `browser`
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        # https://github.com/microsoft/vscode/issues/146408
        "x-scheme-handler/vscode" = ["code-url-handler.desktop"]; # open `vscode://` url with `code-url-handler.desktop`
        "x-scheme-handler/vscode-insiders" = ["code-insiders-url-handler.desktop"]; # open `vscode-insiders://` url with `code-insiders-url-handler.desktop`
        # all other unknown schemes will be opened by this default application.
        # "x-scheme-handler/unknown" = editor;

        "x-scheme-handler/discord" = ["discord.desktop"];
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop "];

        "audio/*" = ["mpv.desktop"];
        "video/*" = ["mpv.dekstop"];
        "image/*" = ["imv.desktop"];
        "image/gif" = ["imv.desktop"];
        "image/jpeg" = ["imv.desktop"];
        "image/png" = ["imv.desktop"];
        "image/webp" = ["imv.desktop"];
      };

      associations.removed = {
        # ......
      };
    };
  };
}
