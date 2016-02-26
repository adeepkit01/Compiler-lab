/* we do not need flex library */
%option noyywrap

/* ----- DEFINITIONS PART ----- */
/* ============================ */

/* DEFINITIONS FOR TOKEN CODES */
/* --------------------------- */

/* ' The literal block %{ ... %} ' in this part is copied to verbatim to the generated
C source file near the beginning, before the beginning of yylex() */
%{
#include"symtab1.h"
#include"constab.h"
#include<string.h>
#include<stdlib.h>
#include "y.tab.h"



int lineno=1;
int commentDepth;
int ERROR=0;
%}

/* DEFINITIONS FOR FINITE AUTOMATA */
/* ------------------------------- */

%x commentsc
%x str
DOTHASH [\.#]

/* Universal Character Name: the naming conventions for UCS defined by International Standard ISO/IEC 10646 */
UCN (\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8})

/* DIGIT: any number from 0 to 9 */
DIGIT [0-9]

/* LETTER: any uppercase or lowercase letter */
LETTER [A-Za-z]

/* DELIMITER: any occurence of 'space', 'tab' or 'newline' */
DELIMITER [\v \t]

NEWLINE [\n]

/* IDENTIFIER: starting with a letter; following by any occurence of letter, digit or underscore */
IDENT ([_a-zA-Z]|{UCN})([_a-zA-Z0-9]|{UCN})*

/* SINGLE LINE COMMENTS: starting with // and ending with a newline */ 
SLCOMMENT ("//".*)
%%
 /* ----- RULES PART ----- */
 /* ====================== */


 /* Preprocessor directves printed out but ignored otherwise */


"#include<"{LETTER}+".h>" { printf("Header file\n"); }
 
"#define"[.]+[\n] { printf("Macro\n"); }
   

 /*----RULES FOR COMMENTS---*/
 /*=========================*/

"//".*  { printf("Single Line Comment:%s\n",yytext); }

 
 /* comment start-condition for recognizing multi-line comments */ 
<commentsc> 
{
 [\n]                                { yymore(); ++lineno; }
"*/"                                 { commentDepth--; printf("Multiline comment : %s",yytext); BEGIN(INITIAL);}
"/*"                                 {commentDepth++; yymore(); }
<<EOF>>                              {printf("line no. %d :ERROR: Unclosed comment.",lineno);
                                      FILE** fout=&stdout;
           printf("\n\n===============================================\n");
           printf("------------------SYMBOL TABLE-----------------\n");
           printf("===============================================\n\n");
            symtab_dump(*fout);
            printf("\n\n==========================================\n");
           printf("---------------CONSTANT TABLE-------------\n");
           printf("==========================================\n\n");
            symtab_dumpc(*fout);
            yyterminate();
                                      }
                               
.                                    yymore();/* ignore all other characters (the text actually out-commented)*/;
}

  /* when you see a /* goto <commentsc> state  */ 
"/*"  { commentDepth=1;yymore(); BEGIN(commentsc);}

  /* if u see comment end and the commentDepth of the previous comment is > 0, nested commenting was attempted */ 
"*/"  { if(commentDepth>0)  printf("line no. %d :ERROR: Nested commenting attempted.",lineno);
        commentDepth=0;
      }

 /*----RULES FOR OPERATORS AND PUNCTUATORS---*/
 /*==========================================*/
"*=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(MUL_ASSIGN); }

"/=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(DIV_ASSIGN); }

"%=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(MOD_ASSIGN); }

"-=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(SUB_ASSIGN); }

"+=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(ADD_ASSIGN); }

">>=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(RIGHT_ASSIGN); }

"<<=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(LEFT_ASSIGN); }

"&=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(AND_ASSIGN); }

"|=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(OR_ASSIGN); }

"^=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(XOR_ASSIGN); }

"<<" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(LEFT_OP); }

">>" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(RIGHT_OP); }  

"++" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(INC_OP); } 

"--" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(DEC_OP); } 

"+" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return('+'); } 
    
"-" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return('-'); } 
      
"*" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return('*'); }
      
"/" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return( '/'); }
      
"%" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return( '%');}
      
"&&" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return( AND_OP);}
      
"||" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n", yytext); return(OR_OP); }
     
"!" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return('!'); }
      
"<" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return('<');} 
      
">" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return('>');} 

":" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return(':');} 

"?" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return('?');} 
      
"<=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return( LE_OP); } 
     
">=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return( GE_OP); } 
      
"==" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return( EQ_OP); }
      
"!=" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return( NE_OP); }

"&" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return('&'); }
      
"|" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return('|'); } 
      
"^" { insert(yytext,yyleng,3,0,lineno); printf("Operator: %s\n",yytext); return('^'); }
      
"(" { insert(yytext,yyleng,4,0,lineno); printf("Punctuator(LPARA): %s\n",yytext); return('('); } 
      
")" { insert(yytext,yyleng,4,0,lineno); printf("Punctuator(RPARA): %s\n",yytext); return(')'); }
      
"[" { insert(yytext,yyleng,4,0,lineno); printf("Punctuator(LBRACKET): %s\n",yytext); return('['); }
      
"]" { insert(yytext,yyleng,4,0,lineno); printf("Punctuator(RBRACKET): %s\n",yytext); return(']'); } 
      
"{" { insert(yytext,yyleng,4,0,lineno); printf("Punctuator(LCURLY): %s\n",yytext); return('{'); }
      
"}" { insert(yytext,yyleng,4,0,lineno); printf("Punctuator(RCURLY): %s\n",yytext); return('}'); }
      
"," { insert(yytext,yyleng,4,0,lineno); printf("Punctuator(COMMA): %s\n",yytext); return(','); }
      
";" { insert(yytext,yyleng,4,0,lineno); printf("Punctuator(SEMICOLON): %s\n",yytext); return(';'); }
      
"=" { insert(yytext,yyleng,4,0,lineno); printf("Assignment operator: %s\n",yytext); return('='); }
      

 /* RULES FOR KEYWORDS */
 /* ------------------ */

"volatile" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n",yytext); return( VOLATILE); }

"char" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n",yytext); return( CHAR); } 
	  
"int" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(INT); } 
	  
"void" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(VOID); }
	  
"if" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(IF); }
	  
"else" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(ELSE); }
	  
"while" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(WHILE); }
	  
"for" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(FOR); }
	  
"continue" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(CONTINUE); }
	  
"break" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(BREAK); } 
	  
"return" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(RETURN); } 
	  
"auto" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(AUTO); } 
	   
"extern" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(EXTERN); } 
	  
"float" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(FLOAT); } 
	  
"double" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(DOUBLE); }
	  
"switch" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(SWITCH); }
	  
"case" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(CASE); } 
	   
"const" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(CONST); }
	   
"default" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(DEFAULT); }
	   
"long" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(LONG); } 
	   
"register" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(REGISTER); }
	   
"short" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(SHORT); }
	   
"signed" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(SIGNED); }
	    
"static" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(STATIC); } 
	    
"unsigned" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(UNSIGNED); }
	   
"do" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(DO); } 
	 
"enum" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(ENUM); }
	   
"struct" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(STRUCT); } 
	   
"union"	{ insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(UNION); } 
	   
"goto" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(GOTO); }
	   
"sizeof" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(SIZEOF); }
	   
"typedef" { insert(yytext,yyleng,1,0,lineno); printf("Keyword: %s\n", yytext); return(TYPEDEF); }
	   


 
 /* RULES FOR IDENTIFIIERS */
 /* ---------------------- */
{IDENT} { 
insert(yytext,yyleng,2,1,lineno);
printf("Identifier: %s\n", yytext);return(IDENTIFIER); } 


  

 /* RULES FOR LITERALS */
 /* ------------------ */

{DIGIT}+ { printf("Integer constant: %s\n",yytext);
                insertc(yytext,yyleng,1,lineno); 
              return (CONSTANT);}
{DIGIT}+"."{DIGIT}+ |
{DIGIT}+"."{DIGIT}+(E|e)[+-]?{DIGIT}+ {printf("Floating point constant: %s\n",yytext); 
                                            insertc(yytext,yyleng,2,lineno);
                 return(CONSTANT);}
 
\'[a-zA-Z0-9]\' {printf("Character constant:%s\n",yytext);
                insertc(yytext,yyleng,3,lineno);
               return(CONSTANT);}	   

   /* when u see a " go the <str> state */ 

\" { BEGIN(str); }


 
   /* string start condition <str> for recognizing string literals */  
<str>
{\"        {  if(ERROR==0)
              printf("String literal:\"%s\n",yytext);
              insertc(yytext,yyleng-1,4,lineno);
                BEGIN(INITIAL);
                 return(STRING_LITERAL);            
                 }
     
\n        {
                 printf("line no. %d :ERROR: unterminated string constant\n",lineno);
                 ERROR=1;
                 }
     
     
\\[^ntrbf]. {
                 printf("line no. %d :ERROR: Bad escape sequence\n",lineno);
                 ERROR=1;
                 }
     
\\n  { yymore();}
\\t  { yymore();}
\\r  { yymore();}
\\b  { yymore();}
\\f  { yymore();}
\\(.|\n)  {yymore();}

     
[^\\\n\"]+        {yymore();}
                     
}


	   

{DELIMITER} { }   

{NEWLINE} {lineno++;}
	    

 /*------Print the symbol table and constants table once you reach <EOF>------*/
 			 
<<EOF>>   { FILE** fout=&stdout;
           printf("\n\n===============================================\n");
           printf("------------------SYMBOL TABLE-----------------\n");
           printf("===============================================\n\n");
            symtab_dump(*fout);
            printf("\n\n==========================================\n");
           printf("---------------CONSTANT TABLE-------------\n");
           printf("==========================================\n\n");
            symtab_dumpc(*fout);
            yyterminate();}

 /*----any other charaacter is unsupported by C language----*/
. {printf("line no. %d :ERROR: unsupported character:%s\n",lineno,yytext);}




%%

/* ----- USER CODE PART ----- */
/* ========================== */
int main(int argc, char **argv)
{
++argv; --argc;
if(argc>0)
	yyin=fopen(argv[0], "r");
else
	yyin=stdin;

yyparse();


}
