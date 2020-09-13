import '../token.dart';
import 'expression.dart';

class Assign extends Expr {
  final Token name;
  final Expr value;

  Assign(this.name, this.value);

  @override
  R accept<R>(ExprVisitor<R> visitor) {
    return visitor.visitAssignExpression(this);
  }
}
