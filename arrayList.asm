	.data
.eqv	SIZE	20	#Size of arrayList


### variables for Main function
ch:		.word	0	#variable that stores the return value of menu() functions
element:	.word	0	#variable that stores the input value of user for new element
pos:		.word	0	#varaible that stores the input value of user that define the position of the element to delete

main:	
menu_loop:	jal menu
		$v0,10
		syscall


### Function that prints menu and ask to user for an option to choose
	.data
DECORATOR:	.asciiz	"\n\t\t********************************************\n"
TITLE_MENU:	.asciiz "\t\t******LIST Implementation Using Arrays******\n"
BODY_MENU:	.asciiz	"\t1. Create\n\t2. Insert\n\t3. Delete\n\t4. Count\n\t5. Find\n\t6. Display\n\t7.Exit\n\n\tEnter your choice : "
	.text
menu:	la $a0,DECORATOR	#set argument to print
	jal print		#call print function
	la $a0,TITLE_MENU	#set argument to print
	jal print		#call print function
	la $a0, BODY_MENU	#set argument to print
	jal print		#call print function
	jr $ra			#return (end of function) // AQUI HAY QUE GUARDAR LA DIRECCION, YA QUE SE PIERDE el return Adrress AL USAR PRINT

print:	li	$v0,4		#Set value for print a String
	syscall			#call system
	jr $ra			#return (end of function)