package simpleinterpreter;

import java.util.List;

class Interpreter implements Expr.Visitor<Object>, Stmt.Visitor<Void> {

    SimpleInterpreter simpleInterpreter;

    private final List<StatementGraph> statmentsGraph;

    public List<StatementGraph> getStatmentsGraph() {
        return statmentsGraph;
    }

    private AST currentStatementAST;

    public Interpreter(SimpleInterpreter simpleInterpreter, List<StatementGraph> statmentsGraph) {
        this.simpleInterpreter = simpleInterpreter;
        this.statmentsGraph = statmentsGraph;
    }

    private Environment environment = new Environment();

    void interpret(List<Stmt> statements) {
        try {
            int index = 0;
            for (Stmt statement : statements) {
                currentStatementAST = statmentsGraph.get(index).getAstGraph();
                currentStatementAST.initInterpreterAST(environment);
                execute(statement);
                index++;
            }
        } catch (RuntimeError error) {
            String output = error.getMessage() + "\n[line " + error.token.line + "]";
            currentStatementAST.reportRuntimeError(output);
            simpleInterpreter.runtimeError(error);
        }
    }

    private Object evaluate(Expr expr) {
        return expr.accept(this);
    }

    private void execute(Stmt stmt) {
        stmt.accept(this);
    }

    void executeBlock(List<Stmt> statements,
                      Environment environment) {

        Environment previous = this.environment;
        try {
            this.environment = environment;
            for (Stmt statement : statements) {
                execute(statement);
            }
        } finally {
            this.environment = previous;
            currentStatementAST.updateSymbolTable(environment);
        }
    }

    @Override
    public Void visitBlockStmt(Stmt.Block stmt) {
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Executing Block Statements...");
        executeBlock(stmt.statements, new Environment(environment));
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Block Statements are executed");
        return null;
    }

    @Override
    public Object visitBinaryExpr(Expr.Binary expr) {
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Evaluating left expression");
        Object left = evaluate(expr.left);
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "left expression = " + stringify(left));

        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Evaluating right expression");
        Object right = evaluate(expr.right);
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "right expression = " + stringify(right));

        switch (expr.operator.type) {
            case GREATER:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Verifying that both operands are numbers before evaluation");
                checkNumberOperands(expr.operator, left, right);
                return (double) left > (double) right;
            case GREATER_EQUAL:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Verifying that both operands are numbers before evaluation");
                checkNumberOperands(expr.operator, left, right);
                return (double) left >= (double) right;
            case LESS:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Verifying that both operands are numbers before evaluation");
                checkNumberOperands(expr.operator, left, right);
                return (double) left < (double) right;
            case LESS_EQUAL:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Verifying that both operands are numbers before evaluation");
                checkNumberOperands(expr.operator, left, right);
                return (double) left <= (double) right;
            case BANG_EQUAL:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Checking if both operands are not equal");
                return !isEqual(left, right);
            case EQUAL_EQUAL:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Checking if both operands are equal");
                return isEqual(left, right);

            case MINUS:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Verifying that both operands are numbers before evaluation");
                checkNumberOperands(expr.operator, left, right);
                return (double) left - (double) right;
            case SLASH:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Verifying that both operands are numbers before evaluation");
                checkNumberOperands(expr.operator, left, right);
                return (double) left / (double) right;
            case STAR:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Verifying that both operands are numbers before evaluation");
                checkNumberOperands(expr.operator, left, right);
                return (double) left * (double) right;
            case PLUS:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Verifying that both operands are of the same type either numbers or strings");
                if (left instanceof Double && right instanceof Double) {
                    return (double) left + (double) right;
                }

                if (left instanceof String && right instanceof String) {
                    return left + (String) right;
                }

                throw new RuntimeError(expr.operator, "Operands must be two numbers or two strings.");
        }

        return null;
    }

    @Override
    public Object visitGroupingExpr(Expr.Grouping expr) {
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Evaluating expression between parentheses");
        Object ret = evaluate(expr.expression);
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Expression is evaluated");
        return ret;
    }

    @Override
    public Object visitLiteralExpr(Expr.Literal expr) {
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Returning the value of the literal to the parent");
        return expr.value;
    }

    @Override
    public Object visitLogicalExpr(Expr.Logical expr) {
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Evaluating left expression");
        Object left = evaluate(expr.left);

        if (expr.operator.type == TokenType.OR) {
            currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Check if left expression is true");
            if (isTruthy(left)) return left;
        } else {
            currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Check if left expression is false");
            if (!isTruthy(left)) return left;
        }

        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Right expression must be evaluated too.");
        return evaluate(expr.right);
    }

    @Override
    public Object visitUnaryExpr(Expr.Unary expr) {
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Evaluating expression first");
        Object right = evaluate(expr.right);

        switch (expr.operator.type) {
            case MINUS:
                currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Verifying that the operands is a number before evaluation");
                checkNumberOperand(expr.operator, right);
                return -(double) right;
            case BANG:
                return !isTruthy(right);
        }
        return null;
    }

    @Override
    public Object visitVariableExpr(Expr.Variable expr) {
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Check if variable exists in the symbol table and fetch its value and return it.");
        return environment.get(expr.name);
    }

    private void checkNumberOperand(Token operator, Object operand) {
        if (operand instanceof Double) return;
        throw new RuntimeError(operator, "Operand must be a number.");
    }

    private void checkNumberOperands(Token operator,
                                     Object left, Object right) {
        if (left instanceof Double && right instanceof Double) return;

        throw new RuntimeError(operator, "Operands must be numbers.");
    }

    private boolean isTruthy(Object object) {
        if (object == null) return false;
        if (object instanceof Boolean) return (boolean) object;
        return true;
    }

    private boolean isEqual(Object a, Object b) {
        if (a == null && b == null) return true;
        if (a == null) return false;

        return a.equals(b);
    }

    private String stringify(Object object) {
        if (object == null) return "nil";

        if (object instanceof Double) {
            String text = object.toString();
            if (text.endsWith(".0")) {
                text = text.substring(0, text.length() - 2);
            }
            return text;
        }

        return object.toString();
    }

    @Override
    public Void visitExpressionStmt(Stmt.Expression stmt) {
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Evaluating expression");
        evaluate(stmt.expression);
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Expression evaluated");
        return null;
    }

    @Override
    public Void visitIfStmt(Stmt.If stmt) {
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Checking if condition is true");
        if (isTruthy(evaluate(stmt.condition))) {
            currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Executing if's body");
            execute(stmt.thenBranch);
            currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "if's body is executed");
        } else if (stmt.elseBranch != null) {
            currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Executing else's body");
            execute(stmt.elseBranch);
            currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "else's body is executed");
        } else {
            currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Conditions are not true");
        }
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Evaluation is done");
        return null;
    }

    @Override
    public Void visitPrintStmt(Stmt.Print stmt) {
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Evaluating expression before printing");
        Object value = evaluate(stmt.expression);
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Expression evaluated");
        currentStatementAST.printOutputMessage(stringify(value));
        System.out.println(stringify(value));
        return null;
    }

    @Override
    public Void visitVarStmt(Stmt.Var stmt) {
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Defining a variable in the symbol table");
        Object value = null;
        if (stmt.initializer != null) {
            currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Evaluating expression first");
            value = evaluate(stmt.initializer);
        }

        environment.define(stmt.name.lexeme, value);
        currentStatementAST.updateSymbolTable(environment);
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Variable is defined in the symbol table");
        return null;
    }

    @Override
    public Void visitWhileStmt(Stmt.While stmt) {
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Executing While's body while the condition is true");
        while (isTruthy(evaluate(stmt.condition))) {
            execute(stmt.body);
        }
        currentStatementAST.visitNodeInterpreter(stmt.astNodeIndex, "Condition is false, execution stopped");
        return null;
    }

    @Override
    public Object visitAssignExpr(Expr.Assign expr) {
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Evaluating expression first");
        Object value = evaluate(expr.value);
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Expression evaluated");
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Assigning value to variable");
        environment.assign(expr.name, value);
        currentStatementAST.updateSymbolTable(environment);
        currentStatementAST.visitNodeInterpreter(expr.astNodeIndex, "Value is assigned");
        return value;
    }

}