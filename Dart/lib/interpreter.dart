import 'dart:ffi';
import 'dart:math';

import 'package:Dart/environment.dart';
import 'package:Dart/errors.dart';
import 'package:Dart/expressions/Assign.dart';
import 'package:Dart/expressions/binary.dart';
import 'package:Dart/expressions/expression.dart';
import 'package:Dart/expressions/logical.dart';
import 'package:Dart/expressions/unary.dart';
import 'package:Dart/expressions/literal.dart';
import 'package:Dart/expressions/grouping.dart';
import 'package:Dart/expressions/variable.dart';
import 'package:Dart/statements/block.dart';
import 'package:Dart/statements/if_statement.dart';
import 'package:Dart/statements/print_statement.dart';
import 'package:Dart/statements/expresion_statement.dart';
import 'package:Dart/statements/stmt.dart';
import 'package:Dart/statements/variable_statement.dart';
import 'package:Dart/token.dart';

import 'lox.dart';
import 'token.dart';

class Interpreter implements ExprVisitor<Object>, StmtVisitor {
  Environment _environment = Environment();

  void interpret(List<Stmt> statments) {
    try {
      for (Stmt statement in statments) {
        _execute(statement);
      }
    } on RuntimeError catch (error) {
      Lox.runtimeError(error);
    }
  }

  void _execute(Stmt statement) {
    statement.accept(this);
  }

  String _stringify(Object obj) {
    if (obj == null) return 'nil';
    return obj.toString();
  }

  Object _evaluate(Expr expr) => expr.accept(this);

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

  @override
  void visitExpressionStmt(ExpressionStatement statement) {
    _evaluate(statement.expression);
  }

  @override
  void visitPrintStmt(PrintStatement statement) {
    Object value = _evaluate(statement.expression);
    print(_stringify(value));
  }

  @override
  void visitVariableStmt(VariableStatement variableStatement) {
    Object value = null;
    if (variableStatement.initializer != null) {
      value = _evaluate(variableStatement.initializer);
    }

    _environment.define(variableStatement.name.lexeme, value);
  }

  @override
  void visitBlockStmt(Block block) {
    _executeBlock(block.statements, Environment(enclosing: _environment));
  }

  @override
  Object visitVariableExpression(Variable variable) {
    return _environment.get(variable.name);
  }

  @override
  Object visitAssignExpression(Assign assign) {
    Object value = _evaluate(assign.value);
    _environment.assign(assign.name, value);
    return value;
  }

  @override
  void visitIfStmt(IfStatement ifStatement) {
    if (_isTruthy(_evaluate(ifStatement.condition))) {
      _execute(ifStatement.thenBranch);
    } else if (ifStatement.elseBranch != null) {
      _execute(ifStatement.elseBranch);
    }
  }

  @override
  Object visitLogicalExpression(Logical logical) {
    Object left = _evaluate(logical.left);

    if (logical.operator.type == TokenType.OR) {
      if (_isTruthy(left)) return left;
    } else {
      if (!_isTruthy(left)) return left;
    }

    return _evaluate(logical.right);
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

  void _executeBlock(List<Stmt> statements, Environment env) {
    Environment prev = _environment;
    try {
      _environment = env;

      for (Stmt stmt in statements) {
        _execute(stmt);
      }
    } finally {
      _environment = prev;
    }
  }
}
