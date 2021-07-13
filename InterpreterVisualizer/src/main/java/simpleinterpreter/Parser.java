package simpleinterpreter;

import java.util.ArrayList;
import java.util.List;

import static simpleinterpreter.TokenType.*;

class Parser {

    private static class ParseError extends RuntimeException {

    }

    List<Stmt> statements = new ArrayList<>();

    private final List<Token> tokens;
    private int current = 0;


    /********************** Visualization ***************/
    private final List<StatementGraph> statmentsGraph;

    private int nodeIndex;
    private int astNodeIndex;
    private int statementIndex = -1;

    void addNewStatement() {
        statementIndex++;
        statmentsGraph.add(new StatementGraph());
        nodeIndex = -1;
        astNodeIndex = -1;
    }

    void addNewNode(String data) {
        nodeIndex++;
        currentStatement().addNewNode(nodeIndex, data);
    }

    void addNewASTNode(int nodeIndex, List<String> data, List<Integer> neighbours) {
        astNodeIndex++;
        currentStatement().addASTNode(nodeIndex, astNodeIndex, data, neighbours);
    }

    StatementGraph currentStatement() {
        return statmentsGraph.get(statementIndex);
    }

    void visitNode(int nodeIndex, String data) {
        currentStatement().visitNode(nodeIndex, data);
    }

    void consumeToken(int tokenIndex) {
        currentStatement().consumeToken(tokenIndex);
    }

    public List<StatementGraph> getStatmentsGraph() {
        return statmentsGraph;
    }

    void reportError(String message) {
        currentStatement().reportSyntaxError(message);
    }

    /***************************************************************/


    SimpleInterpreter simpleInterpreter;

    Parser(List<Token> tokens, SimpleInterpreter simpleInterpreter) {
        this.tokens = tokens;
        this.simpleInterpreter = simpleInterpreter;
        statmentsGraph = new ArrayList<>();
    }


    public List<Stmt> getStatements() {
        return statements;
    }

    void parse() {
        int nodeIdx = nodeIndex;
        while (!isAtEnd()) {
            addNewStatement();
            addNewNode("Program Entry Rule");
            statements.add(declaration());
            visitNode(nodeIdx, "Parsing is done");
        }
    }

    private Stmt declaration() {
        addNewNode("Declaration Rule");
        int nodeIdx = nodeIndex;

        try {
            Stmt ret;
            visitNode(nodeIdx, "Looking for \"var\" keyword");
            if (match(VAR)) {
                visitNode(nodeIdx, "\"var\" keyword is parsed, moving to varDecl rule");
                ret = varDeclaration();
                visitNode(nodeIdx, "");
                return ret;
            }
            visitNode(nodeIdx, "Couldn't find \"var\" keyword, moving to statement rule");
            ret = statement();
            visitNode(nodeIdx, "");
            return ret;
        } catch (ParseError error) {
            synchronize();
            return null;
        }
    }

    private Stmt varDeclaration() {
        addNewNode("Var Declaration Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "Looking for IDENTIFIER token");
        Token name = consume(IDENTIFIER, "Expect variable name.");
        visitNode(nodeIdx, "IDENTIFIER is parsed, looking for EQUAL operator");


        Expr initializer = null;
        if (match(EQUAL)) {
            visitNode(nodeIdx, "EQUAL operator is parsed, moving to expression rule");
            initializer = expression();
            visitNode(nodeIdx, "Expression is parsed, looking for semi-colon after variable declaration");
        } else {
            visitNode(nodeIdx, "EQUAL operator was not found, looking for semi-colon after variable declaration");
        }

        consume(SEMICOLON, "Expect ';' after variable declaration.");

        if (initializer == null)
            addNewASTNode(nodeIdx, prepareList("Variable Declaration Statement", "Variable Name: " + name.lexeme), prepareList());
        else
            addNewASTNode(nodeIdx, prepareList("Variable Declaration Statement", "Variable Name: " + name.lexeme), prepareList(initializer.astNodeIndex));
        return new Stmt.Var(name, initializer, astNodeIndex);
    }

    private Stmt whileStatement() {
        addNewNode("While Statement Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "Looking for '('");
        consume(LEFT_PAREN, "Expect '(' after 'while'.");
        visitNode(nodeIdx, "'(' is parsed, moving to the while condition with the expression rule");
        Expr condition = expression();
        visitNode(nodeIdx, "while condition is parsed, looking for ')'");
        consume(RIGHT_PAREN, "Expect ')' after condition.");
        visitNode(nodeIdx, "')' is parsed, moving to the while body with the statement rule");
        Stmt body = statement();
        visitNode(nodeIdx, "while body is parsed");

        addNewASTNode(nodeIdx, prepareList("While Statement"), prepareList(condition.astNodeIndex, body.astNodeIndex));
        return new Stmt.While(condition, body, astNodeIndex);
    }

    private Stmt statement() {
        addNewNode("Statement Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "Looking for one of the following \"if\", \"print\", \"while\" keywords or '{'");

        Stmt ret;
        if (match(IF)) {
            visitNode(nodeIdx, "if keyword is parsed, now moving to if statement rule");
            ret = ifStatement();
            visitNode(nodeIdx, "if statement is parsed");
            return ret;
        }

        if (match(PRINT)) {
            visitNode(nodeIdx, "print keyword is parsed, now moving to print statement rule");
            ret = printStatement();
            visitNode(nodeIdx, "print statement is parsed");
            return ret;
        }

        if (match(WHILE)) {
            visitNode(nodeIdx, "while keyword is parsed, now moving to while statement rule");
            ret = whileStatement();
            visitNode(nodeIdx, "while statement is parsed");
            return ret;
        }

        if (match(LEFT_BRACE)) {
            visitNode(nodeIdx, "'{' is parsed, now moving to the statements block rule");

            List<Stmt> blockOfStatements = block();

            List<Integer> indices = new ArrayList<>();
            for (Stmt s : blockOfStatements) {
                indices.add(s.astNodeIndex);
            }

            addNewASTNode(nodeIdx, prepareList("Block of Statements"), indices);

            ret = new Stmt.Block(blockOfStatements, astNodeIndex);
            visitNode(nodeIdx, "statements block is parsed");
            return ret;
        }

        visitNode(nodeIdx, "none of the keywords or left brace is found, moving to the expression statement rule");
        ret = expressionStatement();
        visitNode(nodeIdx, "expression statement is parsed");
        return ret;
    }

    private Stmt ifStatement() {
        addNewNode("if Statement Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "Looking for '(' ");
        consume(LEFT_PAREN, "Expect '(' after 'if'.");
        visitNode(nodeIdx, "'(' is parsed, moving to expression rule to parse conditions");
        Expr condition = expression();
        visitNode(nodeIdx, "conditions are parsed, looking for ')'");
        consume(RIGHT_PAREN, "Expect ')' after if condition.");
        visitNode(nodeIdx, "')' is parsed, moving to statement rule to parse if's body");
        Stmt thenBranch = statement();
        visitNode(nodeIdx, "if's body is parsed, looking for \"else\" keyword");
        Stmt elseBranch = null;
        if (match(ELSE)) {
            visitNode(nodeIdx, "\"else\" keyword is found, moving to statement rule to parse else's body");
            elseBranch = statement();
            visitNode(nodeIdx, "else's body is parsed");
        } else {
            visitNode(nodeIdx, "\"else\" keyword is not found");
        }

        if (elseBranch == null) {
            addNewASTNode(nodeIdx, prepareList("If Statement"), prepareList(condition.astNodeIndex, thenBranch.astNodeIndex));
        } else {
            addNewASTNode(nodeIdx, prepareList("If Statement"), prepareList(condition.astNodeIndex, thenBranch.astNodeIndex, elseBranch.astNodeIndex));
        }

        return new Stmt.If(condition, thenBranch, elseBranch, astNodeIndex);
    }

    private Stmt printStatement() {
        addNewNode("Print Statement Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving to the expression rule");
        Expr value = expression();
        visitNode(nodeIdx, "expression is parsed, looking for semi-colon after the expression");
        consume(SEMICOLON, "Expect ';' after value.");

        addNewASTNode(nodeIdx, prepareList("Print Statement"), prepareList(value.astNodeIndex));
        return new Stmt.Print(value, astNodeIndex);
    }

    private List<Stmt> block() {
        addNewNode("Block Rule");
        int nodeIdx = nodeIndex;

        List<Stmt> statements = new ArrayList<>();

        visitNode(nodeIdx, "Parsing statements until '}' or EOF");
        while (!check(RIGHT_BRACE) && !isAtEnd()) {
            statements.add(declaration());
            visitNode(nodeIdx, "");
        }
        visitNode(nodeIdx, "Statements are parsed, looking for '}");
        consume(RIGHT_BRACE, "Expect '}' after block.");
        return statements;
    }

    private Stmt expressionStatement() {
        addNewNode("Expression Statement Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving into expression rule");
        Expr expr = expression();
        visitNode(nodeIdx, "expression is parsed, looking for semi-colon after the expression");

        consume(SEMICOLON, "Expect ';' after expression.");

        addNewASTNode(nodeIdx, prepareList("Expression Statement"), prepareList(expr.astNodeIndex));
        return new Stmt.Expression(expr, astNodeIndex);
    }

    private Expr expression() {
        addNewNode("Expression Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving into the assignment rule");
        Expr ret = assignment();
        visitNode(nodeIdx, "assignment rule is parsed");
        return ret;
    }

    private Expr assignment() {
        addNewNode("Assignment Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving into the logical or rule");
        Expr expr = or();
        visitNode(nodeIdx, "logical or rule is parsed, looking for EQUAL operator");

        if (match(EQUAL)) {
            visitNode(nodeIdx, "EQUAL operator is parsed, moving into assignment rule");
            Token equals = previous();

            Expr value = assignment();
            visitNode(nodeIdx, "assignment rule is parsed, checking if the left hand side is a valid variable");

            if (expr instanceof Expr.Variable) {
                Token name = ((Expr.Variable) expr).name;
                addNewASTNode(nodeIdx, prepareList("Assignment Expression", "Variable Name: " + name.lexeme), prepareList(value.astNodeIndex));
                return new Expr.Assign(name, value, astNodeIndex);
            }

            error(equals, "Invalid assignment target.");
        }

        return expr;
    }

    private Expr or() {
        addNewNode("Logical OR Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving into the logical and rule");
        Expr expr = and();
        visitNode(nodeIdx, "logical and rule is parsed, looking for logical OR operator");

        visitNode(nodeIdx, "Parsing until we run out of logical OR operators");
        while (match(OR)) {
            visitNode(nodeIdx, "logical OR operator is found, moving into logical and rule");
            Token operator = previous();
            Expr right = and();
            visitNode(nodeIdx, "logical and rule is parsed");
            addNewASTNode(nodeIdx, prepareList("Logical Expression", "Operator: " + operator.lexeme), prepareList(expr.astNodeIndex, right.astNodeIndex));
            expr = new Expr.Logical(expr, operator, right, astNodeIndex);
        }

        return expr;
    }

    private Expr and() {
        addNewNode("Logical AND Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving into the expression rule");
        Expr expr = equality();
        visitNode(nodeIdx, "expression is parsed, parsing until we run out of logical AND operators");

        while (match(AND)) {
            visitNode(nodeIdx, "logical AND operator is found, moving into the equality rule");
            Token operator = previous();
            Expr right = equality();
            visitNode(nodeIdx, "equality rule is parsed");
            addNewASTNode(nodeIdx, prepareList("Logical Expression", "Operator: " + operator.lexeme), prepareList(expr.astNodeIndex, right.astNodeIndex));
            expr = new Expr.Logical(expr, operator, right, astNodeIndex);
        }

        return expr;
    }

    private Expr equality() {
        addNewNode("Equality Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving into comparison rule");
        Expr expr = comparison();
        visitNode(nodeIdx, "comparison rule is parsed, parsing until we run out of (!, !=) operators");

        while (match(BANG_EQUAL, EQUAL_EQUAL)) {
            Token operator = previous();
            visitNode(nodeIdx, "an operators is parsed, moving into comparison rule");
            Expr right = comparison();
            visitNode(nodeIdx, "comparison rule is parsed");
            addNewASTNode(nodeIdx, prepareList("Binary Expression", "Operator: " + operator.lexeme), prepareList(expr.astNodeIndex, right.astNodeIndex));
            expr = new Expr.Binary(expr, operator, right, astNodeIndex);
        }

        return expr;
    }

    private Expr comparison() {
        addNewNode("Comparison Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving into the term rule");
        Expr expr = term();
        visitNode(nodeIdx, "term rule is parsed, parsing until we run out of (>, >=, <, <=) operators");

        while (match(GREATER, GREATER_EQUAL, LESS, LESS_EQUAL)) {
            visitNode(nodeIdx, "an operator is parsed, moving into term rule");
            Token operator = previous();
            Expr right = term();
            visitNode(nodeIdx, "term rule is parsed");
            addNewASTNode(nodeIdx, prepareList("Binary Expression", "Operator: " + operator.lexeme), prepareList(expr.astNodeIndex, right.astNodeIndex));
            expr = new Expr.Binary(expr, operator, right, astNodeIndex);
        }

        return expr;
    }

    private Expr term() {
        addNewNode("Term Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving into factor rule");
        Expr expr = factor();
        visitNode(nodeIdx, "factor rule is parsed, parsing until we run out of (-, +) operators");

        while (match(MINUS, PLUS)) {
            visitNode(nodeIdx, "an operator is parsed, moving into factor rule");
            Token operator = previous();
            Expr right = factor();
            visitNode(nodeIdx, "factor rule is parsed");
            addNewASTNode(nodeIdx, prepareList("Binary Expression", "Operator: " + operator.lexeme), prepareList(expr.astNodeIndex, right.astNodeIndex));
            expr = new Expr.Binary(expr, operator, right, astNodeIndex);
        }

        return expr;
    }

    private Expr factor() {
        addNewNode("Factor Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "moving into unary rule");
        Expr expr = unary();
        visitNode(nodeIdx, "unary rule is parsed, parsing until we run out of (/, *) operators");

        while (match(SLASH, STAR)) {
            visitNode(nodeIdx, "an operator is found, moving into the unary rule");
            Token operator = previous();
            Expr right = unary();
            visitNode(nodeIdx, "unary rule is parsed");
            addNewASTNode(nodeIdx, prepareList("Binary Expression", "Operator: " + operator.lexeme), prepareList(expr.astNodeIndex, right.astNodeIndex));
            expr = new Expr.Binary(expr, operator, right, astNodeIndex);
        }

        return expr;
    }

    private Expr unary() {
        addNewNode("Unary Rule");
        int nodeIdx = nodeIndex;

        visitNode(nodeIdx, "Parsing until we run out of (!, -) operators");
        if (match(BANG, MINUS)) {
            visitNode(nodeIdx, "an operator is found, moving into the unary rule");
            Token operator = previous();
            Expr right = unary();
            visitNode(nodeIdx, "unary rule is parsed");
            addNewASTNode(nodeIdx, prepareList("Unary Expression", "Operator: " + operator.lexeme), prepareList(right.astNodeIndex));
            return new Expr.Unary(operator, right, astNodeIndex);
        }

        visitNode(nodeIdx, "moving into primary rule");
        Expr ret = primary();
        visitNode(nodeIdx, "primary rule is parsed");
        return ret;
    }

    private Expr primary() {
        addNewNode("Primary Rule");
        int nodeIdx = nodeIndex;


        if (match(FALSE)) {
            visitNode(nodeIndex, "\"false\" keyword is found");
            addNewASTNode(nodeIdx, prepareList("Literal", "Value: " + "false"), prepareList());
            return new Expr.Literal(false, astNodeIndex);
        }
        if (match(TRUE)) {
            visitNode(nodeIndex, "\"true\" keyword is found");
            addNewASTNode(nodeIdx, prepareList("Literal", "Value: " + "true"), prepareList());
            return new Expr.Literal(true, astNodeIndex);
        }
        if (match(NIL)) {
            visitNode(nodeIndex, "\"nil\" keyword is found");
            addNewASTNode(nodeIdx, prepareList("Literal", "Value: " + "nil"), prepareList());
            return new Expr.Literal(null, astNodeIndex);
        }

        if (match(NUMBER, STRING)) {
            visitNode(nodeIndex, "a number or a string is found");
            addNewASTNode(nodeIdx, prepareList("Literal", "Value: " + previous().literal), prepareList());
            return new Expr.Literal(previous().literal, astNodeIndex);
        }

        if (match(IDENTIFIER)) {
            visitNode(nodeIndex, "an IDENTIFIER is found");
            addNewASTNode(nodeIdx, prepareList("IDENTIFIER", "Name: " + previous().lexeme), prepareList());
            return new Expr.Variable(previous(), astNodeIndex);
        }

        if (match(LEFT_PAREN)) {
            visitNode(nodeIndex, "'(' is found, moving into expression rule");
            Expr expr = expression();
            visitNode(nodeIdx, "expression is parsed, looking for ')");
            consume(RIGHT_PAREN, "Expect ')' after expression.");
            addNewASTNode(nodeIdx, prepareList("Grouping of Expression"), prepareList(expr.astNodeIndex));
            return new Expr.Grouping(expr, astNodeIndex);
        }

        throw error(peek(), "Expect expression.");
    }


    private boolean match(TokenType... types) {
        for (TokenType type : types) {
            if (check(type)) {
                advance();
                return true;
            }
        }

        return false;
    }

    private Token consume(TokenType type, String message) {
        if (check(type)) return advance();

        throw error(peek(), message);
    }

    private boolean check(TokenType type) {
        if (isAtEnd()) return false;
        return peek().type == type;
    }

    private Token advance() {
        if (!isAtEnd()) {
            consumeToken(current);
            current++;
        }
        return previous();
    }

    private boolean isAtEnd() {
        return peek().type == EOF;
    }

    private Token peek() {
        return tokens.get(current);
    }

    private Token previous() {
        return tokens.get(current - 1);
    }

    private ParseError error(Token token, String message) {
        reportError(getErrorMessage(token, message));
        simpleInterpreter.error(token, message);
        return new ParseError();
    }

    private String getErrorMessage(Token token, String message) {
        int line = token.line;
        String where;

        if (token.type == TokenType.EOF) {
            where = " at end";
        } else {
            where = " at '" + token.lexeme + "'";
        }

        String output = "[line " + line + "] Error" + where + ": " + message;

        return output;
    }

    private void synchronize() {
        advance();

        while (!isAtEnd()) {
            if (previous().type == SEMICOLON) return;

            switch (peek().type) {
                case CLASS:
                case FUN:
                case VAR:
                case FOR:
                case IF:
                case WHILE:
                case PRINT:
                case RETURN:
                    return;
            }

            advance();
        }
    }

    <T> List<T> prepareList(T... args) {
        List<T> data = new ArrayList<>();
        for (T s : args)
            data.add(s);
        return data;
    }
}