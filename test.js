var chai = require('chai');
var PEG = require('./arithmetics.js');
var expect = chai.expect;

function clear(str){
  return str.replace(/\s/g,'');;
}

describe("Expresiones aritmeticas", function () {
  it("# a = (3+4) * 6", function(){
    var tree = `[
      {
        "type": "=",
        "id": {
          "type": "ID",
          "value": "a",
          "constante": "no"
        },
        "value": {
          "type": "*",
          "izq": [
            {
              "type": "+",
              "izq": {
                "type": "NUMBER",
                "value": 3
              },
              "derecha": {
                "type": "NUMBER",
                "value": 4
              }
            }
          ],
          "derecha": {
            "type": "NUMBER",
            "value": 6
          }
        }
      }
    ]`;
    var res = clear(JSON.stringify(PEG.parse('a = (3+4) * 6;'), null, 2))
    expect(res).to.equal(clear(tree));
  });
  
  it("# b = c = 4 / 5", function(){
    var tree = `[
      {
        "type": "=",
        "id": {
          "type": "ID",
          "value": "b",
          "constante": "no"
        },
        "value": {
          "type": "=",
          "id": {
            "type": "ID",
            "value": "c",
            "constante": "no"
          },
          "value": {
            "type": "/",
            "izq": {
              "type": "NUMBER",
              "value": 4
            },
            "derecha": {
              "type": "NUMBER",
              "value": 5
            }
          }
        }
      }
    ]`;
    var res = clear(JSON.stringify(PEG.parse('b = c = 4 / 5;'), null, 2))
    expect(res).to.equal(clear(tree));
  });
});

describe("Declaraciones de constantes", function () {
  it("# const a = 5", function(){
    var tree = `[
      {
        "type": "=",
        "id": {
          "type": "ID",
          "value": "c",
          "constante": "si"
        },
        "value": {
          "type": "NUMBER",
          "value": 5
        }
      }
    ]`;
    tree = clear(tree);
    var res = clear(JSON.stringify(PEG.parse('const c = 5;'), null, 2))
    expect(res).to.equal(tree);
  });
});

describe("Funciones", function () {
  it("# Declaraciones", function(){
    var tree = `[{         "nombre_funcion": {           "type": "ID",           "value": "f",           "constante": "no"         },         "arguments": [           {             "type": "ID",             "value": "a",             "constante": "no"           },           {             "type": "ID",             "value": "b",             "constante": "no"           },           {             "type": "ID",             "value": "c",             "constante": "no"           }         ],         "code": [           {             "type": "=",             "id": {               "type": "ID",               "value": "i",               "constante": "no"             },             "value": {               "type": "NUMBER",               "value": 0             }           },           {             "type": "=",             "id": {               "type": "ID",               "value": "h",               "constante": "no"             },             "value": {               "type": "NUMBER",               "value": 0             }           }         ]       }     ]`
    tree = clear(tree);
    var res = clear(JSON.stringify(PEG.parse(`f = ->(a,b,c){
    	i=0;
    	h=0;
    };`), null, 2))
    expect(res).to.equal(tree);
  });
  
  it("# Llamada ", function(){
    var tree = `[   {     "type": "FUNCTION_CALL",     "value": "f",     "args": [       {         "type": "NUMBER",         "value": 1       },       {         "type": "NUMBER",         "value": 2       },       {         "type": "NUMBER",         "value": 3       }     ]   } ]`;
    tree = clear(tree);
    var res = clear(JSON.stringify(PEG.parse('f(1,2,3);'), null, 2))
    expect(res).to.equal(tree);
  });
});

describe("Condicionales y bucles", function () {
  it("# If-Else", function(){
    var tree = `[   {     "type": "IF-ELSE",     "condition": {       "type": "==",       "izq": {         "type": "ID",         "value": "j",         "constante": "no"       },       "derecha": {         "type": "NUMBER",         "value": 4       }     },     "first": [       {         "type": "=",         "id": {           "type": "ID",           "value": "a",           "constante": "no"         },         "value": {           "type": "/",           "izq": {             "type": "NUMBER",             "value": 4           },           "derecha": {             "type": "NUMBER",             "value": 5           }         }       },       {         "type": "=",         "id": {           "type": "ID",           "value": "b",           "constante": "no"         },         "value": {           "type": "NUMBER",           "value": 345         }       }     ],     "second": [       {         "type": "=",         "id": {           "type": "ID",           "value": "v",           "constante": "no"         },         "value": {           "type": "NUMBER",           "value": 9         }       }     ]   } ]`;
    tree = clear(tree);
    var res = clear(JSON.stringify(PEG.parse(`if (j == 4){ a = 4 /5; b = 345;}else{v = 9}`), null, 2))
    expect(res).to.equal(tree);
  });
  it("# Bucle while", function(){
    var tree = `[   {     "type": "WHILE",     "condition": {       "type": "<",       "izq": {         "type": "ID",         "value": "i",         "constante": "no"       },       "derecha": {         "type": "NUMBER",         "value": 6       }     },     "actions": [       {         "type": "=",         "id": {           "type": "ID",           "value": "h",           "constante": "no"         },         "value": {           "type": "+",           "izq": {             "type": "ID",             "value": "a",             "constante": "no"           },           "derecha": {             "type": "NUMBER",             "value": 2           }         }       },       {         "type": "=",         "id": {           "type": "ID",           "value": "i",           "constante": "no"         },         "value": {           "type": "+",           "izq": {             "type": "ID",             "value": "i",             "constante": "no"           },           "derecha": {             "type": "NUMBER",             "value": 1           }         }       }     ]   } ]`;
    tree = clear(tree);
    var res = clear(JSON.stringify(PEG.parse('while(i < 6){h = a + 2;i = i +1};'), null, 2))
    expect(res).to.equal(tree);
  });
});