import 'package:Dart/expressions/expression.dart';

class Grouping extends Expression {
  final Expression expression;

  Grouping(this.expression);

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitGroupingExpression(this);
  }
}
