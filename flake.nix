{
  description = "alternative, personal nixpkgs.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    # NOTE: remove when meson has advanced to 0.58.1 in master
    meson058.url = "github:jtojnar/nixpkgs/meson-0.58";
    rust-nightly.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-compat-ci.url = "github:hercules-ci/flake-compat-ci";

    ### Equivalent to multiple fetchFromGit[Hub/Lab] invocations
    # Themes
    abstractdark-sddm-theme-src = { url = "github:3ximus/abstractdark-sddm-theme"; flake = false; };

    # Programs
    alacritty-src = { url = "github:zenixls2/alacritty/ligature"; flake = false; };
    downloader-cli-src = { url = "github:deepjyoti30/downloader-cli"; flake = false; };
    ytmdl-src = { url = "github:deepjyoti30/ytmdl"; flake = false; };

    # Utilities
    eww.url = "github:elkowar/eww";

    # Wayland
    kile-wl-src = { url = "gitlab:snakedye/kile"; flake = false; };
    # river-src = { type = "git"; url = "https://github.com/ifreund/river.git"; submodules = true; flake = false; };
    sway-src = { url = "github:swaywm/sway"; flake = false; };
    wlroots-src = { url = "github:swaywm/wlroots"; flake = false; };
    xdpw-src = { url = "github:emersion/xdg-desktop-portal-wlr"; flake = false; };
  };

  outputs = args@{ self, flake-utils, nixpkgs, rust-nightly, meson058, ... }:
    {
      ciNix = args.flake-compat-ci.lib.recurseIntoFlake self;

      overlay = final: prev: {
        inherit (self.packages.${final.system})
          # Themes
          abstractdark-sddm-theme
          # Programs
          alacritty-ligatures
          pydes
          simber
          weechat-unwrapped-git
          youtube-search
          ytmdl
          # Utilities
          downloader-cli
          itunespy
          eww
          # X11
          awesome-git
          # Wayland
          kile-wl-git
          sway-unwrapped-git
          wlroots-git
          xdg-desktop-portal-wlr-git;
      };
    }
    // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          allowBroken = true;
          allowUnsupportedSystem = true;
          overlays = [ rust-nightly.overlay ];
        };

        version = "999-unstable";

        mesonPkgs = import meson058 { inherit system; };
      in
      {
        defaultPackage = self.packages.${system}.eww;

        packages = rec {

          alacritty-ligatures = with pkgs; (alacritty.overrideAttrs (old: rec {
            src = args.alacritty-src;

            postInstall = ''
              install -D extra/linux/Alacritty.desktop -t $out/share/applications/
              install -D extra/logo/compat/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg
              strip -S $out/bin/alacritty
              patchelf --set-rpath "${lib.makeLibraryPath old.buildInputs}:${stdenv.cc.cc.lib}/lib${lib.optionalString stdenv.is64bit "64"}" $out/bin/alacritty
              installShellCompletion --zsh extra/completions/_alacritty
              installShellCompletion --bash extra/completions/alacritty.bash
              installShellCompletion --fish extra/completions/alacritty.fish
              install -dm755 "$out/share/man/man1"
              gzip -c extra/alacritty.man > "$out/share/man/man1/alacritty.1.gz"
              install -Dm644 alacritty.yml $out/share/doc/alacritty.yml
              install -dm755 "$terminfo/share/terminfo/a/"
              tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
              mkdir -p $out/nix-support
              echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
            '';

            cargoDeps = old.cargoDeps.overrideAttrs (_: {
              inherit src;
              outputHash = "sha256-ttnwv8msnGMrC+s/RPK3oXe4u7rxa5m56iDfvCYnCio=";
            });
          }));

          discocss-canary = pkgs.callPackage ./pkgs/discocss-canary { };

          eww = args.eww.defaultPackage.${system};

          iosevka-pure-bin = pkgs.callPackage ./pkgs/iosevka-pure-bin { };

          sf-mono-bin = pkgs.callPackage ./pkgs/sf-mono-bin { };

          sf-mono-liga-bin = pkgs.callPackage ./pkgs/sf-mono-liga-bin { };

          kile-wl-git = pkgs.kile-wl.overrideAttrs (_: rec {
            inherit version;
            src = args.kile-wl-src;
          });

          sway-unwrapped-git = (pkgs.sway-unwrapped.overrideAttrs (_: {
            inherit version;
            src = args.sway-src;
          })).override {
            inherit (mesonPkgs) meson;
            wlroots = wlroots-git;
          };

          wlroots-git = (pkgs.wlroots.overrideAttrs (old: {
            inherit version;
            src = args.wlroots-src;

            buildInputs = (old.buildInputs or [ ]) ++ (with pkgs; [
              seatd
            ]);
          })).override {
            inherit (mesonPkgs) meson;
          };

          abstractdark-sddm-theme = pkgs.callPackage ./pkgs/abstractdark-sddm-theme {
            src = args.abstractdark-sddm-theme-src;
          };

          simber = pkgs.python3Packages.callPackage ./pkgs/simber { };

          pydes = pkgs.python3Packages.callPackage ./pkgs/pydes { };

          downloader-cli = pkgs.python3Packages.callPackage ./pkgs/downloader-cli {
            src = args.downloader-cli-src;
          };

          itunespy = pkgs.python3Packages.callPackage ./pkgs/itunespy { };

          xdg-desktop-portal-wlr-git = pkgs.xdg-desktop-portal-wlr.overrideAttrs (_: {
            inherit version;
            src = args.xdpw-src;
          });

          youtube-search = pkgs.python3Packages.callPackage ./pkgs/youtube-search { };

          ytmdl = pkgs.python3Packages.callPackage ./pkgs/ytmdl {
            inherit itunespy simber pydes downloader-cli youtube-search;
            src = args.ytmdl-src;
          };
        };
      }
    );
}
