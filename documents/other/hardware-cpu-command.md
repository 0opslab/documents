title: CPU的指令集
date: 2016-01-08 22:22:22
tags:
    - asm
categories: asm
---
指令集是CPU能性能的一种体现也是程序最终的执行载体。不论什么语言编写的程序最终度会转换成CPU的指令。
下面是x86架构上的一些通用的指令。至于其他架构的指令集都是大同小异，抓住指令的作用。不要记住名字！

CPU的指令系统的分为以下几大类
 数据传送指令  循环指令
 标志位操作指令  转移指令
 算术运算指令  条件设置字节指令
 逻辑运算指令  字符串操作指令
 移位操作指令  ASCII-BCD码运算调整指令
 位操作指令  处理器指令
 比较运算指令

# 数据传送指令
 数据传送指令又分为：传送指令、交换指令、地址传送指令、堆栈操作指令、转换指令和I/O指令。
 除了标志位操作指令sahf和popf指令外，本类的其他指令都不影响标志位。

# 传送指令
 MOV REG/MEM,REG/MEM/IMM 其中reg—register寄存器，mem-memory存储器，imm-immediate立即数
 功能：
  是把源操作数（第二个）的值传个目的操作数（第一个）。
 规定：
  1.俩个操作数的数据类型要相同。
  2.俩个操作数不能同时为段寄存器。
  3.代码段寄存器CS不能做为目的操作数，但可以作为源操作数。
  4.立即数不能直接传给段寄存器。
  5.立即数不能做为目的操作数。
  6.指令指针IP，不能做为MOV指令的操作数。
  7.俩个操作数不能同时为存储单元。
# 传送填充指令
 指令的主要功能和规定与MOV指令类似。不同之处在与对目的操作数的高位进行填充的时候，根据填充
 方式有分为符号填充和零填充。

# 符号填充指令
 MOVSX :用源操作数的符号位来填充目的操作数的高位数据位。
 零填充指令 MOVZX :恒用0来填充目的操作数的高位数据。
# 交换指令
 交换指令XCHG是俩个寄存器，寄存器和内存变量之间的内容交换指令。要求俩个操作数之间的类型相同
 格式：
  XCHG REG/MEM,REG/MEM
# 取有效地址指令

 指令LEA是把一个内存变量的有效地址送给指定的寄存器。
 格式：
  LEA REG,MEM
  该指令通常用来对指针会变址寄存器BX,DI或SI等置初值之用。
 取段寄存器指针
 该“组”指令的功能是把内存单元的一个“低字”传送给指令中指定的16位寄存器。把随后的一个“高字”
 传送给相应的段寄存器（DS\ES\FS\GS\SS）.
 指令的格式:LDS/LES/LFS/LGS/LSS REG,MEM
 若reg是16位寄存器，那么men必须是32位指针；若reg是32位寄存器，那么MEN必须是48位指针，其低32位
 给指令中指定的寄存器，高16位给指令中的段寄存器。
  堆栈操作指令(Stack Operation Instruction)
 进栈操作
  PUSH(Push Word or Doubleword onto Stack)
   指令格式：PUSH　Reg/Mem/imm
　　　　　　　　 一个字进栈，系统自动完成两步操作：SP←SP-2，(SP)←操作数；
   一个双字进栈，系统自动完成两步操作：ESP←ESP-4，(ESP)←操作数。
  PUSHA(Push All General Registers)
   指令格式：PUSHA
   其功能是依次把寄存器AX、CX、DX、BX、SP、BP、SI和DI等压栈。
  PUSHAD(Push All 32-bit General Registers)
   指令格式：PUSHAD
   其功能是把寄存器EAX、ECX、EDX、EBX、ESP、EBP、ESI和EDI等压栈。
 出栈操作
  POP(Pop Word or Doubleword off Stack)
   指令格式：POP　Reg/Mem
   弹出一个字，系统自动完成两步操作：操作数←(SP)，SP←SP-2；
   弹出一个双字，系统自动完成两步操作：操作数←(ESP)，ESP←ESP-4。
  POPA(Pop All General Registers)
   令格式：POPA
   其功能是依次把寄存器DI、SI、BP、SP、BX、DX、CX和AX等弹出栈。
  POPAD(Pop All 32-bit General Registers)
   指令格式：POPAD
   其功能是依次把寄存器EDI、ESI、EBP、ESP、EBX、EDX、ECX和EAX等弹出栈.

# 标志位操作指令
 进位CF操作指令
  清进位指令CLC (Clear Carry Flag): CF 置 0
  置进位指令STC (Set Carry Flag)： CF 置 1
  进位取反指令 CMC : CD = NOT CF

# 方向位DF操作指令
  清方向位指令 CLD（clear direction flag）DF =0
  置方向位指令 STD （SET DIRECTION FLAG） DF =1
# 中断准许位IF操作指令
  清中断准许位指令CLI（clear Internetrupt flag） if =0
      功能是不准许可屏蔽的外部中断来中段其后程序的执行。
  置中断准许位指令STI（set interrupt flag） if=1
      其功能是回复可屏蔽的外部中断的中断响应功能能。
# 取标志位的操作指令
  LAHF (LOAD AH FROM FLAGS) AH = FLAGS的低8位
  SAHF (STROE AH IN FLAGS) FLAGS的低8位 = AH
 标志位堆栈操作指令
  PUSHF/PUSHFD (push flags onto stack) 把16/32位标志寄存器进栈。
  POPF/POPFD(POP FLAGS OFF STACK):把16/32位标志寄存器出栈。


# 算术运算指令
 加法指令
# 加法指令ADD
   指令的格式：ADD REG/MEM ,REG/MEM/IMM
   受影响的标志位 AF CF OF PF SF ZF
   指令的功能是把源操作数的值加到目的的操作数中。
# 带进位加指令ADC
   指令的格式：ADC REG/MEM ,REG/MEM/IMM
   受影响的标志位：AF CF OF PF SF ZF
   指令的功能是把源操作数和进位标志位CF的值（0/1）一起加到目的的操作数中
# 加1指令 INC
   指令的格式：INC reg/mem
   受影响的标志位AF OF PF SF ZF 不影响CF
   指令的功能是把操作数的值加1
# 交换加指令XADD (EXchange and add)
   指令的格式:XADD REG/MEM ,REG
   受影响的标志位:AF CF OF PF SF ZF
   指令的功能是先交换俩个操作数的值，再进行算术“加”。
# 减法指令
  减法指令SUB
   指令的格式SUB reg/MEM,REG/MEM/IMM
   受影响的标志位：AF CF OF PF SF ZF
   指令的功能是从目的操作数中减去源操作数。
# 带错位见SBB
   指令的格式：SBB REG/MEM,REG/MEM/IMM
   受影响的标志位 AF,CF,OF,PF,SF,ZF
   指令的功能是把元操作数和标志为CF的值从目的操作数中一起减去。
# 减1指令DEC
   指令的格式：DEC REG/MEM
   受影响的标志位AF OF PF SF ZF 不影响CF
   指令的功能是把操作数的值减1
# 求补指令NEG
   指令的格式NEG REG/MEM
   受影响的标志位AF CF OF PF SF ZF
   指令的功能：操作数= 0-操作数，即改变操作数的正负号。

# 乘法指令
     计算机的乘法指令分为无符号乘法指令和有符号乘法指令，他们唯一的区别就在于，数据的最高位是作为
     “数值”参与运算还是作为“符号位”参与运算。
#无符号数乘法指令MUL
   指令的格式：MUL reg/MEM
   受影响的标志位：CF OF (AF PF SF ZF 无定义)
   指令的功能是把显式操作数和隐含的操作数都作为无符号数相乘，所得的结果存放关系：
   -----------------------------------------------------------------------------
   乘数位数 隐含的被乘数  乘积的存放位置   举例
   8位  AL   AX    MUL BL
   16位  AX   DX-AX    MUL BX
   32位  EAX   EDX-EAX    MUNL ECX
# 有符号数乘法指令IMUL
   指令的格式：  IMUL Reg/Mem
     IMUL Reg, Imm   ;80286+
     IMUL Reg, Reg, Imm  ;80286+
     IMUL Reg, Reg/Mem  ;80386+
   受影响的标志位：CF和OF(AF、PF、SF和ZF无定义)
   1)、指令格式1——该指令的功能是把显式操作数和隐含操作数相乘
   2)、指令格式2——其寄存器必须是16位/32位通用寄存器，其计算方式为：
    Reg ← Reg × Imm
   3)、指令格式3——其寄存器只能是16位通用寄存器，其计算方式为：
    Reg1 ← Reg2×Imm  或  Reg1 ← Mem×Imm
   4)、指令格式4——其寄存器必须是16位/32位通用寄存器，其计算方式为：
    Reg1 ← Reg1×Reg2  或  Reg1 ← Reg1×Mem
# 除法指令
   除法指令的被除数是隐含操作数，除数在指令中显式地写出来。CPU会根据除数是8位、16位，还是32位，
   来自动选用被除数AX、DX-AX，还是EDX-EAX。除法指令功能是用显式操作数去除隐含操作数，可得到商
   和余数。当除数为0，或商超出数据类型所能表示的范围时，系统会自动产生0号中断。
# 无符号数除法指令DIV
   指令的格式：DIV  Reg/Mem
   指令的功能是用显式操作数去除隐含操作数(都作为无符号数)，
# 有符号数除法指令IDIV
  指令的格式：IDIV  Reg/Mem
  受影响的标志位：AF、CF、OF、PF、SF和ZF
  指令的功能是用显式操作数去除隐含操作数(都作为有符号数)，所得商和余数
  --------------------------------------------------------------------
  除数位数 隐含的被除数  商 余数  举例
  8位  AX   AL      AH  DIV BH
  16位  DX-AX   AX DX  DIV BX
  32位  EDX-EAX   EAX EDX  DIV EBX
# 强制类型转换指令CBW CWD CWDE CDQ(CONVENT BYTE TO WORD)
  字节转换为字指令CBW
   指令格式:CBW
   指令的隐含操作数为AH 和AL 其功能是用AL的符号位去填充AH即当AL为正数
    AH=0 否则AH=OFFH,指令不影响任何标志位。
# 字转换值双字指令CWD
   指令格式:CWD
   指令的隐含操作数为DX和AX 其功能是用AL的符号位去填充AX即当DX为正数
    AH=0 否则AH=OFFH,指令不影响任何标志位。
# 字转换为扩展的双字指令CWDE
   指令格式:CWDE
   指令的隐含操作数为DX和AX 其功能是用AX的符号位去填充EAX即当DX为正数
    AH=0 否则AH=OFFH,指令不影响任何标志位。
# 双字转换为四字指令 CDQ
   指令格式:CDQ
   指令的隐含操作数为EDX和EAX 其功能是用EAX的符号位去填充EDX即当DX为正数
    AH=0 否则AH=OFFH,指令不影响任何标志位。
# 逻辑运算指令
       逻辑运算指令的是一组重要的指令，它包括逻辑与AND 逻辑或OR 逻辑非NOT 和异或指令XOR
# 逻辑与指令AND
   指令的格式：AND reg/mem, reg/mem/imm
   受影响的标志位：cf(0) of (0) pf sf af
   指令的功能是把源操作数中的每位二进制与目的操作数的相应二进制进行逻辑与操作
   ，结果存入目的操作。
# 逻辑或操作指令OR
   格式OR reg/mem，reg/mem/imm
   受影响的标志位 cf(0) of(0) pf sf zf
   指令的功能是把源操作数中的每位二进制与目的操作数中的相信二进制进行逻辑或操作，
   结果存入目标操作数中。
# 逻辑非操作指令NOT
   指令的格式NOT reg/MEM
   功能是把操作数中的每位变反，即0变1，1变0 指令的执行不影响任何标志位。
# 逻辑异或操作指令XOR
   指令的格式：XOR  reg/mem,reg/mem/imm
   受影响的标志位CF(0) OF(0) PF SF ZF
   指令的功能是把源操作数中的每位二进制与目的操作数中的相应二进制进行逻辑异或操作
   结果存入目标操作数中。
# 移位操作指令
 移位操作指令是一组经常使用的指令，它包括算术移位、逻辑移位、双精度移位、循环移位、带进位的循环移位等五大类。
# 算术移位指令：
   算术左移 SAL(SHIFT ALGEBRAIC LEFA)算术右移SAR( shift algebraic right)
   指令的格式：SAL/SAR  REG/MEM ,CL/IMM
   受影响的标志位CF OF PF SF ZF
   算术左移SAL把目的操作数的低位向高位移，空出的低位补0
   算术右移SAR把目的操作数的高位向低位移，空出的高位用最高位(即符号)填充。
# 逻辑移位指令
   逻辑左移SHL(shift logical left)逻辑右移SHR(shfit logical right)
   指令的格式：SHL/SHR reg/mem，cl/imm
   受影响的标志位：CF OF PF SF ZF
   逻辑左移/右移指令只有他们的移位方向不同，移位后空出的都补0。
# 双精度移位指令
   双进度左移SHLD(SHOFT LEFT DOUBLE) 和双精度右移SHRD(SHIFT RIGHT DOUBLE)他们都是具有三个操作
   数的指令。
   格式：SHLD/SHRD REG/MEM,REG,CL/IMM  ;80386
    其中的第一个操作数是一个16位/32位的寄存器或存储单元，第二个操作数(与前者具有相同位数)
    一定是寄存器。第三个是移位的操作数，它有CL或一个立即数来确。
   在执行SHLD指令时，第一操作数向左移n位，其“空出”的低位由第二操作数的高n位来填补
   ，但第二操作数自己不移动、不改变。
   在执行SHRD指令时，第一操作数向右移n位，其“空出”的高位由第二操作数的低n位来填补
   ，但第二操作数自己也不移动、不改变
# 循环移位指令
   循环移位指令有ROL(ROTATE LEFT) 和循环右移指令ROR(rotate right)
   指令格式：ROL/ROR reg/MEM ，cl/IMM
   受影响的标志位CF和OF
   循环左移/右移只是移位方向不同，他们移出的位不仅要进入CF而且还要填充移出的空位。
# 带进位的循环移位指令
   带进位的循环指令有：带进位的循环左移RCL(ROTATE LEFT THROUGH CARRY)带进位的循环右移RCR
   指令的格式 RCL/RCR reg/mem,CL/IMM
   受影响的标志为CF OF
   带进位的循环左移/右移指令只有移位的方向不同，他们都用原CF的值填补空出的位，移出的位再进入CF。
# 位操作指令
  位扫描指令(BIT SCAN INSTRUCTION)
   指令的格式：BSF/BSR reg，reg/MEM    ；80386+
   受影响的标志位zf
   位扫描指令是第二个操作数中找第一个“1”,如果找到，则该"1"的位置保存在第一个操作数中，
   并置标志位ZF为1，否则ZF为0.
   BSF正向扫描指令，从右向左扫描即：从低位向高位扫描
   BSR逆向扫描指令，从左向由扫描即：从高位向低位扫描
# 位检测指令(bit test instrction)
   指令的格式BT/BTC/BTR/BTS REG/MEM,REG/IMM ;80386+
   受影响的标志位CF
   位检测指令是把第一个操作数中的某一位的值传送给标志位CF，具体的那一位有指令的第二个操作数决定。
   BT：把指定的位传送给CF；
   BTC：把指定的位传送给CF后，还使该位变反；
   BTR：把指定的位传送给CF后，还使该位变为0；
   BTS：把指定的位传送给CF后，还使该位变为1；
# 检测位指令TEST
   检测位指令是把二个操作数进行逻辑“与”操作，并根据运算结果设置相应的标志位，但并不保存结果，所以
   不会改变指令中的操作数。在该指令后常用JE,JNE,JZ,JNZ等条件转移指令。
   指令的格式：TEST REG/MEM,REG/MEM/IMM
   受影响的标志位CF(0) OF(0) PF SD ZF


# 比较指令
  比较指令CMP
   指令格式：CMP REG/MEM,REG/MEM/IMM
   受影响的标志位AF CF OF PF SF ZF
   指令的功能：用第二个操作数减去第一个操作数，并根据所得的差设置有关的标志位，为随后的条件转移指令
   提供条件，但并不保存该结果，所以不会改变指令中的操作数。
  比较交换指令
   比较交换指令先进行比较，在根据比较的结果决定是否要对操作数进行交换操作，当俩个数相等的时候，置标志
   ZF为1，否则把第一操作数的值赋值给第二个操作数，并置标志位ZF为0
   8位/16位/32位比较交换指令
   指令的格式CMPXCHG REG/MEM,AL/AX/EAX
   受影响的标志位AF CF OF PF SF ZF
   64位比较指令
   该指令只有一个操作数第二个操作数EDX:EAX是隐含的。
   指令的格式：CMPXCHG8B  REG/MEM   ;PENTIUM+
   受影响的标志位ZF
# 循环指令
  汇编语言提供了多种循环指令，这些循环指令的循环次数都是保存在技术器CX或ECX。但又得循环指令还可根据标志位ZF来
  决定是否结束循环。
  循环指令LOOP
  该指令的一般格式：
   LOOP 标号
   LOOPW 标号 ；cx做为循环计数器，80386+
   LOOPD 标号 ;ECX做为循环计数器,80386+
   循环指令的功能描述：(cx)=(cx)-1或者(ecx)=(ecx)-1
     如果(cx)不等于0或者(ecx)不等于0转向标号所指向的指令，否则终止循环，指令该指令下面的指令
  相等或为零循环指令的一般格式：
   LOOPE/LOOPZ 标号
   LOOPEW/LOOPZW 标号 ；CX作为循环指令的计数器
   LOOPED/LOOPZD 标号 ；ECX作为循环指令的计数器
   这是一组有条件循环的指令，他们除了要接受CX或ECX得影响外，还受标志位ZF的影响。
   (cx)=(cx)-1或(ecx)=(ecx)-1
   如果循环计数器的值不为0且ZF=1，则程序转到循环体的第一条指令，否则程序将执行该循环体指令下面的指令
  不等或不为零循环指令的一般格式：
   LOOPNE/LOOPNZ 标号
   LOOPNEW/LOOPNZW 标号 ；CX作为循环指令的计数器
   LOOPNED/LOOPNZD 标号 ；ECX做为循环指令的计数器
   (cx)=(cx)-1 或(ecx)=(ecx)-1
   如果循环计数器的值不等于0且ZF=0,则程序转到循环体的第一条指令。否则程序将执行该循环指令的下面的指令。
  循环计数器为0转指令
   上述的各类循环指令种，不管循环计数器的初值为何，循环体都会执行一次。当循环计数器的初值为0的时候
   几乎是个死循环，为解决这个问题指令系统提供了一条与循环指令计数器有关的指令---循环计数器为零调转指令
   该指令的格式：
    JCXZ 标号 ；当CX=0时 则程序转移到标号处执行(jmp cx zero)
    JECXZ 标号；当ECX=0时 则程序转移到标号处执行
# 转移指令
  转移指令为无条件转移指令和有条件转移指令
   无条件转移指令 JMP
   格式：JMP 标号/REG/MEM
   指令是从当前程序执行的地方无条件转移到另一个地方执行。这种转移可以是一个短转移(short)，近转移(near)
   远转移(far)
   短转移和近转移时段内的转移，JMP指令只是把目标指令的位置的偏移量赋值指令指针寄存器IP，从而实现转移，但
   远转移时段间的转移，JMP指令不当要指名指针指令寄存器IP还要指明代码段寄存器CS的值。
##  条件转移指令
      条件转移只是根据标志寄存器的一个或者多个标志位来决定是否需要转移
      条件转移指令又分为三大类：基于无符号的条件转移指令，基于有符号的条件转移指令和基于特殊算术标志位的条件转移指令
##   无符号的条件转移指令
    ----------------------------------------------------------------------------------------------
## 指令的助记符  检测的转移条件  功能描述
    JE/JZ   ZF=1   JUMP EQUAL OR JUMP ZERO
    JNE/JNZ   ZF=0   JUMP NOT EQUAL OR JUMP NOT ZERO
    JA/JNBE   CF=0 and ZF=0   JUMP ABVOE OR JUMP NOT BELOW OR EQUAL
    JAE/JNB   CF=0   JUMP ABOVE OR EQUAL OR JUMP NOT BELOW
    JB/JNAE   CF=1   JUMP BELOW OR EQUAL NOT ABOVE OR EQUAL
    JBE/JNA   CF=1 OR AF=1  JUMP BELOW OR EQUAL OR JUMP NOT ABLOW
    -----------------------------------------------------------------------------------------------
## 有符号数的条件转移指令
    ----------------------------------------------------------------------------------------------
    指令的助记符  检测的转移条件  功能描述
    JE/JZ   ZF=1   JUMP EQUAL OR JUMP ZERO
    JNE/JNZ   ZF=0   JUMP NOT EQUAL OR JUMP NOT ZERO
    JG/JNLE   ZF=0 and SF=OF  JUMP GREATER OR JUMP NOT LESS OR EQUAL
    JGE/JNL   SF=OF   JUMP GREATER OR EQUAL OR JUMP NOT LESS
    JL/JNGE   SF不等于OF  JUMP LESS OR JUMP NOT GREATER OR EQUAL
    JLE/JNG   ZF=1 OR SF不等于OF JUMP LESS OR EQUAL OR JUMP NOT GREATER
    ----------------------------------------------------------------------------------------------
## 特殊算术标志位的条件转移指令
    ----------------------------------------------------------------------------------------------
    指令的助记符  检测的转移条件  功能描述
    JC   CF=1   JUMP CARRY
    JNC   CF=0   JUMP NOT CARRY
    JO   OF=1   JUMP OVERFLOW
    JNO   OF=0   JUMP NOT OVERFLOW
    JP/JPE   PF=1   JUMP PARITY OR JUMP PARITY EVEN
    JNP/JPO   PF=0   JUMP NOT PARITY OR JUMP PARITY ODD
    JS   SF=1   JUMP sign（negative）
    JNS   SF=0    JUMP NO SIGN(POSITIVE)
    -----------------------------------------------------------------------------------------------
# 条件设置字节指令
  条件设置字节指令是80386+CPU所具有的一组指令。他们在测试条件方面与条件转移指令是一致的，但在功能方面，他们是不转移
  而是根据设置其字节操作的内容为1或0
  条件设置指令的一般格式：
   SETnn reg/mem nn表示测试条件，操作数只是8位寄存器或者一个字节单元。
   -----------------------------------------------------------------------
   指令助记符   操作数和检测条件之间的关系
   SETZ/SETE   REG/MEM = ZF
   SETNZ/SETNE   REG/MEM =NOT ZF
   SETS    REG/MEM = SF
   SETNS    REG/MEM = NOT SF
   SETO    REG/MEM = OF
   SETNO    REG/MEM = NOT OF
   SETP/SETPE   REG/MEM = PF
   SETNP/SETNPO   REG/MEM = NOT OF
   SETC/SETB/SETNAE  REG/MEM = CF
   SETNC/SETN/SETAE  REG/MEM = NOT CF
   SETNA/SETBE   REG/MEM =(CF OR ZF)
   SETA/SETNBE   REG/MEM = NOT(CF OR ZF)
   --------------------------------------------------------------------
# 字符串操作指令
 字符串操作指令的实质是对一片连续的存储单元进行处理，这片存储单元是有隐含的DS、SI和ES、DI
 来指定的，字符串操作指令可对内存单元按字节、字或双字节、进行处理并能根据操作的对象的字节
 数使编制寄存器SI（和DI）增减1、2、4。
 具体规定如下：
  当DF=0时变址寄存器SI(DI) 增加1、2、4
  当DF=1时变址寄存器SI(DI) 减少1、2、4
# 取字符串数据指令(load string instruction)
  从由指针DS:SI所指向的内存单元开始，取一个字节、字、双字节进入AL、AX、或EAX并根据标志位DF对寄存器SI做出相应的增减
  该指令的执行不会影响任何标志位。
  指令的格式：LODS 地址表达式
       LODSB/LODSW
       LODSD
       在指令LODS中，它会根据其地址表达式的属性来决定读取一个字节、字或双字。
# 置字符串数据指令
  该指令是把寄存器AL AX 或者EAX中的值存于以指针ES:DI所指指向的内存单元为起始的一片存储单元里，并根据标志位DF对寄存器DI
  做相应增减。该指令不影响任何标志位。
   STOS 地址表达式
   STOSB/STOSW
   STOSD
# 字符串传送指令(MOVE STRING INSTRUCTION)
  该指令是把指针DS:SI所指向的字节、字或双字传送给指针ES:DI所指向的内存单元，并根据标志位DF对寄存器
  DI和SI做相应的增减。该指令的执行不影响任何标志位、
  指令的格式：MOVS  地址表达式1，地址表达式2
       MOVSB /MOVSW
       MOVSB
# 输入字符串指令(input string instruction)
  该指令时从某一指定的端口接收一个字符串，并存放入一片存储单元之中。输入端口由DX来指定，存储单元的
  首地址和读入数据的个数分别有ES.DI和CX来确定，在指令执行的过程中，还根据标志位DF对寄存器DI做相应的
  增减，该指令不会影响任何的标志位。
  与指令有关的操作数ES.DI DX和CX等都是隐含操作数。
  指令的格式：INS 地址表达式
      INSB/INSW
      INSD
# 输出字符串指令(output string instruction)
  该指令是吧一个字符串输入到指定的端口中。输出的端口有DX指定，其输出数据的首地址个个数分别由DS:SI和
  CX来确定。在执行过程当中还会根据标志位DF对寄存器SI做相应的增减，该指令的执行不会影响任何标志位。
  与指令有关的操作数DS、SI、DX和CX等都是隐含操作数。
  指令的是格式：
    OUTS 地址表达式
    OUTSB/OUTSW
    OUTSD
 字符串比较指令(Compare String Instruction)
  该指令是把指针DS:SI和ES:DI所指向字节、字或双字的值相减，并用所得到的差来设置有关的标志位。与此同时
  ，变址寄存器SI和DI也将根据标志位DF的值作相应增减。
  指令的格式：CMPS　地址表达式1, 地址表达式2
    CMPSB/CMPSW
    CMPSD　　　　　　;80386+
  受影响的标志位：AF、CF、OF、PF、SF和ZF
# 字符串扫描指令(Scan String Instruction)
  该指令是用指针ES:DI所指向字节、字或双字的值与相应的AL、AX或EAX的值相减，用所得到的差来设置有关标志位
  与此同时，变址寄存器DI还将根据标志位DF的值进行增减。
   指令的格式：SCAS　地址表达式1
    SCASB/SCASW
    SCASD　　　　　　;80386+
   受影响的标志位：AF、CF、OF、PF、SF和ZF
# 重复字符串操作指令（repeat string instruction）
  重复前缀指令REP(Repeat String Instruction)
   复前缀指令是重复其后的字符串操作指令，重复的次数由CX来决定。其一般格式为：
    REP　LODS/LODSB/LODSW/LODSD
    REP　STOS/STOSB/STOSW/STOSD
    REP　MOVS/MOVSB/MOVSW/MOVSD
    REP　INS/ INSB/INSW/INSD
    REP　OUTS/OUTSB/OUTSW/OUTSD
   重复前缀指令的执行步骤如下：
   (1)、判断：CX=0；
   (2)、如果CX=0，则结束重复操作，执行程序中的下一条指令；
   (3)、否则，CX=CX-1(不影响有关标志位)，并执行其后的字符串操作指令，在该指令执行完后，再转到步骤(1)。
  条件重复前缀指令(Repeat String Conditionally)
    条件重复前缀指令与前面的重复前缀指令功能相类似，所不同的是：其重复次数不仅由CX来决定，而且还
    会由标志位ZF来决定。根据ZF所起的作用又分为二种：相等重复前缀指令REPE/REPZ和不等重复前缀指令REPNE/REPNZ。
   A、相等重复前缀指令的一般格式为：
   REPE/REPZ　SCAS/SCASB/SCASW/SCASD
   REPE/REPZ　CMPS/CMPSB/CMPSW/CMPSD
   该重复前缀指令的执行步骤如下：
   (1)、判断条件：CX≠0 且 ZF=1；
   (2)、如果条件不成立，则结束重复操作，执行程序中的下一条指令；
   (3)、否则，CX=CX-1(不影响有关标志位)，并执行其后的字符串操作指令，在该指令执行完后，再转到步骤(1)。
   B、不等重复前缀指令的一般格式为：
   REPNE/REPNZ　SCAS/SCASB/SCASW/SCASD
   REPNE/REPNZ　CMPS/CMPSB/CMPSW/CMPSD
   该重复前缀指令的执行步骤如下：
   (1)、判断条件：CX≠0 且 ZF=0；
   (2)、如果条件不成立，则结束重复操作，执行程序中的下一条指令；
   (3)、否则，CX=CX-1(不影响有关标志位)，并执行其后的字符串操作指令，在该指令执行完后，再转到步骤(1)。
# 处理器指令
 处理器指令是一组控制CPU工作方式的指令。这组指令的使用频率不高。
 1、空操作指令NOP(No Operation Instruction)
  该指令没有的显式操作数，主要起延迟下一条指令的执行。通常用执行指令“XCHG AX, AX”来代表它的执行。
  NOP指令的执行不影响任何标志位。
  指令的格式：NOP
 2、等待指令WAIT(Put Processor in Wait State Instruction)
  该指令使CPU处于等待状态，直到协处理器(Coprocessor)完成运算，并用一个重启信号唤醒CPU为止。
  该指令的执行不影响任何标志位。
  指令的格式：WAIT
 3、暂停指令HLT(Enter Halt State Instruction)
  在等待中断信号时，该指令使CPU处于暂停工作状态，CS:IP指向下一条待执行的指令。当产生了中断信号，CPU把CS和IP压栈，
  并转入中断处理程序。在中断处理程序执行完后，中断返回指令IRET弹出IP和CS，并唤醒CPU执行下条指令。
  指令的格式：HLT
  指令的执行不影响任何标志位。
 4、封锁数据指令LOCK(Lock Bus Instruction)
  该指令是一个前缀指令形式，在其后面跟一个具体的操作指令。LOCK指令可以保证是在其后指令执行过程中，禁止协处理器修
  改数据总线上的数据，起到独占总线的作用。该指令的执行不影响任何标志位。
  指令的格式：LOCK INSTRUCTION
