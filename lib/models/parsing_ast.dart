class ParsingAst {
  List _nodesData;
  List _graphs;
  List _visitedNode;

  ParsingAst(this._nodesData, this._graphs, this._visitedNode);

  factory ParsingAst.fromJson(Map<String, dynamic> json) {
    List nodesData = (json["Nodes"] as List<dynamic>);

    List graphs = (json["Graphs"] as List<dynamic>);

    List visitedNodes = (json["Visited Nodes"] as List<dynamic>);

    return ParsingAst(nodesData, graphs, visitedNodes);
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
