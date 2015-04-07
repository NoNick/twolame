extern _GLOBAL_OFFSET_TABLE_

section .data
        ; perform different commands (depend on offset) to fill xmm0, xmm1
        ; let's write down pointers to functions, so we can call [zero_ + offset * 8]
        align   8
        zero_   dq zero
        one_    dq one
        two_    dq two
        three_  dq three
        four_   dq four
        five_   dq five
        six_    dq six
        seven_  dq seven

section .text

global asm_cycle
global asm_cycle_extended

; fills r11 with address of suitable fetch function (zero, one, etc.)
; when the offset is in rsi
%macro  func_in_r11 0
        lea     rax, [rel zero_]
        mov     r11, [rax + rsi * 8]
%endmacro

; loads next 8 floats from rsi (dp) and rcx (enwindow)
; and writes its scalar product into rdx (y)
%macro  scalar_product 0
        call     r11
        dpps    xmm0, [rcx], 0xF1
        dpps    xmm1, [rcx + 16], 0xF1
        addss   xmm0, xmm1
        movss   [rdx], xmm0
%endmacro

; void asm_cycle(float *dp, int pa, float *y, const float *enwindowT, int n_cycles);
; similar to following C code:
;     float *pEnw = enwindowT;
;     for (i = 0; i < n_cycles; i++) {
;         float *dp2 = dp + i * 8;
;         float t = 0;
;         for (j = 0; j < 8; j++) {
;             t += dp2[(pa + j) % 8] * pEnw[j];
;         }
;         pEnw += j;
;         y[i] = t;
;     }
asm_cycle:
        func_in_r11

        .loop1:
                scalar_product

                add     rdi, 32             ; dp += 8
                add     rcx, 32             ; enwindowT += 8
                add     rdx, 4              ; y++
                dec     r8
                jnz     .loop1
	ret

; void asm_cycle_extended(float *dp, int pa, float *y, const float *enwindowT, int n_cycles, float *yprime);
; similar to following C code:
;     float *pEnw = enwindowT;
;     for (i = 0; i < n_cycles; i++) {
;         float *dp2 = dp + i * 8;
;         float t = 0;
;         for (j = 0; j < 8; j++) {
;             t += dp2[(pa + j) % 8] * pEnw[j];
;         }
;         pEnw += j;
;         y[33 + i] = t;
;         yprime[i + 1] = y[i + 17] + y[15 - i];
;     }
asm_cycle_extended:
        func_in_r11

        add     r9, 4                       ; yprime[i]
        lea     rax, [rdx + 68]             ; y[17]
        lea     r10, [rdx + 60]             ; y[15]
        add     rdx, 132                    ; y[33]
        .loop1:
                scalar_product

                movss   xmm0, [rax]         ; xmm0 = y[17 + i]
                movss   xmm1, [r10]         ; xmm1 = y[15 - i]
                addss   xmm0, xmm1
                movss   [r9], xmm0          ; yprime[i + 1] = xmm0 + xmm1

                add     rdx, 4              ; y[33 + i]
                add     rdi, 32             ; dp += 8
                add     rcx, 32             ; enwindowT += 8
                add     r9, 4               ; yprime[i + 1]
                add     rax, 4              ; y[17 + i]
                sub     r10, 4              ; y[15 - i]
                dec     r8
                jnz      .loop1
        ret

        zero:
                movups      xmm0, [rdi]
                movups      xmm1, [rdi + 16]
                ret

        one:
                movups      xmm0, [rdi + 4]
                movups      xmm1, [rdi + 20]            ; warning: access to potentially uninitialized data (byte after rdi + 32)
                insertps    xmm1, [rdi], 0x30
                ret

        two:
                movups      xmm0, [rdi + 8]
                movups      xmm1, [rdi + 24]            ; warning: access to potentially uninitialized data (2 bytes after rdi + 32)
                insertps    xmm1, [rdi], 0x20           ; swapping 0x20 & 0x30 doesn't make a lot of noise
                insertps    xmm1, [rdi + 4], 0x30       ; need to check if imm8 is right
                ret

        three:
                movups      xmm0, [rdi + 12]
                movups      xmm1, [rdi - 4]             ; warning: access to potentially uninitialized data (byte before rdi)
                insertps    xmm1, [rdi + 28], 0x0
                ret

        four:
                movups      xmm0, [rdi + 16]
                movups      xmm1, [rdi]
                ret

        five:
                movups      xmm0, [rdi + 20]            ; warning: access to potentially uninitialized data (byte after rdi + 32)
                insertps    xmm0, [rdi], 0x30
                movups      xmm1, [rdi + 4]
                ret

        six:
                movups      xmm0, [rdi + 24]            ; warning: access to potentially uninitialized data (2 bytes after rdi + 32)
                insertps    xmm0, [rdi], 0x20
                insertps    xmm0, [rdi + 4], 0x30
                movups      xmm1, [rdi + 8]
                ret

        seven:
                movups      xmm0, [rdi - 4]             ; warning: access to potentially uninitialized data (byte before rdi)
                insertps    xmm0, [rdi + 28], 0x0
                movups      xmm1, [rdi + 12]
                ret
