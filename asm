ORG 100H           ; Program dimulai pada offset 100H

START:
    MOV AH, 09H     ; Menampilkan teks
    LEA DX, MSG1
    INT 21H

    ; Set angka rahasia ke 51
    MOV SI, 51    ; Menyimpan angka rahasia (51) ke SI
    
   
INPUT_GUESS:
    MOV AH, 09H     ; Menampilkan pesan masukkan angka
    LEA DX, MSG2
    INT 21H

    CALL GET_NUMBER ; Memanggil fungsi untuk mengambil input angka
    MOV DI, AX      ; Menyimpan angka input ke DI

    CMP DI, SI      ; Membandingkan angka input dengan angka rahasia
    JE CORRECT      ; Jika sama, loncat ke CORRECT
    JL TOO_LOW      ; Jika input < angka rahasia, loncat ke TOO_LOW
    JG TOO_HIGH     ; Jika input > angka rahasia, loncat ke TOO_HIGH

TOO_LOW:
    MOV AH, 09H
    LEA DX, MSG3    ; Pesan "Tebakan terlalu rendah"
    INT 21H
    JMP INPUT_GUESS ; Ulangi tebak angka

TOO_HIGH:
    MOV AH, 09H
    LEA DX, MSG4    ; Pesan "Tebakan terlalu tinggi"
    INT 21H
    JMP INPUT_GUESS ; Ulangi tebak angka

CORRECT:
    MOV AH, 09H
    LEA DX, MSG5    ; Pesan "Tebakan benar"
    INT 21H
    JMP EXIT        ; Keluar dari game

EXIT:
    MOV AH, 4CH     ; Perintah keluar
    INT 21H

; Fungsi untuk mengambil input angka dari pengguna
GET_NUMBER:
    MOV AH, 01H     ; Input karakter pertama
    INT 21H
    SUB AL, '0'     ; Konversi ASCII ke angka
    MOV BL, AL      ; Simpan digit pertama

    MOV AH, 01H     ; Input karakter kedua (jika ada)
    INT 21H
    SUB AL, '0'     ; Konversi ASCII ke angka
    MOV BH, AL      ; Simpan digit kedua (jika ada)

    ; Jika ada digit kedua, kombinasikan keduanya
    MOV AL, BL      ; AL = digit pertama
    MOV CL, 10
    MUL CL          ; AL = digit pertama * 10
    ADD AL, BH      ; AL = digit pertama * 10 + digit kedua

    ; Jika hanya satu digit, AL sudah berisi digit pertama
    RET

; Subroutine untuk menampilkan angka (desimal) di layar
DISPLAY_NUM:
    XOR CX, CX       ; Membersihkan CX untuk menghitung digit
    MOV BX, 10       ; Basis desimal
CONVERT_LOOP:
    XOR DX, DX       ; Membersihkan DX untuk operasi DIV
    DIV BX           ; Membagi AX dengan 10
    ADD DL, '0'      ; Mengonversi sisa bagi ke karakter ASCII
    PUSH DX          ; Menyimpan digit di stack
    INC CX           ; Menambah jumlah digit
    CMP AX, 0
    JNE CONVERT_LOOP ; Ulangi jika AX belum nol

PRINT_DIGITS:
    POP DX           ; Mengambil digit dari stack
    MOV AH, 02H      ; Menampilkan karakter
    INT 21H
    LOOP PRINT_DIGITS
    RET

; Data segment
MSG1 DB 'Selamat datang di game Tebak Angka!$'
MSG2 DB 0DH, 0AH, 'Masukkan angka antara 1-100: $'
MSG3 DB 0DH, 0AH, 'Tebakan terlalu rendah.$'
MSG4 DB 0DH, 0AH, 'Tebakan terlalu tinggi.$'
MSG5 DB 0DH, 0AH, 'Selamat, tebakan Anda benar!$'
MSG_SECRET DB 0DH, 0AH, 'Kode rahasia: $'

END START          ; Menandai akhir program
