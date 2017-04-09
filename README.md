## awesome-quicklaunch

### Description

Simple quicklaunchbar widget.


### Installation

Drop the script into your awesome config folder. Suggestion:

```bash
cd ~/.config/awesome
git clone https://github.com/coldfix/awesome-quicklaunch.git
```


### Usage

In your `~/.config/awesome/rc.lua`:

```lua
local quicklaunch = require("awesome-quicklaunch")


-- create widget
local launchbar = quicklaunch:launchbar({
    { "Pidgin",       "pidgin.png",       "pidgin-debug",   },
    { "Konversation", "konversation.png", "konversation",   },
    {                                                       },
    { "Terminal",     "terminator.png",   "termite",        {
        {"~/dev",     { "termite", "-d", "~/dev"   }},
        {"/media",    { "termite", "-d", "~/media" }},
    }},
})


-- add the widget to your wibox
left_layout:add(launchbar)
```

The constructor expects a list of items which can be

- empty tables (separator)
- tables of three or four elements `{ tooltip, icon, action, [menu] }`

An action can be

- a single command string
- a list of command line arguments
- a function to be executed

A menu must be given as a list of tables `{ text, action }` with actions as
defined above. Currently, submenus are not supported.


### Requirements

* [awesome 4.0](http://awesome.naquadah.org/) or possibly 3.5
