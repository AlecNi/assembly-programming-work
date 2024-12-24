; mount d d:\work\ASM\FinalProject
; MASM video.asm
; LINK video.obj
STKSEG SEGMENT STACK 
    DW 200 DUP(0) 
STKSEG ENDS 

DATASEG SEGMENT
    ; color db 'data/colors.txt$'
    ; color_buffer db 672 dup(0)
    sound db 'data/sound.txt$'
    sound_buffer db 2400 dup(0)
    frame db 'data/pic???.txt$' ; 第一个文件名（将通过代码动态修改）
    delay_count dw 32768  ; 延迟值，用于控制帧率（每秒4帧）
    count dw 849
    pos dw 0
DATASEG ENDS

PICTURE SEGMENT 
    frame_buffer db 64672 dup(0)  ; 用来存储图像数据的缓冲区
PICTURE ENDS 

ASSUME CS:CODESEG,DS:DATASEG,SS:STKSEG,ES:PICTURE

CODESEG SEGMENT 

MAIN PROC FAR 
    ; 初始化数据段
    mov ax, DATASEG 
    mov ds, ax
    mov es, ax

    ; lea dx, color
    ; lea dx, color_buffer
    ; lea dx, frame
    ; lea dx, frame_buffer

    mov cx, 2400
    lea dx, sound_buffer
    mov bx, dx
    lea dx, sound
    call read

    ; 安装中断处理程序
    ; 将中断处理程序的地址设置为 0x08h (定时器中断)
    cli                      ; 禁用中断

    lea dx, Timer_ISR          ; 获取 Timer_ISR 偏移地址
    mov ax, 08h                ; 定时器中断向量索引为 0x08
    mov cl, 2
    shl ax, cl                 ; 每个向量占用 4 字节，乘以 4
    mov bx, ax                 ; BX 存储中断向量表的位置
    mov word ptr [bx], ds        ; 设置段地址
    add bx, 2
    mov word ptr [bx], dx        ; 设置偏移地址

    sti                      ; 启用中断

    ; 设置定时器中断处理程序
    ; 初始化定时器
    mov al, 36h                ; 设置计数器 0 的工作模式 (0011 0110)
    out 43h, al                ; 向 43h 端口发送命令（选择计数器 0）
    mov ax, 0ffffh            ; 1193180 / 1000h = 18.2
    out 40h, al
    mov al, ah
    out 40h, al
        
    ; 切换到 VGA 13h 模式（640×480 256 色模式）
    mov ax, 13h
    int 10h

    ; mov cx, 672
    ; lea dx, color_buffer
    ; mov bx, dx
    ; lea dx, color
    ; call read
    ; call set_palette

    ; 处理文件读取和显示
    mov cx, [count]  ; count 帧
    mov ax, PICTURE 
    mov es, ax
frame_loop:
    call update_filename

    ; 打开 data 文件夹下的 pic???.txt 文件
    push cx
    mov cx, 64672
    lea dx, frame_buffer
    mov bx, dx
    lea dx, frame
    call read
    pop cx

    call display

    ; 延迟控制帧率
    call delay

    loop frame_loop       ; 处理下一帧

    mov al, 30h       ; 0x30: 选择计时器 2，设置为中断触发模式（停止状态）
    out 43h, al       ; 发送控制字节到 PIT 控制端口 0x43

    ; 等待用户按键退出
    mov ah, 0
    int 16h

    ; 恢复文本模式
    mov ax, 03h
    int 10h

    ; 退出程序
    mov ah, 4Ch
    int 21h
MAIN ENDP 

; 参数在stack里，顺序为：文件名地址，缓冲区地址
; cx 保存文件大小, dx保存文件位置, bx保存缓冲区位置
read proc
    push ax
    push ds

    ; 打开 data 文件夹下的文件
    mov ah, 3Dh           ; INT 21h 打开文件功能
    mov al, 0             ; 只读模式
    int 21h               ; 调用 DOS 中断
    mov dx, bx
    mov bx, ax            ; 保存文件句柄
    jc  read_error

    ; 读取文件内容
    mov ax, es
    mov ds, ax
    mov ah, 3Fh           ; INT 21h 读取文件功能
    int 21h               ; 调用 DOS 中断
    jc  read_error

    ; 关闭文件
    pop ds
    mov ah, 3Eh           ; INT 21h 关闭文件功能
    int 21h               ; 调用 DOS 中断
read_error:
    pop ax

    ret
read endp


; 更新文件名
update_filename proc
    push ax
    push bx
    push dx

    ; 设置文件名为 frame_nnn.txt
    ; nnn 为文件编号，存储在 ah，al，bh 中
    mov ax, [count]
    sub ax, cx
    mov bx, 10
    xor dx, dx
    div bx
    push dx
    xor dx, dx
    div bx
    mov ah, al
    mov al, dl
    pop dx
    mov bh, dl
    add ah, '0'           ; 转换为字符
    add al, '0' 
    add bh, '0' 

    mov frame[8], ah  ; 将字符放入文件名位置
    mov frame[9], al
    mov frame[10], bh

    pop dx
    pop bx
    pop ax

    ret
update_filename endp


; 显示图像
display proc
    push ax
    push bx
    push cx
    push dx
    push si
    push ds

    xor bx, bx
    mov al, 32            ; 设置第一个颜色
    mov dx, 03C8h
    out dx, al        ; 将调色板索引输出到 0x03C8

    mov cx, 224            ; 我们设置后 224 个颜色
    mov dx, 03C9h
set_color_loop:
    mov al, es:[bx]         ; 读取红色值
    out dx, al        ; 设置红色
    inc bx
    mov al, es:[bx]         ; 读取绿色值
    out dx, al        ; 设置绿色
    inc bx
    mov al, es:[bx]         ; 读取蓝色值
    out dx, al        ; 设置蓝色
    inc bx
    loop set_color_loop

   ; 显示图像
   xor si, si
   mov ax, 0A000h        ; VGA 显存地址
   mov ds, ax
   mov cx, 64000         ; 每次显示 64000 个像素
display_loop:
   mov al, es:[bx]          ; 从缓冲区读取一个像素
   mov ds:[si], al       ; 将像素写入 VGA 显存
   inc bx                ; 缓冲区指针自增
   inc si
   loop display_loop     ; 循环直到显示完所有像素

;     ; 设置显存地址（VGA 显存位于 0xA0000）
;     MOV ax, 0A000h
;     MOV ds, ax           ; 显存起始地址
;     mov bx, 200
;     xor si, si
; BIG_LOOP:
;     cmp bx, 0
;     je OUT_LOOP
;     dec bx

;     mov cx, 320        ; 屏幕总像素数（320 * 200 = 64000 字节）
;     ; 填充画面
;     mov al, bl           ; 使用颜色索引
;     add al, 32
; draw_loop:
;     mov ds:[si], al         ; 填充当前像素
;     inc si               ; 显存地址向下移动
;     loop draw_loop       ; 重复直到屏幕填满
;     jmp BIG_LOOP
; OUT_LOOP:

    pop ds
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    ret
display endp


; ; 设置调色板（修改前 256 个颜色）
; set_palette proc
;     ; 使用 I/O 端口 0x03C8 和 0x03C9 设置调色板
;     ; 0x03C8 - 设置当前调色板索引
;     ; 0x03C9 - 设置调色板的 RGB 值

;     mov al, 32            ; 设置第一个颜色（索引 0）
;     mov dx, 03C8h
;     out dx, al        ; 将调色板索引输出到 0x03C8

;     lea si, color_buffer  ; 获取颜色表的地址
;     mov cx, 224            ; 我们设置后 224 个颜色
;     mov dx, 03C9h
; set_palette_loop:
;     mov al, [si]         ; 读取红色值
;     out dx, al        ; 设置红色
;     inc si
;     mov al, [si]         ; 读取绿色值
;     out dx, al        ; 设置绿色
;     inc si
;     mov al, [si]         ; 读取蓝色值
;     out dx, al        ; 设置蓝色
;     inc si
;     loop set_palette_loop

;     ret
; set_palette endp


; 定时器中断服务程序,控制声音输出
Timer_ISR proc
    ; 保存寄存器状态
    push ax
    push bx
    push cx
    push dx
    push ds
    push si
    push di

    mov ax, [pos]
    xor dx, dx
    mov bx, 3
    div bx
    cmp dx, 0
    jnz no_action
    cmp ax, 1200
    jge no_action
    mov bx, 2
    mul bx
    ; 播放简单的音效（使用 PC Speaker）
    call play_sound
no_action:
    ; 重新加载计数器，以便下次定时器中断仍然触发
    mov ax, 0ffffh          ; 重新设置计数器值
    out 40h, al             ; 低字节 (0xFF)
    mov al, ah
    out 40h, al             ; 高字节 (0xFF)

    mov ax, [pos]
    inc ax
    mov [pos], ax

    ; 发送 EOI 信号
    mov al, 20h             ; 设置 EOI 命令
    out 20h, al             ; 发送 EOI 信号到 PIC

    ; 恢复寄存器状态
    pop di
    pop si
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax

    ; 中断返回
    iret
Timer_ISR endp


; 波音，ax为指针
play_sound proc
    push ax
    push bx
    push ds

    ; 播放简单的音效（使用 PC Speaker）
    mov bx, ax
    mov ax, DATASEG 
    mov ds, ax

    ; 设置频率
    mov al, 36h           ; 控制字节 0x36 -> 设置计时器 2（用于音频），16 位计数器，模式 3（方波）
    out 43h, al           ; 发送到音频控制寄存器

    ; 音频频率 = 时钟频率 / (频率计数器值 + 1)，通常时钟频率为 1193180 Hz
    mov al, 00ffh
    mov al, sound_buffer[bx]   ; 低字节
    out 42h, al            ; 发送低字节到音频数据寄存器 0x42
    INC bx

    mov al, sound_buffer[bx] ; 高字节
    out 42h, al            ; 发送高字节到音频数据寄存器 0x42

    pop ds
    pop bx
    pop ax

    ret
play_sound endp



; 延迟
delay proc
    push ax
    push cx

    mov ax, 12
delay_loop_big:
    ; 简单的延迟，控制播放速度
    mov cx, [delay_count]
delay_loop:
    loop delay_loop
    dec ax
    jnz delay_loop_big

    pop cx
    pop ax

    ret
delay endp

CODESEG ENDS 

END MAIN 
substitute
