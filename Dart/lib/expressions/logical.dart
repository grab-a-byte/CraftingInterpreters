import '../token.dart';
import 'expression.dart';
import 'expression.dart';

class Logical implements Expr {
  final Expr left;
  final Token operator;
  final Expr right;

  Logical(this.left, this.operator, this.right);

  @override
  R accept<R>(ExprVisitor<R> visitor) {
    return visitor.visitLogicalExpression(this);
  }
}
