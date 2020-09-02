import 'package:Dart/expressions/expression.dart';
import 'package:Dart/statements/stmt.dart';
import 'package:Dart/token.dart';

class VariableStatement extends Stmt {
  final Token name;
  final Expr initializer;

  VariableStatement(this.name, this.initializer);

  @override
  void accept(StmtVisitor visitor) {
    visitor.visitVariableStmt(this);
  }
}
