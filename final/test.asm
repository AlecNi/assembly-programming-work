.model small
.stack 100h

.data
    ; 自定义颜色表（每个颜色由 3 个字节表示：红色、绿色、蓝色）
    ; 注意：VGA 调色板最多有 256 种颜色，每种颜色由 3 个字节表示 RGB 值
    color_table db 255, 255, 255        ; 黑色 (0, 0, 0)
              db 255, 0, 0      ; 红色 (255, 0, 0)
              db 0, 255, 0      ; 绿色 (0, 255, 0)
              db 0, 0, 255      ; 蓝色 (0, 0, 255)
              db 255, 255, 0    ; 黄色 (255, 255, 0)
              db 0, 255, 255    ; 青色 (0, 255, 255)
              db 255, 0, 255    ; 品红 (255, 0, 255)
              db 192, 192, 192  ; 浅灰色 (192, 192, 192)
              db 128,128,128
              db 128,0,0

    
.code
main:
    ; 初始化数据段
    mov ax, @data
    mov ds, ax

    ; 设置 13h 模式（640x480, 256 色）
    mov ax, 13h          ; 设置模式 13h
    int 10h              ; 调用 BIOS 中断 10h

    call draw_image

    mov cx, 100
MORE_DELAY_1:
    call delay
    loop MORE_DELAY_1

    mov al, 1
    ; 修改调色板
    call set_palette

    ; 绘制图像
    call draw_image

    mov cx, 100
MORE_DELAY_2:
    call delay
    loop MORE_DELAY_2

    mov al, 16
    ; 修改调色板
    call set_palette

    ; 绘制图像
    call draw_image

    ; 等待用户按键退出
    mov ah, 0
    int 16h

    ; 恢复文本模式（80x25）
    mov ax, 03h          ; 恢复 80x25 文本模式
    int 10h              ; 调用 BIOS 中断 10h 设置模式

    ; 退出程序
    mov ah, 4Ch
    int 21h


; 设置调色板（修改前 8 个颜色）
set_palette proc
    ; 使用 I/O 端口 0x03C8 和 0x03C9 设置调色板
    ; 0x03C8 - 设置当前调色板索引
    ; 0x03C9 - 设置调色板的 RGB 值

    ; mov al, 1            ; 设置第一个颜色（索引 0）
    mov dx, 03C8h
    out dx, al        ; 将调色板索引输出到 0x03C8

    lea si, color_table  ; 获取颜色表的地址
    mov cx, 8            ; 我们设置前 8 个颜色
    mov dx, 03C9h
set_palette_loop:
    mov al, [si]         ; 读取红色值
    out dx, al        ; 设置红色
    inc si
    mov al, [si]         ; 读取绿色值
    out dx, al        ; 设置绿色
    inc si
    mov al, [si]         ; 读取蓝色值
    out dx, al        ; 设置蓝色
    inc si
    loop set_palette_loop

    ret
set_palette endp


; 绘制图像（一个简单的填充色块）
draw_image proc
    ; 设置显存地址（VGA 显存位于 0xA0000）
    MOV ax, 0A000h
    MOV es, ax           ; 显存起始地址
    mov bx, 200
    xor di, di
BIG_LOOP:
    cmp bx, 0
    je OUT_LOOP
    dec bx
    mov cx, 320        ; 屏幕总像素数（640 * 480 = 307200 字节）

    ; 填充画面
    mov al, bl           ; 使用颜色索引 1（红色）
draw_loop:
    mov es:[di], al         ; 填充当前像素
    inc di               ; 显存地址向下移动
    loop draw_loop       ; 重复直到屏幕填满
    jmp BIG_LOOP
OUT_LOOP:

    ret
draw_image endp

; 延迟
delay proc
    push cx

    ; 简单的延迟，控制播放速度
    mov cx, 32768
delay_loop:
    loop delay_loop

    pop cx

    ret
delay endp

end main