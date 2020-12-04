local curl = require "lcurl.safe"
local json = require "cjson.safe"
script_info = {
	["title"] = "云解析通道",
	["version"] = "0.0.1",
	["color"] = "#57C43C",
	["description"] = "KinhDown App云通道请使用分享下载",
}

function onInitTask(task, user, file)
	for k,v in pairs(file) do
		pd.logInfo(k)
		pd.logInfo(v)
	end
	
	
    --TASK_TYPE_BAIDU
    if task:getType() ~= TASK_TYPE_SHARE_BAIDU then
		task:setError(-1,"必须分享下载")
        return true
    end
	local dlinklink = file.dlink
    if user ~= nil then
        bdss = user:getCookie()
		else
		bdss = ""
	end	
	

	
	
	local url = "http://127.0.0.1:8989/api/yjx?dlink="..dlinklink
	pd.logInfo(dlinklink)
	local data = ""
	local header = { "User-Agent: netdisk;P2SP;2.2.60.26" }
	pd.logInfo(bdss)
	if bdss ~= "" then
		table.insert(header, "Cookie: "..bdss.."SignText")
	end
	
	local c = curl.easy{
		url = url,
		followlocation = 1,
		httpheader = header,
		timeout = 15,
		proxy = pd.getProxy(),
		writefunction = function(buffer)
			data = data .. buffer
			return #buffer
		end,
	}
    local _, e = c:perform()
    c:close()
    if e then
        task:setError(-1,"链接至本地服务器失败,检查8989端口")
		return true
    end
	pd.logInfo(data)
	local j = json.decode(data)
	if j == nil then
		
		task:setError(-1,"请求错误，链接云解析失败")
		return true
	end
	if j.error == "0" then 
	
	task:setUris(j.link)
	task:setOptions("user-agent", j.ua)
	--task:setOptions("split", j.split)
	else
		local info="云解析错误，Status:"..j.error
		task:setError(-1,info)
		return true
	end
	
	
    
    
    --task:setOptions("header", "Cookie: "..user:getCookie())
	task:setOptions("piece-length", "1M")
    return true
end