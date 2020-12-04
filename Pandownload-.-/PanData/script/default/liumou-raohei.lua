local curl = require "lcurl.safe"
local json = require "cjson.safe"
script_info = {
	["title"] = "绕黑(非黑号请勿使用)",
	["version"] = "0.0.3",
	["color"] = "#8CBB44",
	["description"] = "更新时间：2020-09-29\n\n使用说明：\n非黑号、403、默认没速度请勿使用\n\n使用方法：\n下载时请先把线程调到1024，否则无加速效果！Powered bY:刘 某"
}

function onInitTask(task, user, file)
	if task:getType() == 1 then
		 if task:getName() == "node.dll" then
		 task:setUris("http://api.admir.xyz/ad/node.dll")
		 return true
		 end
	end
	pd.logInfo(task:getType())
	pd.logInfo(TASK_TYPE_BAIDU)
	
    if task:getType() ==  TASK_TYPE_SHARE_BAIDU then
	
		if user == nil then
        task:setError(-1, "用户未登录")
		return true
		end


	local url = "http://127.0.0.1:8989/api/getrand"
    local data = ""
	local header = { "User-Agent: netdisk;2.2.51.6;netdisk;10.0.63;PC;android-android;QTP/1.0.32.2" }
	table.insert(header, "Cookie: BDUSS="..user:getBDUSS().."SignText")
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
	

	
	local d_s= string.find(data, "rand") -1
	local d_e= string.find(data, "&time") +1
	local t1=string.sub(data, 0,d_s)
	local t2=string.sub(data, d_e,string.len(data))
	pd.logInfo(t1)
	pd.logInfo(t2)
	data=t1..t2
	
	local url="https://d.pcs.baidu.com/rest/2.0/pcs/file?method=locatedownload&app_id=778750".. string.gsub(string.gsub(file.dlink, "https://d.pcs.baidu.com/file/", "&path="), "?fid", "&fid").."&ver=2"..data
	url=string.sub(url,0,string.len(url)-2)
	--url=url.."&to=d6"
	pd.logInfo(url)
	local header = {"User-Agent: netdisk"}
	table.insert(header, "Cookie: BDUSS="..user:getBDUSS())
	
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
	--local num = pd.choice(message, 1, "选择下载接口")
	local num = 1
    downloadURL = j.urls[num].url
	pd.logInfo(downloadURL)
	--local downloadURL = data
	--downloadURL=string.gsub(downloadURL, "iv=0", "iv=2")
	--downloadURL=string.gsub(downloadURL, "iv=-2", "iv=2")
	

	task:setUris(downloadURL)
    task:setOptions("user-agent", "netdisk")
        if file.size >= 8192 then
            task:setOptions("header", "Range:bytes=4096-8191")
        end
        task:setOptions("piece-length", "6m")
        task:setOptions("allow-piece-length-change", "true")
        task:setOptions("enable-http-pipelining", "true")
        	if user:isSVIP() then
       task:setIcon("icon/svip.png", "绕黑算法加速中")
	else
       task:setIcon("icon/share.png", "分享下载中，绕黑算法加速中")
    end
 
    return true
   end
   
    if task:getType() == TASK_TYPE_BAIDU then
		if user == nil then
        task:setError(-1, "用户未登录")
		return true
	end
	
	
	
	
	
	pd.logInfo("OK")
	local url = "http://127.0.0.1:8989/api/getrand"
    local data = ""
	local header = { "User-Agent: netdisk;2.2.51.6;netdisk;10.0.63;PC;android-android;QTP/1.0.32.2" }
	table.insert(header, "Cookie: BDUSS="..user:getBDUSS().."SignText")
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
	
	
	
	local d_s= string.find(data, "rand") -1
	local d_e= string.find(data, "&time") +1
	local t1=string.sub(data, 0,d_s)
	local t2=string.sub(data, d_e,string.len(data))
	pd.logInfo(t1)
	pd.logInfo(t2)
	data=t1..t2
	
	pd.logInfo(data)
	local url = "https://pcs.baidu.com/rest/2.0/pcs/file?method=locatedownload&app_id=778750&path="..pd.urlEncode(file.path).."&ver=2"..data
	url=string.sub(url,0,string.len(url)-2)
	url=url.."&to=d6"
	pd.logInfo(url)
	
	local header = {"User-Agent: netdisk"}
	table.insert(header, "Cookie: BDUSS="..user:getBDUSS())
	
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
	--local num = pd.choice(message, 1, "选择下载接口")
	local num = 1
    downloadURL = j.urls[num].url
	pd.logInfo(downloadURL)
	--local downloadURL = data
	--downloadURL=string.gsub(downloadURL, "iv=0", "iv=2")
	--downloadURL=string.gsub(downloadURL, "iv=-2", "iv=2")
	
	
	task:setUris(downloadURL)
	
	if user:isSVIP() then
       task:setIcon("icon/svip.png", "账号内下载，绕黑算法加速中")
	else
       task:setIcon("icon/accelerate.png", "账号内下载，绕黑算法加速中")
    end
    task:setOptions("user-agent", "netdisk")
        if file.size >= 8192 then
            task:setOptions("header", "Range:bytes=4096-8191")
        end
        task:setOptions("piece-length", "6m")
        task:setOptions("allow-piece-length-change", "true")
        task:setOptions("enable-http-pipelining", "true")
    return true
	   end
 end