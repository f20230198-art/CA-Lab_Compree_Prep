# 🖥️ MIPS Lab Guide - Quick Reference

> **For your lab exam tomorrow!** Focus on understanding the code patterns.

---

## 📚 Contents

1. [MIPS Basics](#basics)
2. [Lab 1 — Hello World](#lab-1)
3. [Lab 2 — Arithmetic](#lab-2)
4. [Lab 3 — Loops & Conditions](#lab-3)
5. [Lab 4 — Arrays & Search](#lab-4)
6. [Lab 5 — Array Operations](#lab-5)
7. [Cheat Sheet](#cheat-sheet)

---

## <a name="basics"></a>MIPS Basics

### Program Structure
```mips
.data
# Declare strings and variables here

.text
main:
    # Your code here
    li $v0, 10    # Always exit
    syscall
```

### Registers You'll Use

| Register | Use |
|----------|-----|
| `$t0-$t9` | Store numbers |
| `$a0` | Pass to syscall |
| `$v0` | Syscall code / input value |
| `$zero` | Always 0 |

### Syscalls

| Action | `$v0` | Setup |
|--------|-------|-------|
| Print string | `4` | `$a0` = address |
| Print number | `1` | `$a0` = number |
| Read number | `5` | nothing → result in `$v0` |
| Exit | `10` | nothing |

### Instructions

```mips
# Load
li $t0, 5              # Put 5 into $t0
la $a0, msg            # Put address of msg into $a0
move $t1, $t0          # Copy $t0 to $t1

# Math
add $t2, $t0, $t1      # $t2 = $t0 + $t1
sub $t2, $t0, $t1      # $t2 = $t0 - $t1

# Multiply (MUST use mflo to get result!)
mult $t0, $t1          # Multiply
mflo $t2               # Get result

# Divide (mflo = quotient, mfhi = remainder)
div $t0, $t1           # Divide
mflo $t2               # Get quotient (17/5 = 3)
mfhi $t3               # Get remainder (17%5 = 2)

# Memory
sw $t0, num1           # Store $t0 to memory
lw $t0, num1           # Load from memory to $t0

# Branches
beq $t0, $t1, label    # If $t0 == $t1, jump
bne $t0, $t1, label    # If $t0 != $t1, jump
bgt $t0, $t1, label    # If $t0 > $t1, jump
blt $t0, $t1, label    # If $t0 < $t1, jump
j label                # Always jump
```

---

## <a name="lab-1"></a>Lab 1 — Hello World

### Code
```mips
.data
msg: .asciiz "Hello World" 

.text
main: 
    li $v0, 4          # 4 = print string
    la $a0, msg        # Load string address
    syscall 

    li $v0, 10         # 10 = exit
    syscall 
```

### Pattern
**Print string:** `li $v0, 4` → `la $a0, msg` → `syscall`  
**Exit:** `li $v0, 10` → `syscall`

---

## <a name="lab-2"></a>Lab 2 — Arithmetic

### Program 1: Sum Using Registers

```mips
.data 
input1:  .asciiz  "Enter integer 1: "
input2:  .asciiz  "Enter integer 2: "
result:  .asciiz  "The result is: " 

.text 
main:  
    # Print prompt & read first number
    li $v0, 4
    la $a0, input1
    syscall 
    li $v0, 5
    syscall 
    move $t0, $v0          # $t0 = first number

    # Print prompt & read second number
    li $v0, 4
    la $a0, input2
    syscall 
    li $v0, 5
    syscall
    move $t1, $v0          # $t1 = second number
    
    # Add
    add $t2, $t0, $t1      # $t2 = $t0 + $t1

    # Print result
    li $v0, 4
    la $a0, result 
    syscall
    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 10
    syscall 
```

### Pattern
**Read number:** `li $v0, 5` → `syscall` → `move $t0, $v0`  
**Print number:** `li $v0, 1` → `move $a0, $t0` → `syscall`

---

### Program 2: Sum Using Memory

```mips
.data 
input1:  .asciiz  "Enter integer 1: "
input2:  .asciiz  "Enter integer 2: "
result:  .asciiz  "The result is: " 
num1:    .word 0          # Memory location
num2:    .word 0
sum:     .word 0

.text 
main:  
    # Read & store first number
    li $v0, 4
    la $a0, input1
    syscall 
    li $v0, 5
    syscall 
    move $t0, $v0 
    sw $t0, num1           # Store to memory

    # Read & store second number
    li $v0, 4
    la $a0, input2
    syscall 
    li $v0, 5
    syscall
    move $t1, $v0 
    sw $t1, num2           # Store to memory
    
    # Load, add, store
    lw $t0, num1           # Load from memory
    lw $t1, num2
    add $t2, $t0, $t1 
    sw $t2, sum            # Store to memory

    # Print result
    li $v0, 4
    la $a0, result 
    syscall
    li $v0, 1
    lw $a0, sum            # Load from memory
    syscall

    li $v0, 10
    syscall 
```

### Pattern
**Memory:** `.word 0` → `sw $t0, num1` → `lw $t0, num1`

---

## <a name="lab-3"></a>Lab 3 — Loops & Conditions

### Program 1: Expression `a = a*b/c%d + e`

Follow precedence: `*` → `/` → `%` → `+`

```mips
.data
input1: .asciiz "Enter integer 1: "
input2: .asciiz "Enter integer 2: "
input3: .asciiz "Enter integer 3: "
input4: .asciiz "Enter integer 4: "
input5: .asciiz "Enter integer 5: "
result: .asciiz "The result is: "

.text
main:  
    # Read a, b, c, d, e into $t0, $t1, $t2, $t3, $t4
    li $v0, 4; la $a0, input1; syscall; li $v0, 5; syscall; move $t0, $v0
    li $v0, 4; la $a0, input2; syscall; li $v0, 5; syscall; move $t1, $v0
    li $v0, 4; la $a0, input3; syscall; li $v0, 5; syscall; move $t2, $v0
    li $v0, 4; la $a0, input4; syscall; li $v0, 5; syscall; move $t3, $v0
    li $v0, 4; la $a0, input5; syscall; li $v0, 5; syscall; move $t4, $v0
    
    # Step 1: a * b
    mult $t0, $t1
    mflo $t5               # $t5 = a*b

    # Step 2: (a*b) / c
    div $t5, $t2
    mflo $t6               # $t6 = (a*b)/c

    # Step 3: (a*b/c) % d
    div $t6, $t3
    mfhi $t7               # $t7 = remainder

    # Step 4: result + e
    add $t8, $t7, $t4      # $t8 = final result

    # Print
    li $v0, 4; la $a0, result; syscall
    li $v0, 1; move $a0, $t8; syscall
    li $v0, 10; syscall 
```

### Key Steps
1. `mult` → `mflo` (get product)
2. `div` → `mflo` (get quotient)
3. `div` → `mfhi` (get remainder)
4. `add` (final step)

---

### Program 2: Odd/Even Check

Logic: `number % 2 == 0` → even, else → odd

```mips
.data
input: .asciiz "Enter a number to check for odd or even: "
odd_result: .asciiz "The number is odd."
even_result: .asciiz "The number is even."

.text
main:	
    # Read number
    li $v0, 4; la $a0, input; syscall
    li $v0, 5; syscall
    move $t0, $v0          # $t0 = number
    
    # Get remainder when divided by 2
    li $t1, 2
    div $t0, $t1
    mfhi $t2               # $t2 = number % 2
    
    # Check if remainder is 0
    beq $t2, $zero, even   # If 0, even
    j odd                   # Else, odd

even: 
    li $v0, 4; la $a0, even_result; syscall
    j end

odd: 
    li $v0, 4; la $a0, odd_result; syscall

end: 
    li $v0, 10; syscall 
```

### If-Else Pattern
```mips
beq $t0, $t1, true_label    # If true
j false_label               # Else

true_label:
    # Code
    j end

false_label:
    # Code

end:
```

---

### Program 3: Sum of Digits

Logic: Extract last digit → add → remove digit → repeat

```mips
.data
input: .asciiz "Enter a number: "
result: .asciiz "The sum of digits: "

.text
main: 	
    # Read number
    li $v0, 4; la $a0, input; syscall
    li $v0, 5; syscall 
    move $t0, $v0          # $t0 = number

    li $t1, 10             # Divisor
    li $t2, 0              # $t2 = sum
    
sum:   
    beq $t0, $zero, end    # If number == 0, done
    j loop

loop: 
    div $t0, $t1           # Divide by 10
    mfhi $t3               # $t3 = last digit
    add $t2, $t2, $t3      # sum += digit
    mflo $t0               # number = number/10 (remove last digit)
    j sum

end: 
    li $v0, 4; la $a0, result; syscall
    li $v0, 1; move $a0, $t2; syscall
    li $v0, 10; syscall
```

### Loop Pattern
```mips
check:
    beq $t0, $zero, end    # Check condition
    j loop_body

loop_body:
    # Do work
    j check                 # Repeat
```

---

## <a name="lab-4"></a>Lab 4 — Arrays & Search

### Program 1: Expression `a = a - b*c + d%e`

```mips
.data
input1: .asciiz "Enter integer 1: "
input2: .asciiz "Enter integer 2: "
input3: .asciiz "Enter integer 3: "
input4: .asciiz "Enter integer 4: "
input5: .asciiz "Enter integer 5: "
result: .asciiz "The result is: "

.text
main:	
    # Read inputs into $t0-$t4
    li $v0, 4; la $a0, input1; syscall; li $v0, 5; syscall; move $t0, $v0
    li $v0, 4; la $a0, input2; syscall; li $v0, 5; syscall; move $t1, $v0
    li $v0, 4; la $a0, input3; syscall; li $v0, 5; syscall; move $t2, $v0
    li $v0, 4; la $a0, input4; syscall; li $v0, 5; syscall; move $t3, $v0
    li $v0, 4; la $a0, input5; syscall; li $v0, 5; syscall; move $t4, $v0

    # b * c
    mult $t1, $t2; mflo $t5

    # d % e
    div $t3, $t4; mfhi $t6

    # a - (b*c)
    sub $t7, $t0, $t5

    # result + (d%e)
    add $t8, $t7, $t6
    
    # Print
    li $v0, 4; la $a0, result; syscall
    li $v0, 1; move $a0, $t8; syscall
    li $v0, 10; syscall
```

---

### Program 2: Linear Search

Find a number in an array.

```mips
.data
num: .asciiz "Enter number to be found: "
found: .asciiz "The number is found at "
not_found: .asciiz "The number is not found."
array: .word 9, 10, 11, 12, 13, 14, 15, 16, 17, 18

.text
main: 	
    # Read search number
    li $v0, 4; la $a0, num; syscall
    li $v0, 5; syscall
    move $t0, $v0          # $t0 = search number
 
    la $t1, array          # $t1 = array address
    li $t2, 10             # $t2 = length
    li $t3, 0              # $t3 = index
    
loop: 	
    beq $t3, $t2, not_found1    # If index == length, not found
    lw $t4, 0($t1)              # Load array[i]
    beq $t4, $t0, found1        # If array[i] == search, found!
    addi $t3, $t3, 1            # index++
    addi $t1, $t1, 4            # Move to next (4 bytes!)
    j loop

found1: 
    li $v0, 4; la $a0, found; syscall
    li $v0, 1; move $a0, $t3; syscall
    j exit

not_found1: 
    li $v0, 4; la $a0, not_found; syscall

exit: 	
    li $v0, 10; syscall 
```

### Array Pattern
```mips
array: .word 1, 2, 3       # Declare
la $t0, array              # Get address
lw $t1, 0($t0)             # array[0]
lw $t1, 4($t0)             # array[1] (+4 bytes)
addi $t0, $t0, 4           # Move to next
```

---

### Program 3: Factorial

Calculate `n! = n × (n-1) × ... × 1`

```mips
.data
num: .asciiz "Enter a number: "
fact: .asciiz "Factorial is: "

.text
main: 	
    # Read number
    li $v0, 4; la $a0, num; syscall
    li $v0, 5; syscall
    move $t0, $v0          # $t0 = n

    li $t1, 1              # Lower bound
    li $t2, 1              # $t2 = i (counter)
    li $t3, 1              # $t3 = factorial result
    
    blt $t0, $t1, exit     # If n < 1, skip
    ble $t2, $t0, loop

loop:  	
    mult $t3, $t2          # factorial *= i
    mflo $t3
    addi $t2, $t2, 1       # i++
    bgt $t2, $t0, end      # If i > n, done
    j loop
    
end: 	
    li $v0, 4; la $a0, fact; syscall
    li $v0, 1; move $a0, $t3; syscall

exit:	
    li $v0, 10; syscall
```

---

## <a name="lab-5"></a>Lab 5 — Array Operations

### Program 1: Largest Element

```mips
.data
result: .asciiz "The largest element is: "
array: .word 10, 20, 30, 40, 50, 60, 70, 80, 90, 100

.text
main: 	
    la $t0, array          # $t0 = array address
    li $t1, 10             # Length
    li $t2, 1              # Index (start at 1)
    lw $t3, 0($t0)         # $t3 = largest (first element)
    addi $t0, $t0, 4       # Move to second

loop:	
    beq $t2, $t1, exit
    lw $t4, 0($t0)         # Load current
    bgt $t4, $t3, largest  # If bigger, update
    addi $t2, $t2, 1       # index++
    addi $t0, $t0, 4       # Next element
    j loop

largest:	
    move $t3, $t4          # Update largest
    addi $t2, $t2, 1
    addi $t0, $t0, 4
    j loop

exit:	
    li $v0, 4; la $a0, result; syscall
    li $v0, 1; move $a0, $t3; syscall
    li $v0, 10; syscall 
```

---

### Program 2: Sum of 5 Elements (User Input)

```mips
.data
array: .space 20           # Empty array (5 × 4 bytes)
msg: .asciiz "Enter 5 elements: "
sum: .asciiz "Sum of elements is: "

.text
main: 	
    li $v0, 4; la $a0, msg; syscall
    la $t0, array

    # Read 5 numbers
    li $v0, 5; syscall; sw $v0, 0($t0)
    li $v0, 5; syscall; sw $v0, 4($t0)
    li $v0, 5; syscall; sw $v0, 8($t0)
    li $v0, 5; syscall; sw $v0, 12($t0)
    li $v0, 5; syscall; sw $v0, 16($t0)

    # Sum them
    li $t1, 0              # sum
    li $t2, 5              # length
    li $t3, 0              # index

loop: 	
    beq $t3, $t2, end
    lw $t4, 0($t0)         # Load element
    add $t1, $t1, $t4      # sum += element
    addi $t3, $t3, 1
    addi $t0, $t0, 4
    j loop

end: 	
    li $v0, 4; la $a0, sum; syscall
    li $v0, 1; move $a0, $t1; syscall
    li $v0, 10; syscall
```

### `.space` Pattern
```mips
array: .space 20           # Reserve 20 bytes
li $v0, 5; syscall
sw $v0, 0($t0)             # Store input
```

---

### Program 3: Add Two Arrays

`C[i] = A[i] + B[i]`

```mips
.data
array1: .word 11, 13, 15, 17, 19
array2: .word 1, 3, 5, 7, 9
array3: .word 0, 0, 0, 0, 0
result: .asciiz "The resultant array is: "
space: .asciiz " "

.text
main: 	
    la $t1, array1         # Pointer to array1
    la $t2, array2         # Pointer to array2
    la $t3, array3         # Pointer to array3
    li $t4, 0              # Index
    li $t5, 5              # Length

loop:	
    beq $t4, $t5, end
    
    lw $t6, 0($t1)         # Load array1[i]
    lw $t7, 0($t2)         # Load array2[i]
    add $t0, $t6, $t7      # Add
    sw $t0, 0($t3)         # Store in array3[i]
    
    # Move all pointers
    addi $t1, $t1, 4
    addi $t2, $t2, 4
    addi $t3, $t3, 4
    addi $t4, $t4, 1
    j loop

end: 	
    li $v0, 4; la $a0, result; syscall
    
    # Print array3
    la $t3, array3
    li $t4, 0

p_loop:	
    beq $t4, $t5, exit
    li $v0, 4; la $a0, space; syscall
    li $v0, 1; lw $a0, 0($t3); syscall
    addi $t3, $t3, 4
    addi $t4, $t4, 1
    j p_loop

exit:	
    li $v0, 10; syscall
```

### Multiple Arrays Pattern
```mips
la $t1, array1; la $t2, array2; la $t3, array3
lw $t6, 0($t1)         # Get from array1
lw $t7, 0($t2)         # Get from array2
add $t0, $t6, $t7      # Process
sw $t0, 0($t3)         # Store in array3
# Move all 3 pointers
addi $t1, $t1, 4; addi $t2, $t2, 4; addi $t3, $t3, 4
```

---

## <a name="cheat-sheet"></a>Cheat Sheet

### Template
```mips
.data
# Declare here

.text
main:
    # Code here
    li $v0, 10
    syscall
```

### Syscalls
```mips
# Print string
li $v0, 4; la $a0, msg; syscall

# Print number
li $v0, 1; move $a0, $t0; syscall

# Read number
li $v0, 5; syscall; move $t0, $v0

# Exit
li $v0, 10; syscall
```

### Math
```mips
add $t2, $t0, $t1          # Add
sub $t2, $t0, $t1          # Subtract
mult $t0, $t1; mflo $t2    # Multiply
div $t0, $t1; mflo $t2     # Divide (quotient)
div $t0, $t1; mfhi $t2     # Modulo (remainder)
```

### Loops
```mips
# For loop
li $t0, 0              # i = 0
li $t1, 10             # n = 10
loop:
    beq $t0, $t1, end  # if i == n, exit
    # body
    addi $t0, $t0, 1   # i++
    j loop
end:

# While loop
check:
    beq $t0, $zero, end    # while $t0 != 0
    # body
    j check
end:
```

### If-Else
```mips
beq $t0, $t1, true
# false code
j end

true:
# true code

end:
```

### Arrays
```mips
# Declare
array: .word 1, 2, 3       # Pre-filled
array: .space 12           # Empty (3 integers)

# Access
la $t0, array              # Get address
lw $t1, 0($t0)             # array[0]
lw $t1, 4($t0)             # array[1]
lw $t1, 8($t0)             # array[2]

# Traverse
la $t0, array
li $t1, 5                  # length
li $t2, 0                  # index
loop:
    beq $t2, $t1, end
    lw $t3, 0($t0)         # Load element
    # Process $t3
    addi $t0, $t0, 4       # Next (+4!)
    addi $t2, $t2, 1       # index++
    j loop
```

### Key Points
- Always multiply/divide → use `mflo`/`mfhi`
- Read input → immediately `move` to register
- Arrays → each element is 4 bytes apart
- Always exit with `li $v0, 10; syscall`

---

## Exam Tips

1. **Read question** → identify: input, output, logic
2. **Write structure:**
   ```mips
   .data
   .text
   main:
       # code
       li $v0, 10
       syscall
   ```
3. **Follow patterns** from this guide
4. **Test mentally** with small numbers
5. **Check:**
   - Exit at end?
   - `mflo` after `mult`/`div`?
   - Array offsets = 4, 8, 12... ?

**Good luck! 🍀**
