{
  description = "m3l6h's custom neovim configuration packaged as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    "plugins-demicolon" = {
      url = "github:mawkler/demicolon.nvim";
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

      extra_pkg_config = { };

      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];

      customOpts = {
        aliases = {
          enable = false;
        };
        colorscheme = "kanagawa";
        hostname = "nixos";
        username = "m3l6h";
        homeDirectory = "/home/${customOpts.username}";
      };

      categoryDefinitions =
        {
          pkgs,
          ...
        }:
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
          };

          startupPlugins = {
            general =
              with pkgs.vimPlugins;
              [
                lazy-nvim
                blink-cmp
                conform-nvim
                fastaction-nvim
                flash-nvim
                guess-indent-nvim
                lazydev-nvim
                mini-diff
                mini-icons
                mini-statusline
                mini-surround
                noice-nvim
                nui-nvim
                nvim-autopairs
                nvim-lspconfig
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                nvim-web-devicons
                oil-nvim
                smartcolumn-nvim
                smear-cursor-nvim
                snacks-nvim
                trouble-nvim
                undotree
                vim-tmux-navigator
                which-key-nvim
              ]
              ++ [
                pkgs.vimPlugins."${customOpts.colorscheme}-nvim"
              ]
              ++ [
                pkgs.neovimPlugins.demicolon
              ];
          };

          # Empty b/c we are using Lazy.nvim for lazy loading
          optionalPlugins = { };
        };

      packageDefinitions = {
        neovim =
          { pkgs, ... }:
          {
            settings = {
              colorscheme = customOpts.colorscheme;
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases =
                [
                  "nvim"
                ]
                ++ nixpkgs.lib.optionals (customOpts.aliases.enable) [
                  "v"
                  "vi"
                  "vim"
                ];
              hosts.python3.enable = true;
              hosts.node.enable = true;
              unwrappedCfgPath = "${customOpts.homeDirectory}/.local/state/nvim/lazy";
            };
            categories = {
              general = true;

              dashboard = true;
              lua = true;
              nix = true;
              picker = true;
            };
            extra = {
              nixdExtras.nixpkgs = ''import (builtins.getFlake "path:${builtins.toString inputs.self}").inputs.nixpkgs {}'';
              nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self}").nixosConfigurations.${customOpts.hostname}.options'';
              nixdExtras.home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self}").homeConfigurations.${customOpts.username}.options'';

              nixdExtras.nvim_lspconfig = "${pkgs.vimPlugins.nvim-lspconfig}";
              nixdExtras.sqlite3_path = "${pkgs.sqlite.out}/lib/libsqlite3.so";
            };
          };
      };
      defaultPackageName = "neovim";
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
            customOpts
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
            nixpkgs
            customOpts
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
            nixpkgs
            customOpts
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
            customOpts
            ;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
