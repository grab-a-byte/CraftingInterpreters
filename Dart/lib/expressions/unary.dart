import 'package:Dart/expressions/expression.dart';
import 'package:Dart/token.dart';

class Unary extends Expression {
  final Token operator;
  final Expression right;

  Unary(this.operator, this.right);

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitUnaryExpression(this);
  }
}
