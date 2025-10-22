# 微算機期中模板
公告沒說不能用別人的模板，看到就拿去用吧

有發現問題記得回報一下

~~請別在意某些變數命名很抽象~~

## 使用說明
- ⚠️ 如果使用這個模板，盡量不要使用 btemp0 ~ btemp15 對應的 file register (預設是 0xF0 ~ 0xFF) ，這邊會拿去給模板的函式使用
- 主要程式碼寫在 `main` 跟 `GOTO meow` 之間， macro 放在 `main` 前面 ，函式實作放在 `GOTO meow` 後面
### div8
```
div8 t, a, b
```
- `t = a / b`

### mod8
```
mod8 t, a, b
```
- `t = a % b`

### shift_left8
```
shift_left8 t, x, y
```
- `t = x << y`
- 如果過程發生過溢位， C 會被設成 1

### shift_right8
```
shift_right8 t, x, y
```
- `t = x >> y`
- 如果過程發生過溢位， C 會被設成 1

### add16
```
add16 tl, th, al, ah, bl, bh
```
- `t = a + b`
### sub16
```
sub16 tl, th, al, ah, bl, bh
```
- `t = a - b`

### mul16
```
mul16 tl, tml, tmh, th, al, ah, bl, bh
```
- 前 4 bytes 是輸出
- 輸出的兩個高位單純作為溢出值或 `uint32` ， `int32` 請使用 `mul32`

### negf16
```
negf16 xl, xh
```
- `x = -x`

### int8_to_int16
```
int8_to_int16 xo, xl, xh
```
- 維持二補數性質將 int8 轉成 int16
- xo 是輸入
### int16_to_int32
```
int16_to_int32 xol, xoh, x0, x1, x2, x3
```
- 維持二補數性質將 int16 轉成 int32
- xo 是輸入
### negf32
```
negf32 x0, x1, x2, x3
```
- `x = -x`

### for loop
```
for i, num, for_loop_label, for_end_label
; 你要做的事情
for_end i, for_loop_label, for_end_label
```
- `for (;i < num;i++)`
- `for_loop_label`, `for_end_label` 是自定義的 label 名稱 ，要確保整個程式中沒有重複

### if
```
if_lower a, b, if_label, else_label
;...
else_ else_label, end_if_label
;...
end_if end_if_label
```
- 提供 `if_equ`, `if_bigger`, `if_lower`

### if16
```
if_equ16 al, ah, bl, bh, if_label, else_label
;...
else_ else_label, end_if_label
;...
end_if end_if_label
```
- 提供 `if_equ16`, `if_equ_zero_16`, `if_bigger16`, `if_lower16`
- 這專門拿來比較 `uint16`

### clz8
```
clz8 t, x
```

### sqrt8
```
sqrt8 t, x
```

### rlcf16, rrcf16, rlcf32, rrcf32
- 跟指令集上面的功能應該一樣，只是提供多 bits

### shift_left16
```
shift_left16 tl, th, xl, xh, y
```
- `t = x << y`
- 如果過程發生過溢位， C 會被設成 1

### shift_right16
```
shift_right16 tl, th, xl, xh, y
```
- `t = x >> y`
- 如果過程發生過溢位， C 會被設成 1

### div16
```
div16 tl, th, al, ah, bl, bh
```
- t = a / b

### mod16
```
mod16 tl, th, al, ah, bl, bh
```
- t = a % b

### clz16
```
clz16 t, xl, xh
```

### sqrt16
```
sqrt16 t, xl, xh
```
