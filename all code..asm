Computer Architecture Lab Codes 
Lab 1: Hello World Program 
	.data
msg:     .asciiz “Hello World” 

	.text

main: li $v0, 4
          la $a0, msg
          syscall 

          li $v0, 10
          syscall 




Lab 2: Sum of Numbers 

Program 1: Write a program to find the sum of two numbers by storing them in temporary registers 

	.data 
input1:  .asciiz  “Enter integer 1: ”
input2:  .asciiz  “Enter integer 2: ”
result:   .asciiz  “The result is: ” 

	.text 
main:  li $v0, 4
           la $a0, input1
           syscall 

           li $v0, 5
           syscall 
           move $t0, $v0 

           li $v0, 4
           la $a0, input2
           syscall 

           li $v0, 5
           syscall
           move $t1, $v0 
           
           add $t2, $t0, $t1

           li $v0, 4
           la $a0, result 
           syscall

           li $v0, 1
        move $a0, $t2
        syscall

        li $v0, 10
        syscall 


Program 2: Find the sum of two numbers by storing them in the memory. 
Note: The only difference between the two programs is in the instructions used. Here we use load word and store word. 
	.data 
input1:  .asciiz  “Enter integer 1: ”
input2:  .asciiz  “Enter integer 2: ”
result:   .asciiz  “The result is: ” 
num1:   .word 0
num2:   .word 0
sum:     .word 0

	.text 
main:  li $v0, 4
           la $a0, input1
           syscall 

           li $v0, 5
           syscall 
           move $t0, $v0 
           sw $t0,num1

           li $v0, 4
           la $a0, input2
           syscall 

           li $v0, 5
           syscall
           move $t1, $v0 
           sw $t1, num2
           
           lw $t0,num1
           lw $t1,num2
           add $t2, $t0, $t1 
           sw $t2, sum 

           li $v0, 4
           la $a0, result 
           syscall

           li $v0, 1
lw $a0,sum
syscall

li $v0,10
syscall 



Lab 3: 
Questions: 

Program 1: Write the MIPS ALP for the high-level code. Observe the precedence and associativity rules. 
  a = a * b / c % d + e

	.data
input1: .asciiz “Enter integer 1: ”
input2: .asciiz “Enter integer 2: ”
input3: .asciiz “Enter integer 3: ”
input4: .asciiz “Enter integer 4: ”
input5: .asciiz “Enter integer 5: ”
result: .asciiz “The result is: ”

	.text
main:  li $v0,4
           la $a0,input1
           syscall 

           li $v0,5
           syscall
           move $t0,$v0

           li $v0,4
           la $a0,input2
           syscall

           li $v0,5
           syscall
           move $t1,$v0

           li $v0,4
           la $a0,input3
           syscall

           li $v0,5
           syscall 
           move $t2,$v0

           li $v0,4
           la $a0,input4
           syscall 
           
           li $v0,5
          syscall
          move $t3,$v0
          
          li $v0,4
          la $a0,input5
          syscall 

          li $v0,5
          syscall
          move $t4,$v0
          
          mult $t0,$t1
          mflo $t5
          div $t5,$t2
          mflo $t6
          div $t6,$t2
          mfhi $t7
          add $t8,$t7,$t4

          li $v0,4
          la $a0,result
          syscall

          li $v0,1
          move $a0,$t8
          syscall

          li $v0,10
          syscall 



Program 2: To read a number N from input and find if the number is odd or even. Display the result to the user. 

Note: Example Code for Jump 
.text 
main: 
	li $v0,5
	li $t1,5
	
	beq $t0,$t1,equal_label
	j not_equal_label

	equal label: 
	li $v0,4
	la $a0,equal_msg
	syscall
	j end

	not_equal_label: 
	li $v0,4
	la $a0,not_equal_msg
	syscall

	end: 
	li $v0,10
	syscall 

Program 2 Solution: 
	.data
input: .asciiz “Enter a number to check for odd or even: ”
odd_result: .asciiz “The number is odd.”
even_result: .asciiz “The number is even.”

	.text
main:	li $v0,4
	la $a0,input 
	syscall

	li $v0,5
	syscall
	move $t0,$v0
	
	li $t1,2
	div $t0,$t1
	mfhi $t2
	beq $t2,$zero,even
	j odd

	even: 
	li $v0,4
	la $a0,even_result
	syscall
	j end

	odd: 
	li $v0,4
	la $a0,odd_result
	syscall

	end: 
	li $v0,10
	syscall 
Program 3: 
To find the sum of digits of a number N. Display the result to the user. 
Sum = 0;
While (N != 0) 
{
Remainder = N % 10;
Sum = Sum + Remainder;
N = N / 10;
}
 	.data
input: .asciiz “Enter a number: ”
result: .asciiz “The sum of digits: ”

	.text
main: 	li $v0,4
	la $a0,input
	syscall

	li $v0,5
	syscall 
	move $t0,$v0

	li $t1,10 
	li $t2,0
	
sum:   
beq $t0,$zero,end
j loop 

loop: 
div $t0,$t1
mfhi $t3 
add $t2,$t2,$t3
mflo $t0
j sum 

end: 
li $v0, 4
la $a0, result
syscall

li $v0,1
move $a0,$t2
syscall

li $v0,10
syscall



Lab 4: 
Q1) Write the MIPS ALP for the high-level code. Observe precedence and associativity rules. 

a = a – b * c + d % e 

	.data
input1:  .asciiz “Enter integer 1: ”
input2:  .asciiz “Enter integer 2: ”
input3:  .asciiz “Enter integer 3: ”
input4:  .asciiz “Enter integer 4: ”
input5:  .asciiz “Enter integer 5: ”
result: .asciiz “The result is: ”

	.text
main:	li $v0, 4
	la $a0,input1
	syscall

	li $v0,5
	syscall
	move $t0,$v0

	li $v0,4
	la $a0,input2
	syscall

	li $v0,5
	syscall 
	move $t1,$v0

	li $v0,4
	la $a0,input3
	syscall

	li $v0,5
	syscall
	move $t2,$v0

	li $v0,4
	la $a0,input4
	syscall

	li $v0,5
	syscall
	move $t3,$v0

	li $v0,4
	la $a0, input5
	syscall 

	li $v0,5
	syscall
	move $t4,$v0   	

	mult $t1, $t2
	mflo $t5
	div $t3, $t4
	mfhi $t6 
	sub $t7, $t0, $t5
	add $t8, $t7, $t6 
	
	li $v0, 4
	la $a0, result
	syscall

	li $v0, 1
	move $a0,$t8
	syscall

	li $v0,10
	syscall

Q2) Linear Search: 
flag = 0 
for (i=0; i< length; i++)
	if (A[i] == x) 
	{ 
	flag = 1;
	break;
	}
if flag == 0
printf(“Element not found”)
else 
printf(“Element found at position %d, i);

	.data
num: .asciiz “Enter number to be found: ”
found: .asciiz “The number is found at ”
not_found: .asciiz “The number is not found.”
array: .word 9, 10, 11, 12, 13, 14, 15, 16, 17, 18

	.text
main: 	li $v0,4
	la $a0,num
	syscall

	li $v0,5
	syscall
	move $t0,$v0
 
	la $t1, array (loads address of the array) 
	li $t2, 10 (loading the length of the array) 
	li $t3, 0 (i = 0) 
	
loop: 	beq $t3, $t2, not_found1
	lw $t4, 0($t1)
	beq $t4, $t0, found1
	addi $t3, $t3, 1
	addi $t1, $t1, 4
	j loop

found1: li $v0, 4
	la $a0, found
	syscall

	li $v0,1
	move $a0,$t3
	syscall

	j exit

not_found1: li $v0,4
	       la $a0,not_found
	       syscall

exit: 	li $v0, 10
	syscall 
Q3) factorial 
if (n>=1) 
{
for (i = 1;  i <= n; i++) 
{
factorial *= i;
}
}

	.data
num: .asciiz “Enter a number: ”
fact: .asciiz “Factorial is: ”

	.text
main: 	li $v0,4
	la $a0,num
	syscall

	li $v0,5
	syscall
	move $t0,$v0
	
	li $t1,1
	li $t2,1
	li $t3,1
	blt $t0, $t1, exit

	ble $t2, $t0, loop
loop:  	mult $t3, $t2
	mflo $t3
	addi $t2, $t2, 1
	bgt $t2, $t0, end
	j loop
	
end: 	li $v0,4
	la $a0, fact
	syscall
	li $v0,1
	move $a0,$t3
	syscall

exit:	li $v0,10
	syscall


Lab 5: 	
Questions: 

Find the largest element of a word array A which has 10 elements. 
Sum of the elements of a word array A having 5 elements and display the result to the user. 
Assume you have two-word arrays A and B that have 5 elements each. Sum the corresponding elements of the two arrays A and B. Store the result in word array C. 
for (i = 0; i <  5; i++)
C[i] = A[i] + B[i];
Program 1: 

	.data
result: .asciiz “The largest element is: ”
array: .word 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
	.text

main: 	la $t0, array
	li $t1, 10
	li $t2, 1 
	lw $t3, 0($t0)
	addi $t0, $t0, 4

loop:	beq $t2, $t1, exit
	lw $t4, 0($t0)
	bgt $t4, $t3, largest
	addi $t2, $t2, 1
	addi $t0, $t0, 4
	j loop

largest:	move $t3, $t4
	addi $t2, $t2, 1
	addi $t0, $t0, 4
	j loop

exit:	li $v0, 4
	la $a0, result
	syscall

	li $v0,1
	move $a0, $t3
	syscall
	
	li $v0, 10
	syscall 
Program 2: 

	.data
array: .space 20
msg: .asciiz “Enter 5 elements: ”
sum: .asciiz “Sum of elements is: ”
	.text

main: 	li $v0, 4
	la $a0, msg
	syscall
	
	la $t0, array 

	li $v0,5 
	syscall
	sw $v0, 0($t0)

	li $v0,5
	syscall
	sw $v0, 4($t0)

	li $v0,5
	syscall
	sw $v0, 8($t0)

	li $v0,5
	syscall
	sw $v0, 12($t0)

	li $v0,5
	syscall
	sw $v0, 16($t0)

	li $t1, 0
	li $t2, 5
	li $t3, 0 

loop: 	beq $t3, $t2, end
	lw $t4, 0($t0)
	add $t1, $t1, $t4
	addi $t3, $t3, 1
	addi $t0, $t0, 4
	j loop

end: 	li $v0,5 
	la $a0, sum 
	syscall

	li $v0,1
	move $a0, $t1
	syscall

	li $v0,10
	syscall
 
Program 3: 

	.data
array1: .word 11, 13, 15, 17, 19
array2: .word 1, 3, 5, 7, 9
array3: .word 0, 0, 0, 0, 0
result: .asciiz "The resultant array is: "
space: .asciiz " "
	.text

main: 	la $t1, array1
	la $t2, array2
	la $t3, array3

	li $t4,0  #index counter
	li $t5,5  

loop:	beq $t4, $t5, end
	lw $t6, 0($t1)
	lw $t7, 0($t2)
	li $t0, 0            #sum counter 
	add $t0, $t6, $t7
	sw $t0, 0($t3)
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	addi $t3, $t3, 4
	addi $t4, $t4, 1
	j loop

end: 	li $v0, 4
	la $a0, result
	syscall

	la $t3, array3
	li $t4, 0

p_loop:	beq $t4, $t5, exit
	li $v0,4
	la $a0,space
	syscall

	li $v0,1
	lw $a0,0($t3)
	syscall
	addi $t3, $t3, 4
	addi $t4, $t4, 1
	j p_loop

exit:	li $v0, 10
	syscall
