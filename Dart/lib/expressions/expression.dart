import 'package:Dart/expressions/binary.dart';
import 'package:Dart/expressions/grouping.dart';
import 'package:Dart/expressions/literal.dart';
import 'package:Dart/expressions/unary.dart';

abstract class Expression {
  R accept<R>(Visitor<R> visitor);
}

abstract class Visitor<R> {
  R visitBinaryExpression(Binary node);
  R visitGroupingExpression(Grouping node);
  R visitLiteralExpression(Literal node);
  R visitUnaryExpression(Unary node);
}
