	AREA	Closure, CODE, READONLY
	IMPORT	main
	EXPORT	start

;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.

start
	
	LDR	R1, =AElems	;aStartingAddress = inputtedAStartingAddress;
	LDR R7, =AElems	;aChangingAddress = inputtedAStartingAddress;
	LDR R2, =ASize	;aSizeAddress = inputtedASizeAddress;
	MOV R0,#0		;boolean closured = false;
	LDR R2, [R2]	;aSize = Memory.word[aSizeAddress]	
	CMP R2,#0		;if (aSize!=0)
	BEQ nullSet		;{
	MOV R3, #0		;	currentValue = 0;
	MOV R4, #0		;	testValue = 0;
	MOV R5, #0		;	finishedAddress = 0;
	MOV R6, R1		;	testValueAddress = AElemsAddress;
	ADD R6,R6,#4	;	testValueAddress += 4;
	MOV R10,#4		;	addressIncrement = 4;
	MOV R0, #1		;	boolean closured = true;  					//Will be reset later on
		
	SUB R2,R2,#1	;	aSize--; 									//To avoid over counting
	MUL R5,R2,R10	;	finishedAddress = aSize*addressIncrement;		//Calculating finishedAddress
	ADD R5,R5,R1	;	finishedAddress += startingAdddress;
	MOV R10,#0
sorting				;	
	CMP R7,R5		;	while(aChangingAddress!=finishedAddress)
	BEQ finishedSort;	{
	LDR R3,[R7]		;		currentValue = Memory.word(aChangingAddress);
	LDR R4,[R6]		;		testValue = Memory.word(testValueAddress);

	;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.
	
	CMP R3,R4		;		if(currentValue>testValue)
	BLE higher		;		{
	STR R3,[R6]		;			Memory.word(testValueAddress) = currentValue;
	STR R4,[R7]		;			Memory.word(aChangingAddress) = testValue;
	CMP R1,R7		;			if(startingAddress!=testValueAddress)
	BEQ firstElementRun;		{
	MOV R8,R7		;				changingAddressBeforeInsertion = aChangingAddress;
	SUB R9,R7,#4	;				insertionCheckingAddress = aChangingAddress - 4;
while
	CMP R1,R7		;				while((startingAddress!=testValueAddress)&&(testValue<insertionCurrentValue)
	BEQ startingElem;				{
	LDR R3,[R9]		;					insertionCurrentValue = Memory.word(insertionCheckingAddress) // This line in code is before the  
					;																				  // second condition of the while 
					;																				  // statement is met
	CMP R3,R4		;					if(testValue<insertionCurrentValue)
	BLE higherPrev	;					{
	STR R4,[R9]		;						Memory.word(insertionCheckingAddress) = testValue;
	STR R3,[R7]		;						Memory.word(aChangingAddress) = insertionCurrentValue;
	SUB R9,R9,#4	;						insertionCheckingAddress -=4;
	SUB R7,R7,#4	;						aChangingAddress -= 4;
	LDR R4,[R7]		;						testValue = Memory.word(aChangingAddress);
	B while
startingElem		;					}
higherPrev			;				}
	MOV R7,R8		;				aChangingAddress = changingAddressBeforeInsertion;
firstElementRun		;			}
higher				;		}
	ADD R7,R7,#4	;	currentValueAddress += 4; 
	ADD R6,R6,#4	;	testValueAddress += 4;
	MOV R3,#0		; 	currentValue = 0;
	MOV R4,#0		;	testValue = 0;
	B sorting		;	//Branch unconditionally to sorting
finishedSort		;	}

;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.

whileComparing
	CMP R1,R7		;			while(aStartingAddress<=aChangingAddress)
	BHI comparedMoreThanHalf;	{
	LDR R8,[R1]		;				testValue = Memory.word(aStartingAddress);
	LDR R9,[R7]		;				currentValue = Memory.word(aChangingAddress);
	SUB R11,R9,R8	;				zeroNumberTest = currentValue - testValue;
	CMP R11,#0		;				if(zeroNumberTest = 0)
	BEQ notClosed	;				{ //Branch inconditionally to notClosed	}
	ADD R10,R9,R8	;				valuesAdded = testValue + currentValue;
	CMP R10,#0		;				if(valuesAdded = 0) 				//If it isn't it branches to notClosed
	BNE notClosed	;				{
	ADD R1,R1,#4	;					aStartingAddress += 4;
	SUB R7,R7,#4	;					aChandingAddress -= 4;
	B whileComparing;			}										//Branches back to the top of while loop if valuesAdded = 0;
notClosed			;				} 							//Curly Brackets placed this way to explain the branching present							
					;				else
					;				{
	MOV R0,#0		;					closed = false;
	B finishedComparing;											//branches to end of program
comparedMoreThanHalf;				}
	MOV R0,#1		;		closed = true;
finishedComparing	;	}
nullSet				;}
stop	B	stop

;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.

	AREA	TestData, DATA, READWRITE

ASize	DCD	8			; Number of elements in A
AElems	DCD	+4,-6,-4,+3,-8,+6,+8,-3 ; Elements of A

	END
