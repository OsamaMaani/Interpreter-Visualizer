package simpleinterpreter;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class AST {

    //Parser Data
    private final List<JSONArray> astJSON;
    private final JSONArray visitedNode;
    private final List<JSONObject> nodesData;

    // Interpreter Data
    private final JSONArray interpreterVisitedNode;
    private final JSONArray SymbolTableIndexSync;
    private final List<JSONObject> symbolTableJSON;
    private final List<JSONObject> interpreterNodesData;
    private final JSONObject outputMessages;
    private final JSONObject runtimeErrors;


    private final String ID = "\"id\"";
    private final String NEXT = "\"next\"";

    AST() {
        astJSON = new ArrayList<>();
        visitedNode = new JSONArray();
        nodesData = new ArrayList<>();

        interpreterVisitedNode = new JSONArray();
        symbolTableJSON = new ArrayList<>();
        SymbolTableIndexSync = new JSONArray();
        interpreterNodesData = new ArrayList<>();
        outputMessages = new JSONObject();
        runtimeErrors = new JSONObject();
    }


    /* Traversing AST during Semantic Analysis */

    void initInterpreterAST(Environment environment) {
        int rootIndex = getLastVisitedNodeIndex();
        interpreterVisitedNode.put(rootIndex);
        JSONObject lastDataJSONObject = new JSONObject(getLastJSONObject().toString());
        interpreterNodesData.add(lastDataJSONObject);
        JSONObject symbolTable = buildSymbolTable(environment, 1);
        symbolTableJSON.add(symbolTable);
        SymbolTableIndexSync.put(0);
    }

    void reportRuntimeError(String message) {
        int index = interpreterVisitedNode.length() - 1;
        runtimeErrors.put(Integer.toString(index), message);
    }

    void printOutputMessage(String message) {
        int index = interpreterVisitedNode.length() - 1;
        outputMessages.put(Integer.toString(index), message);
    }

    void addNodeDataInterpreter(int index, List<String> data) {
        //Data
        JSONObject lastDataJSONObject = new JSONObject(getInterpreterLastJSONObject().toString());
        if (!data.isEmpty()) {
            for (String s : data) {
                lastDataJSONObject.append(Integer.toString(index), s);
            }
        }
        interpreterNodesData.add(lastDataJSONObject);
    }

    JSONObject buildSymbolTable(Environment environment, int scope) {
        JSONObject variables = new JSONObject();

        Map<String, Object> values = environment.getValues();
        for (String name : values.keySet()) {
            variables.put(name, values.get(name));
        }

        JSONObject scopes;
        if (environment.enclosing != null) {
            scopes = buildSymbolTable(environment.enclosing, scope + 1);
        } else {
            scopes = new JSONObject();
        }

        if (!variables.isEmpty())
            scopes.put(Integer.toString(scope), variables);

        return scopes;
    }

    void updateSymbolTable(Environment environment) {
        JSONObject symbolTable = buildSymbolTable(environment, 1);
        symbolTableJSON.add(symbolTable);
    }

    void visitNodeInterpreter(int index, String... args) {
        interpreterVisitedNode.put(index);
        SymbolTableIndexSync.put(symbolTableJSON.size() - 1);

        ArrayList<String> data = new ArrayList<>();

        for (String s : args) {
            data.add(s);
        }

        addNodeDataInterpreter(index, data);
    }

    private JSONObject getInterpreterLastJSONObject() {
        int size = interpreterNodesData.size();
        if (size == 0)
            return new JSONObject();
        return interpreterNodesData.get(size - 1);
    }

    /* Building AST during Parsing */

    void addNodeData(int index, List<String> data) {
        //Data
        JSONObject lastDataJSONObject = new JSONObject(getLastJSONObject().toString());
        if (!data.isEmpty()) {
            for (String s : data) {
                lastDataJSONObject.append(Integer.toString(index), s);
            }
        }
        nodesData.add(lastDataJSONObject);
    }

    void addNewNode(int index, List<String> data, List<Integer> neighbours) {
        //I'm supposed to draw one edge from (index) to other nodes indices in args
        //args also has some data the I need to add to node (Index)

        addNodeData(index, data);

        JSONArray lastJSONArray = new JSONArray(getLastJSONArray().toString());

        visitedNode.put(index);

        JSONObject currentNode = new JSONObject();
        currentNode.put(ID, toStringWithDoubleQuotes(index));
        currentNode.put(NEXT, new JSONArray());
        for (int to : neighbours) {
            currentNode.append(NEXT, toStringWithDoubleQuotes(to));
        }

        lastJSONArray.put(currentNode);
        astJSON.add(lastJSONArray);
    }

    /* Helper Functions */

    private JSONArray getLastJSONArray() {
        int size = astJSON.size();
        if (size == 0)
            return new JSONArray();
        return astJSON.get(size - 1);
    }

    private JSONObject getLastJSONObject() {
        int size = nodesData.size();
        if (size == 0)
            return new JSONObject();
        return nodesData.get(size - 1);
    }

    private int getLastVisitedNodeIndex() {
        int size = visitedNode.length();
        if (size == 0)
            return -1;
        return visitedNode.getInt(size - 1);

    }

    private String toStringWithDoubleQuotes(int index) {
        return "\"" + index + "\"";
    }


    /* Getters for Generating AST */

    int getASTsSize() {
        return astJSON.size();
    }

    public List<JSONArray> getAstJSON() {
        return astJSON;
    }

    public JSONArray getVisitedNode() {
        return visitedNode;
    }

    public JSONArray getNodesData() {
        JSONArray nodesDataJSONArray = new JSONArray();
        for (JSONObject jsonObject : nodesData) {
            nodesDataJSONArray.put(jsonObject);
        }
        return nodesDataJSONArray;
    }


    /* Getters for Traversing AST */

    public JSONObject getInterpreterRuntimeErrors() {
        return runtimeErrors;
    }

    JSONArray getInterpreterCompleteAST() {
        return getLastJSONArray();
    }

    public JSONArray getInterpreterVisitedNode() {
        return interpreterVisitedNode;
    }

    public List<JSONObject> getInterpreterNodesData() {
        return interpreterNodesData;
    }

    public JSONObject getInterpreterOutputMessages() {
        return outputMessages;
    }

    public JSONArray getSymbolTableIndexSync() {
        return SymbolTableIndexSync;
    }

    public List<JSONObject> getSymbolTableJSON() {
        return symbolTableJSON;
    }
}
