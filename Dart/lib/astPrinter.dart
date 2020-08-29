import 'dart:io';
import 'dart:math';

import 'package:Dart/expressions/binary.dart';
import 'package:Dart/expressions/expression.dart';
import 'package:Dart/expressions/unary.dart';
import 'package:Dart/expressions/literal.dart';
import 'package:Dart/expressions/grouping.dart';

class AstPrinter extends ExprVisitor<String> {
  String printAsString(Expr expr) {
    return expr.accept(this);
  }

  String _parenthesize(String name, List<Expr> expressions) {
    StringBuffer buffer = StringBuffer();

    buffer..write('(')..write(name);

    expressions.forEach((element) {
      buffer..write(' ')..write(element.accept(this));
    });
    buffer.write(')');

    return buffer.toString();
  }

  @override
  String visitBinaryExpression(Binary node) {
    print(_parenthesize(node.operator.lexeme, [node.left, node.right]));
    return _parenthesize(node.operator.lexeme, [node.left, node.right]);
  }

  @override
  String visitGroupingExpression(Grouping node) {
    print(_parenthesize("group", [node.expression]));
    return _parenthesize("group", [node.expression]);
  }

  @override
  String visitLiteralExpression(Literal node) {
    if (node.value == null) {
      print('THIS BE NUI:LPL');
      return 'nil';
    } else {
      return node.value.toString();
    }
  }

  @override
  String visitUnaryExpression(Unary node) {
    print(_parenthesize(node.operator.lexeme, [node.right]));
    return _parenthesize(node.operator.lexeme, [node.right]);
  }
}
