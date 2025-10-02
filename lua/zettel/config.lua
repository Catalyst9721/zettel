local M = {}

---@class zettel.setupOpts
---@field createLocation string Where zettels are created or accessed



---@param opts zettel.setupOpts|nil
M.setup = function(opts)
    opts = opts or {}

    for k, v in pairs(opts) do
        M[k] = v
    end
end




return M
