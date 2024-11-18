
(* Lexical analyser for mini-Turtle *)

{ 
  (*header*)
  open Lexing
  open Parser

  (* raise exception to report a lexical error *)
  exception Lexing_error of string

  (* note : remember to call the Lexing.new_line function
at each carriage return ('\n' character) *)
}
let letter = ['a' - 'z' 'A' - 'Z']
let digit = ['0' - '9']
let underscores = '_'
let colors = ("red"|"blue"|"green"|"white"|"black")
let not_new_line = [^ '\n']*

rule token = parse
    | "forward" {FORWARD}
    | "turnleft" {TURNLEFT}
    | "turnright" {TURNRIGHT}
    | "pendown" {PENDOWN}
    | "penup" {PENUP}
    | colors as mc {COLOR_NAME mc}
    | "color" {COLOR}
    | "if" {IF}
    | "else" {ELSE}
    | "repeat" {REPEAT}
    | "def" {DEF}
    | letter (letter|digit|underscores)* as id {IDENT id} (*this order matter, because it will match prev*)
    | digit+ as num {INT (int_of_string num)}
    | "+" {PLUS}
    | '-' { MINUS }
    | '*' { TIMES }
    | '/' { DIVIDE }
    | '{' { LBRACE }
    | '}' { RBRACE }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | ',' { COMMA }
    | eof { EOF }
    | "//" not_new_line '\n' {token lexbuf} (*means that skip all //start parse to end of line. so it recall the token lexbuf function*)
    | "\n" {token lexbuf}
    | [' ' '\t'] {token lexbuf}
    | "(*" {comment lexbuf}

and comment = parse
    | "*)" {token lexbuf}
    | _ {comment lexbuf}
