# initialize double-precision arrays
.data
x: .double 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
y: .double 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
z: .double 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
 
# main program
.text
.global main
main:
# prompt user for input
li $v0, 4
la $a0, prompt_y
syscall

# input values for y array
la $t0, y
li $t1, 16
li $v0, 7
loop_y_input:
     syscall
     sdc1 $f0, ($t0)
     addi $t0, $t0, 8
     addi $t1, $t1, -1
     bgtz $t1, loop_y_input

# prompt user for input
li $v0, 4
la $a0, prompt_z
syscall

# input values for z array
la $t0, z
li $t1, 16
li $v0, 7
loop_z_input:
     syscall
     sdc1 $f0, ($t0)
     addi $t0, $t0, 8
     addi $t1, $t1, -1
     bgtz $t1, loop_z_input

# multiply y and z, and store result in x
la $t0, y
