package simpleinterpreter;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class InterpreterAdapter {

    private static final JSONObject invalidTokenError = new JSONObject().put("ERROR", "Invalid Token.");
    private static final InterpreterAdapter interpreterAdapter = new InterpreterAdapter();
    private static final Map<String, SimpleInterpreter> interpreters = new HashMap<>();


    private InterpreterAdapter() {
    }

    public static InterpreterAdapter getInterpreterAdapter() {
        return interpreterAdapter;
    }


    public void startInterpreter(String token, String source) {
        interpreters.put(token, new SimpleInterpreter(source));
    }

    public JSONObject getLexicalAnalysis(String token) {
        if (interpreters.get(token) == null) {
            return invalidTokenError;
        }
        SimpleInterpreter interpreter = interpreters.get(token);
        return interpreter.getLexicalAnalysis();
    }

    public JSONObject getSyntacticAnalysis(String token) {
        if (interpreters.get(token) == null) {
            return invalidTokenError;
        }
        SimpleInterpreter interpreter = interpreters.get(token);
        return interpreter.getSyntacticAnalysis();
    }

    public JSONObject getSemanticAnalysis(String token) {
        if (interpreters.get(token) == null) {
            return invalidTokenError;
        }
        SimpleInterpreter interpreter = interpreters.get(token);
        return interpreter.getSemanticAnalysis();
    }

}
