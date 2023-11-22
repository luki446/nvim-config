-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Dirty workaround to copy from WSL to windows clipboard
local clip_pathname = "/mnt/c/Windows/System32/clip.exe"

local function is_clip_executable()
    return vim.fn.executable(clip_pathname) == 1
end

if is_clip_executable() then
    vim.api.nvim_create_autocmd("TextYankPost", {
        pattern = "*",
        callback = function(event)
            local copied_string = table.concat(event.recontents, "\n")
            local win_yank = "/tmp/winyank"
            local tmp_file = io.open(win_yank, "w")

            if tmp_file then
                tmp_file:write(copied_string)

                tmp_file:close()
            end

            vim.fn.system(clip_pathname .. " < " .. win_yank)
        end,
        group = augroup("WSLYank"),
    })
end
