package simpleinterpreter;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.Arrays;
import static simpleinterpreter.TokenType.*;

class Token {
    final TokenType type;
    final String lexeme;
    final Object literal;
    final int line;
    final int start;
    final int end;

    Token(TokenType type, String lexeme, Object literal, int line, int start, int end) {
        this.type = type;
        this.lexeme = lexeme;
        this.literal = literal;
        this.line = line;
        this.start = start;
        this.end = end;
    }

    int getTokenCategory(){
        TokenType single_char[] = {LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE, COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR};

        TokenType two_chars[] = {BANG, BANG_EQUAL,EQUAL, EQUAL_EQUAL, GREATER, GREATER_EQUAL, LESS, LESS_EQUAL};

        TokenType literals[] = {IDENTIFIER, STRING, NUMBER};

        TokenType keywords[] = {AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR, PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE};

        if(Arrays.asList(single_char).contains(type)){
            return 1;
        }
        else if(Arrays.asList(two_chars).contains(type)){
            return 2;
        }
        else if(Arrays.asList(literals).contains(type)){
            return 3;
        }
        else if(Arrays.asList(keywords).contains(type)){
            return 4;
        }
        return 0;
    }

    public String toString() {
        return type + "," + lexeme + "," + literal + "," + line + "," + start + "," + end + "," + getTokenCategory();
    }

    JSONObject getTokenJSON(){
        JSONObject tokenJSON = new JSONObject();
        tokenJSON.put("type", type);
        tokenJSON.put("lexeme", lexeme);
        tokenJSON.put("literal", (literal == null ? "" : literal.toString()));
        tokenJSON.put("line", line);
        tokenJSON.put("line", line);
        tokenJSON.put("start", start);
        tokenJSON.put("end", end);
        tokenJSON.put("category", getTokenCategory());
        return tokenJSON;
    }
}