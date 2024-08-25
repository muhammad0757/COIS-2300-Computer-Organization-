.macro print_int (%x)
    li $v0, 1
    add $a0, $zero, %x
    syscall
    .end_macro

.macro print_str (%str)
    .data
myLabel: .asciiz %str
    .text
    li $v0, 4
    la $a0, myLabel
    syscall
    .end_macro

# generic looping mechanism
.macro for (%regIterator, %from, %to, %interval, %bodyMacroName)
    add %regIterator, $zero, %from
    Loop:
    %bodyMacroName ()
    add %regIterator, %regIterator, %interval
    ble %regIterator, %to, Loop
    .end_macro

#print an integer
.macro body()
    print_int $t0
    print_str "\n "
    .end_macro

#printing 1 to 10:
print_str "Here is the output for interval 1:\n"
for ($t0, 1, 10, 1, body)

#printing 1 to 20 with interval 2:
print_str "\nHere is the output for interval 2:\n"
.macro body2()
    print_int $t1
    print_str " "
    .end_macro
for ($t1, 10, 40, 4, body2)

