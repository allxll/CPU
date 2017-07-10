j Main
j Interrupt
j Exception
########### Normal Process ##################
Main:
#####################################
#		Timer Startup				#
#####################################

	lui $t0, 0x4000
	ori $t0, $t0, 0x0008

	sw $zero, 0($t0)    # set TCON to be 0, stop timer.

	lui $t2, 0xffff
	ori $t2, $t2, 0xfff6
	sw $t2, -8($t0)    # set TH to be 0xfffffff6, the 10 clock timer.

	ori $t2, $t2, 0xffff
	sw $t2, -4($t0)   # set TL to be 0xffffffff

	addi $t1, $zero, 3
	sw $t1, 0($t0)     # set TCON = 3, start timer

######################################
	
	# Main Function


######################################


		addi $a0, $zero, 3
		jal Sum
	Loop:
		beq $zero, $zero, Loop
	Sum:
		addi $sp, $sp, 8
		sw $ra, -4($sp)
		sw $a0, 0($sp)
		slti $t0, $a0, 1
		beq $t0, $zero, L1
		xor $v0, $zero, $zero
		addi $sp, $sp, -8
		jr $ra
	L1:
		addi $a0, $a0, -1
		jal Sum
		lw $a0, 0($sp)
		lw $ra, -4($sp)
		addi $sp, $sp, -8
		add $v0, $a0, $v0
		jr $ra






#############################################################################
#                        Interrupt Handle Procedure                         #
#                                                                           #
#   Part 1:    Timer Interrption, in which we load the digi data 		    #
#           and display it.  (finished)									        #
#	Part 2:    Uart Interruption, in which we wait for the data.		    #
#                             
#																			#
#   Both parts are integrated in the program below.							#											#
#############################################################################




# $a0, $a1 is the input number ( From Uart )
# $t0 == 0x40000000

Interrupt:
	sw $t1, 4($sp)
	sw $t0, 8($sp)
	add $t0, $zero, $zero
	lui $t0, 0x4000
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
	addi $v1, $zero, 1
	beq $s0, $v1, Now0
	sll $v1, $v1, 1
	beq $s0, $v1, Now1
	sll $v1, $v1, 1
	beq $s0, $v1, Now2
	sll $v1, $v1, 1
	beq $s0, $v1, Now3
Now0:
    ori $s0, $zero, 0x0200 # AN1
    andi $a0, $a0, 0x000f  #   lower 4 bits of $a0   --- AN1
	j Next
Now1:
	ori $s0, $zero, 0x0400 # AN2
	srl $a0, $a1, 4     #   upper 4 bits of $a1  --- AN2
	j Next
Now2:
	ori $s0, $zero, 0x0800 # AN3
	andi $a0, $a1, 0x000f  #  lower 4 bits of $a1  --- AN3
	j Next
Now3:
	ori $s0, $zero, 0x0100 # AN0
	srl $a0, $a0, 4    #   upper 4 bits of $a0  --- AN0
	j Next
Next:
	jal Decode
	or $s0, $s0, $t2
	sw $s0, 20($t0)
	j Exit
Decode:             # read $a0,  decode to $t2
	add $v0, $zero, $zero   # counter starting from 0
	beq $a0, $v0, Is0
	addi $v0, $v0, 1
	beq $a0, $v0, Is1
	addi $v0, $v0, 1
	beq $a0, $v0, Is2
	addi $v0, $v0, 1
	beq $a0, $v0, Is3
	addi $v0, $v0, 1
	beq $a0, $v0, Is4
	addi $v0, $v0, 1
	beq $a0, $v0, Is5
	addi $v0, $v0, 1
	beq $a0, $v0, Is6
	addi $v0, $v0, 1
	beq $a0, $v0, Is7
	addi $v0, $v0, 1
	beq $a0, $v0, Is8
	addi $v0, $v0, 1
	beq $a0, $v0, Is9
	addi $v0, $v0, 1
	beq $a0, $v0, IsA
	addi $v0, $v0, 1
	beq $a0, $v0, IsB
	addi $v0, $v0, 1
	beq $a0, $v0, IsC
	addi $v0, $v0, 1
	beq $a0, $v0, IsD
	addi $v0, $v0, 1
	beq $a0, $v0, IsE
	addi $v0, $v0, 1
	beq $a0, $v0, IsF
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


#######################################
#         Uart  Interrupt             #
####################################### 
#Uart:




Exit:
	addi $sp, $sp, -36
	ori $t1, $t1, 0x0002
	sw $t1, 8($t0)
	lw $s0, -0($sp)
	lw $a0, -4($sp)
	lw $a1, -8($sp)
	lw $t2, -12($sp)
	lw $v0, -16($sp)
	lw $v1, -20($sp)
	lw $ra, -24($sp)
	lw $t0, -28($sp)
	lw $t1, -32($sp)
	addi $k0, $k0, -4
	jr $k0


###################################################
#			Overflow Exception 			          #
###################################################

Exception:
