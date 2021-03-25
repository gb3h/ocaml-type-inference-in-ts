grammar Ocaml;

// $antlr-format on
// $antlr-format true 
// $antlr-format columnLimit 150
// $antlr-format allowShortBlocksOnASingleLine true, indentWidth 8

WHITESPACE: [ \t\r\n]+ -> skip;

// ================== NAMES ==================

// Naming objects

value_name: LOWERCASE_IDENT | '(' operator_name ')';

operator_name: PREFIX_SYMBOL | infix_op;

infix_op:
	INFIX_SYMBOL
	| '*'
	| '+'
	| '-'
	| '-.'
	| '='
	| '!='
	| '<'
	| '>'
	| 'or'
	| '||'
	| '&'
	| '&&'
	| ':='
	| 'mod'
	| 'land'
	| 'lor'
	| 'lxor'
	| 'lsl'
	| 'lsr'
	| 'asr';

// ================== TYPE EXPRESSIONS ==================

typexpr: '\'' IDENT typexpr_recur;

typexpr_recur: '*' typexpr typexpr_recur | '->' typexpr typexpr_recur | /* Epsilon */;

// ================== CONSTANTS ==================

constant_integer: INTEGER_LITERAL;

constant_boolean: 'false' | 'true';

constant_string: STRING_LITERAL;

// ================== PATTERNS ==================

pattern: val = value_name | '_' | constant_integer | constant_boolean | constant_string;

// ================== EXPRESSIONS ==================

expr:
	value_name																	# valueName
	| constant_integer															# constantInt
	| constant_boolean															# constantBool
	| constant_string															# constantStr
	| '(' expr ')'																# exprInParantheses
	| PREFIX_SYMBOL expr														# exprWithPrefix
	| left = expr operator = infix_op right = expr								# binaryOp
	| 'if' expr 'then' expr ('else' expr)?										# conditionalExpr
	| 'while' expr 'do' expr 'done'												# whileLoop
	| 'for' value_name '=' expr ('to' | 'downto') expr 'do' expr 'done'			# forLoop
	| expr ';' expr																# exprSemicolonExpr
	| 'fun' (parameter)+ '->' expr												# lambda
	| 'let' ('rec')? name = pattern '=' binding = expr 'in' in_context = expr	# letExpr;
// | 'let' ('rec')? name = value_name (parameter)* '=' binding = expr 'in' in_context = expr	# letFunExpr;

// let_binding: pattern '=' binding = expr # letBinding | value_name (parameter)* '=' expr # letFunBinding;

parameter: pattern;

// ================== LEXICAL CONVENTIONS ==================

fragment LETTER: ('A' .. 'Z' | 'a' .. 'z');
CAPITALIZED_IDENT: ('A' .. 'Z') (LETTER | '0' .. '9' | '_' | '\'')*;
LOWERCASE_IDENT: ('a' .. 'z' | '_') (LETTER | '0' .. '9' | '_' | '\'')*;
IDENT: (LETTER | '_') (LETTER | '0' .. '9' | '_' | '\'')*;

INTEGER_LITERAL: ('-')? ('0' .. '9') ('0' .. '9' | '_')*;

STRING_LITERAL:
	'"' (' ' | LETTER | SYMBOL | '0' .. '9' | ',' | ';' | '(' | ')' | '[' | ']' | '`')* '"';

LABEL_NAME: LOWERCASE_IDENT;

OPERATOR_CHAR:
	'!'
	| '$'
	| '%'
	| '&'
	| '*'
	| '+'
	| '-'
	| '.'
	| '/'
	| ':'
	| '<'
	| '='
	| '>'
	| '?'
	| '@'
	| '^'
	| '|'
	| '~';
INFIX_SYMBOL: ('=' | '<' | '>' | '@' | '^' | '|' | '&' | '*' | '/' | '+' | '-' | '$' | '%') (
		OPERATOR_CHAR
	)*;
PREFIX_SYMBOL: '!' (OPERATOR_CHAR)* | ('?' | '~') (OPERATOR_CHAR)+;

fragment SYMBOL:
	'!'
	| '#'
	| '$'
	| '%'
	| '&'
	| '*'
	| '+'
	| '.'
	| '/'
	| '<'
	| '='
	| '>'
	| '?'
	| '@'
	| '\\'
	| '^'
	| '|'
	| '-'
	| '~'
	| ':';
