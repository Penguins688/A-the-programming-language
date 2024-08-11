local tokenTypes = {
    ["function"] = "Function",
    ["var"] = "Var",
    ["if"] = "If",
    ["while"] = "While",
    ["print"] = "Print",
    ["break"] = "Break",
    ["("] = "OpenParen",
    [")"] = "CloseParen",
    ["{"] = "OpenBrace",
    ["}"] = "CloseBrace",
    ["=="] = "Equal",
    ["!="] = "NotEqual",
    ["<"] = "LessThan",
    [">"] = "GreaterThan",
    ["<="] = "LessThanOrEqual",
    [">="] = "GreaterThanOrEqual",
    ["="] = "Equals",
    [";"] = "SemiColon",
    ["\n"] = "NewLine",
    ["+"] = "Operator",
    ["-"] = "Operator",
    ["*"] = "Operator",
    ["/"] = "Operator",
    ["%"] = "Operator"
}

local function classifyToken(token)
    local tokenType = tokenTypes[token]
    if tokenType then
        return tokenType
    elseif tonumber(token) then
        return "Number"
    elseif token:match('^".-"$') then
        return "String"
    else
        return "Identifier"
    end
end

local function read(file)
    local content = {}
    for line in file:lines() do
        local lineArr = {}
        local i = 1
        while i <= #line do
            local char = line:sub(i, i)
            if char:match("%s") then
                i = i + 1
            elseif char == '"' then
                local str = '"'
                i = i + 1
                while i <= #line and line:sub(i, i) ~= '"' do
                    str = str .. line:sub(i, i)
                    i = i + 1
                end
                str = str .. '"'
                table.insert(lineArr, {type = "String", value = str})
                i = i + 1
            elseif char == '/' and line:sub(i+1, i+1) == '/' then
                break
            elseif char:match("%d") then
                local number = char
                i = i + 1
                while i <= #line and line:sub(i, i):match("%d") do
                    number = number .. line:sub(i, i)
                    i = i + 1
                end
                table.insert(lineArr, {type = "Number", value = number})
            else
                local twoCharOp = char .. line:sub(i+1, i+1)
                if tokenTypes[twoCharOp] then
                    table.insert(lineArr, {type = tokenTypes[twoCharOp], value = twoCharOp})
                    i = i + 2
                elseif tokenTypes[char] then
                    table.insert(lineArr, {type = tokenTypes[char], value = char})
                    i = i + 1
                else
                    local word = char
                    i = i + 1
                    while i <= #line and not line:sub(i, i):match("%s") and not tokenTypes[line:sub(i, i)] do
                        word = word .. line:sub(i, i)
                        i = i + 1
                    end
                    local token = {
                        type = classifyToken(word),
                        value = word
                    }
                    table.insert(lineArr, token)
                end
            end
        end
        table.insert(lineArr, {type = "NewLine", value = "\n"})
        table.insert(content, lineArr)
    end
    return content
end

function tokenize(fileName)
    local file = io.open(fileName, "r")
    if file then
        local content = read(file)
        file:close()
        return content
    else
        error("Error: unable to open file " .. fileName)
    end
end