	AREA	Anagram, CODE, READONLY
	IMPORT	main
	EXPORT	start
	
;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.

start
	LDR	R5, =stringA	;stringAAddress = inputtedStringAAddress;
	LDR	R12,=stringB	;stringBAddress = inputtedStringBAddress;
	MOV R0,#0			;boolean anagram = false;
	LDRB R3, [R5]		;charA = Memory.byte(stringAAddress)
	LDRB R11,[R12]		;charB = Memory.byte(stringAAddress)
	CMP R3, #0			;if(charA = 0)
	BNE nullSet			;{
	CMP R11,#0			;	if(charB = 0)
						;	{
	BEQ bothNullSet		;	//Unconditionally branch to bothNullSet (Ends program)
						;	}
nullSet					;}
	MOV R10,#0			;countA= 0;
	MOV R11,#0			;countB= 0;
countA					
						;while(charA != 0)
						;{
	LDRB R3, [R5]		;	charA = Memory.byte(stringAAddress)
	CMP R3, #0			;
	BEQ endCountA		;				//Psuedocode for these two lines below the while loop - for clarity.
	ADD R10, R10, #1	;	countA++;
	CMP R3, #0x41		;	if (character>"A")||(character<"Z") //if (upperCase)
	BLO	notUpperCase	;	{
	CMP R3, #0x5A		;
	BHI	notUpperCase	;
	ADD R3, R3, #0x20	; 		ASCII Value of Character +=0x20;
	STRB R3, [R5]		;		Store new Lowercase ACII Character Value;
notUpperCase			;	}
	CMP R3, #0x61		;	if (character>"a")||(character<"z") //if (!lowerCase)
	BLO	notLowerCase	;	{
	CMP R3, #0x7A		;
	BHI	notLowerCase	;	//If a character is not in the lowercase alphabet, this program will now jump to the end and state it isn't an anagram
						;	}
						;	//After loop fully completed, it will become the finishedAddress
	ADD R5, R5, #1		;	finishedAddress++;
	B	countA			;}
						;if(charA = 0)
						;{	//Unconditionally branch to endCountA	}
endCountA	
	LDR R1,=stringA		;aStartingAddress = inputtedAStringStartingAddress;
	LDR R7,=stringA		;aChangingAddress = inputtedAStringStartingAddress;
	MOV R3, #0			;currentValue = 0;
	MOV R4, #0			;testValue = 0;
	MOV R6, R1			;testValueAddress = aStartingAddress;
	ADD R6,R6,#1		;testValueAddress++;

;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.

sorting	
	CMP R7,R5			;while(aChangingAddress!=finishedAddress)
	BEQ finishedSort	;{
	LDRB R3,[R7]		;	currentValue = Memory.byte(aChangingAddress);
	LDRB R4,[R6]		;	testValue = Memory.byte(testValueAddress);
	CMP R4, #0x00		;	if (character != NULL) 
	BEQ endprogram		;	{
	CMP R3,R4			;		if(currentValue>testValue)
	BLE higher			;		{
	STRB R3,[R6]		;			Memory.byte(testValueAddress) = currentValue;
	STRB R4,[R7]		;			Memory.byte(aChangingAddress) = testValue;		  
	CMP R1,R7			;			if(startingAddress!=testValueAddress)
	BEQ firstElementRun	;			{
	MOV R8,R7			;				changingAddressBeforeInsertion = aChangingAddress;
	SUB R9,R7,#1		;				insertionCheckingAddress = aChangingAddress - 1;
while
	CMP R1,R7			;				while((startingAddress!=testValueAddress)&&(testValue<insertionCurrentValue)
	BEQ startingElem	;				{
	LDRB R3,[R9]		;					insertionCurrentValue = Memory.byte(insertionCheckingAddress) // This line in code is before the  
	CMP R3,#0			;
	BEQ exitInsertion	;																			  // second condition of the while 
						;																			  // statement is met
	CMP R3,R4			;					if(testValue<insertionCurrentValue)
	BLE higherPrev		;
	CMP R3,R4		;					if(testValue<insertionCurrentValue)
	BLE higherPrev	;					{
	STRB R4,[R9]	;						Memory.byte(insertionCheckingAddress) = testValue;
	STRB R3,[R7]	;						Memory.byte(aChangingAddress) = insertionCurrentValue;
	SUB R9,R9,#1	;						insertionCheckingAddress -=1;
	SUB R7,R7,#1	;						aChangingAddress -= 1;
	LDRB R4,[R7]	;						testValue = Memory.byte(aChangingAddress);
	B while
startingElem		;					}
higherPrev			;				}
exitInsertion		;
	MOV R7,R8		;				aChangingAddress = changingAddressBeforeInsertion;
firstElementRun		;			}
higher				;		}
	ADD R7,R7,#1	;		currentValueAddress++;
	ADD R6,R6,#1	;		testValueAddress++;
	MOV R3,#0		;		currentValue = 0;
	MOV R4,#0		;		testValue = 0;
	B sorting		;		//Branch unconditionally to sorting
finishedSort		;	}
endprogram			;}

;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.

;//We now replace stringA with stringB and branch back into the loop to sort stringB
	CMP R11,#0		;if(countB=0)
	BNE sortingCompleted;{
	LDR R5,=stringB	;		stringBAddress = inputtedStringBAddress;	
countB				;
	LDRB R3, [R5]	;		charB = Memory.byte(stringBAddress)
	CMP R3, #0		;		if(charB!=0)
	BEQ endCountB	;		{
	ADD R11, R11, #1;		countB++;	
	CMP R3, #0x41	;		if (character>"A")||(character<"Z") //if (upperCase)
	BLO	notUpperCaseB;		{
	CMP R3, #0x5A	;
	BHI	notUpperCaseB;
	ADD R3, R3, #0x20; 		ASCII Value of Character +=0x20;
	STRB R3, [R5]	;		Store new Lowercase ACII Character Value;
notUpperCaseB		;		}
	CMP R3, #0x61		;	if (character>"a")||(character<"z") //if (!lowerCase)
	BLO	notLowerCaseB	;	{
	CMP R3, #0x7A		;
	BHI	notLowerCaseB	;	//If a character is not in the lowercase alphabet, this program will now jump to the end and state it isn't an anagram
						;	}
								;//After loop fully completed, it will become the finishedAddress
	ADD R5, R5, #1	;		finishedAddress++;
	B	countB		;		//Branch unconditionally to countB
endCountB			;		}
	LDR R1,=stringB	;		bStartingAddress = inputtedBStringStartingAddress;
	LDR R7,=stringB	;		bChangingAddress = inputtedBStringStartingAddress;
	MOV R3, #0		;		currentValue = 0;
	MOV R4, #0		;		testValue = 0;
	MOV R6, R1		;		testValueAddress = bStartingAddress;
	ADD R6,R6,#1	;		testValueAddress += 1;
	B 	sorting		;		//Branches unconditionally into sorting loop
sortingCompleted	;}

;//After the values have been sorted we compare the first element in stringA with the first element in stringB and continue to increment...etc
;//After doing this comparision we can see is this an anagram or not.
	LDR R1,=stringA
	LDR R7,=stringB
whileComparing			
	LDRB R8,[R1]			;charA = Memory.byte(stringAAddress)
	LDRB R9,[R7]			;charB = Memory.byte(stringBAddress)
	CMP R9, #0x00			;if(charB = NULL)
	BNE oneSetNull			;{
	CMP R8, #0x00			;	if(charA=NULL)
	BEQ finishedComparingAll;	//Branches unconditionally to finishedComparingAll - Out of whileComparing loop
oneSetNull					;}
	CMP R9,R8				;if(charA=charB)				
	BNE notAnagram			;{
	ADD R1,R1,#1			;	stringAAddress++;
	ADD R7,R7,#1			;	stringBAddress++;
	B whileComparing		;	//Branches unconditionally to whileComparing - Continuing the loop
notAnagram					;}
notLowerCase
notLowerCaseB
	MOV R0,#0				;anagram = false; //Code only run when charA!=charB
	B finishedComparing		;//Unconditionally branch to finishedComparing
finishedComparingAll		;
	MOV R0,#1				;anagram = true;  //Code only run when charA=charB in all cases of the strings
finishedComparing			;
bothNullSet					;
stop	B	stop

;Code belongs to Conor Gildea, completed first year at TCD in 2016/2017.

	AREA	TestData, DATA, READWRITE

stringA	DCB	"tacos",0
stringB	DCB	"coats",0

	END
