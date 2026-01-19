# foldsigns.nvim

Adds foldmarkers as signs.

<img width="675" height="477" alt="screenshot" src="https://github.com/user-attachments/assets/948bc0f3-fca0-4a39-b9f6-073f3222e277" />

## Installation

With `lazy.nvim`:

```lua
{
  "netmute/foldsigns.nvim"
}
```

## Usage

foldsigns is designed to be plug and play. Once installed with `lazy.nvim`, it usually just works.

## Defaults

The plugin changes some neovim opts, so it looks the best. These are:

```lua
foldlevelstart = 99
foldlevel = 99
foldnestmax = 1
foldtext = ""
fillchars = {
  fold = " ",
  foldopen = "",
  foldclose = "",
}
```

It only does so if you haven't changed the defaults. It will never override your settings.

## Troubleshooting

If something doesn't work, or doesn't look right, it's usually because your config interferes.

Run `:checkhealth foldsigns`, it tells you what's causing the issue.
