package simpleinterpreter;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StatementGraph {

    //same size
    private final List<JSONArray> statmentJSON;
    private final JSONArray visitedNode;

    private final List<JSONObject> nodesData;


    String ID = "\"id\"";
    String NEXT = "\"next\"";

    private final Map<Integer, List<Integer>> consumedTokens;
    private final JSONArray errors;


    //helper map
    private final Map<Integer, Integer> nodeInIndex;

    StatementGraph() {
        statmentJSON = new ArrayList<>();
        nodeInIndex = new HashMap<>();
        consumedTokens = new HashMap<>();
        visitedNode = new JSONArray();
        errors = new JSONArray();
        nodesData = new ArrayList<>();
    }


    void addNodeData(int index, String data){
        //Data
        JSONObject lastDataJSONObject = new JSONObject(getLastJSONObject().toString());
        if(data != "") {
            lastDataJSONObject.append(Integer.toString(index), data);
        }
        nodesData.add(lastDataJSONObject);
    }

    void addNewNode(int index, String data){
        nodeInIndex.put(index, getLastJSONArray().length());

        addNodeData(index, data);

        JSONArray lastJSONArray = new JSONArray(getLastJSONArray().toString());

        int lastNode = getLastVisitedNodeIndex(); //from

        visitedNode.put(index);
        if(lastNode != -1) {
            int indexOfNodeInJSON = nodeInIndex.get(lastNode);
            lastJSONArray.getJSONObject(indexOfNodeInJSON).append(NEXT, toStringWithDoubleQuotes(index));
        }

        JSONObject currentNode = new JSONObject();
        currentNode.put(ID, toStringWithDoubleQuotes(index));
        currentNode.put(NEXT, new JSONArray());

        lastJSONArray.put(currentNode);
        statmentJSON.add(lastJSONArray);
    }

    void visitNode(int index, String data){
        visitedNode.put(index);

        addNodeData(index, data);

        // keep the lists consistent
        JSONArray last = getLastJSONArray();
        statmentJSON.add(last);
    }

    void consumeToken(int tokenIndex){
        int index = statmentJSON.size() - 1;
        if(consumedTokens.get(index) == null){
            consumedTokens.put(index, new ArrayList<>());
        }
        consumedTokens.get(statmentJSON.size() - 1).add(tokenIndex);
    }

    void reportError(String message){
        int index = statmentJSON.size() - 1;
        JSONObject error = new JSONObject();
        error.put(Integer.toString(index), message);
        errors.put(error);
    }


    JSONArray getLastJSONArray(){
        int size = statmentJSON.size();
        if(size == 0)
            return new JSONArray();
        return statmentJSON.get(size - 1);
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

    public List<JSONArray> getStatmentJSON() {
        return statmentJSON;
    }


    String toStringWithDoubleQuotes(int index){
        return "\"" + Integer.toString(index) + "\"";
    }


//    public List<Integer> getVisitedNode() {
//        return visitedNode;
//    }
//
//    public List<String> getNodesData() {
//        return nodesData;
//    }
//
//    public Map<Integer, List<Integer>> getConsumedTokens() {
//        return consumedTokens;
//    }
//
//    public List<String> getErrors() {
//        return errors;
//    }
//
//    public Map<Integer, Integer> getNodeInIndex() {
//        return nodeInIndex;
//    }



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

    public JSONArray getConsumedTokens() {
        JSONArray consumedTokensJSON = new JSONArray();
        for(Map.Entry<Integer, List<Integer>> entry : consumedTokens.entrySet()){
            JSONObject list = new JSONObject();
            list.put(Integer.toString(entry.getKey()), entry.getValue());
            consumedTokensJSON.put(list);
        }
        return consumedTokensJSON;
    }

    public JSONArray getErrors() {
        return errors;
    }

}
