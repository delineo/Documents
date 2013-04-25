lexer grammar ISQLLexer;

options
{
    language = Java;
}

// 구문 Token 정의
tokens
{
    // 변수, 지정인식 구별자(keyword)  
    COLON             = ':';
    AT                = '@';
    DOLLAR            = '$';
    QUESTION          = '?';
    ASSIGN            = '=';

    // 구분자
    COMMA             = ',';
    DOT               = '.';
    LCURLY            = '{';
    RCURLY            = '}'; 
    SEMI              = ';';

    // 사직연산자
    PLUS              = '+';
    MINUS             = '-';
    DIV               = '/';
    STAR              = '*';
    MOD               = '%';
    LPAREN            = '(';
    RPAREN            = ')';
    
    // 비교 연산자
    EQUAL             = '==';
    NOT_EQUAL         = '!=';
    LESS_OR_EQUAL     = '<=';
    LESS_THEN         = '<';
    GREATER_OR_EQUAL  = '>=';
    GREATER_THEN      = '>';

    // Bool 연산자
    NOT               = '~'; 
    AND               = '&';
    OR                = '|';
    XOR               = '^';
    LOGICAL_AND       = '&&';
    LOGICAL_OR        = '||';
    LOGICAL_NOT       = '!';

    
    // Keyword
    IF                = 'if';
    ELSE              = 'else';

    SWITCH            = 'switch';
    CASE              = 'case';
    BREAK             = 'break';
    DEFAULT           = 'default';
    
    FOR               = 'for';
    WHILE             = 'while';
    
    NULL              = 'null';
    TRUE              = 'true';
    FALSE             = 'false';
    
    OUT               = 'out';
    RETURN            = 'return';
    CONTINUE          = 'continue';

    // 구문 형식 정의
    BLOCK_SCOPE;  // 구문 범위
    QUERY;        // 쿼리 범위


    SWITCH_BLOCK_LABEL_LIST;

    PARENTESIZED_EXPR;
    EXPR;
}


/*-----------------------------------------------------------------------------//
 java file의 Package 경로 설정
//-----------------------------------------------------------------------------*/
/*
@header
{
package  caddy.core.syntax.isql;
}

class ISQLLexer extends Lexer;
options
{
    charVocabulary = '\3'..'\377';
    k=2;
}
*/
/*-----------------------------------------------------------------------------//
 SQL 구문 정의
//-----------------------------------------------------------------------------*/
query:
    compilationUnit EOF
    -> ^(QUERY compilationUnit);

compilationUnit:
    command*;

command:
    AT^
    (
        ifStatement
      | switchStatement
      | whileStatement
    ) SEMI;

// 구문영역 정의
block:  
    LCURLY blockStatement* RCURLY
    -> ^(BLOCK_SCOPE[$LCURLY, "BLOCK_SCOPE"] blockStatement*);

blockStatement:
    statement;


// 구문 정의
statement:
    block
  | ifStatement
  | switchStatement
  | whileStatement
  | OUT parenthesizedExpression                                                 -> ^(OUT parenthesizedExpression)
  | RETURN SEMI                                                                 -> ^(RETURN)
  | BREAK SEMI                                                                  -> ^(BREAK)
  | CONTINUE SEMI                                                               -> ^(CONTINUE)
  | SEMI;

// IF 구문 정의
ifStatement:
    IF parenthesizedExpression ifStat=statement
    (
        ELSE elseStat = statement
        -> ^(IF parenthesizedExpression $ifStat $elseStat)
      | /* empty statement */ -> ^(IF parenthesizedExpression $ifStat)
    ) ;

// SWITCH 구문 정의
switchStatement:
    SWITCH parenthesizedExpression LCURLY switchBlockLabels RCURLY
    -> ^(SWITCH parenthesizedExpression switchBlockLabels) ;
    
switchBlockLabels:
    switchCaseLabels switchDefaultLabel? switchCaseLabels
    -> ^(SWITCH_BLOCK_LABEL_LIST switchCaseLabels switchDefaultLabel? switchCaseLabels);

switchCaseLabels:
    switchCaseLabel*;

switchCaseLabel:
    CASE^ expression COLON! blockStatement* ;

switchDefaultLabel:
    DEFAULT^ COLON! blockStatement*;

// WHILE 구문 정의
whileStatement:
    WHILE parenthesizedExpression statement
    -> ^(WHILE parenthesizedExpression statement) ;

// 표현식(EXPRESSIONS) 구문 정의
parenthesizedExpression:
    LPAREN expression RPAREN
    -> ^(PARENTESIZED_EXPR[$LPAREN, "PARENTESIZED_EXPR"] expression);

expression:
    assignmentExpression
    -> ^(EXPR assignmentExpression);
        
// 할당자 구문
assignmentExpression:
    conditionalExpression 
    (
        (
            ASSIGN^
        ) 
        assignmentExpression
    )? ;
    
conditionalExpression:
    logicalOrExpression (QUESTION^ assignmentExpression COLON! conditionalExpression)? ;


// 비교 구문
logicalOrExpression:
    logicalAndExpression  (LOGICAL_OR^  logicalAndExpression )* ;

logicalAndExpression:
    inclusiveOrExpression (LOGICAL_AND^ inclusiveOrExpression)* ;

inclusiveOrExpression:
    exclusiveOrExpression (OR^          exclusiveOrExpression)* ;

exclusiveOrExpression:
    andExpression         (XOR^         andExpression        )* ;
    
andExpression:
    equalityExpression    (AND^         equalityExpression   )* ;

equalityExpression:
    relationalExpression
    (
        (   EQUAL^
          | NOT_EQUAL^
        ) 
        relationalExpression
    )* ;

relationalExpression:
    additiveExpression 
    (
        (
            LESS_OR_EQUAL^
          | GREATER_OR_EQUAL^
          | LESS_THEN^
          | GREATER_THEN^
        )
        additiveExpression
    )* ;

additiveExpression:
    multiplicativeExpression
    (
        (
            PLUS^
          | MINUS^
        )
        multiplicativeExpression
    )* ;

multiplicativeExpression:
    primaryExpression 
    (
        (
            STAR^
          | DIV^
          | MOD^
        )
        primaryExpression
    )* ;


primaryExpression:
    parenthesizedExpression
  | literal ;
/*-----------------------------------------------------------------------------//
 리터럴(literal) 정의
//-----------------------------------------------------------------------------*/
literal:
    HEX_LITERAL             // 16진수 
  | OCTAL_LITERAL           // 8진수
  | DECIMAL_LITERAL         // 정수
  | FLOATING_POINT_LITERAL  // 소수
  | STRING_LITERAL          // 문자
  | TRUE
  | FALSE
  | NULL ;

// 16진수
HEX_LITERAL:
    '0' ('x'|'X') HEX_DIGIT+ INTEGER_TYPE_SUFFIX? ;
// 16진수 문자 범위 지정
fragment HEX_DIGIT:
    ('0'..'9'|'a'..'f'|'A'..'F') ;

// 8진수
OCTAL_LITERAL:
    '0' ('0'..'7')+ INTEGER_TYPE_SUFFIX? ;

// 정수  
DECIMAL_LITERAL:
    ('0' | '1'..'9' '0'..'9'*) INTEGER_TYPE_SUFFIX? ;
// 정수 지시자
fragment INTEGER_TYPE_SUFFIX:
    ('l'|'L') ;

// 소수
FLOATING_POINT_LITERAL
    :   ('0'..'9')+ 
        (
            DOT ('0'..'9')* EXPONENT? FLOAT_TYPE_SUFFIX?
        |   EXPONENT FLOAT_TYPE_SUFFIX?
        |   FLOAT_TYPE_SUFFIX
        )
    |   DOT ('0'..'9')+ EXPONENT? FLOAT_TYPE_SUFFIX?
    ;
// 소수 확장
fragment EXPONENT:
    ('e'|'E') ('+'|'-')? ('0'..'9')+ ;
// 소수 지시자
fragment FLOAT_TYPE_SUFFIX:
    ('f'|'F'|'d'|'D') ;

// 문자
STRING_LITERAL:
    '"' ( ESCAPE_SEQUENCE | ~('\\'|'"') )* '"';

fragment ESCAPE_SEQUENCE:
    '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
  | UNICODE_ESCAPE    // UNICODE 지원
  | OCTAL_ESCAPE ;    // 8진수 지원

fragment OCTAL_ESCAPE:
    '\\' ('0'..'3') ('0'..'7') ('0'..'7')
  | '\\' ('0'..'7') ('0'..'7')
  | '\\' ('0'..'7') ;

fragment UNICODE_ESCAPE:
    '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT ;


// 음.. 여기는 변수 지정자 구분하기 위한 것 같은 뒤...
// 이거는 쓸일이 없을것 같은뒤.... 쓸라나... 음.. 음..
// ID 식별자의 시작문자열 범위
IDENT:
    ID_START (ID_START)* ;

fragment ID_START:
    '\u0024'
  | '\u0041'..'\u005a'
  | '\u005f'
  | '\u0061'..'\u007a'
  | '\u00c0'..'\u00d6'
  | '\u00d8'..'\u00f6'
  | '\u00f8'..'\u00ff'
  | '\u0100'..'\u1fff'
  | '\u3040'..'\u318f'
  | '\u3300'..'\u337f'
  | '\u3400'..'\u3d2d'
  | '\u4e00'..'\u9fff'
  | '\uf900'..'\ufaff' ;

// ID 식별자 부문 정의
fragment ID_PART:
    ID_START
  | '\u0030'..'\u0039' ;
//----------------------------------------------------

    
WS:
    (
        ' ' | '\t' |  '\f'
      | (
            options {generateAmbigWarnings=false;}:
                '\r\n'   // DOS
              | '\r'     // Macintosh
              | '\n'     // UNIX
        )
        { newline(); }
    )+
    { $setType(ANTLR_USE_NAMESPACE(antlr)Token::SKIP); } ;


COMMENT:
   '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;};

LINE_COMMENT:   
   ('//'|'--') ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;};
