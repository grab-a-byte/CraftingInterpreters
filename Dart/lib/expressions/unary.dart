import 'package:Dart/expressions/expression.dart';
import 'package:Dart/token.dart';

class Unary extends Expr {
  final Token operator;
  final Expr right;

  Unary(this.operator, this.right);

  @override
  R accept<R>(ExprVisitor<R> visitor) {
    return visitor.visitUnaryExpression(this);
  }
}
