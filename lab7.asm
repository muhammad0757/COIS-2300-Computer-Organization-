.data
const5: .float 5.0
const9: .float 9.0
const32: .float 32.0
enter: .asciiz "Enter temperature in Fahrenheit: "
result: .asciiz "The temperature in Celsius is: "
newline: .asciiz "\n"
loopx2: .asciiz "\nConvert another temperature? (y/n): "
fahr: .float 100

.text

main:
    # user enter value in fahr
    li $v0, 4 # syscall 4 string
    la $a0, enter
    syscall

    # read user input
    li $v0, 6 #  reading float
    syscall
    mov.s $f12, $f0 #  move Fahrenheit value to $f12

   
    jal convertCelsius

    # Print celsius
    li $v0, 4 # syscall for  string
    la $a0, result
    syscall

    # print output for whats stored
    li $v0, 2 # syscall 2 float
    mov.s $f12, $f0 #now its in f12
    syscall

    # Ask the user if they want to convert to another temperature
    li $v0, 4 # syscall for string
    la $a0, newline 
    syscall
    la $a0, loopx2
    syscall
    la $a0, newline 
    syscall

    # read users input value
    li $v0, 12 # syscall for character
    syscall

    # repete process
    beq $v0, 121, main # branch to main if user types yes (121) = y
    j exit # else exi

convertCelsius:
    # Load constants for conversion formula
    lwc1 $f16, const5
    lwc1 $f18, const9
    lwc1 $f20, const32

    # Calculate Celsius temperature using the given formula
    sub.s $f12, $f12, $f20
    div.s $f12, $f12, $f18
    mul.s $f12, $f12, $f16

    # Return Celsius temperature
    mov.s $f0, $f12
    jr $ra # return to the main program

exit:
    li $v0, 10 # system call for exit
    syscall
