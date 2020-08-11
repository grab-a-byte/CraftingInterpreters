module Scanner

type TokenType =
    // Single-character tokens.
    | LEFT_PAREN | RIGHT_PAREN | LEFT_BRACE | RIGHT_BRACE
    | COMMA | DOT | MINUS | PLUS | SEMICOLON | SLASH | STAR

    // One or two character tokens.
    | BANG | BANG_EQUAL
    | EQUAL | EQUAL_EQUAL
    | GREATER | GREATER_EQUAL
    | LESS | LESS_EQUAL

     // Literals.
    | IDENTIFIER | STRING | NUMBER

    // Keywords.
    | AND | CLASS | ELSE | FALSE | FUN | FOR | IF | NIL | OR
    | PRINT | RETURN | SUPER | THIS | TRUE | VAR | WHILE

type Token = {
    TokenType: TokenType
    Lexeme: string
    Literal: obj
    Line: int
}

let tokenString token =
    sprintf "%A %s %A" token.TokenType token.Lexeme token.Literal

let scanTokens source =
    ["a |b"]