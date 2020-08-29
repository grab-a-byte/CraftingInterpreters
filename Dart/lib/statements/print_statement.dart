import 'package:Dart/expressions/expression.dart';
import 'package:Dart/statements/stmt.dart';

class PrintStatement extends Stmt {
  final Expr expression;
  PrintStatement(this.expression);

  @override
  void accept(StmtVisitor visitor) {
    visitor.visitPrintStmt(this);
  }
}
