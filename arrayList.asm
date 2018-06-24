	.data
.eqv	SIZE	3	#Size of arrayList
.eqv	true	0	#Valores del enum boolean
.eqv	false	1
OP1:	.asciiz "\n||Create arrayList||\n"
OP2:	.asciiz "\n||Insert element on arrayList||\n"
OP3:	.asciiz "\n||Delete an element||\n"
OP4:	.asciiz "\n||Count elements||\n"
OP5:	.asciiz "\n||Display elements||\n"
OP6:	.asciiz "\n||Average of arrayList||\n"
OP7:	.asciiz "\n||Exiting from program...||\n"
DEF:	.asciiz "\nInvalid Choice!\n"
LST_EMP:.asciiz "List is Empty.\n"
POS_DEL:.asciiz "\nEnter the position of element to be deleted : "

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
		jal islistempty
		beq $v0,true,elsecase3
		la $a0,POS_DEL		#set argument to print
		li $a1,4
		jal print
		li $a0,5
		jal scan		# call scan function
		move $a0,$v0		# $a0= scan()
		jal delete
		j menu_loop
elsecase3:	la $a0,LST_EMP		#set argument to print
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
		
CASE_6:		bne $t0,6,CASE_7	#if $t0 != 6 jump to case 7
		la $a0,OP6
		li $a1,4
		jal print
		jal islistempty
		beq $v0,true,elsecase6
		jal average
		j menu_loop
elsecase6:	la $a0,LST_EMP		#set argument to print
		li $a1,4
		jal print
		j menu_loop

CASE_7:		bne $t0,7,DEFAULT	#if $t0 != 7 jumo to DEFAULT
		la $a0,OP7
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


### Funcion que imprime el menu del programa y recepta la eleccion del usuario
##  args: none
##  return: $v0 -> La opcion que escogio el usuario en un numero entero
###
	.data
DECORATOR:	.asciiz	"\n\t\t********************************************\n"
TITLE_MENU:	.asciiz "\t\t******LIST Implementation Using Arrays******\n"
BODY_MENU:	.asciiz	"\t1. Create\n\t2. Insert\n\t3. Delete\n\t4. Count\n\t5. Display\n\t6. Average\n\t7. Exit\n\n\tEnter your choice : "
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
	jr $ra			#return (end of function)


### Funcion que inicializa la lista con los elementos especificados por el usuario
##  args: ninguno
##  return: ninguno
###
	.data
ENTER_ELEMENT:	.asciiz	"\nEnter an element: "
CONTINUE_INS:	.asciiz	"\nTo insert another element press '1' To stop press '0': "
YOU_ENTERED:	.asciiz	"\nYou entered: "
LIST_FULL:	.asciiz	"\n\tList if Full!"
	.text
	
create:	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $ra,($sp) 		#copy return address to reserved stack memory place
	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $fp,($sp)		#copy frame pointer to reserved stack memory place
	sub $fp,$sp,8		#reserve 8 bytes for int element-> 0($fp), int flag -> 4($fp)
	move $sp,$fp		# $sp= $fp
	li $t1,1		# $t1= 1;
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
	
	jal islistfull
	beq $v0,true,elsecreate
	la $a0,CONTINUE_INS	#set argument to print
	li $a1,4
	jal print	
	li $a0,5
	jal scan		# call scan function
	sw $v0, 4($fp)		# flag= $v0 (retorno del scan)
	lw $t5, 4($fp)		# $t5 = flag
	beq $t5,1,loopc
	j exitcreate
elsecreate:
	la $a0,LIST_FULL	#set argument to print
	li $a1,4
	jal print
	li $t1,0		# $t1= 0
	sw $t1, 4($fp)		# flag= $t1 (retorno de islistfull)
	lw $t5, 4($fp)		# $t5 = flag
	beq $t5,1,loopc
exitcreate:
	addi $sp,$fp,8		# restoring $sp
	lw $fp,($sp)        	#   Pop stored $fp
        addi $sp,$sp,4       	           
        lw $ra,($sp)        	#   Pop stored $ra
        addi $sp,$sp,4             
	jr $ra


### Funcion que elimina un elemento del arrayList en una posicion dada por el usuario
##  args: $a0 -> int pos
## return: ninguno
###
	.data
CANNOT_DELETE:	.asciiz	"\n\nCannot delete at zeroth position"
ONLY:		.asciiz	"\n\nOnly "
ONLY2:		.asciiz	" elements exists. Cannot delete at "
ELM_DELETED:	.asciiz	"\nElement deleted!"
	.text
delete:	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $ra,($sp) 		#copy return address to reserved stack memory place
	move $t1,$a0		# $t1 = pos
	subi $t3,$t1,1		# inicializamos i= pos-1 ya que la variable i solo se usara para el for. (no es necesario pasarlo a memoria)
	bne $t1,0,chckpos	# if(pos==0)
	la   $a0, CANNOT_DELETE # load address of spacer for syscall
	li   $a1, 4         	# specify Print String service
	jal print
	j   exitdel
	
chckpos:lw  $t2, 88($s1)	# $t2= l.length
	ble $t1,$t2,delpos	# if( pos > l.length)
	la  $a0, ONLY 		# load address of spacer for syscall
	li  $a1, 4         	# specify Print String service
	jal print
	move  $a0, $t2		# load array for syscall
	li  $a1, 1         	# specify Print Integer service
	jal print
	la  $a0, ONLY2 		# load address of spacer for syscall
	li  $a1, 4         	# specify Print String service
	jal print
	move  $a0, $t1		# load array for syscall
	li  $a1, 1         	# specify Print Integer service
	jal print
	j   exitdel

delpos: bge $t3,$t2,endford	#for loop(i<l.length)
	move $t4,$s1		# $t4 = l.list
	sll $t5,$t3,2		# $t5= i * 4
	add $t6,$t4,$t5		# $t6= &(l.list[i])
	addi $t5,$t3,1		# $t5= i + 1
	sll $t5,$t5,2		# $t5= $t5 * 4
	add $t7,$t4,$t5		# $t7= &(l.list[i+1])
	lw  $t8,($t7)		# $t8= l.list[i+1]
	sw  $t8,($t6)		# l.list[i] = l.list[i+1]
	addi $t3,$t3,1		# i++
	j delpos
	
endford:subi $t3,$t2,1		# $t3= l.length - 1;
	sw $t3, 88($s1)		# l.lenght--;
	la  $a0, ELM_DELETED 	# load address of spacer for syscall
	li  $a1, 4         	# specify Print String service
	jal print
	
exitdel:lw $ra,($sp)        	#   Pop stored $ra
        addi $sp,$sp,4             
	jr $ra
		


### Funcion que imprime todos los elementos del arrayList
## args: ninguno
## return: ninguno
###
	.data
ELEMENT:	.asciiz "\nElement "
SPACE:		.asciiz " : "
	.text
display:sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $ra,($sp) 		#copy return address to reserved stack memory place
	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $fp,($sp)		#copy frame pointer to reserved stack memory place
	sub $fp,$sp,8		#reserve 8 bytes for int element-> 0($fp), int flag -> 4($fp)
	move $sp,$fp		# $sp= $fp
	
	lw $t1, 88($s1)		# load array size
	li $t2, 0		# variable position
	move $t3, $s1		# move array

loopd:	la   $a0, ELEMENT       # load address of ELEMENT for syscall
	li   $a1, 4           	# specify Print String service
	jal print               # output string
	
	addi $t2, $t2, 1	# increase position
	la $a0, 0($t2)		# load address of position number
	li   $a1, 1          	# specify Print Integer service
	jal print               # print position number
	
	la   $a0, SPACE      	# load address of spacer for syscall
	li   $a1, 4         	# specify Print String service
	jal print               # output string
	
	lw   $a0, 0($t3)	# load array for syscall
	li   $a1, 1         	# specify Print Integer service
	jal print               # print array number
	
	addi $t3, $t3, 4   	# increment address
	addi $t1, $t1, -1     	# decrement loop counter
	bgtz $t1, loopd        	# repeat if not finished 
	
	addi $sp,$fp,8		# restoring $sp
	lw $fp,($sp)        	#   Pop stored $fp
        addi $sp,$sp,4       	           
        lw $ra,($sp)        	#   Pop stored $ra
        addi $sp,$sp,4             
	jr $ra
	
	
### Funcion que calcula e imprime el valor de la suma y el promedio del arrayList
##  args: ninguno
##  return: ninguno
###
	.data
THESUM:	.asciiz "\nThe sum is: "
THEAVG:	.asciiz "\nThe average is: "
	.text
average:sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $ra,($sp) 		#copy return address to reserved stack memory place
	sub $sp,$sp,4		#reserve 4 bytes on stack
	sw $fp,($sp)		#copy frame pointer to reserved stack memory place
	sub $fp,$sp,8		#reserve 8 bytes for float avg-> 0($fp), int sum -> 4($fp) (int i no va a ser alojado en memoria para optimizar)
	move $sp,$fp		# $sp= $fp
	sw $zero, 4($sp)	# sum= 0
	li $t1,0		# $t1 -> i
	lw $t2,88($s1)		# $t2 = l.length
	
forsum:	bge $t1,$t2,endforsum   # for(i<l.length)
	lw $t3,4($fp)		# $t3= sum
	move $t4,$s1		# $t4 -> l.list
	sll $t5,$t1,2		# $t5= i * 4
	add $t4,$t4,$t5		# $t4 -> l.list[i]
	lw $t6,($t4)		# $t6= l.list[i]
	add $t3,$t3,$t6		# sum= sum + l.list[i]
	sw $t3,4($sp)		# sum= $t3
	addi $t1,$t1,1		# i++
	j forsum
endforsum:
	la $a0, THESUM      	# load address of spacer for syscall
	li $a1, 4         	# specify Print String service
	jal print
	lw $t1,4($sp)		# $t1 = sum
	move $a0, $t1		# load int for syscall
	li $a1, 1         	# specify Print Integer service
	jal print
	lw $t2, 88($s1)		# $t2 = l.length (por si acaso volvemos a cargar :v)
	mtc1 $t1,$f1		# $f1 =	 sum <==> (float)sum
	mtc1 $t2,$f2		# $f2 = l.length <==> (float)l.length
	div.s $f3,$f1,$f2	# sum/ length
	swc1 $f3,0($fp)		# avg= $f3
	la $a0, THEAVG      	# load address of spacer for syscall
	li $a1, 4         	# specify Print String service
	jal print
	lw $t3, 0($fp)		# $t3= avg
	mtc1 $t3,$f12		# $f12= $t3
	li $v0,2		# code for print float
	syscall
	addi $sp,$fp,8		# restoring $sp
	lw $fp,($sp)        	#   Pop stored $fp
        addi $sp,$sp,4       	           
        lw $ra,($sp)        	#   Pop stored $ra
        addi $sp,$sp,4             
	jr $ra

### Funcion que verifica si el arrayList esta lleno
##  args: ninguno
##  return: $v0 -> valor booleano true(0) o false(1)
###
islistfull:	lw $t1, 88($s1)		# $t1 = l.length
		bne $t1,SIZE, elsefull
		li $v0,true		# $v0 = true
		jr $ra
elsefull:	li $v0,false		# $v0 = false
		jr $ra


### Funcion que verifica si el arrayList esta vacio
##  args: ninguno
##  return: $v0 -> valor booleano true(0) o false(1)
###
islistempty:	lw $t1, 88($s1)		# $t1 = l.length
		bne $t1,0, else_empty
		li $v0,true		# $v0 = true
		jr $ra
else_empty:	li $v0,false		# $v0 = false
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
	
