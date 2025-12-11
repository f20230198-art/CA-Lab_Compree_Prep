# 🎯 MIPS Previous Year Questions (PYQ) - Complete Solutions Guide

> **Master these 4 questions and you're ready for the exam!**  
> Each question broken down step-by-step with clear logic.

---

## 📚 Contents

1. [Q1 — Armstrong Number Checker](#q1)
2. [Q2 — Leaf Procedure (Polynomial)](#q2)
3. [Q3 — Last 5 Characters of String](#q3)
4. [Q4 — Array Polynomial Evaluation](#q4)
5. [Exam Strategy](#strategy)

---

## <a name="q1"></a>Q1 — Armstrong Number Checker

### ❓ Problem
Check if a number is an Armstrong number.

**Armstrong Number:** A number equal to sum of its digits raised to the power of number of digits.
- Example: 153 = 1³ + 5³ + 3³ = 1 + 125 + 27 = 153 ✓
- Example: 9474 = 9⁴ + 4⁴ + 7⁴ + 4⁴ = 6561 + 256 + 2401 + 256 = 9474 ✓

### 🎯 Approach

**Step 1:** Find number of digits  
**Step 2:** For each digit, calculate digit^(number of digits)  
**Step 3:** Sum all results  
**Step 4:** Compare sum with original number

### 📝 Complete Code with Explanation

```mips
.data 
msg1: .asciiz "Enter number to check for armstrong :"
msg2: .asciiz "The number is an armstrong number"
msg3: .asciiz "The number is not an armstrong number"
 
.text 
main:
    # Read input
    li $v0, 4
    la $a0, msg1
    syscall
 
    li $v0, 5
    syscall
    move $t0, $v0          # $t0 = original number (SAVE THIS!)
 
    # ===== PART 1: Count Digits =====
    li $t1, 0              # $t1 = digit counter
    li $t2, 10  
    add $t3, $t0, $zero    # $t3 = copy of number
 
num_digits:
    beq $t3, $zero, after_digits    # If number becomes 0, done
    div $t3, $t2                     # Divide by 10
    mflo $t3                         # Keep quotient
    addi $t1, $t1, 1                 # digit_count++
    j num_digits
 
    # Now: $t1 = number of digits (the power to use)
    #      $t0 = original number (still saved)
 
after_digits:
    add $t4, $t0, $zero    # $t4 = copy of number to process
    li $t2, 10 
    li $t5, 0              # $t5 = sum of digit^n
 
    # ===== PART 2: Extract each digit and calculate digit^n =====
loop:
    beq $t4, $zero, done   # If no more digits, done
    
    # Extract last digit
    div $t4, $t2           # Divide by 10
    mfhi $t6               # $t6 = last digit (remainder)
    mflo $t4               # $t4 = remaining number (quotient)
    
    # Calculate digit^n (where n = $t1)
    add $t7, $t6, $zero    # $t7 = digit
    li $t8, 1              # $t8 = result (starts at 1)
    li $t9, 0              # $t9 = counter
 
power_loop:
    beq $t9, $t1, power_end    # If counter == n, done
    mul $t8, $t8, $t7          # result = result * digit
    addi $t9, $t9, 1           # counter++
    j power_loop
 
power_end:
    add $t5, $t5, $t8      # sum += digit^n
    j loop
 
    # ===== PART 3: Compare sum with original =====
done:
    beq $t5, $t0, is_armstrong    # If sum == original, Armstrong!
 
not_armstrong:
    li $v0, 4
    la $a0, msg3
    syscall
    j exit
 
is_armstrong:
    li $v0, 4
    la $a0, msg2
    syscall
 
exit:
    li $v0, 10
    syscall
```

### 🔍 Step-by-Step Execution (Example: 153)

#### Part 1: Count Digits
| Iteration | `$t3` | Operation | Digit Count (`$t1`) |
|-----------|-------|-----------|---------------------|
| 1 | 153 | 153/10 = 15 | 1 |
| 2 | 15 | 15/10 = 1 | 2 |
| 3 | 1 | 1/10 = 0 | 3 |
| Done | 0 | Stop | **3 digits** |

#### Part 2: Calculate Sum
| Digit (`$t6`) | Power (`digit^3`) | Sum (`$t5`) |
|---------------|-------------------|-------------|
| 3 | 3³ = 27 | 27 |
| 5 | 5³ = 125 | 152 |
| 1 | 1³ = 1 | **153** |

#### Part 3: Compare
- Sum = 153
- Original = 153
- **153 == 153** → Armstrong! ✓

### 💡 Key Concepts Used
- Digit extraction: `div by 10` → `mfhi` (last digit), `mflo` (remaining)
- Power calculation: Loop multiplication
- Nested loops: Outer (digits) + Inner (power)

---

## <a name="q2"></a>Q2 — Leaf Procedure (Polynomial)

### ❓ Problem
Calculate: **x² + y² + z² + xyzw** using a procedure.

**Leaf Procedure:** A function that doesn't call other functions (no need to save `$ra`).

### 🎯 Approach

**Main:**
1. Read 4 inputs: x, y, z, w
2. Pass to procedure via `$a0, $a1, $a2, $a3`
3. Get result from `$v0`
4. Print result

**Procedure:**
1. Calculate x², y², z²
2. Calculate xyzw (multiply step by step)
3. Add all: x² + y² + z² + xyzw
4. Return in `$v0`

### 📝 Complete Code with Explanation

```mips
.data 
msg1: .asciiz "Enter x value :"
msg2: .asciiz "Enter y value :"
msg3: .asciiz "Enter z value :"
msg4: .asciiz "Enter w value :"
res: .asciiz "Result is ="
 
.text 
main:
    # Read x
    li $v0, 4; la $a0, msg1; syscall
    li $v0, 5; syscall
    move $t0, $v0
 
    # Read y
    li $v0, 4; la $a0, msg2; syscall
    li $v0, 5; syscall
    move $t1, $v0
 
    # Read z
    li $v0, 4; la $a0, msg3; syscall
    li $v0, 5; syscall
    move $t2, $v0
 
    # Read w
    li $v0, 4; la $a0, msg4; syscall
    li $v0, 5; syscall
    move $t3, $v0
 
    # Pass arguments to procedure
    move $a0, $t0          # $a0 = x
    move $a1, $t1          # $a1 = y
    move $a2, $t2          # $a2 = z
    move $a3, $t3          # $a3 = w
    jal calc_proc          # Call function
 
    move $s0, $v0          # $s0 = result
 
    # Print result
    li $v0, 4; la $a0, res; syscall
    li $v0, 1; move $a0, $s0; syscall
    li $v0, 10; syscall
 
# ===== PROCEDURE: calc_proc =====
# Input: $a0=x, $a1=y, $a2=z, $a3=w
# Output: $v0 = x²+y²+z²+xyzw
# No stack needed (leaf procedure!)

calc_proc:
    # Calculate x²
    mul $t4, $a0, $a0      # $t4 = x²
    
    # Calculate y²
    mul $t5, $a1, $a1      # $t5 = y²
    
    # Calculate z²
    mul $t6, $a2, $a2      # $t6 = z²
    
    # Calculate xyzw (step by step)
    mul $t8, $a0, $a1      # $t8 = xy
    mul $t8, $t8, $a2      # $t8 = xyz
    mul $t8, $t8, $a3      # $t8 = xyzw
    
    # Add everything
    add $t4, $t4, $t5      # $t4 = x² + y²
    add $t4, $t4, $t6      # $t4 = x² + y² + z²
    add $t4, $t4, $t8      # $t4 = x² + y² + z² + xyzw
    
    move $v0, $t4          # Return result
    jr $ra                 # Return to main
```

### 🔍 Step-by-Step Execution (Example: x=2, y=3, z=1, w=4)

| Step | Operation | Register | Value |
|------|-----------|----------|-------|
| 1 | x² | `$t4` | 2² = 4 |
| 2 | y² | `$t5` | 3² = 9 |
| 3 | z² | `$t6` | 1² = 1 |
| 4 | x×y | `$t8` | 2×3 = 6 |
| 5 | xy×z | `$t8` | 6×1 = 6 |
| 6 | xyz×w | `$t8` | 6×4 = 24 |
| 7 | x²+y² | `$t4` | 4+9 = 13 |
| 8 | +z² | `$t4` | 13+1 = 14 |
| 9 | +xyzw | `$t4` | 14+24 = **38** |

**Result: 38** ✓

### 💡 Key Concepts Used
- Procedure call: `jal` and `jr $ra`
- Argument passing: `$a0-$a3`
- Return value: `$v0`
- Leaf procedure: No stack needed!

---

## <a name="q3"></a>Q3 — Last 5 Characters of String

### ❓ Problem
Print last 5 characters of a string.
- Input: "correction"
- Output: "ction"

### 🎯 Approach

**Step 1:** Find string length  
**Step 2:** Calculate start position = length - 5  
**Step 3:** Print from that position (5 characters)

### 📝 Complete Code with Explanation

```mips
.data 
msg1: .asciiz "Enter string :"
string: .space 100
msg2: .asciiz "Last 5 characters of string :"
 
.text 
main:
    # Read string
    li $v0, 4
    la $a0, msg1
    syscall
 
    li $v0, 8
    la $a0, string
    li $a1, 100
    syscall
 
    # ===== PART 1: Find string length =====
    la $s0, string         # $s0 = pointer to string
    li $t0, 0              # $t0 = length counter
 
loop:
    lb $t1, 0($s0)         # Load 1 character
    beqz $t1, after_len    # If null, done
    beq $t1, 10, after_len # If newline, done (from user input)
    addi $t0, $t0, 1       # length++
    addi $s0, $s0, 1       # Move to next char
    j loop
 
    # Now: $t0 = string length
 
after_len:
    la $s1, string         # $s1 = start of string
    li $t2, 5              # We want last 5 chars
    sub $t0, $t0, $t2      # $t0 = length - 5 (starting position)
    add $s1, $s1, $t0      # $s1 now points to (length-5)th char
 
    # ===== PART 2: Print last 5 characters =====
    li $v0, 4
    la $a0, msg2
    syscall
 
last_five_loop:
    beq $t2, $zero, end    # Printed 5 chars? Done
    lb $t3, 0($s1)         # Load character
 
    li $v0, 11             # Syscall 11 = print character
    move $a0, $t3
    syscall
 
    addi $t2, $t2, -1      # counter--
    addi $s1, $s1, 1       # Move to next char
    j last_five_loop
 
end:
    li $v0, 10
    syscall
```

### 🔍 Step-by-Step Execution (Example: "correction")

#### Part 1: Find Length

| Position | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|----------|---|---|---|---|---|---|---|---|---|---|
| Char | c | o | r | r | e | c | t | i | o | n |
| Length | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | **10** |

- Total length = 10

#### Part 2: Calculate Start Position
- Start = length - 5 = 10 - 5 = **5**
- Position 5 = 'c'

#### Part 3: Print 5 Characters

| Position | 5 | 6 | 7 | 8 | 9 |
|----------|---|---|---|---|---|
| Char | c | t | i | o | n |

**Output: "ction"** ✓

### 💡 Key Concepts Used
- String length calculation
- Character-by-character printing: syscall 11
- Pointer arithmetic: `add $s1, $s1, $t0`
- Checking for null (`\0`) and newline (`\n` = 10)

### 🎨 New Syscall

```mips
li $v0, 11             # Print single character
move $a0, $t3          # Character to print
syscall
```

---

## <a name="q4"></a>Q4 — Array Polynomial Evaluation

### ❓ Problem
Calculate: **A[0]×x³ + A[1]×x² + A[2]×x¹ + A[3]**

Given array: `[1, 2, 3, 4]` and user input `x`

### 🎯 Approach

**Step 1:** Read x from user  
**Step 2:** Load array elements into registers  
**Step 3:** Calculate each term:
- Term 1: A[0] × x³
- Term 2: A[1] × x²
- Term 3: A[2] × x
- Term 4: A[3]

**Step 4:** Add all terms

### 📝 Complete Code with Explanation

```mips
.data 
msg1: .asciiz "Enter x value :"
msg2: .asciiz "Result ="
array: .word 1, 2, 3, 4
length: .word 4
 
.text 
main:
    # Read x
    li $v0, 4
    la $a0, msg1
    syscall
 
    li $v0, 5
    syscall
    move $t0, $v0          # $t0 = x
 
    # ===== Load array elements =====
    la $s0, array
    lw $s1, 0($s0)         # $s1 = A[0] = 1
    lw $s2, 4($s0)         # $s2 = A[1] = 2
    lw $s3, 8($s0)         # $s3 = A[2] = 3
    lw $s4, 12($s0)        # $s4 = A[3] = 4
 
    # ===== Term 1: A[0] × x³ =====
    mul $t1, $t0, $t0      # $t1 = x²
    mul $t1, $t1, $t0      # $t1 = x³
    mul $t1, $t1, $s1      # $t1 = A[0] × x³
 
    # ===== Term 2: A[1] × x² =====
    mul $t2, $t0, $t0      # $t2 = x²
    mul $t2, $t2, $s2      # $t2 = A[1] × x²
 
    # ===== Term 3: A[2] × x¹ =====
    mul $t3, $t0, $s3      # $t3 = A[2] × x
 
    # ===== Term 4: A[3] =====
    # $s4 already has A[3]
 
    # ===== Add all terms =====
    add $t4, $t1, $t2      # $t4 = Term1 + Term2
    add $t4, $t4, $t3      # $t4 += Term3
    add $t4, $t4, $s4      # $t4 += Term4
 
    # Print result
    li $v0, 4
    la $a0, msg2
    syscall
 
    li $v0, 1
    move $a0, $t4
    syscall
 
    li $v0, 10
    syscall
```

### 🔍 Step-by-Step Execution (Example: x=2)

#### Array Elements
- A[0] = 1
- A[1] = 2
- A[2] = 3
- A[3] = 4

#### Calculations

| Term | Formula | Calculation | Result |
|------|---------|-------------|--------|
| 1 | A[0]×x³ | 1 × 2³ = 1 × 8 | 8 |
| 2 | A[1]×x² | 2 × 2² = 2 × 4 | 8 |
| 3 | A[2]×x¹ | 3 × 2¹ = 3 × 2 | 6 |
| 4 | A[3] | 4 | 4 |
| **Total** | | 8+8+6+4 | **26** |

**Result: 26** ✓

### 💡 Key Concepts Used
- Loading array elements: `lw` with offsets (0, 4, 8, 12...)
- Power calculation: Repeated multiplication
- Polynomial evaluation: Calculate each term, then sum

### 🎯 Pattern for Powers

```mips
# x² (x squared)
mul $t1, $x, $x

# x³ (x cubed)
mul $t1, $x, $x        # x²
mul $t1, $t1, $x       # x² × x = x³

# x⁴
mul $t1, $x, $x        # x²
mul $t1, $t1, $x       # x³
mul $t1, $t1, $x       # x⁴
```

---

## <a name="strategy"></a>Exam Strategy & Tips

### 🎯 How to Approach ANY Question

#### **Step 1: Understand the Problem**
- What's the input?
- What's the output?
- What's the logic/formula?

#### **Step 2: Break Into Parts**
1. Read inputs
2. Process/calculate
3. Print outputs

#### **Step 3: Identify Patterns**
- Loop needed? (for/while)
- Array access?
- Procedure call?
- String manipulation?

#### **Step 4: Write Structure First**

```mips
.data
# Declare messages and data

.text
main:
    # Read inputs
    
    # Part 1: ...
    
    # Part 2: ...
    
    # Print output
    
    # Exit
    li $v0, 10
    syscall
```

---

### 🔑 Common Question Patterns

| Question Type | Key Elements | Similar To |
|---------------|-------------|------------|
| **Number Check** (Armstrong, Prime, Perfect) | Digit extraction, Loops, Conditionals | Q1 |
| **Procedure/Function** | `jal`, `jr $ra`, `$a0-$a3`, `$v0` | Q2 |
| **String Operations** | `lb`, `sb`, character loop, syscall 8/11 | Q3 |
| **Array Calculations** | `lw` with offsets, polynomial eval | Q4 |

---

### 💡 Quick Problem-Solving Checklist

#### **For Number Problems:**
- [ ] Extract digits using `div 10` → `mfhi` (digit), `mflo` (remaining)
- [ ] Use loop for processing each digit
- [ ] Need power? Nested loop for multiplication

#### **For String Problems:**
- [ ] Use `lb` (load byte) not `lw`
- [ ] Check for null (`\0`) with `beqz`
- [ ] Move pointer by +1 (not +4!)
- [ ] Print char: syscall 11

#### **For Array Problems:**
- [ ] Load elements: offset = index × 4
- [ ] Access: `lw $t0, 0($s0)`, `lw $t1, 4($s0)`, etc.
- [ ] Loop if needed: update pointer by +4

#### **For Procedures:**
- [ ] Pass args: `$a0-$a3`
- [ ] Return: `$v0`
- [ ] Call: `jal function`
- [ ] Return: `jr $ra`
- [ ] Stack if recursive!

---

### 🚀 Practice Questions to Master

Based on PYQ patterns, also practice:

1. **Prime number checker** (similar to Q1)
2. **Factorial using procedure** (similar to Q2)
3. **String reversal** (similar to Q3)
4. **Matrix operations** (similar to Q4)
5. **Fibonacci with recursion**

---

### 📝 Final Exam Checklist

Before you start writing code:

✅ **Read question 2-3 times**  
✅ **Identify: inputs, outputs, logic**  
✅ **Write pseudocode/comments first**  
✅ **Check question requirements:**
   - Need procedure? Use `jal`/`jr $ra`
   - Need recursion? Use stack
   - String? Use `lb`/`sb`
   - Array? Use correct offsets

✅ **Test mentally with small example**  
✅ **Don't forget:**
   - Exit with `li $v0, 10; syscall`
   - Use `mflo`/`mfhi` after `mult`/`div`
   - Save original value if needed later

---

## 🎓 Summary: What Makes These Questions Important

### Q1 — Armstrong Number
**Tests:** Loops, digit manipulation, power calculation, nested loops
**Key Skill:** Breaking down a number digit by digit

### Q2 — Leaf Procedure  
**Tests:** Procedure calls, argument passing, return values
**Key Skill:** Writing reusable functions

### Q3 — Last 5 Characters
**Tests:** String handling, character I/O, pointer arithmetic
**Key Skill:** String traversal and manipulation

### Q4 — Polynomial Evaluation
**Tests:** Array access, mathematical expressions, power calculation
**Key Skill:** Systematic calculation of complex formulas

---

## 🌟 Final Tips

1. **Practice writing code WITHOUT looking at answers**
2. **Trace through execution on paper**
3. **Understand WHY each instruction is there**
4. **Time yourself** - aim for 15-20 mins per question
5. **Comment your code** during exam for partial credit

---

> **You've got this! Master these 4 patterns and you can solve ANY question! 💪**

---

**Good luck for your lab exam! 🍀**

---

> PYQ Solutions Guide | Computer Architecture Lab
