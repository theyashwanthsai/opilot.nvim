return {
    {
        "opilot",
        dev = "true",
        dir = "~/.config/nvim/lua/plugins/opilot.lua",
        cmd = "AI",
        cond = "true",
        config = function()
            function CodeComplete()
                -- Logic    
                -- Copy code from current buffer
                -- send a curl request to gemma (May change in future)
                -- write the output back to buffer
                
                -- Get current buffer code. Need to change so that only till the cursor gets extracted
                local buf_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                local code = table.concat(buf_content)

                -- local api_url = "https://api-inference.huggingface.co/models/google/gemma-7b"
                local api_url = "https://api-inference.huggingface.co/models/codellama/CodeLlama-13b-hf"
                local auth_token = "YOUR-API-KEY"

               local payload = {
                    inputs = "You are a helpful code completion assistant. Only output the code." .. code
                }

                local payload_json = vim.fn.json_encode(payload)
                local cmd = string.format(
                'curl %s -X POST -d %s -H "Content-Type: application/json" -H "Authorization: Bearer %s"',
                api_url,
                vim.fn.shellescape(payload_json),
                auth_token
                )

                local response = vim.fn.systemlist(cmd)
                
                local last_line = ""
                for _, line in ipairs(response) do
                    last_line = line
                end

                local output = {}
                local first_colon_index = last_line:find(':')
                if first_colon_index then
                    local endline_index = last_line:find("\n", first_colon_index+1)
                    if endline_index then
                        code_part = last_line:sub(first_colon_index + 2, endline_index - 1)
                    else
                        code_part = last_line:sub(first_colon_index + 2)  
                    end
                    local start_index, end_index = code_part:find(code, 1, true)

                    if start_index then
                        code_part = code_part:sub(1, start_index - 1) .. code_part:sub(end_index + 1)
                    end
                    table.insert(output, code_part)
                -- add an else statement to tell nothing found (as a comment) todo
                else
                    table.insert(output, "None, press undo")
                end

                local cursor = vim.api.nvim_win_get_cursor(0)
                local current_line = cursor[1] - 1
                local current_col = cursor[2]
                -- vim.api.nvim_buf_set_lines(0, current_line+1, current_line+1, false, {last_line})   
                vim.api.nvim_buf_set_lines(0, current_line+1, current_line+1, false, output)  
            end
            vim.cmd([[command! AI lua CodeComplete()]])        
        end    
    },
    {
       "opilot_Test",
        dev = "true",
        dir = "~/.config/nvim/lua/plugins/opilot.lua",
        cmd = "AITest",
        cond = "true",
        config = function()
            function AddTests()
                -- Copy code from current buffer, send to API and generate test cases and add it.
                local buf_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                local code = table.concat(buf_content)

                
                local api_url = "https://api-inference.huggingface.co/models/codellama/CodeLlama-7b-hf"
                local auth_token = "YOUR-API-KEY"
                
                local payload = {
                    inputs = "For the given code below, generate test case functions. Give code only no text explanations: " .. code
                }

                local payload_json = vim.fn.json_encode(payload)
                
                local cmd = string.format(
                'curl %s -X POST -d %s -H "Content-Type: application/json" -H "Authorization: Bearer %s"',
                api_url,
                vim.fn.shellescape(payload_json),
                auth_token
                )

                local response = vim.fn.systemlist(cmd)
                -- retrieve only the last line from the response. Format this last line and only output that part.
                local last_line = ""
                for _, line in ipairs(response) do
                    last_line = line
                end
 
                 local output = {}
                local first_colon_index = last_line:find(':')

                if first_colon_index then
                    local second_colon_index = last_line:find(':', first_colon_index + 1)
                    if second_colon_index then
                        local endline_index = last_line:find("Complete", second_colon_index)
                        
                        local code_part
                        if endline_index then
                            code_part = last_line:sub(second_colon_index + 1, endline_index - 3)
                        else
                            code_part = last_line:sub(second_colon_index + 1)  
                        end
                        local start_index, end_index = code_part:find(code, 1, true)

                        if start_index then
                            code_part = code_part:sub(1, start_index - 1) .. code_part:sub(end_index + 1)
                        end
                        table.insert(output, code_part)
                    -- add an else statement to tell nothing found (as a comment) todo
                    else
                        table.insert(output, "None, press undo")
                    end
                end
                vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
            end
            vim.cmd([[command! AITest lua AddTests()]])
        end
    }
}

