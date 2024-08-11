function parse(content)
    local parsedTable = {}
    local currentLine = {}
    for _, lineTokens in ipairs(content) do
        for _, token in ipairs(lineTokens) do
            if token.type == "String" then
                local newString = token.value:gsub('"', "")
                token.value = newString
            end
            if token.value == "\n" then
                table.insert(parsedTable, currentLine)
                currentLine = {}
            else
                table.insert(currentLine, { type = token.type, value = token.value })
            end
        end
    end
    if #currentLine > 0 then
        table.insert(parsedTable, currentLine)
        currentLine = {}
    end
    return parsedTable
end