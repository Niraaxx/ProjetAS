%{
#include <stdio.h>

#include "turtle-ast.h"

int yylex();
void yyerror(struct ast *ret, const char *);

%}

%debug
%defines

%define parse.error verbose

%parse-param { struct ast *ret }

%union {
  double value;
  char *name;
  struct ast_node *node;
}

%token <value>    VALUE       "value"
%token <name>     NAME        "name"

/*Simple Command*/
%token            KW_FORWARD  "fw"
%token            KW_UP       "up"          
%token            KW_DOWN     "down"     
%token            KW_RIGHT    "rt"
%token            KW_LEFT     "lt" 
%token            KW_HEADING  "heading"   
%token            KW_BACKWARD "bw"  
%token            KW_POSITION "pos" 
%token            KW_HOME     "home"   
%token            KW_COLOR    "color"   
%token            KW_PRINT    "print"  


/* TODO: add other tokens */

%right '+' '-'
%left '*' '/'
%left UMINUS

%type <node> unit cmds cmd expr

%%

unit:
    cmds              { $$ = $1; ret->unit = $$; }
;

cmds:
    cmd cmds          { $1->next = $2; $$ = $1; }
  | /* empty */       { $$ = NULL; }
;

cmd:
    KW_FORWARD expr   { $$ = make_cmd_forward($2);}
    KW_UP             {                           ;}
    KW_DOWN           {                           ;}
    KW_RIGHT expr     {                           ;}
    KW_LEFT expr      {                           ;}
    KW_HEADING expr   {                           ;}
    KW_BACKWARD expr  {                           ;}
    KW_POSITION expr expr {                         ;}
    KW_HOME           {                           ;}
    KW_COLOR expr     {                           ;}
    KW_PRINT expr     {                           ;}
;

expr:
    VALUE             { $$ = make_expr_value($1); }
  /*| NAME              { $$ = constant($1); }*/
  | expr '+' expr     { $$ = $1 + $3;}
  | expr '-' expr     { $$ = $1 - $3;}
  | expr '*' expr     { $$ = $1 * $3;}
  | expr '/' expr     { $$ = $1 / $3;}
  | '(' expr ')'        { $$ = ($2) ;}
  | '-' expr %prec UMINUS         { $$ = -$2;}
    /* TODO: add identifier */
;

%%

void yyerror(struct ast *ret, const char *msg) {
  (void) ret;
  fprintf(stderr, "%s\n", msg);
}
