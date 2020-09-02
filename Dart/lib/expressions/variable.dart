import 'package:Dart/expressions/expression.dart';
import 'package:Dart/token.dart';

class Variable implements Expr {
  final Token name;

  Variable(this.name);

  @override
  R accept<R>(ExprVisitor<R> visitor) {
    return visitor.visitVariableExpression(this);
  }
}
