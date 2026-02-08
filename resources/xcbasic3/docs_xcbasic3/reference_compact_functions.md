====== XC=BASIC 3.0 programming reference START ======

====== Syntax ======

===== Vocabulary =====

The following reserved keywords form the basic vocabulary of the language. The keywords may be spelled with either upper or lower case letters, or a mix of both. Therefore ''PRINT'', ''print'' and ''Print'' are equivalent.

<html><tt>
AND AS ASM BACKGROUND BORDER BYTE CALL CASE CHARAT CLOSE CONST CONTINUE DATA DECIMAL DECLARE DIM DO DOKE ELSE END ERR
OR EXIT FAST FILTER FLOAT FOR FUNCTION GET GOSUB GOTO HSCROLL IF INCBIN INCLUDE INLINE INPUT INT INTERRUPT LET LOAD LOCATE LONG LOOP MEMCPY MEMSET MEMSHIFT MOD NEXT NOT OFF ON OPEN OPTION OR ORIGIN OVERLOAD POKE PRINT PRIVATE RANDOMIZE RASTER READ REM RETURN SAVE SCREEN SELECT SHARED SOUND SPRITE STATIC STEP STRING SUB SWAP SYS SYSTEM
 TEXTAT THEN TIMER TO TYPE UNTIL VMODE VOICE VOLUME VSCROLL WHILE WORD WRITE XOR
</tt></html>

<adm note>
In XC=BASIC (unlike CBM BASIC) you must separate keywords from each other or from other identifiers with at least one space. This will not impose any speed or size penalty on the compiled program.
</adm>
===== Identifiers =====

Identifiers are used to name constants, variables, labels, subs and functions in XC=BASIC. You may choose identifiers as you wish, following these rules:

  - The first character must be alphabetic or an underscore (''_'') character
  - The remaining characters must be alphabetic, numeric, or the underscore (''_'') character
  - The ''$'' sign may suffix the identifer, however it doesn't automatically mean that the identifier refers to a string.
  - Either upper or lower case alphabetic characters may be used. Both are considered equivalent. Therefore ''XYZ'' and ''xyz'' are considered the same identifier.
  - An identifer may not duplicate one of the reserved keywords in the basic vocabulary above.

Identifiers can be of any length. Unlike CBM BASIC, where only the first two characters are significant, in XC=BASIC all characters are significant. The length of your identifers will not affect the size of the compiled program. For this reason, you are advised to use descriptive identifiers that are easy to read.

===== Statements =====

Statements can be separated using the colon ('':'') character. The separator is not required if there's only one statement in one line. The following two code pieces will be compiled to the same exact executable.

  FOR i AS INT = 1 TO 5 : PRINT i : NEXT
  
  FOR i AS INT = 1 TO 5
    PRINT i
  NEXT

<adm warning>
XC=BASIC is strict when it comes to line ending. On Windows, it only interprets the CR+LF sequence ("\r\n") as line ending, while on *nix systems, the LF ("\n") character is recognized only. Make sure you convert your source files before you compile anything that was written in another OS.
</adm>

===== Comments =====

Anything after a single quote (''''') character, up until the end of the line is ignored during compilation.

  x = 5 ' Assigning the value 5 to the variable x

The [[REM]] statement also serves to add comments. However, it must be separated from other statements using the colon ('':'') character if it is on the same line. Anything following the REM keyword up until the end of the line is ignored.

  REM This is a comment
  PRINT x : REM Outputting the value of x


===== Whitespace =====

Whitespace (e.g. spaces and tabs) are required between identifiers and keywords to avoid confusion. You are encouraged to use indentation to make the program more readable:

  FOR i AS INT = 0 TO 10
    FOR j AS INT = 0 TO 10
      PRINT "row ", i, "column ", j
    NEXT j
  NEXT i

===== Labels and Line Numbers =====

Labels can be used to mark points in your code and are referenced by ''GOTO'' and ''GOSUB'' statements. Labels must be appended with a colon ('':'').

  GOSUB intro
  END
  
  intro:
  PRINT "welcome to my program"  
  RETURN

In later sections of this tutorial you will learn more about labels and how they can be useful in your program.

In addition to labels, you can use line numbers as well. Line numbers will be treated like labels by XC=BASIC. However, the following conditions apply:

  * Line numbers do not have to be consecutive
  * The colon ('':'') character must not be appended to line numbers
  * Labels, line numbers or unnumbered/unlabeled lines can be mixed in the program

===== Splitting long lines =====

Starting from [v3.1], the ''_'' (underscore) character can be used to split a logical line to multiple physical lines.

  ' The following is a single command split into
  ' multiple lines for better readability
  SPRITE 2 _
    SHAPE 3 _
    ON _
    AT 50, 50 _
    MULTI _
    UNDER BACKGROUND

<- installation_and_usage|Previous page  ^ syntax|Syntax  ^ datatypes|Next page ->
====== Data Types ======

XC=BASIC offers 7 built-in data types (also called //primitive types//):

^Type   ^Numeric range                                        ^Size in bytes^
|BYTE   |0 to 255                                             | 1          |
|INT |-32,768 to 32,767                                    | 2          |
|WORD   |0 to 65,535                                          | 2          |
|LONG   |-8,388,608 to 8,388,607                              | 3          |
|FLOAT  |±2.93874⨉10<sup>-39</sup> to ±1.69477⨉10<sup>38</sup>| 4          |
|DECIMAL|0 to 9999                                            | 2          |
|STRING |N/A                                                  |1-97       |

===== Numeric types =====

  * BYTE is the smallest and fastest numeric type. Bytes are typically used as array indices, counters in [[FOR]] loops, boolean (true or false) values, and many more.
  * INT (integer) is the most commonly used type in XC=BASIC programs. Integers offer a reasonably high range of values and they support negative numbers while still being computationally fast.
  * WORD is the unsigned version of INT. It's especially useful for specifying memory addresses, e. g in a [[POKE]] or [[PEEK]] statement.
  * LONG is similar to INT, but its numeric range is much larger. A LONG variable reserves 3 bytes in memory.
  * FLOATs are 32-bit floating point numbers with a 24-bit mantissa and an 8-bit exponent. They are similar to the numeric data type in CBM BASIC, but are accurate to only 6-7 decimal digits.

<adm warning>
Floating point variables have great flexibility because they can store very large and very small numbers, including a decimal fraction. However, they are manipulated much more slowly than the other types, and therefore should be used with caution and only when necessary.
</adm>

  * Finally, DECIMAL is a special type and the only reason it exists in XC=BASIC is because DECIMAL (or often called BCD - Binary Coded Decimal) numbers can be displayed on screen without the overhead of binary-decimal conversion. DECIMAL comes in handy when you want to display scores or other numeric information in a game relatively rapidly.

<adm warning>
DECIMAL has strict limitations. It only supports addition and subtraction and can not be converted to or from any other types.
</adm>

<adm note>
When displaying decimals, all the leading zeroes will be displayed. For example the number 99 will be displayed as ''0099''.
</adm>

===== Numeric literals =====

When compiling the program, the compiler must assign a type to all numbers it encounters. The compiler will identify the type of a number through the following rules:

  * A number featuring a decimal dot (''.'') will be recognized as FLOAT. For example, the number ''1.0'' is a FLOAT. You //must// use a decimal point in a FLOAT, even if its fractional part is zero. Without the decimal point the compiler will treat the number as an integral number and the program might be spending precious runtime converting it back to FLOAT.
  * A number appended with a ''d'' will be recognized as DECIMAL. For example, ''9999d'' is a valid DECIMAL.
  * A number between 0 and 255 will be recognized as BYTE
  * A number between -32,768 and 32,767 will be recognized as INT
  * A number between 32,768 and 65,535 will be recognized as WORD
  * A number between -8,388,608 and 8,388,607 will be recognized as LONG
  * Any other number will trigger a compile-time error

<adm note>
You can use scientific notation, e.g ''1.453E-12'' when writing FLOAT literals.
</adm>

==== Numeral systems ====

Numeric literals can be written in decimal, hexadecimal and binary form.

  * A number prepended with a ''$'' sign is recognized as hexadecimal, for example: ''$03FF''.
  * A number prepended with a ''%'' sign is recognized as binary, for example: ''%01110101''.
  * Any other numbers are recognized as decimal.

<adm warning>
Binary and hexadecimal numbers are always assumed unsigned. For example the number $FFFF will be treated as 65535 (WORD) rather than -1 (INT).
</adm>

===== Strings =====

Strings are fixed-length series of PETSCII characters. You can read more about strings on the [[v3:strings]] page.

<- syntax|Previous page ^ datatypes|Data Types  ^ variables|Next page ->

====== Variables ======

XC=BASIC is a statically typed programming language which means that the type of a variable is known at compile time. All variables have a type and that type cannot change.

===== Defining Variables =====

In an XC=BASIC program, all variables must be defined before they're used. Either you define them using the [[DIM]] statement (this is called //explicit// definition) or the compiler will auto-define them in certain situations. The latter is called //implicit// definition.

==== Explicit Definition ====

The ''DIM'' statement may be used to explicitly define variables. Here are some examples of variable definition using ''DIM'':

  DIM enemy_count AS INT
  DIM score AS DECIMAL
  DIM gravity AS FLOAT
  DIM name$ AS STRING * 16

Apart from the ''DIM'' statement, there are other cases where you may explicitly define a variable. You will learn about those later.

<adm note>
Defining variable types by using sigils (the ''#'', ''%'' and ''!'' suffixes) is no longer supported in XC=BASIC. The ''$'' character is allowed at the end of variable names for readability but the variable won't be defined as ''STRING'' just because the ''$'' sign is there. You //must// use ''DIM'' to define Strings.
</adm>

==== Implicit Definition ====

If an undefined variable is encountered by the compiler, it will try to define it silently. For example:

  a = 5
  PRINT a

The above program works because the compiler implicitly defines the variable ''a'' in the first line. But what will its type be? The compiler first checks the right hand side of the assignment, in this case the number ''5''. As stated previously, a number between 0 and 255 is best represented by the Byte type, and therefore the compiler will infer ''a'' to be of type Byte. This is called an //inferred type// because the compiler examines the expression and, using the above stated rules, decides which type best represents it.

This seems very convenient, but it is something you should generally avoid so that the compiler will not automatically assign data types you don't intend and/or produce results that are inaccurate yet hard to track down in code. Take the following example:

  a = 5
  a = a + 300
  PRINT a

In CBM BASIC, where the only numeric type is ''FLOAT'', you can safely expect the result to be ''305''. In XC=BASIC this is not the case. Let's break down the above example and see how the compiler will handle it:

  - The compiler defines ''a'' as ''BYTE'' and assigns the value ''5'' to it.
  - The expression ''a + 300'' is evaluated. Since ''300'' is an ''INT'', the expression will be evaluated as ''INT'', resulting to ''305''.
  - Now the result must be assigned to ''a''. The number ''305'' can't be assigned to a ''BYTE'', so it will be truncated to 8 bits.
  - The result is ''49''. 

Since, on the surface, the result does not make any sense to a human mind, it might be difficult to track down the problem. We can fix the above program by explicitly defining ''a'' as ''INT'':

  DIM a AS INT
  a = 5
  a = a + 300
  ' The result is: 305
  PRINT a

<adm warning>
It is recommended that you define variables explicitly rather than let the compiler guess their types to avoid issues like the example above.
</adm>

<adm note>
Unlike CBM BASIC variables, which are automatically initialized to ''0'', XC=BASIC does not provide any initialization of variables. This means that you cannot assume anything about the value of a variable until you have assigned some value to it. The initial value of a variable is simply whatever happens to be in the memory location XC=BASIC assigns to the variable.
</adm>

====== Constants ======

Constants are simple textual labels that represent numeric values //in compile time//. When the compiler encounters a constant, it will replace it with the value it represents.

The benefits of using constants instead of variables are:

  * As opposed to variables, no memory is allocated for constants
  * Constants are faster to evaluate than variables

<adm note>
Always use constants over variables whenever possible to save memory and speed up program execution. See the [[CONST]] keyword reference page for more information.
</adm>

====== Arrays ======

Arrays are similar to arrays in CBM BASIC.

  * They must be explicitly defined in all cases using ''DIM''
  * The maximum number of dimensions is 3

A few examples of defining arrays:

  DIM cards(52) AS BYTE
  DIM my_cards(5) AS BYTE
  DIM matrix(5, 5) AS FLOAT

Accessing array members is done using the usual BASIC syntax:

  DIM my_array(3, 3) AS LONG
  x = my_array(0, 1)

<adm warning>
Array indices are zero-based which means the first item's index is ''0''.
</adm>

<adm warning>
For performance reasons, array bounds are not checked at runtime. If you use an index that is out of the bounds, the result will be unpredictable.
</adm>

  DIM numbers(10) AS LONG
  ' This will compile fine but
  ' probably break your program because
  ' the last index in the array is 9.
  i = 10
  numbers(i) = 9999

====== Variable Scope ======

There are three scopes in XC=BASIC:

  * SHARED: the widest scope, a shared variable is visible in all Code Modules. A Code Module is a single source file (for example: //program.bas//). Learn more about [[code_modules|Code Modules here]].
  * GLOBAL: the variable is visible in the current Code Module (in the source file where it was defined).
  * LOCAL: the variable is only visible within the ''SUB'' or ''FUNCTION'' where it was defined.

If you define a variable outside a ''SUB'' or ''FUNCTION'', it will be defined in the **Global** scope by default which means that it can be accessed from everywhere within that BAS source file (even from within ''SUB''s and ''FUNCTION''s), but not from other files.

If you define a variable inside a ''SUB'' or ''FUNCTION'', it will be defined in the **Local** scope of that ''SUB'' or ''FUNCTION'' and it won't be accessible from anywhere else.

Using the ''SHARED'' keyword in a ''DIM'' statement, you can make a variable visible from all Code Modules:

<code>
' This file is first.bas
' 'a' is a global variable in this file only
DIM a AS INT
' 'b' is a shared variable visible in other files as well
DIM SHARED b AS INT
a = 5
b = 10
INCLUDE "second.bas"
' Will print: 5
PRINT a
' Will print: 11
PRINT b
</code>
<code>
' This file is second.bas
' 'a' is a global variable in this file only
' It doesn't collide with the other 'a' in first.bas
DIM a AS INT
a = 6
' We can access 'b' from first.bas
b = 11
</code>

====== Fast Variables ======

If you define a variable as ''FAST'', it will be reserved on the zero page, making it faster under the hood to reference and operate on. The space on zero page is limited ([[v3:memory_model|37-74 bytes, depending on target machine]]), but that's enough space to supply a relatively generous number of FAST variables.

<code>
DIM FAST ix AS BYTE
FOR ix = 0 TO 255
  ' A very fast loop
NEXT
</code>

<adm note>
When no more variables can be placed on the zero page, the compiler will emit a warning and ignore the ''FAST'' directive from then on.
</adm>

<- datatypes|Previous page ^ variables|Variables ^ operators|Next page ->

====== Operators ======

XC=BASIC provides the following operators:

===== Arithmetic Operators =====

  * ''*'' (multiplication)
  * ''/'' (division)
  * ''MOD'' (modulo)
  * ''+'' (addition or string concatenation)
  * ''-'' (subtraction)

Operands for the arithmetic operators can be any numeric expressions, with the exception of ''DECIMAL'' types that can only be operands for addition or subtraction.

The ''+'' operator can also be used to concatenate strings. In this case both operands must be strings, otherwise a compile-time error is emitted.

===== Relational Operators =====

  * ''='' (equal to)
  * ''<>'' (not equal to)
  * ''>'' (greater than)
  * ''>='' (greater than or equal to)
  * ''<'' (less than)
  * ''<='' (less than or equal to)

Operands for the relational operators can be any numeric expressions. A relational expression evaluates to ''255'' when the comparison passes (TRUE), and ''0'' when it fails (FALSE).

The relational operators ''='' and ''<>'' can also be used to compare strings. In this case both operands must be strings, otherwise a compile-time error will be emitted.

<adm note>
Comparing strings for ''>'', ''>='', ''<'' and ''<='' is not supported.
</adm>

===== Logical Operators =====

  * ''AND''
  * ''OR''
  * ''XOR''
  * [[SHL]] - logical shift left
  * [[SHR]] - logical shift right

Logical operators can operate on all integral types (BYTE, INT, WORD, LONG and DECIMAL).

===== Unary Operators =====

  * ''@'' ([[address-of|address of]])
  * ''-'' (negation)
  * ''NOT'' (logical reversion)

<- variables|Previous page ^ operators|Operators ^ expressions|Next page ->
====== Arithmetic expressions ======

When no parentheses are present, arithmetic expressions are evaluated from left to right, with multiplication and division having a higher priority than addition and subtraction.

The following table explains operator precedence in XC=BASIC:

| Highest    | ''NOT'', ''-'' (unary) |
|                 | ''*'', ''/'', ''MOD'' |
|                 | ''+'', ''-'' |
|                 | ''<'', ''<='', ''>'', ''='', ''>='', ''>'' |
| Lowest    | ''AND'', ''OR'', ''XOR'' |

The arithmetic operators, ''+'', ''-'', ''*'', and ''/'', work in the expected fashion, however, the result of arithmetic on type BYTE, WORD, INT or LONG cannot have a fractional result. Therefore ''5 / 2'' evaluates as 2, not 2.5. However, ''5.0 / 2.0'' evaluates as 2.5, because the presence of the decimal point tells the compiler that the numbers are of type FLOAT.

  PRINT 5/2 ' Outputs 2
  PRINT 5.0/2.0 ' Outputs 2.5

Operators, except unary operators, accept two operands. These two operands do not have to be of the same type. In a mixed expression, the operands are promoted to the higher type, being BYTE the lowest and FLOAT the highest type. The table below summarizes the results of a partially evaluated expression.

^              ^ BYTE            ^ WORD          ^ INT ^ LONG ^ FLOAT ^ DECIMAL ^
^ BYTE    | BYTE          | WORD        | INT | LONG | FLOAT |  -  |
^ WORD  | WORD        | WORD        | INT | LONG | FLOAT |  -  |
^ INT        | INT             | INT              | INT | LONG | FLOAT |  -  |
^ LONG   | LONG | LONG | LONG | LONG | FLOAT |  -  |
^ FLOAT  | FLOAT        | FLOAT        | FLOAT | FLOAT | FLOAT |  -  |
^ DECIMAL |  -  |  -  |  -  |  -  |  -  | DECIMAL |

<adm note>
DECIMAL types can not be used together with other types.
</adm>

The type of the data being operated on must be considered. For example, adding two values of type BYTE will always result in a value which is also of type BYTE, even if the result is too large to fit in a BYTE. For example, if ''x'' is a variable of type BYTE which has been previously assigned the value of 254, then the expression ''x + 4'' will NOT have a value of 258, but 2. This is because BYTE variables can only take on values between 0 and 255, so that when you add 4 to 254, the result is (258-256) = 2.

Likewise, adding or multiplying two numeric literals is subject to overflow, even if the left hand side of the assignment is a variable that could otherwise fit the result.

  DIM a AS INT
  a = 250 + 6
  PRINT a ' Outputs 0

Since both 250 and 6 are of type BYTE, the result will also be of type BYTE, regardless the type of ''a''. To overcome this problem, use the typecasting functions [[v3:cbyte|]], [[v3:cword|]], [[v3:cint|]] and [[v3:cfloat|]].

  DIM a AS INT
  a = CINT(250) + CINT(6)
  PRINT a ' Outputs 256

<- operators|Previous page ^ expressions|Arithmetic expressions ^ strings|Next page ->
====== Strings ======

Strings are fixed-length series of PETSCII characters. The maximum length of a string is 96 characters.

===== String literals =====

String literals must be enclosed between double quote (''"'') characters and may contain any ASCII character. Every ASCII character that has a PETSCII equivalent will be translated to PETSCII.

For characters that don't have an ASCII equivalent, you can use PETSCII escape sequences. An escape sequence is a number or an alias in curly braces. For example:

  PRINT "{CLR}" : REM clear screen
  PRINT "{147}" : REM same as above
  PRINT "{WHITE}text in white"

Refer to [[:petscii_escape_sequences|this page]] for all supported escape sequences.
===== Defining string variables =====

As opposed to numeric variables, string variables cannot be implicitly defined. You must use the ''DIM'' keyword to create a variable of STRING type. The statement must define the variable name, the type, and the maximum string length, as in this example:

  DIM varname$ AS STRING * 16
  
This will create a STRING variable named ''varname$'' with a maximum length of 16 characters.

<adm note>
The ''$'' postfix in the variable name is optional and may be omitted.
</adm>

<adm warning>
The maximum allowed string length is 96 characters.
</adm>
===== Value assignment =====

Variables of STRING type, just like any other variables, may be assigned values using the ''='' operator:

  varname$ = "hello world"
  
There's one caveat that you must be aware of: if the right-hand side of the assignment is longer than the variable's maximum length, the string will be truncated to fit into the variable. For example:

  DIM varname$ AS STRING * 5
  varname$ = "hello world"
  PRINT varname$ : REM will output "hello"
  
<adm warning>
Strings will be truncated to the maximum length that will fit into the variable. So if a STRING variable was defined with a length of 32, for example, then only the first 32 string characters of the assigned value will be stored.
</adm>
===== String operators =====

Use the ''+'' operator to concatenate two strings.

  DIM name$ AS STRING * 16
  DIM greet$ AS STRING * 23
  INPUT "enter your name: "; name$
  greet$ = "hello, " + name$
  
You can use the comparison operators ''='' and ''<>'' to verify two strings are identical.
===== String functions =====

You can find all functions that operate on strings on the [[functionref]] page.

===== Direct string manipulation =====

If you intend to manipulate strings directly, for example to examine and/or replace individual characters, you may use [[PEEK]] and [[POKE]] to read and write individual characters within strings. For this you must understand how strings are stored in memory. When you define a string variable, as in this example:

  DIM mystr$ AS STRING * 8

...the compiler will allocate 9 bytes in memory - one for holding the string length, and the rest for the characters that make up the string value. Now when you assign a value to this variable, such as:

  mystr$ = "hello"

...the memory area will be set like this (numbers in hexadecimal):

| | H | E | L | L | O | | | |
|---|---|---|---|---|---|---|---|---|
| 05 | 48 | 45 | 4C | 4C | 4F | | | |

The first byte will contain the string length (five characters in this case) and the following 5 bytes will represent the encoded PETSCII characters. Since the fixed size of this string is 8 characters, but the actual string is only 5 characters long, the last three bytes are unused and their values are undefined and insignificant. However, XC=BASIC does not perform "garbage collection" like some others languages do, so those 3 bytes will remain in memory for the entire runtime of the program as unused space unless you alter the string by assigning a new value. Therefore, for the sake of efficient memory use, it is best to ensure all strings are defined to a length that is as short as possible for the needs of the program.

The "@" operator returns the memory address of a variable. With this address, you can easily manipulate the string. For example, you can change its first character to an "A", as in the following example:

  POKE @mystr$ + 1, 65
  PRINT mystr$

Here is how the compiler will handle this example:

  * The expression ''@mystr$'' will be resolved to the address of ''mystr$'' as a WORD. This is the 1st byte of the string in memory, the one that holds the length of the string.
  * Adding 1 will resolve to the first character of the string (2nd byte).
  * The number 65 is the PETSCII-code of the letter 'A'

If the above code is compiled and run, the output will be "AELLO".

<- expressions|Previous page ^ strings|Strings ^ flowcontrol|Next page ->
====== Control Flow Statements ======

===== Conditional branching =====

With the ''IF'' statement you can test a condition and then run code based on whether the condition test passed or failed.

  IF <condition> THEN
      <statements>
  END IF

The ''IF'' clause runs the statements under it when the **<condition>** is evaluated to be **TRUE** (pass). If the **<condition>** evaluates to **FALSE** (fail), nothing is run.

You can optionally include **<statements>** that are run when the **<condition>** fails by adding an ''ELSE'' clause

  IF <condition> THEN
      <statements>
  ELSE  
      <statements>
  END IF

XC=BASIC doesn't contain a boolean data type to represent true or false, it uses a ''BYTE'' instead. The value of 0 represents **FALSE**. Any other value greater than 0 represents **TRUE**.

When the **<condition>** contains a comparison operator, such as ''='' or ''>'', the result of the comparison is set to 255 when the comparison passes, and 0 when it fails. The result is then processed as normal, with 0 representing **FALSE** and any other number representing **TRUE**.

If the **<condition>** is a numerical expression, such as ''1'' or ''10 - 10'', the result is evaluated the same way as previously described.

==== Single Line Variation ====

The ''IF'' statement can be written on a single line:

  IF <condition> THEN <statements> [ELSE <statements>]

One or more code **<statements>** must be added to the **THEN** clause. If multiple statements are added, they must be separated by a colon.

The ''ELSE'' clause is optional, and must contain at least one code **<statement>**. Multiple statements can be used if separated by a colon.

The single line ''IF'' statement runs the same as the normal multi line ''IF'' statement described in the previous section.

===== Multiple branching =====

The [[ON]] statement allows you to define multiple branches and an //index// expression. This expression will be evaluated as a number N and the program will continue at the Nth label in the list of branches.

<adm note>
The maximum allowed number of labels in the list is 256.
</adm>

  DIM x$ AS STRING * 8
  INPUT "enter a number "; x$
  ON SGN(VAL(x$)) + 1 GOTO negative, zero, positive
  negative:
  PRINT "you entered a negative number"
  END
  zero:
  PRINT "you entered zero"
  END
  positive:
  PRINT "you entered a positive number"

<adm warning>
Unlike CBM BASIC, where the first label (or line number) corresponds to the number 1, in XC=BASIC labels are zero-based. The first label is used for value 0, the second for 1, and so on.
</adm>

<adm warning>
If index is evaluated to a number that has no matching label in the list, for example if the number is bigger than the allowed number of labels, the program may crash or behave abnormally.
</adm>

''ON'' can also be used in combination with [[GOSUB]].
===== Looping =====

==== FOR ... NEXT loop ====

Syntax:

  FOR <variable> [AS <type>] = <start_value> TO <end_value> [STEP <step_value>]
    <statements>
  NEXT [<variable>]

The ''FOR ... NEXT'' loop initializes a counter variable and executes the statements until the counter variable equals the value in the ''TO'' clause. After each iteration, the counter variable is incremented by the step value or 1 in case the step value was not specified. For example:

  DIM i AS BYTE
  FOR i = 1 TO 30 STEP 3
    PRINT i
  NEXT i

In the above, the counter variable is pre-defined. If the variable is not pre-defined, you can use the ''AS'' keyword to specify the type and this way the compiler will automatically define the variable before starting the loop. The following code is identical to the one above:

  FOR i AS BYTE = 1 TO 30 STEP 3
    PRINT i
  NEXT i

<adm warning>
The counter variable, the start value, the end value and the step value must all be of the same numeric type and this type is concluded from the counter variable. All the other expresions will be converted to this type if possible, otherwise a compile-time error will be thrown.
</adm>

<adm note>
The variable name can be omitted in the ''NEXT'' statement.
</adm>

You can use the ''CONTINUE FOR'' command to skip the rest of the statements in the ''FOR ... NEXT'' block and go to the next iteration, for example:

  REM -- print numbers from 1 to 10, except 5 and 7
  FOR num AS BYTE = 1 TO 10
    IF num = 5 OR num = 7 THEN CONTINUE FOR
    PRINT num
  NEXT

Finally, you can use the ''EXIT FOR'' statement to early exit a ''FOR ... NEXT'' loop.

  DIM a$ AS STRING * 1
  FOR i AS BYTE = 1 TO 10
    PRINT "iteration #"; i : INPUT "do you want to continue? (y/n)"; a$
    IF a$ = "n" THEN EXIT FOR
    PRINT i
  NEXT i

==== DO ... LOOP loop ====

The ''DO ... LOOP'' loop can be used as either a pre-test or post test loop.

=== Pre-test syntax ===

  DO WHILE|UNTIL <condition>
    <statements>
  LOOP

=== Post-test syntax ===

  DO
    <statements>
  LOOP WHILE|UNTIL <condition>

The former is used to test the condition //before// entering the loop body and the latter is used to test the condition //after// each iteration. This effectively means that post-test loop will be executed at least once, whereas in a pre-test loop the condition may fail the very first time and therefore it may happen that the statements in the loop will not be executed at all.

In both types, you can either use the ''WHILE'' or the ''UNTIL'' keywords. ''WHILE'' means that the loop is //entered// if the condition evaluates to true, ''UNTIL'' means that the loop is //exited// if the condition evaluates to true.

Similarly to ''EXIT FOR'', you can use the ''EXIT DO'' command to prematurely exit a ''DO ... LOOP'' block, or ''CONTINUE DO'' to skip rest of the block and go to the next iteration.

<- strings|Previous page ^ flowcontrol|Control Flow Statements ^ subroutines|Next page ->
====== Subroutines ======

While you can use the [[GOSUB]] command in pair with [[RETURN]] to call parts of code as subroutines, the more sophisticated way of implementing subroutines is using the ''SUB ... END SUB'' block.

===== Defining Subroutines =====

Subroutines are named routines that accept zero or more arguments. The simplest syntax to define a subroutine is the following:

  SUB <rountine_name> ([arg1 AS <type>, arg2 AS <type>, ...])
    <statements>
  END SUB

It is worth noting that the argument list is optional. If you omit the arguments, you still must add the empty parentheses after the routine name, like so:

  SUB <routine_name> ()
    <statements>
  END SUB

===== Calling Subroutines =====

You can use the [[CALL]] keyword to call a subroutine. It behaves similarly to [[GOSUB]] with an important difference: ''CALL'' can pass arguments to the subroutine. Consider the following example:

  SUB greet (name$ AS STRING * 10)
    PRINT "Hello, "; name$
  END SUB
  
  CALL greet("Emily") ' will display: Hello, Emily
  CALL greet("Mark") ' will display: Hello, Mark

The ''CALL'' command will evaluate the argument list in the parentheses, pass all arguments to the subroutine and then instruct the computer to continue the program at the top of the subroutine.

===== Exiting Subroutines =====

The subroutine will be exited at the ''END SUB'' statement. If you want to exit a subroutine earlier, use the ''EXIT SUB'' command:

  SUB test (a AS INT)
    IF a < 0 THEN PRINT "positive number please" : EXIT SUB
    PRINT SQR(a)
  END SUB
  CALL test(-1)
===== Local and Global Variables =====

Variables defined inside a subroutine are local variables, i. e. they are only accessible within that subroutine. Global variables (the ones defined outside subroutines) are visible from within all subroutines.

  globalvar = 1
  SUB test ()
    PRINT globalvar : REM this is okay as globalvar is visible form here
    localvar = 5
  END SUB
  CALL test()
  PRINT localvar : REM ERROR: localvar is not defined in the global scope

==== Shadowing ====

A local variable may have the same name as a global variable. In such cases the local variable will be used inside the subroutine. This is know as a "shadow variable." Consider the following example:

  a = 42
  SUB test ()
    a = 5
    PRINT a
  END SUB
  CALL test() : REM will output 5
  PRINT a : REM will output 42


===== Static vs. Dynamic =====

It is important to understand how arguments may be passed to a subroutine. XC=BASIC offers two methods:

  * //Dynamic// arguments: the arguments are created dynamically in memory. Before the subroutine is called, a new area in memory - a //stack frame// - is allocated, and this area holds the passed arguments. The advantage of dynamic memory allocation is that it allows recursive subroutine calls, i. e. the subroutine can call itself without harming its data. However, there is a penalty: dynamic arguments operate much slower than static arguments.
  * //Static// arguments: the arguments are stored in a pre-allocated memory area. When the subroutine is called, the arguments are simply copied to this area. This is much faster than dynamic frame allocation but it doesn't support recursion.

The default method of passing arguments is //dynamic//. If you'd like to pass arguments statically, append the ''STATIC'' keyword to the subroutine definition:

  SUB <subroutine_name> (arg AS <type>) STATIC

<adm note>
The ''STATIC'' keyword in a subroutine definition not only applies to the subroutine's arguments but to all its local variables as well.
</adm>

<adm warning>
Always define your subroutines ''STATIC'' unless you intend to make recursive calls. The compiler will try to detect possible recursion and warn you about this in case you forget the ''STATIC'' keyword.
</adm>

==== Static Variables Inside Dynamic Subroutines ====

You can mix static and dynamic behaviour using the ''STATIC'' keyword instead of ''DIM'' to mark local variables static when a subroutine is otherwise dynamic.

  SUB test (arg AS INT)
    DIM a AS INT : REM a is dynamic
    STATIC b AS INT : REM b is static
  END SUB

<adm note>
Static local variables' values are preserved between subroutine calls. Upon entering a subroutine, static local variables have the same value as when the subroutine last exited. They are not overwritten.
</adm>

If a subroutine is defined as ''STATIC'', all its local variables will be static, regardless of whether you use the ''DIM'' or ''STATIC'' keyword to define them:

  SUB test (arg AS INT) STATIC
    DIM a AS INT : REM a is static
    STATIC b AS INT : REM b is also static
  END SUB

<adm warning>
The stack frame that is allocated on each subroutine call must not be larger than 128 bytes. The compiler detects if a subroutine requires a larger stack frame, and emits a compile-time error in such cases. Therefore it is recommended to keep as many variables ''STATIC'' as possible.
</adm>

===== Overloading =====

Subroutine overloading, commonly known as method overloading in object-oriented programming languages, refers to the ability to create multiple subroutines with the same name but different parameters. This feature allows a programmer to define different ways to call a subroutine based on the types and number of arguments passed.

Overloaded subroutines have the same name but differ in the type, number, or both type and number of parameters.

==== Compile-Time Polymorphism ====

The appropriate subroutine to call is determined at compile-time based on the arguments provided in the call.

Consider the following example:

  SUB PrintMessage(msg AS STRING * 16)
      PRINT msg
  END SUB
  
  SUB PrintMessage(msg AS STRING * 16, num AS INT) OVERLOAD
      PRINT msg; " "; num
  END SUB
  
  CALL PrintMessage("Hello, XC=BASIC!")
  CALL PrintMessage("The number is", 42)

<adm warning>
You must use the ''OVERLOAD'' keyword when defining the second and subsequent overloaded variations of a subroutine. This tells the compiler that the duplicate subroutine names are intentional overloads and not a programming mistake.
</adm>

<adm note>
It is possible to overload the built-in XC=BASIC functions in your code, too.
</adm>
===== Forward Declaration =====

A subroutine can not be called before it was defined. This often makes it hard to organize your code in a clean and readable way. You may want to put subroutines at the end of your code and that's a perfectly valid requirement.

This is where forward declaration comes in handy. Forward declaration means that you declare a subroutine's all important properties (or the //header// of the subroutine) beforehand, and leave the actual code implementation for later. Consider the following example:

  REM -- the top of the program
  DECLARE SUB somesub (arg AS FLOAT) STATIC
  REM -- the subroutine will be implemented later but it is already callable
  CALL somesub(3.1415)
  REM -- the bottom of the program
  SUB somesub (arg AS FLOAT) STATIC
    PRINT "two times the argument is: "; arg * 2.0
  END SUB

<adm warning>
The implementation of the subroutine later in the code must use the same number and type of arguments as the declaration. Overloading is still possible, though: you may declare overloaded variations of the subroutine and implement each variation later on in the program.
</adm>
===== Subroutine Visibility =====

Subroutines, as well as variables, may be defined with different visibility levels. XC=BASIC offers two options:

  * //Global// visibility: the subroutine is callable from within the entire code module it was defined (but not outside the code module).
  * //Shared// visibility: the subroutine is callable from within all code modules.

<adm note>
The default visibility for subroutines is //global//.
</adm>

To define a subroutine as shared, append the ''SHARED'' keyword to its definition:

  SUB <subroutine_name> (arg AS <type>) SHARED
  
  END SUB

This will ensure the subroutine is callable from within other code modules. Read more about [[code_modules|Code Modules here]].

<- flowcontrol|Previous page ^ subroutines|Subroutines ^ functions|Next page ->


====== Functions ======

Functions in XC=BASIC are essentially the same as [[subroutines|Subroutines]], with one important difference: functions //must// return a value. Everything else that is described on the [[subroutines|previous page]] is true for functions and will not be repeated here.

===== Defining the return type =====

A function must always return a type, that is, the type of the value that it returns. You must define the return type in the function definition line using the ''AS'' keyword:

  FUNCTION <fn_name> AS <type> (<arg> AS <type>)
    <statements>  
  END FUNCTION

===== Calling a function =====

Functions can not be called using the ''CALL'' keyword, but rather they must be invoked as part of an expression. A function call is treated like an expression and its type is concluded from the function's return type. For example:

  FUNCTION test AS LONG ()
    REM -- function body here
  END FUNCTION
  
  x = test()
  REM -- The variable x will be implicitly defined as LONG
  REM -- because the right hand side is a LONG type

<adm note>
For the above reason, there are no void functions in XC=BASIC. [[subroutines|Subroutines]] serve as void functions.
</adm>
===== Returning a value =====

There are two ways to return a value from a function:

  * The QBASIC style, by assigning a value to the function name.
  * Using the ''RETURN'' keyword.

Both styles are accepted in XC=BASIC. Here are two examples to demonstrate each:

  REM -- returning value the QBASIC style
  FUNCTION test AS BYTE ()
    test = 42
  END FUNCTION
  PRINT test() : REM will output 42

  REM -- returning value using the RETURN keyword
  FUNCTION test AS BYTE ()
    RETURN 42
  END FUNCTION
  PRINT test() : REM will output 42

The above two codes are identical, but the ''RETURN'' keyword comes with a restriction: it immediately exits the function. There can be, however, situations where you want to continue executing the function even after specifying the return value, for example:

  (TODO: provide example)

Note the use of the ''EXIT FUNCTION'' command that is used to early exit the function.

<adm warning>
If the code exits from a function before any return value was specified, an undefined value will be returned.
</adm>


====== User-Defined Types ======

User-defined types (or UDT's) allow you to create your own data structures. In its simplest form, a type definition is a bunch of field definitions inside a ''TYPE ... END TYPE'' block. The following example illustrates a very simple type definition:

  TYPE EMPLOYEE
    firstname AS STRING * 16
    lastname AS STRING * 16
    salary AS LONG
  END TYPE

A type can have any number of fields, but there is one restriction: the size of a single instance of the type may not exceed 64 bytes. In the above example, //firstname// and //lastname// take up 17 bytes each, and //salary//, being of LONG type takes 3 bytes. That's 37 bytes total, well below the limit.

Having defined the new type as above, you can define variables of EMPLOYEE type and assign values to its fields using the dot (''.'') notation:

  DIM emp AS EMPLOYEE
  emp.firstname = "Mark"
  emp.lastname = "Cunnigham"
  emp.salary = 45500

To read a field value you can use the same dot-notation:

  PRINT emp.firstname : REM outputs: "Mark"

<adm note>
Variables defined as UDT's are called //instances// of that type. In the above example, ''emp'' is an //instance// of the EMPLOYEE type.
</adm>
===== Arrays of user defined types variables =====

Multiple instances of UDT's can be organized in arrays, for example:

  DIM employees(50) AS EMPLOYEE

Now to access field values of a specific member in the array, you can combine the array notation and the dot notation:

  DIM sum AS LONG : sum = 0
  FOR i AS BYTE = 0 TO 49
    sum = sum + employees(i).salary
  NEXT i
  PRINT "the average salary at the company is "; sum / 50

<adm warning>
Arrays can be dimensioned as user-defined type, however TYPE definitions cannot contain array fields.
</adm>
===== Nested UDT's =====

A field in a TYPE definition can be of another TYPE, and so on, as long as a single insance does not exceed the 64 bytes limit explained above.

  TYPE VECTOR
    x AS INT
    y AS INT
  END TYPE
  
  TYPE SPRITE
    pos AS VECTOR
    color AS BYTE
  END TYPE

To access fields within the nested type, you can extend the dot notation like in the following example:

  DIM monster AS SPRITE
  monster.pos.x = 160
  monster.pos.y = 100
  monster.color = 3

===== Type methods =====

You can define [[Subroutines]] and [[Functions]] within a type declaration that allows you to define routines that work with data in a single instance of that type. These routines are called //type methods// and are very similar to object methods in object-oriented programming. Extending the example above, let's write a routine that moves the imaginary monster on the horizontal axis:

  TYPE VECTOR
    x AS INT
    y AS INT
  END TYPE
  
  TYPE SPRITE
    pos AS VECTOR
    color AS BYTE
    SUB move (amount AS INT) STATIC
      THIS.pos.x = THIS.pos.x + amount
    END SUB
  END TYPE
  
  DIM monster AS SPRITE
  monster.pos.x = 100
  CALL monster.move(5)
  PRINT monster.pos.x : REM outputs 105

===== The THIS keyword =====


Note the usage of the [[THIS]] keyword in the above example. ''THIS'' is a special variable that refers to the instance on which the method was called. In the above example, ''THIS'' refers to the variable that the ''move'' method was called on, in this case: //monster//.

<adm note>
Adding methods to a TYPE definition does not increase an instance's size and therefore methods do not count in the 64 bytes size limit.
</adm>

Defining functions within type definitions allows you to write methods that return a value. The following example is a theoretical game where two players fight each other, hitting in rounds, with a random damage. The method ''hit(damage)'' subtracts the damage from a fighter's energy and the method ''isdead()'' tells if the fighter is out of energy.

  TYPE FIGHTER
    energy as INT
    SUB hit (damage AS BYTE) STATIC
      THIS.energy = THIS.energy - CINT(damage)
    END SUB
    FUNCTION isdead AS BYTE () STATIC
      RETURN THIS.energy <= 0
    END FUNCTION
  END TYPE
  
  DIM player1 AS FIGHTER
  DIM player2 AS FIGHTER
  player1.energy = 1000
  player2.energy = 1000
  
  RANDOMIZE TI()
  DO
    CALL player1.hit(CBYTE(RNDL()))
    CALL player2.hit(CBYTE(RNDL()))
    PRINT "p1 energy: "; player1.energy; ", p2 energy: "; player2.energy
  LOOP UNTIL player1.isdead() OR player2.isdead()
  PRINT "game over"

As seen above, you can organize code in a very well-structured way with the help of UDT's.
 
<- functions|Previous page ^ udt|User-Defined Types ^ code_modules|Next page ->
====== Code Modules ======

A Code Module (or simply module) is a file containing XC=BASIC statements. An XC=BASIC program consists of one or more modules.

<adm note>
Modules usually have the //.bas// extension, although the compiler does not care about the extension. The //.bas// extension is to help text editors to detect what kind of code you're editing.
</adm>

Although completely optional, it is a good idea to organize code in multiple modules for better readability and maintainability if the program is growing exceedingly large.

===== Including modules =====

The [[INCLUDE]] directive instructs the compiler to load the given module, compile it, and "inject" the code into the current module at the exact point where the ''INCLUDE'' directive is.

//main.bas//
  REM -- a simple game
  INCLUDE "instructions.bas"
  INCLUDE "play.bas"
  CALL instructions ()
  DO
    CALL gameplay ()
  LOOP WHILE 1
//instructions.bas//
  SUB instructions () SHARED STATIC
    PRINT "welcome. use joystick in port 2. press fire to jump."
  END SUB
//play.bas//
  SUB gameplay () SHARED STATIC
    ' actual game code here...
  END SUB

The above example is a program that consists of three modules. The main module is //main.bas// and it includes two other modules, //instructions.bas// and //play.bas//.

As opposed to other languages, like C for example, you do not have to compile each module and have a linker to link them in one executable. You only have to compile the main module and the rest will be resolved by the compiler.

<adm note>
Included modules are resolved recursively. You can include modules in included modules, to any depth.
</adm>

Refer to the [[INCLUDE]] page to learn more - for example, how the compiler resolves the path of included modules.

===== Sharing identifiers among modules =====

<adm note>
We'll use the term "identifier" to refer to variables, constants, subroutines and functions.
</adm>

As you might have previously read [[variables#variable_scope|here]] and [[subroutines#subroutine_visibility|here]], variables, as well as constants, subroutines and functions, have three levels of visibility. The default visibility is GLOBAL, which means that the identifier is visible everywhere within the module where it was defined but not in other modules. The exception to this rule is when a variable or constant is defined within a subroutine or function. In this case, the default visibility is LOCAL.

To share an identifier with other modules, you must use the [[SHARED]] keyword. A few examples:

  SHARED CONST PI = 3.14159
  DIM a AS INT SHARED
  SUB clear_screen () SHARED STATIC



====== Error Handling ======

===== Defining an error handling routine =====

Starting from XC=BASIC version 3, certain runtime errors are trappable using the ''ON ERROR GOTO'' statement. You can specify a custom error handling routine that makes it possible to recover from errors when needed. The following example demonstrates this functionality:

  ON ERROR GOTO errhandler
  DIM d$ AS STRING * 6
  
  start:
    INPUT "enter divisor "; d$
    PRINT "10/"; d$; "="; 10.0 / VAL(d$)
    END
  
  errhandler:
    IF ERR() = 20 THEN
      PRINT "division by zero error"
      GOTO start
    END IF

===== Getting the error code =====

When an error occurs, the ''ERR()'' function returns the error code, a number between 0 and 255. The following are built-in errors in XC=BASIC:

^ Code      ^ Error message       ^
|1              |TOO MANY FILES   |
|2              |FILE OPEN              |
|3              |FILE NOT OPEN      |
|4              |FILE NOT FOUND   |
|5              |DEVICE NOT PRESENT |
|6              |NOT INPUT FILE      |
|7              |NOT OUTPUT FILE  |
|8              |MISSING FILENAME|
|9              |ILLEGAL DEVICE NUMBER |
|10            |DEVICE NOT READY |
|11            |OTHER READ ERROR |
|14            |ILLEGAL QUANTITY |
|15            |OVERFLOW |
|20            |DIVISION BY ZERO |
|21            |ILLEGAL DIRECT |

===== User-defined errors =====

Apart from the built-in errors, you can define your own error codes, too. You can use the ''ERROR'' command to trigger any error, built-in or custom.

  ON ERROR GOTO errhandler
  ERROR 99
  END
  errhandler:
    IF ERR() = 99 THEN PRINT "my custom error occured" ELSE PRINT "other error"

====== Interrupts ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

XC=BASIC allows you to set up interrupting rules and write routines that handle interrupts. The supported interrupt types are:

  * **Timer interrupts**, issued after every <N> processor cycles where <N> is a value between 1 and 65535 (supported on all targets)
  * **Raster interrupts**, issued when the screen raster line reached a certain position (supported on [c64] [c16] [cplus4] [c128] [x16] [m65])
  * **Vertical blank interrupts**, issued when the screen is fully rendered (supported on [x16]) 
  * **Sprite collision** interrupts, issued when two or more sprites collide ([c64] [c128] [x16] [m65])
  * **Sprite-background collision** interrupts, issued when one ore more sprites collide with the background ([c64] [c128] [m65])

<adm note>
Multiple types of interrupts can be enabled at the same time, allowing your program a great flexibility of responding to events. If an interrupt is "missed" (because another one is currently served), it will be fired immediately after the current service routine is finished.
</adm>

<adm warning>
Enabling multiple types of interrupts is not yet supported on the MEGA65.
</adm>

===== Defining interrupt service routines =====

In order to respond to an interrupt request, you must first define what routine to pass control to when an interrupt is fired. If you don't do this, your program will not know what to do when an interrupt request is issued, so it will go to a random memory address and break. A service routine is nothing but a labelled code point in your program, the same that can be referenced by [[GOTO]] or [[GOSUB]]. For example:

  irqserv:
    ' Do whatever needs to be done when an interrupt request is issued
    RETURN

Once you have a service routine, you can reference it within an ''ON <event> GOSUB'' statement:

  ON TIMER <cycles> GOSUB irqserv
  ON RASTER <line> GOSUB irqserv
  ON SPRITE GOSUB irqserv
  ON BACKGROUND GOSUB irqserv
  ON VBLANK GOSUB irqserv

===== Enabling and disabling interrupts =====

Once the service routines are defined and they're referenced in one or more ''ON <event> GOSUB'' statements, it is safe to enable interrupts:

  TIMER INTERRUPT ON
  RASTER INTERRUPT ON
  SPRITE INTERRUPT ON
  BACKGROUND INTERRUPT ON
  VBLANK INTERRUPT ON

If you no longer wish to fire interrupts, use the same commands with the ''OFF'' keywords:

  TIMER INTERRUPT OFF
  RASTER INTERRUPT OFF
  SPRITE INTERRUPT OFF
  BACKGROUND INTERRUPT OFF
  VBLANK INTERRUPT OFF

<adm warning>
Make sure you you don't enable interrupts before the service routine is referenced in the corresponding ''ON <event> GOSUB'' statement, otherwise your program may break at the first interrupt.
</adm>

===== Enabling or disabling system background tasks =====

By default, KERNAL runs some "background tasks" that are nothing but a timer interrupt service routine that typically does the following:

  * Flash the cursor
  * Query the keyboard (required by [[INPUT]] and [[GET]])
  * Query the joysticks and mouse ([x16])
  * Update the jiffy count (required by the [[TI]] function)

If your program doesn't require the above, you can turn of the system interrupt service using the following command:

  SYSTEM INTERRUPT OFF

As you guessed, to turn it back on, you can use

  SYSTEM INTERRUPT ON
===== Restrictions =====

Due to the nature of the runtime environment, there are some things that you must avoid in interrupt service routines:

  - You must not call subs or functions
  - You must not use floating point arithmetic
  - You must not use the [[THIS]] keyword
  - You must not enable or disable other interrupts (although changing their service routine using ''ON <event> GOSUB'' is allowed).

Note that the above rules only apply to the service routine, not the rest of the program.

===== You're driving: safe or fast? =====

Another factor to take into consideration is speed. XC=BASIC reserves a few zero page locations to use as virtual registers. In order to return to the main program flow in a clean state after a service routine is done, the runtime environment must push these virtual registers on the stack before the service routine is entered and pull them back when it finished. This roughly takes 2 times 170 CPU cycles.

You have two options:

  - You accept this penalty, or
  - If you're sure that your interrupt service routine doesn't mess up the virtual registers, you can declare ''OPTION FASTINTERRUPT'' at the top of your program, which will effectively bypass saving the virtual registers when the routine is entered.

<adm note>
Virtual registers reside on the zero page between addresses $02 and $0D, inclusive. You can use a machine language monitor to find out if these values were altered after an interrupt service routine was quit. If they weren't, you're good to go with ''OPTION FASTINTERRUPT''.
</adm>  

===== Examples =====

==== Timer interrupt example ====

The following example will display a counter on the top left corner of the screen while the rest of the program is running.

  DIM i AS DECIMAL
  i = 0000d
  DIM a$ AS STRING * 8
  
  ON TIMER 10000 GOSUB irqserv
  TIMER INTERRUPT ON
  
  INPUT "what is your name? "; a$
  END
  
  ' This routine will be executed once in every 10,000 cpu cycles
  irqserv:
    TEXTAT 0, 0, i
    i = i + 0001d
    RETURN

==== Raster interrupt example ====

  ' Turn off swapping of virtual registers
  ' as we don't use them in this example
  OPTION FASTINTERRUPT
   
  BACKGROUND 0
   
  ' This will set up the first interrupt
  GOSUB irqserv2
   
  SYSTEM INTERRUPT OFF
  ' Go!
  RASTER INTERRUPT ON
   
  ' Loop forever
  DO : LOOP WHILE 1
   
  irqserv1:
    BORDER 2
    ON RASTER 120 GOSUB irqserv2
    RETURN
   
  irqserv2:
    BORDER 1
    ON RASTER 100 GOSUB irqserv1
    RETURN

====== File I/O ======

[vic20] [c16] [cplus4] [c64] [c128] [m65]

File input-output in XC=BASIC was designed to be mostly compatible with CBM BASIC so that the same commands can be used for opening, reading from and writing to files. Since XC=BASIC is a strongly typed language, and therefore it comes with restrictions, there are some small differences to be aware of. Those differences are explained on each command's reference page.

In addition, new commands have been added for binary writing and reading that allow convenient storing and recalling of simple or complex data structures, without the headache of encoding and decoding textual data.

<adm warning>
File I/O commands are not implemented for the Commodore PET.
</adm>

The following guide focuses on the differences between CBM BASIC and XC=BASIC rather than explaining how to use the commands that are compatible. The Commodore-64 and 1541 User Guides explain almost everything you need to know about the "traditional" file I/O commands.

===== LOAD and SAVE =====

CBM BASIC's ''LOAD'' and ''SAVE'' commands can store and recall either BASIC programs or binary data to and from a peripheral device (e. g tape or disk drive). XC=BASIC is compiled to machine language and therefore it doesn't make much sense to support loading and saving BASIC programs. For this reason, [[LOAD]] and [[SAVE]] in XC=BASIC are used for loading and saving binary data only. To save a particular memory area to disk or tape, you must use the following command:

  SAVE <filename>, <device_no>, <start_address>, <end_address>
  
Let's say you want to store the memory contents at $8000-$83FF (that is, 1K of data) on disk, you can use the following command:

  SAVE "mydata", 8, $8000, $83FF

This will call the KERNAL function SAVE that will open the file and save the memory contents. The first two byte in the file will contain a pointer to the address $8000 so that ''LOAD'' will know where to recall data in memory if needed. These first two bytes are called the "load address".

<adm note>
You may use both decimal or hexadecimal numbers in XC=BASIC for specifying addresses and other numbers as well.
</adm>

When you wish to recall data from disk (or tape), you have two options: either you accept the load address in the file, or you specify a different address. To use the load address that is saved with the file, use the command:

  LOAD <filename>, <device_no>

Whereas to specify a different address:

  LOAD <filename>, <device_no>, <destination_address>
  
The latter form allows you to recall data to a different address in memory. For example:

  LOAD "mydata", 8, $C000

The above command will read data that was saved above to a different address, in this case $C000-$C3FF.

<adm warning>
If the destination address is specified in a ''LOAD'' statement, the first two bytes of the file will always be discarded, regardless of whether they were intended to serve as a load address or they're part of the actual data.
</adm>

===== READ and WRITE =====

The ''PRINT#'' and ''INPUT#'' commands in CBM BASIC work with PETSCII-encoded data. XC=BASIC also supports [[PRINT_hash]] and [[INPUT_hash]], and they behave almost exactly the same, which means that data saved in CBM BASIC should be readable in XC=BASIC and vice versa.

Apart from that, XC=BASIC supports reading and writing binary data. This means that any variable is written to a file will be written using the exact same binary representation as the variable's value is stored in memory. Binary output and input therefore allows you to save and restore data just as they are, without conversion.

The other advantage of binary I/O is that you can save and restore complex data structures (see [[udt]]) easily, in one go. Check out the following example:

  TYPE GAMESTATE
    playername$ AS STRING * 8
    score AS DECIMAL
    level AS BYTE
    monsterscount AS INT
  END TYPE
  
  DIM state AS GAMESTATE
  
  REM -- save the game!
  OPEN 2,8,2,"savegame,s,w"
  WRITE #2, state
  CLOSE 2
  
  REM -- load a saved game!
  OPEN 2,8,2,"savegame,s,r"
  READ #2, state
  CLOSE 2

This convenience comes with a cost: you must take extra care with the data types when using ''READ#'' and ''WRITE#''. Since only the data is saved to the file, not the data type, ''READ#'' can only rely on what type of variable you specified as its argument(s). If the data is not the same type as the variable, you'll face unwanted behavior, as in the following example:

  OPEN 2, 8, 2, "myfile,s,w" : REM open file for writing
  WRITE #2, 5, 6, 7 : REM write the numbers 5, 6 and 7 (3 bytes all together)
  CLOSE 2
  
  DIM a AS INT : REM note a, b and c are integers
  DIM b AS INT
  DIM c AS INT
  
  OPEN 2, 8, 2, "myfile,s,r" : REM open file for reading
  READ #2, a, b, c : REM this will try to read 6 bytes
  PRINT a, b, c
  CLOSE 2

In the example above we specify the literal numbers 5, 6 and 7 as output data. The compiler will conclude the data type by looking at the numbers and it will treat them as BYTE type [[datatypes#numeric_literals|as per these rules]]. The ''READ #2, a, b, c'' statement however will try to fetch 2 bytes per each variable, resulting in wrong values.

<adm warning>
Use the type conversion functions [[CBYTE]], [[CINT]], [[CWORD]], [[CLONG]] and [[CFLOAT]] to make sure that the correct data type is output.
</adm>
====== Keyboard scancodes ======

Use the following values as parameters passed to the [[KEY]] function to detect if a key is pressed on the keyboard.

| Key | C-64 / C-128 |
| :--- | :--- |
| * | 48898 |
| + | 57089 |
| , | 57216 |
| - | 57152 |
| . | 57104 |
| / | 49024 |
| : | 57120 |
| ; | 48900 |
| = | 48928 |
| @ | |
| A | 64772 |
| B | 63248 |
| C | 64272 |
| CBM | 32544 |
| CRSR DN | 65152 |
| CRSR LT | |
| CRSR RT | 65028 |
| CRSR UP | |
| CTRL | 32516 |
| D | 64260 |
| DEL | 65025 |
| E | 64832 |
| ESC | |
| F | 64288 |
| F1/F2 | 65040 |
| F1/F4 | |
| F2/F5 | |
| F3/6 | |
| F3/F4 | 65056 |
| F5/F6 | 65088 |
| F7/F8 | 65032 |
| 0 | 61192 |
| G | 63236 |
| H | 63264 |
| HELP/F7 | |
| HOME | 48904 |
| I | 61186 |
| J | 61188 |
| K | 61216 |
| L | 57092 |
| LSHIFT | 64896 |
| M | 61200 |
| N | 61312 |
| O | 61248 |
| P | 57090 |
| Q | 32576 |
| R | 64258 |
| RETURN | 65026 |
| RSHIFT | 48912 |
| S | 64800 |
| SHIFT | |
| SPACE | 32528 |
| STOP | 32640 |
| T | 64320 |
| U | 63296 |
| V | 63360 |
| W | 64770 |
| X | 64384 |
| Y | 63234 |
| Z | 64784 |
| £ | 48897 |
| ← | 32514 |
| ↑ | 48960 |
| 1 | 32513 |
| 2 | 32520 |
| 3 | 64769 |
| 4 | 64776 |
| 5 | 64257 |
| 6 | 64264 |
| 7 | 63233 |
| 8 | 63240 |
| 9 | 61185 |
Here is a detailed reference guide for XC=BASIC keywords and functions supported on the Commodore 64. All non-C64 references have been removed to provide a focused guide for C64 development.

---

### **@ (Address Of)**

The `@` symbol is a unary operator used to retrieve the memory address of a variable, array, or label.

*   **Syntax:** `@<variable_name>`
*   **Returns:** A `WORD` representing the 16-bit address.

**Use:**
This is primarily used when you need to pass the location of a variable to machine code routines (`SYS`), or when manipulating data using `PEEK`/`POKE` based on variable storage.

**Corner Cases:**
*   **Dynamic Variables:** If applied to a dynamic local variable (inside a non-static `SUB` or `FUNCTION`), the operator returns an address **relative to the current stack frame**, not an absolute memory address.
*   **Static Variables:** If applied to a `STATIC` variable (even inside a dynamic sub), it returns the absolute address.

**Example:**
```basic
DIM x AS INT
PRINT "x resides at address "; @x

' Retrieving array element addresses
DIM y(3) AS LONG
PRINT "array member addresses: "; @y(0), @y(1), @y(2)

' Retrieving a code label address to use with a jump table or manual pointer
mylab:
PRINT "this code piece starts at "; @mylab
```

---

### **ABS**

Returns the absolute (positive) value of a numeric expression.

*   **Syntax:** `ABS(<expression>)`
*   **Returns:** Same numeric type as the input (`BYTE`, `INT`, `WORD`, `LONG`, or `FLOAT`).

**Example:**
```basic
PRINT ABS(-1)    ' Prints 1
PRINT ABS(1)     ' Prints 1
DIM n AS INT
n = -5400
PRINT ABS(n)     ' Prints 5400
```

---

### **AND**

Performs a bitwise AND operation on two numbers.

*   **Syntax:** `<operand1> AND <operand2>`
*   **Returns:** Numeric result of the bitwise operation.

**Use:**
Often used for masking bits. For example, checking if specific bits in a hardware register are set.

**Corner Cases:**
*   Operands can be any numeric type **except** `FLOAT`.

**Example:**
```basic
PRINT 1 AND 0        ' Output: 0
PRINT 255 AND 15     ' Output: 15

' Check if bit 4 (value 16) is set in a joystick register
IF (JOY(1) AND 16) = 16 THEN PRINT "Fire button pressed"
```

---

### **ASC**

Returns the PETSCII numeric code of the first character of a string.

*   **Syntax:** `ASC(<string>)`
*   **Returns:** `BYTE`.

**Corner Cases:**
*   If the input string is empty (`""`), the function returns `0`.
*   Only considers the first character; subsequent characters are ignored.

**Example:**
```basic
PRINT ASC("a")   ' Output: 65
PRINT ASC("abc") ' Output: 65
PRINT ASC("")    ' Output: 0
```

---

### **ASM**

Injects inline 6502 assembly code directly into the output. The compiler passes this code verbatim to the *dasm* assembler.

*   **Syntax:**
    ```basic
    ASM
      <assembly code>
    END ASM
    ```

**Use:**
Used for timing-critical code (like raster bars) or accessing specific hardware features not exposed by BASIC.

**Details:**
*   **Formatting:** Lines must start with a label or at least one whitespace character (standard *dasm* syntax).
*   **Variable Access:** You can access static BASIC variables using `{variable_name}` syntax.
*   **Strings:** XC=BASIC strings are not zero-terminated (they have a length byte). To use strings in ASM (e.g., for KERNAL calls), you must manually create a zero-terminated array or handle the length byte.

**Warning:**
*   The compiler does not validate ASM code. Errors will be reported by *dasm*.
*   Only `STATIC` variables can be referenced via `{}`.

**Example:**
```basic
SUB SetBorderBlack () STATIC
  DIM temp AS BYTE
  temp = 0
  ASM
    lda {temp}
    sta $D020  ; Write 0 to Border Color register
  END ASM
END SUB
```

---

### **ATN**

Returns the arctangent of a number.

*   **Syntax:** `ATN(<float>)`
*   **Returns:** `FLOAT`.

**Corner Case:**
*   You must include the math library: `INCLUDE "trigono.bas"`.

**Example:**
```basic
INCLUDE "trigono.bas"
PRINT ATN(0.5) ' Outputs 0.464088
```

---

### **BACKGROUND**

Sets the screen background color using the standard C64 color palette (0-15).

*   **Syntax:** `BACKGROUND <color>`

**Details:**
*   Updates the VIC-II background color register ($D021).
*   Valid colors are 0 (Black) through 15 (Light Grey).

**Example:**
```basic
CONST BLACK = 0
CONST WHITE = 1
BORDER BLACK : BACKGROUND WHITE
```

---

### **BORDER**

Sets the screen border color using the standard C64 color palette (0-15).

*   **Syntax:** `BORDER <color>`

**Details:**
*   Updates the VIC-II border color register ($D020).
*   Valid colors are 0 (Black) through 15 (Light Grey).

**Example:**
```basic
BORDER 2     ' Red border
BORDER 14    ' Light Blue border
```

---

### **CHARAT**

Draws a character code directly to a specific coordinate on the screen memory. It does not update the cursor position.

*   **Syntax:** `CHARAT <x>, <y>, <screencode> [, <color>]`

**Details:**
*   **<x>, <y>:** Coordinates (0-based). 0-39 for X, 0-24 for Y.
*   **<color>:** Optional (0-15). If provided, it updates Color RAM at that position. If omitted, the color remains whatever was previously there.
*   **Unsafe:** No bounds checking is performed. Writing outside 0-39 or 0-24 will write to adjacent memory.

**Example:**
```basic
' Put 'A' (screen code 1) at column 20, row 10
CHARAT 20, 10, 1

' Put 'B' (screen code 2) at top-left, in Yellow (7)
CHARAT 0, 0, 2, 7
```

---

### **CHARSET**

Instructs the VIC-II chip where to look for character data (font).

*   **Syntax:** `CHARSET <value>`

**Calculation:**
The address is calculated as `<value> * $800` (2048 bytes), relative to the currently selected VIC bank (default Bank 0).

**Common Values (Bank 0):**
*   `CHARSET 2`: Standard ROM Upper case / Graphics ($1000 offset, points to ROM).
*   `CHARSET 3`: Standard ROM Lower case / Upper case ($1800 offset, points to ROM).
*   `CHARSET 4`: RAM at $2000.
*   `CHARSET 5`: RAM at $2800.

**Example:**
```basic
' Switch to Upper/Lower case mode
CHARSET 3 

' Switch to custom font loaded at $2000
CHARSET 4
```

---

### **CONST**

Defines a named value that exists only at compile-time. It is replaced by the literal value in the binary.

*   **Syntax:** `[SHARED] CONST <name> = <numeric_literal>`

**Use:**
Excellent for defining hardware registers, colors, or game constants to make code readable without using memory variables.

**Details:**
*   Does not consume RAM.
*   Use `SHARED` to make it visible across multiple source files (`INCLUDE`s).

**Example:**
```basic
CONST VIC_BORDER = $D020
CONST RED = 2
POKE VIC_BORDER, RED
```

---

### **DATA**

Defines a block of static data in the program.

*   **Syntax:** `DATA AS <type> <value> [, <value> ...]`

**Use:**
XC=BASIC does not use `READ`. Instead, you point a `DIM` array to the `DATA` label using the `@` syntax. This effectively initializes an array with static data.

**Details:**
*   **Strings:** Must define max length, e.g., `DATA AS STRING * 5`. Shorter strings are zero-padded; longer strings are truncated.
*   **Inlining:** By default, data is stored in a separate segment. Use `OPTION INLINEDATA` to place it in program flow (ensure you `GOTO` over it to prevent the CPU from executing data).

**Example:**
```basic
' Accessing data via array
DIM squares(3) AS INT @lab_squares
PRINT squares(3) ' Outputs 9

lab_squares:
DATA AS INT 0, 1, 4, 9
```

---

### **DEEK**

Reads a 16-bit word from memory (Little Endian: reads `addr` and `addr+1`).

*   **Syntax:** `DEEK(<address>)`
*   **Returns:** `WORD` (0-65535).

**Use:**
Useful for reading 16-bit pointers (like vector tables) or hardware registers that are paired.

**Example:**
```basic
' Reads the BASIC start of variables pointer ($2D-$2E)
PRINT DEEK($002D)
```

---

### **DIM**

Defines a variable or array.

*   **Syntax:**
    `DIM|STATIC [SHARED] [FAST] <name>[(dims)] AS <type> [@<address>]`

**Keywords:**
*   **STATIC:** Use this instead of `DIM` inside dynamic subs to retain value between calls.
*   **SHARED:** Makes variable visible to all modules.
*   **FAST:** Requests storage in the Zero Page (faster access). Ignored if ZP is full.
*   **@ <address>:** Maps the variable to a specific memory address or label. Useful for memory mapping hardware registers (e.g., VIC-II registers).

**Types:** `BYTE`, `INT` (signed 16-bit), `WORD` (unsigned 16-bit), `LONG` (signed 24-bit), `FLOAT` (32-bit), `DECIMAL` (BCD), `STRING * length`.

**Example:**
```basic
DIM x AS BYTE
DIM arr(10) AS INT
' Map a variable directly to the border color register
DIM border_reg AS BYTE @ $D020 
border_reg = 0 ' Sets border to black
```

---

### **DO ... LOOP**

Defines a loop that repeats indefinitely or based on a condition.

*   **Syntax (Pre-test):** `DO WHILE|UNTIL <cond> ... LOOP`
*   **Syntax (Post-test):** `DO ... LOOP WHILE|UNTIL <cond>`

**Details:**
*   **Post-test** guarantees the loop runs at least once.
*   Use `EXIT DO` to break.
*   Use `CONTINUE DO` to skip to the next iteration.

**Example:**
```basic
DIM i AS BYTE
DO
  i = i + 1
  PRINT i
LOOP UNTIL i = 10
```

---

### **DOKE**

Writes a 16-bit word to memory (Little Endian).

*   **Syntax:** `DOKE <address>, <value>`

**Use:**
Writes the low byte of `<value>` to `<address>` and the high byte to `<address>+1`. Useful for setting pointers.

**Example:**
```basic
' Set the top of BASIC memory pointer ($37-$38) to $4000
DOKE $0037, $4000
```

---

### **FILTER**

Sets SID sound filter properties.

*   **Syntax:** `FILTER [<sid_num>] <subcmd> ...`

**Subcommands:**
*   `CUTOFF <0-2047>`: Sets filter cutoff frequency.
*   `RESONANCE <0-15>`: Sets resonance.
*   `LOW PASS`, `BAND PASS`, `HIGH PASS`: Enables specific filter modes.

**Details:**
*   `<sid_num>` is optional (defaults to 1). Used for systems with dual SIDs.

**Example:**
```basic
' Set cutoff to approx mid-range, max resonance, low pass filter
FILTER CUTOFF 1000 RESONANCE 15 LOW PASS
```

---

### **FOR ... NEXT**

Standard counting loop.

*   **Syntax:**
    `FOR <var> [AS <type>] = <start> TO <end> [STEP <step>] ... NEXT`

**Corner Cases & Warnings:**
*   **Unsigned Countdown:** You cannot loop downwards (`STEP -1`) if the counter variable is unsigned (`BYTE` or `WORD`). It will wrap around (underflow) and loop infinitely. Use `INT` or a `DO` loop for countdowns.
*   **Static Counter:** Loop counters are always `STATIC`. You cannot use a dynamic local variable as a `FOR` counter.

**Example:**
```basic
FOR i AS INT = 10 TO 0 STEP -1
  PRINT i
NEXT
```

---

### **GET**

Reads a single character from the keyboard buffer.

*   **Syntax:** `GET <variable>`

**Behavior:**
*   If `<variable>` is Numeric: Returns the PETSCII code (0 if buffer empty).
*   If `<variable>` is String: Returns the character (Empty string if buffer empty).

**Example:**
```basic
DIM k AS BYTE
DO
  GET k
LOOP UNTIL k <> 0 ' Wait for any key press
```

---

### **HSCROLL**

Sets horizontal hardware scrolling (VIC-II register $D016).

*   **Syntax:** `HSCROLL <pixels>`

**Details:**
*   Accepts values 0-7.
*   Shifts the entire screen display by that many pixels.
*   Usually combined with `VMODE ... COLS 38` to hide the edges where scrolling artifacts appear.

**Example:**
```basic
HSCROLL 4 ' Shift screen by 4 pixels
```

---

### **IF**

Conditional Logic.

*   **Syntax (Single Line):** `IF <cond> THEN <stmt> [ELSE <stmt>]`
*   **Syntax (Block):**
    ```basic
    IF <cond> THEN
      <statements>
    ELSE
      <statements>
    END IF
    ```

**Details:**
*   Condition is True if it evaluates to any non-zero number.
*   Comparisons (e.g., `x > 5`) return 255 for True and 0 for False.

---

### **INPUT**

Reads a string from the user via keyboard.

*   **Syntax:** `INPUT ["prompt";] <string_var>`

**Example:**
```basic
DIM name$ AS STRING * 20
INPUT "What is your name? "; name$
```

---

### **INPUT#**

Reads comma-separated string data from a file (Disk/Tape).

*   **Syntax:** `INPUT #<file_no>, <var> [, <var>...]`

**Details:**
*   Recognizes comma `,` as a separator.
*   Respects quote `"` marks (commas inside quotes are treated as literal text).
*   Compatible with data written via `PRINT#`.

---

### **INTERRUPTS (ON ... GOSUB)**

Defines routines to handle hardware interrupts.

*   **Syntax:** `ON <event> GOSUB <label>`
*   **Events:** `TIMER` (CIA Timer), `RASTER` (VIC-II Raster Line), `SPRITE` (Sprite-Sprite collision), `BACKGROUND` (Sprite-Background collision).

**Usage:**
1.  Define the handler: `ON RASTER 100 GOSUB my_irq`.
2.  Enable specific interrupt: `RASTER INTERRUPT ON`.
3.  (Optional) Disable system defaults: `SYSTEM INTERRUPT OFF` (Stops cursor blink, keyboard scanning).

**Constraints in ISR (Interrupt Service Routine):**
*   No floating point math.
*   No `SUB`/`FUNCTION` calls.
*   No `THIS` keyword.
*   Use `OPTION FASTINTERRUPT` to skip saving virtual registers if you are sure your ISR is safe (optimization).

**Example:**
```basic
ON RASTER 100 GOSUB split_screen
RASTER INTERRUPT ON
DO : LOOP ' Infinite loop

split_screen:
  BORDER 2 ' Change border to red at line 100
  RETURN
```

---

### **JOY**

Returns the status of a joystick.

*   **Syntax:** `JOY(<port>)`
*   **Returns:** `BYTE` bitmask.

**Details:**
*   `<port>`: 1 or 2.
*   **Bitmask Values:**
    *   Bit 0 (1): Up
    *   Bit 1 (2): Down
    *   Bit 2 (4): Left
    *   Bit 3 (8): Right
    *   Bit 4 (16): Fire Button

**Example:**
```basic
' Check Port 2
DIM j AS BYTE
j = JOY(2)
IF (j AND 1) THEN PRINT "Up"
IF (j AND 16) THEN PRINT "Fire"
```

---

### **LOAD**

Loads a binary file into memory.

*   **Syntax:** `LOAD <filename>, <device> [, <address>]`

**Details:**
*   If `<address>` is omitted, it uses the 2-byte header from the file (standard C64 PRG format).
*   Use `ON ERROR GOTO` to trap load failures.

---

### **MEMCPY / MEMSHIFT / MEMSET**

High-speed memory operations.

*   **MEMSET:** `MEMSET <addr>, <length>, <byte_val>`
    *   Fills a block of memory with a specific byte value. Efficient for clearing screen/color RAM.
*   **MEMCPY:** `MEMCPY <src>, <dst>, <length>`
    *   Copies memory. Safe if non-overlapping or if destination is *lower* than source (copying down).
*   **MEMSHIFT:** `MEMSHIFT <src>, <dst>, <length>`
    *   Copies memory. Safe if destination is *higher* than source (copying up).

---

### **OPEN**

Opens a logical file channel.

*   **Syntax:** `OPEN <logical_no>, <device>, <sec_addr>, <filename>`

**Example:**
```basic
OPEN 2, 8, 2, "mydata,s,w" ' Open sequential file for write on disk 8
```

---

### **OPTION**

Sets compiler options. Must be placed at the top of the code.

*   **Syntax:** `OPTION <name> [= <value>]`

**Common Options:**
*   `TARGET = "c64"` (Recommended to ensure C64 memory layout).
*   `NOBASICLOADER`: Creates a bare binary without the BASIC startup stub (`10 SYS...`). Useful for cartridges.
*   `STARTADDRESS = $xxxx`: Sets code origin.
*   `INLINEDATA`: Allows `DATA` statements to be compiled in program flow rather than a separate segment.
*   `FASTINTERRUPT`: Optimizes ISR overhead (unsafe if ISR uses virtual registers).

---

### **PRINT#**

Writes text data to a file.

*   **Syntax:** `PRINT #<file_no>, <expr> [, or ;] ...`

**Details:**
*   Works exactly like `PRINT` but directs output to a file channel.
*   Use `,` for tabs, `;` to concatenate.
*   Compatible with `INPUT#`.

---

### **READ# / WRITE#**

Binary file I/O.

*   **WRITE#:** `WRITE #<file_no>, <expr> ...`
    *   Writes raw binary representation of variables. No separators.
*   **READ#:** `READ #<file_no>, <var> ...`
    *   Reads raw binary data back into variables.

**Corner Case:**
*   You must read back the exact same types in the exact same order they were written, or data will be garbage.

**Example:**
```basic
DIM x AS INT, y AS INT
x = 1000 : y = 2000
OPEN 1, 8, 2, "bindata,s,w"
WRITE #1, x, y
CLOSE 1
```

---

### **RND / RNDB / RNDI / RNDW / RNDL**

Generates pseudo-random numbers.

*   `RND()`: Returns `FLOAT` (0.0 to 1.0).
*   `RNDB()`: Returns `BYTE` (0 to 255).
*   `RNDI()`: Returns `INT` (-32768 to 32767).
*   `RNDW()`: Returns `WORD` (0 to 65535).
*   `RNDL()`: Returns `LONG`.

**Note:** Use `RANDOMIZE <seed>` to initialize the sequence (e.g., `RANDOMIZE TI()`).

---

### **SCAN**

Returns the current raster line being drawn by the VIC-II.

*   **Syntax:** `SCAN()`
*   **Returns:** `WORD` (0 to 311 for PAL, 0 to 262 for NTSC).

**Use:**
Essential for timing visual effects to avoid tearing, or for light-pen logic.

**Example:**
```basic
' Wait for raster line 250 (bottom of screen)
DO : LOOP UNTIL SCAN() >= 250
```

---

### **SCREEN**

Switches the logical screen memory location (Video Matrix Base).

*   **Syntax:** `SCREEN <0-15>`

**Details:**
*   Sets video matrix to `<value> * $400` relative to the current VIC bank.
*   **Performance Warning:** This command is slow because it updates KERNAL tables (like where `PRINT` puts text). For fast double-buffering in games (flipping between two screens), use direct `POKE`s to VIC registers instead ($D018).

---

### **SELECT CASE**

Multi-branch conditional structure.

*   **Syntax:**
    ```basic
    SELECT CASE <expr>
      CASE <val1>, <val2>
        <stmts>
      CASE <start> TO <end>
        <stmts>
      CASE IS <operator> <val>
        <stmts>
      CASE ELSE
        <stmts>
    END SELECT
    ```

**Example:**
```basic
SELECT CASE score
  CASE 0 TO 99: PRINT "Beginner"
  CASE 100 TO 999: PRINT "Intermediate"
  CASE IS >= 1000: PRINT "Expert"
END SELECT
```

---

### **SHL / SHR**

Bitwise Shift Left and Right.

*   **Syntax:** `SHL(<val>, <bits>)`, `SHR(<val>, <bits>)`

**Details:**
*   Equivalent to multiplying (`SHL`) or dividing (`SHR`) by powers of 2.
*   **SHR** performs a *signed* shift if the type is `INT` or `LONG` (preserves the sign bit), and logical shift for `BYTE`/`WORD`.

---

### **SPRITE**

Configures VIC-II sprite properties.

*   **Syntax:** `SPRITE <id> <subcmd> ...`

**Details:**
*   `<id>`: Sprite number 0-7.

**Subcommands:**
*   `ON`, `OFF`: Enable/Disable.
*   `AT <x>, <y>`: Sets position. X range 0-511, Y range 0-255.
*   `COLOR <val>`: Sets sprite color (0-15).
*   `SHAPE <pointer>`: Sets the data source.
    *   **Calculation:** The pointer value is `(Address - VIC_Bank_Address) / 64`. E.g., if Bank 0 starts at $0000 and sprite data is at $2000, shape is 128.
*   `HIRES`: Sets standard high-resolution mode (2 colors).
*   `MULTI`: Sets multicolor mode (4 colors).
*   `ON BACKGROUND`: Priority low (behind text/background).
*   `UNDER BACKGROUND`: Priority high (in front of text/background).

**Example:**
```basic
' Enable Sprite 0, set pointer 128 ($2000), move to 100,50, set Red
SPRITE 0 ON SHAPE 128 AT 100, 50 COLOR 2
```

---

### **SYS**

Calls a machine language subroutine.

*   **Syntax:** `SYS <address> [FAST]`

**Details:**
*   **Standard:** Loads CPU registers (A, X, Y, Status) from memory locations `$030C`-$030F` before jumping. Saves them back to those addresses on return.
*   **FAST:** Jumps directly to address without setting up registers. Much faster; use this if the routine doesn't need specific register inputs.

---

### **TEXTAT**

Writes a string directly to screen memory at specific coordinates.

*   **Syntax:** `TEXTAT <x>, <y>, <text> [, <color>]`

**Difference from PRINT:**
*   Does not move the cursor.
*   Writes raw screen codes (0-255), not PETSCII. E.g., 'A' is 1, not 65.
*   Control characters (like `{CLR}`) are printed as glyphs, not executed.
*   No bounds checking (unsafe).

**Example:**
```basic
' Write "hello" at col 0, row 0 in White (1)
TEXTAT 0, 0, "hello", 1
```

---

### **TYPE**

Defines a User Defined Type (Struct/Class).

*   **Syntax:**
    ```basic
    TYPE <name>
      <field> AS <type>
      SUB <method> ...
    END TYPE
    ```

**Usage:**
*   Fields are accessed via dot notation: `myvar.field`.
*   Methods (SUBs inside types) can access the instance using `THIS`.

**Example:**
```basic
TYPE Enemy
  x AS INT
  y AS INT
  hp AS BYTE
END TYPE

DIM e AS Enemy
e.x = 100 : e.hp = 50
```

---

### **VMODE**

Sets the VIC-II video mode.

*   **Syntax:**
    `VMODE [TEXT|BITMAP|EXT] [HIRES|MULTI] [ROWS 24|25] [COLS 38|40]`

**Options:**
*   `TEXT`: Standard character mode.
*   `BITMAP`: 320x200 graphics mode.
*   `EXT`: Extended background color mode (ECM).
*   `HIRES`: Standard 2-color mode.
*   `MULTI`: Multicolor 4-color mode.
*   `ROWS 24`: Opens top/bottom borders (RSEL=0).
*   `COLS 38`: Opens side borders (CSEL=0).

**Example:**
```basic
' Switch to Multicolor Bitmap mode
VMODE BITMAP MULTI
```

---

### **VOICE**

Abstracted command to control the SID sound chip.

*   **Syntax:** `VOICE <id> <cmd> ...`

**Details:**
*   `<id>`: Voice 1, 2, or 3.

**Subcommands:**
*   `ON`, `OFF`: Gates the voice (starts/stops Attack/Release cycle).
*   `WAVE <SAW|TRI|PULSE|NOISE>`: Sets the waveform.
*   `TONE <freq>`: Sets frequency (0-65535).
*   `PULSE <width>`: Sets pulse width (0-4095) for PULSE wave.
*   `ADSR <a,d,s,r>`: Sets envelope (Attack, Decay, Sustain, Release) 0-15.
*   `FILTER ON|OFF`: Routes this voice through the filter.

**Example:**
```basic
' Setup SID Voice 1 as a sawtooth bass
VOICE 1 WAVE SAW TONE 4000 ADSR 0,9,5,0 ON
```

---

### **WAIT**

Pauses execution until a memory location changes.

*   **Syntax:** `WAIT <address>, <mask> [, <xor_val>]`

**Logic:**
1.  Read byte at `<address>`.
2.  XOR with `<xor_val>` (default 0).
3.  AND with `<mask>`.
4.  If result is 0, repeat. If result != 0, continue.

**Example:**
```basic
' Wait until the raster line (lowest bit of $D012) is high
WAIT $D012, 128
```

====== XC=BASIC 3.0 programming reference END ======