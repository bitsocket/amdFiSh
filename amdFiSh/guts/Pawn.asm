
macro EvalPawns Us {
	; in  rbp address of Pos struct
	;     rbx address of State struct
	;     rdi address of pawn table entry
	; out esi score
local Them, Up, Right, Left
local Isolated0, Isolated1, Backward0, Backward1, Unsupported, Doubled
local ..NextPiece, ..AllDone, ..Done, ..WritePawnSpan
local ..Neighbours_True, ..Lever_False, ..TestUnsupported
local ..Lever_True, ..Neighbours_False, ..Continue, ..NoPassed, ..PopLoop

match =White, Us
\{
	Them  equ Black
	Up    equ DELTA_N
	Right equ DELTA_NE
	Left  equ DELTA_NW
\}

match =Black, Us
\{
	Them  equ White
	Up    equ DELTA_S
	Right equ DELTA_SW
	Left  equ DELTA_SE
\}
	Isolated0 equ ((45 shl 16) + (40))
	Isolated1 equ ((30 shl 16) + (27))
	Backward0 equ ((56 shl 16) + (33))
	Backward1 equ ((41 shl 16) + (19))
	Unsupported equ ((17 shl 16) + (8))
	Doubled equ ((18 shl 16) + (38))


		xor   eax, eax
		mov   qword[rdi+PawnEntry.passedPawns+8*Us], rax
		mov   qword[rdi+PawnEntry.pawnAttacksSpan+8*Us], rax
		mov   byte[rdi+PawnEntry.kingSquares+Us], 64
		mov   byte[rdi+PawnEntry.semiopenFiles+Us], 0xFF

		mov   r15, qword[rbp+Pos.typeBB+8*Pawn]
		mov   r14, r15
		and   r14, qword[rbp+Pos.typeBB+8*Them]
		and   r15, qword[rbp+Pos.typeBB+8*Us]
		mov   r13, r15
	; r14 = their pawns
	; r13 = our pawns     = r15

		mov   rax, r15
	   shift_bb   Right, rax, rcx
		mov   rdx, r15
	   shift_bb   Left, rdx, rcx
		 or   rax, rdx
		mov   qword[rdi+PawnEntry.pawnAttacks+8*Us], rax

		mov   rax, LightSquares
		and   rax, r15
	     popcnt   rax, rax, rcx
		mov   rdx, DarkSquares
		and   rdx, r15
	     popcnt   rdx, rdx, rcx
		mov   byte[rdi+PawnEntry.pawnsOnSquares+2*Us+White], al
		mov   byte[rdi+PawnEntry.pawnsOnSquares+2*Us+Black], dl

		xor   esi, esi
	; esi = score

	       test   r15, r15
		 jz   ..AllDone


if PEDANTIC

		lea   r15, [rbp+Pos.pieceList+16*(8*Us+Pawn)]
	      movzx   ecx, byte[rbp+Pos.pieceList+16*(8*Us+Pawn)]
..NextPiece:
		add   r15, 1

else

..NextPiece:
		bsf   rcx, r15
	       blsr   r15, r15, rax

end if

		mov   edx, ecx
		and   edx, 7
		mov   r12d, ecx
		shr   r12d, 3
	if Us eq Black
		xor   r12d, 7
	end if
	; ecx = s, edx = f, r12d = relative_rank(Us, s)

	      movzx   eax, byte[rdi+PawnEntry.semiopenFiles+Us]
		btr   eax, edx
		mov   byte[rdi+PawnEntry.semiopenFiles+Us], al
		mov   rax, [PawnAttackSpan+8*(64*Us+rcx)]
		 or   qword[rdi+PawnEntry.pawnAttacksSpan+8*Us], rax

		mov   r11, r14
		and   r11, qword[ForwardBB+8*(64*Us+rcx)]
		neg   r11
		sbb   r11d, r11d
	; r11d = opposed
		mov   rdx, qword[AdjacentFilesBB+8*rdx]
	; rdx = adjacent_files_bb(f)
		mov   r10, qword[PassedPawnMask+8*(64*Us+rcx)]
		and   r10, r14
	; r10 = stoppers
		mov   r8d, ecx
		shr   r8d, 3
		mov   r8, qword[RankBB+8*r8-Up]
		mov   r9, r13
		and   r9, rdx
	; r9 = neighbours
		and   r8, r9
	; r8 = supported
		lea   eax, [rcx-Up]
		 bt   r13, rax
                mov   rax, r8           ; dirty trick relies on fact
                sbb   rax, 0            ; that r8>0 as signed qword
                lea   eax, [rsi-Doubled]
              cmovs   esi, eax
	; doubled is taken care of
		mov   rax, qword[PawnAttacks+8*(64*Us+rcx)]
               test   r9, r9
		 jz   ..Neighbours_False
..Neighbours_True:
		and   rax, r14
	; rax = lever
	     cmovnz   eax, dword[Lever+4*r12]
		lea   esi, [rsi+rax]
		jnz   ..TestUnsupported
..Lever_False:
		mov   rax, r9
		 or   rax, r10
	if Us eq White
		cmp   ecx, SQ_A5
		jae   ..TestUnsupported
	else if Us eq Black
		cmp   ecx, SQ_A5
		 jb   ..TestUnsupported
	end if
	if Us eq White
		bsf   rax, rax
	else if Us eq Black
		bsr   rax, rax
	end if
		shr   eax, 3
		mov   rax, qword[RankBB+8*rax]
		and   rdx, rax
	   shift_bb   Up, rdx
		 or   rdx, rax
		mov   eax, r11d
		and   eax, Backward0-Backward1
		lea   eax, [rsi+rax-Backward0]
	       test   rdx, r10
	     cmovnz   esi, eax
		jnz   ..Continue
..TestUnsupported:
		cmp   r8, 1
		sbb   eax, eax
		and   eax, Unsupported
		sub   esi, eax
		jmp   ..Continue

..Neighbours_False:
		and   rax, r14
	     cmovnz   eax, dword[Lever+4*r12]
		lea   esi, [rsi+rax]

		mov   eax, r11d
		and   eax, Isolated0-Isolated1
		lea   esi, [rsi+rax-Isolated0]

..Continue:
	; at this point we have taken care of
	;       backwards, neighbours, supported, lever

		neg   r11d
		mov   edx, ecx
		shr   edx, 3
		mov   rdx, qword[RankBB+8*rdx]
		and   rdx, r9
	     popcnt   r9, rdx, rax
	; r9 = popcnt(phalanx)
		neg   rdx
		adc   r11d, r11d
	       blsr   rax, r8
		neg   rax
		adc   r11d, r11d
		lea   r11d, [8*r11+r12]
		 or   rdx, r8
	     cmovnz   edx, dword[Connected+4*r11]
		add   esi, edx
	; connected is taken care of
	     popcnt   r11, r8, rax
        ; r8 = supported
	; r11 = popcnt(supported)

		mov   rax, qword[PawnAttacks+8*(64*Us+rcx)]
		and   rax, r14
	; rax = lever
		mov   rdx, qword[PawnAttacks+8*(64*Us+rcx+Up)]
		and   rdx, r14
	; rdx = leverPush

                mov   r12, r10

	       test   r13, qword[ForwardBB+8*(64*Us+rcx)]
		jnz   ..NoPassed
		xor   r10, rax
		xor   r10, rdx
		jnz   ..NoPassed
	     popcnt   rax, rax, r10
	     popcnt   rdx, rdx, r10
		sub   r11, rax
		sub   r9, rdx
		 or   r11, r9
		 js   ..NoPassed
		mov   eax, 1
		shl   rax, cl
		 or   qword[rdi+PawnEntry.passedPawns+8*Us], rax
                jmp   ..Done
..NoPassed:
                lea   eax, [rcx+Up]
                btc   r12, rax
	if Us eq White
                shl   r8, 8
		cmp   ecx, SQ_A5
		 jb   ..Done
	else if Us eq Black
                shr   r8, 8
		cmp   ecx, SQ_A5
		jae   ..Done
	end if
               test   r12, r12
                jnz   ..Done
               andn   r8, r14, r8
                 jz   ..Done
..PopLoop:
                bsf   r9, r8
                xor   eax, eax
                mov   r9, qword[PawnAttacks+8*(64*Us+r9)]
                and   r9, r14
               blsr   rdx, r9
               setz   al                
		shl   rax, cl
		 or   qword[rdi+PawnEntry.passedPawns+8*Us], rax
               blsr   r8, r8, rax
                jnz   ..PopLoop
..Done:

if PEDANTIC
	      movzx   ecx, byte[r15]
		cmp   ecx, 64
		 jb   ..NextPiece

else
	       test   r15, r15
		jnz   ..NextPiece
end if

..AllDone:

}
