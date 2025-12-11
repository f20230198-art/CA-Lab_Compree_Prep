# 🖥️ MIPS Assembly - Part 2 (Labs 6-9)

> **Continuation of your CA Lab Guide** - String operations, procedures, recursion, and floating-point

---

## 📚 Contents

1. [Lab 6 — String Operations](#lab-6)
2. [Lab 7 — Procedures (Functions)](#lab-7)
3. [Lab 8 — Recursion](#lab-8)
4. [Lab 9 — Floating Point](#lab-9)
5. [Quick Reference](#quick-ref)

---

## <a name="lab-6"></a>Lab 6 — String Operations

### 🎯 New Concept: Working with Characters

**Strings** = arrays of characters. Each character is 1 byte.

### New Instructions

```mips
lb $t2, 0($t0)      # Load Byte: load 1 character
sb $t2, 0($t3)      # Store Byte: store 1 character
lbu $t2, 0($t0)     # Load Byte Unsigned
beqz $t2, label     # Branch if $t2 == 0 (end of string)
```

**Key:** Strings end with null character (`\0` = 0)

---

### Program 1: String Length

Count characters until you hit `\0`.

```mips
.data
myString: .asciiz "Hello World!"
output: .asciiz "The string length is: "

.text
main:   
    la $t0, myString       # $t0 = string address
    li $t1, 0              # $t1 = counter

loop_start:    
    lb $t2, 0($t0)         # Load 1 character
    beqz $t2, loop_end     # If char == 0, done
    addi $t1, $t1, 1       # counter++
    addi $t0, $t0, 1       # Move to next char (+1 byte!)
    j loop_start

loop_end:      
    li $v0, 4
    la $a0, output
    syscall

    li $v0, 1
    move $a0, $t1          # Print length
    syscall

    li $v0, 10
    syscall
```

### How It Works

| Step | `$t0` points to | `$t2` (char) | `$t1` (count) |
|------|-----------------|--------------|---------------|
| 1 | 'H' | 'H' (not 0) | 1 |
| 2 | 'e' | 'e' (not 0) | 2 |
| ... | ... | ... | ... |
| 12 | '!' | '!' (not 0) | 12 |
| 13 | '\0' | 0 | 12 (stop) |

**Pattern:** Strings use +1 (not +4 like integers!)

---

### Program 2: Reverse String

Read string → reverse → store in new location.

```mips
.data
string: .asciiz "Computer Architecture"
revstr: .space 100
output: .asciiz "The reversed string is: "

.text  
main:  
    la $t0, string
    li $t1, 0
  
    # Step 1: Find length
str_length:    
    lbu $t2, 0($t0)
    beqz $t2, end_loop
    addi $t0, $t0, 1       # Move forward
    addi $t1, $t1, 1       # Count++
    j str_length
 	
end_loop:      
    la $t3, revstr         # $t3 = destination address
    addi $t0, $t0, -1      # Move to last character
 
    # Step 2: Copy backwards
rev_loop:      
    bge $zero, $t1, end_rev_loop    # If count <= 0, done
    lbu $t4, 0($t0)        # Load char from end
    sb $t4, ($t3)          # Store in revstr
    addi $t0, $t0, -1      # Move backward in original
    addi $t3, $t3, 1       # Move forward in reversed
    addi $t1, $t1, -1      # counter--
    j rev_loop

end_rev_loop:   
    sb $zero, ($t3)        # Add null terminator!

    li $v0, 4
    la $a0, output
    syscall

    li $v0, 4
    la $a0, revstr         # Print reversed string
    syscall

    li $v0, 10
    syscall
```

### Logic

For "ABC":
1. Find length = 3
2. Start at 'C' (end)
3. Copy: C → revstr[0], B → revstr[1], A → revstr[2]
4. Result: "CBA"

---

### Program 3: Palindrome Check

Check if string reads same forwards and backwards.

```mips
.data
enter: .asciiz "Enter an input string: "
palindrome_msg: .asciiz "The given string is a palindrome."
not_palindrome_msg: .asciiz "The given string is not a palindrome."
inputstr: .space 100

.text
main:   
    # Read string from user
    li $v0, 4
    la $a0, enter
    syscall
 
    li $v0, 8              # 8 = read string
    la $a0, inputstr
    li $a1, 100            # Max 100 chars
    syscall
 
    la $a0, inputstr
    move $t0, $a0
    li $t1, 0
 
    # Find length
str_len: 
    lb $t2, ($a0)
    beqz $t2, end_len
    addi $t1, $t1, 1
    addi $a0, $a0, 1
    j str_len

end_len: 
    la $a0, inputstr
    la $t0, inputstr       # $t0 = start
    add $t3, $a0, $t1
    addi $t3, $t3, -2      # $t3 = end (skip newline)

    # Compare from both ends
check_palindrome: 
    blt $t3, $t0, is_palindrome    # If pointers crossed, palindrome!
    lb $t4, ($t0)          # Char from start
    lb $t5, ($t3)          # Char from end
    bne $t4, $t5, not_palindrome   # If different, not palindrome
    addi $t0, $t0, 1       # Move start forward
    addi $t3, $t3, -1      # Move end backward
    j check_palindrome
 
is_palindrome: 		
    li $v0, 4
    la $a0, palindrome_msg
    syscall
    j exit
 
not_palindrome: 	
    li $v0, 4
    la $a0, not_palindrome_msg
    syscall

exit: 	
    li $v0, 10
    syscall
```

### How It Works

For "RACECAR":
- Compare R (start) with R (end) ✓
- Compare A with A ✓
- Compare C with C ✓
- Compare E with E ✓
- Pointers meet → Palindrome!

For "HELLO":
- Compare H with O ✗ → Not palindrome

---

### Program 4: Concatenate Strings

Join two strings into one.

```mips
.data
input1: .asciiz "Enter first string: "
input2: .asciiz "Enter second string: "
output: .asciiz "Concatenated string is: "
str1: .space 100
str2: .space 100
concat: .space 200

.text
main: 
    # Read first string
    li $v0, 4
    la $a0, input1
    syscall

    li $v0, 8
    la $a0, str1
    li $a1, 100
    syscall

    # Read second string
    li $v0, 4 
    la $a0, input2
    syscall

    li $v0, 8
    la $a0, str2
    li $a1, 100
    syscall

    la $t0, str1
    la $t1, str2
    la $t2, concat

    # Copy str1 to concat
copy_str1_loop:	
    lb $t3, ($t0)
    sb $t3, ($t2)
    beqz $t3, end_copy_str1
    addi $t0, $t0, 1 
    addi $t2, $t2, 1
    j copy_str1_loop

end_copy_str1: 	
    addi $t2, $t2, -1      # Go back (overwrite null)

    # Copy str2 after str1
copy_str2_loop: 
    lb $t3, ($t1)
    sb $t3, ($t2)
    beqz $t3, end_copy_str2
    addi $t1, $t1, 1
    addi $t2, $t2, 1
    j copy_str2_loop

end_copy_str2: 	
    li $v0, 4
    la $a0, output
    syscall

    li $v0, 4
    la $a0, concat
    syscall

    li $v0, 10
    syscall
```

### Logic

If str1 = "Hello" and str2 = "World":
1. Copy "Hello\0" to concat
2. Go back 1 (to overwrite \0)
3. Copy "World\0" 
4. Result: "HelloWorld\0"

---

### String Patterns Summary

```mips
# Load string address
la $t0, string

# Loop through string
loop:
    lb $t1, 0($t0)         # Load char
    beqz $t1, end          # Check if null
    # Process $t1
    addi $t0, $t0, 1       # Next char (+1!)
    j loop

# Read string from user
li $v0, 8
la $a0, buffer
li $a1, 100                # Max length
syscall
```

---

## <a name="lab-7"></a>Lab 7 — Procedures (Functions)

### 🎯 New Concept: Calling Functions

**Procedures** = reusable code blocks (like functions in C).

### New Instructions

```mips
jal function_name     # Jump And Link: call function
jr $ra                # Jump Register: return from function

# Argument registers
$a0-$a3              # Pass arguments to function

# Return registers
$v0-$v1              # Return values from function

# Saved registers
$s0-$s7              # Keep values across function calls
```

---

### Program 1: Calculator with 4 Functions

Main calls: sum, diff, prod, quot procedures.

```mips
.data
input1: .asciiz "Enter first number x: "
input2: .asciiz "Enter second number y: "
sum_msg: .asciiz "Sum is: "
diff_msg: .asciiz "Difference is: "
prod_msg: .asciiz "Product is: "
quot_msg: .asciiz "Quotient is: "
newline: .asciiz "\n"

.text
main:	
    # Read inputs
    li $v0, 4; la $a0, input1; syscall
    li $v0, 5; syscall; move $s0, $v0      # $s0 = x
	
    li $v0, 4; la $a0, input2; syscall
    li $v0, 5; syscall; move $s1, $v0      # $s1 = y

    # Call sum
    move $a0, $s0
    move $a1, $s1
    jal sum                # Call function
    move $s2, $v0          # $s2 = result

    # Call diff
    move $a0, $s0
    move $a1, $s1
    jal diff
    move $s3, $v0

    # Call prod
    move $a0, $s0
    move $a1, $s1
    jal prod
    move $s4, $v0

    # Call quot
    move $a0, $s0
    move $a1, $s1
    jal quot
    move $s5, $v0

    # Print all results
    li $v0, 4; la $a0, sum_msg; syscall
    li $v0, 1; move $a0, $s2; syscall
    li $v0, 4; la $a0, newline; syscall

    li $v0, 4; la $a0, diff_msg; syscall
    li $v0, 1; move $a0, $s3; syscall
    li $v0, 4; la $a0, newline; syscall

    li $v0, 4; la $a0, prod_msg; syscall
    li $v0, 1; move $a0, $s4; syscall
    li $v0, 4; la $a0, newline; syscall

    li $v0, 4; la $a0, quot_msg; syscall
    li $v0, 1; move $a0, $s5; syscall
    li $v0, 4; la $a0, newline; syscall

    li $v0, 10
    syscall

# Function definitions
sum:	 
    add $v0, $a0, $a1      # $v0 = $a0 + $a1
    jr $ra                 # Return

diff:	 
    sub $v0, $a0, $a1
    jr $ra 

prod: 	 
    mult $a0, $a1
    mflo $v0
    jr $ra

quot:    
    div $a0, $a1
    mflo $v0
    jr $ra 
```

### Function Pattern

```mips
# Calling a function
move $a0, value1       # Put args in $a0, $a1, $a2, $a3
move $a1, value2
jal function_name      # Call
move $t0, $v0          # Get result from $v0

# Defining a function
function_name:
    # Do work
    # Put result in $v0
    jr $ra             # Return
```

---

### Program 2: Linear Search with Procedure

Pass array address, size, and search element to function.

```mips
.data
array: .word 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
array_size: .word 10
found_msg: .asciiz "The element is found: "
not_found_msg: .asciiz "The element is not found." 
index_msg: .asciiz "The element is found at index: "
newline: .asciiz "\n"

.text
main: 	
    la $a0, array          # $a0 = array address
    lw $a1, array_size     # $a1 = size
    li $a2, 90             # $a2 = search element

    jal linear_search      # Call function
    move $t1, $v0          # $v0 = found flag (1 or 0)
                           # $t0 = index (set by function)

    beqz $t0, not_found
    j found

found: 
    li $v0, 4; la $a0, found_msg; syscall
    li $v0, 1; move $a0, $t1; syscall
    li $v0, 4; la $a0, newline; syscall
    li $v0, 4; la $a0, index_msg; syscall
    li $v0, 1; move $a0, $t0; syscall
    j end

not_found:
    li $v0, 4; la $a0, not_found_msg; syscall
    j end

# Function: linear_search
# Args: $a0 = array, $a1 = size, $a2 = search element
# Returns: $v0 = 1 (found) or 0 (not found), $t0 = index
linear_search: 	
    li $t0, 0              # index = 0

search_loop:
    bge $t0, $a1, not_found_func 

    sll $t1, $t0, 2        # $t1 = index * 4
    add $t2, $a0, $t1      # $t2 = address of array[index]
    lw $t3, ($t2)          # $t3 = array[index]
    beq $t3, $a2, found_func

    addi $t0, $t0, 1       # index++
    j search_loop

found_func: 
    li $v0, 1              # Return 1
    jr $ra

not_found_func:     
    li $v0, 0              # Return 0
    jr $ra 

end:
    li $v0, 10
    syscall
```

### New: `sll` (Shift Left Logical)

```mips
sll $t1, $t0, 2        # $t1 = $t0 << 2 = $t0 * 4
```

Used to calculate array offset: `index * 4`

---

### Program 3: Fibonacci with Procedure

Generate Fibonacci series: 0, 1, 1, 2, 3, 5, 8, 13...

```mips
.data
prompt: .asciiz "Enter n for fibonacci: "
space: .asciiz " "
newline: .asciiz "\n"

.text
main:   
    li $v0, 4; la $a0, prompt; syscall
    li $v0, 5; syscall
    move $t0, $v0          # $t0 = n
 
    li $t1, 0              # a = 0
    li $t2, 1              # b = 1
 
    # Print first number (0)
    move $a0, $t1
    li $v0, 1; syscall
    li $v0, 4; la $a0, space; syscall
 
    ble $t0, 1, end
    
    # Print second number (1)
    move $a0, $t2
    li $v0, 1; syscall
    li $v0, 4; la $a0, space; syscall
 
    li $t3, 2              # counter = 2
 
fib_loop: 
    bge $t3, $t0, end
    
    move $a0, $t1
    move $a1, $t2
    jal fib_proc           # Call: fib(a, b)
    
    move $t1, $t2          # a = b
    move $t2, $v0          # b = result
 
    move $a0, $v0
    li $v0, 1; syscall
    li $v0, 4; la $a0, space; syscall
 
    addi $t3, $t3, 1
    j fib_loop
 
end: 
    li $v0, 10
    syscall

# Function: fib_proc
# Args: $a0 = a, $a1 = b
# Returns: $v0 = a + b
fib_proc:
    add $v0, $a0, $a1      # Return a + b
    jr $ra
```

---

## <a name="lab-8"></a>Lab 8 — Recursion

### 🎯 New Concept: Functions Calling Themselves

**Recursion** = function calls itself. Need to save state on **stack**.

### Stack Operations

```mips
addi $sp, $sp, -8      # Allocate space on stack (8 bytes)
sw $ra, 4($sp)         # Save return address
sw $a0, 0($sp)         # Save argument

# Do work...

lw $a0, 0($sp)         # Restore argument
lw $ra, 4($sp)         # Restore return address
addi $sp, $sp, 8       # Deallocate stack space
jr $ra                 # Return
```

---

### Program 1: Power (Recursive)

Calculate `a^n` using recursion.

```mips
.data
input1: .asciiz "Enter a number a: "
exponent1: .asciiz "Enter the exponent n: "
result: .asciiz "Power of n is: "
newline: .asciiz "\n"

.text
main:	
    li $v0, 4; la $a0, input1; syscall
    li $v0, 5; syscall; move $s0, $v0      # $s0 = a

    li $v0, 4; la $a0, exponent1; syscall
    li $v0, 5; syscall; move $s1, $v0      # $s1 = n
	
    move $a0, $s0
    move $a1, $s1 
    jal power              # Call power(a, n)

    move $s2, $v0
	
    li $v0, 4; la $a0, result; syscall
    li $v0, 1; move $a0, $s2; syscall
    li $v0, 4; la $a0, newline; syscall
    li $v0, 10; syscall

# Recursive function: power(a, n)
# if (n == 1) return a
# else return a * power(a, n-1)
power:	
    addi $sp, $sp, -8      # Allocate stack
    sw $ra, 4($sp)         # Save return address
    sw $a1, 0($sp)         # Save n

    li $t0, 1
    beq $a1, $t0, base_case    # If n == 1, base case
	
    addi $a1, $a1, -1      # n = n - 1
    jal power              # Recursive call: power(a, n-1)
    
    lw $a1, 0($sp)         # Restore n
    lw $ra, 4($sp)         # Restore return address
    mul $v0, $a0, $v0      # result = a * power(a, n-1)
    addi $sp, $sp, 8       # Deallocate stack
    jr $ra 

base_case:	
    move $v0, $a0          # Return a
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra 
```

### How Recursion Works

For `power(2, 3)`:
1. Call power(2, 3) → calls power(2, 2)
2. Call power(2, 2) → calls power(2, 1)
3. power(2, 1) → returns 2 (base case)
4. power(2, 2) → returns 2 * 2 = 4
5. power(2, 3) → returns 2 * 4 = 8

---

### Program 2: Binary Search (Recursive)

Search in sorted array recursively.

```mips
.data
array: .word 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
array_size: .word 10
element: .asciiz "Enter element to be found: "
found_msg: .asciiz "Found at index: "
not_found_msg: .asciiz "The element is not found." 
newline: .asciiz "\n" 

.text
main:	
    li $v0, 4; la $a0, element; syscall
    li $v0, 5; syscall; move $s0, $v0      # $s0 = search element

    la $a0, array          # $a0 = array
    move $a1, $s0          # $a1 = element
    li $a2, 0              # $a2 = low = 0
    li $a3, 9              # $a3 = high = 9
    jal bin_search 
    move $s1, $v0          # $s1 = result index
	
    li $t0, -1
    beq $s1, $t0, print_not_found 

    li $v0, 4; la $a0, found_msg; syscall
    li $v0, 1; move $a0, $s1; syscall
    j done 

print_not_found: 
    li $v0, 4; la $a0, not_found_msg; syscall

done:	
    li $v0, 10; syscall

# Recursive: bin_search(array, element, low, high)
# Returns: index or -1
bin_search: 	
    addi $sp, $sp, -20     # Save everything
    sw $ra, 16($sp)
    sw $a0, 12($sp)
    sw $a1, 8($sp)
    sw $a2, 4($sp)
    sw $a3, 0($sp)

    bgt $a2, $a3, not_found    # If low > high, not found

    # Calculate mid = (low + high) / 2
    add $t0, $a2, $a3
    li $t1, 2
    div $t0, $t1
    mflo $t2               # $t2 = mid

    # Get array[mid]
    sll $t3, $t2, 2        # offset = mid * 4
    add $t3, $a0, $t3 
    lw $t4, 0($t3)         # $t4 = array[mid]

    beq $a1, $t4, found    # If element == array[mid], found!

    blt $a1, $t4, left_half    # If element < array[mid], search left

    # Search right half
    addi $a2, $t2, 1       # low = mid + 1
    jal bin_search
    j bin_search_end 

left_half: 	
    addi $a3, $t2, -1      # high = mid - 1
    jal bin_search 

bin_search_end: 
    lw $ra, 16($sp)        # Restore everything
    lw $a0, 12($sp)
    lw $a1, 8($sp)
    lw $a2, 4($sp)
    lw $a3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

found: 
    move $v0, $t2          # Return mid
    j bin_search_end

not_found: 
    li $v0, -1             # Return -1
    j bin_search_end
```

---

### Program 3: Sum of N Numbers (Recursive)

Calculate sum: 1 + 2 + 3 + ... + n

```mips
.data
number: .asciiz "Enter a number n: "
result: .asciiz "Sum is: "
newline: .asciiz "\n"

.text
main:	
    li $v0, 4; la $a0, number; syscall
    li $v0, 5; syscall
    move $a0, $v0          # $a0 = n

    jal RSum               # Call RSum(n)
    move $s0, $v0
	
    li $v0, 4; la $a0, result; syscall
    li $v0, 1; move $a0, $s0; syscall
    li $v0, 4; la $a0, newline; syscall
    li $v0, 10; syscall

# Recursive: RSum(n)
# if (n == 1) return 1
# else return n + RSum(n-1)
RSum: 	
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a0, 0($sp)

    li $t0, 1
    beq $a0, $t0, base     # If n == 1, base case

    addi $a0, $a0, -1      # n = n - 1
    jal RSum               # Recursive call: RSum(n-1)
    
    lw $a0, 0($sp)         # Restore n
    lw $ra, 4($sp)
    add $v0, $v0, $a0      # result = n + RSum(n-1)
    addi $sp, $sp, 8
    jr $ra 

base:	
    move $v0, $a0          # Return n (which is 1)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra 
```

### Recursion Pattern

```mips
function:
    # Save on stack
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a0, 0($sp)
    
    # Check base case
    # ... if base, return
    
    # Modify argument
    # Recursive call: jal function
    
    # Restore from stack
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    
    # Process result & return
    jr $ra
```

---

## <a name="lab-9"></a>Lab 9 — Floating Point

### 🎯 New Concept: Decimal Numbers

Use **floating-point registers** (`$f0-$f31`) for decimals.

### Floating Point Instructions

```mips
# Data types
.float 3.14            # Declare float

# Load/move
l.s $f4, pi            # Load float from memory
mov.s $f2, $f0         # Move float between registers

# Arithmetic
add.s $f6, $f2, $f4    # Add floats
sub.s $f6, $f2, $f4    # Subtract
mul.s $f6, $f2, $f4    # Multiply
div.s $f6, $f2, $f4    # Divide

# Syscalls
li $v0, 6              # Read float → $f0
li $v0, 2              # Print float (value in $f12)
```

---

### Program 1: Area of Circle

Formula: `Area = π × r²`

```mips
.data
pi: .float 3.1415926535897924
radius: .float 0.0
area: .float 0.0
radius_msg: .asciiz "Enter radius: "
area_msg: .asciiz "Circle Area = "

.text
main:   
    li $v0, 4
    la $a0, radius_msg
    syscall
 
    li $v0, 6              # Read float
    syscall
    mov.s $f2, $f0         # $f2 = radius
    
    l.s $f4, pi            # $f4 = pi
    mul.s $f6, $f2, $f2    # $f6 = r * r
    mul.s $f8, $f4, $f6    # $f8 = pi * r²
 
    li $v0, 4
    la $a0, area_msg
    syscall
    
    mov.s $f12, $f8        # Move result to $f12
    li $v0, 2              # Print float
    syscall

    li $v0, 10
    syscall
```

### Steps

1. Read radius into `$f2`
2. Load π into `$f4`
3. Calculate r²: `$f6 = $f2 * $f2`
4. Calculate area: `$f8 = $f4 * $f6`
5. Print `$f8`

---

### Program 2: Fahrenheit to Celsius

Formula: `C = (5.0/9.0) × (F - 32.0)`

```mips
.data
input: .asciiz "Enter temperature in F: "
result: .asciiz "Temperature in Celsius is: "
const5: .float 5.0
const9: .float 9.0
const32: .float 32.0

.text
main:   	
    li $v0, 4; la $a0, input; syscall
    li $v0, 6; syscall
    mov.s $f2, $f0         # $f2 = F

    l.s $f4, const5        # $f4 = 5.0
    l.s $f6, const9        # $f6 = 9.0
    l.s $f8, const32       # $f8 = 32.0

    sub.s $f10, $f2, $f8   # $f10 = F - 32
    div.s $f12, $f4, $f6   # $f12 = 5/9
    mul.s $f14, $f12, $f10 # $f14 = (5/9) * (F-32)

    li $v0, 4; la $a0, result; syscall
    mov.s $f12, $f14
    li $v0, 2; syscall
    li $v0, 10; syscall
```

---

### Program 3: Polynomial Evaluation

Calculate: `y = ax² + bx + c`

```mips
.data
msg_a: .asciiz "Enter coefficient of a: "
msg_b: .asciiz "Enter coefficient of b: "
msg_c: .asciiz "Enter coefficient of c: "
prompt: .asciiz "Enter the value of x: "
result: .asciiz "Polynomial result y: "

.text
main:   
    # Read a
    li $v0, 4; la $a0, msg_a; syscall
    li $v0, 6; syscall
    mov.s $f2, $f0         # $f2 = a

    # Read b
    li $v0, 4; la $a0, msg_b; syscall
    li $v0, 6; syscall
    mov.s $f4, $f0         # $f4 = b

    # Read c
    li $v0, 4; la $a0, msg_c; syscall
    li $v0, 6; syscall
    mov.s $f6, $f0         # $f6 = c

    # Read x
    li $v0, 4; la $a0, prompt; syscall
    li $v0, 6; syscall
    mov.s $f8, $f0         # $f8 = x

    # Calculate
    mul.s $f10, $f8, $f8   # $f10 = x²
    mul.s $f12, $f2, $f10  # $f12 = a * x²
    mul.s $f14, $f4, $f8   # $f14 = b * x
    add.s $f16, $f12, $f14 # $f16 = ax² + bx
    add.s $f18, $f16, $f6  # $f18 = ax² + bx + c

    li $v0, 4; la $a0, result; syscall
    mov.s $f12, $f18
    li $v0, 2; syscall
    li $v0, 10; syscall
```

### Calculation Steps

For `a=1, b=2, c=3, x=5`:
1. x² = 5 × 5 = 25
2. ax² = 1 × 25 = 25
3. bx = 2 × 5 = 10
4. ax² + bx = 25 + 10 = 35
5. y = 35 + 3 = 38

---

## <a name="quick-ref"></a>Quick Reference

### String Operations

```mips
# Load/store bytes (characters)
lb $t0, 0($t1)         # Load 1 char
sb $t0, 0($t2)         # Store 1 char
beqz $t0, end          # If null, end

# String loop
la $t0, string
loop:
    lb $t1, 0($t0)
    beqz $t1, end
    # Process $t1
    addi $t0, $t0, 1   # +1 for chars!
    j loop

# Read string
li $v0, 8
la $a0, buffer
li $a1, 100
syscall
```

### Procedures

```mips
# Call
move $a0, arg1         # Pass args
move $a1, arg2
jal function
move $t0, $v0          # Get result

# Define
function:
    # Work
    move $v0, result   # Return value
    jr $ra
```

### Recursion

```mips
function:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a0, 0($sp)
    
    # Base case check
    
    # Recursive call
    jal function
    
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
```

### Floating Point

```mips
# Declare
.float 3.14

# Operations
l.s $f2, value         # Load from memory
mov.s $f4, $f2         # Move
add.s $f6, $f2, $f4    # Add
sub.s $f6, $f2, $f4    # Subtract
mul.s $f6, $f2, $f4    # Multiply
div.s $f6, $f2, $f4    # Divide

# I/O
li $v0, 6; syscall     # Read → $f0
mov.s $f12, $f2        # Move to $f12
li $v0, 2; syscall     # Print $f12
```

---

## Key Differences Summary

| Concept | Integers | Strings | Floats |
|---------|----------|---------|--------|
| **Registers** | `$t0-$t9` | `$t0-$t9` | `$f0-$f31` |
| **Load** | `lw` | `lb` | `l.s` |
| **Store** | `sw` | `sb` | `s.s` |
| **Add** | `add` | N/A | `add.s` |
| **Offset** | +4 | +1 | +4 |
| **Read** | `syscall 5` | `syscall 8` | `syscall 6` |
| **Print** | `syscall 1` | `syscall 4` | `syscall 2` |

---

## Common Patterns

### Traverse String
```mips
la $t0, string
loop:
    lb $t1, 0($t0)
    beqz $t1, done
    addi $t0, $t0, 1
    j loop
```

### Call Function
```mips
move $a0, value
jal func
move $t0, $v0
```

### Recursive Template
```mips
func:
    addi $sp, $sp, -8
    sw $ra, 4($sp); sw $a0, 0($sp)
    # base case
    # recursive: jal func
    lw $a0, 0($sp); lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
```

---

**Good luck with Labs 6-9! 🍀**

---

> Part 2 - Labs 6-9 | Strings, Procedures, Recursion, Floats
