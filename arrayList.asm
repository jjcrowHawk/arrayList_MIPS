	.data
.eqv	SIZE	20	#Size of arrayList
OP1:	.asciiz "\n||Create arrayList||\n"
OP2:	.asciiz "\n||Insert element on arrayList||\n"
OP3:	.asciiz "\n||Delete an element||\n"
OP4:	.asciiz "\n||Count elements||\n"
OP5:	.asciiz "\n||Display elements||\n"
OP6:	.asciiz "\nExiting from menu....\n"
OP7:	.asciiz "\n||Create arrayList||\n"
DEF:	.asciiz "\nInvalid Choice!\n"

#ch:		.word	0	#variable that stores the return value of menu() functions
#element:	.word	0	#variable that stores the input value of user for new element
#pos:		.word	0	#varaible that stores the input value of user that define the position of the element to delete

### Main Function	
	.text
main:		sub $sp,$sp,4		#reserve 4 bytes on stack
		sw $ra,($sp) 		#copy return address to reserved stack memory place
		sub $sp,$sp,4		#reserve 4 bytes on stack
		sw $fp,($sp)		#copy frame pointer to reserved stack memory place
		sub $fp,$sp,12		#reserve 12 bytes for int ch-> 0($fp), element -> 4($fp), pos->8($fp)
		move $sp,$fp		# $sp= $fp
menu_loop:	jal menu		#call menu()
		sw $v0,0($sp)		#load return value to ch
		lw $t0,0($sp)		#load ch value to $t0
CASE_1:		bne $t0,1,CASE_2	#if $t0 != 1 jump to case 2
		la $a0,OP1
		li $a1,4
		jal print
		j menu_loop
CASE_2:		bne $t0,2,CASE_3	#if $t0 != 2 jump to case 3
		la $a0,OP2
		li $a1,4
		jal print
		j menu_loop
CASE_3:		bne $t0,3,CASE_4	#if $t0 != 3 jump to case 4
		la $a0,OP3
		li $a1,4
		jal print
		j menu_loop
CASE_4:		bne $t0,4,CASE_5	#if $t0 != 4 jump to case 5
		la $a0,OP4
		li $a1,4
		jal print
		j menu_loop
CASE_5:		bne $t0,5,CASE_6	#if $t0 != 5 jump to case 6
		la $a0,OP5
		li $a1,4
		jal print
		j menu_loop
CASE_6:		bne $t0,6,DEFAULT	#if $t0 != 6 jump to DEFAULT
		la $a0,OP6
		li $a1,4
		jal print
		j EXIT
DEFAULT:	la $a0,DEF		#default case
		li $a1,4
		jal print
		j menu_loop
EXIT:		lw $fp,($sp)        	#   Pop stored $fp
         	add $sp,$sp,4                  
         	lw $ra,($sp)        	#   Pop stored $ra
         	add $sp,$sp,4                   		
		li $v0,10	    	# Inserting code to exit
		syscall

### Function that prints menu and ask to user for an option to choose
##  args: none
##  return: $v0 -> An integer that represents the user's choice.
###
	.data
DECORATOR:	.asciiz	"\n\t\t********************************************\n"
TITLE_MENU:	.asciiz "\t\t******LIST Implementation Using Arrays******\n"
BODY_MENU:	.asciiz	"\t1. Create\n\t2. Insert\n\t3. Delete\n\t4. Count\n\t5. Display\n\t6.Exit\n\n\tEnter your choice : "
	.text
menu:	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $ra,($sp) 		#copy return address to reserved stack memory place
	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $fp,($sp)		#copy frame pointer to reserved stack memory place
	sub $fp,$sp,4		#reserve 4 bytes for int ch-> 0($fp)
	move $sp,$fp		# $sp= $fp
	la $a0,DECORATOR	#set argument to print
	li $a1,4
	jal print		#call print function
	la $a0,TITLE_MENU	#set argument to print
	li $a1,4
	jal print		#call print function
	la $a0, BODY_MENU	#set argument to print
	li $a1,4
	jal print		#call print function
	li $a0,5
	jal scan		#call scan function
	sw $v0, 0($fp)		#store result on ch
	lw $v0, 0($fp)		#store result on return register (this is redundant :v )
	addi $sp,$fp,4		# restoring $sp
	lw $fp,($sp)        	#   Pop stored $fp
        addi $sp,$sp,4       	           
        lw $ra,($sp)        	#   Pop stored $ra
        addi $sp,$sp,4             
	jr $ra			#return (end of function) // AQUI HAY QUE GUARDAR LA DIRECCION, YA QUE SE PIERDE el return Adrress AL USAR PRINT


### Function that prints on screen an int,float,char or string passed by args.
## args: $a0 -> value to print, 
##	 $a1 -> numbercode to specify the type of value
## return: none
###
print:	move $v0,$a1		#Set value for print a String
	syscall			#call system
	jr $ra			#return (end of function)

### Function that scans numeric data from user's input and store it in a buffer
## args: $a0 -> numbercode of scanf
## returns: $v0 -> the input value of the user
###
scan:	move $v0,$a0
	syscall
	jr $ra
	