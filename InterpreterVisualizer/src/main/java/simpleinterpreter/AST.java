package simpleinterpreter;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AST {

    //same size
    private final List<JSONArray> astJSON;
    private final JSONArray visitedNode;
    private final List<JSONObject> nodesData;

    private final String ID = "\"id\"";
    private final String NEXT = "\"next\"";

    private final JSONArray runtimeErrors;

    //helper map
    private final Map<Integer, Integer> nodeInIndex;

    AST() {
        astJSON = new ArrayList<>();
        nodeInIndex = new HashMap<>();
        visitedNode = new JSONArray();
        runtimeErrors = new JSONArray();
        nodesData = new ArrayList<>();
    }

    int getASTGraphsSize(){
        return astJSON.size();
    }

    void addNodeData(int index, List<String> data){
        //Data
        JSONObject lastDataJSONObject = new JSONObject(getLastJSONObject().toString());
        if(!data.isEmpty()) {
            for(String s : data) {
                lastDataJSONObject.append(Integer.toString(index), s);
            }
        }
        nodesData.add(lastDataJSONObject);
    }

    void addNewNode(int index, List<String> data, List<Integer> neighbours){
        //I'm supposed to draw one edge from (index) to other nodes indices in args
        //args also has some data the I need to add to node (Index)

        addNodeData(index, data);

        JSONArray lastJSONArray = new JSONArray(getLastJSONArray().toString());

        visitedNode.put(index);

        JSONObject currentNode = new JSONObject();
        currentNode.put(ID, toStringWithDoubleQuotes(index));
        currentNode.put(NEXT, new JSONArray());
        for(int to : neighbours){
            currentNode.append(NEXT, toStringWithDoubleQuotes(to));
        }

        lastJSONArray.put(currentNode);
        astJSON.add(lastJSONArray);
    }

    void visitNode(int index, String ... args){
        visitedNode.put(index);

        ArrayList<String> data = new ArrayList<>();

        for(String s : args){
            data.add(s);
        }

        addNodeData(index, data);

        // keep the lists consistent
        JSONArray last = getLastJSONArray();
        astJSON.add(last);
    }

    void reportError(String message){
        int index = astJSON.size() - 1;
        JSONObject error = new JSONObject();
        error.put(Integer.toString(index), message);
        runtimeErrors.put(error);
    }

    JSONArray getLastJSONArray(){
        int size = astJSON.size();
        if(size == 0)
            return new JSONArray();
        return astJSON.get(size - 1);
    }

    JSONObject getLastJSONObject(){
        int size = nodesData.size();
        if(size == 0)
            return new JSONObject();
        return nodesData.get(size - 1);
    }

    int getLastVisitedNodeIndex(){
        int size = visitedNode.length();
        if(size == 0)
            return -1;
        return visitedNode.getInt(size - 1);

    }

    public List<JSONArray> getAstJSON() {
        return astJSON;
    }

    String toStringWithDoubleQuotes(int index){
        return "\"" + Integer.toString(index) + "\"";
    }

    public JSONArray getVisitedNode() {
        return visitedNode;
    }

    public JSONArray getNodesData() {
        JSONArray nodesDataJSONArray = new JSONArray();
        for(JSONObject jsonObject : nodesData) {
            nodesDataJSONArray.put(jsonObject);
        }
        return nodesDataJSONArray;
    }

    public JSONArray getRuntimeErrors() {
        return runtimeErrors;
    }

}
