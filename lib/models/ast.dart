class Ast{
  List _nodesData;
  List _graphs;
  List _visitedNode;

  Ast(this._nodesData, this._graphs, this._visitedNode);

  factory Ast.fromJson(Map<String, dynamic> json) {
    List nodesDataJSON = (json["Nodes"] as List<dynamic>);
    List nodesData = [];

    nodesData = nodesDataJSON;

    List graphs = (json["Graphs"] as List<dynamic>);

    List visitedNodes = (json["Visited Nodes"] as List<dynamic>);

    return Ast(nodesData, graphs, visitedNodes);
  }

  set nodesData(List value) {
    _nodesData = value;
  }

  List get nodesData => _nodesData;

  List get graphs => _graphs;

  List get visitedNode => _visitedNode;

  set graphs(List value) {
    _graphs = value;
  }

  set visitedNode(List value) {
    _visitedNode = value;
  }
}