local repo = "lucas-montes/knowbase-core"

-- Use curl to fetch the latest release information from GitHub API
local command = string.format('curl -s --fail-with-body "https://api.github.com/repos/lucas-montes/knowbase-core/releases/latest" | jq -r ".tag_name" ', repo)
local result = vim.fn.systemlist(command)

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


print(result[1])
-- Check if the request was successful (HTTP status 200)
if vim.fn.json_decode(result[1]).message == 'Not Found' then
    print('Error: Repository or release not found')
else
    local latest_tag = vim.fn.json_decode(result[1]).tag_name
    print('Latest tag:', latest_tag)
end
