-- こちらを採用する
-- 旧式のは工夫して使えるようにするか, 完全に破棄する(デバッグライブラリを用いているのはあまり褒められたことではない)
local function iflet (...)
    local bindings = {...}
    return function(thenproc)
        -- match check
        for k, v in pairs(bindings) do
            local t = getmetatable(v)
            -- アンラップ失敗
            if not t.instance then
                -- elseを実行する関数を返す
                return function(f) f() end
            else
                bindings[k] = t.instance
            end
        end

        -- thenproc を実行
        thenproc(table.unpack(bindings))

        -- else をとって何もしない関数を返す
        return function() return end
    end
end

return iflet

