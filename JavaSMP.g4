grammar JavaSMP;

start : importType* variables* class* EOF;

actions : variables* functions*;

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
dataType : NumericalDataType | CharacterDataType | 'new' Array ('<' dataType '>')? '(' arrayAssignValue? ')';

initValue : Float | Number | StringValue | Array'(' arrayAssignValue? ')' | variableName;

assignValue : AssignmentSign initValue;
arrayAssignValue : initValue (','initValue)*;
typeAndAssign : ':' dataType assignValue?;
varInfo : variableName (assignValue? | typeAndAssign);

declareVariable : AccessType? (decType | dataType) varInfo(','varInfo)* EndLine;
assignVariable : (This '.')? Identifier assignValue EndLine;

variables : declareVariable | assignVariable;

//---------------------------

//------------Functions----------

functionInput : dataType varInfo (',' dataType varInfo)*;
functionBody : actions (Return initValue EndLine)? ;
functions : AccessType? dataType? Identifier '(' functionInput ')' '{' functionBody '}' ;

//-------------------------------


//------------Classes------------

className : Identifier;
parentName : Identifier;
implementName : Identifier;

extend : Extends parentName;
implements : Implements implementName ('with' implementName)*;

classBody : '{' actions '}';

class : Class className  extend? implements? classBody;
//---------------------------

AssignmentSign : '+=' | '-=' | '=';


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
