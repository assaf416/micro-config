VERSION = "1.0.0"

local config = import("micro/config")

function init()
    config.MakeCommand("yapf", yapf, config.NoComplete)
    config.AddRuntimeFile("yapf", config.RTHelp, "help/yapf.md")
end

function onSave(bp)
    if bp.Buf:FileType() == "python" then
        yapf(bp)
    end
    if bp.Buf:FileType() == "ruby" then
        ruby_format(bp)
    end
    if bp.Buf:FileType() == "erb" then
        erb_format(bp)
    end
    
end

function yapf(bp)
    bp:Save()
    local handle = io.popen("yapf -i " .. bp.Buf.Path)
    local result = handle:read("*a")
    handle:close()
    bp.Buf:ReOpen()
end

function ruby_format(bp)
    bp:Save()
    local handle = io.popen("rufo " .. bp.Buf.Path)
    local result = handle:read("*a")
    handle:close()
    bp.Buf:ReOpen()
end

function erb_format(bp)
    bp:Save()
    local handle = io.popen("erb-format -w " .. bp.Buf.Path)
    local result = handle:read("*a")
    handle:close()
    bp.Buf:ReOpen()
end