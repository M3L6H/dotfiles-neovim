# neovim

My personal neovim configuration put together using
[nixCats](https://nixcats.org)
with
[lazy](https://lazy.folke.io)
so that it is portable between Nix and non-Nix environments.

## Options

Available config options.

| Option                  | Purpose                                                     |
| ----------------------- | ----------------------------------------------------------- |
| `vim.g.border`          | Specify the border to use across floats                     |
| `vim.g.dashboard.image` | Specify the image to display on the dashboard               |
| `vim.g.dashboard.size`  | Size of the dashboard image to pass to chafa                |
| `vim.g.terminalwindow`  | Specify the tmux window vim should switch to when "closing" |


## Dependencies

Dependencies that are used by the various plugins in the configuration. On Nix, these are included
in the flake and will be installed automatically. On non-Nix systems, these will have to be
installed manually.

| Dependency   | Purpose                             |
| ------------ | ----------------------------------- |
| chafa        | Used for image in dashboard         |
| image-magick | Used for image in dashboard         |
| fzf          | Used in picker                      |
| ripgrep      | Used in picker                      |
| gh           | Used for GitHub issues in dashboard |

## Credits

In no particular order.

- [Mr. Jakob](https://www.youtube.com/@MrJakob)
- [nixCats](https://nixcats.org)
