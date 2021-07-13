package simpleinterpreter;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.List;

public class SimpleInterpreter {
    private Scanner scanner;
    private Parser parser;
    private Interpreter interpreter;

    private boolean run = false;
    private boolean hadError = false;
    private boolean hadRuntimeError = false;
    private final String source;

    public SimpleInterpreter(String source) {
        this.source = source;
        run();
    }

    public void run() {
        if (run) return;
        run = true;
        scanner = new Scanner(source, this);
        scanner.scanTokens();
        List<Token> tokens = scanner.getTokens();
        parser = new Parser(tokens, this);
        parser.parse();
        List<Stmt> statements = parser.getStatements();
        if (hadError) return;
        interpreter = new Interpreter(this, parser.getStatmentsGraph());
        interpreter.interpret(statements);

        //Testing
//        System.out.println(parser.getStatmentsGraph().get(0).getAstGraph().getAstJSON().toString());
//        System.out.println(parser.getStatmentsGraph().get(0).getAstGraph().getNodesData().toString());
//        System.out.println(parser.getStatmentsGraph().get(0).getAstGraph().getVisitedNode().toString());
//        System.out.println(parser.getStatmentsGraph().get(0).getAstGraphIndexSync().toString());

//        System.out.println(interpreter.statmentsGraph.get(0).getAstGraph().;
//        System.out.println(interpreter.statmentsGraph.get(1).getAstGraph().getSymbolTableJSON().get(0).toString());
//        System.out.println(interpreter.statmentsGraph.get(2).getAstGraph().getSymbolTableJSON().get(0).toString());
//        System.out.println(interpreter.statmentsGraph.get(3).getAstGraph().getSymbolTableJSON().get(0).toString());
    }

    JSONObject getLexicalAnalysis() {
        run();
        JSONObject lexicalAnalysis = new JSONObject();

        List<Token> tokens = scanner.getTokens();
        JSONArray tokensJSON = new JSONArray();
        for (Token token : tokens) {
            tokensJSON.put(token.getTokenJSON());
        }

        JSONObject errorsJSON = scanner.getErrors();

        lexicalAnalysis.put("Tokens", tokensJSON);
        lexicalAnalysis.put("Errors", errorsJSON);

        return lexicalAnalysis;
    }

    JSONObject getSyntacticAnalysis() {
        run();
        JSONObject syntacticAnalysis = new JSONObject();

        List<StatementGraph> graph = parser.getStatmentsGraph();
        for (StatementGraph s : graph) {
            JSONObject statement = new JSONObject();
            statement.put("Graphs", s.getStatmentJSON());
            statement.put("Visited Nodes", s.getVisitedNode());
            statement.put("Nodes", s.getNodesData());
            statement.put("Consumed Tokens", s.getConsumedTokens());
            statement.put("Errors", s.getErrors());
            statement.put("AST Graph Index Sync", s.getAstGraphIndexSync());

            JSONObject ast = new JSONObject();
            ast.put("Graphs", s.getAstGraph().getAstJSON());
            ast.put("Visited Nodes", s.getAstGraph().getVisitedNode());
            ast.put("Nodes", s.getAstGraph().getNodesData());
            statement.put("AST", ast);

            syntacticAnalysis.append("Statements", statement);
        }

        return syntacticAnalysis;
    }

    JSONObject getSemanticAnalysis() {
        run();
        JSONObject semanticAnalysis = new JSONObject();

        if (hadError) return semanticAnalysis;

        List<StatementGraph> graph = interpreter.getStatmentsGraph();
        for (StatementGraph s : graph) {
            JSONObject statement = new JSONObject();
            statement.put("AST", s.getAstGraph().getInterpreterCompleteAST());
            statement.put("Visited Nodes", s.getAstGraph().getInterpreterVisitedNode());
            statement.put("Nodes", s.getAstGraph().getInterpreterNodesData());
            statement.put("Symbol Table Index Sync", s.getAstGraph().getSymbolTableIndexSync());
            statement.put("Symbol Table", s.getAstGraph().getSymbolTableJSON());
            statement.put("Errors", s.getAstGraph().getInterpreterRuntimeErrors());
            statement.put("Output Messages", s.getAstGraph().getInterpreterOutputMessages());

            semanticAnalysis.append("Statements", statement);
        }

        return semanticAnalysis;
    }

    void error(Token token, String message) {
        if (token.type == TokenType.EOF) {
            report(token.line, " at end", message);
        } else {
            report(token.line, " at '" + token.lexeme + "'", message);
        }
    }

    void error(int line, String message) {
        report(line, "", message);
    }

    void report(int line, String where,
                String message) {
        String output = "[line " + line + "] Error" + where + ": " + message;
        System.err.println(output);
        hadError = true;
    }

    void runtimeError(RuntimeError error) {
        String output = error.getMessage() + "\n[line " + error.token.line + "]";
        System.err.println(output);
        hadRuntimeError = true;
    }
}


