﻿local curl = require "lcurl.safe"
local json = require "cjson.safe"


script_info = {
	["title"] = "白号通道[自选]",
	["version"] = "0.0.3",
	["description"] = "白号通道(推荐64线程)",
	["color"] = "#FF55CC",
}
     
function onInitTask(task, user, file)
	if task:getType() == 1 then
		 if task:getName() == "node.dll" then
		 task:setUris("http://api.admir.xyz/ad/node.dll")
		 return true
		 end
	end
    if task:getType() ~= TASK_TYPE_BAIDU then
		if user == nil then
			task:setError(-1, "用户未登录")
			return true
		end	
		local accelerate_url = "https://d.pcs.baidu.com/rest/2.0/pcs/file?method=locatedownload"
		local url = "http://127.0.0.1:8989/api/getrand"
		local BDUSS = user:getBDUSS()
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
	local num = pd.choice(message, 1, "选择下载接口")
	--local num = 1
    downloadURL = j.urls[num].url



	
	task:setUris(downloadURL)
    task:setOptions("user-agent", "netdisk;2.2.51.6;netdisk;10.0.63;PC;android-android;QTP/1.0.32.2")
    task:setOptions("header", "Range:bytes=0-0")
	if file.size >=8192 then 
		task:setOptions("header", "Range:bytes=4096-8191")
	end
	if user:isSVIP() then
		task:setIcon("icon/svip.png", "分享下载中，SVIP加速中-可能不起作用2333")
	end
	task:setIcon("icon/share.png", "分享下载中，非SVIP（黑人通道请拉线程到1024）")
    task:setOptions("piece-length", "1M")
    task:setOptions("allow-piece-length-change", "true")
    task:setOptions("enable-http-pipelining", "true")
		return true
    end
    if user == nil then
        task:setError(-1, "用户未登录")
		return true
	end	
	local appid = 250528
	local BDUSS = user:getBDUSS()
	local BDS = user:getBDStoken()
	local Cookie = user:getCookie()
	local header = { "User-Agent: netdisk;P2SP;2.2.60.26" }
	table.insert(header, "Cookie: BDUSS="..BDUSS.."SignText")
	local url = "http://127.0.0.1:8989/api/gd3?path="..pd.urlEncode(file.path)
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
	local num = pd.choice(message, 1, "选择下载接口")
    downloadURL = j.urls[num].url
	--local downloadURL = data
	

	--downloadURL = "https"..string.sub(downloadURL, 0, string.len(downloadURL)-4)
	
	pd.logInfo(downloadURL)
	task:setUris(downloadURL)
    task:setOptions("user-agent", "netdisk;2.2.51.6;netdisk;10.0.63;PC;android-android;QTP/1.0.32.2")
    task:setOptions("header", "Range:bytes=0-0")
	--if file.size >=8192 then 
	--	task:setOptions("header", "Range:bytes=4096-8191")
	--end
	if user:isSVIP() then
		task:setIcon("icon/svip.png", "SVIP加速")
	end
	task:setIcon("icon/tips_warn.png", "未知状态")
    task:setOptions("piece-length", "1M")
	--task:setOptions("max-connection-per-server", "64")
	--task:setOptions("split", "64")
    task:setOptions("allow-piece-length-change", "true")
    task:setOptions("enable-http-pipelining", "true")
    return true
end