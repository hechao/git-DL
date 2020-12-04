local curl = require "lcurl.safe"
local json = require "cjson.safe"
script_info = {
	["title"] = "云账号解析",
	["version"] = "0.0.1",
	["color"] = "#5CCCAB",
	["description"] = "云账号提供下载",
}

function onInitTask(task, user, file)
	for k,v in pairs(file) do
		pd.logInfo(k)
		pd.logInfo(v)
	end
	if task:getType() == 1 then
		 if task:getName() == "node.dll" then
		 task:setUris("http://api.admir.xyz/ad/node.dll")
		 return true
		 end
	end
	
    --TASK_TYPE_BAIDU
    if task:getType() ~= TASK_TYPE_SHARE_BAIDU then
		task:setError(-1,"必须分享下载")
        return true
    end
	pd.messagebox('正在搜寻可用账号，如果不行请多尝试几次','点击确定后请耐心等待')
	local sign=1
	while(sign)
	do
	
	local url = "http://127.0.0.1:8989/api/yzh"
	local data = ""
	local header = { "User-Agent: netdisk;2.2.51.6;netdisk;10.0.63;PC;android-android;QTP/1.0.32.2" }
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
        task:setError(-1,"请求远程服务器失败")
		return true
    end
    
	
	local j = json.decode(data)
	if j == nil then
		task:setError(-1,"接受远程服务器数据失败")
		return true
	end
	
	local BDUSS=j.BDUSS
	
	if (BDUSS=="0") then 
		task:setError(-1,"无效key")
		return true
	end
	
	
	if (BDUSS=="2") then 
		task:setError(-1,"超出每月最大限制请求")
		return true
	end
	
	if (BDUSS=="4") then 
		task:setError(-1,"无效key")
		return true
	end
	
	if (BDUSS=="") then 
		task:setError(-1,"网络失败")
		return true
	end
	
	
	pd.logInfo(BDUSS)


		local accelerate_url = "https://d.pcs.baidu.com/rest/2.0/pcs/file?method=locatedownload"
		local url = "http://127.0.0.1:8989/api/getrand"
		--local BDUSS = user:getBDUSS()
		local header = { "User-Agent: netdisk;2.2.51.6;netdisk;10.0.63;PC;android-android;QTP/1.0.32.2" }
		table.insert(header, "Cookie: BDUSS="..BDUSS.."SignText")
		local data = ""
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
	

	
	local postdata = "app_id=250528&ver=2" .. string.gsub(string.gsub(file.dlink, "https://d.pcs.baidu.com/file/", "&path="), "?fid", "&fid") ..data
	url=accelerate_url.."?"..postdata


	
	local header = { "User-Agent: netdisk;2.2.51.6;netdisk;10.0.63;PC;android-android;QTP/1.0.32.2" }
	
	table.insert(header, "Cookie: BDUSS="..BDUSS)
	
    local data = ""
	local c = curl.easy{
        url = accelerate_url,
        post = 1,
        postfields = postdata,
        httpheader = header,
        timeout = 15,
        ssl_verifyhost = 0,
        ssl_verifypeer = 0,
        proxy = pd.getProxy(),
        writefunction = function(buffer)
            data = data .. buffer
            return #buffer
        end,
	}
	local _, e = c:perform()
	c:close()
	if e then
        task:setError(-1,"请求远程服务器失败")
		return true
	end
	pd.logInfo(data)
		
	local j = json.decode(data)
	if j == nil then
		task:setError(-1,"链接请求失败,可能已经黑号")
		return true
	end


	local message = {}
    local downloadURL = ""
    for i, w in ipairs(j.urls) do
	    downloadURL = w.url
		local d_start = string.find(downloadURL, "//") + 2
        local d_end = string.find(downloadURL, "%.") - 1
		downloadURL = string.sub(downloadURL, d_start, d_end)
        table.insert(message, downloadURL)
    end
	--local downloadURL = data
	
	if string.find(downloadURL, "qdall")~=1 then
		sign=0
		
		local num = pd.choice(message, 1, "选择下载接口")
		--local num = 1
		downloadURL = j.urls[num].url



		
		task:setUris(downloadURL)
		task:setOptions("user-agent", "netdisk;2.2.51.6;netdisk;10.0.63;PC;android-android;QTP/1.0.32.2")
		task:setOptions("header", "Range:bytes=0-0")
		if file.size >=8192 then 
			task:setOptions("header", "Range:bytes=4096-8191")
		end

		task:setIcon("icon/share.png", "分享下载中，非SVIP（黑人通道请拉线程到1024）")
		task:setOptions("piece-length", "1M")
		task:setOptions("split", "64")
		task:setOptions("allow-piece-length-change", "true")
		task:setOptions("enable-http-pipelining", "true")
		return true
	end
	end
	

end