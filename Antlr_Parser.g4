parser grammar Antlr_Parser;

options {
    tokenVocab = Antlr_Lexer;
}

start : imports  class+ EOF;

actions : (variables | functions)*;
internalActions : (variables | for | voids | while | do | if | switch | exception)*;

//----------------------------Imports---------------------------------------

packageName : Identifier(Dot Identifier)*;
importAs : packageName Forward Identifier ;

singleImport : importAs | packageName;
multiImport : (importAs | packageName)( Comma (importAs | packageName))+;

fromImport : From packageName Import (Multi | multiImport | singleImport) EndLine  ;
normalImport : Import packageName( Comma packageName)* EndLine;

importType : fromImport | normalImport;

imports : importType*;

//--------------------------------------------------------------------------
//------------------------------Common Usage--------------------------------
withType : LCruse dataType RCruse;
dataType : Void | NumericalDataType | CharacterDataType | object_name | objectCall  ;

voidOrInObjVar : variableName(Dot (variableName | objectCall))*;
nVInString : voidOrInObjVar | Float | Number;
normalValue : voidOrInObjVar | Float | Number | stringValue ;
objectInput : LParantesis initValue*(Comma initValue)* RParantesis ;

initValue : operations | normalValue | objectCall;
assignValue : ((AssignmentSign | OpAndAssign) initValue) | UnaryOp;
typeAndAssign : TwoDot dataType assignValue?;
objectType : New? (Array | object_name) withType? ;
objectCall : objectType objectInput;
//--------------------------------------------------------------------------

//-------------------------------Variables----------------------------------

stringValue : Interp_Start stringValue End_Interp
    | exprInString
    | DQUOTE stringContents* DQUOTE
    ;

stringContents : TEXT
               | ESCAPE_SEQUENCE
               | BACKSLASH_PAREN stringValue End_Interp
               ;

exprInString : Unary exprInString
 | UnaryOp exprInString | exprInString UnaryOp
 | exprInString Power exprInString
 | exprInString mulop exprInString
 | exprInString addop exprInString
 | Interp_Start exprInString End_Interp
 | nVInString;

expr : Unary expr
  | UnaryOp expr | expr UnaryOp
  | LParantesis expr RParantesis
  | expr Power expr
  | expr mulop expr
  | expr addop expr
  | normalValue
  ;

addop : Add | Sub ;
mulop : Multi | Divide | DivideInt | Percent ;

decType : Var | Const;
variableName : Identifier;
object_name : Identifier;

operations : expr ;

varInfo : variableName (assignValue? | typeAndAssign);

declareVariable : AccessType? (decType | dataType) varInfo(Comma varInfo)* EndLine;
assignVariable : (This  Dot )? Identifier assignValue EndLine;

variables : declareVariable | assignVariable;

//--------------------------------------------------------------------------

//--------------------------------Voids-------------------------------------

voidCallInput : objectInput ;
objectVoid : Identifier(Dot  Identifier)* voidCallInput EndLine;
voids : objectVoid;

//--------------------------------------------------------------------------
//--------------------------------Functions---------------------------------

inputData : dataType varInfo;
functionInput : inputData ( Comma inputData)*;
return : Return initValue EndLine;
functionBody : internalActions return?;
functions : AccessType? dataType Identifier LParantesis functionInput? RParantesis LBracet functionBody RBracet ;

//--------------------------------------------------------------------------

conditions : initValue Comparison initValue (ConditionCheck conditions)*;

//----------------------------------for-------------------------------------
iterator_name : Identifier;

initialization : NumericalDataType? variableName (AssignmentSign | OpAndAssign) Number ;
incdec : variableName (AssignmentSign | OpAndAssign | UnaryOp);
forBody : internalActions;

normalFor : initialization EndLine conditions EndLine incdec;
iteratorFor : decType variableName In iterator_name;

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
expression : Number | Float | stringValue | variableName;
default : Default ':' internalActions (Break EndLine)?;

switchBody : Case expression ':' caseBody (Break EndLine)? ;

switch : Switch LParantesis expression RParantesis LBracet switchBody* default? RBracet;

//--------------------------------------------------------------------------

//--------------------------------------Exception---------------------------

exception_name : Identifier;
catchInfo : Catch LParantesis dataType? variableName RParantesis;

cathBody : LBracet internalActions RBracet ;
on: On exception_name (catchInfo)? cathBody ;
try : Try LBracet internalActions RBracet;

exception : try on? (catchInfo cathBody)?;

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