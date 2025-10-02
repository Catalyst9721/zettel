local M = {}
M.opts = {}


---@param file string
---@return boolean
local function file_exists(file)
    local f = io.open(file, "r")
    if f ~= nil then io.close(f) return true else return false end
end


---If given an empty string, returns filename with just the date.
---@param name string
---@return string
local function format_file_name(name)
    local formatted_file_name = ""
    local date = os.date("%Y%m%d%H%M", os.time())

    name = name:gsub(" ", "_"):gsub("[^A-za-z0-9-]", ""):lower()

    if name == "" then
        formatted_file_name = date .. ".md"
    else
        formatted_file_name = date .. "_" .. name .. ".md"
    end

    return formatted_file_name
end


---opts.args can be blank
---Creates and opens Zettel. If one already exists, it opens it.
---@param createLocation string
---@param opts any
local function create_zettel(createLocation, opts)
    local input_name = ""
    if opts.args ~= "" then
        input_name = opts.args
    else
        -- Is this the best way?
        input_name = vim.fn.input({prompt = "Enter filename: ", cancelreturn = "exit"})
        if input_name == "exit" then return end
    end

    local formatted_file_name = format_file_name(input_name)

    if file_exists(createLocation .. formatted_file_name) then
        print("\nFile exists, opening existing file")
    else
        print("\nFile created, opening")
    end

    vim.cmd("vsplit")
    --vim.cmd("^Wl")
    vim.cmd("e " .. createLocation .. formatted_file_name)
end


---@param opts zettel.setupOpts|nil
function M.setup(opts)
    local config = require("zettel.config")
    config.setup(opts)
    vim.api.nvim_create_user_command("Zettel",
        create_zettel,
        {args = config.createLocation, nargs = '?'}
    )
end


return M
