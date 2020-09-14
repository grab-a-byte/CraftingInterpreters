import 'package:Dart/statements/stmt.dart';

class Block implements Stmt {
  List<Stmt> statements;

  Block(this.statements);

  @override
  void accept(StmtVisitor visitor) {
    visitor.visitBlockStmt(this);
  }
}
