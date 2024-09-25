
loop_nasm.exe:     file format pe-x86-64

;一堆数据，可能包括各种常量之类的
Contents of section .text:
 0000 554889e5 4883ec30 e8000000 00c745fc  UH..H..0......E.
 0010 01000000 c645fb61 eb300fbe 45fb89c1  .....E.a.0..E...
 0020 e8000000 00837dfc 0d7511b9 0a000000  ......}..u......
 0030 e8000000 00c745fc 00000000 0fb645fb  ......E.......E.
 0040 83c00188 45fb8345 fc01807d fb7a7eca  ....E..E...}.z~.
 0050 b8000000 004883c4 305dc390 90909090  .....H..0]......
Contents of section .xdata:
 0000 01080305 08520403 01500000           .....R...P..    
Contents of section .pdata:
 0000 00000000 5b000000 00000000           ....[.......    
Contents of section .debug_info:
 0000 2b010000 04000000 00000801 474e5520  +...........GNU 
 0010 43313120 372e332e 30202d6d 74756e65  C11 7.3.0 -mtune
 0020 3d636f72 6532202d 6d617263 683d6e6f  =core2 -march=no
 0030 636f6e61 202d6700 0c6c6f6f 702e6300  cona -g..loop.c.
 0040 443a5c77 6f726b5c 41534d5c 6c6f6f70  D:\work\ASM\loop
 0050 00000000 00000000 005b0000 00000000  .........[......
 0060 00000000 00020106 63686172 00020807  ........char....
 0070 6c6f6e67 206c6f6e 6720756e 7369676e  long long unsign
 0080 65642069 6e740002 08056c6f 6e67206c  ed int....long l
 0090 6f6e6720 696e7400 02020773 686f7274  ong int....short
 00a0 20756e73 69676e65 6420696e 74000204   unsigned int...
 00b0 05696e74 00020405 6c6f6e67 20696e74  .int....long int
 00c0 00020407 756e7369 676e6564 20696e74  ....unsigned int
 00d0 00020407 6c6f6e67 20756e73 69676e65  ....long unsigne
 00e0 6420696e 74000201 08756e73 69676e65  d int....unsigne
 00f0 64206368 61720003 6d61696e 000104ae  d char..main....
 0100 00000000 00000000 0000005b 00000000  ...........[....
 0110 00000001 9c046a00 0105ae00 00000291  ......j.........
 0120 6c046900 01066500 00000291 6b0000    l.i...e.....k.. 
Contents of section .debug_abbrev:
 0000 01110125 08130b03 081b0811 01120710  ...%............
 0010 17000002 24000b0b 3e0b0308 0000032e  ....$...>.......
 0020 013f1903 083a0b3b 0b491311 01120740  .?...:.;.I.....@
 0030 18964219 00000434 0003083a 0b3b0b49  ..B....4...:.;.I
 0040 13021800 0000                        ......          
Contents of section .debug_aranges:
 0000 2c000000 02000000 00000800 00000000  ,...............
 0010 00000000 00000000 5b000000 00000000  ........[.......
 0020 00000000 00000000 00000000 00000000  ................
Contents of section .debug_line:
 0000 45000000 02001d00 00000101 fb0e0d00  E...............
 0010 01010101 00000001 00000100 6c6f6f70  ............loop
 0020 2e630000 00000000 09020000 00000000  .c..............
 0030 00001582 59754c2f ae679f77 9f03774a  ....YuL/.g.w..wJ
 0040 030c6659 02060001 01                 ..fY.....       
Contents of section .rdata$zzz:
 0000 4743433a 20287838 365f3634 2d77696e  GCC: (x86_64-win
 0010 33322d73 65682d72 6576302c 20427569  32-seh-rev0, Bui
 0020 6c742062 79204d69 6e47572d 57363420  lt by MinGW-W64 
 0030 70726f6a 65637429 20372e33 2e300000  project) 7.3.0..
Contents of section .debug_frame:
 0000 14000000 ffffffff 01000178 200c0708  ...........x ...
 0010 a0010000 00000000 24000000 00000000  ........$.......
 0020 00000000 00000000 5b000000 00000000  ........[.......
 0030 410e1086 02430d06 0256c60c 07080000  A....C...V......

Disassembly of section .text:

0000000000000000 <main>:
   0:	55                   	push   %rbp             ;将当前的%rbp(基址寄存器)的值压入栈中，以保存其原始值
   1:	48 89 e5             	mov    %rsp,%rbp        ;将%rsp(栈指针寄存器)的值复制到rbp中，从而更新rbp为新的栈帧基址
   4:	48 83 ec 30          	sub    $0x30,%rsp       ;从%rsp中减去30H/48个字节(在栈上分配48B的空间，用于存放局部变量或其他临时数据)
   8:	e8 00 00 00 00       	callq  d <main+0xd>     ;调用函数
   d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)  ;将立即数（$0x1）存储到相对于%rbp指向位置偏移-0x4处，j
  14:	c6 45 fb 61          	movb   $0x61,-0x5(%rbp) ;同上，即存储了两个临时变量，i
  18:	eb 30                	jmp    4a <main+0x4a>   ;无条件跳转
  1a:	0f be 45 fb          	movsbl -0x5(%rbp),%eax  ;将从栈上相对于%rbp偏移-0x5处读取一个字节的数据扩展为一个字/32位存储到%eax中，%eax=i
  1e:	89 c1                	mov    %eax,%ecx        ;%ecx=%eax
  20:	e8 00 00 00 00       	callq  25 <main+0x25>   ;调用函数
  25:	83 7d fc 0d          	cmpl   $0xd,-0x4(%rbp)  ;比较立即数0xd与相对于%rbp指向位置偏移-0x4处的值，j
  29:	75 11                	jne    3c <main+0x3c>   ;不相等跳转
  2b:	b9 0a 00 00 00       	mov    $0xa,%ecx        ;%ecx=0xa
  30:	e8 00 00 00 00       	callq  35 <main+0x35>   ;调用函数
  35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)  ;j=0
  3c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax  ;%eax=i
  40:	83 c0 01             	add    $0x1,%eax        ;%eax+=1
  43:	88 45 fb             	mov    %al,-0x5(%rbp)   ;i=%al
  46:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)  ;j+=1
  4a:	80 7d fb 7a          	cmpb   $0x7a,-0x5(%rbp) ;比较立即数0x7a与i（cmpb比较1Byte，cmpl比较4Byte）
  4e:	7e ca                	jle    1a <main+0x1a>   ;小于等于跳转
  50:	b8 00 00 00 00       	mov    $0x0,%eax        ;%eax=0
  55:	48 83 c4 30          	add    $0x30,%rsp       ;%rsp+=48
  59:	5d                   	pop    %rbp             ;从栈顶弹出值，将其存储%rbp中
  5a:	c3                   	retq                    ;从当前函数返回到调用者，并从栈中弹出返回地址，恢复%rip（指令指针寄存器）
  5b:	90                   	nop                     ;空操作/占位符
  5c:	90                   	nop
  5d:	90                   	nop
  5e:	90                   	nop
  5f:	90                   	nop