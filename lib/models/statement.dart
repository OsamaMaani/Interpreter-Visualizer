import 'parsing_ast.dart';

class Statement {
  ParsingAst _astGraph;
  List _nodesData;
  List _graphs;
  List _visitedNode;
  List _astGraphIndexSync;
  Map<int, List> _consumedTokens;
  Map<int, List> _errors;

  Statement(
      this._nodesData,
      this._graphs,
      this._visitedNode,
      this._consumedTokens,
      this._errors,
      this._astGraphIndexSync,
      this._astGraph);

  factory Statement.fromJson(Map<String, dynamic> json) {
    List nodesDataJSON = (json["Nodes"] as List<dynamic>);
    List nodesData = [];

    nodesData = nodesDataJSON;

    List graphs = (json["Graphs"] as List<dynamic>);

    List visitedNodes = (json["Visited Nodes"] as List<dynamic>);

    List consumedTokensJSON = (json["Consumed Tokens"] as List<dynamic>);
    Map<int, List> consumedTokens = {};
    for (var consumedTokensMap in consumedTokensJSON) {
      var key =
          int.parse((consumedTokensMap as Map<String, dynamic>).keys.first);
      var listOfTokens =
          (consumedTokensMap as Map<String, dynamic>).values.first;
      consumedTokens[key] = listOfTokens;
    }

    List errorsJSON = (json["Errors"] as List<dynamic>);
    Map<int, List> errors = {};
    for (var errorMap in errorsJSON) {
      var key = int.parse((errorMap as Map<String, dynamic>).keys.first);

      var errorMessage =
          (errorMap as Map<String, dynamic>).values.first.toString();

      if (errors.containsKey(key)) {
        errors[key].add(errorMessage);
      } else {
        errors[key] = [errorMessage];
      }
    }

    List astGraphIndexSync = (json["AST Graph Index Sync"] as List<dynamic>);

    ParsingAst astGraph = ParsingAst.fromJson(json["AST"]);

    return Statement(nodesData, graphs, visitedNodes, consumedTokens, errors,
        astGraphIndexSync, astGraph);
  }

  Map<int, List> get errors => _errors;

  set errors(Map<int, List> value) {
    _errors = value;
  }

  Map<int, List> get consumedTokens => _consumedTokens;

  set consumedTokens(Map<int, List> value) {
    _consumedTokens = value;
  }

  List get astGraphIndexSync => _astGraphIndexSync;

  set astGraphIndexSync(List value) {
    _astGraphIndexSync = value;
  }

  List get visitedNode => _visitedNode;

  set visitedNode(List value) {
    _visitedNode = value;
  }

  List get graphs => _graphs;

  set graphs(List value) {
    _graphs = value;
  }

  List get nodesData => _nodesData;

  set nodesData(List value) {
    _nodesData = value;
  }

  ParsingAst get astGraph => _astGraph;

  set astGraph(ParsingAst value) {
    _astGraph = value;
  }
}
