import 'dart:ffi';
import 'dart:math';

import 'package:Dart/errors.dart';
import 'package:Dart/expressions/binary.dart';
import 'package:Dart/expressions/expression.dart';
import 'package:Dart/expressions/unary.dart';
import 'package:Dart/expressions/literal.dart';
import 'package:Dart/expressions/grouping.dart';
import 'package:Dart/token.dart';

import 'lox.dart';

class Interpreter extends Visitor<Object> {
  void interpret(Expression expr) {
    try {
      Object value = _evaluate(expr);
      print(_stringify(value));
    } on RuntimeError catch (error) {
      Lox.runtimeError(error);
    }
  }

  String _stringify(Object obj) {
    if (obj == null) return 'nil';
    return obj.toString();
  }

  Object _evaluate(Expression expr) => expr.accept(this);

  @override
  Object visitBinaryExpression(Binary node) {
    Object left = _evaluate(node.left);
    Object right = _evaluate(node.right);

    switch (node.operator.type) {
      case TokenType.GREATER:
        _checkNumberOperands(node.operator, left, right);
        return (left as double) > (right as double);
      case TokenType.GREATER_EQUAL:
        _checkNumberOperands(node.operator, left, right);
        return (left as double) >= (right as double);
      case TokenType.LESS:
        _checkNumberOperands(node.operator, left, right);
        return (left as double) < (right as double);
      case TokenType.LESS_EQUAL:
        _checkNumberOperands(node.operator, left, right);
        return (left as double) <= (right as double);
      case TokenType.MINUS:
        _checkNumberOperands(node.operator, left, right);
        return (left as double) - (right as double);
      case TokenType.SLASH:
        _checkNumberOperands(node.operator, left, right);
        return (left as double) / (right as double);
      case TokenType.STAR:
        _checkNumberOperands(node.operator, left, right);
        return (left as double) * (right as double);
      case TokenType.PLUS:
        if (left is double && right is double) return left + right;
        if (left is String && right is String) return left + right;
        throw RuntimeError(
            node.operator, "opernds must be two number or strings");
      case TokenType.BANG_EQUAL:
        return !_isEqual(left, right);
      case TokenType.EQUAL_EQUAL:
        return _isEqual(left, right);
      default:
        return null;
    }
    return null;
  }

  @override
  Object visitGroupingExpression(Grouping node) => _evaluate(node);

  @override
  Object visitLiteralExpression(Literal node) {
    return node.value;
  }

  @override
  Object visitUnaryExpression(Unary node) {
    Object right = _evaluate(node.right);

    switch (node.operator.type) {
      case TokenType.BANG:
        return !(_isTruthy(right));
      case TokenType.MINUS:
        _checkNumberOperand(node.operator, right);
        return -(right as double);
      default:
        return null;
    }
  }

  bool _isTruthy(Object obj) {
    if (obj == null) return false;
    if (obj is bool) return obj;
    return true;
  }

  bool _isEqual(Object left, Object right) {
    if (left == null && right == null) return true;
    if (left == null) return false;

    return left == right;
  }

  void _checkNumberOperand(Token operator, Object operand) {
    if (operand is double) return;
    throw RuntimeError(operator, "Operand must be a number");
  }

  void _checkNumberOperands(Token operator, Object left, Object right) {
    if (left is double && right is double) return;

    throw RuntimeError(operator, "Operands must be numbers");
  }
}
