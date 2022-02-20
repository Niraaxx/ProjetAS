%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "turtle-ast.h"
#include "turtle-parser.h"
%}

%option warn 8bit nodefault noyywrap

DIGIT [0-9]
BOOLEAN true|false
INTEGER [1-9]{DIGIT}*|0
HEXADIGIT [0-9a-fA-F]
HEXA 0[xX]{HEXADIGIT}+
F1 {DIGIT}*"."{DIGIT}+
F2 {DIGIT}+"."{DIGIT}*
FLOAT ({INTEGER}|{F1}|{F2})[eE][+-]?{INTEGER}+
PROC [A-Z][0-9A-Z]*
PROCENC [A-Za-z_][A-Za-z0-9_]+ | [_][A-Za-z0-9_]+

%%

    /*Simple Commande*/
"fw"|"forward"             {return KW_FORWARD;}
"up"                       {return KW_UP;}       
"down"                     {return KW_DOWN;}          
"rt"|"right"               {return KW_RIGHT;}     
"lt"|"left"                {return KW_LEFT;}       
"heading"|"hd"             {return KW_HEADING;}      
"bw"|"backward"            {return KW_BACKWARD;}   
"pos"|"position"           {return KW_POSITION;}  
"home"                     {return KW_HOME;}         
"color"                    {return KW_COLOR;}        
"print"                    {return KW_PRINT;}   



"("           { return '('; }
")"           { return ')'; }
"#"        /*nothing*/
{DIGIT}+              { yylval.value = strtod(yytext, NULL); return VALUE; }
{F1}|{F2}|{F3} {
    printf("Le petit flottant : %f voir %s \n",atof(yytext), yytext);
}

{INTEGER} { printf("Integer : %i\n", atoi(yytext)); }

{DIGIT}+  { printf("Number: %i (%s)\n", atoi(yytext), yytext); }

{TRUE} { printf("true est reconnu\n"); }

{HEXA} { printf("Hexadécimaux : %s\n",yytext); }

{PROC} { printf("PROC TURTLE : %s\n",yytext); }

{PROCENC} { printf("Procedure en C : %s\n", yytext); }

[\n\t ]*              /* whitespace */
.                     { fprintf(stderr, "Unknown token: '%s'\n", yytext); exit(EXIT_FAILURE); }

%%
