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

global dct1_sse_4_1
global dct1_extended_sse_4_1
global dct2_avx

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

; void dct1_sse_4_1(float *dp, int pa, float *y, const float *enwindowT, int n_cycles);
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
dct1_sse_4_1:
        func_in_r11

        .loop1:
                scalar_product

                add     rdi, 32             ; dp += 8
                add     rcx, 32             ; enwindowT += 8
                add     rdx, 4              ; y++
                dec     r8
                jnz     .loop1
	ret

; void dct1_extended_sse_4_1(float *dp, int pa, float *y, const float *enwindowT, int n_cycles, float *yprime);
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
dct1_extended_sse_4_1:
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

; void dct2_avx(float *s, float *yprime, float mem[][32]);
;
; similar to following C code:
;    for (i = 16; i > 0; i--) {
;    register float s0 = 0.0, s1 = 0.0;
;    register float *mp = mem[i - 1];
;    register float *xinp = yprime;
;    for (j = 0; j < 8; j++) {
;        s0 += *mp++ * *xinp++;
;        s1 += *mp++ * *xinp++;
;        s0 += *mp++ * *xinp++;
;        s1 += *mp++ * *xinp++;
;    }
;    s[i - 1] = s0 + s1;
;    s[32 - i] = s0 - s1;
;}
dct2_avx:
        lea     rdx, [rdx + 1920] ; mem[i - 1][0]. i = 16, 15 * 32 * 4 = 1920
        lea     r8, [rdi + 16 * 8]  ; s[32 - i], i = 16
        lea     rdi, [rdi + 15 * 8] ; s[i - 1], i = 16
        mov     rcx, 16
        .loop1:
                xorps   xmm0, xmm0              ; s0
                xorps   xmm1, xmm1              ; s1
                mov     rax, rdx                ; mp = mem[i - 1]
                mov     r9, rsi                 ; xinp = yprime
                mov     r10, 8
                .loop2:
                        movups  xmm2, [rax]
                        movups  xmm3, [r9]
                        vdpps   xmm4, xmm2, xmm3, 0x51
                        addss   xmm0, xmm4
                        vdpps   xmm4, xmm2, xmm3, 0xa1
                        addss   xmm1, xmm4
                        add     rax, 16
                        add     r9, 16
                        dec     r10
                        jnz     .loop2
                vaddss  xmm4, xmm0, xmm1
                cvtss2sd xmm4, xmm4
                movsd   [rdi], xmm4             ; s[i - 1] = s0 + s1
                vsubss  xmm4, xmm0, xmm1
                cvtss2sd xmm4, xmm4
                movsd   [r8], xmm4              ; s[32 - i] = s0 - s1
                sub     rdi, 8                  ; s[i - 1]
                add     r8, 8                   ; s[32 - i]
                sub     rdx, 128                ; mem[i - 1]
                loop    .loop1
        ret








