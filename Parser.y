/*
 * Práctica de Bison — Procesadores de Lenguajes 2026-27
 * Mini-REXX: traductor a la máquina de pila abstracta.
 * Autor : Jairo Sanchez Gonzalez
 * Fecha : 30/11/2026
 * Compilación:  bison -yd -v Parser.y
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
%type <num> listaSalida
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
termino: factor
       | termino '*' factor {printf("mul\n");}
       | termino '/' factor {printf("div\n");} ;

factor: atomo
      | '-' {printf("mete 0\n");}  atomo {printf("sub\n");}
      | '+' atomo {printf("add\n");} ;

atomo: NUM {printf("mete %d\n",$1);}
     | ID  { printf("valord %s\n",$1);}
     | '(' expresion ')' 
     | elegir	;

elegir: CHOOSE '(' condicion ',' expresion ',' expresion ')' ;
      	
expresion: termino 
	 | expresion '+' termino {printf("add\n");}
  	 | expresion '-' termino {printf("sub\n");}

asignacion: ID IGUAL {printf("valori %s\n",$1);} expresion {printf("asigna\n");} ;

entrada: PULL ID {printf("lee %s\n",$2);} ;

elementoSalida: CAD {printf("metecad %s\n",$1);} | expresion;

listaSalida: elementoSalida {$$ =1;}
	   | listaSalida ',' elementoSalida {$$=$1+1;} ;
	   
salida: SAY listaSalida {printf("print %d\n",$2);};

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

bucle: bucleWHILE
     | bucleUNTIL
     | bucleContador ; 


bucleWHILE: DO WHILE condicion sentencias END ;
	
bucleUNTIL : DO UNTIL condicion sentencias END ;

bucleContador: DO ID IGUAL expresion TO expresion sentencias END
	     | DO ID IGUAL expresion TO expresion listaBY sentencias END;

listaBY:/* vacio */
       | BY NUM
       | BY ADDING NUM
       | BY SUBTRACTING NUM ;

%%
void yyerror(const char *s){
	fprintf(stderr, "Error: %s\n",s);
} 
int main(int argc, char *argv[]) {
	
	if (argc>1){
		yyin= fopen(argv[1],"r");
		if(yyin==NULL){
			perror(argv[1]);
			return 1;
   		}
	}
	return yyparse();
}
