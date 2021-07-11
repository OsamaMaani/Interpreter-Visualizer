package simpleinterpreter;

import java.util.List;

abstract class Stmt {
  interface Visitor<R> {
    R visitBlockStmt(Block stmt);
    R visitExpressionStmt(Expression stmt);
    R visitIfStmt(If stmt);
    R visitPrintStmt(Print stmt);
    R visitVarStmt(Var stmt);
    R visitWhileStmt(While stmt);
  }

  int astNodeIndex;

  static class Block extends Stmt {
    Block(List<Stmt> statements, int astNodeIndex) {
      this.statements = statements;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitBlockStmt(this);
    }

    final List<Stmt> statements;
  }

  static class Expression extends Stmt {
    Expression(Expr expression, int astNodeIndex) {
      this.expression = expression;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitExpressionStmt(this);
    }

    final Expr expression;
  }

  static class If extends Stmt {
    If(Expr condition,
       Stmt thenBranch,
       Stmt elseBranch,
       int astNodeIndex) {
      this.condition = condition;
      this.thenBranch = thenBranch;
      this.elseBranch = elseBranch;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitIfStmt(this);
    }

    final Expr condition;
    final Stmt thenBranch;
    final Stmt elseBranch;
  }

  static class Print extends Stmt {
    Print(Expr expression, int astNodeIndex) {
      this.expression = expression;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitPrintStmt(this);
    }

    final Expr expression;
  }

  static class Var extends Stmt {
    Var(Token name, Expr initializer, int astNodeIndex) {
      this.name = name;
      this.initializer = initializer;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitVarStmt(this);
    }

    final Token name;
    final Expr initializer;
  }

  static class While extends Stmt {
    While(Expr condition, Stmt body, int astNodeIndex) {
      this.condition = condition;
      this.body = body;
      this.astNodeIndex = astNodeIndex;
    }

    @Override
    <R> R accept(Visitor<R> visitor) {
      return visitor.visitWhileStmt(this);
    }

    final Expr condition;
    final Stmt body;
  }


  abstract <R> R accept(Visitor<R> visitor);
}