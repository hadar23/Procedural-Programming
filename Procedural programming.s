.data
NUM: .word 0			# num of arguments in the array
array: .word 0:30		# 30 tables, each one = 0
array1: .word 0:30		# 30 tables, each one = 0
jumpTable: .word top, add_number, REPLACE, DEL, find, average, max, print_array, sort, END 	# each part is word (4 byte)
menu: .asciiz "\n\nThe options are:\n1. Enter a number (base 10)\n2. Replace a number (base 10)\n3. DEL a number (base 10)\n4. Find a number in the array (base 10)\n5. Find average (base 2-10)\n6. Find Max (base 2-10)\n7. Print the array elements (base 2-10)\n8. Print sort array (base 2-10)\n9. END\nYour Choice: "
wrongInput: .asciiz "\n\nThe input you've entered is not valid"
theArrayIsFull: .asciiz "\n\nThe array is full."
whatNumberToAdd: .asciiz "\n\nWhat number to add ?\nThe Number: "
theArrayIsEmpty: .asciiz "\n\nThe array is empty"
whatNumberToReplace: .asciiz "\n\nWhat number to replace?\nThe Number: "
whatNumberToDelete: .asciiz "\n\nWhat number to delete?\nThe Number: "
whatNumberToFind: .asciiz "\n\nWhat number to find?\nThe Number: "
theNumberAlreadyExist: .asciiz "\n\nThe number already exist in the array, in index "
theNumberDoesNotExist: .asciiz "\n\nThe number does not exist in the array"
itCannotBeReplace: .asciiz ", therefore it cannot be replaced"
itCannotBeDeleted: .asciiz ", therefore it cannot be deleted"
replaceTheNumber: .asciiz "\n\nReplace the number "
inIndex2: .asciiz " (in index "
withWhatNumber: .asciiz ") with what number ?\nThe Number: "
theNumber: .asciiz "\n\nThe number "
replacedTheNumber: .asciiz " replaced the number "
inIndex: .asciiz ", in index "
hasBeenDeleted: .asciiz " has been deleted from the array"
hasBeenAdded: .asciiz ", has been added to array, in index "
existInTheArray: .asciiz " exist in the array, in index "
inWhatBase: .asciiz "\n\nIn what base do you want to print? (base 2-10)\nThe Base: "
theAverageOfTheArray: "\n\nThe average of the array is "
byBase: .asciiz " (by base "
inIndex3: .asciiz "), in index "
theMaxNumber: .asciiz "\n\nThe max number of the array is "
notAGoodBase: .asciiz "\n\nThe base you've entered is not in the range 2-10.\nPlease try again."
theArrayIs: .asciiz "\n\nThe array is: "
theArrayHasBeenSorted: .asciiz "\n\nThe array has been sorted successfully!"
.text
Main:
	j top
input_not_valid:
	li $v0, 4			# print string	
	la $a0, wrongInput		# print wrongInput 	
	syscall
top:	
	li $v0, 4			# print string	
	la $a0, menu			# print the menu
	syscall
	
	li $v0, 12			# read char, put it in v0 
	syscall
	
	move $t0, $v0			# t0 = v0 = user choice
	move $a0, $t0			# a0 = t0 = user choice
	jal check_user_choice	
	bnez $v0, input_not_valid	# if v0 != 0 -> go to input_not_valid
	
	# the input is valid
	subiu $t0, $t0, 0x30		# put the index in t0
	sll $t0, $t0, 2 		# t0 = t0*(2^2), t0 = t0*4
	lw $t2, jumpTable($t0)		# t2 = the address of chosen case
	la $a1, NUM			# a1 = address of num 
	la $a2, array			# a2 = address of array
	la $a3, array1			# a3 = address of array1 (helper for sort)
	jalr $t2			# go to the address inside t2 (t2 = the address of chosen case)
	j top

#########################################################
#		Add Number				#
#		^^^^^^^^^^				#
#	Input:						#
#		$a1 =	address of NUM			#
#		$a2 =	address of array		#
#		$a3 = 	address of array1		#
#	Variables:					#
#		$t0 =	NUM				#
#		$t1 =	input number from user		#
#		$t2 =	index of number in the array	#
#		$t3 =	new address in array		#
#########################################################
add_number:
	lw $t0, ($a1)			# t0 = 	NUM
	beq $t0, 30, array_is_full	# if t0 = 30 go to  array_is_full
	
	li $v0, 4			# print string	
	la $a0, whatNumberToAdd		# print whatNumberToAdd
	syscall
	
	li $v0, 5			# read integer	
	syscall
	
	move $t1, $v0			# t1 = integer from user
# push to stack-----------------------------------
	addi $sp, $sp, -20			#|
	sw $a1, 0($sp)				#|
	sw $a2, 4($sp)				#|
	sw $t0, 8($sp)				#|
	sw $t1, 12($sp)				#|
	sw $ra, 16($sp)				#|
#-------------------------------------------------
	move $a1, $t0			# a1 = t0 = NUM
	move $a3, $t1			# a3 = t1 = integer from user 
	jal CHECK
# pop from stack----------------------------------
	lw $a1, 0($sp)				#|
	lw $a2, 4($sp)				#|
	lw $t0, 8($sp)				#|
	lw $t1, 12($sp)				#|
	lw $ra, 16($sp)				#|
	addi $sp, $sp, 20			#|
#-------------------------------------------------
	move $t2, $v0			# t2 = index of number in the array	
	bne $t2, -1, number_exist_of_add_number	# if index found (t2 != -1) go to number_exist_of_add_number
	move $t2, $t0			# update the new index
	sll $t3, $t0, 2			# t3 = t0*4
	add $t3, $t3, $a2		# t3 = new address in array 
	sw $t1, ($t3)			# store the new number in the new address
	addi $t0, $t0, 1		# NUM++
	sw $t0, ($a1)			# store the new NUM in its place
	
	li $v0, 4			# print string	
	la $a0, theNumber		# print theNumber
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t1			# print the number	
	syscall
	
	li $v0, 4			# print string	
	la $a0, hasBeenAdded		# print hasBeenAdded
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t2			# print the index	
	syscall
	
	j end_add_number
number_exist_of_add_number: 
	li $v0, 4			# print string	
	la $a0, theNumberAlreadyExist	# print theNumberAlreadyExist
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t2			# print the index	
	syscall
	
	j end_add_number	
array_is_full:
	li $v0, 4			# print string	
	la $a0, theArrayIsFull		# print theArrayIsFull
	syscall
end_add_number:
	jr $ra			
	
#########################################################
#		Replace Number				#
#		^^^^^^^^^^^^^^				#
#	Input:						#
#		$a1 =	address of NUM			#
#		$a2 =	address of array		#
#		$a3 = 	address of array1		#
#	Variables:					#
#		$t0 =	NUM				#
#		$t1 =	input number from user		#
#		$t2 =	index of number in the array	#
#		$t3 =	new number			#
#########################################################	
REPLACE:
	lw $t0, ($a1)			# t0 = 	NUM
	beqz $t0, array_is_empty_of_REPLACE	# if t0 = 0 go to array_is_empty_of_REPLACE
	
	li $v0, 4			# print string	
	la $a0, whatNumberToReplace	# print whatNumberToReplace
	syscall
	
	li $v0, 5			# read integer	
	syscall
	
	move $t1, $v0			# t1 = integer from user
# push to stack-----------------------------------
	addi $sp, $sp, -16			#|
	sw $a2, 0($sp)				#|
	sw $t0, 4($sp)				#|
	sw $t1, 8($sp)				#|
	sw $ra, 12($sp)				#|
#-------------------------------------------------
	move $a1, $t0			# a1 = t0 = NUM
	move $a3, $t1			# a3 = t1 = integer from user 
	jal CHECK
# pop from stack----------------------------------
	lw $a2, 0($sp)				#|
	lw $t0, 4($sp)				#|
	lw $t1, 8($sp)				#|
	lw $ra, 12($sp)				#|
	addi $sp, $sp, 16			#|
#-------------------------------------------------
	move $t2, $v0			# t2 = index of number in the array	
	beq $t2, -1, number_doesnt_exist_of_REPLACE	# if index not found (t2 = -1) go to number_doesnt_exist_of_REPLACE:
	
	li $v0, 4			# print string	
	la $a0, replaceTheNumber	# print replaceTheNumber
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t1			# print the number
	syscall
	
	li $v0, 4			# print string	
	la $a0, inIndex2		# print inIndex2
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t2			# print the index
	syscall
	
	li $v0, 4			# print string	
	la $a0, withWhatNumber		# print withWhatNumber
	syscall
	
	li $v0, 5			# read integer	
	syscall
	
	move $t3, $v0
# push to stack-----------------------------------
	addi $sp, $sp, -20			#|
	sw $a2, 0($sp)				#|
	sw $t1, 4($sp)				#|
	sw $t2, 8($sp)				#|
	sw $t3, 12($sp)				#|
	sw $ra, 16($sp)				#|
#-------------------------------------------------
	move $a1, $t0			# a1 = t0 = NUM
	move $a3, $t3			# a3 = t3 = new number from user 
	jal CHECK
# pop from stack----------------------------------
	lw $a2, 0($sp)				#|
	lw $t1, 4($sp)				#|
	lw $t2, 8($sp)				#|
	lw $t3, 12($sp)				#|
	lw $ra, 16($sp)				#|
	addi $sp, $sp, 20			#|
#-------------------------------------------------
	move $t4, $v0			# t4 = index of new number in the array
	bne $t4, -1, new_number_exist_of_REPLACE	# if index found (t4 != -1) go to new_number_exist_of_REPLACE
	sll $t5, $t2, 2
	add $t5, $t5, $a2
	sw $t3, ($t5)
	
	li $v0, 4			# print string	
	la $a0, theNumber		# print theNumber
	syscall	
	
	li $v0, 1			# print integer	
	move $a0, $t3			# print new number
	syscall
	
	li $v0, 4			# print string	
	la $a0, replacedTheNumber	# print replacedTheNumber
	syscall	
	
	li $v0, 1			# print integer	
	move $a0, $t1			# print number
	syscall
	
	li $v0, 4			# print string	
	la $a0, inIndex			# print inIndex
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t2			# print the index
	syscall
	
	j end_of_REPLACE
	
new_number_exist_of_REPLACE:
	li $v0, 4			# print string	
	la $a0, theNumberAlreadyExist	# print theNumberAlreadyExist
	syscall	
	
	j end_of_REPLACE
	
number_doesnt_exist_of_REPLACE:
	li $v0, 4			# print string	
	la $a0, theNumberDoesNotExist	# print theNumberDoesNotExistrrayIsEmpty
	syscall
	
	li $v0, 4			# print string	
	la $a0, itCannotBeReplace	# print itCannotBeReplace
	syscall
	
	j end_of_REPLACE
	
array_is_empty_of_REPLACE:
	li $v0, 4			# print string	
	la $a0, theArrayIsEmpty		# print theArrayIsEmpty
	syscall

end_of_REPLACE:
	jr $ra
	
#########################################################
#		Delete Number				#
#		^^^^^^^^^^^^^				#
#	Input:						#
#		$a1 =	address of NUM			#
#		$a2 =	address of array		#
#		$a3 = 	address of array1		#
#	Variables:					#
#		$t0 =	NUM				#
#		$t1 =	input number from user		#
#		$t2 =	index of number in the array	#
#########################################################	
DEL:
	lw $t0, ($a1)			# t0 = 	NUM
	beqz $t0, array_is_empty_of_DEL	# if t0 = 0 go to array_is_empty_of_DEL
	
	li $v0, 4			# print string	
	la $a0, whatNumberToDelete	# print whatNumberToDelete
	syscall
	
	li $v0, 5			# read integer	
	syscall
	
	move $t1, $v0			# t1 = integer from user
# push to stack-----------------------------------
	addi $sp, $sp, -16			#|
	sw $a1, 0($sp)				#|
	sw $a2, 4($sp)				#|
	sw $t1, 8($sp)				#|
	sw $ra, 12($sp)				#|
#-------------------------------------------------
	move $a1, $t0			# a1 = t0 = NUM
	move $a3, $t1			# a3 = t1 = integer from user 
	jal CHECK
# pop from stack----------------------------------

	lw $a1, 0($sp)				#|
	lw $a2, 4($sp)				#|
	lw $t1, 8($sp)				#|
	lw $ra, 12($sp)				#|
	addi $sp, $sp, -16			#|
#-------------------------------------------------
	move $t2, $v0			# t2 = index of number in the array	
	beq $t2, -1, number_doesnt_exist_of_DEL	# if index not found (t2 = -1) go to number_doesnt_exist_of_REPLACE:
	
# push to stack-----------------------------------
	addi $sp, $sp, -8			#|
	sw $t1, 0($sp)				#|
	sw $ra, 4($sp)				#|
#-------------------------------------------------
	
	move $a3, $t2
	jal reduction
# pop from stack----------------------------------
	lw $t1, 0($sp)				#|
	lw $ra, 4($sp)				#|
	addi $sp, $sp, 8			#|
#-------------------------------------------------
	li $v0, 4			# print string	
	la $a0, theNumber		# print theNumber
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t1			# print the number
	syscall
	
	li $v0, 4			# print string	
	la $a0, hasBeenDeleted		# print hasBeenDeleted
	syscall
	
	j end_of_DEL
	
number_doesnt_exist_of_DEL:
	li $v0, 4			# print string	
	la $a0, theNumberDoesNotExist	# print theNumberDoesNotExistrrayIsEmpty
	syscall
	
	li $v0, 4			# print string	
	la $a0, itCannotBeDeleted	# print itCannotBeDeleted
	syscall
	
	j end_of_DEL
		
array_is_empty_of_DEL:
	li $v0, 4			# print string	
	la $a0, theArrayIsEmpty		# print theArrayIsEmpty
	syscall	

end_of_DEL:
	jr $ra
	
#########################################################
#		Find Number				#
#		^^^^^^^^^^^				#
#	Input:						#
#		$a1 =	address of NUM			#
#		$a2 =	address of array		#
#		$a3 = 	address of array1		#
#	Variables:					#
#		$t0 =	NUM				#
#		$t1 =	input number from user		#
#		$t2 =	index of number in the array	#
#########################################################
find:
	lw $t0, ($a1)			# t0 = 	NUM
	
	li $v0, 4			# print string	
	la $a0, whatNumberToFind	# print whatNumberToFind
	syscall
	
	li $v0, 5			# read integer	
	syscall
	
	move $t1, $v0			# t1 = integer from user
# push to stack-----------------------------------
	addi $sp, $sp, -4			#|
	sw $ra, 0($sp)				#|
#-------------------------------------------------
	move $a1, $t0			# a1 = t0 = NUM
	move $a3, $t1			# a3 = t1 = integer from user 
	jal CHECK
# pop from stack----------------------------------
	lw $ra, 0($sp)				#|
	addi $sp, $sp, 4			#|
#-------------------------------------------------
	move $t2, $v0			# t2 = index of number in the array	
	bne $t2, -1, number_exist_of_find	# if index found (t2 != -1) go to number_exist_of_find
	
	li $v0, 4			# print string	
	la $a0, theNumberDoesNotExist	# print theNumberDoesNotExist
	syscall
	
	j end_find
	
number_exist_of_find:
	li $v0, 4			# print string	
	la $a0, theNumber		# print theNumber
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t1			# print the number from the user
	syscall
	
	li $v0, 4			# print string	
	la $a0, existInTheArray		# print existInTheArray
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t2			# print the index
	syscall
	
end_find:
	jr $ra	

#########################################################
#		Average					#
#		^^^^^^^					#
#	Input:						#
#		$a1 =	address of NUM			#
#		$a2 =	address of array		#
#		$a3 = 	address of array1		#
#	Variables:					#
#		$t0 =	NUM				#
#		$t1 =	counter				#
#		$t2 =	address of number in array	#
#		$t3 =	sum of array			#
#		$t4 =	number is array			#
#		$t5 =	average of array		#
#		$t6 =	base				#
#########################################################
average:
	lw $t0, ($a1)			# t0 = NUM
	beqz $t0, array_is_empty_of_average	# if t0 = 0 go to array_is_empty_of_average
	
	move $t1, $0			# t1 = counter
	move $t2, $a2			# t2 = address of number in array
	move $t3, $0			# t3 = sum of array
sum_loop_of_average:
	beq $t1, $t0, calculate_average	# if counter = num fo to calculate average
	lw $t4 ($t2)			# t4 = number in array
	add $t3, $t3, $t4		# sum += number in array
	addi $t1, $t1, 1		# counter++
	addi $t2, $t2, 4		# next address in the array
	j sum_loop_of_average	
	
calculate_average:
	div $t3, $t0			# sum / NUM
	mflo $t5			# the average (without the reminder)

ask_for_base_average:
	li $v0, 4			# print string	
	la $a0, inWhatBase		# print inWhatBase
	syscall
	
	li $v0, 5			# read integer	
	syscall
	
	move $t6, $v0			# t6 = base
	blt $t6, 2, not_a_good_base_average	# if base < 2 go to not_a_good_base_average
	bgt $t6, 10, not_a_good_base_average	# if base > 10 go to not_a_good_base_average
	
	li $v0, 4			# print string	
	la $a0, theAverageOfTheArray	# print theAverageOfTheArray
	syscall
	
# push to stack-----------------------------------
	addi $sp, $sp, -8			#|
	sw $t6, 0($sp)				#|
	sw $ra, 4($sp)				#|
#-------------------------------------------------
	move $a1, $t5			# a1 = t5 = average
	move $a2, $t6			# a2 = t6 = base 
	jal print_num
# pop from stack----------------------------------
	lw $t6, 0($sp)				#|
	lw $ra, 4($sp)				#|
	addi $sp, $sp, 8			#|
#-------------------------------------------------
	li $v0, 4			# print string	
	la $a0, byBase			# print byBase
	syscall
	
	li $v0, 1			# print integer	
	move $a0, $t6			# print base
	syscall
	
	li $v0, 11			# print char	
	li $a0, ')'			# print ')'
	syscall
	
	j end_average

not_a_good_base_average:
	li $v0, 4			# print string	
	la $a0, notAGoodBase		# print notAGoodBase
	syscall		
	
	j ask_for_base_average	
			
array_is_empty_of_average:
	li $v0, 4			# print string	
	la $a0, theArrayIsEmpty		# print theArrayIsEmpty
	syscall		
	
end_average:
	jr $ra
	
#########################################################
#		Max					#
#		^^^					#
#	Input:						#
#		$a1 =	address of NUM			#
#		$a2 =	address of array		#
#		$a3 = 	address of array1		#
#	Variables:					#
#		$t0 =	NUM				#
#		$t1 =	counter				#
#		$t2 =	address of number in array	#
#		$t3 =	max of array			#
#		$t4 =	number in array			#
#		$t5 =	index of max			#
#		$t6 =	base				#
#########################################################
max:
	lw $t0, ($a1)			# t0 = 	NUM
	beqz $t0, array_is_empty_of_max	# if t0 = 0 go to array_is_empty_of_max
	
	move $t1, $0			# t1 = counter
	move $t2, $a2			# t2 = address of number in array
	lw $t3, ($t2)			# t3 = max of array
	move $t5, $0			# t5 = index of max
find_max_loop:
	beq $t1, $t0, ask_for_base_max	# if counter = NUM go to ask_for_base_max
	lw $t4 ($t2)			# t4 = number in array
	blt $t4, $t3, not_bigger_of_max	# if number in array < max go to not_bigger_of_max
	# number in array > max
	move $t3, $t4			# max = number in array
	move $t5, $t1			# index of max = counter (index of number in array)	
not_bigger_of_max:
	addi $t2, $t2, 4		# go to next address of array	
	addi $t1, $t1, 1		# counter++
	j find_max_loop

ask_for_base_max:
	li $v0, 4			# print string	
	la $a0, inWhatBase		# print inWhatBase
	syscall
	
	li $v0, 5			# read integer	
	syscall
	
	move $t6, $v0			# t6 = base
	blt $t6, 2, not_a_good_base_max		# if base < 2 go to not_a_good_base_max
	bgt $t6, 10, not_a_good_base_max	# if base > 10 go to not_a_good_base_max
	
	li $v0, 4			# print string	
	la $a0, theMaxNumber		# print theMaxNumber
	syscall
	
# push to stack-----------------------------------
	addi $sp, $sp, -12			#|
	sw $t5, 0($sp)				#|
	sw $t6, 4($sp)				#|
	sw $ra, 8($sp)				#|
#-------------------------------------------------
	move $a1, $t3			# a1 = t3 = max
	move $a2, $t6			# a2 = t6 = base 
	jal print_num
# pop from stack----------------------------------
	lw $t5, 0($sp)				#|
	lw $t6, 4($sp)				#|
	lw $ra, 8($sp)				#|
	addi $sp, $sp, 12			#|
#-------------------------------------------------
	li $v0, 4			# print string	
	la $a0, byBase			# print byBase
	syscall	
	
	li $v0, 1			# print integer	
	move $a0, $t6			# print the base
	syscall
	
	li $v0, 4			# print string	
	la $a0, inIndex3		# print inIndex3
	syscall	
	
	li $v0, 1			# print integer	
	move $a0, $t5			# print the index of max
	syscall
	
	j end_max	

not_a_good_base_max:
	li $v0, 4			# print string	
	la $a0, notAGoodBase		# print notAGoodBase
	syscall		
	
	j ask_for_base_max
			
array_is_empty_of_max:
	li $v0, 4			# print string	
	la $a0, theArrayIsEmpty		# print theArrayIsEmpty
	syscall		
	
end_max:
	jr $ra	
		
#########################################################
#		Print Array				#
#		^^^^^^^^^^^				#
#	Input:						#
#		$a1 =	address of NUM			#
#		$a2 =	address of array		#
#		$a3 = 	address of array1		#
#	Variables:					#
#		$t0 =	NUM				#
#		$t1 =	base				#
#		$t2 =	address of number in array	#
#		$t3 =	counter				#
#		$t4 =	number in array to print	#
#########################################################	
print_array:
	lw $t0, ($a1)			# t0 = 	NUM
	beqz $t0, array_is_empty_of_print_array	# if t0 = 0 go to array_is_empty_of_print_array

ask_for_base_print_array:	
	li $v0, 4			# print string	
	la $a0, inWhatBase		# print inWhatBase
	syscall
	
	li $v0, 5			# read integer	
	syscall
	
	move $t1, $v0			# t1 = base
	blt $t1, 2, not_a_good_base_print_array		# if base < 2 go to not_a_good_base_print_array
	bgt $t1, 10, not_a_good_base_print_array	# if base > 10 go to not_a_good_base_print_array 
	
	li $v0, 4			# print string	
	la $a0, theArrayIs		# print theArrayIs
	syscall
	
	move $t2, $a2			# t2 = address of number in array
	move $t3, $0			# t3 = counter
print_array_loop:
	lw $t4, ($t2)			# t4 = number in array to print
	
# push to stack-----------------------------------
	addi $sp, $sp, -24			#|
	sw $t0, 0($sp)				#|
	sw $t1, 4($sp)				#|
	sw $t2, 8($sp)				#|
	sw $t3, 12($sp)				#|
	sw $t4, 16($sp)				#|
	sw $ra, 20($sp)				#|
#-------------------------------------------------
	move $a1, $t4			# a1 = t4 = number to print
	move $a2, $t1			# a2 = t1 = base 
	jal print_num
# pop from stack----------------------------------
	lw $t0, 0($sp)				#|
	lw $t1, 4($sp)				#|
	lw $t2, 8($sp)				#|
	lw $t3, 12($sp)				#|
	lw $t4, 16($sp)				#|
	lw $ra, 20($sp)				#|
	addi $sp, $sp, 24			#|
#-------------------------------------------------
	addi $t3, $t3, 1		# counter++
	addi $t2, $t2, 4		# next address in array 
	
	beq $t3, $t0, end_print_array	# if counter = NUM go to end_print_array
	
	li $v0, 11			# print char
	li $a0, ','			# print ','
	syscall
	li $a0, ' '			# print ' '
	syscall
	
	j print_array_loop
			
not_a_good_base_print_array:
	li $v0, 4			# print string	
	la $a0, notAGoodBase		# print notAGoodBase
	syscall
	
	j ask_for_base_print_array

array_is_empty_of_print_array:
	li $v0, 4			# print string	
	la $a0, theArrayIsEmpty		# print theArrayIsEmpty
	syscall		
	
end_print_array:
	jr $ra	

#########################################################
#		Sort Array				#
#		^^^^^^^^^^				#
#	Input:						#
#		$a1 =	address of NUM			#
#		$a2 =	address of array		#
#		$a3 = 	address of array1		#
#	Variables:					#
#		$t0 =	NUM				#
#		$t1 =	counter				#
#		$t2 =	address of number in array	#
#		$t3 =	address of number in array1(I)	#
#		$t4 =	number in array			#
#		$t6 =	0 - has not changed		#
#			1 - has been changed			#
#		$t7 =	address of number in array1(J)	#
#		$t8 =	number in array1(J)		#
#		$t9 =	number in array1(J+1)		#
#########################################################
sort:
	lw $t0, ($a1)			# t0 = 	NUM
	beqz $t0, array_is_empty_of_sort	# if t0 = 0 go to array_is_empty_of_sort
	
	move $t1, $0			# t1 = counter
	move $t2, $a2			# t2 = address of number in array
	move $t3, $a3			# t3 = address of number in array1
	
copy_array_to_array1:
	lw $t4, ($t2)			# t4 = number in array
	sw $t4, ($t3)			# copy number to array1
	addi $t2, $t2, 4		# next address in array
	addi $t3, $t3, 4		# next address in array1
	addi $t1, $t1, 1		# counter++
	bne $t1, $t0, copy_array_to_array1	# if counter != NUM go to copy_array_to_array1
	
	addi $t3, $t3, -4		# t3 = address of number in array1(I) - starts from the end of array1
bubble_sort_first_loop:			
	li $t6, 0			# t6 = 0 (has not changed)
	move $t7, $a3			# t7 = address of number in array1(J) - starts from the beginning of array1
bubble_sort_second_loop:
	beq $t7, $t3, is_there_any_change	# if J = I go to is_there_any_change
	lw $t8, ($t7)			# number in array1(J)
	lw $t9, 4($t7)			# number in array1(J+1)
	blt $t8, $t9, good_vibes	# if J < J+1 go to good_vibes
	# J > J+1 -> replace them
	li $t6, 1			# t6 = 1 (has been changed)
	sw $t8, 4($t7)			# put J inside the address of J+1
	sw $t9, ($t7)			# put J+1 inside the address of J
good_vibes:
	addi $t7, $t7, 4		# next address is array1 (same as J++ in java)
	j bubble_sort_second_loop
is_there_any_change:
	addi $t3, $t3, -4		# next address is array (same as I-- in java)
	bnez $t6, bubble_sort_first_loop

	li $v0, 4			# print string	
	la $a0, theArrayHasBeenSorted	# print theArrayHasBeenSorted
	syscall
	
	
# push to stack-----------------------------------
	addi $sp, $sp, -4			#|	
	sw $ra, 0($sp)				#|
#-------------------------------------------------
	move $a2, $a3			# a2 = a3 = address of array1 
	jal print_array
# pop from stack----------------------------------	
	lw $ra, 0($sp)				#|
	addi $sp, $sp, 4			#|
#-------------------------------------------------	
	j end_print_array
	
array_is_empty_of_sort:
	li $v0, 4			# print string	
	la $a0, theArrayIsEmpty		# print theArrayIsEmpty
	syscall		
	
end_sort:
	jr $ra	

#########################################################
#		End Program				#
#		^^^^^^^^^^^				#
#		ends the program			#
#########################################################				
END:	
	li $v0, 10			# end program
	syscall

#########################################################
#		Check User Choice			#
#		^^^^^^^^^^^^^^^^^			#
#	Input:						#
#		$a0 =	user choice			#
#	Output:						#
#		$v0 =	0 - choice is valid		#
#			1 - choice is not valid		#
#########################################################	
check_user_choice:
	blt $a0, 0x31, choice_not_valid	# if a0 < 1, go to choice_not_valid
	bgt $a0, 0x39, choice_not_valid	# if a0 > 9, go to choice_not_valid
	li $v0, 0			# v0 = 0 (0 - choice is valid)
	j end_of_check_user_choice
choice_not_valid:
	li $v0, 1			# v0 = 1 (1 - choice is not valid)
end_of_check_user_choice:
	jr $ra	

#########################################################
#		Check The Number			#
#		^^^^^^^^^^^^^^^^			#
#	Input:						#
#		$a1 =	NUM				#
#		$a2 =	address of array		#
#		$a3 = 	input number			#
#########################################################
CHECK:
	move $t0, $0			# t0 = index array 
for:	
	beq $t0, $a1, not_found		# if index = NUM (number of arguments in array) go to not_found
	lw $t1, ($a2)			# t1 = the value inside the array in index t0
	beq $t1, $a3, found_num		# if the value = the input number go to found_num 
	addi $a2, $a2, 4		# a2+=4
	addi $t0, $t0, 1		# index++
	j for
not_found:
	addi $v0, $0, -1		# v0 = -1
	j end_CHECK
found_num:
	move $v0, $t0			# v0 = the index  
end_CHECK:	
	jr $ra

#########################################################
#		Print The Number			#
#		^^^^^^^^^^^^^^^^			#
#	Input:						#
#		$a1 =	number to print			#
#		$a2 =	base to print			#
#	Variables:					#
#		$t0 =	counter of digits in stack	#
#		$t1 =	the reminder			#
#########################################################
print_num:
	li $v0, 1			# print integer
	move $t0, $0			# t0 = counter of digits in stack
	blt $a1, $0, negative_number	# if the number to print is negative go to negative_number
	j convert_to_base
	
negative_number:
	li $v0, 11			# print char
	li $a0, '-'			# print '-'
	syscall
	li $v0,1			# print integer
	abs $a1, $a1			# get the absolute value of the number to print

convert_to_base:
	blt $a1, $a2, last_digit	# if the number to print < base go to last_digit
	addi $t0, $t0, 1		# counter++
	div $a1, $a2			# number / base
	mfhi $t1			# t1 = the reminder
	addi $sp, $sp, -4		# prepare stack for saving
	sw $t1, ($sp)			# save reminder (a digit) in stack
	mflo $a1			# get the rest of the number
	j convert_to_base
	
last_digit:
	beqz $a1, print_the_converted_num	# if the number to print = 0 go to print_the_converted_num
	# the number to print is not 0
	move $a0, $a1				# print number
	syscall
	
print_the_converted_num:
	beqz $t0, end_of_print_num		# if counter == 0 go to end_of_print_num
	lw $a0, ($sp)				# get the digit from the stack
	addi $sp, $sp, 4			# prepare the stack for poping
	addi $t0, $t0, -1			# counter--
	syscall
	j print_the_converted_num
	
end_of_print_num:
	jr $ra
	
#########################################################
#		Reduction				#
#		^^^^^^^^^				#
#	Input:						#
#		$a1 =	address of NUM			#
#		$a2 =	address of array		#
#		$a3 = 	index of number			#
#	Variables:					#
#		$t0 =	NUM				#
#		$t1 =	address of number in array	#
#		$t2 =	number in array			#
#		$t3 =	last address in array		#
#########################################################		
reduction:
	lw $t0, ($a1)				# t0 = NUM
	sll $t3, $t0, 2				# t3 = NUM*4
	add $t3, $t3, $a2			# t3 = last address in array
	move $t1, $a3				# t1 = index of number
	sll $t1, $t1, 2				# t1 = index*4
	add $t1, $t1, $a2			# t1 = address of number in array
	addi $t1, $t1, 4			# next address in array
	
loop_reduction:
	beq $t1, $t3, end_of_reduction		# if address in array == last address in array go to end_of_reduction
	lw $t2, ($t1)				# t2 = number in array
	sw $t2, -4($t1)				# put number in the previous address
	addi $t1, $t1, 4			# next address in array
	j loop_reduction
	
end_of_reduction:
	addi $t0, $t0, -1			# NUM--
	sw $t0, ($a1)				# save new NUM
	jr $ra
