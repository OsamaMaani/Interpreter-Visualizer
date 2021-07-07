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

    private final JSONArray nodesData;


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
        nodesData = new JSONArray();
    }


    void addNewNode(int index, String data){
        nodeInIndex.put(index, getLastJSONArray().length());
        nodesData.put(new JSONObject().put(Integer.toString(index), data));

        JSONArray lastJSONArray = new JSONArray(getLastJSONArray().toString());

        int lastNode = getLastVisitedNodeIndex(); //from

        visitedNode.put(index);
        if(lastNode != -1) {
            int indexOfNodeInJSON = nodeInIndex.get(lastNode);
            lastJSONArray.getJSONObject(indexOfNodeInJSON).append("next", Integer.toString(index));
        }

        JSONObject currentNode = new JSONObject();
        currentNode.put("id", Integer.toString(index));
        currentNode.put("next", new JSONArray());

        lastJSONArray.put(currentNode);
        statmentJSON.add(lastJSONArray);
    }

    void visitNode(int index){
        visitedNode.put(index);

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

    int getLastVisitedNodeIndex(){
        int size = visitedNode.length();
        if(size == 0)
            return -1;
        return visitedNode.getInt(size - 1);

    }

    public List<JSONArray> getStatmentJSON() {
        return statmentJSON;
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
        return nodesData;
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
