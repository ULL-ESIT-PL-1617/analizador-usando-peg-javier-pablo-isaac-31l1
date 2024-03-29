# Información

## Miembros:
* [Pablo Pastor Martín](https://alu0100890839.github.io)
* [Isaac Aimán Salas](https://alu0100841565.github.io)
* [Javier Rámos Fernández](https://alu0100884982.github.io)

## Uso
Para ejecutar los test: `mocha`

Para ejecutar: `node mainfromfile.js [archivo]` ó `node mainfromfile.js [codigo]`

## Gramática

Σ = { ADDOP, MULOP, COMPARATOR, NUMBER, ID, WHILE, LEFTBRACE, RIGHTBRACE, LEFTPAR, RIGHTPAR, RETURN, IF, THEN, ELSE, TRUE, FALSE, COMA, ASSIGN, INCREMENT, DECREMENT, FOR ';' }

V = { start, expression, funcion, bucle, argumentos, coma , assign, conditional, comparation, additive, multiplicative, primary, llamada_funcion, integer}

Productions:

    start → coma

    coma → expression ( ';' expression )*

    expression → bucle/ conditional / funcion / comparation

    funcion → identifier ASSIGN FUNCTION_ARROW LEFTPAR
    argumentos? RIGHTPAR LEFTBRACE coma? (RETURN expression )? ';' RIGHTBRACE

    comparation → (assign / additive) (COMPARATOR (assign / additive))+ / (assign / additive)

    conditional → IF expression THEN expression ELSE expression

    argumentos → (identifier (COMA ID)*)?

    assign → identifier ASSIGN expression

    additive → multiplicative (ADDOP multiplicative)*

    multiplicative → primary (MULOP primary)* / primary

    bucle → WHILE comparation LEFTBRACE coma RIGHTBRACE / FOR LEFTPAR assign ';' comparation ';' ID (INCREMENT/DECREMENT) RIGHTPAR LEFTBRACE coma COMA RIGHTBRACE

    primary → llamada_funcion | BOOLEAN | integer | identifier | LEFTPAR coma RIGHTPAR

    identifier → CONST ID | ID

    llamada_funcion → ID LEFTPAR (primary (COMA primary)*)? RIGHTPAR

    integer → NUMBER
