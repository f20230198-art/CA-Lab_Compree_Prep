# 🖥️ MIPS Assembly - Complete Beginner's Lab Guide

> **Your one-night crash course for the CA Lab Exam!**  
> Read this guide from start to finish. By the end, you'll be able to solve any lab question without looking at answers.

---

## 📚 Table of Contents

1. [MIPS Basics - The Foundation](#1️⃣-mips-basics---the-foundation)
2. [Lab 1 — Your First Program (Input/Output)](#2️⃣-lab-1--your-first-program-inputoutput)
3. [Lab 2 — Arithmetic Operations](#3️⃣-lab-2--arithmetic-operations)
4. [Lab 3 — Loops, Branches & Logic](#4️⃣-lab-3--loops-branches--logic)
5. [Lab 4 — Advanced Loops & Arrays](#5️⃣-lab-4--advanced-loops--arrays)
6. [Lab 5 — Mastering Arrays](#6️⃣-lab-5--mastering-arrays)
7. [Quick Cheat Sheet](#-quick-cheat-sheet)

---

## 1️⃣ MIPS Basics - The Foundation

### What is MIPS?

**MIPS** is a simple assembly language used to program processors. Think of it as talking directly to the computer's brain using very basic commands.

Every MIPS program has **two main sections**:
- **`.data`** → Where you store strings, numbers, arrays (like declaring variables)
- **`.text`** → Where you write actual instructions (like your main function)

### Registers

| Register | Use |\n|----------|-----|\n| `$t0-$t9` | Store numbers |\n| `$a0` | Pass to syscall |\n| `$v0` | Syscall code OR input value |\n| `$zero` | Always = 0 |

### The Magic of Syscalls (Input/Output Commands)

Syscalls are **pre-built functions** that let you interact with the user. You control them using `$v0`.

| What You Want | Put in `$v0` | What Else Needed | Example |
|---------------|--------------|------------------|---------|
| **Print a string** | `4` | `$a0` = address of string | Print "Hello" |
| **Print a number** | `1` | `$a0` = the number | Print 42 |
| **Read a number** | `5` | Nothing | Get input from user → stored in `$v0` |
| **Exit program** | `10` | Nothing | End the program |

### Basic Instructions You Must Know

#### 1. Loading Values
```mips
li $t0, 5          # Load Immediate: Put number 5 into $t0
la $a0, message    # Load Address: Put memory address of 'message' into $a0
move $t1, $t0      # Copy value from $t0 to $t1
```

#### 2. Arithmetic Operations
```mips
add $t2, $t0, $t1      # $t2 = $t0 + $t1
sub $t2, $t0, $t1      # $t2 = $t0 - $t1
mult $t0, $t1          # Multiply $t0 * $t1 → result in special registers
div $t0, $t1           # Divide $t0 / $t1 → quotient and remainder in special registers

mflo $t2               # Move From LO: Get quotient (after division) or lower 32 bits (after multiplication)
mfhi $t3               # Move From HI: Get remainder (after division) or upper 32 bits (after multiplication)
```

**🔑 Important:** `mult` and `div` don't store results directly in registers. You MUST use `mflo` and `mfhi` to get the results!

#### 3. Memory Operations
```mips
sw $t0, num1           # Store Word: Save $t0's value into memory location 'num1'
lw $t0, num1           # Load Word: Load value from memory 'num1' into $t0

sw $t0, 0($t1)         # Store $t0 at address in $t1 + offset 0
lw $t0, 4($t1)         # Load from address in $t1 + offset 4 (next array element)
```

#### 4. Branching & Jumping (Control Flow)
```mips
beq $t0, $t1, label    # Branch if Equal: If $t0 == $t1, jump to 'label'
bne $t0, $t1, label    # Branch if Not Equal: If $t0 != $t1, jump to 'label'
bgt $t0, $t1, label    # Branch if Greater Than: If $t0 > $t1, jump to 'label'
blt $t0, $t1, label    # Branch if Less Than: If $t0 < $t1, jump to 'label'
ble $t0, $t1, label    # Branch if Less or Equal: If $t0 <= $t1, jump to 'label'
j label                # Jump unconditionally to 'label'
```

### How to Think About Labels

**Labels** are like bookmarks in your code. They mark a spot you can jump to.

```mips
main:           # This is where program starts
    # code here
    j loop      # Jump to the 'loop' label

loop:           # Loop starts here
    # loop code
    j end       # Jump to 'end'

end:            # Program ends here
    li $v0, 10
    syscall
```

---

## 2️⃣ Lab 1 — Your First Program (Input/Output)

### 🎯 Goal: Learn How to Display Output

This is the simplest program. It just prints "Hello World" on the screen.

### 📝 Complete Code

```mips
.data
msg: .asciiz "Hello World" 

.text
main: 
    li $v0, 4          # Set syscall code to 4 (print string)
    la $a0, msg        # Load address of msg into $a0
    syscall            # Execute the syscall (print the string)

    li $v0, 10         # Set syscall code to 10 (exit)
    syscall            # Exit the program
```

### 🔍 Line-by-Line Breakdown

| Line | What It Does |
|------|--------------|
| `.data` | Start of data section (where we declare our strings/variables) |
| `msg: .asciiz "Hello World"` | Create a label `msg` that points to the string "Hello World" |
| `.text` | Start of code section (where instructions go) |
| `main:` | Label marking the start of our program |
| `li $v0, 4` | Load Immediate: Put 4 into `$v0` (4 means "print string") |
| `la $a0, msg` | Load Address: Put the memory address of `msg` into `$a0` |
| `syscall` | Execute the system call (prints the string at address in `$a0`) |
| `li $v0, 10` | Load 10 into `$v0` (10 means "exit program") |
| `syscall` | Exit the program |

### 🧠 Key Concepts

**1. How `.asciiz` works:**
- `.asciiz` creates a null-terminated string (a string that ends with `\0`)
- The label `msg` is like a variable name that stores the address where "Hello World" is stored

**2. The Print String Pattern:**
```mips
li $v0, 4          # Tell syscall: "I want to print a string"
la $a0, msg        # Tell syscall: "The string is at this address"
syscall            # Execute it!
```

**3. Always Exit:**
Every program MUST end with:
```mips
li $v0, 10
syscall
```
Otherwise, the simulator will crash!

### ✅ What You Learned
- ✓ How to structure a MIPS program (`.data` and `.text` sections)
- ✓ How to print a string using syscall 4
- ✓ How to properly exit a program using syscall 10
- ✓ What labels are and how they work

---

## 3️⃣ Lab 2 — Arithmetic Operations

### 🎯 Goal: Learn How to Take Input & Do Math

Now we'll learn the most important skills:
1. How to **read numbers** from the user
2. How to do **arithmetic** operations
3. The difference between using **registers** vs **memory**

---

### 📚 Program 1: Sum Using Registers (The Fast Way)

This program reads two numbers, adds them, and displays the result — all using registers.

### 📝 Complete Code

```mips
.data 
input1:  .asciiz  "Enter integer 1: "
input2:  .asciiz  "Enter integer 2: "
result:  .asciiz  "The result is: " 

.text 
main:  
    # Print "Enter integer 1: "
    li $v0, 4
    la $a0, input1
    syscall 

    # Read first integer
    li $v0, 5              # syscall 5 = read integer
    syscall 
    move $t0, $v0          # Copy the input from $v0 to $t0

    # Print "Enter integer 2: "
    li $v0, 4
    la $a0, input2
    syscall 

    # Read second integer
    li $v0, 5
    syscall
    move $t1, $v0          # Copy the input from $v0 to $t1
    
    # Add the two numbers
    add $t2, $t0, $t1      # $t2 = $t0 + $t1

    # Print "The result is: "
    li $v0, 4
    la $a0, result 
    syscall

    # Print the sum
    li $v0, 1              # syscall 1 = print integer
    move $a0, $t2          # Put the result in $a0
    syscall

    # Exit
    li $v0, 10
    syscall 
```

### 🔍 Understanding Each Part

#### **Step 1: Reading an Integer**
```mips
li $v0, 5        # Tell syscall: "I want to read an integer"
syscall          # Execute (waits for user input)
move $t0, $v0    # The number user typed is now in $v0, copy it to $t0
```

**🔑 Key Point:** When you use syscall 5, the number the user types gets stored in `$v0`. You need to **immediately copy** it to another register (like `$t0`) before doing another syscall, otherwise it gets overwritten!

#### **Step 2: Doing Arithmetic**
```mips
add $t2, $t0, $t1    # $t2 = $t0 + $t1
```

Simple! The result goes in the first register (`$t2`).

#### **Step 3: Printing an Integer**
```mips
li $v0, 1        # Tell syscall: "I want to print an integer"
move $a0, $t2    # Put the number to print in $a0
syscall          # Print it!
```

**🔑 Key Point:** Print integer (syscall 1) needs the number in `$a0`, NOT `$v0`.

### 📊 Register Usage Summary

| Register | Contains |
|----------|----------|
| `$t0` | First number (input 1) |
| `$t1` | Second number (input 2) |
| `$t2` | Sum result |
| `$v0` | Syscall code / input value |
| `$a0` | String address / number to print |

---

### 📚 Program 2: Sum Using Memory (The Storage Way)

This program does the **exact same thing** but stores values in **memory** instead of just registers.

### 📝 Complete Code

```mips
.data 
input1:  .asciiz  "Enter integer 1: "
input2:  .asciiz  "Enter integer 2: "
result:  .asciiz  "The result is: " 
num1:    .word 0        # Reserve space for first number
num2:    .word 0        # Reserve space for second number
sum:     .word 0        # Reserve space for sum

.text 
main:  
    # Print "Enter integer 1: "
    li $v0, 4
    la $a0, input1
    syscall 

    # Read first integer and store in memory
    li $v0, 5
    syscall 
    move $t0, $v0 
    sw $t0, num1           # Store Word: Save $t0 into memory location 'num1'

    # Print "Enter integer 2: "
    li $v0, 4
    la $a0, input2
    syscall 

    # Read second integer and store in memory
    li $v0, 5
    syscall
    move $t1, $v0 
    sw $t1, num2           # Store $t1 into memory location 'num2'
    
    # Load both numbers from memory
    lw $t0, num1           # Load Word: Get value from 'num1' into $t0
    lw $t1, num2           # Load value from 'num2' into $t1
    
    # Add them
    add $t2, $t0, $t1
    
    # Store result back to memory
    sw $t2, sum            # Save result to memory location 'sum'

    # Print "The result is: "
    li $v0, 4
    la $a0, result 
    syscall

    # Print the sum (loaded from memory)
    li $v0, 1
    lw $a0, sum           # Load sum from memory directly into $a0
    syscall

    # Exit
    li $v0, 10
    syscall 
```

### 🔍 New Instructions Explained

#### **`.word` - Declaring Memory Space**
```mips
num1: .word 0        # Create a memory location called 'num1', initialize with 0
```
`.word` reserves 4 bytes (32 bits) of memory. You can store one integer here.

#### **`sw` - Store Word (Register → Memory)**
```mips
sw $t0, num1         # Save the value in $t0 to memory location 'num1'
```

#### **`lw` - Load Word (Memory → Register)**
```mips
lw $t0, num1         # Load the value from memory location 'num1' into $t0
```

### 🤔 Registers vs Memory: What's the Difference?

| Aspect | Registers (`$t0`, `$t1`, etc.) | Memory (`.word`, `lw`, `sw`) |
|--------|-------------------------------|------------------------------|
| **Speed** | ⚡ Very fast | 🐌 Slower |
| **Size** | Only 10 temporary registers | Can store millions of values |
| **When to use** | Quick calculations | Storing arrays, large data |
| **Example** | `add $t2, $t0, $t1` | `sw $t0, num1` then `lw $t1, num1` |

**💡 Rule of Thumb:** 
- Use **registers** for simple programs with a few variables
- Use **memory** when you need to store arrays or many values

### ✅ What You Learned
- ✓ How to read integers from user (syscall 5)
- ✓ How to print integers (syscall 1)
- ✓ How to do basic arithmetic (`add`, `sub`)
- ✓ Difference between registers and memory
- ✓ How to use `lw` (load word) and `sw` (store word)

---

## 4️⃣ Lab 3 — Loops, Branches & Logic

### 🎯 Goal: Master Complex Math, Conditions, and Loops

This is where MIPS gets powerful! You'll learn:
1. How to handle **multiplication and division** (with `mflo` and `mfhi`)
2. How to use **if-else** logic (branching)
3. How to create **loops** (while loops)

---

### 📚 Program 1: Expression Evaluation with Operator Precedence

**Problem:** Calculate `a = a * b / c % d + e`

You need to follow **operator precedence** (BODMAS/PEMDAS rules):
1. First: `a * b` (multiplication)
2. Then: `result / c` (division)
3. Then: `result % d` (modulo/remainder)
4. Finally: `result + e` (addition)

### 📝 Complete Code

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
    # Read a (into $t0)
    li $v0, 4
    la $a0, input1
    syscall 
    li $v0, 5
    syscall
    move $t0, $v0

    # Read b (into $t1)
    li $v0, 4
    la $a0, input2
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    # Read c (into $t2)
    li $v0, 4
    la $a0, input3
    syscall
    li $v0, 5
    syscall 
    move $t2, $v0

    # Read d (into $t3)
    li $v0, 4
    la $a0, input4
    syscall 
    li $v0, 5
    syscall
    move $t3, $v0
    
    # Read e (into $t4)
    li $v0, 4
    la $a0, input5
    syscall 
    li $v0, 5
    syscall
    move $t4, $v0
    
    # Step 1: a * b
    mult $t0, $t1          # Multiply $t0 * $t1
    mflo $t5               # Get the result into $t5

    # Step 2: (a*b) / c
    div $t5, $t2           # Divide $t5 / $t2
    mflo $t6               # Get quotient into $t6

    # Step 3: (a*b/c) % d
    div $t6, $t3           # Divide $t6 / $t3
    mfhi $t7               # Get remainder into $t7 (mfhi = remainder!)

    # Step 4: result + e
    add $t8, $t7, $t4      # $t8 = $t7 + $t4

    # Print result
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t8
    syscall

    li $v0, 10
    syscall 
```

### 🔍 Understanding `mult` and `div`

#### **Multiplication: `mult $t0, $t1`**
```mips
mult $t0, $t1     # Multiply $t0 * $t1
mflo $t5          # Move From LO: Get the result
```

**Why `mflo`?** Multiplication can produce HUGE numbers (e.g., 1000000 * 1000000). The result is stored in two special registers (HI and LO). For normal numbers, just use `mflo` to get the result.

#### **Division: `div $t0, $t1`**
```mips
div $t0, $t1      # Divide $t0 / $t1
mflo $t2          # Get QUOTIENT (how many times it divides)
mfhi $t3          # Get REMAINDER (what's left over)
```

**Example:** `17 / 5`
- Quotient (`mflo`) = 3 (because 5 goes into 17 three times)
- Remainder (`mfhi`) = 2 (because 17 - 15 = 2)

### 🧮 Calculation Breakdown

For input: `a=10, b=3, c=2, d=4, e=5`

| Step | Operation | Calculation | Result |
|------|-----------|-------------|--------|
| 1 | `a * b` | `10 * 3` | `30` → `$t5` |
| 2 | `(a*b) / c` | `30 / 2` | Quotient = `15` → `$t6` |
| 3 | `(a*b/c) % d` | `15 % 4` | Remainder = `3` → `$t7` |
| 4 | `result + e` | `3 + 5` | `8` → `$t8` |

---

### 📚 Program 2: Odd or Even Check (Branching)

**Problem:** Read a number and check if it's odd or even.

**Logic:** A number is even if `number % 2 == 0`, otherwise it's odd.

### 📝 Complete Code

```mips
.data
input: .asciiz "Enter a number to check for odd or even: "
odd_result: .asciiz "The number is odd."
even_result: .asciiz "The number is even."

.text
main:	
    # Read number
    li $v0, 4
    la $a0, input 
    syscall

    li $v0, 5
    syscall
    move $t0, $v0      # $t0 = input number
    
    # Divide by 2 and get remainder
    li $t1, 2          # $t1 = 2
    div $t0, $t1       # Divide $t0 / 2
    mfhi $t2           # $t2 = remainder
    
    # Check if remainder is 0
    beq $t2, $zero, even    # If remainder == 0, jump to 'even'
    j odd                    # Otherwise, jump to 'odd'

even: 
    li $v0, 4
    la $a0, even_result
    syscall
    j end               # Jump to end (skip the 'odd' part)

odd: 
    li $v0, 4
    la $a0, odd_result
    syscall

end: 
    li $v0, 10
    syscall 
```

### 🔍 Understanding Branching

#### **`beq` - Branch if Equal**
```mips
beq $t2, $zero, even    # If $t2 == $zero (i.e., $t2 == 0), jump to 'even'
```

This is like: `if (remainder == 0) goto even;`

#### **`j` - Unconditional Jump**
```mips
j odd    # Always jump to 'odd' (no condition)
```

This is like: `goto odd;`

### 🎯 Control Flow Diagram

```
Read number → Divide by 2 → Get remainder
                                 ↓
                          Is remainder == 0?
                         ↙               ↘
                      YES                 NO
                       ↓                   ↓
                Print "even"         Print "odd"
                       ↓                   ↓
                       └────→ END ←────────┘
```

### 💡 The Pattern for If-Else

```mips
    # Check condition
    beq $t0, $t1, true_label    # If condition is true, go to true_label
    j false_label                # Otherwise, go to false_label

true_label:
    # Code when condition is TRUE
    j end                        # Skip false part

false_label:
    # Code when condition is FALSE

end:
    # Continue program
```

---

### 📚 Program 3: Sum of Digits (While Loop)

**Problem:** For a number like 456, find `4 + 5 + 6 = 15`

**Algorithm:**
```
sum = 0
while (number != 0):
    digit = number % 10      # Get last digit
    sum = sum + digit         # Add to sum
    number = number / 10      # Remove last digit
```

**Example:** Number = 456
1. `456 % 10 = 6`, sum = 6, number becomes `456 / 10 = 45`
2. `45 % 10 = 5`, sum = 11, number becomes `45 / 10 = 4`
3. `4 % 10 = 4`, sum = 15, number becomes `4 / 10 = 0`
4. Stop (number == 0)

### 📝 Complete Code

```mips
.data
input: .asciiz "Enter a number: "
result: .asciiz "The sum of digits: "

.text
main: 	
    # Read number
    li $v0, 4
    la $a0, input
    syscall

    li $v0, 5
    syscall 
    move $t0, $v0      # $t0 = input number

    li $t1, 10         # $t1 = 10 (divisor)
    li $t2, 0          # $t2 = sum (initialize to 0)
    
sum:   
    beq $t0, $zero, end    # If number == 0, exit loop
    j loop                  # Otherwise, continue loop

loop: 
    div $t0, $t1           # Divide number by 10
    mfhi $t3               # $t3 = last digit (remainder)
    add $t2, $t2, $t3      # sum = sum + digit
    mflo $t0               # number = quotient (removes last digit)
    j sum                   # Go back to check condition

end: 
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

### 🔍 Understanding the Loop

#### **Loop Structure**
```mips
sum:   
    beq $t0, $zero, end    # Check: if number == 0, exit
    j loop                  # If not 0, do loop body

loop: 
    # Loop body (extract digit, add to sum, remove digit)
    j sum                   # Go back to check condition again
```

This is equivalent to:
```c
while (number != 0) {
    // loop body
}
```

#### **Step-by-Step Execution** (for input 123)

| Iteration | `$t0` (number) | Operation | `$t3` (digit) | `$t2` (sum) |
|-----------|----------------|-----------|---------------|-------------|
| Start | 123 | - | - | 0 |
| 1 | 123 | `123 % 10` | 3 | 0 + 3 = **3** |
| | 12 | `123 / 10` | | |
| 2 | 12 | `12 % 10` | 2 | 3 + 2 = **5** |
| | 1 | `12 / 10` | | |
| 3 | 1 | `1 % 10` | 1 | 5 + 1 = **6** |
| | 0 | `1 / 10` | | |
| End | 0 | Exit loop | - | **6** |

### ✅ What You Learned
- ✓ How to use `mult` and `div` with `mflo` and `mfhi`
- ✓ How to get quotient (division result) and remainder (modulo)
- ✓ How to implement if-else using `beq` and `j`
- ✓ How to create while loops in MIPS
- ✓ How to solve digit extraction problems

---

## 5️⃣ Lab 4 — Advanced Loops & Arrays

### 🎯 Goal: Work with Arrays and Complex Loops

Now you'll learn:
1. How to handle more complex expressions
2. How to work with **arrays** (multiple values in memory)
3. How to search through arrays
4. How to use loops for repeated multiplication (factorial)

---

### 📚 Program 1: Another Expression - Subtraction & Precedence

**Problem:** Calculate `a = a - b * c + d % e`

**Precedence Order:**
1. First: `b * c` (multiplication)
2. Then: `d % e` (modulo)
3. Then: `a - (b*c)` (subtraction)
4. Finally: `result + (d%e)` (addition)

### 📝 Complete Code

```mips
.data
input1:  .asciiz "Enter integer 1: "
input2:  .asciiz "Enter integer 2: "
input3:  .asciiz "Enter integer 3: "
input4:  .asciiz "Enter integer 4: "
input5:  .asciiz "Enter integer 5: "
result: .asciiz "The result is: "

.text
main:	
    # Read a ($t0)
    li $v0, 4
    la $a0, input1
    syscall
    li $v0, 5
    syscall
    move $t0, $v0

    # Read b ($t1)
    li $v0, 4
    la $a0, input2
    syscall
    li $v0, 5
    syscall 
    move $t1, $v0

    # Read c ($t2)
    li $v0, 4
    la $a0, input3
    syscall
    li $v0, 5
    syscall
    move $t2, $v0

    # Read d ($t3)
    li $v0, 4
    la $a0, input4
    syscall
    li $v0, 5
    syscall
    move $t3, $v0

    # Read e ($t4)
    li $v0, 4
    la $a0, input5
    syscall 
    li $v0, 5
    syscall
    move $t4, $v0   	

    # Step 1: b * c
    mult $t1, $t2
    mflo $t5           # $t5 = b * c

    # Step 2: d % e
    div $t3, $t4
    mfhi $t6           # $t6 = d % e (remainder)

    # Step 3: a - (b*c)
    sub $t7, $t0, $t5  # $t7 = a - (b*c)

    # Step 4: result + (d%e)
    add $t8, $t7, $t6  # $t8 = (a - b*c) + (d%e)
    
    # Print result
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t8
    syscall

    li $v0, 10
    syscall
```

### 🧮 Example Calculation

For: `a=20, b=3, c=2, d=10, e=3`

| Step | Operation | Result |
|------|-----------|--------|
| 1 | `b * c` = `3 * 2` | `$t5 = 6` |
| 2 | `d % e` = `10 % 3` | `$t6 = 1` |
| 3 | `a - (b*c)` = `20 - 6` | `$t7 = 14` |
| 4 | `14 + 1` | `$t8 = 15` ✓ |

---

### 📚 Program 2: Linear Search in an Array

**Problem:** Find if a number exists in an array and return its position.

**What's an Array?** A collection of numbers stored consecutively in memory.

**Algorithm:**
```
for i = 0 to length-1:
    if array[i] == search_value:
        print "Found at position i"
        exit
print "Not found"
```

### 📝 Complete Code

```mips
.data
num: .asciiz "Enter number to be found: "
found: .asciiz "The number is found at "
not_found: .asciiz "The number is not found."
array: .word 9, 10, 11, 12, 13, 14, 15, 16, 17, 18    # Array of 10 numbers

.text
main: 	
    # Read search number
    li $v0, 4
    la $a0, num
    syscall

    li $v0, 5
    syscall
    move $t0, $v0          # $t0 = number to find
 
    la $t1, array          # $t1 = address of array (pointer to first element)
    li $t2, 10             # $t2 = array length (10 elements)
    li $t3, 0              # $t3 = index (i = 0)
    
loop: 	
    beq $t3, $t2, not_found1    # If index == length, not found
    lw $t4, 0($t1)              # Load array[i] into $t4
    beq $t4, $t0, found1        # If array[i] == search_value, found!
    addi $t3, $t3, 1            # i++
    addi $t1, $t1, 4            # Move pointer to next element (4 bytes)
    j loop

found1: 
    li $v0, 4
    la $a0, found
    syscall

    li $v0, 1
    move $a0, $t3          # Print index
    syscall

    j exit

not_found1: 
    li $v0, 4
    la $a0, not_found
    syscall

exit: 	
    li $v0, 10
    syscall 
```

### 🔍 Understanding Arrays in MIPS

#### **Declaring an Array**
```mips
array: .word 9, 10, 11, 12, 13    # Array of 5 integers
```

In memory, this looks like:
```
Address: 0x1000  0x1004  0x1008  0x100C  0x1010
Value:      9      10      11      12      13
```

Each integer takes **4 bytes** (1 word = 4 bytes).

#### **Loading Address of Array**
```mips
la $t1, array    # $t1 now holds the address of the first element
```

#### **Accessing Array Elements**
```mips
lw $t4, 0($t1)     # Load array[0] (offset 0)
lw $t4, 4($t1)     # Load array[1] (offset 4 bytes)
lw $t4, 8($t1)     # Load array[2] (offset 8 bytes)
```

**Pattern:** `offset = index * 4`

#### **Moving Through Array**
```mips
addi $t1, $t1, 4    # Move pointer to next element
```

After this, `$t1` points to the next array element.

### 🎯 Search Flow Example

Array: `[9, 10, 11, 12, 13]`, Search for: `11`

| Iteration | Index (`$t3`) | Address | Value (`$t4`) | Match? |
|-----------|---------------|---------|---------------|--------|
| 1 | 0 | 0x1000 | 9 | No → continue |
| 2 | 1 | 0x1004 | 10 | No → continue |
| 3 | 2 | 0x1008 | 11 | **Yes!** → Found at 2 |

---

### 📚 Program 3: Factorial Using Loop

**Problem:** Calculate factorial of n: `n! = n × (n-1) × (n-2) × ... × 1`

Example: `5! = 5 × 4 × 3 × 2 × 1 = 120`

**Algorithm:**
```
factorial = 1
for i = 1 to n:
    factorial = factorial * i
```

### 📝 Complete Code

```mips
.data
num: .asciiz "Enter a number: "
fact: .asciiz "Factorial is: "

.text
main: 	
    # Read number
    li $v0, 4
    la $a0, num
    syscall

    li $v0, 5
    syscall
    move $t0, $v0      # $t0 = n (input number)
    
    li $t1, 1          # $t1 = 1 (lower bound)
    li $t2, 1          # $t2 = i (loop counter, starts at 1)
    li $t3, 1          # $t3 = factorial (result, starts at 1)
    
    blt $t0, $t1, exit # If n < 1, skip calculation

    ble $t2, $t0, loop # If i <= n, start loop

loop:  	
    mult $t3, $t2      # factorial = factorial * i
    mflo $t3           # Get result
    addi $t2, $t2, 1   # i++
    bgt $t2, $t0, end  # If i > n, exit loop
    j loop             # Continue loop
    
end: 	
    # Print "Factorial is: "
    li $v0, 4
    la $a0, fact
    syscall
    
    # Print result
    li $v0, 1
    move $a0, $t3
    syscall

exit:	
    li $v0, 10
    syscall
```

### 🔍 Understanding the Loop

#### **Loop Condition: `ble $t2, $t0, loop`**
```mips
ble $t2, $t0, loop    # Branch if Less or Equal: if i <= n, go to loop
```

This is like: `while (i <= n) { ... }`

#### **Exit Condition: `bgt $t2, $t0, end`**
```mips
bgt $t2, $t0, end     # Branch if Greater Than: if i > n, exit
```

### 🧮 Execution Example (n = 4)

| Iteration | `$t2` (i) | `$t3` (factorial) | Operation | New factorial |
|-----------|-----------|-------------------|-----------|---------------|
| Start | 1 | 1 | - | 1 |
| 1 | 1 | 1 | `1 * 1` | 1 |
| 2 | 2 | 1 | `1 * 2` | 2 |
| 3 | 3 | 2 | `2 * 3` | 6 |
| 4 | 4 | 6 | `6 * 4` | **24** |
| 5 | 5 | 24 | i > n, exit | - |

Result: **24** ✓

### ✅ What You Learned
- ✓ How to declare and access arrays using `.word`
- ✓ How to traverse arrays using pointer arithmetic
- ✓ How to implement linear search
- ✓ How to use `bgt`, `blt`, `ble` for comparisons
- ✓ How to implement factorial using loops
- ✓ Array addressing with offsets (`lw $t0, 0($t1)`, `lw $t0, 4($t1)`)

---

## 6️⃣ Lab 5 — Mastering Arrays

### 🎯 Goal: Advanced Array Operations

This is the final lab! You'll master:
1. Finding maximum element in an array
2. Taking array input from user
3. Operating on multiple arrays simultaneously

---

### 📚 Program 1: Largest Element in Array

**Problem:** Find the biggest number in an array.

**Algorithm:**
```
largest = array[0]
for i = 1 to length-1:
    if array[i] > largest:
        largest = array[i]
```

### 📝 Complete Code

```mips
.data
result: .asciiz "The largest element is: "
array: .word 10, 20, 30, 40, 50, 60, 70, 80, 90, 100

.text
main: 	
    la $t0, array      # $t0 = address of array
    li $t1, 10         # $t1 = length (10 elements)
    li $t2, 1          # $t2 = index (start from 1, since we already have first element)
    lw $t3, 0($t0)     # $t3 = largest (initialize with first element)
    addi $t0, $t0, 4   # Move pointer to second element

loop:	
    beq $t2, $t1, exit     # If index == length, exit
    lw $t4, 0($t0)         # Load current element
    bgt $t4, $t3, largest  # If current > largest, update largest
    addi $t2, $t2, 1       # index++
    addi $t0, $t0, 4       # Move to next element
    j loop

largest:	
    move $t3, $t4          # Update largest
    addi $t2, $t2, 1       # index++
    addi $t0, $t0, 4       # Move to next element
    j loop

exit:	
    # Print result
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t3
    syscall
    
    li $v0, 10
    syscall 
```

### 🔍 Step-by-Step Breakdown

#### **Initialization**
```mips
lw $t3, 0($t0)       # Assume first element is largest
addi $t0, $t0, 4     # Move pointer to second element
li $t2, 1            # Start loop from index 1
```

#### **Comparison Logic**
```mips
lw $t4, 0($t0)           # Load current element
bgt $t4, $t3, largest    # If current > largest, jump to update
# If not greater, just move to next element
```

#### **Update Largest**
```mips
move $t3, $t4    # largest = current element
```

### 🧮 Execution Example

Array: `[10, 50, 30, 90, 20]`

| Iteration | Index | Current (`$t4`) | Largest (`$t3`) | Action |
|-----------|-------|-----------------|-----------------|--------|
| Start | 0 | - | **10** | Initialize |
| 1 | 1 | 50 | 10 | 50 > 10 → Update: **50** |
| 2 | 2 | 30 | 50 | 30 ≤ 50 → Skip |
| 3 | 3 | 90 | 50 | 90 > 50 → Update: **90** |
| 4 | 4 | 20 | 90 | 20 ≤ 90 → Skip |
| End | - | - | **90** | Final answer |

---

### 📚 Program 2: Sum of 5 Elements (User Input)

**Problem:** Let the user enter 5 numbers, then calculate their sum.

**New Concept:** Using `.space` to allocate memory for user input.

### 📝 Complete Code

```mips
.data
array: .space 20           # Reserve 20 bytes (5 integers × 4 bytes each)
msg: .asciiz "Enter 5 elements: "
sum: .asciiz "Sum of elements is: "

.text
main: 	
    # Print message
    li $v0, 4
    la $a0, msg
    syscall
    
    la $t0, array          # $t0 = address of array

    # Read 5 numbers and store in array
    li $v0, 5 
    syscall
    sw $v0, 0($t0)         # Store at array[0]

    li $v0, 5
    syscall
    sw $v0, 4($t0)         # Store at array[1]

    li $v0, 5
    syscall
    sw $v0, 8($t0)         # Store at array[2]

    li $v0, 5
    syscall
    sw $v0, 12($t0)        # Store at array[3]

    li $v0, 5
    syscall
    sw $v0, 16($t0)        # Store at array[4]

    # Now calculate sum
    li $t1, 0              # $t1 = sum (initialize to 0)
    li $t2, 5              # $t2 = length
    li $t3, 0              # $t3 = index

loop: 	
    beq $t3, $t2, end      # If index == length, done
    lw $t4, 0($t0)         # Load current element
    add $t1, $t1, $t4      # sum = sum + current
    addi $t3, $t3, 1       # index++
    addi $t0, $t0, 4       # Move to next element
    j loop

end: 	
    # Print "Sum of elements is: "
    li $v0, 4
    la $a0, sum 
    syscall

    # Print sum
    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 10
    syscall
```

### 🔍 Understanding `.space`

#### **`.space` vs `.word`**
```mips
array1: .word 1, 2, 3        # Pre-filled array with values [1, 2, 3]
array2: .space 12            # Empty array, 12 bytes (3 integers)
```

`.space 20` reserves 20 bytes of uninitialized memory. Perfect for user input!

#### **Storing User Input**
```mips
la $t0, array      # Get array address
li $v0, 5          # Read integer
syscall
sw $v0, 0($t0)     # Store at array[0]

li $v0, 5
syscall
sw $v0, 4($t0)     # Store at array[1] (4 bytes offset)
```

### 🎯 Memory Layout

After storing 5 inputs (e.g., 10, 20, 30, 40, 50):

```
Offset:  0    4    8    12   16
Value:   10   20   30   40   50
```

---

### 📚 Program 3: Adding Two Arrays

**Problem:** Given two arrays `A` and `B`, create array `C` where `C[i] = A[i] + B[i]`

**Algorithm:**
```
for i = 0 to 4:
    C[i] = A[i] + B[i]
```

### 📝 Complete Code

```mips
.data
array1: .word 11, 13, 15, 17, 19
array2: .word 1, 3, 5, 7, 9
array3: .word 0, 0, 0, 0, 0         # Result array
result: .asciiz "The resultant array is: "
space: .asciiz " "

.text
main: 	
    la $t1, array1     # $t1 = address of array1
    la $t2, array2     # $t2 = address of array2
    la $t3, array3     # $t3 = address of array3

    li $t4, 0          # $t4 = index counter
    li $t5, 5          # $t5 = length

loop:	
    beq $t4, $t5, end      # If index == length, done
    
    lw $t6, 0($t1)         # Load array1[i]
    lw $t7, 0($t2)         # Load array2[i]
    
    li $t0, 0              # Clear $t0 (sum holder)
    add $t0, $t6, $t7      # $t0 = array1[i] + array2[i]
    
    sw $t0, 0($t3)         # Store in array3[i]
    
    # Move all pointers to next element
    addi $t1, $t1, 4       # array1 pointer++
    addi $t2, $t2, 4       # array2 pointer++
    addi $t3, $t3, 4       # array3 pointer++
    addi $t4, $t4, 1       # index++
    j loop

end: 	
    # Print "The resultant array is: "
    li $v0, 4
    la $a0, result
    syscall

    # Print array3
    la $t3, array3         # Reset pointer to start
    li $t4, 0              # Reset index

p_loop:	
    beq $t4, $t5, exit     # If printed all elements, exit
    
    # Print space
    li $v0, 4
    la $a0, space
    syscall

    # Print element
    li $v0, 1
    lw $a0, 0($t3)         # Load and print array3[i]
    syscall
    
    addi $t3, $t3, 4       # Move to next element
    addi $t4, $t4, 1       # index++
    j p_loop

exit:	
    li $v0, 10
    syscall
```

### 🔍 Working with Multiple Arrays

#### **Loading Three Array Addresses**
```mips
la $t1, array1    # $t1 points to first element of array1
la $t2, array2    # $t2 points to first element of array2
la $t3, array3    # $t3 points to first element of array3
```

#### **Parallel Access**
```mips
lw $t6, 0($t1)    # Load from array1[i]
lw $t7, 0($t2)    # Load from array2[i]
add $t0, $t6, $t7 # Add them
sw $t0, 0($t3)    # Store in array3[i]
```

All three pointers advance together:
```mips
addi $t1, $t1, 4    # Move array1 pointer
addi $t2, $t2, 4    # Move array2 pointer
addi $t3, $t3, 4    # Move array3 pointer
```

### 🧮 Execution Example

**Input:**
- Array1: `[11, 13, 15, 17, 19]`
- Array2: `[1, 3, 5, 7, 9]`

| Index | Array1[i] | Array2[i] | Sum | Array3[i] |
|-------|-----------|-----------|-----|-----------|
| 0 | 11 | 1 | 11 + 1 | **12** |
| 1 | 13 | 3 | 13 + 3 | **16** |
| 2 | 15 | 5 | 15 + 5 | **20** |
| 3 | 17 | 7 | 17 + 7 | **24** |
| 4 | 19 | 9 | 19 + 9 | **28** |

**Output:** `The resultant array is:  12 16 20 24 28`

### 💡 Printing Array Elements

To print all elements with spaces:
```mips
p_loop:
    beq $t4, $t5, exit      # Check if done
    
    # Print space
    li $v0, 4
    la $a0, space
    syscall
    
    # Print number
    li $v0, 1
    lw $a0, 0($t3)          # Load element
    syscall
    
    addi $t3, $t3, 4        # Next element
    addi $t4, $t4, 1        # Increment counter
    j p_loop
```

### ✅ What You Learned
- ✓ How to find maximum/minimum in arrays
- ✓ Using `.space` to allocate memory for user input
- ✓ Reading multiple values and storing in arrays
- ✓ Working with multiple arrays simultaneously
- ✓ Parallel array traversal with multiple pointers
- ✓ Printing array elements with formatting

---

## 📝 Quick Cheat Sheet

### 🎯 Program Structure Template

```mips
.data
# Declare your strings and variables here
message: .asciiz "Hello"
number: .word 0
array: .word 1, 2, 3, 4, 5
buffer: .space 20

.text
main:
    # Your code here
    
    # Always end with:
    li $v0, 10
    syscall
```

---

### 🔧 Common Syscalls Reference

| Task | Code | Setup | Example |
|------|------|-------|---------|
| **Print String** | `$v0 = 4` | `$a0` = address | `li $v0, 4` <br> `la $a0, msg` <br> `syscall` |
| **Print Integer** | `$v0 = 1` | `$a0` = number | `li $v0, 1` <br> `move $a0, $t0` <br> `syscall` |
| **Read Integer** | `$v0 = 5` | None | `li $v0, 5` <br> `syscall` <br> `move $t0, $v0` |
| **Exit Program** | `$v0 = 10` | None | `li $v0, 10` <br> `syscall` |

---

### 🧮 Arithmetic Cheat Sheet

```mips
# Simple operations
add $t2, $t0, $t1       # $t2 = $t0 + $t1
sub $t2, $t0, $t1       # $t2 = $t0 - $t1
addi $t0, $t0, 1        # $t0 = $t0 + 1 (increment)

# Multiplication
mult $t0, $t1           # Multiply $t0 × $t1
mflo $t2                # Get result in $t2

# Division
div $t0, $t1            # Divide $t0 ÷ $t1
mflo $t2                # Get quotient in $t2
mfhi $t3                # Get remainder in $t3

# Modulo (remainder only)
div $t0, $t1            # Divide $t0 ÷ $t1
mfhi $t2                # $t2 = $t0 % $t1
```

---

### 🔀 Branching & Looping Patterns

#### **If-Else Pattern**
```mips
    beq $t0, $t1, true_part    # If equal
    # false part
    j end

true_part:
    # true part
    
end:
    # continue
```

#### **While Loop Pattern**
```mips
loop:
    beq $t0, $zero, end    # While $t0 != 0
    
    # Loop body
    
    j loop

end:
    # continue
```

#### **For Loop Pattern** (i = 0 to n)
```mips
    li $t0, 0              # i = 0
    li $t1, 10             # n = 10

loop:
    beq $t0, $t1, end      # if i == n, exit
    
    # Loop body
    
    addi $t0, $t0, 1       # i++
    j loop

end:
    # continue
```

---

### 📦 Array Operations Cheat Sheet

#### **Declare Array**
```mips
.data
array1: .word 1, 2, 3, 4, 5      # Pre-filled array
array2: .space 20                # Empty array (5 integers)
```

#### **Access Array Elements**
```mips
la $t0, array          # Load array address
lw $t1, 0($t0)         # Load array[0]
lw $t1, 4($t0)         # Load array[1]
lw $t1, 8($t0)         # Load array[2]
# Pattern: offset = index × 4
```

#### **Traverse Array Loop**
```mips
    la $t0, array      # Array pointer
    li $t1, 5          # Array length
    li $t2, 0          # Index

loop:
    beq $t2, $t1, end  # If index == length, exit
    
    lw $t3, 0($t0)     # Load current element
    # Do something with $t3
    
    addi $t0, $t0, 4   # Move to next element
    addi $t2, $t2, 1   # index++
    j loop

end:
```

#### **Store User Input in Array**
```mips
la $t0, array          # Get array address

li $v0, 5              # Read integer
syscall
sw $v0, 0($t0)         # Store at array[0]

li $v0, 5
syscall
sw $v0, 4($t0)         # Store at array[1]
```

---

### 🎓 Common Branching Instructions

| Instruction | Meaning | When it Branches |
|-------------|---------|------------------|
| `beq $t0, $t1, label` | Branch if Equal | `$t0 == $t1` |
| `bne $t0, $t1, label` | Branch if Not Equal | `$t0 != $t1` |
| `bgt $t0, $t1, label` | Branch if Greater | `$t0 > $t1` |
| `bge $t0, $t1, label` | Branch if Greater/Equal | `$t0 >= $t1` |
| `blt $t0, $t1, label` | Branch if Less | `$t0 < $t1` |
| `ble $t0, $t1, label` | Branch if Less/Equal | `$t0 <= $t1` |
| `j label` | Jump (unconditional) | Always |

---

### 💡 Quick Problem-Solving Guide

#### **To solve ANY lab problem:**

1. **Read the problem carefully** - What's the input? What's the output?

2. **Write pseudocode first**
   ```
   Read number
   Calculate something
   Print result
   ```

3. **Translate to MIPS step-by-step:**
   - Input → `li $v0, 5; syscall; move $t0, $v0`
   - Calculate → Use `add`, `mult`, `div`, etc.
   - Output → `li $v0, 1; move $a0, $t0; syscall`

4. **For loops, identify:**
   - Loop counter (index)
   - Loop condition (when to stop)
   - Loop body (what to repeat)

5. **For arrays, remember:**
   - Each element is 4 bytes apart
   - Use `la` to get starting address
   - Use `lw` to read, `sw` to write
   - Advance pointer by 4 each iteration

---

### 🚨 Common Mistakes to Avoid

| ❌ Mistake | ✅ Correct |
|-----------|-----------|
| Forgetting to exit | Always end with `li $v0, 10; syscall` |
| Using `mult` result directly | Must use `mflo` to get result |
| Not moving `$v0` after read | `syscall` then `move $t0, $v0` |
| Wrong array offset | Use multiples of 4: 0, 4, 8, 12... |
| Infinite loop | Make sure loop condition eventually becomes false |
| Comparing without loading | Load values first: `lw $t0, num` |

---

### 🎯 Expression Evaluation Strategy

For complex expressions like `a = (b * c) / d + e % f`:

1. **Identify operator precedence:**
   - Parentheses first
   - Then: `*`, `/`, `%` (left to right)
   - Finally: `+`, `-` (left to right)

2. **Break it down:**
   ```mips
   # Step 1: b * c
   mult $t1, $t2
   mflo $t5
   
   # Step 2: result / d
   div $t5, $t3
   mflo $t6
   
   # Step 3: e % f
   div $t4, $t5
   mfhi $t7
   
   # Step 4: combine
   add $t8, $t6, $t7
   ```

---

### 🔑 Register Usage Best Practices

- **`$t0-$t9`**: Use for temporary calculations
- **`$v0`**: Syscall code OR return value from syscall 5
- **`$a0`**: Argument for syscalls (string address or integer)
- **`$zero`**: Always 0, useful for comparisons

**💡 Pro Tip:** Write comments showing what each register holds!

```mips
move $t0, $v0    # $t0 = first number
move $t1, $v0    # $t1 = second number
add $t2, $t0, $t1    # $t2 = sum
```

---

## 🎓 Final Exam Tips

### **Before the Exam:**
1. ✅ Read this entire guide once
2. ✅ Practice writing programs WITHOUT looking at answers
3. ✅ Memorize syscall codes (1, 4, 5, 10)
4. ✅ Understand the loop patterns

### **During the Exam:**
1. **Read question twice** - understand input/output
2. **Write pseudocode** on paper first
3. **Start with basic structure:**
   ```mips
   .data
   # declare here
   
   .text
   main:
       # code here
       li $v0, 10
       syscall
   ```
4. **Test mentally** - trace through with example values
5. **Double-check:**
   - Did you exit properly?
   - Are array offsets correct (multiples of 4)?
   - Did you use `mflo`/`mfhi` after `mult`/`div`?

### **Common Exam Questions:**
- ✓ Read numbers, do arithmetic → Use Lab 2 pattern
- ✓ Check odd/even/prime → Use branching from Lab 3
- ✓ Factorial/power → Use loop from Lab 4
- ✓ Array max/min/sum → Use Lab 5 pattern
- ✓ Complex expression → Break down step by step

---

## 🔗 Resources

- **QtSpim Simulator** - Where you'll run your code
- **MIPS Green Sheet** - Quick reference for all instructions
- **This Guide** - Your one-stop study material!

---

## 🎉 You're Ready!

You've now learned:
- ✅ Basic I/O (input/output)
- ✅ Arithmetic operations
- ✅ Loops and branching
- ✅ Array operations
- ✅ Problem-solving patterns

**Remember:** MIPS is just like any programming language. The syntax is different, but the logic is the same!

> **Practice makes perfect!** Try writing programs WITHOUT looking at the answers. You've got this! 💪

---

> 📚 **Computer Architecture Lab - MIPS Assembly Guide**  
> *Complete reference for Labs 1-5*  
> *Last Updated: December 2025*

---

### 📌 Quick Links to Sections

- [MIPS Basics](#1️⃣-mips-basics---the-foundation)
- [Lab 1 - Hello World](#2️⃣-lab-1--your-first-program-inputoutput)
- [Lab 2 - Arithmetic](#3️⃣-lab-2--arithmetic-operations)
- [Lab 3 - Loops & Logic](#4️⃣-lab-3--loops-branches--logic)
- [Lab 4 - Arrays & Search](#5️⃣-lab-4--advanced-loops--arrays)
- [Lab 5 - Advanced Arrays](#6️⃣-lab-5--mastering-arrays)
- [Cheat Sheet](#-quick-cheat-sheet)

**Good luck on your exam! 🍀**
