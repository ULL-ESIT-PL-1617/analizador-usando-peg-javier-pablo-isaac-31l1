
### Gramática
Σ = { ADDOP, MULOP, COMPARATOR, NUMBER, ID, WHILE, LEFTBRACE, RIGHTBRACE, LEFTPAR, RIGHTPAR, IF, THEN, ELSE, TRUE, FALSE, COMA, ASSIGN }

V = { start, expression, funcion, bucle, argumentos, coma , assign, conditional, comparation, additive, multiplicative, primary, llamada_funcion, integer}

Productions:

    start → coma
    coma → expression ( , expression )*
    expression → bucle/ conditional / funcion / comparation
    funcion → ID ASSIGN FUNCTION_ARROW LEFTPAR argumentos RIGHTPAR LEFTBRACE coma RIGHTBRACE
    comparation → (assign / additive) (COMPARATOR (assign / additive))+ / (assign / additive)
    conditional → IF expression THEN expression ELSE expression
    argumentos → (ID (COMA ID)*)?
    assign → ID ASSIGN expression
    additive → multiplicative (ADDOP multiplicative)*
    multiplicative → primary (MULOP primary)*
    bucle → WHILE comparation coma RIGHTBRACE
    primary → llamada_funcion | BOOLEAN | integer | ID | LEFTPAR comma RIGHTPAR
    llamada_funcion → ID LEFTPAR (primary (COMA primary)*)? RIGHTPAR
    integer → NUMBER
