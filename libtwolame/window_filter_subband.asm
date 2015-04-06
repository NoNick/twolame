extern _GLOBAL_OFFSET_TABLE_

section .data
        align   8
        zero    dq asm_cycle.zero
        one     dq asm_cycle.one
        two     dq asm_cycle.two
        three   dq asm_cycle.three
        four    dq asm_cycle.four
        five    dq asm_cycle.five
        six     dq asm_cycle.six
        seven   dq asm_cycle.seven

section .text

global asm_cycle

; void asm_cycle(float *dp, int pa, float *y, const float *enwindowT);
; similar to following C code:
;     float *pEnw = enwindowT;
;     for (i = 0; i < 32; i++) {
;         float *dp2 = dp + i * 8;
;         float t = 0;
;         for (j = 0; j < 8; j++) {
;             t += dp2[(pa + j) % 8] * pEnw[j];
;         }
;         pEnw += j;
;         y[i] = t;
;     }
asm_cycle:
        lea rax, [rel zero]
        mov r11, [rax + rsi * 8]

    .begin:
        mov     r10, 32
        .loop1:
                jmp     r11
            .done:
                dpps    xmm0, [rcx], 0xF1
                dpps    xmm1, [rcx + 16], 0xF1
                addss   xmm0, xmm1
                movss   [rdx], xmm0

                add     rdi, 32             ; dp += 8
                add     rcx, 32             ; enwindowT += 8
                add     rdx, 4              ; y++
                dec     r10
                jnz     .loop1
	ret

        .zero:
                movups      xmm0, [rdi]
                movups      xmm1, [rdi + 16]
                jmp         .done

        .one:
                movups      xmm0, [rdi + 4]
                movups      xmm1, [rdi + 20]            ; warning: access to potentially uninitialized data (byte after rdi + 32)
                insertps    xmm1, [rdi], 0x30
                jmp         .done

        .two:
                movups      xmm0, [rdi + 8]
                movups      xmm1, [rdi + 24]            ; warning: access to potentially uninitialized data (2 bytes after rdi + 32)
                insertps    xmm1, [rdi], 0x20           ; swapping 0x20 & 0x30 doesn't make a lot of noise
                insertps    xmm1, [rdi + 4], 0x30       ; need to check if imm8 is right
                jmp         .done

        .three:
                movups      xmm0, [rdi + 12]
                movups      xmm1, [rdi - 4]             ; warning: access to potentially uninitialized data (byte before rdi)
                insertps    xmm1, [rdi + 28], 0x0
                jmp         .done

        .four:
                movups      xmm0, [rdi + 16]
                movups      xmm1, [rdi]
                jmp         .done

        .five:
                movups      xmm0, [rdi + 20]            ; warning: access to potentially uninitialized data (byte after rdi + 32)
                insertps    xmm0, [rdi], 0x30
                movups      xmm1, [rdi + 4]
                jmp         .done

        .six:
                movups      xmm0, [rdi + 24]            ; warning: access to potentially uninitialized data (2 bytes after rdi + 32)
                insertps    xmm0, [rdi], 0x20
                insertps    xmm0, [rdi + 4], 0x30
                movups      xmm1, [rdi + 8]
                jmp         .done

        .seven:
                movups      xmm0, [rdi - 4]             ; warning: access to potentially uninitialized data (byte before rdi)
                insertps    xmm0, [rdi + 28], 0x0
                movups      xmm1, [rdi + 12]
                jmp         .done
