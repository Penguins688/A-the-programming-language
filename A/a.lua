require("src.lexer")
require("src.parser")
require("src.compiler")

local function main(filename, show_output)
    filename = filename or arg[1]
    show_output = show_output or arg[2] == "--debug"
    
    if filename then
        local ext = filename:match("^.+(%..+)$")
        if ext ~= ".a" then
            error("Invalid file extension. The file must have a .a extension.")
        end
        
        local tokens = tokenize(filename)
        local parsed = parse(tokens)
        
        if show_output then
            compile(parsed, true)
        else
            compile(parsed, false)
        end
    else
        print("Usage: lua a.lua <filename> [--debug]")
    end
end

main()
