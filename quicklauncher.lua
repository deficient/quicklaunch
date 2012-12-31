
local util = require("awful.util")
local wbutton = require("awful.widget.button")
local button = require("awful.button")
local tooltip = require("awful.tooltip")

-- quicklauncher
local quicklauncher = { mt = {} }

--- Create a button widget which will launch a command.
-- @param args Standard widget table arguments, plus image for the image path
-- and command for the command to run on click, or either menu to create menu.
-- @return A launcher widget.
function quicklauncher.new(args)
    if not args.command and not args.action and not args.menu then return end
    local w = wbutton(args)
    if not w then return end

    local b = w:buttons()
    if args.command then
        b = util.table.join(b, button({}, 1, nil, function () util.spawn(args.command) end))
    elseif args.action then
        b = util.table.join(b, button({}, 1, nil, args.action))
    elseif args.menu then
        b = util.table.join(b, button({}, 1, nil, function () args.menu:toggle() end))
    end

    if args.menu then
        b = util.table.join(b, button({}, 3, nil, function () args.menu:toggle() end))
    end

    if args.tooltip then
        tooltip({ objects = { w } }):set_text(args.tooltip)
    end

    w:buttons(b)
    return w
end

function quicklauncher.mt:__call(...)
    return quicklauncher.new(...)
end

return setmetatable(quicklauncher, quicklauncher.mt)
