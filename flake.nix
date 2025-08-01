{
  description = "m3l6h's custom neovim configuration packaged as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nvzone-minty = {
      url = "github:nvzone/minty";
      flake = false;
    };

    nvzone-volt = {
      url = "github:nvzone/volt";
      flake = false;
    };

    yuckls = {
      url = "github:eugenenoble2005/yuckls";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
        (final: prev: {
          mdsf = prev.mdsf.override (old: {
            rustPlatform = old.rustPlatform // {
              buildRustPackage =
                args:
                old.rustPlatform.buildRustPackage (
                  args
                  // rec {

                    version = "0.10.4"; # Version in nixpkgs is very old
                    src = prev.fetchFromGitHub {
                      owner = "hougesen";
                      repo = "mdsf";
                      tag = "v${version}";
                      hash = "sha256-NH3DE6ef1HuS5ADVFros+iDQMZVVgG8V9OuFzzkig8g=";
                    };

                    cargoHash = "sha256-dGqFRXezzqOpHA74fnLUGQAI8KgbPmWIL46UP0wza40=";

                    doInstallCheck = false; # Tests are failing and --skip=tests is not working
                    doCheck = false; # Tests are failing and --skip=tests is not working
                  }
                );
            };
          });
        })
      ];

      extra_pkg_config = { };

      # Define extra opts
      extra_pkg_params = {
        aliases = {
          enable = false;
        };
        colorscheme = "kanagawa";
        hostname = "nixos";
        username = "m3l6h";
        homeDirectory = "/home/${extra_pkg_params.username}";
      };

      categoryDefinitions =
        {
          pkgs,
          ...
        }:
        let
          # TODO Figure out how to do this idiomatically
          blink-cmp-words =
            (pkgs.vimUtils.buildVimPlugin {
              pname = "blink-cmp-words";
              version = "2025-06-26";
              src = pkgs.fetchFromGitHub {
                owner = "archie-judd";
                repo = "blink-cmp-words";
                rev = "81224ec2eb72115c84bb19ae566ef25083dbfed2";
                hash = "sha256-y1rGiUXQWXkjr0XvWV7ZBEa7NsUqKGJ7wyDA8XPXwZQ=";
              };
              meta.homepage = "https://github.com/archie-judd/blink-cmp-words/";
            }).overrideAttrs
              {
                dependencies = with pkgs.vimPlugins; [
                  blink-cmp
                ];
              };
          demicolon =
            (pkgs.vimUtils.buildVimPlugin {
              pname = "demicolon.nvim";
              version = "2025-04-25";
              src = pkgs.fetchFromGitHub {
                owner = "mawkler";
                repo = "demicolon.nvim";
                rev = "8d79e527dbbef9de06405a30258b8d752c0638c4";
                hash = "sha256-UTzA9xX14zS6FV4g4HNWjyYyFPGE/Rc9dADa2+JFltU=";
              };
              meta.homepage = "https://github.com/mawkler/demicolon.nvim/";
            }).overrideAttrs
              {
                nvimSkipModules = [
                  "demicolon.repeat_jump"
                ];
              };
          # These are in nixpkgs but the pname is wrong, so they are not correctly found by lazy
          nvzone-minty =
            (pkgs.vimUtils.buildVimPlugin {
              pname = "minty";
              version = "";
              src = inputs.nvzone-minty;
              meta.homepage = "https://github.com/nvzone/minty";
            }).overrideAttrs
              {
                nvimSkipModules = [
                  "minty.huefy.api"
                  "minty.huefy.init"
                  "minty.huefy.layout"
                  "minty.huefy.state"
                  "minty.huefy.ui"
                  "minty.shades.init"
                  "minty.shades.layout"
                  "minty.shades.ui"
                  "minty.utils"
                ];
              };
          nvzone-volt = pkgs.vimUtils.buildVimPlugin {
            pname = "volt";
            version = "";
            src = inputs.nvzone-volt;
            meta.homepage = "https://github.com/nvzone/volt";
          };
          yuckls =
            with pkgs.dotnetCorePackages;
            pkgs.buildDotnetModule {
              pname = "yuckls";
              version = "";

              src = inputs.yuckls;
              projectFile = "YuckLS/YuckLS.csproj";
              dotnet-sdk = sdk_9_0;
              dotnet-runtime = runtime_9_0;
              nugetDeps = ./deps/yuckls.json;
            };
        in
        {
          lspsAndRuntimeDeps = {
            css = with pkgs; [
              jsbeautifier
              stylelint
              vscode-langservers-extracted
            ];
            dashboard = with pkgs; [
              chafa
              gh
              imagemagick
            ];
            # Dependencies for snacks image
            image = with pkgs; [
              ghostscript # Used to render pdf files
              imagemagick
              mermaid-cli # Used to render mermaid diagrams
              tectonic # Used to render LaTeX expressions
            ];
            lua = with pkgs; [
              lua-language-server
              stylua
            ];
            markdown = with pkgs; [
              marksman
              mdformat
              mdsf
            ];
            nix = with pkgs; [
              nixd
              nixfmt-rfc-style
            ];
            picker = with pkgs; [
              fzf
              ripgrep
            ];
            shell = with pkgs; [
              bash-language-server
              shellcheck
              shfmt
            ];
            yuck = [
              yuckls
            ];
          };

          startupPlugins = {
            general =
              with pkgs.vimPlugins;
              [
                lazy-nvim
              ]
              ++ [
                pkgs.vimPlugins."${extra_pkg_params.colorscheme}-nvim"
              ];
            autopairs = with pkgs.vimPlugins; [
              nvim-autopairs
            ];
            blink-cmp = with pkgs.vimPlugins; [
              blink-cmp

              # depends on mini icons for icons in completion
              mini-icons
            ];
            bullets = with pkgs.vimPlugins; [
              bullets-vim
            ];
            conform = with pkgs.vimPlugins; [
              conform-nvim
            ];
            colorizer = with pkgs.vimPlugins; [
              nvim-colorizer-lua
            ];
            demicolon = with pkgs.vimPlugins; [
              demicolon

              # demicolon has a hard requirement on treesitter
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
            ];
            dictionary = [
              blink-cmp-words
            ];
            fastaction = with pkgs.vimPlugins; [
              fastaction-nvim
            ];
            flash = with pkgs.vimPlugins; [
              flash-nvim
            ];
            guess-indent = with pkgs.vimPlugins; [
              guess-indent-nvim
            ];
            lazydev = with pkgs.vimPlugins; [
              lazydev-nvim
            ];
            lspconfig = with pkgs.vimPlugins; [
              nvim-lspconfig
            ];
            mini-diff = with pkgs.vimPlugins; [
              mini-diff
            ];
            mini-statusline = with pkgs.vimPlugins; [
              mini-statusline
            ];
            mini-surround = with pkgs.vimPlugins; [
              mini-surround
            ];
            minty = [
              nvzone-minty

              # depends on volt for its UI
              nvzone-volt
            ];
            multicursor = with pkgs.vimPlugins; [
              multicursor-nvim
            ];
            noice = with pkgs.vimPlugins; [
              noice-nvim
              nui-nvim
            ];
            oil = with pkgs.vimPlugins; [
              oil-nvim

              # depends on mini icons for icons in file tree
              mini-icons
            ];
            render-markdown = with pkgs.vimPlugins; [
              render-markdown-nvim
            ];
            smartcolumn = with pkgs.vimPlugins; [
              smartcolumn-nvim
            ];
            smear-cursor = with pkgs.vimPlugins; [
              smear-cursor-nvim
            ];
            snacks = with pkgs.vimPlugins; [
              snacks-nvim
            ];
            surround = with pkgs.vimPlugins; [
              nvim-surround
            ];
            tiny-inline-diagnostic = with pkgs.vimPlugins; [
              tiny-inline-diagnostic-nvim
            ];
            treesitter = with pkgs.vimPlugins; [
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
            ];
            trouble = with pkgs.vimPlugins; [
              trouble-nvim

              # trouble uses web icons for its UI
              nvim-web-devicons
            ];
            undotree = with pkgs.vimPlugins; [
              undotree
            ];
            vim-tmux-navigator = with pkgs.vimPlugins; [
              vim-tmux-navigator
            ];
            which-key = with pkgs.vimPlugins; [
              which-key-nvim
            ];
          };

          # Empty b/c we are using Lazy.nvim for lazy loading
          optionalPlugins = { };
        };

      packageDefinitions = {
        minimal =
          { ... }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [
                "nvim"
              ];
              hosts.python3.enable = true;
              hosts.node.enable = true;
              unwrappedCfgPath = "${extra_pkg_params.homeDirectory}/.local/state/nvim/lazy";
            };
            categories = {
              general = true;

              # Functionality
              dashboard = false;
              image = false;
              picker = false;

              # Languages/toolchains
              css = false;
              lua = false;
              markdown = false;
              nix = false;
              shell = false;
              yuck = false;

              # Plugins
              autopairs = false;
              blink-cmp = false;
              bullets = false;
              conform = false;
              colorizer = false;
              demicolon = false;
              dictionary = false;
              fastaction = false;
              flash = false;
              guess-indent = false;
              lazydev = false;
              lspconfig = false;
              mini-diff = false;
              mini-statusline = false;
              mini-surround = false;
              minty = false;
              multicursor = false;
              noice = false;
              oil = false;
              render-markdown = false;
              smartcolumn = false;
              smear-cursor = false;
              snacks = false;
              tiny-inline-diagnostic = false;
              treesitter = false;
              trouble = false;
              undotree = false;
              vim-tmux-navigator = false;
              which-key = false;
            };
            extra = { };
          };
        m3l6h-neovim =
          { pkgs, ... }:
          {
            settings = {
              colorscheme = extra_pkg_params.colorscheme;
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [
                "nvim"
              ]
              ++ nixpkgs.lib.optionals (extra_pkg_params.aliases.enable) [
                "v"
                "vi"
                "vim"
              ];
              hosts.python3.enable = true;
              hosts.node.enable = true;
              unwrappedCfgPath = "${extra_pkg_params.homeDirectory}/.local/state/nvim/lazy";
            };
            categories = {
              general = true;

              # Functionality
              dashboard = true;
              image = true;
              picker = true;

              # Languages/toolchains
              css = true;
              lua = true;
              markdown = true;
              nix = true;
              shell = true;
              yuck = true;

              # Plugins
              autopairs = true;
              blink-cmp = true;
              bullets = true;
              conform = true;
              colorizer = true;
              demicolon = true;
              dictionary = true;
              fastaction = true;
              flash = true;
              guess-indent = true;
              lazydev = true;
              lspconfig = true;
              mini-diff = true;
              mini-statusline = true;
              mini-surround = false;
              minty = true;
              multicursor = true;
              noice = false;
              oil = true;
              render-markdown = true;
              smartcolumn = true;
              smear-cursor = true;
              snacks = true;
              surround = true;
              tiny-inline-diagnostic = true;
              treesitter = true;
              trouble = true;
              undotree = true;
              vim-tmux-navigator = true;
              which-key = true;
            };
            extra = {
              nixdExtras.nixpkgs = ''import (builtins.getFlake "path:${builtins.toString inputs.self}").inputs.nixpkgs {}'';
              nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self}").nixosConfigurations.${extra_pkg_params.hostname}.options'';
              nixdExtras.home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self}").homeConfigurations.${extra_pkg_params.username}.options'';

              nixdExtras.nvim_lspconfig = "${pkgs.vimPlugins.nvim-lspconfig}";
              nixdExtras.sqlite3_path = "${pkgs.sqlite.out}/lib/libsqlite3.so";
            };
          };
      };
      defaultPackageName = "m3l6h-neovim";
    in

    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            extra_pkg_params
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = '''';
          };
        };
      }
    )
    // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            extra_pkg_params
            nixpkgs
            ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            extra_pkg_params
            nixpkgs
            ;
        };
      in
      {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit
            nixpkgs
            dependencyOverlays
            extra_pkg_config
            extra_pkg_params
            ;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
