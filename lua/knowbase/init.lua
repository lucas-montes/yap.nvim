local M = {}

DEFAULT_CONFIG = {
    port = 5483,
    folder = os.getenv("HOME") .. "Knowbase",
    pattern = { ".md" },
    update = { auto = "exit" },
    link = { auto = "exit", based_on = { "h1", "dir", "file" } }
}

local _config = {}

M.setup = function(opts)
    _set_up_config(opts)
    _apply_config()
end

function _set_up_config(opts)
    for key, value in pairs(DEFAULT_CONFIG) do
        local otps_value = opts[key]
        if otps_value == nil then
            _config[key] = value
        else
            _config[key] = otps_value
        end
    end
end

function _apply_config()
    return
end

function _get_autocmd(action)
    if _config[action] == "save" then
        return "BufWritePost"
    else
        return "VimLeavePre"
    end
end

function _run_autocmd(autocmd)
    vim.api.nvim_create_autocmd(autocmd, {
        group = vim.api.nvim_create_augroup("knowbase", { clear = true }),
        pattern = _config.pattern,
        callback = function() _call_core(_, data, "") end
    })
end

M.call_server = function(args)
    _call_core("", "", args.args)
end

function _call_core(_, data, extra_args)
    local exec = "/home/lucas/Projects/knowbase/knowbase-core/debug/release/knowbase"
    vim.fn.jobstart({ exec, extra_args, "add" },
        {
            stdout_buffered = true,
            on_stdout = _handle_out,
            on_stderr = _handle_error,
        })
end

function _handle_out(_, data, name)
    -- local buffnum = 10
    -- vim.api.nvim_buf_set_lines(buffnum, 0, 0, false, { data })
    return
end

function _handle_error(channel_id, data, name)
    return
end

M.add_to_base = function()
    local current_file = vim.fn.expand('%:p')
    if current_file == nil then
        _add_dir()
    else
        _add_file(current_file)
    end
end

function _add_dir()
    local cwd = vim.fn.getcwd()
    print(cwd)
    print("_add_dir")
end

function _add_file(file)
    print(file)
    _call_core(_, _, file)
end

vim.api.nvim_create_user_command("AddToBase", M.add_to_base, { bang = true })
vim.api.nvim_create_user_command("RunKb", M.call_server, { bang = true, nargs = "+" })
vim.keymap.set("n", "<leader>atb", "", { callback = M.add_to_base })


return M
