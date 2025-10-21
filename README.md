# 微算機期中模板
公告沒說不能用別人的模板，看到就拿去用吧

有發現問題記得回報一下

~~請別在意某些變數命名很抽象~~

## 使用說明
⚠️ 如果使用這個模板，盡量不要使用 btemp0 ~ btemp15 對應的 file register (預設是 0xF0 ~ 0xFF) ，這邊會拿去給模板的函式使用
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
