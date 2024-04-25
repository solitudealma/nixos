{
  pkgs,
  config,
  username,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    # enableUpdateCheck = false;
    # enableExtensionUpdateCheck = false;
    # let vscode sync and update its configuration & extensions across devices, using github account.
    # userSettings = {
    #   #
    #   "window.titleBarStyle" = "custom";
    #   "window.menuBarVisibility" = "compact";
    #   "extensions.autoUpdate" = false;

    #   # 字体
    #   "editor.fontFamily" = "'Maple Mono SC NF', 'jetbrains mono', 'Droid Sans Mono', 'monospace', monospace";
    #   "editor.fontSize" = 18;
    #   "terminal.integrated.fontFamily" = "'Maple Mono SC NF', 'jetbrains mono', 'Droid Sans Mono', 'monospace', monospace";

    #   "editor.scrollbar.vertical" = "hidden";
    #   "editor.scrollbar.verticalScrollbarSize" = 0;
    #   "security.workspace.trust.untrustedFiles" = "newWindow";
    #   "security.workspace.trust.startupPrompt" = "never";
    #   "security.workspace.trust.enabled" = false;
    #   "editor.minimap.side" = "left";
    #   "terminal.external.linuxExec" = "kitty";
    #   "terminal.explorerKind" = "both";
    #   "terminal.sourceControlRepositoriesKind" = "both";
    #   "telemetry.telemetryLevel" = "off";
    #   "editor.indentSize" = "tabSize";
    #   "editor.tabSize" = 4;
    #   "workbench.colorTheme" = "Moegi Dark Vitesse";
    #   "workbench.iconTheme" = "material-icon-theme";
    #   "nix.enableLanguageServer" = true;
    #   "nix.serverPath" = "nil";
    #   "nix.serverSettings" = {
    #     # settings for 'nixd' LSP
    #     "nil" = {
    #       "nixpkgs" = {
    #         "expr" = "import (builtins.getFlake \"/home/SolitudeAlma/zaneyos\").inputs.nixpkgs {} ";
    #       };
    #       "formatting" = {
    #         "command" = ["alejandra"];
    #       };
    #       "options" = {
    #         "nixos" = {
    #           #(\"git+files://\" + toString ./.))
    #           "expr" = "(builtins.getFlake \"/home/SolitudeAlma/zaneyos\").nixosConfigurations.laptop.options";
    #         };
    #         "home-manager" = {
    #           "expr" = "(builtins.getFlake \"/home/SolitudeAlma/zaneyos\").homeConfigurations.\"SolitudeAlma@laptop\".options";
    #         };
    #       };
    #     };
    #   };
    # };
  };
}
