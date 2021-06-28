local vim = vim
local vsyn = {}

-- VSyntax default options.
vsyn.options = {
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
    toggle_mapping = nil,
    -- Highlight group for the virtual text
    highlight_group = 'Comment',
}

-- Stores the enabled state of the VSyntax virtual text.
local enabled = false
-- VSyntax virtual text namespace.
local virtual_text_ns = vim.api.nvim_create_namespace('nvim-vsyntax')
-- VSyntax highlight group.
local virtual_text_hl = 'VSyntaxVirtualText'

-- Generates the description of the highlight group corresponding to the
-- given syntax ID.
-- Returns a string with the following structure:
-- `prefix` xxx `highlight name` → `link name`: `colors`, `attributes`
-- Any non relevant part is skipped.
local function _syntax_desc(synID)
    -- Generate the `xxx` and the highlight names.
    local descs = {}
    table.insert(descs, {vsyn.options.prefix or '', virtual_text_hl})
    local desc = nil
    local syn_name = vim.fn.synIDattr(synID, 'name')
    local id_trans = vim.fn.synIDtrans(synID)
    if id_trans == synID then
        if syn_name then
            desc = ' ' .. syn_name
        end
        table.insert(descs, {'xxx', syn_name})
    else
        local trans_name = vim.fn.synIDattr(id_trans, 'name')
        desc = ' ' .. syn_name .. ' → ' .. trans_name
        table.insert(descs, {'xxx', trans_name})
    end

    -- Generate the different color components.
    local colors = {'fg#', 'bg', 'sp'}
    local component_desc = {}
    for _, color in ipairs(colors) do
        local d = vim.fn.synIDattr(id_trans, color)
        if d ~= '' then
            table.insert(component_desc, color .. '=' .. d)
        end
    end

    -- Generate the list of attributes.
    local attr_desc = {}
    for k, v in pairs(vsyn.options.attributes or {}) do
        local d = vim.fn.synIDattr(id_trans, k)
        if d ~= '' then
            table.insert(attr_desc, v)
        end
    end
    attr_desc = table.concat(attr_desc, '')
    if #attr_desc > 0 then
        table.insert(component_desc, 'font=' .. attr_desc)
    end

    -- Combine all parts into a string.
    component_desc = table.concat(component_desc, ', ')
    if #component_desc > 0 then
        desc = desc .. ': ' .. component_desc
    end

    table.insert(descs, {desc, virtual_text_hl})
    return descs
end

-- Print the syntax information for the token under the cursor
-- Mainly for testing/debug purposes
-- vsyn.show_syntax = function()
--     local synID = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1)
--     local desc = _syntax_desc(synID)
--     print(desc)
-- end

-- Update the VSyntax virtual text
vsyn.update_virtual_text = function()
    vim.api.nvim_buf_clear_namespace(0, virtual_text_ns, 0, -1)

    local line = vim.fn.line('.')
    local synID = vim.fn.synID(line, vim.fn.col('.'), 1)
    local descs = _syntax_desc(synID)
    vim.api.nvim_buf_set_virtual_text(
    0, virtual_text_ns, line - 1, descs, {}
    )
end

-- Enable VSyntax virtual text display
vsyn.enable = function()
    enabled = true
    local highlight_group = vsyn.options.highlight_group or 'Comment'
    vim.cmd('highlight! link ' .. virtual_text_hl .. ' ' .. highlight_group)
    vim.cmd([[
    augroup VSyntax
    autocmd CursorHold,CursorHoldI * lua require('nvim-vsyntax').update_virtual_text()
    augroup END
    ]])
    vsyn.update_virtual_text()
end

-- Disable VSyntax virtual text display
vsyn.disable = function()
    enabled = false
    vim.cmd([[
    augroup VSyntax
    autocmd!
    augroup END
    ]])
    vim.api.nvim_buf_clear_namespace(0, virtual_text_ns, 0, -1)
end

-- Toggle VSyntax virtual text display
vsyn.toggle = function()
    if enabled then
        vsyn.disable()
    else
        vsyn.enable()
    end
end

-- Configure the VSyntax plugin
vsyn.setup = function(options)
    if options then
        vsyn.options = vim.tbl_deep_extend('force', vsyn.options, options)
    end

    if vsyn.options.toggle_mapping then
        vim.api.nvim_set_keymap(
        'n',
        vsyn.options.toggle_mapping,
        '<cmd>lua require("nvim-vsyntax").toggle()<CR>',
        {noremap = true, silent = true})
    end
end

return vsyn

-- vim:et:sw=4:
