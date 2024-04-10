return {
    {
        "intelli",
        dev = "true",
        dir = "~/.config/nvim/lua/plugins/intelli.lua",
        cmd = "AI",
        cond = "true",
        config = function()
            function CodeComplete()
                -- Logic    
                -- Copy code from current buffer
                -- send a post req to nodejs server
                -- get output back from the nodejs server
                -- write the output back to buffer
                -- Backend server has two major API
                -- Send to /getcode and then get from /apires
                local bufnr = vim.api.nvim_get_current_buf()
                local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                local code = table.concat(lines, '\n')
                -- local code = "abc" 
                -- print(code)
                local url = "http://localhost:3000/getcode"
                -- local curl_cmd = "curl -X POST -H 'Content-type: text/plain' -d '" .. code .. "' ".. url
                local json_code = '{"code":"' .. code:gsub("\n", "\\n") .. '"}'
                local curl_cmd = "curl -X POST -H 'Content-type: application/json' -d '" .. json_code .. "' " .. url .. " 2>/dev/null"
                -- print(curl_cmd)
                local response = vim.fn.system(curl_cmd)
                -- print(response)

                local url1 = "http://localhost:3000/apires"
                local curl_cmd1 = "curl -X GET " .. url1 .. " 2>/dev/null"
                local response1 = vim.fn.system(curl_cmd1)
                -- local bufnr = vim.api.nvim_get_current_buf()
                local lines = {}
                for line in response1:gmatch("[^\r\n]+") do
                    table.insert(lines, line)
                end
                -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
                vim.fn.setreg('*', table.concat(lines, '\n'))
            end
            vim.cmd([[command! AI lua CodeComplete()]])
        end
        },
    
    {
        "intelli_test",
        dev = "true",
        dir = "~/.config/nvim/lua/plugins/intelli.lua.lua",
        cmd = "AITest",
        cond = "true",
        config = function()
            function AddTests()
                -- Copy code from current buffer, send to API and generate test cases and add it.
                local url = "http://localhost:3000/apires"
                local curl_cmd = "curl -X POST " .. url
                local response = vim.fn.system(curl_cmd)
                local bufnr = vim.api.nvim_get_current_buf()
                local lines = {}
                for line in response:gmatch("[^\r\n]+") do
                    table.insert(lines, line)
                end
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            end
            vim.cmd([[command! AITest lua CodeComplete()]])
        end
    }
}

