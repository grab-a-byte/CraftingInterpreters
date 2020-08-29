import 'package:Dart/expressions/expression.dart';
import 'package:Dart/token.dart';

class Binary extends Expr {
  final Expr left;
  final Expr right;
  final Token operator;

  Binary(this.left, this.operator, this.right);

  @override
  R accept<R>(ExprVisitor<R> visitor) {
    return visitor.visitBinaryExpression(this);
  }
}
