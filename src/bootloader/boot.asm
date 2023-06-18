org 0x7C00
bits 16


%define ENDL 0x0D, 0x0A

; FAT12 header
jmp short start
nop

bdb_oem:                    db 'MSWIN4.1' ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880       ; 1.44MB
bdb_media_descriptor_type;  db 0F0h
bdb_sectors_per_fat:        dw 9
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           dd 0
                            dd 0
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 34h, 56h, 78h
ebr_volume_label:           db 'NANOBYTE OS'
ebr_system_id:              db 'FAT12   '

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