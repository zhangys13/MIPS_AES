main:

	lui $a0,0x1001    #set base address
	lw   $s0,00($a0)
	lw   $s1,04($a0)
	lw   $s2,08($a0)
	lw   $s3,12($a0)  #load cipher key 

	lw   $s4,16($a0)  #load cipher initial state
	lw   $s5,20($a0)
	lw   $s6,24($a0)
	lw   $s7,28($a0)
	addi $a1,$0,0     #set $a1 as round count
	lui $a2,0x8d00    #set $a2 as KeyExpansion Rcon
	addi $a3,$0,10    #set $a3 as 10
AddRoundKey:          #addround operation
	xor $s4,$s4,$s0
	xor $s5,$s5,$s1
	xor $s6,$s6,$s2
	xor $s7,$s7,$s3
	beq $a1,$a3,Finish # when round count is 10,the whole process is finished
	addi $a1,$a1,1     # when round count isnot 10,cotinue next instruction and begin next turn

SubBytes:
# col 1
	addi $t9,$s4,0
	jal  SubWords    #finish operation with sbox
	addi  $s4,$t9,0
# col 2
	addi $t9,$s5,0
	jal  SubWords
	addi  $s5,$t9,0
# col 3
	addi $t9,$s6,0
	jal  SubWords
	addi  $s6,$t9,0
# col 4
	addi $t9,$s7,0
	jal  SubWords
	addi  $s7,$t9,0
	j ShiftRows
SubWords:	

	srl  $t0,$t9,22
	andi $t0,$t0,0x03fc	 # get first byte
	srl  $t1,$t9,14
	andi $t1,$t1,0x03fc
	srl  $t2,$t9,6
	andi $t2,$t2,0x03fc
	sll  $t3,$t9,2
	andi $t3,$t3,0x03fc

	add  $t0,$t0,$a0    #get addr in sbox
	add  $t1,$t1,$a0
	add  $t2,$t2,$a0
	add  $t3,$t3,$a0
	lw   $t0,512($t0)	# put data into $t0
	lw   $t1,512($t1)
	lw   $t2,512($t2)
	lw   $t3,512($t3)

	sll  $t0,$t0,24
	sll  $t1,$t1,16
	sll  $t2,$t2,8
	add  $t9,$t0,$t1
	add  $t9,$t9,$t2
	add  $t9,$t9,$t3
	jr $ra             #get back and operate for the next vector
#################### ShiftRows ######################
ShiftRows:
# row 1
	andi $t1,$s4,0x00ff0000
	andi $s4,$s4,0xff00ffff
	andi $t2,$s5,0x00ff0000
	andi $s5,$s5,0xff00ffff
	andi $t3,$s6,0x00ff0000
	andi $s6,$s6,0xff00ffff
	andi $t4,$s7,0x00ff0000
	andi $s7,$s7,0xff00ffff
	xor  $s4,$s4,$t2
	xor  $s5,$s5,$t3
	xor  $s6,$s6,$t4
	xor  $s7,$s7,$t1
# row 2
	andi $t1,$s4,0xff00
	andi $s4,$s4,0xffff00ff
	andi $t2,$s5,0xff00
	andi $s5,$s5,0xffff00ff
	andi $t3,$s6,0xff00
	andi $s6,$s6,0xffff00ff
	andi $t4,$s7,0xff00
	andi $s7,$s7,0xffff00ff
	xor  $s4,$s4,$t3
	xor  $s5,$s5,$t4
	xor  $s6,$s6,$t1
	xor  $s7,$s7,$t2
# row 3
	andi $t1,$s4,0x00ff
	andi $s4,$s4,0xffffff00
	andi $t2,$s5,0x00ff
	andi $s5,$s5,0xffffff00
	andi $t3,$s6,0x00ff
	andi $s6,$s6,0xffffff00
	andi $t4,$s7,0x00ff
	andi $s7,$s7,0xffffff00
	xor  $s4,$s4,$t4
	xor  $s5,$s5,$t1
	xor  $s6,$s6,$t2
	xor  $s7,$s7,$t3
	beq  $a1,$a3,KeyExpansion   #judge wheather it is the tenth operation or not
#################### MixColomns #####################
MixColumns:                     # the method of operation is similar to subwords
# col 1
	addi $t9,$s4,0
	jal  MixOperation
	addi  $s4,$t9,0
# col 2
	addi $t9,$s5,0
	jal  MixOperation
	addi  $s5,$t9,0
# col 3
	addi $t9,$s6,0
	jal  MixOperation
	addi  $s6,$t9,0
# col 4
	addi $t9,$s7,0
	jal  MixOperation
	addi  $s7,$t9,0
	j KeyExpansion              #operation is finished then turn into keyexpansion
MixOperation:
# get bytes
	andi $t0,$t9,0xff000000
	andi $t1,$t9,0x00ff0000
	andi $t2,$t9,0xff00
	andi $t3,$t9,0x00ff
	sll  $t1,$t1,8
	sll  $t2,$t2,16
	sll  $t3,$t3,24
S0c02:
	sll  $t4,$t0,1                #get b6:b0
	andi $t8,$t0,0x80000000       #get b7
	beq  $t8,$0 ,S1c02
	xori $t4,$t4,0x1b000000
S1c02:
	sll  $t5,$t1,1
	andi $t8,$t1,0x80000000
	beq  $t8,$0 ,S2c02
	xori $t5,$t5,0x1b000000
S2c02:
	sll  $t6,$t2,1
	andi $t8,$t2,0x80000000
	beq  $t8,$0 ,S3c02
	xori $t6,$t6,0x1b000000	
S3c02:
	sll  $t7,$t3,1
	andi $t8,$t3,0x80000000
	beq  $t8,$0 ,MixCal
	xori $t7,$t7,0x1b000000
MixCal:
# byte 0
	xor  $t8,$t4,$t5
	xor  $t8,$t8,$t1
	xor  $t8,$t8,$t2
	xor  $t8,$t8,$t3
	addi  $t9,$t8,0
# byte 1
	xor  $t8,$t5,$t6
	xor  $t8,$t8,$t2
	xor  $t8,$t8,$t3
	xor  $t8,$t8,$t0
	srl  $t8,$t8,8
	add  $t9,$t9,$t8  
# byte 2
	xor  $t8,$t6,$t7
	xor  $t8,$t8,$t3
	xor  $t8,$t8,$t0
	xor  $t8,$t8,$t1
	srl  $t8,$t8,16
	add  $t9,$t9,$t8
# byte 3
	xor  $t8,$t7,$t4
	xor  $t8,$t8,$t0
	xor  $t8,$t8,$t1
	xor  $t8,$t8,$t2
	srl  $t8,$t8,24
	add  $t9,$t9,$t8
	jr $ra                        #operation is finished and go back
#################### KeyExpansion ####################
KeyExpansion:                     #provide key for every turn
# Rotword
	srl  $t5,$s3,24
	sll  $t6,$s3,8
	add  $t5,$t6,$t5
# SubByte
	addi $t9,$t5,0
	jal  SubWords
	addi  $t5,$t9,0
# RC02
	andi $t6,$a2,0x80000000
	sll  $a2,$a2,1
	beq  $t6,$0,KeyExpCal
	xori $a2,$a2,0x1b000000
KeyExpCal:
	xor  $s0,$s0,$t5
	xor  $s0,$s0,$a2
	xor  $s1,$s1,$s0
	xor  $s2,$s2,$s1
	xor  $s3,$s3,$s2
	j AddRoundKey
Finish:
	j Finish

	
	




