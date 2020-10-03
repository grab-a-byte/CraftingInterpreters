import 'Assign.dart';
import 'binary.dart';
import 'grouping.dart';
import 'literal.dart';
import 'logical.dart';
import 'unary.dart';
import 'variable.dart';

abstract class Expr {
  R accept<R>(ExprVisitor<R> visitor);
}

abstract class ExprVisitor<R> {
  R visitBinaryExpression(Binary node);
  R visitGroupingExpression(Grouping node);
  R visitLiteralExpression(Literal node);
  R visitUnaryExpression(Unary node);
  R visitVariableExpression(Variable variable);
  R visitAssignExpression(Assign assign);
  R visitLogicalExpression(Logical logical);
}
