/*jsdfjslf*/
%option noyywrap
%{
#include<stdio.h>
#include<stdlib.h>
#include <assert.h>
#include "y.tab.h"
int flag=0;
int Error=0;
char token[100];
typedef struct list_entry list_entry_t;

struct list_entry {
	void *key;
	void *value;
	list_entry_t *next;
};

typedef struct{
	list_entry_t *list;
	int (*cmp)(const void *, const void *); /*Comparison function */
} list_head_t;

list_head_t* head[10];
list_head_t* headc[10];
void installID() ;
void installCON();
%}


%x Multiline_comment String_lit Escape
DIGIT    	[0-9]
ID       	([a-z]|[A-Z]|_)([a-z]|[A-Z]|[0-9]|_)*
BID		([0-9]|$)([a-z]|[A-Z]|[0-9]|_|$)*
CHARACTER       ([a-z]|[A-Z]|[0-9])
CSYMBOL         "\'"
%%

[\n]+ {yylineno++;} 
<INITIAL>"/*" { /* begin of multi-line comment */
yymore();
BEGIN(Multiline_comment); 
}


<INITIAL>["] { yymore(); BEGIN(String_lit);}

<String_lit>[^"\n\\]+ {yymore(); }

<String_lit>["]    {installCON(); printf("String was : %s\tline no:%d\n",yytext,yylineno); sprintf(token,"String_Literal"); BEGIN(INITIAL);return (STRING_LITERAL); }

<String_lit>\\ {yymore(); BEGIN(Escape);}

<String_lit><<EOF>> {Error=1;printf("Unterminated String: %s\tline no:%d\n",yytext,yylineno); yyterminate();}
<String_lit>\n {Error=1;yylineno++;printf("Unterminated String: %s\tline no:%d\n",yytext,yylineno); yyterminate();}

<Escape>[a|n|b|t|f|r|v|\|"|'|?] {yymore(); printf("Escape Sequence    \tline no:%d \n",yylineno); BEGIN(String_lit);}
<Escape>. {Error=1;printf("Unrecognised escape sequence    \tline no:%d\n",yylineno); yyterminate();}



<Multiline_comment>"*/" { 
/* end of multi-line comment */
printf("was a multi-line comment:'%s'\tline no:%d\n", yytext,yylineno);
BEGIN(INITIAL); 
}

<Multiline_comment>. { 
yymore();
} 

<Multiline_comment>\n {
yymore();
} 

<Multiline_comment><<EOF>> {Error=1;printf("Unterminated Comment: %s\tline no:%d\n", yytext,yylineno); 
yyterminate();}

"*/"     {Error=1;printf("Uninitiated Comment\tline no:%d\n",yylineno); yyterminate();}

("//"([ \t]|[a-z]|[A-Z]|[0-9])*)	           {printf("Comment:%s\tline no:%d\n",yytext,yylineno);}


"volatile" {/* begin keywords */ sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return( VOLATILE); }

"char" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return( CHAR); } 
	  
"int" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno);return(INT); } 
	  
"void" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(VOID); }
	  
"if" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno);return(IF); }
	  
"else" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(ELSE); }
	  
"while" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(WHILE); }
	  
"for" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(FOR); }
	  
"continue" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(CONTINUE); }
	  
"break" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(BREAK); } 
	  
"return" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(RETURN); } 
	  
"auto" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(AUTO); } 
	   
"extern" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(EXTERN); } 
	  
"float" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(FLOAT); } 
	  
"double" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(DOUBLE); }
	  
"switch" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(SWITCH); }
	  
"case" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(CASE); } 
	   
"const" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(CONST); }
	   
"default" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(DEFAULT); }
	   
"long" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(LONG); } 
	   
"register" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(REGISTER); }
	   
"short" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(SHORT); }
	   
"signed" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(SIGNED); }
	    
"static" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(STATIC); } 
	    
"unsigned" {sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(UNSIGNED); }
	   
"do" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(DO); } 
	 
"enum" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(ENUM); }
	   
"struct" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(STRUCT); } 
	   
"union"	{ sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(UNION); } 
	   
"goto" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(GOTO); }
	   
"sizeof" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno);return(SIZEOF); }
	   
"typedef" { sprintf(token,"Keyword"); installID();printf( "A keyword:%s\tline no:%d\n", yytext,yylineno); return(TYPEDEF); }
	   


("+"|"-")?{DIGIT}+("u"|"U")?("l"|"L")?    	                                           { /*here we take on constants*/sprintf(token,"Integer_Literal"); installCON();printf( "Integer constants:%s (%d)\tline no:%d \n", yytext,atoi( yytext ),yylineno); return (CONSTANT); }

("+"|"-")?{DIGIT}*("."){DIGIT}+("f"|"F")?("l"|"L")?     	                                                                             {sprintf(token,"Float_Literal"); installCON();printf( "Float constants:%s (%f)\tline no:%d\n", yytext,atof( yytext ),yylineno); return (CONSTANT);  }


"\a"|"\\n"|"\\b"|"\t"|"\\t"|"\b"|"\\a" {if(flag==1) {;} else{sprintf(token,"Escape_Sequence"); installID(); fprintf(yyout,"%s\tESCAPE SEQUENCES\tline no:%d\n",yytext,yylineno); }}

{DIGIT}+("E"|"e")("+"|"-")?{DIGIT}+?	{if(flag==1){;} else {sprintf(token,"Integer_Literal");installCON();fprintf(yyout,"%s INTEGER LITERAL\tline no:%d\n",yytext,yylineno); return (CONSTANT);}}

'([^'\\\n]|\\.)'                         {if(flag==1){;} else{ sprintf(token,"Char_Literal"); installCON(); fprintf(yyout,"%s CHARACTERLITERAL\tline no:%d\n",yytext,yylineno);return (CONSTANT);}}
\'  					 {if(flag==1){;} else fprintf(yyout,"%s unterminated CHARACTERLITERAL\tline no:%d\n",yytext,yylineno);}
''                                       {if(flag==1){;} else fprintf(yyout,"%s Empty CHARACTERLITERAL\tline no:%d\n",yytext,yylineno);}

   
{DIGIT}+"."{DIGIT}+("E"("+"|"-")?{DIGIT}+)? {if(flag==1) {;} else{ sprintf(token,"Float_Literal");installCON(); fprintf(yyout,"%s\tFLOAT LITERAl\tline no:%d\n",yytext,yylineno); return (CONSTANT);}} 

{ID}+".h"                                                                              {sprintf(token,"Header"); installID(); printf( "header:%s\tline no:%d\n", yytext,yylineno ); }
{BID}								{printf( "Illegal Identifier:%s\tline no:%d\n",yytext,yylineno);}                                                                         
{ID}                                                                                       { sprintf(token,"Identifier"); installID(); printf( "Identifier:%s\tline no:%d\n", yytext,yylineno );return (IDENTIFIER);}


"*=" {/*for operators*/ sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(MUL_ASSIGN); }

"/=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(DIV_ASSIGN); }

"%=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(MOD_ASSIGN); }

"-=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(SUB_ASSIGN); }

"+=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(ADD_ASSIGN); }

">>=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(RIGHT_ASSIGN); }

"<<=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(LEFT_ASSIGN); }

"&=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(AND_ASSIGN); }

"|=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(OR_ASSIGN); }

"^=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(XOR_ASSIGN); }

"<<" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(LEFT_OP); }

">>" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(RIGHT_OP); }  

"++" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(INC_OP); } 

"--" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(DEC_OP); } 

"+" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('+'); } 
    
"-" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('-'); } 
      
"*" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('*'); }
      
"/" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return( '/'); }
      
"%" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return( '%');}
      
"&&" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return( AND_OP);}
      
"||" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(OR_OP); }
     
"!" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('!'); }
      
"<" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno);return('<');} 
      
">" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno);return('>');} 

":" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(':');} 

"?" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('?');} 
      
"<=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return( LE_OP); } 
     
">=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return( GE_OP); } 
      
"==" {sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return( EQ_OP); }
      
"!=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return( NE_OP); }

"&" {sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('&'); }
      
"|" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('|'); } 
      
"^" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('^'); }
      
"(" {sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('('); } 
      
")" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(')'); }
      
"[" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('['); }
      
"]" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno);return(']'); } 
      
"{" {sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('{'); }
      
"}" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('}'); }
      
"," { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(','); }
      
";" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return(';'); }
      
"=" { sprintf(token,"operator"); installID();printf( "An operator:%s\tline no:%d\n", yytext ,yylineno); return('='); }
      

"#define"|"#include"	                                                                   {sprintf(token,"Preprocessor Directive"); installID();printf("preprocessors:%s\tline no:%d\n",yytext,yylineno); }
[ \t]+                                                                                               {}
","|";"|"{"|"}"|"\."|"\("|"\)"			                                           {sprintf(token,"Special_Symbols"); installID();printf("special symbols:%s\tline no:%d\n",yytext,yylineno); }
.                                                                                          {printf(" Unrecognized character :%s\tline no:%d\n", yytext,yylineno );}
%%


//Function to initialise the linked lists

list_head_t *list_init(int (*cmp)(const void *, const void *)){
	assert(cmp!=NULL);

	//Create the head
	list_head_t *newList;

	//Allocate the list	
	newList = (list_head_t *) malloc(sizeof(list_head_t));
	if (newList == NULL) {
		fprintf(stderr, "Cannot allocate list head\n");
		exit(EXIT_FAILURE);
	}
	
	//Assign comparison function
	newList->cmp=cmp;

	//Return the list head
	return newList;
}

//Function to insert the symbol

list_entry_t *list_insert(list_head_t *head, void *key, void *value)
{
	assert(head!=NULL&&key!=NULL);

	//Create the list entry
	list_entry_t *entry;
	
	//Allocate the list entry
	entry = (list_entry_t *) malloc(sizeof(list_entry_t));
	if(entry == NULL) {
		return NULL;
	}
	
	//Assign values
	entry->key=key;
	entry->value=value;
	entry->next=head->list;

	//Move the head pointer
	head->list=entry;
	return entry;
}

//Function to search for a symbol during insertion

list_entry_t *list_search_entry(list_head_t *head, void *key)
{
	assert(head!=NULL&&key!=NULL);

	//Create a list entry to store temp values in
	list_entry_t* test;

	//Start with first element after head
	test=head->list;

	//Loop until end of list
	while(test!=NULL){
		//If key matches, return value
		if(head->cmp(key,test->key)==0)
			return test;
		test=test->next;
	}
	return NULL;
}

//Function to search for a value

void *list_search(list_head_t *head, void *key)
{
	assert(head!=NULL&&key!=NULL);

	//Create a list entry to store temp values in
	list_entry_t* test;

	//Start with first element after head
	test=head->list;

	//Loop until end of list
	while(test!=NULL){
		//If key matches, return value
		if(head->cmp(key,test->key)==0)
			return test->value;
		test=test->next;
	}
	return NULL;
}

//Function to print symbol table

int print_table(int i){

        if(head[i]->list==NULL)
        {
            //printf("List empty for this hash\n");
            return;
        }	
	list_entry_t* entry=head[i]->list;
        printf("HASH %d [%s, %s]",i, (char*)entry->key, (char*)entry->value);
        entry=entry->next;
	while(entry!=NULL)
	{
	        printf("->[%s, %s]",(char*)entry->key, (char*)entry->value);
		entry=entry->next;
	}
        printf("\n");
}

//Function to print symbol table

int print_tablec(int i){

        if(headc[i]->list==NULL)
        {
            return;
            
        }	
	list_entry_t* entry=headc[i]->list;
        printf("HASH %d [%s, %s]",i, (char*)entry->key, (char*)entry->value);
        entry=entry->next;
	while(entry!=NULL)
	{
		printf("->[%s, %s] ",(char*)entry->key, (char*)entry->value);
		entry=entry->next;
	}
       printf("\n");
}

//Used for searching table
int cmp_string( const void *a, const void *b)
{
	assert(a!=NULL);
	assert(b!=NULL);
	return strcmp(a,b);
}

//Installation functions

void installID(){
         int i=0, sum=0;
	char* key=calloc(strlen(yytext),sizeof(char));
        char* val=calloc(strlen(token),sizeof(char));
         for(i=0;yytext[i]!='\0';i++){
          sum=sum+yytext[i];
          }
          sum%=10;
	strcpy(key, yytext);
        strcpy(val, token);
	list_entry_t* entry=list_search_entry(head[sum], key);
	if(entry==NULL)
	 (void*)list_insert(head[sum], key, val);
}

void installCON(){
         int i=0, sum=0;
	char* key=calloc(strlen(yytext),sizeof(char));
        char* val=calloc(strlen(token),sizeof(char));
         for(i=0;yytext[i]!='\0';i++){
          sum=sum%10+yytext[i]%10;
          }
         sum%=10;
	strcpy(key, yytext);
        strcpy(val, token);
	list_entry_t* entry=list_search_entry(headc[sum], key);
	if(entry==NULL)
	 (void*)list_insert(headc[sum], key, val);
}

int main(){

int i;
for(i=0;i<10;i++)
{
head[i]=list_init(cmp_string);
headc[i]=list_init(cmp_string);
}
yylex();
yyparse();
if(Error)
exit(0);
printf("\tSymbol table\n");
for(i=0;i<10;i++)
print_table(i);
i=0;
printf("\n\n\tConstant table\n");
for(i=0;i<10;i++)
print_tablec(i);
}
