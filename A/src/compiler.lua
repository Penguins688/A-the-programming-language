local functions = {}
local variables = {}

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
            
            -- handle identifiers
            elseif token.type == "Identifier" then
                if tokenIndex > 1 and (line[tokenIndex - 1].type == "Function" or line[tokenIndex - 1].type == "Var") then
                    outfile:write(token.value)
                else
                    if find_function(line[tokenIndex].value) then
                        outfile:write(line[tokenIndex].value .. "()")
                    elseif find_variable(line[tokenIndex].value) then
                        outfile:write(line[tokenIndex].value)
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
                    else
                        outfile:write("= ") 
                    end
                else
                    error("Error: incorrect variable assignment on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                
            -- handle number
            elseif token.type == "Number" then
                outfile:write(token.value)
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
                    outfile:write(line[tokenIndex].value .. " ")
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

            -- handle if
            elseif token.type == "While" then
                outfile:write("while ")
                tokenIndex = tokenIndex + 1
                if line[tokenIndex].type ~= "OpenParen" then
                    error("Error: Expected '(' after 'if' on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                while tokenIndex <= #line and line[tokenIndex].type ~= "CloseParen" do
                    outfile:write(line[tokenIndex].value .. " ")
                    tokenIndex = tokenIndex + 1
                end
                if tokenIndex > #line or line[tokenIndex].type ~= "CloseParen" then
                    error("Error: Expected ')' after condition in if statement on line " .. lineIndex)
                end
                tokenIndex = tokenIndex + 1
                if tokenIndex > #line or line[tokenIndex].type ~= "OpenBrace" then
                    error("Error: Expected '{' after if condition on line " .. lineIndex)
                end
                outfile:write("do\n")
                tokenIndex = tokenIndex + 1
                
            -- handle OpenBrace (start of block)
            elseif token.type == "OpenBrace" then
                tokenIndex = tokenIndex + 1
                
            -- handle CloseBrace (end of block)
            elseif token.type == "CloseBrace" then
                outfile:write("end\n")
                tokenIndex = tokenIndex + 1
                
            --handle print    
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
                    
                    table.insert(expression, line[tokenIndex].value)
                    tokenIndex = tokenIndex + 1
                end
                
                if parenthesesCount > 0 then
                    error("Error: Expected ')' after print expression on line " .. lineIndex)
                end
                
                outfile:write(table.concat(expression, " "))
                outfile:write(")")
                
                
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
    end
    if show_output == false then
        outfile:write("\nos.remove('out.lua')")
    else

    end 
    outfile:close()
    os.execute("lua out.lua")
end