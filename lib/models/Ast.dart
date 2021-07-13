class Ast {
  String _astGraph;
  List _visitedNode;
  List _nodesData;
  List _symbolTableIndexSync;
  List<dynamic> _symbolTable;
  Map<int, String> _errors;
  Map<int, String> _outputMessages;

  Ast(
      this._astGraph,
      this._visitedNode,
      this._nodesData,
      this._symbolTableIndexSync,
      this._symbolTable,
      this._errors,
      this._outputMessages);

  factory Ast.fromJson(Map<String, dynamic> json) {
    String ast = json["AST"].toString();

    List visitedNode = (json["Visited Nodes"] as List<dynamic>);

    List nodesData = (json["Nodes"] as List<dynamic>);

    List symbolTableIndexSync =
        (json["Symbol Table Index Sync"] as List<dynamic>);

    Map<String, dynamic> errorsString =
        (json["Errors"] as Map<String, dynamic>);

    Map<int, String> errors = {};
    for (String s in errorsString.keys) {
      errors[int.parse(s)] = errorsString[s].toString();
    }

    Map<String, dynamic> outputMessagesString =
        (json["Output Messages"] as Map<String, dynamic>);
    Map<int, String> outputMessages = {};
    for (String s in outputMessagesString.keys) {
      outputMessages[int.parse(s)] = outputMessagesString[s].toString();
    }

    List symbolTable = (json["Symbol Table"] as List<dynamic>);

    return Ast(ast, visitedNode, nodesData, symbolTableIndexSync, symbolTable,
        errors, outputMessages);
  }

  Map<int, dynamic> get outputMessages => _outputMessages;

  Map<int, dynamic> get errors => _errors;

  List<dynamic> get symbolTable => _symbolTable;

  List get symbolTableIndexSync => _symbolTableIndexSync;

  List get nodesData => _nodesData;

  List get visitedNode => _visitedNode;

  String get astGraph => _astGraph;
}
