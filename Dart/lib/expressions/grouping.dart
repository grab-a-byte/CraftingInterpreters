import 'package:Dart/expressions/expression.dart';

class Grouping extends Expr {
  final Expr expression;

  Grouping(this.expression);

  @override
  R accept<R>(ExprVisitor<R> visitor) {
    return visitor.visitGroupingExpression(this);
  }
}
