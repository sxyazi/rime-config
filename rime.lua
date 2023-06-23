function date_translator(input, seg)
	if input == "rq" then
		--- Candidate(type, start, end, text, comment)
		yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
		yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), ""))
		yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), ""))
	end
	if input == "sj" then
		--- Candidate(type, start, end, text, comment)
		yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), ""))
		yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), ""))
	end
	if input == "xq" then
		local weakTab = { "日", "一", "二", "三", "四", "五", "六" }
		yield(Candidate("week", seg.start, seg._end, "周" .. weakTab[tonumber(os.date("%w") + 1)], ""))
		yield(Candidate("week", seg.start, seg._end, "星期" .. weakTab[tonumber(os.date("%w") + 1)], ""))
	end
end

-- shang 上 商：当 [拼音=英文] 时将中文前移
function cn_first(input, env)
	local i = 0
	local rest = {}
	local typ = env.engine.context.input

	for cand in input:iter() do
		if cand.text == typ then
			rest[#rest + 1] = cand
		elseif i < 2 and cand.preedit == typ then
			yield(cand)
			i = i + 1
		else
			rest[#rest + 1] = cand
		end
	end

	for _, cand in ipairs(rest) do
		yield(cand)
	end
end

-- 根据首字母自动转换单词为大写
-- true => true / True => True / TRue => TRUE
function auto_capitalize(input, env)
	local typ = env.engine.context.input
	local len = #typ

	if len < 2 or not typ:find("^%u") then
		for cand in input:iter() do
			yield(cand)
		end
		return
	end

	local op = 1
	if typ:find("^%u%u") then
		op = 2
	end

	local lower = typ:lower()
	for cand in input:iter() do
		if lower ~= cand.text:lower() then
			yield(cand)
		elseif op == 1 then
			local text = cand.text:sub(1, 1):upper() .. cand.text:sub(2)
			yield(Candidate(cand.type, 0, len, text, cand.comment))
		elseif op == 2 then
			local text = cand.text:upper()
			yield(Candidate(cand.type, 0, len, text, cand.comment))
		end
	end
end
