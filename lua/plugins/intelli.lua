return {
    {
        "intelli",
        dev = "true",
        dir = "~/.config/nvim/lua/plugins/intelli.lua.lua",
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
                local api_url = "https://api-inference.huggingface.co/models/codellama/CodeLlama-7b-hf"
                local auth_token = "YOUR-API-KEY"

                local payload = {
                    inputs = "Complete the following code snippet. give code only, dont give other answer. : " .. code
                }

                local payload_json = vim.fn.json_encode(payload)

                -- some huggingface API
                local cmd = string.format(
                'curl %s -X POST -d %s -H "Content-Type: application/json" -H "Authorization: Bearer %s"',
                api_url,
                vim.fn.shellescape(payload_json),
                auth_token
                )
                -- Write it to a file to debug :(
                -- local cmd_file = io.open("./cmd.txt", "w")
                --     if cmd_file then
                --         cmd_file:write(cmd .. "\n")
                --         cmd_file:close()
                --     end

                local response = vim.fn.systemlist(cmd)
                -- Write it to a file to debug
                
                local last_line = ""
                for _, line in ipairs(response) do
                    last_line = line
                end
                -- local input = "Complete the following code snippet. give code only. Give code only after the input: " .. code       
                -- local response_file = io.open("./response.txt", "w")
                -- if response_file then
                --     response_file:write(output_lines .. "\n")
                --     response_file:close()
                -- end
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
                local cursor = vim.api.nvim_win_get_cursor(0)
                local current_line = cursor[1] - 1
                local current_col = cursor[2]

                vim.api.nvim_buf_set_lines(0, current_line+1, current_line+1, false, output)     
            end
            vim.cmd([[command! AI lua CodeComplete()]])        
        end
    }
}

