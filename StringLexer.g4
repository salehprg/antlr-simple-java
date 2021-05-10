lexer grammar StringLexer;

//------------Operations------------
Bitwise : '&' | '^' | '|' | '<<' | '>>';

OpAndAssign : '//=' | '*='| '+=' | '-=';
AssignmentSign : '=' ;
Power : '**';
Multi : '*';

Divide : '/';
DivideInt : '//';

Add : '+';
Sub : '-';

UnaryOp : '--' | '++';
Unary : '-' | '+';
//----------------------------------

//------------Exeptions------------
Try : 'try';
On : 'on';
Catch : 'catch';
//----------------------------------

//------------Switch----------------
Switch : 'switch';
Case : 'case';
Break : 'break';
Default : 'default';
//----------------------------------

//--------------If------------------
If : 'if';
Else : 'else';
ElseIf : 'elif';
//----------------------------------

//--------------Loop----------------
For : 'for';

While : 'while';
Do : 'do';
//----------------------------------

//-------------Comparison-----------
ConditionCheck : And | Or | Not | '&&' | '||';
Comparison : LT | GT | LE | GE | '==' | '!=';
GT : '>';
LT : '<';
LE : '<=';
GE : '>=';
//----------------------------------

//------------Special Names---------
From : 'from';
Import : 'import';

Percent : '%';
Comma : ',';
Dot : '.';
Not : 'not';
And : 'and';
Or : 'or';

New : 'new';

LCruse : '[';
RCruse : ']';

LParantesis : '(';
RParantesis : ')';

In : 'in';
Forward : '=>';
With : 'with';

This : 'this';
Class : 'class';
Return : 'return';
Extends : 'extends';
Implements : 'implements';

AccessType : 'public' | 'private' | 'protected' ;
Var : 'var';
Const : 'const';

TwoDot : ':';
EndLine : ';';
//----------------------------------

//-------------Data Types-----------
Void : 'void';
NumericalDataType : 'int' | 'double' | 'float';
Array : 'Array';
CharacterDataType : 'string' | 'char';
Bool : 'Boolean' | 'bool';
//----------------------------------



//-------------Basic Lexers---------
Identifier : Letter Letter LetterOrDigit*;

Float : Digits+ '.' Digits* | '.'Digits+ | Digits'.' Digits+'e'Unary Digits+;

Number : Digits+;

LBracet : '{';
RBracet : '}';

LetterOrDigit : [a-zA-Z0-9$_];
Digits : [0-9];
Letter : [a-zA-Z$_];

WS : [ \t\r\n\u000C]+ -> skip;
COMMENT :   '/*' .*? '*/' -> skip;
LINE_COMMENT : '/~' ~[\r\n]* -> skip;

DQUOTE: '"' -> pushMode(IN_STRING);
Interp_Start: '${' -> pushMode(EMBEDDED);
End_Interp : '}';

mode IN_STRING;
TEXT: ~[$"]+ ;
BACKSLASH_PAREN: '${' -> pushMode(EMBEDDED);
ESCAPE_SEQUENCE: '$' . ;
DQUOTE_IN_STRING: '"' -> type(DQUOTE), popMode;

mode EMBEDDED;
E_Skip : [ ] -> skip;
E_IDENTIFIER: [a-zA-Z0-9$_] [a-zA-Z0-9$_]+ -> type(Identifier);
E_Sign: '+' -> type(Add);
E_Sub: '-' -> type(Sub);
E_Power: '**' -> type(Power);
E_Multi: '*' -> type(Multi);
E_Divide: '/' -> type(Divide);
E_DivideInt: '//' -> type(DivideInt);
E_UnaryOp: ('--' | '++') -> type(UnaryOp);
E_Unary: ('-' | '+')-> type(Unary);

E_Number: [0-9]+ -> type(Number);
E_DQUOTE: '"' -> pushMode(IN_STRING), type(DQUOTE);
E_Interp_Start: '{' -> type(Interp_Start), pushMode(EMBEDDED);
E_End_Interp: '}' -> type(End_Interp), popMode;