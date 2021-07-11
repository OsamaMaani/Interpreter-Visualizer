package simpleinterpreter;

abstract class Expr {
  interface Visitor<R> {
    R visitAssignExpr(Assign expr);
    R visitBinaryExpr(Binary expr);
    R visitGroupingExpr(Grouping expr);
    R visitLiteralExpr(Literal expr);
    R visitLogicalExpr(Logical expr);
    R visitUnaryExpr(Unary expr);
    R visitVariableExpr(Variable expr);
  }
  
  int astNodeIndex;

  static class Assign extends Expr {
    Assign(Token name, Expr value, int astNodeIndex) {
      this.name = name;
      this.value = value;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitAssignExpr(this);
    }

    final Token name;
    final Expr value;
  }

  static class Binary extends Expr {
    Binary(Expr left, Token operator, Expr right, int astNodeIndex) {
      this.left = left;
      this.operator = operator;
      this.right = right;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitBinaryExpr(this);
    }

    final Expr left;
    final Token operator;
    final Expr right;
  }

  static class Grouping extends Expr {
    Grouping(Expr expression, int astNodeIndex) {
      this.expression = expression;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitGroupingExpr(this);
    }

    final Expr expression;
  }

  static class Literal extends Expr {
    Literal(Object value, int astNodeIndex) {
      this.value = value;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitLiteralExpr(this);
    }

    final Object value;
  }

  static class Logical extends Expr {
    Logical(Expr left, Token operator, Expr right, int astNodeIndex) {
      this.left = left;
      this.operator = operator;
      this.right = right;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitLogicalExpr(this);
    }

    final Expr left;
    final Token operator;
    final Expr right;
  }

  static class Unary extends Expr {
    Unary(Token operator, Expr right, int astNodeIndex) {
      this.operator = operator;
      this.right = right;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitUnaryExpr(this);
    }

    final Token operator;
    final Expr right;
  }

  static class Variable extends Expr {
    Variable(Token name, int astNodeIndex) {
      this.name = name;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitVariableExpr(this);
    }

    final Token name;
  }

  abstract <R> R accept(Visitor<R> visitor);
}