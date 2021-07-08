class Statement{

  List _nodesData;
  List _graphs;
  List _visitedNode;
  Map<int, List> _consumedTokens;
  Map<int, List> _errors;


  Statement(this._nodesData, this._graphs, this._visitedNode,
      this._consumedTokens, this._errors);

  factory Statement.fromJson(Map<String, dynamic> json) {
    List nodesDataJSON = (json["Nodes"] as List<dynamic>);
    List nodesData = [];
    for(int nodeIndex = 0 ;nodeIndex<nodesDataJSON.length;nodeIndex++){
      String nodeData = nodesDataJSON[nodeIndex][nodeIndex.toString()];
      nodesData.add(nodeData);
    }

    List graphs = (json["Graphs"] as List<dynamic>);
    print(graphs[2].toString());

    List visitedNodes = (json["Visited Nodes"] as List<dynamic>);


    List consumedTokensJSON = (json["Consumed Tokens"] as List<dynamic>);
    Map<int, List> consumedTokens = {};
    for(var consumedTokensMap in consumedTokensJSON){
      var key = int.parse((consumedTokensMap as Map<String, dynamic>).keys.first);
      var listOfTokens = (consumedTokensMap as Map<String, dynamic>).values.first;
      consumedTokens[key] = listOfTokens;
    }



    List errorsJSON = (json["Errors"] as List<dynamic>);
    Map<int, List> errors = {};
    for(var errorMap in errorsJSON){
      var key = int.parse((errorMap as Map<String, dynamic>).keys.first);

      var errorMessage = (errorMap as Map<String, dynamic>).values.first.toString();

      if(errors.containsKey(key)){
        errors[key].add(errorMessage);
      }
      else{
        errors[key] = [errorMessage];
      }
    }

    return Statement(nodesData, graphs, visitedNodes, consumedTokens, errors);
  }



  set nodesData(List value) {
    _nodesData = value;
  }

  List get nodesData => _nodesData;

  List get graphs => _graphs;

  Map<int, List> get errors => _errors;

  Map<int, List> get consumedTokens => _consumedTokens;

  List get visitedNode => _visitedNode;

  set graphs(List value) {
    _graphs = value;
  }

  set visitedNode(List value) {
    _visitedNode = value;
  }

  set consumedTokens(Map<int, List> value) {
    _consumedTokens = value;
  }

  set errors(Map<int, List> value) {
    _errors = value;
  }
}