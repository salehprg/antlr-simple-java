grammar JavaSMP;

start : (importType | class | variables) * EOF;

actions : (variables | functions | for | voids)*;

//----------Imports-----------

packageName : Identifier('.'Identifier)*;
importAs : packageName '=>' Identifier ;
fromImport : From packageName (Import (All | (importAs | packageName)(','(importAs | packageName))*)) EndLine  ;
imports : Import packageName(','packageName)* EndLine;

importType : fromImport | imports;

//---------------------------

//------------Variables---------

decType : Var | Const;
variableName : Identifier;
object_name : Identifier;
dataType : NumericalDataType | CharacterDataType | 'new' (Array | object_name) ('<' dataType '>')? '(' objectAssignValue? ')' ;

initValue : Float | Number | StringValue | Array'(' objectAssignValue? ')' | variableName('.'variableName)*;

assignValue : AssignmentSign initValue;
objectAssignValue : initValue (','initValue)*;
typeAndAssign : ':' dataType assignValue?;
varInfo : variableName (assignValue? | typeAndAssign);

declareVariable : AccessType? (decType | dataType) varInfo(','varInfo)* EndLine;
assignVariable : (This '.')? Identifier assignValue EndLine;

variables : declareVariable | assignVariable;

//---------------------------

//----------Voids-------------

voids : Identifier '.' Identifier '(' objectAssignValue ')' EndLine;

//---------------
//------------Functions----------

functionInput : dataType varInfo (',' dataType varInfo)*;
functionBody : actions (Return initValue EndLine)? ;
functions : AccessType? dataType? Identifier '(' functionInput ')' '{' functionBody '}' ;

//-------------------------------


//-----------------for--------
iterator_name : Identifier;

initialization : NumericalDataType? variableName AssignmentSign Number ;
conditions : initValue ConditioanlSign initValue (ConditionCheck conditions)*;
incdec : variableName AssignmentSign;
forBody : actions;

normalFor : initialization EndLine conditions EndLine incdec;
iteratorFor : decType variableName 'in' iterator_name;

for : For '(' (normalFor | iteratorFor) ')' '{' forBody '}';

//---------------------------

//-----------------while--------

while : For '(' (normalFor | iteratorFor) ')' '{' forBody '}';

//---------------------------

//------------Classes-----------

className : Identifier;
parentName : Identifier;
implementName : Identifier;

extend : Extends parentName;
implements : Implements implementName ('with' implementName)*;

classBody : '{' actions '}';

class : Class className  extend? implements? classBody;
//---------------------------

AssignmentSign : '+=' | '-=' | '=' | '++' | '--';


For : 'for';
While : 'while';
ConditioanlSign : '<' | '>' | '<=' | '>=';
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
