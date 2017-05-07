/*
* Classic example grammar, which recognizes simple arithmetic expressions like
* "2*(3+4)". The parser generated from this grammar then computes their value.
*/

{
  var tabla_constantes = [];
  function op_recursive(left, operator, rest) {
          console.log("REST :", rest.length , " array: ", rest)
     var resultado = {}
      var next_left = rest[0][1];
      if (rest.length > 1) {
        rest.shift()
      resultado =  {
            type : operator,
            izq: left,
            derecha: op_recursive(next_left, operator, rest)
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

}

start
= a:coma {
  return a;
}

coma
= a:expression b:(PUNTCOMA expression)* {
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
= id:identifier ASSIGN FUNCTION_ARROW LEFTPAR args:(argumentos)? RIGHTPAR LEFTBRACE codigo:(coma)? ret:(RETURN expression)? PUNTCOMA? RIGHTBRACE {
  var result = {};
  var arg = []
  if(!codigo) {
    codigo = [];
  }
  if (args && args.length > 0) {
    arg.push(args[0]);
    for (var i = 0; i < args[1].length; i++)
    arg.push(args[1][i][1]);
  }
  result = {
    nombre_funcion : id,
    arguments : arg,
    code : codigo
  }
  if(ret)
  result["return"] = ret[1];
  return result;
}

comparation
= left:(assign / additive) right:(COMPARATOR (assign / additive))+ {
  var resultado = op_recursive(left, right[0][0], right);
  return resultado;
}
/ b:(assign / additive) {return b;}


bucle
= WHILE cond:comparation  LEFTBRACE act:coma PUNTCOMA RIGHTBRACE {
  var resultado = {
    type: "WHILE",
    condition: cond,
    actions : act
  };
  return resultado;
}
/  FOR LEFTPAR ini:assign PUNTCOMA cond:comparation PUNTCOMA ident:ID i:(INCREMENT/DECREMENT) RIGHTPAR
LEFTBRACE act:coma PUNTCOMA RIGHTBRACE {
  var incremento;
  if (i == "++") {
    incremento = 1;
  } else {
    incremento = -1;
  }
  var resultado = {
    type: "FOR",
    initial: ini,
    condition : cond,
    increment: {
      id : ident,
      quantity: incremento
    },
    actions: act
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
= a:(identifier (PUNTCOMA identifier)*)?


assign
= i:identifier ASSIGN a:expression {
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
/ p:primary &{if (p.value == "return") return false; else return true;} {return p;}


primary
= llamada_funcion
/boolean:BOOLEAN { return { type: "BOOLEAN", value:boolean } }
/  integer
/ identifier
/ LEFTPAR com:coma RIGHTPAR { return com; }


identifier
= CONST cid:ID { tabla_constantes.push(cid); return { type: "ID", value:cid, constante: "si" } }
/ id:ID {
  if(tabla_constantes.indexOf(id) > -1)
  return { type: "ID", value:id, constante: "si" }
  else   return { type: "ID", value:id, constante: "no" }
}


llamada_funcion
= id:ID LEFTPAR args:(primary (COMMA primary)*)? RIGHTPAR {
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
FOR = _"for"_  { return 'for'; }
INCREMENT = _"++"_  { return '++'; }
DECREMENT = _"--"_  { return '--'; }
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
RETURN = _"return"_ { return 'return'; }
CONST = _"const"_ { return 'const'; }
LEFTBRACE = _"{"_
RIGHTBRACE = _"}"_
LEFTPAR = _"("_
RIGHTPAR = _")"_
PUNTCOMA = _";"_
COMMA = _","_
NUMBER = _ digits:$[0-9]+ _ { return parseInt(digits, 10); }
ID = _ id:$([a-z_]i$([a-z0-9_]i*))_ {  return id; }
ASSIGN = _ '=' _
