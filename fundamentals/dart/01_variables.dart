void main() {
  // testVariable();
  // testVariable2();
  // testVariable3();
  // testVariable4();
  testVariable5();
}

void testVariable() {
  const version = '0.0.1';
  final name = '你的名字';
  var count = 0;
  count = count + 1;
  print('$name 正在用 Dart $version 开发， count 的值是 $count');
}

void testVariable2() {
  var objects = ['John', 'Jane', 'Jim'];
  print(objects);
  print(objects[0]);

  objects.add('Jill');
  var removed = objects.remove('Jim');
  print(objects);
  print(removed);
}

void testVariable3() {
  var person = {
    'name': 'John',
    'age': 30,
    'email': 'john@example.com',
    'friends': ['Jane', 'Jim'],
  };
  print(person);

  var friends = person['friends'];

  if (friends != null) {
    (friends as List).add('Jill');
    print(friends);
  }
}

void testVariable4() {
  Object name = 'John';
  name = 213;
  print(name);
}

void testVariable5() {
  var [name, ..._] = ['John', 'Jane', 'Jim'];
  print(name);
}
