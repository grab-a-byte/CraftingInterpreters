import 'package:Dart/expressions/expression.dart';
import 'package:Dart/statements/block.dart';
import 'package:Dart/statements/expresion_statement.dart';
import 'package:Dart/statements/print_statement.dart';
import 'package:Dart/statements/variable_statement.dart';

abstract class Stmt {
  void accept(StmtVisitor visitor);
}

abstract class StmtVisitor {
  void visitExpressionStmt(ExpressionStatement statement);
  void visitPrintStmt(PrintStatement statement);
  void visitVariableStmt(VariableStatement variableStatement);
  void visitBlockStmt(Block block);
}
