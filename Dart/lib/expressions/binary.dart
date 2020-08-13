import 'package:Dart/expressions/expression.dart';
import 'package:Dart/token.dart';

class Binary extends Expression {
  final Expression left;
  final Expression right;
  final Token operator;

  Binary(this.left, this.operator, this.right);

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitBinaryExpression(this);
  }
}
