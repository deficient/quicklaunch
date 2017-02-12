
local awful = require("awful")
local wibox = require("wibox")
local util = require("awful.util")
local wbutton = require("awful.widget.button")
local button = require("awful.button")
local tooltip = require("awful.tooltip")
local str = require("terribad.util.str")
local misc = require("terribad.util.misc")

local tjoin = util.table.join
local ft = require("terribad.util.functools")
local clstools = require("terribad.util.clstools")
local bindN = ft.bindN

-- quicklauncher
local M = clstools.class({})

--- Create a button widget which will launch a command.
-- @param args Standard widget table arguments, plus image for the image path
-- and command for the command to run on click, or either menu to create menu.
-- @return A launcher widget.
function M.new(args)
    args = misc.kwd_from_pos_args(args, {
        'tooltip', 'action', 'image', 'menu' })
    args.image = M.find_icon(args.image)

    if not args.action and not args.menu then return end
    local w = wbutton(args)
    if not w then return end

    local b = w:buttons()

    if args.menu then
        -- TODO: switch cases: menu/table
        local menu_items = {}
        for k, v in pairs(args.menu) do
            menu_items[k] = {v[1], misc.menu_callback(v[2])}
        end
        local menu = awful.menu({ items=menu_items })
        local menu_toggle = function() menu:toggle() end
        b = tjoin(b, button({}, 3, nil, menu_toggle))
    end

    local action = args.action
    if action then
        if type(action) == "string" then
            b = tjoin(b, button({}, 1, nil, bindN(util.spawn, action)))
        elseif type(action) == "table" then
            -- TODO: real spawn
            b = tjoin(b, button({}, 1, nil, bindN(util.spawn, action)))
        elseif type(action) == "function" then
            b = tjoin(b, button({}, 1, nil, bindN(args.action)))
        end
    elseif args.menu then
        b = tjoin(b, button({}, 1, nil, menu_toggle))
    end

    if args.tooltip then
        tooltip({ objects = { w } }):set_text(args.tooltip)
    end

    w:buttons(b)
    return w
end

M.separator = wibox.widget.textbox()
M.separator:set_markup(str.fg("red", " | "))

local function vc(widget, height)
  return wibox.layout {
    nil, wibox.container.constraint(widget, "exact", nil, height), nil,
    expand = "outside",
    layout = wibox.layout.align.vertical,
  }
end

function M.launchbar(items)
    local launchbar = wibox.layout.fixed.horizontal()
    for _, args in pairs(items) do
        if misc.empty(args) then
            launchbar:add(M.separator)
        else
            launchbar:add(vc(M(args), 24))
        end
    end
    return launchbar
end

M.icon_path = {
    os.getenv("HOME") .. "/.icons",
    "/usr/share/icons/hicolor/24x24/apps",
    "/usr/share/icons/hicolor/24x24/mimetypes",
    "/usr/share/icons/gnome/24x24/apps",
    "/usr/share/pixmaps",
    "/usr/share/icons/hicolor/48x48/apps",
    "/usr/share/icons/hicolor/48x48/mimetypes",
    "/usr/share/icons/gnome/48x48/apps",
}

function M.find_icon(filename)
    if awful.util.file_readable(filename) then
        return filename
    end
    for i=1, #(M.icon_path) do
        if awful.util.file_readable(M.icon_path[i].."/"..filename) then
            return M.icon_path[i].."/"..filename
        end
    end
    return nil
end

return M
