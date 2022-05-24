.model small
.stack 100h
N EQU 3
.data
	;SAVEREG dw (?)
	MAT db 1h,2h,3h,1h,2h,3h,1h,2h,3h ;
	MAT2 db 1h,2h,3h,3h,4h,5h,1h,2h,3h
	VEC db 0,0,0 ;vec that will help us multiply 
    RESULT dw 9 dup (0);the result vector
	ColIndex db N
	sum dw 0
	printIndex db N
	resultIndex dw 0
	RowIndex dw 0
	matrix2Index dw 0
	outsideLoopIndex dw 0
.code

	START:
		;setting data segment
		mov ax,@data
		mov ds,ax
		;setting extra segment
		mov ax,0b800h
		mov es,ax
		mov cx,N
		
		outsideLoop:
			;setting VEC to a column of the second mat
			mov cx,N
			mov si,0;si index of vector of second matrix
			mov ax,0
				loopInsertToVec:
					mov di,ds:[matrix2Index]
					mov al,ds:[MAT2+di]
					add ds:[matrix2Index],1
					mov ds:[VEC+si],al
					add si,1
				loop loopInsertToVec
		
		
			mov ds:[RowIndex],0
			Rowloop:	;the outside loop - running on the rows
				mov cx,N;cols Counter
				mov si,ds:[RowIndex];index matrix
				mov di,0;index vector
				mov dx,0;mat
				mov ax,0;vector
				
					Colloop:;the inside loop - running on the columns
						mov dl,ds:[MAT+si];dl saves a num of the mat
						mov al,ds:[VEC+di];al saves a num of the vec
						imul dl			;mul signed
						add ds:[sum],ax ;adding the multiply of a specific a(ij) to sum. 
						mov dx,0
						mov ax,0
						;seting the indexes for the next loop
						add si,N
						add di,1
					loop Colloop
					
			;sum contains the sum of all the multiply between row and col
			;then we saves sum in its palce in the result arr. 
			mov di,ds:[resultIndex]
			mov dx,ds:[sum];saving sum in dx cause we cant mov mem to mem
			mov ds:[sum],0 
			mov ds:[RESULT+di],dx ;saving the sum in hes right place.
			add ds:[resultIndex],2 ;adding resindex by 2 because its dw.
			add ds:[RowIndex],1
			;if condition to the Row loop:
			cmp ds:[RowIndex],N
			jne Rowloop
		;if condition to the outside loop:	
		add ds:[outsideLoopIndex],1
		cmp ds:[outsideLoopIndex],N
		jne outsideLoop
		
		
		
		;;;;;END OF PROGRAM AND TESTING
		;;;;; registers to test in debug
		mov bx,ds:[RESULT+12]
		mov cx,ds:[RESULT+14]
		mov dx,ds:[RESULT+16]
		
		;ending the program
		mov ax,4c00h
		int 21h
	END START
	