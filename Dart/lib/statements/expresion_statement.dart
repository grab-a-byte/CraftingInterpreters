import 'package:Dart/expressions/expression.dart';
import 'package:Dart/statements/stmt.dart';

class ExpressionStatement extends Stmt {
  final Expr expression;
  ExpressionStatement(this.expression);

  @override
  void accept(StmtVisitor visitor) {
    visitor.visitExpressionStmt(this);
  }
}
