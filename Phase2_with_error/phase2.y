%{
#include <iostream>
#include <stdio.h>
using namespace std;
extern "C"
{
#include<ctype.h>

#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KBLU  "\x1B[34m"
#define KYEL  "\x1B[33m"
#define KNRM  "\x1B[0m"

extern int line_number;
extern char printf_str[100];
extern char identifier_name[50];
extern int symbol_table_length;
extern char type[30][10];
extern char for_spe[30];
extern char value[30][100];
extern char name[30][10];
extern int line_num[30];
extern int scopes[100];
char type_spe_arr[20];
extern char* yytext;
int type_spe_arr_index = 0;
        int yyparse(void);
        int yylex(void);  
        int yywrap()
        {
                return 1;
        }
	void yyerror (char const *s)
	{

  	//fprintf (stderr, "%s%d\n",s,line_number);
	cout << "Error, line number: " << line_number << endl;

	}


}


%}
%token ID NUM T_lt T_gt T_lteq T_gteq T_neq T_eqeq T_pl T_min T_mul T_div T_and T_or T_incr T_decr T_not T_eq WHILE INT CHAR FLOAT VOID H MAINTOK INCLUDE BREAK CONTINUE IF ELSE COUT STRING FOR ENDL open clo

%%
S
      : START {cout<<" Input is accepted"; cout << "\nSymbol table: \n";
		cout<<"Type\tName\tLine_Number\tScopes\tValues\n";
	for(int i = 0; i< symbol_table_length; ++i){
		printf("%s%s\t%s\t%d\t\t%d\t%s\n",KYEL, type[i],name[i], line_num[i],scopes[i], value[i]) ;
	}exit(0);}
      ;

START
      : INCLUDE T_lt H T_gt MAIN
      ;

MAIN
      : VOID MAINTOK BODY
      | INT MAINTOK BODY
      ;

BODY
      : open C clo
      ;

C
      : C statement ';'
      | C LOOPS
      | statement ';'
      | LOOPS
      ;
LOOPS
      : WHILE '(' COND ')' LOOPBODY
      | FOR '(' ASSIGN_EXPR ';' COND ';' statement ')' LOOPBODY
      | IF '(' COND ')' LOOPBODY
      | IF '(' COND ')' LOOPBODY ELSE LOOPBODY
      ;

LOOPBODY
  	  : open C clo
  	  | ';'
  	  | statement ';'
  	  ;

statement
      : ASSIGN_EXPR
      | ARITH_EXPR
      | TERNARY_EXPR
      | PRINT
      ;

COND
      : LIT RELOP LIT
      | LIT
      | LIT RELOP LIT bin_boolop LIT RELOP LIT
      | un_boolop '(' LIT RELOP LIT ')'
      | un_boolop LIT RELOP LIT
      | LIT bin_boolop LIT
      | un_boolop '(' LIT ')'
      | un_boolop LIT
      ;

ASSIGN_EXPR
      : ID T_eq ARITH_EXPR
      | TYPE ID T_eq ARITH_EXPR
      | error
      ;

ARITH_EXPR
      : LIT
      | LIT bin_arop ARITH_EXPR
      | LIT bin_boolop ARITH_EXPR
      | LIT un_arop
      | un_arop ARITH_EXPR
      | un_boolop ARITH_EXPR
      ;

TERNARY_EXPR
      : '(' COND ')' '?' statement ':' statement
      ;

PRINT
      : COUT T_lt T_lt STRING
      | COUT T_lt T_lt STRING T_lt T_lt ENDL
      ;
LIT
      : ID
      | NUM
      ;
TYPE
      : INT
      | CHAR
      | FLOAT
      ;
RELOP
      : T_lt
      | T_gt
      | T_lteq
      | T_gteq
      | T_neq
      | T_eqeq
      ;

bin_arop
      : T_pl
      | T_min
      | T_mul
      | T_div
      ;

bin_boolop
      : T_and
      | T_or
      ;

un_arop
      : T_incr
      | T_decr
      ;

un_boolop
      : T_not
      ;


%%

#include "lex.yy.c"
int main(int argc, char* args[])
{
  	yyin=fopen("input.cpp","r");
  	yyparse();
	
  return 0;
}
