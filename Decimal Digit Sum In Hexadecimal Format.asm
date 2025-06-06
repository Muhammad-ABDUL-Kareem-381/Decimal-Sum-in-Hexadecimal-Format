                                             Title Sum of decimal Digits in HEX decimal forat.
               ; This program reads a string of decimal digits, calculates their sum, and prints the sum in hexadecimal format.

.model small   ; Memory model

.stack 100h    ; Stack size

.data
    
    prompt db "Enter a Decimal Digits String: " , '$'      ; Prompt for user input
    error db "Invalid Input! Try Again" , '$'              ; Error message for non-digit input
    result db "Thr Sum of the Digits in HEX is: " , '$'    ; Message to display before showing result
    sum dw 0                                               ; Variable to hold the sum of digits
    
.code

main proc

    mov ax,@data                                           ; Initialize data segment
    mov ds,ax

start_input:
            
    mov sum,0                                              ; Clear previous sum
    mov dl,offset prompt                                   ; Load address of prompt
    mov ah,09h                                             ; Function to display string
    int 21h                                                ; Display prompt
    
read_loop:

    mov ah,01h                                             ; Function to read character
    int 21h                                                ; Read character from user
    
    cmp al,13                                              ; Check if Enter key (carriage return)
    je display_sum                                         ; If so, go to display sum
    
    cmp al,'0'                                             ; Check if character is less than '0'
    jb invalid_input                                       ; If so, it's invalid input
    
    cmp al,'9'                                             ; Check if character is greater than '9'
    ja invalid_input                                       ; If so, it's invalid input
    
    sub al,'0'                                             ; Convert ASCII digit to binary value
    xor ah,ah                                              ; Clear upper byte of AX
    add sum,ax                                             ; Add value to sum
    
    jmp read_loop                                          ; Repeat loop for next character
    
invalid_input:

    mov dl,offset error                                    ; Load address of error message
    mov ah,09h                                             ; Function to display string
    int 21h                                                ; Show error message
    
    jmp start_input                                        ; Restart input process
    
display_sum:
    
    ; Print a new line.
    
    mov ah,02h                                             ; Function to print character
    mov dl,0Dh                                             ; Carriage Return
    int 21h
    mov dl,0Ah                                             ; Line Feed
    int 21h

    mov dl,offset result                                   ; Load address of result message
    mov ah,09h                                             ; Function to display string
    int 21h                                                ; Show result message
    
    mov ax, sum                                            ; Move total sum to AX
    
    mov cx, 4                                              ; We want to print 4 hex digits
    mov bx, ax                                             ; Copy sum to BX

print_hex:

    rol bx, 4                                              ; Rotate left 4 bits to bring next hex digit to lower nibble
    mov dl, bl                                             ; Copy lower byte of BX to DL
    and dl, 0Fh                                            ; Mask higher bits, isolate 4-bit hex digit
    
    cmp dl, 9                                              ; If digit <= 9
    jbe add_ascii_digit                                    ; Then convert directly
    
    add dl, 7                                              ; Else adjust to ASCII A-F range
    
add_ascii_digit:

    add dl, '0'                                            ; Convert to ASCII by adding '0'
    
    mov ah, 02h                                            ; Function to display character
    int 21h                                                ; Print hex digit
    
    loop print_hex                                         ; Loop until 4 hex digits are printed

    mov ah , 4ch                                           ; Terminate program
    int 21h

main endp
end main
