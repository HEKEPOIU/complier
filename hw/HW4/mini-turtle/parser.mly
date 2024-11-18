
/* Parsing for mini-Turtle */

%{
  open Ast

%}

/* Declaration of tokens */
%token <int> INT
%token <string> COLOR_NAME
%token <string> IDENT
%token PLUS MINUS TIMES DIVIDE DEF FORWARD PENUP PENDOWN TURNLEFT
%token TURNRIGHT COLOR IF ELSE REPEAT LBRACE RBRACE LPAREN RPAREN COMMA
%token EOF


/* Priorities and associativity of tokens */

(*Top to down show Priorities low to height*)
%nonassoc IF
%nonassoc ELSE

%left PLUS MINUS
%left TIMES DIVIDE

/* Axiom of the grammar */
%start prog

/* Type of values returned by the parser */
%type <Ast.program> prog
%type <Ast.def> def
%type <Ast.def list> defs
%type <Ast.expr> expr
%type <string list> param_list
%type <Ast.expr list> arg_list
%type <Ast.stmt> stmt
%type <Ast.stmt list> stmts

%%

/* Production rules of the grammar */

prog:
  defs stmts EOF
    { { defs = $1; main = Sblock $2 } }
;


defs:
    {[]}
    | defs def
        {$1 @ [$2]}
;
def:
    | DEF IDENT LPAREN param_list RPAREN stmt
    {{name = $2; formals = $4; body = $6}}
;   


param_list:
    {[]}
  | IDENT
    {[$1]}
  | param_list COMMA IDENT
    { $1 @ [$3] }
;


arg_list:
    { [] }
  | expr
    {[$1]}
  | arg_list COMMA expr
    { $1 @ [$3] }
;

stmts:
    { [] }
  | stmts stmt
    { $1 @ [$2] }
;

stmt:
    FORWARD expr {Sforward $2}
    | PENUP  {Spenup}
    | PENDOWN {Spendown}
    | TURNLEFT expr {Sturn $2}
    | TURNRIGHT expr {Sturn (Ebinop (Sub, Econst 0 , $2))}
    | COLOR COLOR_NAME     
    {
      match $2 with
      | "red" -> Scolor Turtle.red
      | "blue" -> Scolor Turtle.blue
      | "green" -> Scolor Turtle.green
      | "white" -> Scolor Turtle.white
      | "black" -> Scolor Turtle.black
      | _ -> Scolor Turtle.black
    }
    | IF expr stmt ELSE stmt 
       {Sif ($2, $3, $5)} 
    | IF expr stmt 
       {Sif ($2, $3, Sblock[])} 
    | REPEAT expr stmt
        {Srepeat ($2, $3) }
    | LBRACE stmts RBRACE
        {Sblock $2}
    | IDENT LPAREN arg_list RPAREN
        { Scall ($1, $3) }
;
expr:
    INT
        {Econst $1}
    | MINUS expr %prec MINUS
      { Ebinop (Sub, Econst 0, $2) }
    | expr PLUS expr          
      { Ebinop (Add, $1, $3) }
    | expr MINUS expr         
      { Ebinop (Sub, $1, $3) }
    | expr TIMES expr         
      { Ebinop (Mul, $1, $3) }
    | expr DIVIDE expr        
      { Ebinop (Div, $1, $3) }
    | LPAREN expr RPAREN
      { $2 }
    | IDENT
      { Evar $1 }
