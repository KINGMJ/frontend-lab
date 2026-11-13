void main() {
  testOperators1();
}

void testOperators1() {
  String? name;
  print(name ?? 'Guest');

  print(5 / 2);
  print(5 ~/ 2); // 整除
  print(5 % 3); // 取余
}
