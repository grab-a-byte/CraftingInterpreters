import 'package:Dart/lox.dart';

void main(List<String> args) {

  var lox = Lox();

  if (args.length > 1) {
    print('Usage: dlox [<path>]');
  } else if (args.length == 1) {
    lox.runFile(args[0]);
  } else {
    lox.runPrompt();
  }
}