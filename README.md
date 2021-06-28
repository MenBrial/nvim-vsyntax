# nvim-vsyntax

`nvim-vsyntax` displays the highlighting used by the syntax element under
the cursor as virtual text.

# Installation

The preferred method for installing `nvim-vsyntax` is through a plugin manager,
for example using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug `menbrial/nvim-vsyntax`
```

# Overview

`nvim-vsyntax` provides 3 commands with their associated `lua` functions:

- `VSyntaxToggle`: toggles the display of the highlighting virtual text.
- `VSyntaxEnable`: enables the display of the highlighting virtual text.
- `VSyntaxDisable`: disables the display of the highlighting virtual text.

The corresponding `lua` functions are:

```lua
require('nvim-vsyntax').toggle()
require('nvim-vsyntax').enable()
require('nvim-vsyntax').disable()
```

# Configuration

The display of the highlighting inside the virtual text can be configured using
the `setup()` function, as shown below. If the `setup()` function is not
called, the default settings will be used.

```lua
require('nvim-vsyntax').setup({
    -- Virtual text prefix
    prefix = ' $» ',
    -- Strings for representing highlighting attributes
    attributes = {
        bold = '',
        italic = '',
        reverse = '',
        standout = 'ꜱ',
        underline = '',
        undercurl = 'ṵ',
        strikethrough = '',
    },
    -- Mapping for the VSyntax toggle() function
    -- For example to use <leader>sy to toggle VSyntax virtual text in normal
    -- mode, use:
    -- toggle_mapping = '<leader>sy',
    toggle_mapping = nil,
    -- Highlight group for the virtual text
    highlight_group = 'Comment',
})
```
