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

/* Declaracion de los tokens*/
%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
int yylex(void);
void yyerror(const char *s);
%} 
%union {
	int num;
	char * pal;
}
%token PULL SAY IF ELSE THEN DO END SELECT WHEN OTHERWISE WHILE UNTIL TO BY ADDING SUBTRACTING <num>NUM <pal>CAD <pal>ID CHOOSE MENORIGUAL MAYORIGUAL DISTINTO MAYOR MENOR IGUAL
%%

programa: sentencias ;

sentencias: /* vacio */
	  | sentencias sentencia ;

sentencia: asignacion
	 | entrada
	 | salida
	 | condicional
	 | seleccion
	 | bucle ;

expresion: termino
	 | expresion '+' termino
  	 | expresion '-' termino ;

asignacion: ID IGUAL expresion ;

entrada: PULL ID ;

elementoSalida: CAD | expresion;

listaSalida: elementoSalida
	   | listaSalida ',' elementoSalida ;
	   
salida: SAY listaSalida ;

bloque: DO sentencias END ;

relacion: MAYOR
	| MENOR
	| IGUAL
	| DISTINTO
	| MENORIGUAL
	| MAYORIGUAL ;

condicion: expresion 
	 | expresion relacion expresion ;

condicional: IF condicion THEN bloque bloqueElse ;

bloqueElse: /* vacio */
    	  | ELSE bloque ;

clausulaWHEN: WHEN condicion THEN bloque ;

seleccion: SELECT listaWHEN listaOTHERWISE END ; 

listaWHEN: clausulaWHEN
	 | listaWHEN clausulaWHEN;

listaOTHERWISE: /* vacio */
	      | OTHERWISE bloque ;
