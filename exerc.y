%{
  import java.io.*;
%}
   

%token IF, DO, TO, THEN, ELSE, BY
%token AND, NUM, IDENT, INT, DOUBLE, BOOLEAN, WHILE

%right '='
%nonassoc '>'
%left AND
%left '+' '-'
%left '*' '/'

%%
 
Prog : Decl ListaFuncoes
      ;

Decl : Tipo LId ';' Decl
     |
     ;

Tipo : INT
      | DOUBLE
      | BOOLEAN
      ;

LId : LId ',' IDENT
    | IDENT
    ;

ListaFuncoes : ListaFuncoes funcao
              |
              ;

funcao : Tipo IDENT '(' ListaParametros ')' '{' Decl '}' '{' LCmd '}'

ListaParametros : Tipo IDENT
                | Tipo IDENT , ListaParametros
                ;

Bloco : '{' LCmd '}'
      ;

LCmd : Cmd LCmdo
     |       // vazio
     ;

Cmd : Bloco
    | if ( E ) Cmd
    | if ( E ) Cmd else Cmd
    | while ( E ) Cmd
    | E ;
    ;

E : E = E
  | E '+' E
  | E '-' E
  | E '*' E 
  | E '/' E
  | E > E
  | E AND E
  | NUM
  | IDENT
  | ( E )
  ;


%%

  private Yylex lexer;


  private INT yylex () {
    INT yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.prINTln("IO error :"+e.getMessage());
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.prINTln ("Error: " + error);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }


  static BOOLEAN INTeractive;

  public void setDebug(BOOLEAN debug) {
    yydebug = debug;
  }


  public static void main(String args[]) throws IOException {
    System.out.prINTln("");

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
    }
    else {System.out.prINT("> ");
      INTeractive = true;
	    yyparser = new Parser(new InputStreamReader(System.in));
    }

    yyparser.yyparse();
    
  //  if (INTeractive) {
      System.out.prINTln();
      System.out.prINTln("done!");
  //  }
  }






