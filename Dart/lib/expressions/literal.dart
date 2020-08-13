import 'package:Dart/expressions/expression.dart';

class Literal extends Expression {
  final Object value;

  Literal(this.value);

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitLiteralExpression(this);
  }
}
