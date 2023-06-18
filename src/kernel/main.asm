org 0x7C00
bits 16


%define ENDL 0x0D, 0x0A


; FUNCTION start
; Starting point, jumps to main
; END
start:
    jmp main

; FUNCTION puts
; Basic 'puts' (from kernel32)
; Puts a string to the screen
; Params:
;   - ds:si points to string
; END
puts:
    ; save registers (for modding)
    push si
    push ax

.loop:
    lodsb      ; Load next char in 'al'
    or al, al  ; verify next char is NULL
    jz .done   ; Return if done

    mov ah, 0x0e
    mov bh, 0
    int 0x10

    jmp .loop  ; Continue loop

.done:
    pop ax
    pop si
    ret


; FUNCTION main
; Main entry point
; END
main:

    ; setup data segments
    mov ax, 0   ; Can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack

    mov ss, ax
    mov sp, 0x7C00
    
    ; print msg_hello
    mov si, msg_hello
    call puts
    
    ; END OF PROG
    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello World', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h