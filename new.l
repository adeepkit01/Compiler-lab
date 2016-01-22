%{
#include<stdio.h>
#include<stdlib.h>
int flag=0;
%}

%option noyywrap
%x Multiline_comment String_lit Escape
DIGIT    	[0-9]
ID       	([a-z]|[A-Z]|_)([a-z]|[A-Z]|[0-9]|_)*
CHARACTER       ([a-z]|[A-Z]|[0-9])
CSYMBOL         "\'"

%%
 
<INITIAL>"/*" { /* begin of multi-line comment */
yymore();
BEGIN(Multiline_comment); 
}


<INITIAL>["] { yymore(); BEGIN(String_lit);}

<String_lit>[^"\n\\]+ {yymore(); }

<String_lit>["]    {printf("String was : %s\n",yytext); BEGIN(INITIAL); }

<String_lit>\\ {yymore(); BEGIN(Escape);}

<String_lit><<EOF>> {printf("Unterminated String: %s\n",yytext); yyterminate();}
<String_lit>\n {printf("Unterminated String: %s\n",yytext); yyterminate();}

<Escape>[a|n|b|t|f|r|v|\|"|'|?] {yymore(); printf("Escape Sequence \n"); BEGIN(String_lit);}
<Escape>. {printf("Unrecognised escape sequence\n"); yyterminate();}



<Multiline_comment>"*/" { 
/* end of multi-line comment */
printf("'%s': was a multi-line comment\n", yytext);
BEGIN(INITIAL); 
}

<Multiline_comment>. { 
yymore();
} 

<Multiline_comment>\n { 
yymore();
} 

<Multiline_comment><<EOF>> {printf("Unterminated Comment: %s\n", yytext); 
yyterminate();}


("//"([ \t]|[a-z]|[A-Z]|[0-9])*)|("/*"([a-z]|[A-Z]|[0-9)|[ \t\n])*"*/")		           {printf("Comment:%s\n",yytext);}
auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while                                   {printf( "A keyword:%s\n", yytext );}
("+"|"-")?{DIGIT}+("u"|"U")?("l"|"L")?    	                                                                           {printf( "Integer constants:%s (%d)\n", yytext,atoi( yytext ) );}

("+"|"-")?{DIGIT}*("."){DIGIT}+("f"|"F")?("l"|"L")?     	                                                                           {printf( "Float constants:%s (%f)\n", yytext,atof( yytext ) );}


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
