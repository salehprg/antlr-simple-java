grammar JavaSMP;

start : imports  class EOF;

actions : (variables | functions)*;
internalActions : (variables | for | voids | while | do | if | switch | try)*;

//----------------------------Imports---------------------------------------

packageName : Identifier('.'Identifier)*;
importAs : packageName '=>' Identifier ;

singleImport : importAs | packageName;
multiImport : (importAs | packageName)(','(importAs | packageName))+;

fromImport : From packageName Import ('*' | multiImport | singleImport) EndLine  ;
normalImport : Import packageName(','packageName)* EndLine;

importType : fromImport | normalImport;

imports : importType*;

//--------------------------------------------------------------------------

//-------------------------------Variables----------------------------------
//stringExpr : ;
stringValue : StringValue;

expr : '-' expr
   | UnaryOp expr | expr UnaryOp
   | expr mulop expr
   | expr addop expr
   | '(' expr ')'
   | normalValue
   ;

addop : Add | Sub ;
mulop : Multi | Divide | DivideInt | '%' ;

normalValue : Float | Number | stringValue | variableName('.'variableName)*;
decType : Var | Const;
variableName : Identifier;
object_name : Identifier;
withType : '[' dataType ']';
objectType : New (Array | object_name) withType? ;
dataType : Void | NumericalDataType | CharacterDataType | objectType LParantesis objectAssignValue? RParantesis ;

//operations : normalValue (( OperationSign | Multi) normalValue)*;
operations : expr ;

initValue : operations | normalValue  | Array LParantesis objectAssignValue? RParantesis ;


assignValue : (AssignmentSign | OpAndAssign) initValue;
objectAssignValue : initValue (','initValue)*;
typeAndAssign : ':' dataType assignValue?;
varInfo : variableName (assignValue? | typeAndAssign);

declareVariable : AccessType? (decType | dataType) varInfo(','varInfo)* EndLine;
assignVariable : (This '.')? Identifier assignValue EndLine;

variables : declareVariable | assignVariable;

//--------------------------------------------------------------------------

//--------------------------------Voids-------------------------------------

objectVoid : Identifier('.' Identifier)* LParantesis objectAssignValue RParantesis EndLine;
voids : objectVoid;

//--------------------------------------------------------------------------
//--------------------------------Functions---------------------------------

functionInput : dataType varInfo (',' dataType varInfo)*;
functionBody : internalActions (Return initValue EndLine)? ;
functions : AccessType? dataType Identifier LParantesis functionInput? RParantesis LBracet functionBody RBracet ;

//--------------------------------------------------------------------------

conditions : initValue Comparison initValue (ConditionCheck conditions)*;

//----------------------------------for-------------------------------------
iterator_name : Identifier;

initialization : NumericalDataType? variableName (AssignmentSign | OpAndAssign) Number ;
incdec : variableName (AssignmentSign | OpAndAssign);
forBody : internalActions;

normalFor : initialization EndLine conditions EndLine incdec;
iteratorFor : decType variableName 'in' iterator_name;

for : For LParantesis (normalFor | iteratorFor) RParantesis LBracet forBody RBracet;

//--------------------------------------------------------------------------

//------------------------------------while---------------------------------

whileBody : internalActions;
while : While LParantesis conditions RParantesis LBracet whileBody RBracet;

//--------------------------------------------------------------------------

//------------------------------------DoWhile-------------------------------

doBody : internalActions;
do : Do LBracet doBody RBracet While LParantesis conditions RParantesis ;

//--------------------------------------------------------------------------

//--------------------------------------If----------------------------------

ifBody : internalActions;
elseIf : ElseIf LParantesis conditions RParantesis LBracet ifBody RBracet;
else : Else  LBracet ifBody RBracet;

if : If LParantesis conditions RParantesis LBracet ifBody RBracet elseIf* else?;

//--------------------------------------------------------------------------

//--------------------------------------Switch------------------------------

caseBody : internalActions;
expression : Number | Float | StringValue | variableName;
default : Default ':' internalActions (Break EndLine)?;

switchBody : Case expression ':' caseBody (Break EndLine)? ;

switch : Switch LParantesis expression RParantesis LBracet switchBody* default? RBracet;

//--------------------------------------------------------------------------

//--------------------------------------TryCatch----------------------------

exception_name : Identifier;
catchh : Catch LParantesis variableName RParantesis;

try : Try LBracet internalActions RBracet ( (On exception_name (catchh)? LBracet internalActions RBracet)? (catchh LBracet internalActions RBracet)?);

//--------------------------------------------------------------------------
//----------------------------------------Classes---------------------------

className : Identifier;
parentName : Identifier;
implementName : Identifier;

extend : Extends parentName;
implements : Implements implementName (With implementName)*;

classBody : LBracet actions? constructor? actions RBracet;

class : Class className  extend? implements? classBody;

//--------------------------------------------------------------------------

//-------------------------------------Constructor--------------------------

constructorBody : LBracet internalActions? RBracet;
constructor : AccessType? Identifier LParantesis functionInput? RParantesis constructorBody;
//--------------------------------------------------------------------------


//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//-------------------------------------Lexers-------------------------------
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------


//------------Operations------------
Bitwise : '&' | '^' | '|' | '^' | '<<' | '>>';

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
Comparison : '<' | '>' | '<=' | '>=' | '==' | '!=';
GT : '>';
LT : '<';
LE : '<=';
GE : '>=';
//----------------------------------

//------------Special Names---------
From : 'from';
Import : 'import';

Not : 'not';
And : 'and';
Or : 'or';

New : 'new';

LParantesis : '(';
RParantesis : ')';

LBracet : '{';
RBracet : '}';

With : 'with';

This : 'this';
Class : 'class';
Return : 'return';
Extends : 'extends';
Implements : 'implements';

AccessType : 'public' | 'private' | 'protected' ;
Var : 'var';
Const : 'const';

EndLine : ';';
//----------------------------------

//-------------Data Types-----------
Void : 'void';
NumericalDataType : 'Int' | 'Double' | 'float';
Array : 'Array';
CharacterDataType : 'String' | 'char';
Bool : 'Boolean' | 'bool';
//----------------------------------



//-------------Basic Lexers---------

StringValue : '"' StringCharacters? '"';

fragment
StringCharacters :	(~["\\] |'\\')+ ;

Identifier : Letter Letter LetterOrDigit*;

Float : Digits+ '.' Digits* | '.'Digits+ | Digits'.' Digits+'e'Unary Digits+;

Number : Digits+;

LetterOrDigit : [a-zA-Z0-9$_];
Digits : [0-9];
Letter : [a-zA-Z$_];


WS : [ \t\r\n\u000C]+ -> channel(HIDDEN);
COMMENT :   '/*' .*? '*/' -> channel(HIDDEN);
LINE_COMMENT : '/~' ~[\r\n]* -> channel(HIDDEN);
