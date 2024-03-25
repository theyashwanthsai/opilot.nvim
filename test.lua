local http = require("socket.http")
local ltn12 = require("ltn12")

function codecomplete()
    -- Define the URL of your API endpoint
    local url = "http://localhost:3000/apires"
    
    -- Make a GET request to the API endpoint
    local response_body = {}
    local _, status_code, _, _ = http.request {
        url = url,
        method = "GET",
        sink = ltn12.sink.table(response_body)
    }

    -- Check if the request was successful (status code 200)
    if status_code == 200 then
        -- Extract and process the response data
        local response_text = table.concat(response_body)
        print("Response from server:", response_text)
        -- Do something with the response data (e.g., update the buffer)
    else
        print("Error: HTTP request failed with status code", status_code)
    end
end