function date_translator(input, seg)
    if (input == "rq") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), ""))
    end
    if (input == "sj") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), ""))
        yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), ""))
    end
    if (input == "xq") then
        local weakTab = {'日', '一', '二', '三', '四', '五', '六'}
        yield(Candidate("week", seg.start, seg._end, "周"..weakTab[tonumber(os.date("%w")+1)], ""))
        yield(Candidate("week", seg.start, seg._end, "星期"..weakTab[tonumber(os.date("%w")+1)], ""))
    end
end

-- shang 上 商：当 [拼音=英文] 时将中文前移
function cn_first(input, env)
    local i = 0
    local rest = {}
    local typ = env.engine.context.input
    for cand in input:iter() do
        if (cand.text == typ) then
            table.insert(rest, cand)
        elseif (i < 2) then
            yield(cand)
            i = i + 1
        else
            table.insert(rest, cand)
        end
    end

    for i, cand in ipairs(rest) do
        yield(cand)
    end
end
