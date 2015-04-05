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

%macro  place 1
        mov         eax, dword [rdi + r9 * 4]
        mov         dword [rel %1], eax
        inc         r9
        and         r9, 7
%endmacro

; void asm_cycle(FLOAT *dp, int pa, FLOAT *y, FLOAT* enwindowT);
asm_cycle:
        mov     r11, [rel zero]
        cmp     rsi, 0
        je      .begin
        mov     r11, [rel one]
        cmp     rsi, 1
        je      .begin
        mov     r11, [rel two]
        cmp     rsi, 2
        je      .begin
        mov     r11, [rel three]
        cmp     rsi, 3
        je      .begin
        mov     r11, [rel four]
        cmp     rsi, 4
        je      .begin
        mov     r11, [rel five]
        cmp     rsi, 5
        je      .begin
        mov     r11, [rel six]
        cmp     rsi, 6
        je      .begin
        mov     r11, [rel seven]

    .begin:
        mov     r10, 32
        .loop1:
                jmp     r11
            .done:
;                mov     r9, rsi
;                place   pos0
;                place   pos1
;                place   pos2
;                place   pos3
;                place   pos4
;                place   pos5
;                place   pos6
;                place   pos7

;                xorps   xmm0, xmm0
;                vmovaps xmm2, [rel pos0]
;                dpps    xmm1, [rcx], 0xF1
;                addps   xmm0, xmm1
;                vmovaps xmm2, [rel pos4]
;                dpps    xmm1, [rcx + 16], 0xF1
;                addps   xmm0, xmm1
;                vmulps  ymm2, ymm0, ymm1
                vmovaps ymm0, [rel pos0]
                vdpps   ymm0, ymm0, [rcx], 0xF1
                vmovaps [rel pos0], ymm0
                movss   xmm0, [rel pos0]
                movss   xmm1, [rel pos4]
                addss   xmm0, xmm1
                movss   [rdx], xmm0

                add     rdi, 32             ; dp += 8
                add     rcx, 32             ; enwindowT += 8
                add     rdx, 4              ; y++
;                inc     r10
;                cmp     r10, 32
;                jl      .loop1
                dec     r10
                jnz     .loop1
	ret

        .zero:
                vmovups     ymm0, [rdi]
                vmovaps     [rel pos0], ymm0
                jmp         .done

        .one:
                movups      xmm0, [rdi + 4]
                movaps      [rel pos0], xmm0
                mov         rax, [rdi + 20]
                mov         [rel pos4], rax
                mov         rax, [rdi + 24]
                mov         [rel pos5], rax
                mov         rax, [rdi + 28]
                mov         [rel pos6], rax
                mov         rax, [rdi]
                mov         [rel pos7], rax
                jmp         .done

        .two:
                movups      xmm0, [rdi + 8]
                movaps      [rel pos0], xmm0
                mov         rax, [rdi + 24]
                mov         [rel pos4], rax
                mov         rax, [rdi + 28]
                mov         [rel pos5], rax
                mov         rax, [rdi]
                mov         [rel pos6], rax
                mov         rax, [rdi + 4]
                mov         [rel pos7], rax
                jmp         .done

        .three:
                movups      xmm0, [rdi + 12]
                movaps      [rel pos0], xmm0
                mov         rax, [rdi + 28]
                mov         [rel pos4], rax
                mov         rax, [rdi]
                mov         [rel pos5], rax
                mov         rax, [rdi + 4]
                mov         [rel pos6], rax
                mov         rax, [rdi + 8]
                mov         [rel pos7], rax
                jmp         .done

        .four:
                movups      xmm0, [rdi + 16]
                movaps      [rel pos0], xmm0
                movups      xmm0, [rdi]
                movaps      [rel pos4], xmm0
                jmp         .done

        .five:
                mov         rax, [rdi + 20]
                mov         [rel pos0], rax
                mov         rax, [rdi + 24]
                mov         [rel pos1], rax
                mov         rax, [rdi + 28]
                mov         [rel pos2], rax
                mov         rax, [rdi]
                mov         [rel pos3], rax
                movups      xmm0, [rdi + 4]
                movaps      [rel pos4], xmm0
                jmp         .done

        .six:
                mov         rax, [rdi + 24]
                mov         [rel pos0], rax
                mov         rax, [rdi + 28]
                mov         [rel pos1], rax
                mov         rax, [rdi]
                mov         [rel pos2], rax
                mov         rax, [rdi + 4]
                mov         [rel pos3], rax
                movups      xmm0, [rdi + 8]
                movaps      [rel pos4], xmm0
                jmp         .done

        .seven:
                mov         rax, [rdi + 28]
                mov         [rel pos0], rax
                mov         rax, [rdi]
                mov         [rel pos1], rax
                mov         rax, [rdi + 4]
                mov         [rel pos2], rax
                mov         rax, [rdi + 8]
                mov         [rel pos3], rax
                movups      xmm0, [rdi + 12]
                movaps      [rel pos4], xmm0
                jmp         .done


section .bss
    align   32
    pos0:   resb 4
    pos1:   resb 4
    pos2:   resb 4
    pos3:   resb 4
    pos4:   resb 4
    pos5:   resb 4
    pos6:   resb 4
    pos7:   resb 4
