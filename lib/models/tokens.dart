class Token{
  String _tokenType;
  String _lexeme;
  String _literal;
  int _line;
  int _start;
  int _end;

  Token(this._tokenType, this._lexeme, this._literal, this._line, this._start,
      this._end);

  String get tokenType => _tokenType;

  String get lexeme => _lexeme;

  int get line => _line;

  String get literal => _literal;

  int get end => _end;

  int get start => _start;
}