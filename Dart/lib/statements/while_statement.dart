import 'stmt.dart';
import 'stmt.dart';
import '../expressions/expression.dart';
import '../expressions/expression.dart';

class WhileStatement implements Stmt {
  final Expr condition;
  final Stmt body;

  WhileStatement(this.condition, this.body);

  @override
  void accept(StmtVisitor visitor) {
    visitor.visitWhileStmt(this);
  }
}
