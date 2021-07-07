package simpleinterpreter;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class InterpreterAdapter {

    private static JSONObject invalidTokenError = new JSONObject().put("ERROR", "Invalid Token.");
    private static InterpreterAdapter interpreterAdapter = new InterpreterAdapter();
    private static Map<String, SimpleInterpreter> interpreters = new HashMap<>();


    private InterpreterAdapter() {
    }

    public static InterpreterAdapter getInterpreterAdapter(){
        return interpreterAdapter;
    }


    public void startInterpreter(String token, String source){
        interpreters.put(token, new SimpleInterpreter(source));
    }

    public JSONObject getLexicalAnalysis(String token){
        if(interpreters.get(token) == null){
            return invalidTokenError;
        }
        SimpleInterpreter interpreter = interpreters.get(token);
        interpreter.run();
        return interpreter.getLexicalAnalysis();
    }

    public JSONObject getSyntacticAnalysis(String token){
        if(interpreters.get(token) == null){
            return invalidTokenError;
        }
        SimpleInterpreter interpreter = interpreters.get(token);
        interpreter.run();
        return interpreter.getSyntacticAnalysis();
    }

    public JSONObject getSymanticAnalysis(String token){
        if(interpreters.get(token) == null){
            return invalidTokenError;
        }
        SimpleInterpreter interpreter = interpreters.get(token);
        interpreter.run();
        return interpreter.getSymanticAnalysis();
    }

}
