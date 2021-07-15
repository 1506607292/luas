local json = require 'cjson'

function decodeCookie(s_cookie)
    local cookie = {}
    for item in string.gmatch(s_cookie, "[^;]+") do
        local _, _, k, v = string.find(item, "^%s*(%S+)%s*=%s*(%S+)%s*")
        if k ~= nil and v~= nil then
            cookie[k] = v
        end
    end
    return cookie
end

math.randomseed(tonumber(tostring(ngx.now()*1000):reverse():sub(1, 9)))
local keyNum = 13456789
local newDynamicCode = math.random(1000000000,9999999999-keyNum)
local flag = 0
local cookie = ngx.req.get_headers()['Cookie']
if cookie then
    local cToken = decodeCookie(cookie)['CsrfToken']
    local cToken1 = tonumber(string.sub(cToken,0,10))
    local cToken2 = tonumber(string.sub(cToken,11,20))
    if cToken and cToken2-cToken1 == keyNum then
        flag = 0
    else
        flag = -1
    end
else
    flag = -2
    -- return ngx.redirect(ngx.var.request_uri,302)
end

if flag == 0 then
    ngx.header['Set-Cookie'] = {'CsrfToken='..newDynamicCode..newDynamicCode+keyNum}
    return
else
    ngx.header['Set-Cookie'] = {'CsrfToken='..newDynamicCode..newDynamicCode+keyNum}
    os.execute("sleep " .. 1)
    -- ngx.header['Content-Type'] = 'application/json; charset=utf-8'
    return ngx.redirect(ngx.var.request_uri,301)
    -- return ngx.say(json.encode({
        -- tokenCode = flag,
        -- message = 'unKnownError'
    -- }))
end