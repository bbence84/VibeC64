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
====== @ (address of) ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

''@'' (address of) is a unary operator that resolves the memory address of a variable or label. The address is returned as a [[WORD]].

===== Examples =====

  DIM x AS INT
  PRINT "x resides at address "; @x
  
  DIM y(3) AS LONG
  PRINT "array member addresses: "; @y(0), @y(1), @y(2)
  
  mylab:
  PRINT "this code piece starts at "; @mylab

<adm note>
If applied to a dynamic local variable, the ''@'' operator will return an address //relative to the current stack frame//.
</adm>

  SUB routine () ' Note this sub is not STATIC
    DIM a AS INT
    DIM b AS INT
    STATIC c AS INT
    PRINT @b ' Will output 2
    PRINT @c ' Will output an absolute address
  END SUB
  
  CALL routine()


====== AND ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''AND'' operator performs a bitwise AND operation.

===== Syntax =====

  <operand> AND <operand>

Both operands can be any type of numeric expression, except FLOAT.

==== Examples ====

  PRINT 1 AND 0 : REM outputs 0
  IF x >= 0 AND x <= 10 THEN PRINT "x is between 0 and 10"
===== See also =====

  * [[OR]]
  * [[XOR]]

====== AS ======

The ''AS'' keyword is generally used to define the type of a variable or parameter. It may appear as part of the below commands:

  * [[DATA]]
  * [[DIM]]
  * [[FOR]]
  * [[FUNCTION]]
  * [[SUB]]
======ASM======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
=====Syntax=====
  ASM 
    <assembly code>
    <assembly code>
  END ASM

The ''ASM'' directive injects bare 6502 assembly code into the compiled **XC=BASIC** code without any modification. As **XC=BASIC** itself produces [[http://dasm-dillon.sourceforge.net/|dasm]] code, the injected assembly code must also be in dasm format and syntax.

===== Example =====
  REM -- set border to black using XC=BASIC code
  POKE $d020, 0
  REM -- set background to black using inline assembly
  ASM
   lda #$00
   sta $d021
  END ASM
  REM -- the XC=BASIC program continues on from here
  PRINT "done"
  END

The above example illustrates how to use ''ASM'' to inject inline assembly code into the **XC=BASIC** program. The compiler will send the code between the ''ASM ... END ASM'' commands straight to dasm for assembly immediately following the POKE command. Newlines are used in this example to improve the readability of 6502 assembly code that spans beyond one line. Note there are no quotation marks or other encapsulations around the assembly code as was previously required in **XC=BASIC** v2.

Note the spaces before the opcodes on each line of dasm assembly code. Leading spaces are required by dasm for any line of assembly that is not a valid label in dasm.

<adm warning>
Each line in dasm assembly code must start with a label or at least one space.
</adm>

<adm note>The **XC=BASIC** compiler cannot validate the in-line assembly code. It will be copied verbatim into the XC=BASIC assembly before being compiled by dasm, so you must take special care with the ''ASM'' directive. Dasm will report any errors. Please consult the dasm docs carefully for syntax and formatting.
</adm>



===== Referencing BASIC Non-String Variables in Assembly Code =====

To use BASIC non-string variables in assembly code, use the syntax ''{variable_name}''. For example:

  a = 2 : REM global variable
  b = 7
  SUB test () STATIC
    DIM a AS BYTE : REM local variable
    a = 5
    ASM
      lda #$06
      sta {a} ; {a} is resolved to the local "a"
      sta {b}
    END ASM
    PRINT a
  END SUB
  
  CALL test ()
  PRINT a
  PRINT b

<adm warning>
Only STATIC variables can be referenced using the curly braces syntax.
</adm>

===== Referencing Strings in Assembly Code =====
Passing an **XC=BASIC** string by reference will not always produce expected results, because **XC=BASIC** strings in memory are preceded by a single byte string length and are not zero-terminated. Therefore, strings for operations like KERNAL calls (SETNAM, for example) must be be converted first. There are a couple of techniques you can use to accomplish this:
  * Place the string into unused memory and terminate it with a zero byte, then reference that location in the assembly code
  * Create a byte array with stringlen + 1 elements, convert the string to a KERNAL-friendly format, then pass the array by reference in the assembly code

An example of the byte array technique:

  ' create a byte array, fill it with the string "file," and zero-terminate it
  DIM fname(5) AS BYTE
  fname(0) = ASC("f")
  fname(1) = ASC("i")
  fname(2) = ASC("l")
  fname(3) = ASC("e")
  fname(4) = 0
  
  ' set KERNAL SETNAM routine to point to fname
  ASM
    lda #$01
    ldx #<{fname}    ; set lo byte to fname lo
    ldy #>{fname}    ; set hi byte to fname hi 
    jsr $ffbd    ; SETNAM Kernal routine
  END ASM

Or, if you have a longer string that you want to pass, consider iterating over the string with ''MID$'' (see the following example) to simplify the conversion of a string into a byte array. Note that **XC=BASIC** will reset the string variable's length to the actual length of the assigned string every time a string is assigned to that variable, so you don't need to worry about calculating the length using some other trick if you've assigned a string shorter than the full dimension of the variable. ''LEN(string)'' will work:

  DIM a(22) AS BYTE
  DIM x AS BYTE
  DIM b AS STRING * 20
  b = "the quick brown fox"
  
  ' will result in a byte array of "the quick brown fox"
  ' and a zero byte in the next array element, ready
  ' for use by a KERNAL call
  FOR x = 0 to LEN(b)
      a(x) = ASC(MID$(b, x, 1))
  NEXT
  a(len(b) + 1) = 0
  
====== BACKGROUND ======

[vic20] [c64] [c16] [cplus4] [c128] [m65]

Sets the background color.

===== Syntax =====

  BACKGROUND <color>
  BACKGROUND <color>, <luminance>

  * ''<color>'' is the color code. The accepted values are:
    * 0 - 7 for [vic20]
    * 0 - 15 for [c64] [c16] [cplus4] [c128]
    * 0 - 31 for [m65]
  * On the Commodore 16 and Plus/4, both ''<color>'' and ''<luminance>'' values must be provided

===== Examples =====

  CONST BLACK = 0
  CONST WHITE = 1
  BORDER BLACK : BACKGROUND WHITE

===== See also =====

  * [[BORDER]]

====== BORDER ======

[v3.1] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

Sets the border color.

===== Syntax =====

  BORDER <color>
  BORDER <color>, <luminance>

  * ''<color>'' is the color code. The accepted values are:
    * 0 - 7 for [vic20]
    * 0 - 15 for [c64] [c16] [cplus4] [c128]
    * 0 - 31 for [m65]
  * On the [c16] and [cplus4], both ''<color>'' and ''<luminance>'' values must be provided

===== Examples =====

  CONST BLACK = 0
  CONST WHITE = 1
  BORDER BLACK : BACKGROUND WHITE

===== See also =====

  * [[BACKGROUND]]

====== BYTE ======

The ''BYTE'' keyword can be used in several statements to designate a variable or value as an 8-bit unsigned binary number. See [[v3:datatypes|]] and [[v3:dim|]] for more information.
====== CALL ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''CALL'' command executes a [[v3:subroutines|subroutine]].

===== Syntax =====

  CALL <subroutine_name> ([<param> [, <param>, ...]])

The called subroutine must be defined or forward declared before it can be called. See the [[v3:subroutines]] page for more information.

===== Example =====

  CONST LT_BLUE = 14
  
  REM ** Clears the screen and sets color **
  SUB cls (color AS BYTE) STATIC
    MEMSET $0400, 1000, 32
    MEMSET $d800, 1000, color
  END SUB
  
  REM ** Call the routine **
  CALL cls (LT_BLUE)
  PRINT "screen cleared"

===== See also =====

  * [[v3:subroutines|]]


======CHARAT======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''CHARAT'' command outputs a single character at the given X and Y position of the currently selected screen without affecting the cursor position.

=====Syntax=====

  CHARAT <x_pos>, <y_pos>, <screencode> [, <color>]

  * ''<x_pos>'' must be between 0 and the screen width minus one
  * ''<y_pos>'' must be between 0 and the screen height minus one
  * ''<screencode>'' must be between 0 and 255
  * ''<color>'' is optional. If provided, it must be between 0 and 15 (between 0 and 255 on the [c16], [cplus4], [x16] and [m65]). If not provided, the character color will be whatever value happens to be in its Color RAM location.

<adm note>
Color values between 8 and 15 will set the character to multi-color mode on the [vic20].
</adm>

<adm note>
The lower nybble of the color value will set text color, while the upper nybble will set background color on the [x16].
</adm>

<adm note>
Setting the ''<color>'' parameter has no effect on the [pet].
</adm>

<adm warning>
The runtime library will not check if the X and Y values are within the screen boundaries. Providing wrong values will lead to writing to memory locations outside the screen memory, thus potentially damaging the program or data. Use it with care.
</adm>
=====Examples=====

  REM put an 'A' character near the center of the screen
  CHARAT 20, 10, 1
  REM put a 'B' character in the top left corner of the screen, in yellow
  CHARAT 0, 0, 2, 7


=====See Also=====

  * [[v3:SCREEN]]
  * [[v3:TEXTAT]]
====== CHARSET ======

[v3.1] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''CHARSET'' command tells the display chip where to look for the character set. 

 ===== Syntax =====

  CHARSET [RAM|ROM] <value>

Changing the character set is slightly different on each platform.

====== Commodore 64 and 128 ======

The command tells the VIC-II chip to look for the character set at ''<value> * $800'', relative to selected the VIC bank (that is, 0 by default). The ''RAM'' or ''ROM'' parameter is ignored. The VIC-II chip will always see the ROM when <value> is set to 2 or 3. The following example list all possible setups in Bank 0.

  CHARSET 0 ' chars at $0000
  CHARSET 1 ' chars at $0800
  CHARSET 2 ' uppercase/graphic chars in ROM
  CHARSET 3 ' lowercase/uppercase chars in ROM
  CHARSET 4 ' chars at $2000
  CHARSET 5 ' chars at $2800
  CHARSET 6 ' chars at $3000
  CHARSET 7 ' chars at $3800

====== Commodore VIC-20 ======

The address is calculated as ''<value> * $0400''. The VIC chip can either see ROM or RAM. It can't see the expansion RAM, therefore some settings make no sense. You basically have the following (more or less useful) options:

  CHARSET ROM 0 ' uppercase with full graphic chars
  CHARSET ROM 1 ' reversed uppercase and graphic chars
  CHARSET ROM 2 ' lowercase/uppercase chars with some graphics
  CHARSET ROM 3 ' reversed lowercase/uppercase chars with some graphics
  CHARSET RAM 0 ' chars in RAM at $0000
  CHARSET RAM 4 ' chars in RAM at $1000
  CHARSET RAM 5 ' chars in RAM at $1400
  CHARSET RAM 6 ' chars in RAM at $1800
  CHARSET RAM 7 ' chars in RAM at $1C00

====== Commodore 16 and Plus/4 ======

The address is calculated as ''<value> * $0400''. The TED chip can basically see all RAM and ROM, so you have 128 possible settings here as <value> can range from 0 to 63 and both ''RAM'' and ''ROM'' settings work. 

====== Commander X16 ======

The [x16] supports the following modes:

  ' Uploads the character set found 
  ' at $2000 from RAM to VRAM and uses it
  CHARSET RAM $2000
  ' Sets ISO charset
  CHARSET ROM 1
  ' Sets PET upper/graph charset
  CHARSET ROM 2
  ' Sets PET lower/upper charset
  CHARSET ROM 3

====== MEGA65 ======

On the [m65], the location of the character generator data can also be set with byte-level precision. The ''CHARAT'' command accepts a LONG integer as its parameter which allows the placement of character data anywhere in the first 16MB of RAM. The ''RAM'' or ''ROM'' parameter is ignored. 

  ' Relocates character set to $040000
  CHARSET $40000


====== CONST ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The const directive defines a constant. Constants are named values that exist in compile-time only and are replaced with their numeric value in runtime.

===== Syntax =====

  [SHARED] CONST <name> = <value>
  
The <value> must be a numeric literal.

Constants themselves do not have a type. The [[v3:datatypes#numeric_literals|type of the numeric literal]] will be used when a constant is used in an expression.

Constants have the same [[v3:variables#variable_scope|visibility options]] as variables.

===== Examples =====

  REM -- Constants can be used to improve the readability of your code
  CONST BORDER = $d020
  CONST BLACK = 0
  POKE BORDER, BLACK

====== CONTINUE ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''CONTINUE'' keyword is used for skipping the rest of a ''FOR ... NEXT'' or ''DO ... LOOP'' block and go to the next iteration.

===== Syntax =====

  CONTINUE [FOR|DO]
  
When used without the ''FOR'' or ''DO'' keyword, ''CONTINUE'' will be applied to the closest open block.

===== Examples =====

  REM -- Print numbers from 1 to 10 except 5
  FOR i AS BYTE = 1 TO 10
    IF i = 5 THEN CONTINUE FOR
    PRINT i
  NEXT i
  

====== DATA ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''DATA'' directive marks an area where numeric or string literal values are stored.

===== Syntax =====

  DATA AS <type> <value> [, <value> ...]

The ''DATA'' statement in XC=BASIC is different from the one in CBM BASIC. In XC=BASIC, there's no ''READ'' command to copy data into variables but ''DATA'' is typically used together with ''DIM'' to statically initialize a variable with values, like in the following example:

  DIM squares(7) AS INT @lab_squares
  PRINT squares(3) : REM -- outputs 9
  lab_squares:
  DATA AS INT 0, 1, 4, 9, 16, 25, 36

The ''DIM'' statement in the first line defines the variable //squares// as an array of seven integers and tells the compiler that the address of the array is where the //lab_squares// label is. Therefore the array is already filled with the values after the ''DATA'' statement without the need of copying using ''READ''.

===== Storing strings =====

When using DATA with strings, you have to denote the maximum string length. This doesn't mean that all strings must be of this length, it only gives a hint to the compiler how to align data in code. If a string is shorter than the denoted length, remaining memory will be padded with zero bytes. If a string is longer, it will be truncated to the maximum length. For example:

  DIM x$(4) AS STRING * 5 @mydat
  FOR i AS BYTE = 0 TO 3 : PRINT x$(i) : NEXT
  mydat:
  DATA AS STRING * 5 "hello", "thisistoolong", "abc", "world"

The above DATA area will be laid out in memory like this:

  ' First byte is string length
  05 48 45 4C 4C 4F ' "hello"
  05 54 48 49 53 49 ' truncated to "thisi"
  03 41 42 43 00 00 ' "abc" + padding using 00 bytes
  05 57 4F 52 4C 44 ' "world"

===== Inline data injection =====

By default, data are separated from code in XC=BASIC. This means that anything defined in DATA statements will be placed in a separate segment that is located after the code segment, outside of the program flow. This means that you can place a DATA statement anywhere, it won't affect the generated program code. The following example is identical to the one above.

  lab_squares:
  DATA AS INT 0, 1, 4, 9, 16, 25, 36
  DIM squares(7) AS INT @lab_squares
  PRINT squares(3) : REM -- outputs 9

There are situations, however, when you don't want to separate data from code and you need full control over where data is compiled (e. g using the [[v3:origin|]] directive). This is where the  [[OPTION]] INLINEDATA (or, alternatively, the command line option //--inline-data//) comes in handy. Setting it to TRUE will make DATA statements compiled right where they're in the program flow. For example:

  OPTION INLINEDATA
  GOTO main
  lab_squares:
  DATA AS INT 0, 1, 4, 9, 16, 25, 36
  main:
  DIM squares(7) AS INT @lab_squares
  PRINT squares(3) : REM -- outputs 9

If the above example is compiled, data will precede the main program.

<adm warning>
When data is compiled inline, you have to make sure that DATA statements never get executed as part of the program flow. Note the GOTO command above that skips DATA. If data gets executed by mistake, the program will (most likely) crash.
</adm>


====== DECIMAL ======

The ''DECIMAL'' keyword can be used in several statements to designate a variable or value as a 4-digit binary-coded decimal (BCD) number. See [[v3:datatypes|]] and [[v3:dim|]] for more information.
====== DECLARE ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The declare keyword forward-declares a subroutine or function.

===== Syntax =====

  DECLARE SUB <name> ([arg1 AS <type> [, arg2 AS <type>, ... ]]) [OVERRIDE] [STATIC] [SHARED]
  DECLARE FUNCTION <name> AS <type> ([arg1 AS <type> [, arg2 AS <type>, ... ]]) [OVERRIDE] [STATIC] [SHARED]

Read more about forward declaration [[subroutines#forward_declaration|here]].

===== See also =====

  * [[FUNCTION]]
  * [[SUB]]

======DIM======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

''DIM'' is used for defining variables and arrays.
=====Syntax=====

  DIM|STATIC [SHARED] [FAST] _
  <variable name>[(<array dimensions>)] AS <type> [@<address>] _
  [, <variable name>[(<array dimensions>)] AS <type> [@<address>] ... ] _
  [SHARED] [FAST] 

''DIM'' is used to explicitly define variables and assign them a type. Since XC=BASIC is a statically typed programming language, all variables must be defined before they can be used. While some variables can be auto-defined by the compiler without the use of the ''DIM'' statement (known as "implicit definition"), the use of ''DIM'' ensures the variable is defined as the intended type.

  * The keyword is either ''DIM'' or ''STATIC''. The latter is used for defining a static variable in dynamic subroutines and functions. [[subroutines#static_vs_dynamic|Read more here]]
  * Array dimensions are specified in parenthesis. The maximum number of dimensions is 3 and the maximum length of one dimension is 32768.
  * The ''AS'' keyword is mandatory and the variable type must be defined. The type can be a numeric, string or user-defined type as well. If the variable is defined as string, the string length must be also given, for example ''DIM mystr$ AS STRING * 16''
  * ''SHARED'' can be used to set the variable's visibility to shared, that means the variable is visible from within all code modules.
  * The ''FAST'' keyword instructs the compiler to reserve space for the variable on the zero page, if available. If no more zero page space is available, the keyword will be ignored with a warning.
  * If the ''@<address>'' is provided, the compiler will place the variable at the given address in memory. It can be either be:
    * a numeric literal between 0 and $FFFF (65535).
    * a constant
    * a label



===== Examples =====
  ' define single variables
  DIM enemy_count AS INT
  DIM score AS DECIMAL
  DIM gravity AS FLOAT
  DIM name$ AS STRING * 16
  
  ' define multiple variables in a single statement,
  ' all in the shared scope
  DIM SHARED a AS INT, b AS WORD, c AS FLOAT
  
  ' dimension an array of 24 INT variables
  DIM rockets(24) AS INT
  
  ' define a variable with explicit address
  DIM my_var AS INT @ $C000
  

=====Additional Details=====

<adm note>
Refer to the [[v3:Variables]] page for more information on defining variables. Refer to the [[v3:datatypes]] page for more information on variable types and their use.
</adm>
=====See Also=====
  * [[v3:INT]]
  * [[v3:BYTE]]
  * [[v3:WORD]]
  * [[v3:LONG]]
  * [[v3:FLOAT]]
  * [[v3:DECIMAL]]
  * [[v3:STRING]]
  * [[v3:Variables]]
  * [[v3:datatypes]]
====== DO ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''DO ... LOOP'' block defines a pre-test or post-test loop.

===== Pre-test syntax =====

  DO WHILE|UNTIL <condition>
    <statements>
  LOOP

===== Post-test syntax =====

  DO
    <statements>
  LOOP WHILE|UNTIL <condition>

The former is used to test the condition before entering the loop body and the latter is used to test the condition after each iteration. This effectively means that post-test loop will be executed at least once, whereas in a pre-test loop the condition may fail the very first time and therefore it may happen that the statements in the loop will not be executed at all.

In both forms, you can either use the ''WHILE'' or ''UNTIL'' keywords. ''WHILE'' means that the loop is entered if the condition evaluates to true, ''UNTIL'' means that the loop is exited if the condition evaluates to true.

You can use the ''EXIT DO'' command to prematurely exit a ''DO … LOOP'' block, or ''CONTINUE DO'' to skip rest of the block and go to the next iteration.
====== DOKE ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

===== Syntax =====

  DOKE <address>, <value>

The ''DOKE'' command stores a 16-bit value (WORD or INT) in two consecutive bytes at the given memory address.

===== Examples =====

  DOKE $C000, 1986 ' Will store the value to $C000-$C001
  PRINT DEEK($C000)
 
===== See also =====

  * [[v3:deek]]

====== ELSE ======

''ELSE'' marks the fail branch of an ''IF'' block. See [[IF]].

======END======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
=====Syntax=====

  END
  END ASM
  END FUNCTION
  END IF
  END SUB
  END TYPE

The ''END'' command terminates the execution of the program immediately. It can be used within the normal program flow and/or (optionally) at the very end of the program.

The ''END'' keyword may also be used to mark the end of an [[ASM]], [[FUNCTION]], [[IF]], [[SUB]] or [[TYPE]] block. See the linked pages for details.
===== Examples =====
  ' print a common phrase and then terminate the program
  PRINT "Hello, world!"
  END
  
  ' terminate a program if a specific condition has been met
  ' and continue on if not
  DIM a AS TYPE BYTE
  LET a = 5
  PRINT "I just stopped in to see what condition my condition..."
  IF a = 5 THEN
      PRINT "...was in."
      END
  ELSE
      PRINT "...wasn't in."
  END IF
  PRINT "If you can read this, I wasn't in the correct condition."
  END
  
In the first example above, the ''END'' statement terminates the program after the ''PRINT'' statement.

<adm note>
The ''END'' statement is optional if positioned at the end of the program's running code and logic flow.
</adm>

In the second example, because the condition specified in the ''IF'' statement is ''TRUE'' at runtime, the program terminates immediately following ''PRINT "...was in."'' and no additional code is executed.

=====See Also=====
  * [[v3:GOSUB]]
  * [[v3:GOTO]]
====== ERROR ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''ERROR'' command triggers a runtime error. Errors can be trapped using the ''ON ERROR GOTO'' statement.

===== Syntax =====

  ERROR <error_code>

Where <error_code> is a number between 0 and 255.

===== See also =====

  * [[v3:error_handling|]]





====== EXIT ======

The ''EXIT'' keyword has multiple usages:

  * ''EXIT DO'' exits a [[DO]] loop
  * ''EXIT FOR'' exits a [[FOR]] loop
  * ''EXIT FUNCTION'' exits a [[FUNCTION]]
  * ''EXIT SUB'' exits a [[SUB]]

====== FAST ======

The ''FAST'' keyword can be used:

  * In a [[DIM]] statement to instruct the compiler to assign a zeropage address to the variable
  * In a [[SYS]] statement in order to skip fetching registers before and after the system call
====== FILTER ======

[c64] [c128] [m65]

Selects various sound filter properties.

===== Syntax =====

  FILTER [<sid_number>] <subcmd> [<subcmd> ...]

  * ''<sid_number>'' is optional and defines on which SID chip the filter values should be set. If it isn't provided, it defaults to 1. This parameter is useful on multi-SID systems, for example a [c64] equipped with two SID chips, or the [m65] that has four SID chips. The number must be between 1 and 4.
  * ''<subcmd>'' is one of:
    * ''CUTOFF <cutoff_freq>'' - Filter cutoff frequency, a value between 0-2047
    * ''RESONANCE <value>'' - Filter resonance setting, a value between 0-15 
    * ''LOW|BAND|HIGH PASS''

<adm note>
Refer to the [[http://archive.6502.org/datasheets/mos_6581_sid.pdf|SID Data Sheet]] for explanation of all filter settings.
</adm>
===== Example =====

  FILTER CUTOFF 900 RESONANCE 7 LOW PASS

The filter can be applied to a particular voice using the [[VOICE]] command.

===== See also =====

  * [[SOUND_CLEAR]]
  * [[VOICE]]
  * [[VOLUME]]
====== FLOAT ======

The ''FLOAT'' keyword can be used in several statements to designate a variable or value as a 32-bit floating point number. See [[v3:datatypes|]] and [[v3:dim|]] for more information.
====== FOR ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  FOR <varname> [AS <type>] = <start_value> TO <end_value> [STEP <step_value>]
    <statements>
  NEXT [<varname>]

The ''FOR ... NEXT'' loop initializes a counter variable and executes the statements in the block until the counter variable equals the value in the ''TO'' clause. After each iteration, the counter variable is incremented by the step value or 1 in case the step value was not specified. For example:

  DIM i AS BYTE
  FOR i = 1 TO 30 STEP 3
    PRINT i
  NEXT i

As you can see above, the counter variable must be predefined. If the variable is not predefined, you can use the ''AS'' keyword to specify the type and this way the compiler will automatically define the variable before starting the loop. The following code is identical to the one above:

  FOR i AS BYTE = 1 TO 30 STEP 3
    PRINT i
  NEXT i

<adm warning>
The counter variable, the start value, the end value and the step value must all be of the same numeric type and this type is concluded from the counter variable. All the other expressions will be converted to this type if possible, otherwise a compile-time error will be thrown.
</adm>

<adm note>
The variable name can be omitted in the ''NEXT'' statement.
</adm>

===== Countdown of unsigned types  =====

For performance and overflow-safety reasons, it is not possible to go downwards in a loop where the index variable is of an unsigned type (BYTE or WORD). You should rather use a [[v3:do|]] loop for this purpose:

  ' This loop will never run because -1 is converted to 255
  FOR b AS BYTE = 5 TO 1 STEP -1
    PRINT b
  NEXT b
  
  ' Use this instead
  DIM i AS BYTE
  i = 5
  DO WHILE i >= 1
    PRINT i
    i = i - 1
  LOOP
  
  ' Or simply use a signed type
  FOR x AS INT = 5 TO 1 STEP -1
    PRINT x
  NEXT x
===== Continuing the loop =====

You can use the ''CONTINUE FOR'' command to skip the rest of the statements in the ''FOR ... NEXT'' block and go to the next iteration, for example:

  REM -- print numbers from 1 to 10, except 5 and 7
  FOR num AS BYTE = 1 TO 10
    IF num = 5 OR num = 7 THEN CONTINUE FOR
    PRINT num
  NEXT

===== Early exiting the loop =====

Finally, you can use the ''EXIT FOR'' statement to early exit a ''FOR ... NEXT'' loop.

  DIM a$ AS STRING * 1
  FOR i AS BYTE = 1 TO 10
    PRINT "iteration #"; i : INPUT "do you want to continue? (y/n)"; a$
    IF a$ = "n" THEN EXIT FOR
    PRINT i
  NEXT i
  
===== The counter is always STATIC =====

Despite variables in [[v3:subroutines|]] or [[v3:functions|]] can be defined either [[v3:static|]] or dynamic, the counter of a ''FOR ... NEXT'' loop must always be STATIC. For this reason,

  - If you try to use a previously defined dynamic variable as counter, compilation will fail
  - If you let the compiler automatically define the variable (using the ''AS'' keyword), the variable will be defined as STATIC.

  SUB mydynamicsub ()
    DIM i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' Error, i can't be dynamic
  END SUB

  SUB mystaticsub () STATIC
    DIM i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' Works because i is now STATIC
  END SUB

  SUB mydynamicsub ()
    STATIC i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' This works, too
  END SUB

  SUB mydynamicsub ()
    FOR i AS BYTE = 0 TO 10 : PRINT i : NEXT ' Also works, i will be defined STATIC
  END SUB

====== FUNCTION ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''FUNCTION'' keyword starts a function block.

===== Syntax =====

  FUNCTION <name> AS <type> ([<arg> AS <type>[, <arg> AS <type>]...]) [OVERLOAD] [PRIVATE|SHARED] [STATIC]
    <statements>
  END FUNCTION

  * <name> must be a valid [[syntax#identifiers|identifer]]
  * <type> must be provided and it must be a defined type (internal or user-defined)
  * The argument list is optional, but the parenthesis ''()'' must be included
  * The ''OVERLOAD'' keyword must be given if the function overloads another function with the same name
  * If the function is defined in a [[TYPE]] block, the ''PRIVATE'' keyword indicates that the function may only be called from within that TYPE block.
  * The ''SHARED'' keyword indicates that the function is visible from within other code modules
  * The ''STATIC'' keyword indicates that no stack frame is allocated on each function call. See [[subroutines#static_vs_dynamic]]

===== See also =====

  * [[v3:subroutines|]]
  * [[v3:functions|]]

====== GET ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  GET <variable>

The ''GET'' commands reads a single character from the keyboard buffer and assigns it to the given variable.

  * If the variable is a of a numeric type, it will be assigned the numeric PETSCII code of the character,
  * If the variable is a ''STRING'', it will be assigned the character itself, as string.

<adm warning>
The variable must be pre-defined.
</adm>

===== Example =====

Waiting for a key in the buffer:

  DIM a$ AS STRING * 1
  DO
    GET a$
  LOOP UNTIL LEN(a$) > 0
  PRINT "you pressed: "; a$

Or a simpler equivalent:

  DIM a AS BYTE
  DO
    GET a
  LOOP UNTIL a > 0
  PRINT "you pressed: "; CHR$(a)

====== GET# ======

[vic20] [c16] [cplus4] [c64] [c128] [m65]

The ''GET#'' statement is used to read a single character from a file. The file must be opened beforehand with the same logical file number, using the ''[[OPEN|OPEN]]'' statement.

===== Syntax =====

  GET #<logical file no>, <variable>

The character that is read from the file is assigned to the specified variable as per the following rules:

  * If the variable is of a numeric type, it will be assigned the numeric PETSCII code of the character,
  * If the variable is a ''STRING'', it will assigned the character itself, as string.

<adm warning>
The variable must be predefined.
</adm>

<adm warning>
File I/O commands are not implemented for the Commodore PET.
</adm>
===== Examples =====

  REM -- dump raw contents of a file
  DIM char$ AS STRING * 1
  CONST EOF = 64
  OPEN 2, 8, 2, "filename"
  DO WHILE ST() <> EOF
    GET #2, char$
    PRINT char$;
  LOOP
  CLOSE 2
  

====== GOSUB ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  GOSUB <label>

The ''GOSUB'' command calls a subroutine marked by a label. ''RETURN'' will pass control back to the caller. 

<adm note>
Unlike [[subroutines]], labelled code points do not start a new local scope.
</adm>
===== Example =====

  REM ** subroutines **
  GOSUB first_routine
  END
  	
  first_routine:
    PRINT "hello world"
    GOSUB second_routine
    RETURN
  		
  second_routine:
    PRINT "and hello again"
    RETURN

<adm warning>
Make sure you use the ''[[END|END]]'' command before your routines if you don't want them to be executed in the normal program flow (like in the example above).
</adm>


====== GOTO ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''GOTO'' command is used for jumping to a labelled code point.

===== Syntax =====

  GOTO <label>

===== See also =====

  * [[GOSUB]]

====== HSCROLL ======

[c64] [c16] [cplus4] [c128] [x16] [m65]

Sets the horizontal smooth scrolling value.

===== Syntax =====

  ' On all Commodore platforms and the MEGA65:
  HSCROLL <px>
  ' On the Commander X16:
  HSCROLL <layer>, <px> 

  * On [c64] [c16] [cplus4] [c128] [m65], ''<px>'' is a value between 0 and 7. After this operation, the screen will be moved ''<px>'' pixels to the right.
  * On the [x16], ''<layer>'' is a literal 0 or 1 specifying which layer to scroll. ''<px>'' is a value between 0 and 4095



===== See also =====

  * [[VSCROLL]]


====== IF ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

Conditional statements can be run using ''IF ... ELSE ... END IF'' blocks.

===== Single-line syntax =====

  IF <condition> THEN <statements> [ELSE <statements>]

===== Block syntax =====

  IF <condition> THEN
    <statements>
  [ELSE
    <statements>]
  END IF

The condition can be any expression that evaluates to a number. If the number is a nonzero value, the condition will pass, if it equals to zero, the condition will fail. Relations are expressions that evaluate to 0 if false, 255 if true:

  PRINT 1 > 0 : REM -- outputs 255
  
Therefore the condition can be any numeric expression:

  IF x > 0 AND x < 11 THEN PRINT "the number is between 1 and 10"






====== INCBIN ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

Include raw binary data in the compiled program.

===== Syntax =====

  INCBIN "path/to/binary_file"

The ''INCBIN'' directive instructs the assembler to include a custom binary file. This is useful to include graphics, music or any kind of data - even machine code routines - in your program. The included file must be a path relative to the folder where the code module is.

<adm warning>
Be very careful, as the binary stream will be injected into the program right at the point where the compiler encounters the directive. Make sure that the included data is outside the program flow (unless it's meant to be there).
</adm>

Although the compiler will let you know the exact addresses where the included files got assembled within the final executable, these addresses may be changing. In most cases you will want to use ''INCBIN'' in combination with [[ORIGIN]] to make sure that your included binaries are always located at the same address.

====== INCLUDE ======

===== Syntax =====

  INCLUDE "path/to/filename.bas"
  
The ''INCLUDE'' directive instructs the compiler to fetch the contents of another source file and include it in the current source. Nested includes are supported. The path must be a relative path to the current source file.

===== See also =====

  * [[v3:code_modules]]

====== INLINE ======

''INLINE'' is a reserved word that is not intended to be used in userland code.

====== INPUT ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

Read a string from the keyboard.
===== Syntax =====

  INPUT ["prompt";] <variable> [;]

Variable must be a pre-defined ''STRING''.
====== INPUT# ======

[vic20] [c16] [cplus4] [c64] [c128] [m65]

The ''INPUT#'' command is used for reading strings from a file, into one or more variables. The file must be opened beforehand using the [[OPEN]] command.
===== Syntax =====

  INPUT #<logical file number>, <variable> [, <variable>] ...

Differences from CBM BASIC:

  * All variables must be of type STRING. 
  * Only the comma ('','') character is recognized as record separator. If the input is between quotes (''"'') the comma is regarded as part of the string.

<adm warning>
File I/O commands are not implemented for the Commodore PET.
</adm>
===== Example =====

This example demonstrates writing to and reading from a sequential file:

  OPEN 2, 8, 4, "testfile,s,w"
  PRINT #2, "{34}quoted,string{34}", "one";"more", "record"
  CLOSE 2
  
  PRINT "file written. now reading..."
  
  DIM a$ AS STRING * 12
  DIM b$ AS STRING * 12
  DIM c$ AS STRING * 12
  
  OPEN 2, 8, 4, "testfile,s,r"
  INPUT #2, a$, b$, c$
  PRINT a$, b$, c$
  CLOSE 2

===== See also =====

  * [[v3:print_hash|]]
  * [[OPEN]]
  * [[CLOSE]]

====== INT ======

The ''INT'' keyword can be used in several statements to designate a variable or value as a 16-bit signed binary number. See [[v3:datatypes|]] and [[v3:dim|]] for more information.
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

======LET======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
=====Syntax=====
  [LET] <variable> = <expression>

The ''LET'' command assigns the value of an expression to a variable.

===== Examples =====
  ' DIM some variables and assign values to them
  DIM x AS BYTE
  DIM y(10) AS INT
  LET x = 5
  LET y(2) = x * 2

In the above example, variable ''x'' is defined as a ''BYTE'' and ''y'' is defined as an ''INT'' array with ''11'' dimensional elements. Variable ''x'' is then assigned the value of ''5'' and variable ''y'''s second array element is assigned the value of the expression ''x * 2'', which evaluates to ''10'' in this example.

<adm note>
''LET'' is an optional keyword and may be omitted when assigning values or expressions to a variable.
</adm>



=====See Also=====
  * [[v3:DIM]]
  * [[v3:operators]]
  * [[v3:variables]]
  * [[v3:syntax]]
====== LOAD ======

[vic20] [c16] [cplus4] [c64] [c128] [m65]

Load a file from tape or disk to memory.

===== Syntax =====

  LOAD <filename>, <device_no> [, <start_address>]
	
The ''LOAD'' command loads a binary file from the given device into memory using the KERNAL load routine.

  * <filename> must be a STRING
  * <device no> must be a number:
    * device number 1: tape
    * device numbers 8-15: disk drives
  * If <start_address> is not specified, the first to bytes (LB/HB) of the file will be used as the start address. Otherwise the first two bytes of the file will be discarded and the rest will be loaded into the memory address specified by <start_address>.

Use the ''ON ERROR GOTO'' statement beforehand if you want to trap errors during the loading process.

<adm warning>
File I/O commands are not implemented for the Commodore PET.
</adm>

===== See also =====

  * [[v3:fileio|]]
  * [[v3:error_handling|]]

====== LOCATE ======

[vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''LOCATE'' command is used to set the cursor position.

===== Syntax =====

  LOCATE <x_pos>, <y_pos>

<adm warning>
This command does not work on the Commodore PET.
</adm>
====== LONG ======

The ''LONG'' keyword can be used in several statements to designate a variable or value as a 24-bit signed binary number. See [[v3:datatypes|]] and [[v3:dim|]] for more information.
====== DO ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''DO ... LOOP'' block defines a pre-test or post-test loop.

===== Pre-test syntax =====

  DO WHILE|UNTIL <condition>
    <statements>
  LOOP

===== Post-test syntax =====

  DO
    <statements>
  LOOP WHILE|UNTIL <condition>

The former is used to test the condition before entering the loop body and the latter is used to test the condition after each iteration. This effectively means that post-test loop will be executed at least once, whereas in a pre-test loop the condition may fail the very first time and therefore it may happen that the statements in the loop will not be executed at all.

In both forms, you can either use the ''WHILE'' or ''UNTIL'' keywords. ''WHILE'' means that the loop is entered if the condition evaluates to true, ''UNTIL'' means that the loop is exited if the condition evaluates to true.

You can use the ''EXIT DO'' command to prematurely exit a ''DO … LOOP'' block, or ''CONTINUE DO'' to skip rest of the block and go to the next iteration.
====== MEMCPY ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  MEMCPY <source_address>, <destination_address>, <length>
  
The ''MEMCPY'' command calls a built-in routine that copies //length// number bytes in memory from //source_address// to //destination_address//.


<adm note>
''MEMCPY'' uses fast Direct Memory Access (DMA) on the [m65].
</adm>

The routine is overlapping-safe **downwards only**. Use it if

  * The source and destination ranges don't overlap, or
  * The destination range is lower in memory

For copying overlapping areas upwards, see ''[[memshift|MEMSHIFT]]''.

===== See also =====

  * [[MEMSET]]
  * [[MEMSHIFT]]

====== MEMSET ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax: =====

  MEMSET <source_address>, <length>, <fill_value>

The ''MEMSET'' command calls a built-in routine that sets //length// number of bytes in memory to //fill_value// starting from //source_address//.

==== Example ====

  REM -- clear the screen
  MEMSET 1024, 1000, 32

<adm note>
''MEMSET'' uses fast Direct Memory Access (DMA) on the [m65].
</adm>
===== See also =====

  * [[MEMCPY]]
  * [[MEMSHIFT]]

====== MEMSHIFT ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  MEMSHIFT <source_address>, <destination_address>, <length>
  
The ''MEMSHIFT'' command calls a built-in routine that copies //length// number bytes in memory from //source_address// to //destination_address//.


<adm note>
''MEMSHIFT'' uses fast Direct Memory Access (DMA) on the [m65].
</adm>

The routine is overlapping-safe **upwards only**. Use it if

  * The source and destination ranges don't overlap, or
  * The destination range is higher in memory

For copying overlapping areas downwards, see ''[[memcpy|MEMCPY]]''.

===== See also =====

  * [[MEMSET]]
  * [[MEMCPY]]

====== MOD ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''MOD'' ("modulo") operator solves the remainder of a division, after one number is divided by another.
===== Syntax =====

  <dividend> MOD <divisor>

===== Examples =====

  PRINT 5 MOD 2 : REM outputs 1

The above expression evaluates to 1, because 5 divided by 2 has a quotient of 2 and a remainder of 1.

  CONST PI = 3.14159
  PRINT (2.5 * PI) MOD PI : REM outputs a number equal to PI/2

The following program checks whether a year is a leap year:

  DIM in$ AS STRING * 4
  DIM year AS WORD
  DIM isleap AS BYTE
  CONST TRUE = 255
  CONST FALSE = 0
  INPUT "enter year: "; in$
  year = CWORD(VAL(in$))
  IF year MOD 4 = 0 THEN
    IF year MOD 100 = 0 THEN
      isleap = (year MOD 400 = 0)
    ELSE
      isleap = TRUE
    END IF
  ELSE
    isleap = FALSE
  END IF
  PRINT year; " is ";
  IF NOT isleap THEN PRINT "not ";
  PRINT "a leap year."

====== NOT ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The unary ''NOT'' operator performs a bitwise negation operation.

===== Syntax =====

  NOT <expression>

The expression can be any type of numeric expression, except FLOAT.
====== FOR ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  FOR <varname> [AS <type>] = <start_value> TO <end_value> [STEP <step_value>]
    <statements>
  NEXT [<varname>]

The ''FOR ... NEXT'' loop initializes a counter variable and executes the statements in the block until the counter variable equals the value in the ''TO'' clause. After each iteration, the counter variable is incremented by the step value or 1 in case the step value was not specified. For example:

  DIM i AS BYTE
  FOR i = 1 TO 30 STEP 3
    PRINT i
  NEXT i

As you can see above, the counter variable must be predefined. If the variable is not predefined, you can use the ''AS'' keyword to specify the type and this way the compiler will automatically define the variable before starting the loop. The following code is identical to the one above:

  FOR i AS BYTE = 1 TO 30 STEP 3
    PRINT i
  NEXT i

<adm warning>
The counter variable, the start value, the end value and the step value must all be of the same numeric type and this type is concluded from the counter variable. All the other expressions will be converted to this type if possible, otherwise a compile-time error will be thrown.
</adm>

<adm note>
The variable name can be omitted in the ''NEXT'' statement.
</adm>

===== Countdown of unsigned types  =====

For performance and overflow-safety reasons, it is not possible to go downwards in a loop where the index variable is of an unsigned type (BYTE or WORD). You should rather use a [[v3:do|]] loop for this purpose:

  ' This loop will never run because -1 is converted to 255
  FOR b AS BYTE = 5 TO 1 STEP -1
    PRINT b
  NEXT b
  
  ' Use this instead
  DIM i AS BYTE
  i = 5
  DO WHILE i >= 1
    PRINT i
    i = i - 1
  LOOP
  
  ' Or simply use a signed type
  FOR x AS INT = 5 TO 1 STEP -1
    PRINT x
  NEXT x
===== Continuing the loop =====

You can use the ''CONTINUE FOR'' command to skip the rest of the statements in the ''FOR ... NEXT'' block and go to the next iteration, for example:

  REM -- print numbers from 1 to 10, except 5 and 7
  FOR num AS BYTE = 1 TO 10
    IF num = 5 OR num = 7 THEN CONTINUE FOR
    PRINT num
  NEXT

===== Early exiting the loop =====

Finally, you can use the ''EXIT FOR'' statement to early exit a ''FOR ... NEXT'' loop.

  DIM a$ AS STRING * 1
  FOR i AS BYTE = 1 TO 10
    PRINT "iteration #"; i : INPUT "do you want to continue? (y/n)"; a$
    IF a$ = "n" THEN EXIT FOR
    PRINT i
  NEXT i
  
===== The counter is always STATIC =====

Despite variables in [[v3:subroutines|]] or [[v3:functions|]] can be defined either [[v3:static|]] or dynamic, the counter of a ''FOR ... NEXT'' loop must always be STATIC. For this reason,

  - If you try to use a previously defined dynamic variable as counter, compilation will fail
  - If you let the compiler automatically define the variable (using the ''AS'' keyword), the variable will be defined as STATIC.

  SUB mydynamicsub ()
    DIM i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' Error, i can't be dynamic
  END SUB

  SUB mystaticsub () STATIC
    DIM i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' Works because i is now STATIC
  END SUB

  SUB mydynamicsub ()
    STATIC i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' This works, too
  END SUB

  SUB mydynamicsub ()
    FOR i AS BYTE = 0 TO 10 : PRINT i : NEXT ' Also works, i will be defined STATIC
  END SUB

====== ON ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''ON ... GOTO|GOSUB'' construct has multiple use cases:

  * ''ON <value> GOTO|GOSUB'' is used for multiple branching
  * ''ON ERROR GOTO'' is used for error trapping
  * ''ON <event> GOSUB'' is used for interrupt handling

===== Syntax =====

  ON <value> GOTO|GOSUB <label> [, <label> ...]
  ON ERROR GOTO <label>
  ON TIMER|RASTER|SPRITE|BACKGROUND|VBLANK GOSUB <label>

For more details, refer to:

  * [[v3:flowcontrol|]]
  * [[v3:error_handling|]]
  * [[v3:interrupts|]]
====== OPEN ======

[vic20] [c16] [cplus4] [c64] [c128] [m65]

The ''OPEN'' command opens a logical file.

===== Syntax =====

  OPEN <logical_no> [, <device_no> [, <secondary_address> [, <filename> ]]]

<adm warning>
File I/O commands are not implemented for the Commodore PET.
</adm>

====== OPTION ======

The OPTION directive sets various compilation options. Most of these options can be set from the command line as well. The OPTION directive gets higher priority than command line options.

===== Syntax =====

  OPTION <option_name> [= <value>]

<adm note>
OPTION directives must precede any other commands in the program.
</adm>

===== Examples =====

To set the target machine, use:

  OPTION TARGET = "c128"

Accepted values are:

  * "c64" (Commodore-64)
  * "vic20" (Commodore VIC-20 unexpanded)
  * "vic20_3k" (Commodore VIC-20 with 3k RAM expansion)
  * "vic20_8k" (Commodore VIC-20 with 8k RAM expansion)
  * "cplus4" (Commodore Plus/4)
  * "c16" (Commodore-16)
  * "c128" (Commodore-128)
  * "pet2001" (Commodore PET2001)
  * "pet3008" (Commodore PET3000 series with 8k RAM)
  * "pet3016" (Commodore PET3000 series with 16k RAM)
  * "pet3032" (Commodore PET3000 series with 32k RAM)
  * "pet4016" (Commodore PET4000 series with 16k RAM)
  * "pet4032" (Commodore PET4000 series with 32k RAM)
  * "pet8032" (Commodore PET8000 series)
  * "x16" (Commander X16)
  * "mega65" (MEGA65) 

To disable the BASIC loader, use:

  OPTION NOBASICLOADER

If the above option is set, the compiled program will be a bare machine language binary that you can only run using the ''SYS'' command from CBM BASIC.

To set the start address of the program, use:

  OPTION STARTADDRESS = $C000

This really makes sense when used together with ''OPTION NOBASICLOADER''.

To enable inline data injection, use:

  OPTION INLINEDATA

See [[DATA]] for additional details.

To use Fast Interrupts, use

  OPTION FASTINTERRUPT

See [[interrupts]] for more information.
====== OR ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''OR'' operator performs a bitwise OR operation.

===== Syntax =====

  <operand> OR <operand>

Both operands can be any type of numeric expression, except FLOAT.
====== ORIGIN ======
===== Syntax =====

  ORIGIN <address>

The ''ORIGIN'' command instructs the assembler to compile subsequent code starting from an address other than the current address.

  * If the new address is less than the current address, the program won't compile.
  * If the new address is greater than the current address, the gap between the current and new address will be filled in with $FF bytes.

The ''ORIGIN'' command can take a decimal or hexadecimal address. No variables, constants or expressions are allowed.

===== Example =====

  REM -- the program starts here
  GOTO start
  INCBIN "sprites.bin"
  ORIGIN $3800
  INCBIN "charset.bin"
  ORIGIN $4000
  start:
    REM -- the actual code starts here
    PRINT "welcome to my game"

In the example above, sprite data will start right after the ''GOTO'' statement. The gap between the sprites and the charset will be filled with $FF-s.

It is very important that the program code must never execute the empty gaps between the different "segments" that you define with ''ORIGIN'', because that would lead to a crash. Consider the following example:

  REM -- segment #1
  PRINT "hello world"
  
  ORIGIN $1000
  REM -- segment #2
  PRINT "hello again"
	
The above program will break if there is a gap between the two segments. The good practice is the following:

  REM -- segment #1
  PRINT "hello world"
  GOTO seg2
  
  origin $1000
  REM -- segment #2
  seg2:
  PRINT "hello again"
====== OVERLOAD ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''OVERLOAD'' keyword denotes that the subroutine or function overloads another one with the same name. See [[SUB]] and [[FUNCTION]] for details.
====== POKE ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  POKE <address>, <value>

The ''POKE'' command stores a value into the given memory address.
===== Examples =====

  REM ** turn border to black **
  POKE 53280, 0
 
===== See also =====

  * [[v3:peek]]

====== PRINT ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

Output strings and numbers on the currently selected screen, at the current cursor position.

===== Syntax =====

  PRINT <expression> [ ,|; <expression>] ... [;]
  
Expressions can be of any type, excluding user-defined types. Expressions are separated with commas ('','') or semicolons ('';'').

  * If the separator is a comma, the cursor will be moved to the next tab position. A tab is 10 characters wide.
  * If the separator is a semicolon, the cursor will not be moved.

A semicolon at the end of the statement will prevent printing a newline after the last printed expression.
  
===== Examples =====

  PRINT "hello world"
  PRINT "the value of myvar is "; myvar; " and that of anothervar is "; anothervar
  REM -- tabular output
  a = 10 : b = 20 : c = 30
  PRINT a, b, c


====== PRINT# ======

[vic20] [c16] [cplus4] [c64] [c128] [m65]

The ''PRINT#'' command outputs one or more values to a previously opened file. Use the [[OPEN]] statement to open the file first.

===== Syntax =====

  PRINT #<logical_file_no>, <expression> [,|; <expression>] ... [;]

  * <logical_file_no> must evaluate to a number between 0 and 15 and must refer to a file that was previously opened using the [[OPEN]] command.
  * The subsequent expressions will be written to the file as STRING.
  * If a comma ('','') is used between two expressions, the records will be separated with a comma character.
  * If a semicolon ('';'') is used between two expressions, the expressions will be concatenated, and thus they will form a single record.
  * A newline character will close the list of expressions, unless the statement ends with a semicolon ('';'').

<adm warning>
File I/O commands are not implemented for the Commodore PET.
</adm>

===== Example =====

See [[v3:input_hash|]] for an example.

===== See also =====

  * [[v3:input_hash|]]
  * [[OPEN]]
  * [[CLOSE]]


====== PRIVATE ======

The ''PRIVATE'' keyword denotes that a method is only callable within the type in which it was defined. Read more in [[v3:udt|]].


====== RANDOMIZE ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''RANDOMIZE'' command seeds the pseudo-random generator with an initial value.

===== Syntax =====

  RANDOMIZE <value>

The value given must be a LONG number and it will serve as a base for the random sequence.

===== Example =====

A typical use case is to seed the randomizer with the result of the [[TI]] function:

  RANDOMIZE TI()
  FOR i AS BYTE = 1 TO 10 : PRINT RND() : NEXT

===== Commander X16 Example =====

Since the ''TI()'' function is not implemented in the [x16], we'll use the ''ENTROPY()'' function, that is part of the X16.BAS library:

  INCLUDE "x16.bas"
  RANDOMIZE ENTROPY()
  FOR i AS BYTE = 1 TO 10 : PRINT RND() : NEXT


===== See also =====

  * [[RND]]
  * [[RNDB]]
  * [[RNDI]]
  * [[RNDW]]
  * [[RNDL]]
  * [[TI]]



====== READ# ======

[vic20] [c16] [cplus4] [c64] [c128] [m65]

The ''READ#'' command is used for restoring the contents of a variable from a file. The file must be opened first using [[OPEN]].

===== Syntax =====

  READ #<logical_file_no>, <variable> [, <variable> ... ]

The ''READ#'' command is similar to [[INPUT_hash]] in that both commands read sequential data from a file, however while ''INPUT#'' accepts PETSCII-encoded (textual) data, ''READ#'' accepts binary data. To put it simple:

  * ''INPUT#'' can restore data stored using [[PRINT_hash]]
  * ''READ#'' can restore data stored using [[WRITE]]

<adm note>
''READ'' accepts any number of variables of any type, even [[udt]].
</adm>

For an in-depth explanation of file input-output operations with examples, please read [[fileio]].

<adm warning>
File I/O commands are not implemented for the Commodore PET.
</adm>

===== See also =====

  * [[OPEN]]
  * [[CLOSE]]
  * [[GET_hash]]
  * [[PRINT_hash]]
  * [[INPUT_hash]]
  * [[WRITE]]
  * [[ST]]

====== REM ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  REM <comments>
or
  ' <comments>
  
The ''REM'' keyword marks a comment until the end of that line. The compiler will ignore it.
====== RETURN ======

The ''RETURN'' keyword can be used:

  * To return control after the last [[GOSUB]] statement
  * To return a value from a [[FUNCTION]]
====== SAVE ======

[vic20] [c16] [cplus4] [c64] [c128] [m65]

The ''SAVE'' command saves a memory area into a file on the given device. The first two bytes in the file will contain the start address.

===== Syntax =====

  SAVE <filename>, <device_no>, <start_address>, <end_address>

Prepend the file name with ''@0'' to overwrite an existing file on disk.

<adm warning>
File I/O commands are not implemented for the Commodore PET.
</adm>
===== Example =====

  save "@0:existingfile", 8, 49152, 49408

===== See also =====

  * [[v3:fileio|]]
  * [[LOAD]]

====== SELECT CASE ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

Executes one of several statement blocks depending on the value of an expression.

===== Syntax =====

  SELECT CASE <expr>
    CASE <exp1> [, <exp2>, <exp3> ... ]
      <statements>
    CASE IS <relational operator> <exp4>  
      <statements>
    CASE <exp5> TO <exp6>
      <statements>
    CASE ELSE
      <statements>
  END SELECT

In the first ''CASE'' block above, the value of <expr> is tested against <exp1>, <exp2> and <exp3> and the statement block is executed once one of them equals.

In the second block, a relational operator, <, <=, >, >=, <>, or = is provided and the statement block is executed if the relation evaluates to true. This works with numeric types only. 

In the third block, the statement block is executed if <expr> is between <exp5> and <exp6> (inclusive). This works with numeric types only.

If one of the ''CASE'' expressions is tested to be true, the statement block will be executed and control will be passed to the code after ''END SELECT''. That is to say, at most one statement block will be executed. 

If none of the ''CASE'' expressions is tested to be true, control will be passed to ''CASE ELSE'' (if it exists).
===== Example =====

  DIM a$ AS STRING * 3
  again:
  INPUT "your age? ";a$
  age = VAL(a$)
  SELECT CASE age
    CASE 0, 1
      PRINT "baby"
    CASE 2, 3
      PRINT "toddler"
    CASE 4 TO 10
      PRINT "child"
    CASE 11 TO 17
      PRINT "teenager"
    CASE IS >= 18
      PRINT "adult"
    CASE ELSE
      PRINT "invalid value"
      GOTO again
  END SELECT

===== See also =====

  * [[IF]]

====== SCREEN ======

[c64] [c128]

The ''SCREEN'' command switches between multiple logical screens by changing the Video Matrix Base Address.

===== Syntax =====

  SCREEN <screen_number>

Where ''<screen_number>'' must be a value between 0 and 15. The value multiplied by $0400 (decimal 1024) will be the new Base Address within the currently selected VIC bank. The default VIC bank is 0 and the default screen number is 1, therefore the default Base Address is $0400 (decimal 1024).

<adm note>
The command has effect on the Commodore-64 and 128 only. To set the screen mode on the Commander X16, see [[VMODE]].
</adm>

<adm warning>
The ''SCREEN'' command updates various KERNAL variables and pointer tables, which consumes considerable amount of CPU cycles and therefore it is not suitable for quickly switching between screens, for example when displaying double-buffered graphics. If speed is crucial in your program, consider simply using ''POKE'' to switch between screens.
</adm>

===== Example =====

  DIM a$ AS STRING * 1
  PRINT "this is screen 1"
  PRINT "press key to switch"
  REM save cursor position
  x = POS() : y = CSRLIN()
  REM wait for keypress
  DO
    GET a$
  LOOP WHILE LEN(a$) = 0
  REM switch screen
  SCREEN 8
  PRINT CHR$(147)
  PRINT "this is screen 8"
  PRINT "press key to go back"
  REM wait for keypress
  DO
    GET a$
  LOOP WHILE LEN(a$) = 0
  SCREEN 1
  REM restore cursor position
  LOCATE x, y


====== SHARED ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''SHARED'' keyword can be used in multiple statements to denote that the identifier being defined has shared visibility, meaning that it is visible from within all [[v3:code_modules|code modules]].

===== See also =====

  * [[CONST]]
  * [[DIM]]
  * [[FUNCTION]]
  * [[SUB]]

====== SPRITE ======

[c64] [c128] [x16] [m65]

The ''SPRITE'' command sets various properties of a single sprite, including visibility, shape, color, etc.

===== Syntax =====

  SPRITE <spr_no> <subcommand> <subcommand> ...

Where //<spr_no>// is an expression that evaluates to a number between 0 and 7 and //<subcommand>// is one of:

  * ''ON'' or ''OFF'' [c64] [c128] [x16] [m65]
  * ''AT <x>, <y>'' [c64] [c128] [x16] [m65]
  * ''SHAPE <n>'' [c64] [c128] [x16] [m65]
  * ''COLOR <c>'' [c64] [c128] [x16] [m65]
  * ''HIRES'' or ''MULTI''  [c64] [c128] [m65]
  * ''LOWCOL'' or ''HICOL''  [x16]
  * ''XYSIZE <x>, <y>''  [c64] [c128] [x16] [m65]
  * ''ON BACKGROUND'' or ''UNDER BACKGROUND'' [c64] [c128] [m65]
  * ''ZDEPTH <n>'' [x16]
  * ''XYFLIP <xf>, <yf>'' [x16]
===== Examples =====

  SPRITE 0 SHAPE 4 ON AT 160, 100 COLOR 1
  SPRITE 1 OFF
  ' Notice: the _ character splits long lines
  SPRITE 2 _
    SHAPE 3 _
    ON _
    AT 50, 50 _
    MULTI _
    UNDER BACKGROUND

===== SPRITE ON / OFF =====

Enables or disables sprite visibility, for example:

  SPRITE 0 OFF
  SPRITE 1 ON

On the [x16], ''ON'' is equivalent to ''ZDEPTH 3'', while ''OFF'' is equivalent to ''ZDEPTH 0''.
===== SPRITE AT =====

Locates sprite at the given co-ordinates on screen. For example:

  SPRITE 5 AT 100, 140

will position sprite 5 at location (100,140).

===== SPRITE SHAPE =====

Sets the address where the bitmap data of a sprite is stored in memory.

On the [c64] and [c128] this memory address is relative to the currently selected VIC bank and is calculated with the following formula:

  address = VIC bank start + 64 * sprite shape
  
For example:

  SPRITE 0 SHAPE 128

will set the address 0 + 128 * 64 = 8192 ($2000) for sprite 0, the default VIC bank address being 0.

On the [x16] this memory address is a VRAM address, calculated with the following formula:

  address = sprite shape * 32

For example:

  SPRITE 0 SHAPE 2048

will set the address 2048 * 32 = 65536 ($10000) for sprite 0, that is, the first byte of the second VRAM bank.
===== SPRITE COLOR =====

[c64] [c128] Sets the individual sprite color to the desired value.

  CONST RED = 2
  SPRITE 1 COLOR RED

Note: global colors of multicolor sprites can be set using the [[SPRITE MULTICOLOR]] command.

[x16] Sets the palette offset for the sprite.
===== SPRITE HIRES / MULTI =====

[c64] [c128] Switches between high-resolution mode and multicolor modes for a single sprite.

  SPRITE 7 MULTI
  SPRITE 5 HIRES

===== SPRITE LOWCOL / HICOL =====

[x16] Switches between 4 bpp (low color) and 8 bpp (high color) modes for a single sprite.

  SPRITE 7 LOWCOL
  SPRITE 5 HICOL

===== SPRITE XYSIZE =====

Sets horizontal and vertical size of a sprite. Possible values differ by platform, see the following code snipplets for example:

  ' Commodore 64 and 128
  SPRITE 0 XYSIZE 0, 0 ' Normal size
  SPRITE 1 XYSIZE 1, 0 ' Horizontally stretched
  SPRITE 2 XYSIZE 0, 1 ' Vertically stretched
  SPRITE 3 XYSIZE 1, 1 ' Stretched in  both directions
  ' Commander X16
  SPRITE 0 XYSIZE 0, 0 ' 8x8 pixels
  SPRITE 1 XYSIZE 1, 0 ' 16x8 pixels
  SPRITE 2 XYSIZE 0, 1 ' 8x16 pixels
  SPRITE 3 XYSIZE 1, 1 ' 16x16 pixels
  ' ...
  SPRITE 16 XYSIZE 3, 3 ' 64x64 pixels
===== SPRITE ON/UNDER BACKGROUND =====

[c64] [c128] Sets whether the sprite is displayed before or behind background graphics.

  SPRITE 0 ON BACKGROUND
  SPRITE 1 UNDER BACKGROUND

===== SPRITE ZDEPTH =====

[x16] Sets where the sprite appears among layers.

  SPRITE 0 ZDEPTH 0 ' Sprite disabled (equivalent to SPRITE 0 OFF)
  SPRITE 0 ZDEPTH 1 ' Sprite between background and layer 0
  SPRITE 0 ZDEPTH 2 ' Sprite between layer 0 and layer 1
  SPRITE 0 ZDEPTH 3 ' Sprite in front of layer 1 (equivalent to SPRITE 0 ON)

===== SPRITE XYFLIP =====

[x16] Flips (mirrors) the sprite horizontally and/or vertically.

  SPRITE 0 XYFLIP 0, 0 ' Not flipped
  SPRITE 0 XYFLIP 1, 0 ' Flipped horizontally
  SPRITE 0 XYFLIP 0, 1 ' Flipped vertically
  SPRITE 0 XYFLIP 1, 1 ' Flipped horizontally and vertically
====== SPRITE CLEAR HIT ======

[c64] [c128] [m65]

Clears sprite collision status.

===== Syntax =====

  SPRITE CLEAR HIT

Executing this command immediate before the [[SPRITEHIT]] and [[SPRITEBGHIT]] functions are checked, the immediate status is returned. Otherwise, the hit check functions will return if sprites were involved in a collision since the status was last cleared.

===== See also =====

  * [[SPRITE]]
====== SPRITE MULTICOLOR ======

[c64] [c128] [m65]

The ''SPRITE MULTICOLOR'' commands sets the two global color values that apply to all multicolor sprites.

===== Syntax =====

  SPRITE MULTICOLOR <col1>, <col2>

Where <col1> and <col2> are expressions that evaluate to a number between 0 and 15.

===== See also =====

  * [[SPRITE]]


====== STATIC ======

The ''STATIC'' keyword can be used:

  * For defining a static variable in a dynamic sub or function. See [[DIM]].
  * For defining a subroutine or function static. See [[SUB]] and [[FUNCTION]].

====== SOUND CLEAR ======

[vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

Resets all voice registers.

===== Syntax =====

  SOUND CLEAR

This is useful at parts of the programs to make sure that all sounds stop and all sound-related values are reset to original.

===== See also =====

  * [[VOICE]]
  * [[VOLUME]]


====== FOR ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  FOR <varname> [AS <type>] = <start_value> TO <end_value> [STEP <step_value>]
    <statements>
  NEXT [<varname>]

The ''FOR ... NEXT'' loop initializes a counter variable and executes the statements in the block until the counter variable equals the value in the ''TO'' clause. After each iteration, the counter variable is incremented by the step value or 1 in case the step value was not specified. For example:

  DIM i AS BYTE
  FOR i = 1 TO 30 STEP 3
    PRINT i
  NEXT i

As you can see above, the counter variable must be predefined. If the variable is not predefined, you can use the ''AS'' keyword to specify the type and this way the compiler will automatically define the variable before starting the loop. The following code is identical to the one above:

  FOR i AS BYTE = 1 TO 30 STEP 3
    PRINT i
  NEXT i

<adm warning>
The counter variable, the start value, the end value and the step value must all be of the same numeric type and this type is concluded from the counter variable. All the other expressions will be converted to this type if possible, otherwise a compile-time error will be thrown.
</adm>

<adm note>
The variable name can be omitted in the ''NEXT'' statement.
</adm>

===== Countdown of unsigned types  =====

For performance and overflow-safety reasons, it is not possible to go downwards in a loop where the index variable is of an unsigned type (BYTE or WORD). You should rather use a [[v3:do|]] loop for this purpose:

  ' This loop will never run because -1 is converted to 255
  FOR b AS BYTE = 5 TO 1 STEP -1
    PRINT b
  NEXT b
  
  ' Use this instead
  DIM i AS BYTE
  i = 5
  DO WHILE i >= 1
    PRINT i
    i = i - 1
  LOOP
  
  ' Or simply use a signed type
  FOR x AS INT = 5 TO 1 STEP -1
    PRINT x
  NEXT x
===== Continuing the loop =====

You can use the ''CONTINUE FOR'' command to skip the rest of the statements in the ''FOR ... NEXT'' block and go to the next iteration, for example:

  REM -- print numbers from 1 to 10, except 5 and 7
  FOR num AS BYTE = 1 TO 10
    IF num = 5 OR num = 7 THEN CONTINUE FOR
    PRINT num
  NEXT

===== Early exiting the loop =====

Finally, you can use the ''EXIT FOR'' statement to early exit a ''FOR ... NEXT'' loop.

  DIM a$ AS STRING * 1
  FOR i AS BYTE = 1 TO 10
    PRINT "iteration #"; i : INPUT "do you want to continue? (y/n)"; a$
    IF a$ = "n" THEN EXIT FOR
    PRINT i
  NEXT i
  
===== The counter is always STATIC =====

Despite variables in [[v3:subroutines|]] or [[v3:functions|]] can be defined either [[v3:static|]] or dynamic, the counter of a ''FOR ... NEXT'' loop must always be STATIC. For this reason,

  - If you try to use a previously defined dynamic variable as counter, compilation will fail
  - If you let the compiler automatically define the variable (using the ''AS'' keyword), the variable will be defined as STATIC.

  SUB mydynamicsub ()
    DIM i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' Error, i can't be dynamic
  END SUB

  SUB mystaticsub () STATIC
    DIM i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' Works because i is now STATIC
  END SUB

  SUB mydynamicsub ()
    STATIC i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' This works, too
  END SUB

  SUB mydynamicsub ()
    FOR i AS BYTE = 0 TO 10 : PRINT i : NEXT ' Also works, i will be defined STATIC
  END SUB

====== STRING ======

The ''STRING'' keyword can be used in several statements to designate a variable or value as a string.

===== See also =====

  * [[v3:datatypes|]]
  * [[v3:dim|]]
  * [[v3:strings|]]
====== SUB ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''SUB'' keyword starts a subroutine block.

===== Syntax =====

  SUB <name> ([<arg> AS <type>[, <arg> AS <type>]...]) [OVERLOAD] [PRIVATE|SHARED] [STATIC]
    <statements>
  END SUB

  * <name> must be a valid [[syntax#identifiers|identifer]]
  * The argument list is optional, but the parenthesis ''()'' must be included
  * The ''OVERLOAD'' keyword must be given if the function overloads another function with the same name
  * If the subroutine is defined in a [[TYPE]] block, the ''PRIVATE'' keyword indicates that the subroutine may only be called from within that TYPE block.
  * The ''SHARED'' keyword indicates that the function is visible from within other code modules
  * The ''STATIC'' keyword indicates that no stack frame is allocated on each subroutine call. See [[subroutines#static_vs_dynamic]]

===== See also =====

  * [[v3:subroutines|]]
  * [[v3:functions|]]

====== SWAP ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''SWAP'' command is used to exchange the values of two variables.

===== Syntax =====

  SWAP <left>, <right>

After the operation, the variable //left// will have the value of //right// and vice versa.

<adm warning>
The two variables can be of any type, but their types must be the same.
</adm>

===== Example =====

The ''SWAP'' command is especially useful in sorting algorithms:

  REM -- Bubble sort 10 random long numbers --
  
  CONST TRUE = 255
  CONST FALSE = 0
  
  DIM nums(10) AS LONG
  DIM swapped AS BYTE FAST
  DIM i AS BYTE FAST
  DIM j AS BYTE FAST
  
  RANDOMIZE TI()
  FOR i = 0 TO 9 : nums(i) = RNDL() : NEXT
  
  swapped = FALSE
  FOR i = 0 TO 8
      FOR j = 0 TO 8 - i
          IF nums(j) > nums(j + 1) THEN
            SWAP nums(j), nums(j + 1)
            swapped = TRUE
          END IF
      NEXT j
      IF swapped = FALSE THEN EXIT FOR
  NEXT i
  
  FOR i = 1 TO 9 : PRINT nums(i) : NEXT

====== SYS ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''SYS'' commands calls a machine language subroutine at the specified address.

===== Syntax =====

  SYS <address> [FAST]

If used without the ''FAST'' directive, ''SYS'' will do the same as in CBM BASIC, that is, it will load the accumulator, the X and the Y register, and the status register from addresses $030C-$030F (on C64 and VIC-20) or $07F2-$07F5 (on CPlus/4 and C16) before the call. When the subroutine exits, ''SYS'' will save the values of these registers to the same memory addresses.

If however it is used with the ''FAST'' directive, a simpler and faster procedure is taken: the program will just jump to the specified address, without loading and saving the registers before and after the call.

<adm note>
Use the ''FAST'' directive if you don't need to pass values in registers to the subroutine.
</adm>

===== Examples =====

  SYS $C000 FAST : REM calls a subroutine at $C000 without passing registers
  SYS 64738 FAST : REM restarts the machine
  
  REM -- Printing a character on screen using the KERNAL function CHROUT
  CONST CHROUT =  $FFD2
  CONST ACCU = $030C ' C64 and VIC-20 only
  POKE ACCU, 'A': REM to load accumulator with the PETSCII code of 'A'
  SYS CHROUT : REM will output "A"
  




====== TEXTAT ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''TEXTAT'' command outputs a string at the given X and Y position of the currently selected screen without affecting the cursor position.

=====Syntax=====

  TEXTAT <x_pos>, <y_pos>, <text> [, <color>]

  * ''<x_pos>'' must be between 0 and the screen width minus one
  * ''<y_pos>'' must be between 0 and the screen height minus one
  * ''<text>'' can be either a string or a numeric expression
  * ''<color>'' is optional, it must be between 0 and 15 if provided. If not provided, the character color will be whatever value happens to be in the corresponding Color RAM location.

<adm warning>
The runtime library will not check if the X and Y values are within the screen boundaries. Providing wrong values will lead to writing to memory locations outside the screen memory, thus potentially damaging the program or data. Use it with care.
</adm>

<adm note>
Color values between 8 and 15 will set the character to multicolor mode on the Commodore VIC-20.
</adm>

<adm warning>
''TEXTAT'' writes screen codes directly to screen memory, rather than calling the KERNAL character output routine. For this reason PETSCII control caracters (color, cursor movement, etc.) will have no effect on the printed text.
</adm>
=====Examples=====

  REM output "welcome" near the center of the screen
  TEXTAT 16, 12, "welcome"
  REM output "hello" in the top left corner of the screen, in yellow
  TEXTAT 0, 0, "hello", 7


=====See Also=====

  * [[v3:SCREEN]]
  * [[v3:CHARAT]]
====== IF ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

Conditional statements can be run using ''IF ... ELSE ... END IF'' blocks.

===== Single-line syntax =====

  IF <condition> THEN <statements> [ELSE <statements>]

===== Block syntax =====

  IF <condition> THEN
    <statements>
  [ELSE
    <statements>]
  END IF

The condition can be any expression that evaluates to a number. If the number is a nonzero value, the condition will pass, if it equals to zero, the condition will fail. Relations are expressions that evaluate to 0 if false, 255 if true:

  PRINT 1 > 0 : REM -- outputs 255
  
Therefore the condition can be any numeric expression:

  IF x > 0 AND x < 11 THEN PRINT "the number is between 1 and 10"






====== THIS ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

''THIS'' is a special variable that refers to the instance on which the method was called.

===== Example =====

  TYPE vector
    x AS INT
    y AS INT
    SUB TRANSLATE(dx AS INT, dy AS INT)
      THIS.x = THIS.x + dx
      THIS.y = THIS.y + dy
    END SUB
  END TYPE
  
  DIM v AS vector
  v.x = 10 : v.y = 10
  CALL v.TRANSLATE(5, 5)
  PRINT v.x, v.y

====== FOR ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
===== Syntax =====

  FOR <varname> [AS <type>] = <start_value> TO <end_value> [STEP <step_value>]
    <statements>
  NEXT [<varname>]

The ''FOR ... NEXT'' loop initializes a counter variable and executes the statements in the block until the counter variable equals the value in the ''TO'' clause. After each iteration, the counter variable is incremented by the step value or 1 in case the step value was not specified. For example:

  DIM i AS BYTE
  FOR i = 1 TO 30 STEP 3
    PRINT i
  NEXT i

As you can see above, the counter variable must be predefined. If the variable is not predefined, you can use the ''AS'' keyword to specify the type and this way the compiler will automatically define the variable before starting the loop. The following code is identical to the one above:

  FOR i AS BYTE = 1 TO 30 STEP 3
    PRINT i
  NEXT i

<adm warning>
The counter variable, the start value, the end value and the step value must all be of the same numeric type and this type is concluded from the counter variable. All the other expressions will be converted to this type if possible, otherwise a compile-time error will be thrown.
</adm>

<adm note>
The variable name can be omitted in the ''NEXT'' statement.
</adm>

===== Countdown of unsigned types  =====

For performance and overflow-safety reasons, it is not possible to go downwards in a loop where the index variable is of an unsigned type (BYTE or WORD). You should rather use a [[v3:do|]] loop for this purpose:

  ' This loop will never run because -1 is converted to 255
  FOR b AS BYTE = 5 TO 1 STEP -1
    PRINT b
  NEXT b
  
  ' Use this instead
  DIM i AS BYTE
  i = 5
  DO WHILE i >= 1
    PRINT i
    i = i - 1
  LOOP
  
  ' Or simply use a signed type
  FOR x AS INT = 5 TO 1 STEP -1
    PRINT x
  NEXT x
===== Continuing the loop =====

You can use the ''CONTINUE FOR'' command to skip the rest of the statements in the ''FOR ... NEXT'' block and go to the next iteration, for example:

  REM -- print numbers from 1 to 10, except 5 and 7
  FOR num AS BYTE = 1 TO 10
    IF num = 5 OR num = 7 THEN CONTINUE FOR
    PRINT num
  NEXT

===== Early exiting the loop =====

Finally, you can use the ''EXIT FOR'' statement to early exit a ''FOR ... NEXT'' loop.

  DIM a$ AS STRING * 1
  FOR i AS BYTE = 1 TO 10
    PRINT "iteration #"; i : INPUT "do you want to continue? (y/n)"; a$
    IF a$ = "n" THEN EXIT FOR
    PRINT i
  NEXT i
  
===== The counter is always STATIC =====

Despite variables in [[v3:subroutines|]] or [[v3:functions|]] can be defined either [[v3:static|]] or dynamic, the counter of a ''FOR ... NEXT'' loop must always be STATIC. For this reason,

  - If you try to use a previously defined dynamic variable as counter, compilation will fail
  - If you let the compiler automatically define the variable (using the ''AS'' keyword), the variable will be defined as STATIC.

  SUB mydynamicsub ()
    DIM i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' Error, i can't be dynamic
  END SUB

  SUB mystaticsub () STATIC
    DIM i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' Works because i is now STATIC
  END SUB

  SUB mydynamicsub ()
    STATIC i AS BYTE
    FOR i = 0 TO 10 : PRINT i : NEXT ' This works, too
  END SUB

  SUB mydynamicsub ()
    FOR i AS BYTE = 0 TO 10 : PRINT i : NEXT ' Also works, i will be defined STATIC
  END SUB

====== TYPE ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''TYPE'' keyword starts a new [[v3:udt|user-defined type]] (UDT) block.

===== Syntax =====

  TYPE <name>
    <field> AS <type>
    [<field> AS <type>]
    [...]
    [SUB <method_name> ...]
    [FUNCTION <method_name> ...]
    [...]
  END TYPE


====== DO ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''DO ... LOOP'' block defines a pre-test or post-test loop.

===== Pre-test syntax =====

  DO WHILE|UNTIL <condition>
    <statements>
  LOOP

===== Post-test syntax =====

  DO
    <statements>
  LOOP WHILE|UNTIL <condition>

The former is used to test the condition before entering the loop body and the latter is used to test the condition after each iteration. This effectively means that post-test loop will be executed at least once, whereas in a pre-test loop the condition may fail the very first time and therefore it may happen that the statements in the loop will not be executed at all.

In both forms, you can either use the ''WHILE'' or ''UNTIL'' keywords. ''WHILE'' means that the loop is entered if the condition evaluates to true, ''UNTIL'' means that the loop is exited if the condition evaluates to true.

You can use the ''EXIT DO'' command to prematurely exit a ''DO … LOOP'' block, or ''CONTINUE DO'' to skip rest of the block and go to the next iteration.
====== VMODE ======

[c64] [c16] [cplus4] [c128] [x16] [m65]

Selects the video display mode.

===== Syntax =====

[c64] [c16] [cplus4] [c128] [m65]

  VMODE [TEXT|BITMAP|EXT] [HIRES|MULTI] [ROWS <rows>] [COLS <cols>]

  * TEXT selects text mode
  * BITMAP selects bitmap mode
  * EXT selects extended background color mode
  * HIRES or MULTI switches between high-resolution or multi color mode
  * ROWS must be provided the literal number 24 or 25 and sets the number of character rows visible on screen accordingly
  * COLS must be provided the literal number 38 or 40 and sets the number of character rows visible on screen accordingly

===== Examples =====

  ' Selects default text mode
  VMODE HIRES TEXT
  ' Selects multi color bitmap mode
  VMODE MULTI BITMAP
  ' Selects extended background color mode with the
  ' left and right character columns covered
  VMODE EXT COLS 38

[x16]

  VMODE <screen_mode>

Where ''<screen_mode>'' is a valid screen mode accepted by the X16 BASIC command ''SCREEN''. Refer to [[https://github.com/X16Community/x16-docs/blob/master/X16%20Reference%20-%2002%20-%20Editor.md#chapter-2-editor|List of SCREEN modes]].

===== See also =====

  * [[BACKGROUND]]
  * [[BORDER]]
  * [[HSCROLL]]
  * [[VSCROLL]]
====== VOICE ======

[vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

Selects various properties like waveform, tone, filters, etc. of a voice. The command is also used for turning a voice on or off. The command implements a uniform interface to the VIC, TED, SID and VERA chips, however differences between the sound capabilities of these chips must be considered as explained in more details below.

===== Syntax =====

  VOICE <voice_no> <subcmd> [<subcmd> ...]

Where **<voice_no>** is a number identifying the voice register. This must be a literal number on almost all platform, except the [x16] where a numeric expression is also accepted.

  * **<voice_no>** must be between 1-3 on [c64] and [c128], except for dual-SID systems, where a number between 1-6 is accepted
  * On [vic20], voices 1-4 can be used
  * On [c16] and [cplus4], only ''VOICE 1'' or ''VOICE 2'' are available
  * The number of voices range from 0 to 15 on the [x16]
  * The [m65] supports voices 1-12

The command is then is followed by at least one of the following:

  * ''ON'' or ''OFF'' [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
  * ''LEFT'' or ''RIGHT'' [x16]
  * ''TONE <tone_value>'' [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
  * ''ADSR <attack>, <decay>, <sustain>, <release>'' [c64] [c128] [m65]
  * ''WAVE SAW|TRI|PULSE|NOISE''  [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]
  * ''PULSE <freq>'' [c64] [c128] [x16] [m65]
  * ''FILTER ON|OFF'' [c64] [c128] [m65]
  * ''VOLUME'' [x16]

===== Examples =====

  ' Clear all registers
  SOUND CLEAR
  VOLUME 15
  ' Set up voice 1 for a high-pitch sawtooth wave but do not turn it on yet
  VOICE 1 WAVE SAW TONE 2500 ADSR 0, 7, 12, 1
  ' Turn it on
  VOICE 1 ON
  ' Set up voice 2 properties and turn it on immediately
  VOICE 2 WAVE PULSE PULSE 450 TONE 400 ADSR 9, 7, 10, 4 ON
  ' Change its tone while the voice is still on
  VOICE 2 TONE 2300

===== VOICE ON|OFF =====

Turns the voice on or off. Supported on all platforms.

  VOICE <voice_no> ON
  VOICE <voice_no> OFF

On [x16], ''ON'' turns on the voice in both left and right channels.

===== VOICE LEFT|RIGHT =====

[x16] Turns the voice on or off on the left or right channel only.

  VOICE <voice_no> LEFT
  VOICE <voice_no> RIGHT
===== VOICE TONE =====

Sets the tone (frequency) for a voice. Supported on all platforms.

  VOICE <voice_no> TONE <tone_number>

The //<tone_number>// means a different value on each platform.

  * On [c64] [c128] [m65] it represents the exact frequency as interpreted by the SID chip.
  * On [c16] [cplus4] it is a value that is passed to the TED chip. Please see the frequency tables in the [[https://archive.org/details/Programmers_Reference_Guide_for_the_Commodore_Plus_4_1986_Scott_Foresman_Co|Programmer's Reference Guide for the Commodore Plus/4]] (Appendix F).
  * On [vic20] each voice has different frequency ranges. Please see the frequency tables in the [[https://archive.org/details/VIC-20ProgrammersReferenceGuide1stEdition6thPrinti|Commodore VIC-20 Programmer's Reference]] (Page 97).
  * ON [x16], refer to the [[https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md#programmable-sound-generator-psg|PSG section section of the VERA Programmer's Reference]]

===== VOICE WAVE =====

Sets the wave form for a particular voice.

  VOICE <voice_no> WAVE SAW    ' sawtooth
  VOICE <voice_no> WAVE TRI    ' triangle
  VOICE <voice_no> WAVE PULSE  ' pulse
  VOICE <voice_no> WAVE NOISE  ' noise

  * On [c64] [c128] [x16] [m65], each voice can take any wave form.
  * On [c16] [cplus4], voice 1 is always ''PULSE'' and voice 2 can take ''PULSE'' or ''NOISE''
  * On [vic20], voices 1, 2 and 3 are always ''PULSE'' and voice 4 is always ''NOISE''
===== VOICE PULSE =====

Sets the pulse frequency for a particular voice. Only works if the waveform of that voice is set to ''PULSE''. Supported on [c64] [c128] [m65] only.

  VOICE <voice_no> WAVE PULSE PULSE <freq>
  
Frequency must be a value between 0 AND 4096.

===== VOICE ADSR =====

Sets the envelope for a particular voice. Supported on [c64] [c128] [m65] only.

  VOICE <voice_no> ADSR <attack>, <decay>, <sustain>, <release>

All four values are expressions that must evaluate to a number between 0 and 15.

===== VOICE FILTER ON|OFF =====

Applies or removes filter for the particular voice. The filter properties must be set using the [[FILTER]] command. Supported on [c64] [c128] [m65] only.

  VOICE <voice_no> FILTER ON
  VOICE <voice_no> FILTER OFF

===== VOICE VOLUME =====

Controls the volume of the sound with a logarithmic curve; 0 is silent, 63 is the loudest. Supported on [x16] only.

  VOICE <voice_no> VOLUME 0 ' Voice is silent
  VOICE <voice_no> VOLUME 63 ' Voice is loudest
===== See also =====

  * [[FILTER]]
  * [[SOUND_CLEAR]]
  * [[VOLUME]]
====== VOLUME ======

[vic20] [c64] [c16] [cplus4] [c128] [m65]

Sets the master volume for all voices.

===== Syntax =====

  VOLUME [<sid_number>,] <volume>

  * **<sid_number>** is optional and defines on which SID chip the filter values should be set. If it isn't provided, it defaults to 1. This parameter is useful on multi-SID systems, for example a C64 equipped with two SID chips, or the M65 that has four SID chips. The number must be between 1 and 4.
  * **<volume>** is an expression that evaluates to a number between 0 and 15.

===== Examples =====

  ' Set maximum volume
  VOLUME 15
  ' Make SID #2 silent
  VOLUME 2, 0

<adm note>
On [x16], volume for each voice can be set individually. See [[v3:voice#voice_volume|VOICE]].
</adm>
===== See also =====

  * [[FILTER]]
  * [[SOUND_CLEAR]]
  * [[VOICE]]
====== VSCROLL ======

[c64] [c16] [cplus4] [c128] [x16] [m65]

Sets the vertical smooth scrolling value.

===== Syntax =====

  ' On all Commodore platforms:
  VSCROLL <px>
  ' On the Commander X16:
  VSCROLL <layer>, <px> 

  * On [c64] [c16] [cplus4] [c128] [m65], ''<px>'' is a value between 0 and 7. The default scroll value is 3. Values bellow this will move the screen upwards, values above this will move it downwards.
  * On the [x16], ''<layer>'' is a literal 0 or 1 specifying which layer to scroll. ''<px>'' is a value between 0 and 4095.
===== See also =====

  * [[HSCROLL]]
====== WAIT ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''WAIT'' command is used to halt the program until the contents of a memory location changes in a specific way.

===== Syntax =====

  WAIT <address>, <mask> [, <trig>]

The contents of the memory location are first exciusive-ORed with <trig> (if present), and then logically ANDed with <mask>. If the result is zero, the program goes back to that memory location and checks again. When the result is nonzero, the program continues with the next statement.

Please read this [[https://www.atarimagazines.com/compute/issue32/076_1_ALL_ABOUT_COMMODORES_WAIT_INSTRUCTION.php|comprehensive article]] from Compute! Magazine for more information.
====== DO ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''DO ... LOOP'' block defines a pre-test or post-test loop.

===== Pre-test syntax =====

  DO WHILE|UNTIL <condition>
    <statements>
  LOOP

===== Post-test syntax =====

  DO
    <statements>
  LOOP WHILE|UNTIL <condition>

The former is used to test the condition before entering the loop body and the latter is used to test the condition after each iteration. This effectively means that post-test loop will be executed at least once, whereas in a pre-test loop the condition may fail the very first time and therefore it may happen that the statements in the loop will not be executed at all.

In both forms, you can either use the ''WHILE'' or ''UNTIL'' keywords. ''WHILE'' means that the loop is entered if the condition evaluates to true, ''UNTIL'' means that the loop is exited if the condition evaluates to true.

You can use the ''EXIT DO'' command to prematurely exit a ''DO … LOOP'' block, or ''CONTINUE DO'' to skip rest of the block and go to the next iteration.
====== WORD ======

The ''WORD'' keyword can be used in several statements to designate a variable or value as a 16-bit unsigned binary number. See [[v3:datatypes|]] and [[v3:dim|]] for more information.
====== WRITE# ======

[vic20] [c16] [cplus4] [c64] [c128] [m65]

The ''WRITE#'' command is used for saving the contents of a variable to a file. The file must be opened first using [[OPEN]].

  WRITE #<logical_file_no>, <expression> [, <exrpession>, ... ]

The ''WRITE#'' command is similar to [[PRINT_hash]] in that both commands output sequential data to a file. However, while ''PRINT#'' outputs PETSCII-encoded (textual) data, ''WRITE#'' outputs binary data. To illustrate:

  * ''PRINT#'' is used to store data that can be restored using [[INPUT_hash]]
  * ''WRITE#'' is used to store data that can be restored using [[READ]]

<adm warning>
The ''WRITE#'' command accepts any number of arguments of any type. As data will be output in a raw binary form, without separators, it is very important to make sure that each datum is in the exact same type and order that will be used when reading.
</adm>

For an in-depth explanation of file input-output operations with examples, please refer to [[fileio]].

<adm warning>
File I/O commands are not implemented for the Commodore PET.
</adm>

===== See also =====

  * [[OPEN]]
  * [[CLOSE]]
  * [[GET_hash]]
  * [[PRINT_hash]]
  * [[INPUT_hash]]
  * [[READ]]
  * [[ST]]
====== XOR ======

[pet] [vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''XOR'' operator performs a bitwise exclusive-or operation.

===== Syntax =====

  <operand> XOR <operand>

Both operands can be any type of numeric expression except FLOAT.
~~NOTOC~~ 

====== ABS ======

The ''ABS()'' function returns the absolute value of the passed numeric parameter.

===== Function Header =====

  DECLARE FUNCTION ABS AS BYTE (num AS BYTE) SHARED STATIC INLINE
  DECLARE FUNCTION ABS AS INT (num AS INT) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION ABS AS WORD (num AS WORD) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION ABS AS LONG (num AS LONG) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION ABS AS FLOAT (num AS FLOAT) OVERLOAD SHARED STATIC INLINE

===== Examples =====

  PRINT ABS(-1) : REM will print 1
  PRINT ABS(1) : REM will print 1
  n = -5400
  PRINT ABS(n) : REM will print 5400

~~NOTOC~~ 

====== ASC ======

The ''ASC()'' function takes the first char of a string and returns its numeric PETSCII code. If an empty string is provided, the function will return 0.

The inverse function of ''ASC()'' is ''[[v3:chr|]]''.

===== Function Header =====

  DECLARE FUNCTION ASC AS BYTE (char$ AS STRING) SHARED STATIC INLINE

===== Examples =====

  PRINT ASC("a") : REM will print 65
  PRINT ASC("abc") : REM will print 65
  PRINT ASC("") : REM will print 0
 


====== ATN ======

(Defined in //[[trigono.bas]]//)

The ''ATN()'' function returns the arctangent of the argument. It is the inverse function of [[TAN]].

===== Function header =====

  DECLARE FUNCTION ATN AS FLOAT (x AS FLOAT) SHARED STATIC

<adm warning>
You must include the //TRIGONO.BAS// library in your program to be able to access this function.
</adm>

===== Example =====

  INCLUDE "trigono.bas"
  PRINT ATN(0.5) : REM will output 0.464088

===== See also =====

  * [[TAN]]
  * [[SIN]]
  * [[COS]]
~~NOTOC~~ 

====== CBYTE ======

The ''CBYTE()'' function converts its argument to an unsigned 8-bit byte value.

===== Function header =====

  DECLARE FUNCTION CBYTE AS BYTE (arg AS INT) SHARED STATIC INLINE
  DECLARE FUNCTION CBYTE AS BYTE (arg AS WORD) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CBYTE AS BYTE (arg AS LONG) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CBYTE AS BYTE (arg AS FLOAT) OVERLOAD SHARED STATIC INLINE

If the argument is an ''INT'', ''WORD'' or ''LONG'' then the function will truncate the number to 8 bits, keeping the least significant byte and discarding the rest. If the argument is a ''FLOAT'' then it will be rounded, converted to fixed point, and then truncated to 8 bits.

===== Examples =====

  PRINT CBYTE(-1) : REM integer to byte, outputs 255
  PRINT CBYTE(65535) : REM word to byte, outputs 255
  PRINT CBYTE(100.4) : REM float to byte, outputs 100

====== CFLOAT ======

The ''CFLOAT()'' function converts its argument to a floating point value.

===== Function header =====

  DECLARE FUNCTION CFLOAT AS FLOAT (number AS BYTE) SHARED STATIC INLINE
  DECLARE FUNCTION CFLOAT AS FLOAT (number AS INT) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CFLOAT AS FLOAT (number AS WORD) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CFLOAT AS FLOAT (number AS LONG) OVERLOAD SHARED STATIC INLINE

<adm note>
To convert a string to floating point, see [[v3:val|]]
</adm>
====== CHR$ ======

The ''CHR$()'' function converts a number between 0 and 255 to its matching PETSCII character (as string).

The inverse function of ''CHR$()'' is ''[[v3:asc|]]''.

===== Function header =====

  DECLARE FUNCTION CHR$ AS STRING (charcode AS BYTE) SHARED STATIC INLINE

===== Examples =====

  PRINT CHR$(147): REM clear the screen

====== CINT ======

The ''CINT()'' function converts its argument to a signed 16-bit value.

===== Function header =====

  DECLARE FUNCTION CINT AS INT (number AS BYTE) SHARED STATIC INLINE
  DECLARE FUNCTION CINT AS INT (number AS WORD) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CINT AS INT (number AS LONG) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CINT AS INT (number AS FLOAT) OVERLOAD SHARED STATIC INLINE

If the argument is a ''LONG'', the number will be truncated to 16-bits. If the argument is a ''FLOAT'', it will be rounded and then converted to ''INTEGER''.

===== Examples =====

  PRINT CINT(65535) : REM converting WORD to INT. outputs -1
  PRINT CINT(1001.4) : REM converting FLOAT TO INT. outputs 1001

====== CLONG ======

The ''CLONG()'' function converts its argument to a signed 24-bit value.

===== Function header =====

  DECLARE FUNCTION CLONG AS LONG (number AS BYTE) SHARED STATIC INLINE
  DECLARE FUNCTION CLONG AS LONG (number AS INT) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CLONG AS LONG (number AS WORD) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CLONG AS LONG (number AS FLOAT) OVERLOAD SHARED STATIC INLINE

If the argument is a ''FLOAT'', it will be rounded and then converted to ''LONG''.

====== COS ======

(Defined in //[[trigono.bas]]//)

The ''COS()'' function returns the cosine of the argument.

===== Function Header =====

  DECLARE FUNCTION COS AS FLOAT (arg AS FLOAT) SHARED STATIC
  
<adm warning>
You must include the //TRIGONO.BAS// library in your program to be able to access this function.
</adm>

===== Examples =====

  INCLUDE "trigono.bas"
  PRINT COS(0) : REM outputs .999403
  PRINT COS(0.785398) : REM outputs .707704

<adm note>
Trigonometric functions in XC=BASIC were designed to be fast rather than accurate. The result is accurate to 3 to 4 decimal digits (the error range is 0 to 0.0006). Please see [[http://www.ganssle.com/approx.htm|this article]] for details.
</adm>

===== See also =====


  * [[TAN]]
  * [[ATN]]
  * [[SIN]]
====== CSRLIN ======

[c64] [vic20] [c16] [cplus4] [c128] [x16] [m65]

The ''CSRLIN()'' function returns the current row position of the cursor.

===== Function header =====

  DECLARE FUNCTION CSRLIN AS BYTE () SHARED STATIC INLINE

===== Example =====

  PRINT "the cursor is currently in row "; CSRLIN()

<adm warning>
This function does not work on the Commodore PET.
</adm>
===== See also =====

  * [[POS]]
  * [[LOCATE]]



====== CWORD ======

The ''CWORD()'' function converts its argument to an unsigned 16-bit value.

===== Function header =====

  DECLARE FUNCTION CWORD AS WORD (number AS BYTE) SHARED STATIC INLINE
  DECLARE FUNCTION CWORD AS WORD (number AS INT) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CWORD AS WORD (number AS LONG) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION CWORD AS WORD (number AS FLOAT) OVERLOAD SHARED STATIC INLINE

If the argument is a LONG, the number will be truncated to 16-bits. If the argument is a FLOAT, it will be rounded and then converted to WORD.

===== Examples =====

  PRINT CWORD(-1) : REM outputs 65535
  PRINT CWORD(1001.4) : REM outputs 1001

====== DEEK ======

The ''DEEK()'' function returns the content of the specified memory address plus one, as a 16-bit WORD. The return value is a number between 0 and 65535.

===== Function declaration =====

  DECLARE FUNCTION DEEK AS WORD (address AS WORD) SHARED STATIC INLINE
  ' MEGA65 only
  DECLARE FUNCTION DEEK AS WORD (address AS LONG) OVERLOAD SHARED STATIC INLINE  
===== Examples =====

  POKE $C000, $AB ' write value lo byte
  POKE $C001, $CD ' write value hi byte
  PRINT DEEK($C000) ' outputs 52651 (decimal for $CDAB)
====== ERR ======

The ''ERR()'' function returns the code of the last emitted error. It can be used in an [[error_handling|error handling routine]].


====== EXP ======

''EXP()'' is a mathematical function that evaluates the inverse natural logarithm of the argument, that is, the constant //e// (approx. 2.71828) raised to the power of the number given.

===== Function header =====

  DECLARE FUNCTION EXP AS FLOAT (num AS FLOAT) SHARED STATIC INLINE

===== Examples =====

  PRINT EXP(0.0) : REM outputs 1
  PRINT EXP(1.0) : REM outputs 2.71828
  PRINT EXP(2.0) : REM outputs 7.38906

===== See also =====

  * [[LOG]]
  * [[POW]]



====== FLOOR ======

The ''FLOOR()'' function returns the integer part of a floating point value, also as a floating point number.

<adm note>
The function is equivalent to CBM BASIC's ''INT()'' function. However, it has a different name in XC=BASIC due to conflict with the ''INT'' keyword.
</adm>
===== Function header =====

  DECLARE FUNCTION FLOOR AS FLOAT (num AS FLOAT) SHARED STATIC INLINE

===== Example =====

  PRINT FLOOR(3.14159) : REM outputs 3

<adm note>
To convert a floating point number to integer type, see [[v3:cint|]].
</adm>
====== JOY ======

[vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''JOY()'' function returns the status of either joysticks.

===== Function header =====

  DECLARE FUNCTION JOY AS BYTE (portnum AS BYTE) SHARED STATIC INLINE

Where //portnum// is an expression that evaluates to 1 or 2.

<adm note>
On the Commodore VIC-20, //portnum// is ignored.
</adm>

The return value is a BYTE where bits corresponding to a direction are set or unset. The direction to bit mapping if different on each target:

  * On [c64] [c128] [m65]:
    * Bit #0 is set if joystick is being pulled up
    * Bit #1 is set if joystick is being pulled down
    * Bit #2 is set if joystick is being pulled left
    * Bit #3 is set if joystick is being pulled right
    * Bit #4 is set if fire button is depressed
  * On [vic20]:
    * Bit #2 is set if joystick is being pulled up
    * Bit #3 is set if joystick is being pulled down
    * Bit #4 is set if joystick is being pulled left
    * Bit #5 is set if fire button is depressed
    * Bit #7 is set if joystick is being pulled right
  * On [c16] and [cplus4]: 
    * Bit #0 is set if joystick is being pulled up
    * Bit #1 is set if joystick is being pulled down
    * Bit #2 is set if joystick is being pulled left
    * Bit #3 is set if joystick is being pulled right
    * Bit #6 is set if fire button is depressed on joystick 1
    * Bit #7 is set if fire button is depressed on joystick 2

===== Example =====

Using the following example, you can read the joystick status on all platforms:

  ' Uncomment if target is VIC-20
  'CONST JOYUP = 4
  'CONST JOYDN = 8
  'CONST JOYLT = 16
  'CONST JOYRT = 128
  'CONST J1FIRE = 32
  
  ' Uncomment if target is C64
  'CONST JOYUP  = 1
  'CONST JOYDN  = 2
  'CONST JOYLT  = 4
  'CONST JOYRT  = 8
  'CONST J1FIRE = 16
  'CONST J2FIRE = 16
  
  ' Uncomment if target is C16 or C Plus/4
  'CONST JOYUP  = 1
  'CONST JOYDN  = 2
  'CONST JOYLT  = 4
  'CONST JOYRT  = 8
  'CONST J1FIRE = 64
  'CONST J2FIRE = 128
  
  DIM j AS BYTE
  lab:
    j = JOY(1)
    IF j = 0 THEN GOTO lab
    IF j AND JOYUP THEN PRINT " up";
    IF j AND JOYDN THEN PRINT " down";
    IF j AND JOYLT THEN PRINT " left";
    IF j AND JOYRT THEN PRINT " right";
    IF j AND J1FIRE THEN PRINT " fire";
    PRINT ""
    GOTO lab

====== KEY ======

[pet] [vic20] [c64] [c16] [cplus4] [c128]

The ''KEY()'' function tests whether a specified key is being depressed on the keyboard.

===== Function declaration =====

  DECLARE FUNCTION _
  KEY AS BYTE (scancode AS WORD) SHARED STATIC INLINE

For the list of scan codes on particular platforms, see [[v3:keyboard_scancodes|]].

===== Example =====

  CONST Q = 32576 ' scan code for Q key
  PRINT "press Q key to quit program"
  DO : LOOP UNTIL KEY(Q)
  PRINT "good bye"
  END


====== LCASE$ ======

The ''LCASE$()'' function converts all uppercase letters in its argument to their lowercase equivalent.

<adm note>
Lowercase letters, as well as non-alphabetical characters will not be affected.
</adm>

===== Function header =====

  DECLARE FUNCTION LCASE$ AS STRING (instr$ AS STRING) SHARED STATIC INLINE

===== Examples =====

  PRINT CHR$($0e) : REM switch to lowercase display
  PRINT LCASE$("THE String in LowerCase") : REM will output: "the string in lowercase"

===== See also =====

  * [[UCASE]]
====== LEFT$ ======

The ''LEFT$()'' function returns the specified number of characters from the left side of a string.

===== Syntax =====

  LEFT$(<input$>, <n>)

<n> is the number of chars to be returned. If it is greater than the string length then the entire string will be returned.

===== Example =====

  DIM in$ AS STRING * 30
  in$ = "xc=basic programming language"
  PRINT LEFT$(in$, 8) : REM outputs: xc=basic

===== See also =====

  * [[v3:right|]]
  * [[v3:mid|MID$]]

====== LEN ======

The ''LEN()'' function counts the number of characters in a string.

===== Function header =====

  DECLARE FUNCTION LEN AS BYTE (arg$ AS STRING) SHARED STATIC INLINE

If the argument is a variable, the function will return the actual length of the string, rather than the length to which the variable was defined.

===== Examples =====

  PRINT LEN("") : REM outputs 0
  PRINT LEN("hello") : REM outputs 5
  DIM a$ AS STRING * 16
  a$ = "world"
  PRINT LEN(a$) : REM outputs 5 (the actual length of the string)


====== LOG ======

The ''LOG()'' function returns the natural logarithm (log to the base of //e//) of the argument.

===== Function header =====

  DECLARE FUNCTION LOG AS FLOAT (num AS FLOAT) SHARED STATIC INLINE

===== Examples =====

  PRINT LOG(1.0) : REM outputs a number very close to zero
  PRINT LOG(10.0) : REM outputs 2.30259
  PRINT LOG(100.0) / LOG(10.0) : REM outputs 2

===== See also =====

  * [[EXP]]
  * [[POW]]



====== MID$ ======

The ''MID$()'' funcition returns //<length>// characters from a sring, starting from //<position>//.

===== Syntax =====

  MID$(<input$>, <position>,  <length>)

<adm warning>
 Unlike in CBM BASIC, the character position is zero-based, i. e. the first character's position is 0.
</adm>

===== Example =====

  DIM in$ AS STRING * 30
  in$ = "xc=basic programming language"
  PRINT MID$(in$, 9, 11) : REM outputs: programming

===== See also =====

  * [[v3:left|]]
  * [[v3:right]]

====== PEEK ======

The ''PEEK()'' function returns the content of the specified memory address. The return value is a number between 0 and 255.

===== Function declaration =====

  DECLARE FUNCTION PEEK AS BYTE (address AS WORD) SHARED STATIC INLINE
  ' MEGA65 only
  DECLARE FUNCTION PEEK AS BYTE (address AS LONG) OVERRIDE SHARED STATIC INLINE  
===== Examples =====

  POKE $c000, 127 : REM write value
  PRINT PEEK($c000) : REM read value
====== POS ======

[c64] [vic20] [c16] [cplus4] [c128] [x16] [m65]

The ''POS()'' function returns the current column position of the cursor.

===== Function header =====

  DECLARE FUNCTION POS AS BYTE () SHARED STATIC INLINE

===== Example =====

  PRINT "after printing this text{13}the cursor will be in column: ";
  PRINT POS()

<adm warning>
This function does not work on the Commodore PET.
</adm>
===== See also =====

  * [[CSRLIN]]
  * [[LOCATE]]



====== POW ======

The ''POW()'' function computes the power of a number.
===== Function header =====

  DECLARE FUNCTION POW AS FLOAT (base AS FLOAT, exp AS FLOAT) SHARED STATIC INLINE
  DECLARE FUNCTION POW AS LONG (base AS INT, exp AS BYTE) OVERLOAD SHARED STATIC INLINE

<adm note>
The CBM BASIC expression ''base↑exp'' can be translated to **XC=BASIC** as ''POW(base, exp)''.
</adm>
===== Example =====

  PRINT POW(2, 10) : REM outputs 1024

===== See also =====

  * [[SQR]]

====== RIGHT$ ======

The ''RIGHT$()'' function returns the specified number of characters from the right side of a string.

===== Syntax =====

  RIGHT$(<input$>, <n>)

<n> is the number of chars to be returned. If it is greater than the string length then the entire string will be returned.

===== Example =====

  DIM in$ AS STRING * 30
  in$ = "xc=basic programming language"
  PRINT RIGHT$(in$, 20) : REM outputs: programming language

===== See also =====

  * [[v3:left|]]
  * [[v3:mid|MID$]]

====== RND ======

The ''RND()'' function returns a pseudo-random floating point number, between 0 and 1.

===== Function header =====

  DECLARE FUNCTION RND AS FLOAT () SHARED STATIC INLINE

===== Example =====

  ' Display a sequence of 10 random numbers
  RANDOMIZE TI()
  FOR i AS BYTE = 1 TO 10
    PRINT RND()
  NEXT

===== See also =====

  * [[RANDOMIZE]]
  * [[RNDB]]
  * [[RNDI]]
  * [[RNDW]]
  * [[v3:rndl|]]

====== RNDB ======

The ''RNDB()'' function returns a pseudo-random 8-bit unsigned number, between 0 and 255.

===== Function header =====

  DECLARE FUNCTION RNDB AS BYTE () SHARED STATIC INLINE

===== Example =====

  ' Display a sequence of 10 random numbers
  RANDOMIZE TI()
  FOR i AS BYTE = 1 TO 10
    PRINT RNDB()
  NEXT

===== See also =====

  * [[RANDOMIZE]]
  * [[RNDI]]
  * [[RNDW]]
  * [[RNDL]]
  * [[v3:rnd|]]
====== RNDI ======

The ''RNDI()'' function returns a pseudo-random 16-bit signed number, between -32,768 and 32,767.

===== Function header =====

  DECLARE FUNCTION RNDI AS INT () SHARED STATIC INLINE

===== Example =====

  ' Display a sequence of 10 random numbers
  RANDOMIZE TI()
  FOR i AS BYTE = 1 TO 10
    PRINT RNDI()
  NEXT

===== See also =====

  * [[RANDOMIZE]]
  * [[RNDB]]
  * [[RNDW]]
  * [[RNDL]]
  * [[v3:rnd|]]
====== RNDL ======

The ''RNDL()'' function returns a pseudo-random 24-bit signed number, between -8,388,608 and 8,388,607.

===== Function header =====

  DECLARE FUNCTION RNDL AS LONG () SHARED STATIC INLINE

===== Example =====

  ' Display a sequence of 10 random numbers
  RANDOMIZE TI()
  FOR i AS BYTE = 1 TO 10
    PRINT RNDL()
  NEXT

===== See also =====

  * [[RANDOMIZE]]
  * [[RNDB]]
  * [[RNDI]]
  * [[RNDW]]
  * [[v3:rnd|]]
====== RNDW ======

The ''RNDW()'' function returns a pseudo-random 16-bit unsigned number, between 0 and 65,535.

===== Function header =====

  DECLARE FUNCTION RNDW AS WORD () SHARED STATIC INLINE

===== Example =====

  ' Display a sequence of 10 random numbers
  RANDOMIZE TI()
  FOR i AS BYTE = 1 TO 10
    PRINT RNDW()
  NEXT

===== See also =====

  * [[RANDOMIZE]]
  * [[RNDB]]
  * [[RNDI]]
  * [[RNDL]]
  * [[v3:rnd|]]
====== SCAN ======

[vic20] [c64] [c16] [cplus4] [c128] [x16] [m65]

The ''SCAN()'' function tells which scan line is currently draw on the screen.

===== Function declaration =====

  DECLARE FUNCTION _
  SCAN AS WORD () SHARED STATIC INLINE

===== Example =====

  ' A simple raster effect
  SYSTEM INTERRUPT OFF
  start:
  DO : LOOP WHILE SCAN() < 160
  BORDER 3
  DO : LOOP WHILE SCAN() > 10
  BORDER 0
  GOTO start
====== SGN ======

The ''SGN()'' function returns the sign of a numerical argument as follows:

^Argument^Result^
|negative value|-1|
|zero|0|
|positive value (excluding zero)| 1|

===== Function header =====

  DECLARE FUNCTION SGN AS INT (num AS BYTE) SHARED STATIC INLINE
  DECLARE FUNCTION SGN AS INT (num AS INT) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION SGN AS INT (num AS WORD) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION SGN AS INT (num AS LONG) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION SGN AS INT (num AS FLOAT) OVERLOAD SHARED STATIC INLINE

====== SHL ======

The ''SHL()'' function returns a number bit-shifted //<n>// positions to the left.

===== Function header =====

  DECLARE FUNCTION SHL AS BYTE (num AS BYTE, n AS BYTE) SHARED STATIC INLINE
  DECLARE FUNCTION SHL AS INT (num AS INT, n AS BYTE) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION SHL AS WORD (num AS WORD, n AS BYTE) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION SHL AS LONG (num AS LONG, n AS BYTE) OVERLOAD SHARED STATIC INLINE

Each bit in the number will be moved //<n>// positions to the left. The least significant bit will be filled with zero, whereas the most significant bit will be discarded.

<adm note>
Since ''SHL(number, n)'' equals ''number * pow(2, n)'', the function is especially useful if you want to multiply a number by powers of two. Bit shifting is carried out much faster than the multiplication operation.
</adm>

===== Example =====

  PRINT SHL(41, 1) : REM outputs 82
  PRINT SHL(%00001111, 4) : REM outputs 240 (binary 11110000)
  PRINT SHL(%10000000, 1) : REM outputs 0 because the MSB is discarded
  PRINT SHL(CWORD(%10000000), 0) : REM outputs 256 because this time
                                      REM the argument is 16 bits wide

===== See also =====

  * [[SHR]]
====== SHR ======

The ''SHR()'' function returns a number bit-shifted //<n>// positions to the right.

===== Function header =====

  DECLARE FUNCTION SHR AS BYTE (num AS BYTE, n AS BYTE) SHARED STATIC INLINE
  DECLARE FUNCTION SHR AS INT (num AS INT, n AS BYTE) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION SHR AS WORD (num AS WORD, n AS BYTE) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION SHR AS LONG (num AS LONG, n AS BYTE) OVERLOAD SHARED STATIC INLINE

Each bit in the number will be moved //<n>// positions to the right.

  * If the number is unsigned (BYTE or WORD), the most significant bit gets filled with a zero. 
  * If the number is signed (INT or LONG), signed right shifting is carried out, i. e. the most significant bit will be filled with the sign.

The least significant bit is discarded in all cases.

<adm note>
Since ''SHR(number, n)'' equals ''number / pow(2, n)'', the function is especially useful if you want to divide a number by powers of two. Bit shifting is carried out much faster than the division operation.
</adm>

===== Example =====

  PRINT SHR(82, 1) : REM outputs 41
  PRINT SHR(%11110000, 4) : REM outputs 15 (binary 00001111)
  PRINT SHR(%00000001, 1) : REM outputs 0 because the LSB is discarded

===== See also =====

  * [[SHL]]

====== SIN ======

(Defined in //[[trigono.bas]]//)

The ''SIN()'' function returns the sine of the argument.

===== Function Header =====

  DECLARE FUNCTION SIN AS FLOAT (x AS FLOAT) SHARED STATIC
  
<adm warning>
You must include the //TRIGONO.BAS// library in your program to be able to access this function.
</adm>


===== Examples =====

  INCLUDE "trigono.bas"
  PRINT SIN(0) : REM outputs a number very close to zero, see the below note
  PRINT SIN(0.785398) : REM outputs .707704

<adm note>
Trigonometric functions in XC=BASIC were designed to be fast rather than accurate. The result is accurate to 3 to 4 decimal digits (the error range is 0 to 0.0006). Please see [[http://www.ganssle.com/approx.htm|this article]] for details.
</adm>

===== See also =====

  * [[TAN]]
  * [[ATN]]
  * [[COS]]
====== SPRITEBGHIT ======

[c64] [c128] [m65]

Checks for sprite to background collision.

===== Function declaration =====

  DECLARE FUNCTION _
  SPRITEBGHIT AS BYTE (sprno AS BYTE) SHARED STATIC INLINE

If the sprite specified by <spro> has previously come in contact with the background graphics, the function will return 255 (true), 0 (false) otherwise.

<adm note>
Sprite number must be a number between 0 and 7.
</adm>
===== Example =====

  SPRITE CLEAR HIT
  DO
  ' <game looop...>
  LOOP UNTIL SPRITEBGHIT(0)
  PRINT "the airplane has crashed!"

===== See also =====

  * [[SPRITE]]

====== SPRITEHIT ======

[c64] [c128] [m65]

Checks for sprite to sprite collision.

===== Function declaration =====

  DECLARE FUNCTION _
  SPRITEHIT AS BYTE (sprno AS BYTE) SHARED STATIC INLINE

If the sprite specified by <spro> has previously come in contact with any other sprite(s), the function will return 255 (true), 0 (false) otherwise.

<adm note>
Sprite number must be a number between 0 and 7.
</adm>
===== Example =====

  SPRITE CLEAR HIT
  DO
  ' <game looop...>
  LOOP UNTIL SPRITEHIT(0)
  PRINT "booom!!!"
===== See also =====

  * [[sprites]]

====== SQR ======

The ''SQR()'' function returns the square root of a number.

===== Function header =====

  DECLARE FUNCTION SQR AS BYTE (num AS INT) SHARED STATIC INLINE
  DECLARE FUNCTION SQR AS BYTE (num AS WORD) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION SQR AS WORD (num AS LONG) OVERLOAD SHARED STATIC INLINE
  DECLARE FUNCTION SQR AS FLOAT (num AS FLOAT) OVERLOAD SHARED STATIC INLINE

If the argument is a FLOAT, the return value will also be a FLOAT, as accurate as possible. However if the argument is an INT, WORD or LONG, the return value will be a BYTE or WORD, without any fractional part. 

===== Examples =====

  PRINT SQR(2) : REM outputs 1
  PRINT SQR(2.0) : REM outputs 1.41421

In the first line, the argument is 2. Since 2 doesn't have a fractional part, the compiler will treat it as a BYTE. When calling ''SQR()'', the compiler will find the function from the above list that is the most suitable for the argument, that is the one with the INT argument. Calling that function will result in a BYTE, an 8-bit number with no fractional part.

In the second line we use the literal 2.0 that the compiler recognizes as FLOAT and therefore the best match is the function accepting a FLOAT argument and returning a FLOAT.

===== See also =====

  * [[POW]]

====== ST ======

The ''ST()'' function returns the status after the last input-output operation, for example during a disk or tape read or write.

===== Function header =====

  DECLARE FUNCTION ST AS BYTE () SHARED STATIC INLINE

===== Example =====

  REM -- dump raw contents of a file
  DIM char$ AS STRING * 1
  CONST EOF = 64
  OPEN 2, 8, 2, "filename"
  DO WHILE ST() <> EOF
    GET #2, char$
    PRINT char$;
  LOOP
  CLOSE 2

===== See also =====

  * [[OPEN]]
  * [[GET_hash|GET#]]
  * [[INPUT_hash|INPUT#]]
  * [[PRINT_hash|PRINT#]]
  * [[READ]]
  * [[WRITE]]
  * [[CLOSE]]

====== STR$ ======

The ''STR$()'' function converts any type of numeric value into string.

===== Function header =====

  DECLARE FUNCTION STR$ AS STRING (number AS BYTE) SHARED STATIC INLINE
  DECLARE FUNCTION STR$ AS STRING (number AS INT) OVERRIDE SHARED STATIC INLINE
  DECLARE FUNCTION STR$ AS STRING (number AS WORD) OVERRIDE SHARED STATIC INLINE
  DECLARE FUNCTION STR$ AS STRING (number AS LONG) OVERRIDE SHARED STATIC INLINE
  DECLARE FUNCTION STR$ AS STRING (number AS FLOAT) OVERRIDE SHARED STATIC INLINE
  DECLARE FUNCTION STR$ AS STRING (number AS DECIMAL) OVERRIDE SHARED STATIC INLINE
  
===== Examples =====

  DIM msg$ AS STRING * 20
  amount = 300
  msg$ = "you have " + STR$(amount) + " points"

<adm note>
When converting a ''DECIMAL'' number to string, leading zeroes will also be included.
</adm>

  DIM a$ AS STRING * 4
  a$ = STR$(99d)
  PRINT a$ : REM will output 0099

<adm warning>
Converting numeric types to strings can take a considerable amount of CPU cycles. The only exception is the ''DECIMAL'' type that is very quickly converted to string. Consider using the ''DECIMAL'' type if you need to output numbers where speed is crucial.
</adm>
====== TAN ======

(Defined in //[[trigono.bas]]//)

The ''TAN()'' function returns the arctangent of the argument. The inverse function of ''TAN()'' is [[ATN]].

===== Function header =====

  DECLARE FUNCTION TAN AS FLOAT (x AS FLOAT) SHARED STATIC

<adm warning>
You must include the //TRIGONO.BAS// library in your program to be able to access this function.
</adm>

===== Example =====

  INCLUDE "trigono.bas"
  PRINT TAN(PI / 4) : REM outputs a number very close to 1, see below note

<adm note>
Trigonometric functions in XC=BASIC were designed to be fast rather than accurate. The result is accurate to 3 to 4 decimal digits (the error range is 0 to 0.0006). Please see [[http://www.ganssle.com/approx.htm|this article]] for details.
</adm>
===== See also =====

  * [[ATN]]
  * [[SIN]]
  * [[COS]]
====== TI ======

[vic20] [c64] [c16] [cplus4] [c128]

The ''TI()'' function returns the total count of jiffies (1/60 second time increments) since power-on. It returns the same value as the system variable ''TI'' in CBM BASIC.

===== Header =====

  DECLARE FUNCTION TI AS LONG () SHARED STATIC INLINE
  
===== Examples =====

  PRINT "seconds since power-on: "; TI() / 60

====== UCASE$ ======

The ''UCASE$()'' function converts all lowercase letters in a string to their uppercase equivalent.

<adm note>
Uppercase letters, as well as non-alphabetical characters will not be affected.
</adm>

===== Function header =====

  DECLARE FUNCTION UCASE$ AS STRING (instr$ AS STRING) SHARED STATIC INLINE

===== Examples =====

  PRINT CHR$($0e) : REM switch to lowercase display
  PRINT UCASE$("THE String in UpperCase") : REM will output: "THE STRING IN UPPERCASE"

===== See also =====

  * [[LCASE]]

====== VAL ======

The ''VAL()'' function converts a string to a floating point number.

===== Function header =====

  DECLARE FUNCTION VAL AS FLOAT (instr$ AS STRING) SHARED STATIC INLINE

===== Examples =====

  DIM pi AS FLOAT
  pi = VAL("3.14159")



