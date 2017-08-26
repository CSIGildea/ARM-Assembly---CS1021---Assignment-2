	AREA	SymmDiff, CODE, READONLY
	IMPORT	main
	EXPORT	start

	;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.
	
start

	LDR	R1, =AElems	;startingAddress = inputtedAStartingAddress;
	LDR R7, =AElems	;changingAddress = inputtedAStartingAddress;
	LDR R2, =ASize	;aSizeAddress = inputtedASizeAddress;
	LDR R2, [R2]	;setSize = Memory.word[aSizeAddress]	
sortC	
sortB
;//Loop used to sort the elements in setA, setB and setC - This loop using insertion sort to sort the elements
	MOV R3, #0		;currentValue = 0;
	MOV R4, #0		;testValue = 0;
	MOV R5, #0		;finishedAddress = 0;
	MOV R6, R1		;testValueAddress = 0;
	ADD R6,R6,#4	;testValueAddress +=4;
	MOV R10,#4		;addressIncrement = 4;
	CMP R2,#0		;if (aSize!=0)
	BEQ emptySet	;{
	SUB R2,R2,#1	; setSize -= 1;
emptySet			;}
	MUL R5,R2,R10	;finishedAddress = setSize*addressIncrement;
	ADD R5,R5,R1	;finishedAddress += startingAddress;
	MOV R10,#0		;addressIncrement = 0;
sorting	
	CMP R2,#0		;while((aSize!=0)&&(changingAddress!=finishedAddress))
	BEQ empty		;{
	CMP R7,R5		;
	BEQ finishedSort;
	LDR R3,[R7]		;	currentValue = Memory.word(changingAddress);
	LDR R4,[R6]		;	testVale = Memory.word(testValueAddress);
					;
					;
	CMP R3,R4		;	if(currentValue>testValue)
	BLE higher		;	{
	STR R3,[R6]		;		Memory.word(testValueAddress) = currentValue;
	STR R4,[R7]		;		Memory.word(aChangingAddress) = testValue;
	CMP R1,R7		;		if(startingAddress!=testValueAddress)
	BEQ firstElementRun;	{
	MOV R8,R7		;			changingAddressBeforeInsertion = changingAddress;
	SUB R9,R7,#4	;			insertionCheckingAddress = changingAddress - 4;
while				;			while((startingAddress!=testValueAddress)&&(testValue<insertionCurrentValue)
	CMP R1,R7		;			{	
	BEQ startingElem				
	LDR R3,[R9]		;				insertionCurrentValue = Memory.byte(insertionCheckingAddress)
	CMP R3,R4		;
	BLE higherPrev	;				if(testValue<insertionCurrentValue)
					;				{
	STR R4,[R9]		;					Memory.word(insertionCheckingAddress) = testValue;
	STR R3,[R7]		;					Memory.word(changingAddress) = insertionCurrentValue;
	SUB R9,R9,#4	;					insertionCheckingAddress -=4;
	SUB R7,R7,#4	;					changingAddress -= 4;
	LDR R4,[R7]		;					testValue = Memory.word(changingAddress);
	B while			;				}
startingElem		;			}
higherPrev			;		
	MOV R7,R8		; 			changingAddress = changingAddressBeforeInsertion;
firstElementRun		;		}
higher				;	}
	ADD R7,R7,#4	;	currentValueAddress +=4;
	ADD R6,R6,#4	;	testValueAddress += 4;
	MOV R3,#0		;	currentValue = 0;
	MOV R4,#0		;	testValue = 0;
	B sorting		;}
finishedSort
empty
	LDR R1,=BElems	;startingAddress = inputtedBStartingAddress;
	CMP R5,R1		;if(finishedAddress<startingAddress) //Checks was B sorted
	BHI sortedB		;{
	LDR R7,=BElems	;	changingAddress = inputtedBStartingAddress;
	LDR R2,=BSize	;	sizeAddress = inputtedBSizeAddress;
	LDR R2,[R2]		;	size = Memory.word[SizeAddress];
	CMP R2,#0		;	if(size=0)
	BEQ setBEmpty	;	{
					;		//Branch to setBEmpty
					;	}
	B sortB			;	//Branch up to sortB which Sorts B elements	
sortedB				;}
setBEmpty
;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.
;//Finding the intersection of setA and setB and crossing them out by turning their most significant bit to 1
	CMP R12,#1			;if (finished != true)
	BEQ completedProgram;{
	LDR R3,=BElems		;	changingBAddress = inputtedBStartingAddress;
	LDR R4,=AElems		;	changingAAddress = inputtedAStartingAddress;
	LDR R5,=BSize		;	sizeBAddress = inputtedBSizeAddress;
	LDR R5,[R5]			;	sizeB = Memory.word[sizeBAddress];
	LDR R6,=ASize		;	sizeAAddress = inputtedASizeAddress;
	LDR R6,[R6]			; 	sizeA = Memory.word[sizeAAddress];
	MOV R7,#0 			;	countA = 0;
	MOV R8,#0			;	countB = 0;
whileCheckingIntersection	;
	CMP R6,#0			;	if(sizeA!=0)||(sizeB!=0)
	BEQ nullSet			;	{
	CMP R5,#0			;
	BEQ nullSet			;
	CMP R6,R7			;		if(sizeA!=countA)
	BEQ aCheckComplete	;		{
	CMP R5,R8			;			if(sizeB!=countB)
	BEQ bCheckComplete	;			{
	LDR R1,[R3]			;				testBValue = Memory.word[changingBAddress];	
	LDR R2,[R4]			;				testAValue = Memory.word[changingAAddress];
	CMP R1,R2			;				if(testBValue==testAValue)
	BNE dontCrossOut	;				{
	LDR R9, =0x80000000	;					mask = mostSignificantBit(1) 
	ORR R1,R1,R9		;					testBValue += mask;  //This should act like addition
	ORR R2,R2,R9		;					testAValue += mask;	 //in most cases
	STR R2,[R4]			;					Memory.byte(insertionCheckingAddress) = testValue;	
	STR R1,[R3]			;					Memory.byte(insertionCheckingAddress) = testValue;
dontCrossOut			;				}
	ADD R4,R4,#4		;				changingAAddress += 4;
	ADD R7,R7,#1		;				countA++;
	B whileCheckingIntersection;			//Branches unconditionally back to whileCheckingIntersection
aCheckComplete			;		}													//Curly Brackets placed this way to explain the branching present		
	LDR R4,=AElems		;			changingAAddress = inputtedAStartingAddress;			
	ADD R3,R3,#4		;			changingBAddress += 4;
	ADD R8,R8,#1		;			countB++;
	MOV R7,#0			;			countA = 0;
	B whileCheckingIntersection	;		//Branches unconditionally back to whileCheckingIntersection
bCheckComplete			;			}
						;
						;
;//Copying Across All elements in each set (it will branch back into this loop later), whilst ignore the intersection
nullSet					;}
	MOV R11,R6			;sizeCopy = aSize;
	LDR R4,=AElems		;changingAddress = inputtedAStartingAddress;
	LDR R5,=CElems		;changingCAddress = inputtedAStartingAddress;
	MOV R1,#0			;cSizeCount = 0;
	MOV R7,#0			;setElementCount = 0;
movingToC
	LDR R8,[R4]			;testValue = Memory.word[changingAddress];
	CMP R11,R7			;if(sizeCopy != setElementCount)
	BEQ aTransfered		;{
	CMP R8,#0x80000000	;	if(testValue's mostSignificantBit!=(1))
	BHI crossedOutAlready;	{
	STR R8,[R5]			;		Memory.word(changingCAddress) = testValue;
	ADD R5,R5,#4		;		changingCAddress += 4;
	ADD R1,R1,#1		;		cSizeCount++;
crossedOutAlready		;	}
	ADD R4,R4,#4		;	changingAddress +=4;
	ADD R7,R7,#1		; 	setElementCount++;
	B movingToC			;	//Branches unconditionally to movingToC
	
	
;//Checking has B been transfered to C, if not uncrossing all elements in A then transferring non intersected B elements to C.
	
aTransfered				;}
	LDR R10,=BElems		;testAddress = inputtedBStartingAddress;
	CMP R4,R10			;if (changingAddress<testAddress)
	BHI bTransfered		;{
	MOV R7,#0			;	setElementCount = 0;
	LDR R4,=AElems		;	changingAddress = inputtedAStartingAddress;
	LDR R6,=ASize		;	sizeAAddress = inputtedASizeAddress;
	LDR R6,[R6]			;	sizeA = Memory.word[sizeAAddress];
unCross
	CMP R6,R7			;	while(sizeA!=setElementCount)
	BEQ unCrossed		;	{
	LDR R8,[R4]			;		possibleCrossed = Memory.byte[changingAddress]
	CMP R8,#0x80000000	;		if(possibleCrossed's most significant bit is equal to 1)
	BLO uncrossedOutAlready;	{
	LDR R9, =0x80000000	;			mask = mostSignificantBit(1) 
	EOR R8,R8,R9		;			possibleUncross - mask //In most cases this exclusive or will act as subtract
	STR R8,[R4]			;			Memory.word(changingCAddress) = possibleCrossed;
uncrossedOutAlready		;		}
	ADD R4,R4,#4		;		changingAddress += 4;
	ADD R7,R7,#1		;		setElementCount++;
	B unCross			;//Branch unconditionally to unCross
unCrossed				;	}
	LDR R4,=BElems		;	changingAddress = inputtedBStartingAddress;
	MOV R7,#0			;	setElementCount = 0;
	LDR R12,=BSize		;	sizeAddress = inputtedBSizeAddress;
	LDR R11,[R12]		;	size = Memory.word[sizeAddress]
	CMP R11,#0			; 	if(size!=0)
	BEQ nullBSetSkip	;	{
	B movingToC			;		//Branch unconditionally into movingToC loop
						;	}
;//After the non intersected elements in B have been transferred, the crossed elements in B are uncrossed and set C is then sorted.
;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.
bTransfered				;}
	MOV R7,#0			;setElementCount = 0;
	LDR R4,=BElems		;changingAddress = inputtedBStartingAddress;
	LDR R6,=BSize		;sizeBAddress = inputtedBSizeAddress;
	LDR R6,[R6]			;sizeB = Memory.word[sizeBAddress];
unCrossB
	CMP R6,R7			;while(sizeB!=setElementCount)
	BEQ unCrossedB		;{
	LDR R8,[R4]			;	possibleCrossed = Memory.word[changingAddress]
	CMP R8,#0x80000000	;	if((possibleCrossed's most significant bit is equal to 1)
	BLO uncrossedOutAlreadyB;{
	LDR R9, =0x80000000	;		mask = mostSignificantBit(1) 
	EOR R8,R8,R9		;		possibleUncross - mask //In most cases this exclusive or will act as subtract
	STR R8,[R4]			;		Memory.word(changingCAddress) = possibleCrossed;
uncrossedOutAlreadyB	;	 }
	ADD R4,R4,#4		;	changingAddress += 4;
	ADD R7,R7,#1		;	setElementCount++;
	B unCrossB			;//Branch unconditionally to unCross
unCrossedB

;//Finally we sort the elements in C
;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.

nullBSetSkip
	LDR R11,=CSize		;sizeAddress = inputtedCSizeAddress;
	STR R1,[R11]		;Memory.word(sizeAddress) = cSizeCount;
	LDR R1,=CElems		;startingAddress = inputtedCStartingAddress;
	LDR R7,=CElems		;changingAddress = inputtedCStartingAddress;
	LDR R2,=CSize		;sizeAddress = inputtedCSizeAddress;
	LDR R12,=1			;finished = true;
	LDR R2, [R2]		;size = Memory.word[sizeAddress]
	CMP R2,#0			;if(size!=0)
	BEQ nullFinalSet	;{
	B sortC				;	//Branches unconditionally to sortC
nullFinalSet			;}
completedProgram		;
stop	B	stop

;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.

	AREA	TestData, DATA, READWRITE

ASize	DCD	8			; Number of elements in A
AElems	DCD	4,6,2,13,19,7,1,3	; Elements of A

BSize	DCD	6			; Number of elements in B
BElems	DCD 13,9,1,20,5,8		; Elements of B

CSize	DCD	0			; Number of elements in C
CElems	SPACE	56			; Elements of C

	END
