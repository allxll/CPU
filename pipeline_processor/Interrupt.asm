#  CPU design experiment  7/11/2017   
j Main
j Interrupt
j Exception
########### Normal Process ##################
Main:
#####################################
#		Timer Startup				#
#####################################

	

	lui $t0, 0x4000                    # 0c
	ori $t0, $t0, 0x0008			   # 10

	sw $zero, 0($t0)    # set TCON to be 0, stop timer.

##############################################
##		Pipeline  Test Purpose Only          #
##############################################
#	addi $t1, $zero, 1
#	sw $t1, 0($t0)    #  set TCON = 1, start timer, disable intterupt
#	addi $t1, $t1, -1
#	lw $t3, 0($t0)       # 20
#	add, $t1, $t1, $t3 
#############################################


	lui $t2, 0xffff
	ori $t2, $t2, 0xffe0
	sw $t2, -8($t0)    # set TH to be 32? clock timer.

	ori $t2, $t2, 0xffff
	sw $t2, -4($t0)   # set TL to be 0xffffffff

	addi $t1, $zero, 0   
	sw $t1, 0($t0)     # set TCON = 0, stop timer, disable interrupt






######################################
	
	# Main Function


######################################


	##########################
	# GCD  Program
	##########################
	#  line 14
#	add $v0, $zero, $zero
#	Read:
#		lw $s0, 24($t0)
#		andi $s0, $s0, 0x0008 
#		bgtz $s0, Write
#		j Read
#	Write_1:
#		lw $a0, 20($t0)   # load the first number to $a0
#		addi $v0, $v0, 1
#		j Read
#	Write:
#		sw $zero, 24($t0)    # UARTCON = 5'b0 manually , mainly to reset UARTCON[3]
#		beq $v0, $zero, Write_1
#		lw $a1, 20($t0)     # load the second number to $a1
#
#
#	initial:
#		add $s0, $a0, $zero
#		add $s1, $a1, $zero
#
#	lp1:
#		add $t2,$zero,$s0	
#		add $s0,$zero,$s1	
#		add $s1,$zero,$t2	
#		slt $t3,$s1,$s0		
#		beq $t3,$zero,lp2	
#		add $t2,$zero,$s0	
#		add $s0,$zero,$s1	
#		add $s1,$zero,$t2	
#	lp2:
#		sub $s1,$s1,$s0	
#		slt $t3,$s0,$s1	   # 36s	
#		beq $t3,$zero,eq	
#		j lp2			
#	eq:
#		beq $s1,$zero,end   
#		j lp1
#	end:
#		sw $s0, 16($t0)    # send uart
#		sw $s0, 4($t0)     # set led
#		addi $t1, $zero, 3
#		sw $t1, 0($t0)    #  start timer, enable interruption
#	Loop:
#		blez $zero, Loop


		#########################
		# Uart Evaluation Program
		#########################
#	Read:
#		lw $s0, 24($t0)
#		andi $s0, $s0, 0x0008 
#		bgtz $s0, Write
#		j Read
#	Write:
#		sw $zero, 24($t0)   # UARTCON = 5'b0 manually , mainly to reset UARTCON[3]
#		lw $s2, 20($t0)
#		addi $s1, $zero, 0
#		ori $s1, $s1, 0xfe34
#		sw $s1, 16($t0)
#	Loop:
#		blez $zero, Loop


		##########################
		# Fisrt Evaluation Program
		###########################
		addi $a0, $zero, 3
		jal Sum
	Loop:
		beq $zero, $zero, Loop     # 3c  
	Sum:
		addi $sp, $sp, 8    # 40
		sw $ra, -4($sp)     # 
		sw $a0, 0($sp)
		slti $t0, $a0, 1
		beq $t0, $zero, L1   # 50
		xor $v0, $zero, $zero
		addi $sp, $sp, -8
		jr $ra       #  23
	L1:
		addi $a0, $a0, -1   # 60
		jal Sum             #  64
		lw $a0, 0($sp)      # 68
		lw $ra, -4($sp)
		addi $sp, $sp, -8
		add $v0, $a0, $v0
		jr $ra






#############################################################################
#                        Interrupt Handle Procedure                         #
#                                                                           #
#    Timer Interrption, in which we load the digi data 		    			#
#           and display it.  (finished)									    #
#############################################################################




# $a0, $a1 is the input number ( From Uart )
# $t0 == 0x40000000

Interrupt:
	sw $t1, 4($sp)   # 44
	sw $t0, 8($sp)
	add $t0, $zero, $zero
	lui $t0, 0x4000
	lw $t1, 8($t0)
	andi $t1, $t1, 0xfff9
	sw $t1, 8($t0)  # disable Interruption and clear the interruption status

	addi $sp, $sp, 36
	sw $s0, 0($sp)
	sw $a0, -4($sp)
	sw $a1, -8($sp)
	sw $t2, -12($sp)
	sw $v0, -16($sp)
	sw $v1, -20($sp)
	sw $ra, -24($sp)

############################
#	beq $k1, $zero, Uart   #   Uart INterruption (to finish)
###########################


########################################
#      Timer   Interrupt               #
########################################
Timer:
	lw $s0, 20($t0)   # 11 bit digits
	srl $s0, $s0, 8
	addi $v1, $zero, 0x000e
	beq $s0, $v1, Now0
	addi $v1, $zero, 0x000d
	beq $s0, $v1, Now1
	addi $v1, $zero, 0x000b
	beq $s0, $v1, Now2
	addi $v1, $zero, 0x0007
	beq $s0, $v1, Now3
	Now0:
	    addi $s0, $zero, 0x0d00 # AN1
	    andi $a3, $a0, 0x000f  #   lower 4 bits of $a0   --- AN1
		j Next
	Now1:
		addi $s0, $zero, 0x0b00 # AN2
		srl $a3, $a1, 4     #   upper 4 bits of $a1  --- AN2
		j Next
	Now2:
		addi $s0, $zero, 0x0700 # AN3
		andi $a3, $a1, 0x000f  #  lower 4 bits of $a1  --- AN3
		j Next
	Now3:
		addi $s0, $zero, 0x0e00 # AN0
		srl $a3, $a0, 4    #   upper 4 bits of $a0  --- AN0
		j Next
	Next:
		jal Decode
		or $s0, $s0, $t2
		sw $s0, 20($t0)
		j Exit
Decode:             # read $a3,  decode to $t2
	add $v0, $zero, $zero   # counter starting from 0
	beq $a3, $v0, Is0
	addi $v0, $v0, 1
	beq $a3, $v0, Is1
	addi $v0, $v0, 1
	beq $a3, $v0, Is2
	addi $v0, $v0, 1
	beq $a3, $v0, Is3
	addi $v0, $v0, 1
	beq $a3, $v0, Is4
	addi $v0, $v0, 1
	beq $a3, $v0, Is5
	addi $v0, $v0, 1
	beq $a3, $v0, Is6
	addi $v0, $v0, 1
	beq $a3, $v0, Is7
	addi $v0, $v0, 1
	beq $a3, $v0, Is8
	addi $v0, $v0, 1
	beq $a3, $v0, Is9
	addi $v0, $v0, 1
	beq $a3, $v0, IsA
	addi $v0, $v0, 1
	beq $a3, $v0, IsB
	addi $v0, $v0, 1
	beq $a3, $v0, IsC
	addi $v0, $v0, 1
	beq $a3, $v0, IsD
	addi $v0, $v0, 1
	beq $a3, $v0, IsE
	addi $v0, $v0, 1
	beq $a3, $v0, IsF
	jr $ra
	Is0:
		addi $t2, $zero, 0x0001
		jr $ra
	Is1:
		addi $t2, $zero, 0x004f
		jr $ra
	Is2:
		addi $t2, $zero, 0x0012
		jr $ra
	Is3:
		addi $t2, $zero, 0x0006
		jr $ra
	Is4:
		addi $t2, $zero, 0x004c
		jr $ra
	Is5:
		addi $t2, $zero, 0x0024
		jr $ra
	Is6:
		addi $t2, $zero, 0x0020
		jr $ra
	Is7:
		addi $t2, $zero, 0x000f
		jr $ra
	Is8:
		addi $t2, $zero, 0x0000
		jr $ra
	Is9:
		addi $t2, $zero, 0x0004
		jr $ra
	IsA:
		addi $t2, $zero, 0x0008
		jr $ra
	IsB:
		addi $t2, $zero, 0x0060
		jr $ra
	IsC:
		addi $t2, $zero, 0x0031
		jr $ra
	IsD:
		addi $t2, $zero, 0x0042
		jr $ra
	IsE:
		addi $t2, $zero, 0x0030
		jr $ra
	IsF:
		addi $t2, $zero, 0x0038
		jr $ra




Exit:
	addi $sp, $sp, -36
	lw $ra, 12($sp)
	lw $v1, 16($sp)
	lw $v0, 20($sp)
	lw $t2, 24($sp)
	lw $a1, 28($sp)
	lw $a0, 32($sp)
	lw $s0, 36($sp)
	addi $k0, $k0, -4
	ori $t1, $t1, 0x0002
	sw $t1, 8($t0) 
	lw $t1, 4($sp)
	lw $t0, 8($sp)
	jr $k0


###################################################
#			Overflow Exception 			          #
###################################################

Exception:
	jr $k0