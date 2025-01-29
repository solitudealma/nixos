{
  config,
  isWorkstation,
  lib,
  pkgs,
  username,
  ...
}: let
  installFor = ["solitudealma"];
  hasNvidiaGPU = lib.elem "nvidia" config.services.xserver.videoDrivers;
in
  lib.mkIf (lib.elem "${username}" installFor) {
    # Useful other development tools
    environment.systemPackages = with pkgs;
      [
        act
        distrobox
        dive
        fuse-overlayfs
        podman-compose
        podman-tui
      ]
      ++ lib.optionals isWorkstation [
        podman-desktop
      ];

    hardware.nvidia-container-toolkit.enable = hasNvidiaGPU;

    virtualisation = {
      containers.enable = true;
      # Run Podman containers as systemd services
      oci-containers = {
        backend = "podman";
        containers = {
          container-name = {
            image = "container-image";
            autoStart = true;
            ports = ["127.0.0.1:1234:1234"];
          };
        };
      };
      podman = {
        defaultNetwork.settings = {
          dns_enabled = true;
        };
        dockerCompat = true;
        dockerSocket.enable = true;
        enable = true;
      };
      containers.registries.search = [
        "docker.io"
        "gcr.io"
        "quay.io"
      ];
      containers.storage.settings = {
        storage = {
          driver = "overlay";
          graphroot = "/var/lib/containers/storage";
          runroot = "/run/containers/storage";
        };
      };
    };

    users.users.${username}.extraGroups = lib.optional config.virtualisation.podman.enable "podman";
  }
