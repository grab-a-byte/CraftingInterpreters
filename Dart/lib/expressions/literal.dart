import 'package:Dart/expressions/expression.dart';

class Literal extends Expr {
  final Object value;

  Literal(this.value);

  @override
  R accept<R>(ExprVisitor<R> visitor) {
    return visitor.visitLiteralExpression(this);
  }
}
