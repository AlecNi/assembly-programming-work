
sum.exe:     file format pe-x86-64

Contents of section .text:
 0000 554889e5 4883ec30 e8000000 00c745fc  UH..H..0......E.
 0010 00000000 c745f801 000000eb 0a8b45f8  .....E........E.
 0020 0145fc83 45f80183 7df8647e f08b45fc  .E..E...}.d~..E.
 0030 89c2488d 0d000000 00e80000 0000b800  ..H.............
 0040 00000048 83c4305d c3909090 90909090  ...H..0]........
Contents of section .rdata:
 0000 25640a00 00000000 00000000 00000000  %d..............
Contents of section .xdata:
 0000 01080305 08520403 01500000           .....R...P..    
Contents of section .pdata:
 0000 00000000 49000000 00000000           ....I.......    
Contents of section .debug_info:
 0000 3d010000 04000000 00000801 474e5520  =...........GNU 
 0010 43313120 372e332e 30202d6d 74756e65  C11 7.3.0 -mtune
 0020 3d636f72 6532202d 6d617263 683d6e6f  =core2 -march=no
 0030 636f6e61 202d6700 0c73756d 2e630044  cona -g..sum.c.D
 0040 3a5c776f 726b5c41 534d5c73 756d0000  :\work\ASM\sum..
 0050 00000000 00000049 00000000 00000000  .......I........
 0060 00000002 01066368 61720002 08076c6f  ......char....lo
 0070 6e67206c 6f6e6720 756e7369 676e6564  ng long unsigned
 0080 20696e74 00020805 6c6f6e67 206c6f6e   int....long lon
 0090 6720696e 74000202 0773686f 72742075  g int....short u
 00a0 6e736967 6e656420 696e7400 02040569  nsigned int....i
 00b0 6e740002 04056c6f 6e672069 6e740002  nt....long int..
 00c0 0407756e 7369676e 65642069 6e740002  ..unsigned int..
 00d0 04076c6f 6e672075 6e736967 6e656420  ..long unsigned 
 00e0 696e7400 02010875 6e736967 6e656420  int....unsigned 
 00f0 63686172 00036d61 696e0001 04ac0000  char..main......
 0100 00000000 00000000 00490000 00000000  .........I......
 0110 00019c04 616e7300 0106ac00 00000291  ....ans.........
 0120 6c051400 00000000 00001900 00000000  l...............
 0130 00000469 000108ac 00000002 91680000  ...i.........h..
 0140 00                                   .               
Contents of section .debug_abbrev:
 0000 01110125 08130b03 081b0811 01120710  ...%............
 0010 17000002 24000b0b 3e0b0308 0000032e  ....$...>.......
 0020 013f1903 083a0b3b 0b491311 01120740  .?...:.;.I.....@
 0030 18964219 00000434 0003083a 0b3b0b49  ..B....4...:.;.I
 0040 13021800 00050b01 11011207 000000    ............... 
Contents of section .debug_aranges:
 0000 2c000000 02000000 00000800 00000000  ,...............
 0010 00000000 00000000 49000000 00000000  ........I.......
 0020 00000000 00000000 00000000 00000000  ................
Contents of section .debug_line:
 0000 4b000000 02001c00 00000101 fb0e0d00  K...............
 0010 01010101 00000001 00000100 73756d2e  ............sum.
 0020 63000000 00000009 02000000 00000000  c...............
 0030 00168259 76000204 03910002 04036500  ...Yv.........e.
 0040 02040106 4a066908 14590206 000101    ....J.i..Y..... 
Contents of section .rdata$zzz:
 0000 4743433a 20287838 365f3634 2d77696e  GCC: (x86_64-win
 0010 33322d73 65682d72 6576302c 20427569  32-seh-rev0, Bui
 0020 6c742062 79204d69 6e47572d 57363420  lt by MinGW-W64 
 0030 70726f6a 65637429 20372e33 2e300000  project) 7.3.0..
Contents of section .debug_frame:
 0000 14000000 ffffffff 01000178 200c0708  ...........x ...
 0010 a0010000 00000000 24000000 00000000  ........$.......
 0020 00000000 00000000 49000000 00000000  ........I.......
 0030 410e1086 02430d06 0244c60c 07080000  A....C...D......

Disassembly of section .text:

0000000000000000 <main>:
   0:	55                   	push   %rbp                                     ;将%rbp寄存器的值入栈,以便之后恢复
   1:	48 89 e5             	mov    %rsp,%rbp                                ;将%rsp(栈指针寄存器)的值复制到rbp中，从而更新rbp为新的栈帧基址
   4:	48 83 ec 30          	sub    $0x30,%rsp                               ;从%rsp中减去30H/48个字节(在栈上分配48B的空间，用于存放局部变量或其他临时数据)
   8:	e8 00 00 00 00       	callq  d <main+0xd>                             ;调用函数main
   d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)                          ;将立即数（$0x0）存储到相对于%rbp指向位置偏移-0x4处，ans
  14:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)                          ;将立即数（$0x1）存储到相对于%rbp指向位置偏移-0x8处，i
  1b:	eb 0a                	jmp    27 <main+0x27>                           ;无条件跳转,进行for循环的条件判断
  1d:	8b 45 f8             	mov    -0x8(%rbp),%eax                          ;%eax=i
  20:	01 45 fc             	add    %eax,-0x4(%rbp)                          ;ans+=%eax
  23:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)                          ;++i
  27:	83 7d f8 64          	cmpl   $0x64,-0x8(%rbp)                         ;比较100和i
  2b:	7e f0                	jle    1d <main+0x1d>                           ;i<=100,继续循环,跳转到1d
  2d:	8b 45 fc             	mov    -0x4(%rbp),%eax                          ;ans=%eax
  30:	89 c2                	mov    %eax,%edx                                ;%edx=%eax
  32:	48 8d 0d 00 00 00 00 	lea    0x0(%rip),%rcx        # 39 <main+0x39>   ;计算RIP（指令指针）加上偏移量0后的有效地址，并将结果存入寄存器%rcx
  39:	e8 00 00 00 00       	callq  3e <main+0x3e>                           ;调用函数printf
  3e:	b8 00 00 00 00       	mov    $0x0,%eax                                ;%eax=0
  43:	48 83 c4 30          	add    $0x30,%rsp                               ;%rsp+=30H,回收字节
  47:	5d                   	pop    %rbp                                     ;从栈顶弹出值，恢复%rbp
  48:	c3                   	retq                                            ;从当前函数返回到调用者，并从栈中弹出返回地址，恢复%rip（指令指针寄存器）
  49:	90                   	nop                                             ;空操作/占位符
  4a:	90                   	nop
  4b:	90                   	nop
  4c:	90                   	nop
  4d:	90                   	nop
  4e:	90                   	nop
  4f:	90                   	nop
