bool isDigit(String char) {
  var parse = int.tryParse(char);
  if (parse != null && 9 > parse && parse > 0) {
    return true;
  } else {
    return false;
  }
}
