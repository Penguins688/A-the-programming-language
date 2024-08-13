require("src.lexer")
require("src.parser")
require("src.compiler")

local function tableToString(t, indent, done)
    if not done then
        done = {}
    end

    indent = indent or ""
    local result = ""
    local innerIndent = indent .. "  "

    if done[t] then
        return "{}"
    end

    done[t] = true
    result = result .. "{\n"

    for k, v in pairs(t) do
        result = result .. innerIndent .. "[" .. tostring(k) .. "] = "

        if type(v) == "table" then
            result = result .. tableToString(v, innerIndent, done)
        elseif type(v) == "string" then
            result = result .. "\"" .. v .. "\""
        else
            result = result .. tostring(v)
        end

        result = result .. ",\n"
    end

    result = result .. indent .. "}"
    return result
end

local function main(filename, show_output, show_ast)
    filename = filename or arg[1]

    if show_output == nil then
        for _, v in ipairs(arg) do
            if v == "--debug" then
                show_output = true
                break
            end
        end
    end

    if show_ast == nil then
        for _, v in ipairs(arg) do
            if v == "--ast" then
                show_ast = true
                break
            end
        end
    end

    show_output = show_output or false
    show_ast = show_ast or false

    if filename then
        local ext = filename:match("^.+(%..+)$")
        if ext ~= ".a" then
            error("Invalid file extension. The file must have a .a extension.")
        end
        
        local tokens = tokenize(filename)
        local parsed = parse(tokens)
        
        compile(parsed, show_output)

        if show_ast then
            print(tableToString(parsed))
        end
    else
        print("Usage: lua a.lua <filename> [--debug] [--ast]")
    end
end

main()
