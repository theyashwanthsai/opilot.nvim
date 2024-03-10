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

                local api_url = "https://api-inference.huggingface.co/models/google/gemma-7b"
                local auth_token = "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"

                local payload = {
                    inputs = "Complete code: " .. code
                }

                local payload_json = vim.fn.json_encode(payload)

                -- gemma API
                local cmd = string.format(
                'curl %s -X POST -d %s -H "Content-Type: application/json" -H "Authorization: Bearer %s"',
                api_url,
                vim.fn.shellescape(payload_json),
                auth_token
                )
                local response = vim.fn.systemlist(cmd)

                -- output
                -- local output = table.concat(response, "\n")
                local generated_text = response[1].generated_text:gsub("\n", "")

                -- write the code back to the buffer. Need to change so that after the buffer, the diff will be pasted.
                vim.api.nvim_buf_set_lines(0, -1, -1, false, generated_text)
            end
            vim.cmd([[command! AI lua CodeComplete()]])        
        end
    }
}

