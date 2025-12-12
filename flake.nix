{
  description = "m3l6h's custom neovim configuration packaged as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;

      namespace = "m3l6h";

      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      dependencyOverlays = [ ];

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
        {
          lspsAndRuntimeDeps = {
            dashboard = with pkgs; [
              chafa
              gh
              imagemagick
            ];
            dictionary = with pkgs; [
              codebook
            ];
            godot = with pkgs; [
              gdtoolkit_4
            ];
            # Dependencies for snacks image
            image = with pkgs; [
              ghostscript # Used to render pdf files
              imagemagick
              mermaid-cli # Used to render mermaid diagrams
              tectonic # Used to render LaTeX expressions
            ];
            image-paste = with pkgs; [
              wl-clipboard
            ];
            lua = with pkgs; [
              lua-language-server
              stylua
            ];
            markdown = with pkgs; [
              doctoc
              marksman
              (python313.withPackages (
                ps: with ps; [
                  mdformat
                  mdformat-wikilink
                ]
              ))
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
            rust = with pkgs; [
              cargo
              rust-analyzer
              rustfmt
            ];
            shell = with pkgs; [
              bash-language-server
              shellcheck
              shfmt
            ];
            web = with pkgs; [
              emmet-language-server
              prettierd
              stylelint
              typescript-language-server
              vscode-langservers-extracted
            ];
            yaml = with pkgs; [
              yamlfmt
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
              demicolon-nvim

              # demicolon has a hard requirement on treesitter
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
            ];
            dictionary = with pkgs.vimPlugins; [
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
            image-paste = with pkgs.vimPlugins; [
              img-clip-nvim
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
            minty = with pkgs.vimPlugins; [
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
              image-paste = false;
              picker = false;

              # Languages/toolchains
              godot = false;
              lua = false;
              markdown = false;
              nix = false;
              rust = false;
              shell = false;
              web = false;
              yaml = false;

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
        neovim =
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
              image-paste = true;
              picker = true;

              # Languages/toolchains
              godot = true;
              lua = true;
              markdown = true;
              nix = true;
              rust = true;
              shell = true;
              web = true;
              yaml = true;

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
            extra_pkg_params
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { stdenv.hostPlatform = { inherit system; }; };
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
          moduleNamespace = [
            namespace
            defaultPackageName
          ];
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
          moduleNamespace = [
            namespace
            defaultPackageName
          ];
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
