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
int etiq=0;
%} 
%union {
	int num;
	char * pal;
}
%token PULL SAY IF ELSE THEN DO END SELECT WHEN OTHERWISE WHILE UNTIL TO BY ADDING SUBTRACTING <num>NUM <pal>CAD <pal>ID CHOOSE MENORIGUAL MAYORIGUAL DISTINTO MAYOR MENOR IGUAL
%type <num> listaSalida listaBY listaWHEN
%type <pal> relacion
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

elegir: CHOOSE '(' condicion ','{$<num>$ = etiq++; printf("sifalsovea LBL%d\n", $<num>$);} expresion  ','{$<num>$ = etiq++; printf("vea LBL%d\n",$<num>$); printf("LBL%d:\n",$<num>5);} expresion  ')'{printf("LBL%d:\n",$<num>8);} ;
      	
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

relacion: MAYOR {$$ = "esmayor";}
	| MENOR {$$ = "esmenor";}
	| IGUAL {$$ = "esigual";}
	| DISTINTO {$$ = "esdistinto\nnot";}
	| MENORIGUAL {$$ = "esmayor\nnot";}
	| MAYORIGUAL {$$ = "esmenor\nnot";};

condicion: expresion 
	 | expresion relacion expresion {printf("%s\n",$2);} ;

condicional: IF condicion THEN{$<num>$ = etiq++; printf("sifalsovea LBL%d\n",$<num>$);} bloque{$<num>$ = etiq++;printf("vea LBL%d\n",$<num>$); printf("LBL%d:\n",$<num>4);} bloqueElse{printf("LBL%d:\n",$<num>6);} ;

bloqueElse: /* vacio */
    	  | ELSE bloque ;

clausulaWHEN: WHEN condicion THEN{$<num>$ = etiq++; printf("sifalsovea LBL%d\n",$<num>$);} bloque{printf("vea LBL%d\n",$<num>0); printf("LBL%d:\n",$<num>4);} ;

seleccion: SELECT{$<num>$ = etiq++; } listaWHEN listaOTHERWISE END {printf("LBL%d:\n",$<num>2);}; 

listaWHEN: clausulaWHEN {$$ = $<num>0;}
	 | listaWHEN clausulaWHEN {$$ = $1;};

listaOTHERWISE: /* vacio */
	      | OTHERWISE bloque ;

bucle: bucleWHILE
     | bucleUNTIL
     | bucleContador ; 


bucleWHILE: DO WHILE{$<num>$ = etiq++;printf("LBL%d:\n",$<num>$);} condicion{$<num>$ = etiq++;printf("sifalsovea LBL%d\n",$<num>$);} sentencias END{printf("vea LBL%d\n",$<num>3);printf("LBL%d:\n",$<num>5);};

bucleUNTIL : DO UNTIL {$<num>$ = etiq;etiq = etiq +3;printf("vea LBL%d\n",$<num>$+1);printf("LBL%d:\n",$<num>$);} condicion{printf("siciertovea LBL%d\n",$<num>3+2); printf("LBL%d:\n",$<num>3+1);} sentencias END{printf("vea LBL%d\n",$<num>3); printf("LBL%d:\n",$<num>3+2);} ;

bucleContador: DO ID IGUAL{printf("valori %s\n",$2);} expresion{printf("asigna\n");$<num>$ = etiq++;printf("LBL%d:\n",$<num>$);printf("valord %s\n",$2);} TO expresion listaBY{ $<num>$ = etiq++; if ($9>0) printf("esmayor\n"); else printf("esmenor\n"); printf("not\n"); printf("sifalsovea LBL%d\n",$<num>$);} sentencias END {printf("valori %s\n",$2); printf("valord %s\n",$2); if($9 >0) {printf("mete %d\n",$9); printf("add\n");}else {printf("mete %d\n",-$9); printf("sub\n");} printf("asigna\n"); printf("vea LBL%d\n",$<num>6); printf("LBL%d:\n",$<num>10);};

listaBY:/* vacio */ {$$ = 1;}
       | BY NUM {if ($2 == 0) yyerror("Error, nunca puede ser 0"); $$ = $2;}
       | BY ADDING NUM {if ($3 == 0) yyerror("Error, nunca puede ser 0"); $$ = $3;}
       | BY SUBTRACTING NUM {if ($3 == 0) yyerror("Error, nunca puede ser 0"); $$ = -$3;};

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
