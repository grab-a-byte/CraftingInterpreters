import 'package:Dart/expressions/expression.dart';
import 'package:Dart/statements/stmt.dart';

class IfStatement implements Stmt {
  final Expr condition;
  final Stmt thenBranch;
  final Stmt elseBranch;

  IfStatement(this.condition, this.thenBranch, this.elseBranch);

  @override
  void accept(StmtVisitor visitor) {
    visitor.visitIfStmt(this);
  }
}
