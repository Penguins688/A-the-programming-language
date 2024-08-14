local functions = {}
local variables = {}
local lists = {}

local function find_variable(name)
    for _, variable in ipairs(variables) do
        if variable == name then
            return true
        end
    end
    return false
end

local function find_function(name)
    for _, function_name in ipairs(functions) do
        if function_name == name then
            return true
        end
    end
    return false
end

local function find_list(name)
    for _, list_name in ipairs(lists) do
        if list_name == name then
            return true
        end
    end
    return false
end

function compile(ast, show_output)
    local outfile = io.open("out.lua", "w")
    for lineIndex, line in ipairs(ast) do
        local tokenIndex = 1
        while tokenIndex <= #line do
            local token = line[tokenIndex]
            
            -- handle functions
            if token.type == "Function" then
                if tokenIndex + 3 <= #line and line[tokenIndex + 1].type == "Identifier" and line[tokenIndex + 2].type == "Equals" and line[tokenIndex + 3].type == "OpenBrace" then
                    outfile:write("local function " .. line[tokenIndex + 1].value .. "()\n")
                    table.insert(functions, line[tokenIndex + 1].value)
                    tokenIndex = tokenIndex + 4
                else
                    error("Error: function syntax incorrect on line " .. lineIndex)
                end
            
            -- handle semicolons
            elseif token.type == "SemiColon" then
                outfile:write("\n")
                tokenIndex = tokenIndex + 1
                
            -- handle vars
            elseif token.type == "Var" then
                if tokenIndex + 1 <= #line and line[tokenIndex + 1].type == "Identifier" then
                    outfile:write("local " .. line[tokenIndex + 1].value .. " ")
                    table.insert(variables, line[tokenIndex + 1].value)
                    tokenIndex = tokenIndex + 2
                else
                    error("Error: incorrect variable assignment on line " .. lineIndex)
                end
            
            -- handle lists
            elseif token.type == "List" then
                if tokenIndex + 1 <= #line and line[tokenIndex + 1].type == "Identifier" then
                    outfile:write("local " .. line[tokenIndex + 1].value .. " = {")
                    table.insert(lists, line[tokenIndex + 1].value)
                    tokenIndex = tokenIndex + 2
                    local firstElement = true
                    while tokenIndex <= #line and line[tokenIndex].type ~= "SemiColon" do
                        if line[tokenIndex].type == "Number" or line[tokenIndex].type == "String" or line[tokenIndex].type == "Operator" or line[tokenIndex].type == "Comma" then
                            if firstElement and line[tokenIndex].type == "Comma" then
                                error("Error: Unexpected comma at the start of the list on line " .. lineIndex)
                            end
                            if line[tokenIndex].type == "String" then
                                outfile:write("\"" .. line[tokenIndex].value .. "\"")
                            elseif line[tokenIndex].type == "Number" then
                                outfile:write(line[tokenIndex].value)
                            elseif line[tokenIndex].type == "Operator" then
                                outfile:write(line[tokenIndex].value)
                            elseif line[tokenIndex].type == "Comma" then
                                outfile:write(",")
                            end
                            firstElement = false
                            tokenIndex = tokenIndex + 1
                        else
                            error("Error: Unexpected token type " .. line[tokenIndex].type .. " in list on line " .. lineIndex)
                        end
                    end
                    outfile:write("}\n")
                else
                    error("Error: incorrect list assignment on line " .. lineIndex)
                end
            
            --handle lists
            elseif token.type == "Identifier" then
                if tokenIndex > 1 and (line[tokenIndex - 1].type == "Function" or line[tokenIndex - 1].type == "Var" or line[tokenIndex - 1].type == "List") then
                    outfile:write(token.value)
                else
                    if find_function(token.value) then
                        outfile:write(token.value .. "()")
                    elseif find_variable(token.value) then
                        outfile:write(token.value)
                    elseif find_list(token.value) then
                        if tokenIndex < #line and line[tokenIndex + 1].type == "Append" then

                        else
                            outfile:write(token.value)
                        end
                    else
                        error("Error: incorrect identifier usage on line " .. lineIndex)
                    end
                end
                tokenIndex = tokenIndex + 1
                
            -- handle =
            elseif token.type == "Equals" then
                if tokenIndex > 1 and line[tokenIndex - 1].type == "Identifier" then
                    if tokenIndex > 2 and line[tokenIndex - 2].type == "Function" then
                        outfile:write("")
                    elseif tokenIndex > 2 and line[tokenIndex - 2].type == "Var" then
                        outfile:write("= ")
                    else
                        outfile:write("=")
                    end
                else
                    if line[tokenIndex - 1].type == "CloseSquare" then
                        outfile:write("=")
                    else
                        error("Error: incorrect variable assignment on line " .. lineIndex)
                    end
                end
                tokenIndex = tokenIndex + 1
                
            -- handle number
            elseif token.type == "Number" then
                outfile:write(token.value)
                tokenIndex = tokenIndex + 1

            -- handle strings
            elseif token.type == "String" then
                outfile:write("\"" .. token.value .. "\"")
                tokenIndex = tokenIndex + 1
                
            -- handle if
            elseif token.type == "If" then
                outfile:write("if ")
                tokenIndex = tokenIndex + 1
                if line[tokenIndex].type ~= "OpenParen" then
                    error("Error: Expected '(' after 'if' on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                while tokenIndex <= #line and line[tokenIndex].type ~= "CloseParen" do
                    if line[tokenIndex].type == "String" then
                        outfile:write("\"" .. line[tokenIndex].value .. "\" ")
                    else
                        outfile:write(line[tokenIndex].value .. " ")
                    end
                    tokenIndex = tokenIndex + 1
                end
                if tokenIndex > #line or line[tokenIndex].type ~= "CloseParen" then
                    error("Error: Expected ')' after condition in if statement on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                if tokenIndex > #line or line[tokenIndex].type ~= "OpenBrace" then
                    error("Error: Expected '{' after if condition on line " .. lineIndex)
                end
                outfile:write("then\n")
                tokenIndex = tokenIndex + 1

            -- handle while
            elseif token.type == "While" then
                outfile:write("while ")
                tokenIndex = tokenIndex + 1
                if line[tokenIndex].type ~= "OpenParen" then
                    error("Error: Expected '(' after 'while' on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                while tokenIndex <= #line and line[tokenIndex].type ~= "CloseParen" do
                    if line[tokenIndex].type == "String" then
                        outfile:write("\"" .. line[tokenIndex].value .. "\" ")
                    else
                        outfile:write(line[tokenIndex].value .. " ")
                    end
                    tokenIndex = tokenIndex + 1
                end
                if tokenIndex > #line or line[tokenIndex].type ~= "CloseParen" then
                    error("Error: Expected ')' after condition in while statement on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                if tokenIndex > #line or line[tokenIndex].type ~= "OpenBrace" then
                    error("Error: Expected '{' after while condition on line " .. lineIndex)
                end
                outfile:write("do\n")
                tokenIndex = tokenIndex + 1
            
            -- handle repeat until
            elseif token.type == "RepeatUntil" then
                outfile:write("while true do\n")
                outfile:write("if ")
                tokenIndex = tokenIndex + 1
                if line[tokenIndex].type ~= "OpenParen" then
                    error("Error: Expected '(' after 'while' on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                while tokenIndex <= #line and line[tokenIndex].type ~= "CloseParen" do
                    if line[tokenIndex].type == "String" then
                        outfile:write("\"" .. line[tokenIndex].value .. "\" ")
                    else
                        outfile:write(line[tokenIndex].value .. " ")
                    end
                    tokenIndex = tokenIndex + 1
                end
                if tokenIndex > #line or line[tokenIndex].type ~= "CloseParen" then
                    error("Error: Expected ')' after condition in while statement on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                if tokenIndex > #line or line[tokenIndex].type ~= "OpenBrace" then
                    error("Error: Expected '{' after while condition on line " .. lineIndex)
                end
                outfile:write("then\n")
                outfile:write("break\n")
                outfile:write("end\n")
                tokenIndex = tokenIndex + 1


            -- handle repeat loop
            elseif token.type == "Repeat" then
                tokenIndex = tokenIndex + 1
                local repeatCount = ""
                if tokenIndex > #line or line[tokenIndex].type ~= "OpenParen" then
                    error("Error: Expected '(' after 'repeat' on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                while tokenIndex <= #line and line[tokenIndex].type ~= "CloseParen" do
                    if line[tokenIndex].type == "String" then
                        error("Error: Expected a number after '(' in 'repeat' on line " .. lineIndex)
                    end
                    repeatCount = repeatCount .. " " .. line[tokenIndex].value
                    tokenIndex = tokenIndex + 1
                end
                tokenIndex = tokenIndex + 1
                outfile:write("for i = 1, " .. repeatCount .. " do\n")
                tokenIndex = tokenIndex + 1
            
            -- handle forever loop
            elseif token.type == "Forever" then
                outfile:write("while true do\n")
                tokenIndex = tokenIndex + 1

            -- handle add
            elseif token.type == "Append" then
                if tokenIndex > 1 and line[tokenIndex - 1].type == "Identifier" then
                    if find_list(line[tokenIndex - 1].value) then
                        local list = line[tokenIndex - 1].value
                        tokenIndex = tokenIndex + 1 
                        local addition = ""
                        while tokenIndex <= #line and line[tokenIndex].type ~= "SemiColon" do
                            if line[tokenIndex].type == "String" then
                                addition = addition .. "\"" .. line[tokenIndex].value .. "\""
                            else
                                addition = addition .. line[tokenIndex].value
                            end
                            tokenIndex = tokenIndex + 1
                        end
                        outfile:write("table.insert(" .. list .. ", " .. addition .. ")")
                    else
                        error("Error: Expected list before add on line " .. lineIndex) 
                    end
                else
                    error("Error: Expected list before add on line " .. lineIndex)
                end

            elseif token.type == "Random" then
                outfile:write("math.random(")
                tokenIndex = tokenIndex + 2
                while tokenIndex <= #line and line[tokenIndex].type ~= "CloseParen" do
                    if line[tokenIndex].type == "String" then
                        error("Error: expected number value on line " .. lineIndex)
                    else
                        outfile:write(line[tokenIndex].value)
                    end
                    tokenIndex = tokenIndex + 1
                end
                outfile:write(")")
                tokenIndex = tokenIndex + 1 

            -- handle #
            elseif token.type == "Length" then
                outfile:write("#")
                tokenIndex = tokenIndex + 1
                
            -- handle {
            elseif token.type == "OpenBrace" then
                tokenIndex = tokenIndex + 1
                
            -- handle }
            elseif token.type == "CloseBrace" then
                outfile:write("end\n")
                tokenIndex = tokenIndex + 1

            -- handle [
            elseif token.type == "OpenSquare" then
                outfile:write("[")
                tokenIndex = tokenIndex + 1
            
            -- handle ]
            elseif token.type == "CloseSquare" then
                outfile:write("]")
                tokenIndex = tokenIndex + 1
            
            -- handle ..
            elseif token.type == "Concatenate" then
                outfile:write("..")
                tokenIndex = tokenIndex + 1
            
            -- handle input number
            elseif token.type == "InputNum" then
                outfile:write("tonumber(io.read())")
                tokenIndex = tokenIndex + 1

            -- handle input string
            elseif token.type == "InputStr" then
                outfile:write("io.read()")
                tokenIndex = tokenIndex + 1

            -- handle print
            elseif token.type == "Print" then
                outfile:write("print(")
                tokenIndex = tokenIndex + 1
                
                if line[tokenIndex].type ~= "OpenParen" then
                    error("Error: Expected '(' after 'print' on line " .. lineIndex)
                end
                
                tokenIndex = tokenIndex + 1
                
                local expression = {}
                local parenthesesCount = 1
                
                while tokenIndex <= #line do
                    if line[tokenIndex].type == "OpenParen" then
                        parenthesesCount = parenthesesCount + 1
                    elseif line[tokenIndex].type == "CloseParen" then
                        parenthesesCount = parenthesesCount - 1
                        if parenthesesCount == 0 then
                            break
                        end
                    end
                    
                    local tokenValue = line[tokenIndex].value
                    if line[tokenIndex].type == "String" then
                        tokenValue = '"' .. tokenValue .. '"'
                    end
                    
                    table.insert(expression, tokenValue)
                    tokenIndex = tokenIndex + 1
                end
                
                if parenthesesCount > 0 then
                    error("Error: Expected ')' after print expression on line " .. lineIndex)
                end
                
                outfile:write(table.concat(expression, " "))
                outfile:write(")\n")
                
            elseif line[tokenIndex].type == "Operator" then
                outfile:write(line[tokenIndex].value)
                tokenIndex = tokenIndex + 1
            elseif line[tokenIndex].type == "Break" then
                outfile:write(line[tokenIndex].value)
                tokenIndex = tokenIndex + 1
            else
                tokenIndex = tokenIndex + 1 
            end
        end
        if show_output == false then
            outfile:write("\nos.remove('out.lua')")
        end
    end
    outfile:close()
    os.execute("lua out.lua")
end
