%{
#include<stdio.h>
#include<stdlib.h>
int flag=0;
%}

%option noyywrap
%x COMMENT_MULTI STRING_MULTI
DIGIT    	[0-9]
ID       	([a-z]|[A-Z]|_)([a-z]|[A-Z]|[0-9]|_)*
CHARACTER       ([a-z]|[A-Z]|[0-9])
CSYMBOL         "\'"

%%
 
<INITIAL>"/*" { /* begin of multi-line comment */
yymore();
BEGIN(COMMENT_MULTI); 
}


<INITIAL>["] { yymore(); BEGIN(STRING_MULTI);}

<STRING_MULTI>[^"]+ {yymore(); }

<STRING_MULTI>["]    {printf("String was : %s\n",yytext); BEGIN(INITIAL); }

<STRING_MULTI><<EOF>> {printf("Unterminated String: %s\n",yytext); yyterminate();}



<COMMENT_MULTI>"*/" { 
/* end of multi-line comment */
printf("'%s': was a multi-line comment\n", yytext);
BEGIN(INITIAL); 
}

<COMMENT_MULTI>. { 
yymore();
} 

<COMMENT_MULTI>\n { 
yymore();
} 

<COMMENT_MULTI><<EOF>> {printf("Unterminated Comment: %s\n", yytext); 
yyterminate();}


("//"([ \t]|[a-z]|[A-Z]|[0-9])*)|("/*"([a-z]|[A-Z]|[0-9)|[ \t\n])*"*/")		           {printf("Comment:%s\n",yytext);}
auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while                                   {printf( "A keyword:%s\n", yytext );}
{DIGIT}+    	                                                                           {printf( "Integer constants:%s (%d)\n", yytext,atoi( yytext ) );}

"\a"|"\\n"|"\\b"|"\t"|"\\t"|"\b"|"\\a" {if(flag==1) {;} else fprintf(yyout,"%s\tESCAPE SEQUENCES\n",yytext);}

(DIGIT)+("E"("+"|"-")?(DIGIT)+)?	{if(flag==1){;} else fprintf(yyout,"%sINTEGER LITERAL\n",yytext);}
(CSYMBOL)+(CHARACTER)+(CSYMBOL)         {if(flag==1){;} else fprintf(yyout,"%s CHARACTERLITERAL\n",yytext);}
'([^'\\\n]|\\.)'                         {if(flag==1){;} else fprintf(yyout,"%s CHARACTERLITERAL\n",yytext);}\
'  					 {if(flag==1){;} else fprintf(yyout,"%s unterminated CHARACTERLITERAL\n",yytext);}
''                                       {if(flag==1){;} else fprintf(yyout,"%s Empty CHARACTERLITERAL\n",yytext);}

   
(DIGIT)+"."(DIGIT)+("E"("+"|"-")?(DIGIT)+)? {if(flag==1) {;} else fprintf(yyout,"%s\tFLOAT LITERAL\n",yytext);}  


{ID}                                                                                       {printf( "Identifier:%s\n", yytext );}
"+"|"-"|"/"|"%"|"*"|"|"|"="|"=="|"&"|"&&"|"<"|">"|"<="|">="|"+="|"-="|"*="|"/="|"++"|"--"  {printf( "An operator:%s\n", yytext );}
"#define"|"#include"	                                                                   {printf("preprocessors:%s\n",yytext);}
[ \t\n]+                                                                                   {}
","|";"|"{"|"}"|"\."|"\("|"\)"			                                           {printf("special symbols:%s\n",yytext);}
.                                                                                          {printf(" Unrecognized character:%s\n", yytext );}
%%
int main(){
yylex();
}
