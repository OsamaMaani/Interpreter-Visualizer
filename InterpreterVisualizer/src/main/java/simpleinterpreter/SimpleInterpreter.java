package simpleinterpreter;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class SimpleInterpreter {
    private Scanner scanner;
    private Parser parser;
    private Interpreter interpreter;

    private boolean run = false;
    private boolean hadError = false;
    private boolean hadRuntimeError = false;
    private String source;

    public SimpleInterpreter(String source) {
        this.source = source;
        run();
    }

    public void run() {
        if(run) return;
        run = true;
        scanner = new Scanner(source, this);
        scanner.scanTokens();
        List<Token> tokens = scanner.getTokens();
        parser = new Parser(tokens, this);
        parser.parse();
        List<Stmt> statements = parser.getStatements();
        if (hadError) return;
        interpreter = new Interpreter();
        interpreter.interpret(statements);
    }

    JSONObject getLexicalAnalysis(){
        JSONObject lexicalAnalysis = new JSONObject();

        List<Token> tokens = scanner.getTokens();
        JSONArray tokensJSON = new JSONArray();
        for (Token token : tokens) {
            tokensJSON.put(token.getTokenJSON());
        }

        JSONArray errorsJSON = scanner.getErrors();

        lexicalAnalysis.put("Tokens", tokensJSON);
        lexicalAnalysis.put("Errors", errorsJSON);

//        System.out.println(lexicalAnalysis);

        return lexicalAnalysis;
    }

    JSONObject getSyntacticAnalysis(){
        JSONObject syntacticAnalysis = new JSONObject();

        List<StatementGraph> graph = parser.getStatmentsGraph();
        for (StatementGraph s : graph) {
            JSONObject statement = new JSONObject();
            statement.put("Graphs", s.getStatmentJSON());
            statement.put("Visited Nodes", s.getVisitedNode());
            statement.put("Nodes", s.getNodesData());
            statement.put("Consumed Tokens", s.getConsumedTokens());
            statement.put("Errors", s.getErrors());
            syntacticAnalysis.append("Statements", statement);
        }

        System.out.println(syntacticAnalysis);

        return syntacticAnalysis;
    }

    JSONObject getSymanticAnalysis(){
        JSONObject symanticAnalysis = new JSONObject();

        if(hadError)    return symanticAnalysis;

        return symanticAnalysis;
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

