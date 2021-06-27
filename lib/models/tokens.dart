class Token{
  String _tokenType;
  String _lexeme;
  String _literal;
  String _line;

  Token(this._tokenType, this._lexeme, this._literal, this._line);
  String get tokenType => _tokenType;

  String get lexeme => _lexeme;

  String get line => _line;

  String get literal => _literal;
}