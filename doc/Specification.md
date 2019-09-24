# Optional.lua specification

## TOC
- Basis
- Optional type
- iflet function
- Other functions

## Basis
### What is optional for Lua?
- Optional method call that is nil can call method then returns nil.
- Safely unwrapping optional object and handle it. (= if-let syntax)
- カプセル化することによる Optional 構造の隠蔽
- いわば Optional とは nil か 非nil かの不定状態を維持し続けて, if-let で固定化する行為.

### FAQ
- function retruns multi-value, what is a type of Optional(func())?
    - Not yet specified. There are several options:
        - Optional(func()) -> Optional(val1), Optional(val2), ... -- very clear, however receiver's variable counts are not informed.
        - Optional(func()) -> Optional({func()}) -- if-let is defficult
        - Optional(func()) -> Optional((func())) -- easy one but not obedience
        - Optional(func()) -> Optional(Tuple(func())) -- lack of compatibility but convenience one
            - Tuple:unwrap() -> v1, v2, v3, v4

~~~
Optional: (instance: Object | nil) -> OptionalObject

OptionalObject = {}
getmetatable(OptionalObject) = {
    instance: (Object | nil),
    __index: (table, key) -> OptionalObject = { -- インデクシングの戻り値も Optional.
        if instance == nil then return Optional(nil)
        else return Optional(table[key])
    }
    __call: (func, ...) -> OptionalObject = { -- コールの戻り値も Optional.
        if instance == nil then return Optional(nil)
        else Optional(func(...))
    } -- TODO: エラーメッセージが意味不明なものになるので, Optional 仕様に書き換える
    -- 具体的にはメタテーブル内のオブジェクトに対してコール不能エラーが出るので, Optional の中身がコール不能であると明示する.
    -- 以降全てのメタメソッドを実装する
}
~~~

## iflet function
if-let とは不定状態を固定するものである

~~~
iflet: (bindings: Table) -> (() -> (() -> ()))

iflet { v1 = op1, v2 = op2, ... } ( function() 
    then some works
end ) ( function()
    else some works
end)
~~~

ただしこの文法はちょっとえげつない見た目になる

こんな文法も考えられる
~~~
iflet: (...) -> ((...) -> (() -> ()))

iflet (op1, op2, ...) ( function(v1, v2, ...)
    do some stuff
end)(funtion()
    do some else stuff
end)
~~~
こっちの方が正規文法っぽくていい

## Optional ではない方法
~~~
local res = failableFunc1()
local pon = failableFunc2()
if not res and not pon then
    res.someMethod()
    local nce = pon.someMethod() -- maybe fails
    if not nce then
        print(nce)
    end
end
~~~

これは Optional が有効
`
local res = Optional(failableFunc1())
local pon = Optional(failableFunc2())
res.someMethod()
local nce = pon.someMethod() -- nil callable!

iflet (res, nce) (function(_, nce)
    print(nce)
end)
`

