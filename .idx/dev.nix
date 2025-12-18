{ pkgs }: {
  channel = "stable-24.05";
  packages = [
    pkgs.jdk21
    pkgs.unzip
    pkgs.firebase-tools # For Firebase CLI

    # For Linux desktop builds
    pkgs.clang
    pkgs.cmake
    pkgs.ninja
    pkgs.pkg-config
    pkgs.gtk3
    pkgs.webkitgtk
  ];
  idx.extensions = [
    "Dart-Code.dart-code"
    "Dart-Code.flutter"
  ];
  idx.previews = {
    previews = {
      web = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "web-server"
          "--web-hostname"
          "0.0.0.0"
          "--web-port"
          "$PORT"
        ];
        manager = "flutter";
      };
      android = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "android"
          "-d"
          "localhost:5555"
        ];
        manager = "flutter";
      };
    };
  };
}
