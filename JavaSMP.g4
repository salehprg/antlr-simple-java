grammar JavaSMP;

start : (importType | class | variables) * EOF;

actions : (variables | functions | for | voids | while | do | if | switch)*;

//----------Imports-----------

packageName : Identifier('.'Identifier)*;
importAs : packageName '=>' Identifier ;
fromImport : From packageName (Import (All | (importAs | packageName)(','(importAs | packageName))*)) EndLine  ;
imports : Import packageName(','packageName)* EndLine;

importType : fromImport | imports;

//---------------------------

//------------Variables---------

normalValue : Float | Number | StringValue | variableName('.'variableName)*;
decType : Var | Const;
variableName : Identifier;
object_name : Identifier;
dataType : NumericalDataType | CharacterDataType | 'new' (Array | object_name) ('<' dataType '>')? '(' objectAssignValue? ')' ;

operations : normalValue (OperationSign normalValue)*;

initValue : normalValue  | Array'(' objectAssignValue? ')' | variableName('.'variableName)* | operations;


assignValue : AssignmentSign initValue;
objectAssignValue : initValue (','initValue)*;
typeAndAssign : ':' dataType assignValue?;
varInfo : variableName (assignValue? | typeAndAssign);

declareVariable : AccessType? (decType | dataType) varInfo(','varInfo)* EndLine;
assignVariable : (This '.')? Identifier assignValue EndLine;

variables : declareVariable | assignVariable;

//---------------------------

//----------Voids-------------

objectVoid : Identifier('.' Identifier)* '(' objectAssignValue ')' EndLine;
voids : objectVoid;

//---------------
//------------Functions----------

functionInput : dataType varInfo (',' dataType varInfo)*;
functionBody : actions (Return initValue EndLine)? ;
functions : AccessType? dataType? Identifier '(' functionInput ')' '{' functionBody '}' ;

//-------------------------------

conditions : initValue ConditioanlSign initValue (ConditionCheck conditions)*;

//-----------------for--------
iterator_name : Identifier;

initialization : NumericalDataType? variableName AssignmentSign Number ;
incdec : variableName AssignmentSign;
forBody : actions;

normalFor : initialization EndLine conditions EndLine incdec;
iteratorFor : decType variableName 'in' iterator_name;

for : For '(' (normalFor | iteratorFor) ')' '{' forBody '}';

//---------------------------

//-----------------while--------

whileBody : actions;
while : While '(' conditions ')' '{' whileBody '}';

//---------------------------

//-------------DoWhile-----------

doBody : actions;
do : Do '{' doBody '}' While '(' conditions ')' ;

//---------------------------

//-----------------If----------

ifBody : actions;
elseIf : ElseIf '(' conditions ')' '{' ifBody '}';
else : Else  '{' ifBody '}';

if : If '(' conditions ')' '{' ifBody '}' elseIf* else?;

//------------------------------

//-------------Switch--------
caseBody : actions;
expression : Number | Float | StringValue | variableName;
default : Default ':' actions (Break EndLine)?;

switchBody : Case expression ':' caseBody (Break EndLine)? ;

switch : Switch '('expression')' '{' switchBody* default?'}';
//---------------------------


//-------------TryCatch-----------

exception_name : Identifier;
catchh : Catch '(' variableName ')';

try : Try '{' actions '}' ( (On exception_name (catchh)? '{' actions '}')? (catchh '{' actions '}')?);

//--------------------------
//------------Classes-----------

className : Identifier;
parentName : Identifier;
implementName : Identifier;

extend : Extends parentName;
implements : Implements implementName ('with' implementName)*;

classBody : '{' actions  try? '}';

class : Class className  extend? implements? classBody;
//---------------------------

AssignmentSign : '+=' | '-=' | '=' | '++' | '--';
OperationSign : '+' | '-' | '*' | '/';

Try : 'try';
On : 'on';
Catch : 'catch';

Switch : 'switch';
Case : 'case';
Break : 'break';
Default : 'default';

If : 'if';
Else : 'else';
ElseIf : 'elif';

For : 'for';

While : 'while';
Do : 'do';

ConditioanlSign : '<' | '>' | '<=' | '>=' | '==';
GT : '>';
LT : '<';
LE : '<=';
GE : '>=';

ConditionCheck : '&&' | '||';
This : 'this';
Class : 'class';
Return : 'return';
Extends : 'extends';
Implements : 'implements';

AccessType : 'public' | 'private' | 'protected' ;
Var : 'var';
Const : 'const';

NumericalDataType : 'Int' | 'Double' | 'float';
Array : 'Array';
CharacterDataType : 'String' | 'char';

StringValue : '"' StringCharacters? '"';

fragment
StringCharacters :	~["\\]+;

Sign : '+' | '-';
All : '*';
EndLine : ';';
From : 'from';
Import : 'import';

Identifier : Letter LetterOrDigit*;


Float : Digits+ '.' Digits* | '.'Digits+ | Digits'.' Digits+'e'Sign Digits+;


Number : Digits+;

LetterOrDigit : [a-zA-Z0-9];
Digits : [0-9];
Letter : [a-zA-Z];


WS : [ \t\r\n\u000C]+ -> channel(HIDDEN);

COMMENT :   '/*' .*? '*/' -> channel(HIDDEN);
LINE_COMMENT : '//' ~[\r\n]* -> channel(HIDDEN);
