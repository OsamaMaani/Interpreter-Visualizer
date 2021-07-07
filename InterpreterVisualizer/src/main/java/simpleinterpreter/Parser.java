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

    private int nodeIndex;
    private int statementIndex = -1;

    private final List<StatementGraph> statmentsGraph;

    void addNewStatement(){
        statementIndex++;
        statmentsGraph.add(new StatementGraph());
        nodeIndex = -1;
    }

    void addNewNode(String data){
        nodeIndex++;
        currentStatement().addNewNode(nodeIndex, data);
    }

    StatementGraph currentStatement(){
        return statmentsGraph.get(statementIndex);
    }

    void visitNode(int nodeIndex){
        currentStatement().visitNode(nodeIndex);
    }


    void consumeToken(int tokenIndex){
        currentStatement().consumeToken(tokenIndex);
    }

    public List<StatementGraph> getStatmentsGraph() {
        return statmentsGraph;
    }

    void reportError(String message){
        currentStatement().reportError(message);
    }

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
        while (!isAtEnd()) {
            addNewStatement();
            addNewNode("Program Entry");
            statements.add(declaration());
        }
    }

    private Stmt declaration() {
        addNewNode("Declaration");
        int nodeIdx = nodeIndex;

        try {
            Stmt ret;
            if (match(VAR)){
                ret = varDeclaration();
                visitNode(nodeIdx);
                return ret;
            }
            ret = statement();
            visitNode(nodeIdx);
            return ret;
        } catch (ParseError error) {
            synchronize();
            return null;
        }
    }

    private Stmt varDeclaration() {
        addNewNode("Var Declaration");
        int nodeIdx = nodeIndex;

        Token name = consume(IDENTIFIER, "Expect variable name.");

        Expr initializer = null;
        if (match(EQUAL)) {
            initializer = expression();
            visitNode(nodeIdx);
        }

        consume(SEMICOLON, "Expect ';' after variable declaration.");
        return new Stmt.Var(name, initializer);
    }

    private Stmt whileStatement() {
        addNewNode("While Statement");
        int nodeIdx = nodeIndex;

        consume(LEFT_PAREN, "Expect '(' after 'while'.");
        Expr condition = expression();
        visitNode(nodeIdx);

        consume(RIGHT_PAREN, "Expect ')' after condition.");
        Stmt body = statement();
        visitNode(nodeIdx);

        return new Stmt.While(condition, body);
    }

    private Stmt statement() {
        addNewNode("Statement");
        int nodeIdx = nodeIndex;

        Stmt ret;
        if (match(IF)){
            ret = ifStatement();
            visitNode(nodeIdx);
            return ret;
        }

        if (match(PRINT)){
            ret = printStatement();
            visitNode(nodeIdx);
            return ret;
        }

        if (match(WHILE)){
            ret = whileStatement();
            visitNode(nodeIdx);
            return ret;
        }

        if (match(LEFT_BRACE)){
            ret = new Stmt.Block(block());
            visitNode(nodeIdx);
            return ret;
        }

        ret = expressionStatement();
        visitNode(nodeIdx);
        return ret;
    }

    private Stmt ifStatement() {
        addNewNode("if Statement");
        int nodeIdx = nodeIndex;

        consume(LEFT_PAREN, "Expect '(' after 'if'.");
        Expr condition = expression();
        visitNode(nodeIdx);
        consume(RIGHT_PAREN, "Expect ')' after if condition.");
        Stmt thenBranch = statement();
        visitNode(nodeIdx);
        Stmt elseBranch = null;
        if (match(ELSE)) {
            elseBranch = statement();
            visitNode(nodeIdx);
        }

        return new Stmt.If(condition, thenBranch, elseBranch);
    }

    private Stmt printStatement() {
        addNewNode("Print Statement");
        int nodeIdx = nodeIndex;
        Expr value = expression();
        visitNode(nodeIdx);
        consume(SEMICOLON, "Expect ';' after value.");
        return new Stmt.Print(value);
    }

    private List<Stmt> block() {
        addNewNode("Block");
        int nodeIdx = nodeIndex;

        List<Stmt> statements = new ArrayList<>();

        while (!check(RIGHT_BRACE) && !isAtEnd()) {
            statements.add(declaration());
            visitNode(nodeIdx);
        }

        consume(RIGHT_BRACE, "Expect '}' after block.");
        return statements;
    }

    private Stmt expressionStatement() {
        addNewNode("Expression Statement");
        int nodeIdx = nodeIndex;

        Expr expr = expression();
        visitNode(nodeIdx);

        consume(SEMICOLON, "Expect ';' after expression.");
        return new Stmt.Expression(expr);
    }

    private Expr expression() {
        addNewNode("Expression");
        int nodeIdx = nodeIndex;

        Expr ret = assignment();
        visitNode(nodeIdx);
        return ret;
    }

    private Expr assignment() {
        addNewNode("Assignment");
        int nodeIdx = nodeIndex;

        Expr expr = or();
        visitNode(nodeIdx);


        if (match(EQUAL)) {
            Token equals = previous();

            Expr value = assignment();
            visitNode(nodeIdx);

            if (expr instanceof Expr.Variable) {
                Token name = ((Expr.Variable)expr).name;
                return new Expr.Assign(name, value);
            }

            error(equals, "Invalid assignment target.");
        }

        return expr;
    }

    private Expr or() {
        addNewNode("Logic OR");
        int nodeIdx = nodeIndex;

        Expr expr = and();
        visitNode(nodeIdx);

        while (match(OR)) {
            Token operator = previous();
            Expr right = and();
            visitNode(nodeIdx);
            expr = new Expr.Logical(expr, operator, right);
        }

        return expr;
    }

    private Expr and() {
        addNewNode("Logic AND");
        int nodeIdx = nodeIndex;

        Expr expr = equality();
        visitNode(nodeIdx);

        while (match(AND)) {
            Token operator = previous();
            Expr right = equality();
            visitNode(nodeIdx);
            expr = new Expr.Logical(expr, operator, right);
        }

        return expr;
    }

    private Expr equality() {
        addNewNode("Equality");
        int nodeIdx = nodeIndex;

        Expr expr = comparison();
        visitNode(nodeIdx);

        while (match(BANG_EQUAL, EQUAL_EQUAL)) {
            Token operator = previous();
            Expr right = comparison();
            visitNode(nodeIdx);

            expr = new Expr.Binary(expr, operator, right);
        }

        return expr;
    }

    private Expr comparison() {
        addNewNode("Comparison");
        int nodeIdx = nodeIndex;

        Expr expr = term();
        visitNode(nodeIdx);

        while (match(GREATER, GREATER_EQUAL, LESS, LESS_EQUAL)) {
            Token operator = previous();
            Expr right = term();
            visitNode(nodeIdx);
            expr = new Expr.Binary(expr, operator, right);
        }

        return expr;
    }

    private Expr term() {
        addNewNode("Term");
        int nodeIdx = nodeIndex;

        Expr expr = factor();
        visitNode(nodeIdx);

        while (match(MINUS, PLUS)) {
            Token operator = previous();
            Expr right = factor();
            visitNode(nodeIdx);
            expr = new Expr.Binary(expr, operator, right);
        }

        return expr;
    }

    private Expr factor() {
        addNewNode("Factor");
        int nodeIdx = nodeIndex;

        Expr expr = unary();
        visitNode(nodeIdx);

        while (match(SLASH, STAR)) {
            Token operator = previous();
            Expr right = unary();
            visitNode(nodeIdx);
            expr = new Expr.Binary(expr, operator, right);
        }

        return expr;
    }

    private Expr unary() {
        addNewNode("Unary");
        int nodeIdx = nodeIndex;

        if (match(BANG, MINUS)) {
            Token operator = previous();
            Expr right = unary();
            visitNode(nodeIdx);

            return new Expr.Unary(operator, right);
        }

        return primary();
    }

    private Expr primary() {
        addNewNode("Primary");
        int nodeIdx = nodeIndex;

        if (match(FALSE)) return new Expr.Literal(false);
        if (match(TRUE)) return new Expr.Literal(true);
        if (match(NIL)) return new Expr.Literal(null);

        if (match(NUMBER, STRING)) {
            return new Expr.Literal(previous().literal);
        }

        if (match(IDENTIFIER)) {
            return new Expr.Variable(previous());
        }

        if (match(LEFT_PAREN)) {
            Expr expr = expression();
            visitNode(nodeIdx);
            consume(RIGHT_PAREN, "Expect ')' after expression.");
            return new Expr.Grouping(expr);
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
        if (!isAtEnd()){
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

    private String getErrorMessage(Token token, String message){
        int line = token.line;
        String where;

        if (token.type == TokenType.EOF) {
            where = " at end";
        } else {
            where =  " at '" + token.lexeme + "'";
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

}