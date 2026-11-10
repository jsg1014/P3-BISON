/*
 * Práctica de Bison — Procesadores de Lenguajes 2026-27
 * Mini-REXX: traductor a la máquina de pila abstracta.
 * Autor : Jairo Sanchez Gonzalez
 * Fecha : 30/11/2026
 * Compilación:  javacc Parser.jj && javac *.java
 * Uso:          java REXXCompiler [fichero.rexx]   (sin argumento lee de stdin)
 *
 * El código se emite directamente en el orden en que se reconoce la entrada;
 * no se usan variables auxiliares en el código intermedio, solo etiquetas.
 */


%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}
%x COMENTARIOS
%option caseless
%%

"PULL"	{return PULL;}
"SAY"	{return SAY;}
"IF"	{return IF;}
"ELSE"	{return ELSE;}
"THEN"	{return THEN;}
"DO"	{return DO;}
"END"	{return END;}
"SELECT"	{return SELECT;}
"WHEN"	{return WHEN;}
"OTHERWISE"	{return OTHERWISE;}
"WHILE"	{return WHILE;}
"UNTIL"	{return UNTIL;}
"TO"	{return TO;}
"BY"	{return BY;}
"ADDING"	{return ADDING;}
"SUBTRACTING"	{return SUBTRACTING;}
[0-9]+	{yylval.num=atoi(yytext);
		return NUM;}
"CHOOSE"	{return CHOOSE;}
"<="	{return MENORIGUAL;}
">="	{return MAYORIGUAL;}
"<>"	{return DISTINTO;}
">"	{return MAYOR;}
"<"	{return MENOR;}
[a-zA-Z_][a-zA-Z0-9_]*	{yylval.pal=strdup(yytext);
				return ID;}
\"[^"\n]*\"	{yylval.pal=strdup(yytext);
				return CAD;}
\'[^'\n]*\'     {yylval.pal=strdup(yytext);
                                return CAD;}
[ \t\n\r;]	;
.	{return yytext[0];}
"/*"	{ BEGIN(COMENTARIOS);}
<COMENTARIOS>"*/"	{BEGIN (INITIAL);}
<COMENTARIOS>.|\n	{}	
%%
