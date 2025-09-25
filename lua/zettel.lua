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
---@param opts any
local function create_zettel(opts)
    local input_name = ""
    if opts.args ~= "" then
        input_name = opts.args
    else
        input_name = vim.fn.input({prompt = "Enter filename: ", cancelreturn = "exit"})
    end

    if input_name == "exit" then
        return
    end

    local formatted_file_name = format_file_name(input_name)

    if file_exists(M.opts.create_location .. formatted_file_name) then
        print("\nFile exists, opening existing file")
    else
        print("\nFile created, opening")
    end

    vim.cmd("vsplit")
    --vim.cmd("^Wl")
    vim.cmd("e " .. M.opts.create_location .. formatted_file_name)
end


---@param opts any
function M.setup(opts)
    M.opts = opts or {}
    vim.api.nvim_create_user_command("Zettel", create_zettel, {nargs = '?'})
end


return M
