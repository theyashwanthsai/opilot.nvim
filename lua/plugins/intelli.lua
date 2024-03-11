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
                local code = table.concat(buf_content, "\n")

                -- local api_url = "https://api-inference.huggingface.co/models/google/gemma-7b"
                local api_url = "https://api-inference.huggingface.co/models/codellama/CodeLlama-7b-hf"
                local auth_token = "YOUR-API-KEY"

                local payload = {
                    inputs = "Complete the following code snippet. give code only. Give code only after the input: " .. code
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
                -- local res_json = vim.fn.json_decode(response)
                -- local response_file = io.open("./response.txt", "w")
                -- if response_file then
                --     local last_line
                --     for _, line in ipairs(response) do
                --         -- response_file:write(line .. "\n")
                --         last_line = line
                --     end
                --     response_file:write(last_line .. "\n")
                --     response_file:close()
                -- end
                -- Write it to a file to debug
                
                local last_line
                for _, line in ipairs(response) do
                    last_line = line
                end
                local output = {}
                table.insert(output, last_line)
                vim.api.nvim_buf_set_lines(0, -1, -1, false, output) 
            end
            vim.cmd([[command! AI lua CodeComplete()]])        
        end
    }
}

