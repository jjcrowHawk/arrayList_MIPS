	.data
.eqv	SIZE	20	#Size of arrayList
.eqv	true	0	#Valores del enum boolean
.eqv	false	1
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
		addi $t0,$t0,SIZE	# Se crea el espacio de memoria para la struct l
		sll $t0,$t0,2		# la struct se asignara de la siguiente forma:
		addi $t0,$t0,12		# struct{
		li $v0,9		#  int list[MAX] -> 0($s1)
		li $a0,4		#  int element -> 80($s1)
		syscall			#  int pos -> 84($s1)
		move $s1,$v0		#  int length -> 88($s1)
					# }
					
main:		sub $sp,$sp,4		#reserve 4 bytes on stack
		sw $ra,($sp) 		#copy return address to reserved stack memory place
		sub $sp,$sp,4		#reserve 4 bytes on stack
		sw $fp,($sp)		#copy frame pointer to reserved stack memory place
		sub $fp,$sp,12		#reserve 12 bytes for int ch-> 0($fp), element -> 4($fp), pos->8($fp)
		move $sp,$fp		# $sp= $fp
		sw $zero,88($s1)	# l.length= 0
		
menu_loop:	jal menu		#call menu()
		sw $v0,0($sp)		#load return value to ch
		lw $t0,0($sp)		#load ch value to $t0
CASE_1:		bne $t0,1,CASE_2	#if $t0 != 1 jump to case 2
		la $a0,OP1
		li $a1,4
		jal print
		sw $zero,88($s1)	# l.length= 0
		jal create
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
		jal display
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


### Funcion que inicializa la lista con los elementos especificados por el usuario
##  args: ninguno
##  return: ninguno
###
	.data
ENTER_ELEMENT:	.asciiz	"\nEnter an element: "
CONTINUE_INS:	.asciiz	"\nTo insert another element press '1' To stop press '0': "
YOU_ENTERED:	.asciiz	"\nYou entered: "
LIST_FULL:	.asciiz	"\n\tList if Full!"
ELEMENT:	.asciiz "\nElement "
SPACE:		.asciiz " : "
	.text
	
create:	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $ra,($sp) 		#copy return address to reserved stack memory place
	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $fp,($sp)		#copy frame pointer to reserved stack memory place
	sub $fp,$sp,8		#reserve 8 bytes for int element-> 0($fp), int flag -> 4($fp)
	move $sp,$fp		# $sp= $fp
	addi $t1,$t1,1		# $t1= 1;
	sw $t1, 4($fp)		# flag= 1;
	lw $t2, 4($fp)		# se carga en un registro temporal el valor de flag
loopc:	la $a0,ENTER_ELEMENT	#set argument to print
	li $a1,4
	jal print
	li $a0,5
	jal scan		#call scan function
	sw $v0, 0($fp)		# element= $v0 (retorno del scan);	
	lw $t3, 0($fp)		# $t3= element
	move $t4, $s1		# $t4 = l.list
	lw $t5, 88($s1)		# $t5 = l.length
	sll $t5,$t5, 2		# $t5 = $t5 * 4
	add $t4,$t4,$t5		# $t4= l.list[l.length]
	sw $t3,($t4)		# l.list[l.length]= element
	la $a0,YOU_ENTERED	#set argument to print
	li $a1,4
	jal print
	lw $t5,($t4)		# $t5= l.list[l.length]
	move $a0,$t5		#set argument to print
	li $a1,1
	jal print
	lw $t5, 88($s1)		# $t5 = l.length
	addi $t5,$t5,1
	sw $t5, 88($s1)		# l.length++;
	
				#Aqui se colocara el if(islistfull() != true)
	la $a0,CONTINUE_INS	#set argument to print
	li $a1,4
	jal print	
	li $a0,5
	jal scan		# call scan function
	sw $v0, 4($fp)		# flag= $v0 (retorno del scan)
	lw $t5, 4($fp)		# $t5 = flag
	beq $t5,1,loopc
	addi $sp,$fp,8		# restoring $sp
	lw $fp,($sp)        	#   Pop stored $fp
        addi $sp,$sp,4       	           
        lw $ra,($sp)        	#   Pop stored $ra
        addi $sp,$sp,4             
	jr $ra

display:sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $ra,($sp) 		#copy return address to reserved stack memory place
	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $fp,($sp)		#copy frame pointer to reserved stack memory place
	sub $fp,$sp,8		#reserve 8 bytes for int element-> 0($fp), int flag -> 4($fp)
	move $sp,$fp		# $sp= $fp
	
	lw $t1, 88($s1)		# load array size
	li $t2, 0		# variable position

loopd:	la   $a0, ELEMENT       # load address of ELEMENT for syscall
	li   $a1, 4           	# specify Print String service
	jal print               # output string
	
	addi $t2, $t2, 1	# increase position
	la $a0, 0($t2)		# load address of position number
	li   $a1, 1          	# specify Print Integer service
	jal print               # print array number
	
	la   $a0, SPACE      	# load address of spacer for syscall
	li   $a1, 4         	# specify Print String service
	jal print               # output string
	
	lw   $a0, 0($s1)	# load array for syscall
	li   $a1, 1         	# specify Print Integer service
	jal print               # print array number
	
	addi $s1 $s1, 4   	# increment address
	addi $t1, $t1, -1     	# decrement loop counter
	bgtz $t1, loopd        	# repeat if not finished 
	
	addi $sp,$fp,8		# restoring $sp
	lw $fp,($sp)        	#   Pop stored $fp
        addi $sp,$sp,4       	           
        lw $ra,($sp)        	#   Pop stored $ra
        addi $sp,$sp,4             
	jr $ra
	
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
	
