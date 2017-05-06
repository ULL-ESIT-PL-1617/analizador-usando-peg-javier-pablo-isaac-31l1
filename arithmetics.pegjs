/*
 * Classic example grammar, which recognizes simple arithmetic expressions like
 * "2*(3+4)". The parser generated from this grammar then computes their value.
 */
{
  var Parser = this;
  var util = require('util');
  Parser.symbolTable = Parser.symbolTable || {
     PI: Math.PI,
   }

  function checkId(id) {
    if (id == "true" || id == "false") {
        return false;
    }
    return true;
  }

  function op_recursive(left, operator, rest) {
    var resultado = {}
    var next_left = rest[0][1];
    if (rest.length > 1) {
    resultado =  {
          type : operator,
          izq: left,
          derecha: op_recursive(next_left, operator, rest.shift())
    }
  }else {
    resultado =  {
          type : operator,
          izq: left,
          derecha: next_left
     }
    }
    return resultado;
  }

  function evaluar(input) {
    let resultado = {};
    resultado = Parser.parse(input);
    return resultado.result;
  }

  function comparar(left, right) {
     var inicial = left;
      for(var i = 0; i < right.length;i++) {
        var t = right[i];
        var comp = t[0];
        var derecha = t[1];
        var comprobacion;
        switch(comp) {
          case '<' : comprobacion = left < derecha
                     break;
          case '<=' : comprobacion = left <= derecha
                      break;
          case '>' : comprobacion = left > derecha
                     break;
          case '>=' : comprobacion = left >= derecha
                    break;
          case '==' : comprobacion = left == derecha
                    break;

          default : console.log("Error! "+ comp);
        }
        if (!comprobacion)
          return false;
        else left = derecha;
      }
      return true;
    }
  }

start
  = a:coma {
                return a;
             }

coma
  = a:expression b:(COMA expression)* {
                                  var resultado = [];
                                   resultado.push(a);
                                   for (var i = 0; i < b.length; i++) {
                                     resultado.push(b[i][1]);
                                   }
                                   return resultado;

                             }
expression
  = exp:(bucle / conditional / funcion / comparation) {return exp;}


funcion
  = id:ID ASSIGN FUNCTION_ARROW LEFTPAR args:argumentos RIGHTPAR LEFTBRACE codigo:coma RIGHTBRACE {
                                                                                                    var result = {};
                                                                                                    var arg = []
                                                                                                    arg.push(args[0]);
                                                                                                    for (var i = 0; i < args[1].length; i++)
                                                                                                        arg.push(args[1][i][1]);
                                                                                                    result = {
                                                                                                            nombre_funcion : id,
                                                                                                            arguments : arg,
                                                                                                            code : codigo,
                                                                                                            tabla_simbolos : {}
                                                                                                      }
                                                                                                    return result;
                                                                                                  }
comparation
    = left:(assign / additive) right:(COMPARATOR (assign / additive))+ {
                                                                          var resultado = op_recursive(left, right[0][0], right);
                                                                          return resultado;
                                                                        }
     / b:(assign / additive) {return b;}


bucle
 = WHILE condition:comparation  LEFTBRACE act:coma RIGHTBRACE {
                                                            var resultado = {
                                                              type: "WHILE",
                                                              actions : act
                                                            };
                                                            return resultado;
                                                          }


conditional
  = IF cond:comparation THEN a:expression ELSE b:expression  {
                                                            var resultado = {
                                                                  type: "IF",
                                                                  condition: cond,
                                                                  type2: "THEN",
                                                                  first: a,
                                                                  type3:  "ELSE",
                                                                  second: b,
                                                        };
                                                        return resultado;
                                                    }
argumentos
  = a:(ID (COMA ID)*)?



assign
  = i:ID ASSIGN a:expression {
          var resultado = {
                type: "=",
                id: i,
                value: a
      };
      return resultado;
      }
  / a:additive {return a;}

additive
  = left:multiplicative rest:(ADDOP multiplicative)+ {
      var resultado = op_recursive(left, rest[0][0], rest);
      return resultado;
    }
  / m:multiplicative { return m;}

multiplicative
  = left:primary rest:(MULOP primary)+ {
     var resultado = op_recursive(left, rest[0][0], rest);
    return resultado;
    }
  / p:primary {return p;}

primary
  = llamada_funcion
  /boolean:BOOLEAN { return { type: "BOOLEAN", value:boolean } }
  /  integer
  / id:ID { return { type: "ID", value:id } }
  / LEFTPAR com:coma RIGHTPAR { return com; }


llamada_funcion
    = id:ID LEFTPAR args:(primary (COMA primary)*)? RIGHTPAR {

                                                        var result = {};
                                                        var arg = []
                                                        arg.push(args[0]);
                                                        for (var i = 0; i < args[1].length; i++)
                                                            arg.push(args[1][i][1]);
                                                        var resultado = {
                                                                  type : "FUNCTION_CALL",
                                                                  value: id,
                                                                  args : arg
                                                                        }
                                                        return resultado;
                                                      }

integer "integer"
  = n:NUMBER { return { type: "NUMBER", value:n } }

_ = $[ \t\n\r]*



ADDOP = PLUS / MINUS
MULOP = MULT / DIV
COMPARATOR = LETHAN / GETHAN / GTHAN / LTHAN / EQTO
BOOLEAN = TRUE / FALSE
IF =  _"if"_  { return 'if'; }
THEN =  _"then"_  { return 'then'; }
ELSE =  _"else"_  { return 'else'; }
TRUE =  _"true"_  { return 'true'; }
FALSE =  _"false"_  { return 'false'; }
WHILE = _"while"_  { return 'while'; }
LTHAN =  _"<"_  { return '<'; }
LETHAN =  _"<="_  { return '<='; }
GTHAN =  _">"_  { return '>'; }
GETHAN =  _">="_  { return '>='; }
EQTO =  _"=="_  { return '=='; }
PLUS = _"+"_  { return '+'; }
MINUS = _"-"_ { return '-'; }
MULT = _"*"_  { return '*'; }
DIV = _"/"_   { return '/'; }
FUNCTION_ARROW = _"->"_
LEFTBRACE = _"{"_
RIGHTBRACE = _"}"_
LEFTPAR = _"("_
RIGHTPAR = _")"_
COMA = _","_
NUMBER = _ digits:$[0-9]+ _ { return parseInt(digits, 10); }
ID = _ id:$([a-z_]i$([a-z0-9_]i*))_ {  return id; }
ASSIGN = _ '=' _