{
  description = "m3l6h's custom neovim configuration packaged as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

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
            dashboard = with pkgs; [
              chafa
              gh
              imagemagick
            ];
            lua = with pkgs; [
              lua-language-server
              stylua
            ];
            nix = with pkgs; [
              nixd
              nixfmt-rfc-style
            ];
            picker = with pkgs; [
              fzf
              ripgrep
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
            conform = with pkgs.vimPlugins; [
              conform-nvim
            ];
            demicolon = with pkgs.vimPlugins; [
              demicolon

              # demicolon has a hard requirement on treesitter
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
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
            noice = with pkgs.vimPlugins; [
              noice-nvim
              nui-nvim
            ];
            oil = with pkgs.vimPlugins; [
              oil-nvim

              # depends on mini icons for icons in file tree
              mini-icons
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

              dashboard = false;
              lua = false;
              nix = false;
              picker = false;

              autopairs = false;
              blink-cmp = false;
              conform = false;
              demicolon = false;
              fastaction = false;
              flash = false;
              guess-indent = false;
              lazydev = false;
              lspconfig = false;
              mini-diff = false;
              mini-statusline = false;
              mini-surround = false;
              noice = false;
              oil = false;
              smartcolumn = false;
              smear-cursor = false;
              snacks = false;
              treesitter = false;
              trouble = false;
              undotree = false;
              vim-tmux-navigator = false;
              which-key = false;
              yuck = false;
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
              aliases =
                [
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

              dashboard = true;
              lua = true;
              nix = true;
              picker = true;

              autopairs = true;
              blink-cmp = true;
              conform = true;
              demicolon = true;
              fastaction = true;
              flash = true;
              guess-indent = true;
              lazydev = true;
              lspconfig = true;
              mini-diff = true;
              mini-statusline = true;
              mini-surround = false;
              noice = true;
              oil = true;
              smartcolumn = true;
              smear-cursor = true;
              snacks = true;
              surround = true;
              treesitter = true;
              trouble = true;
              undotree = true;
              vim-tmux-navigator = true;
              which-key = true;
              yuck = true;
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
