# 001 变量

对应官方文档：[Variables](https://dart.dev/language/variables)。

本章只讲变量本身：它保存什么、类型从哪来、能不能是 `null`、什么时候必须先赋值，以及 `final`、`const`、`late` 和 `_` 各自锁住哪一层。内置类型的细节留给下一章 [Built-in types](https://dart.dev/language/built-in-types)。

本地变量优先写 `var`，让类型从右边的初值推断出来。类型看不出来，或者你想把类型写给读代码的人看时，再把类型写在左边。

## 变量保存的是引用

```dart
var name = 'Bob';
```

`name` 里面放的不是字符本身，而是指向一个 `String` 对象的引用，那个对象的内容是 `Bob`。类型由 `'Bob'` 推断为 `String`。

右边的值不属于某一种类型时，把左边写成 `Object`。运行时可以先后指向不同种类的对象，静态类型则一直是 `Object`：

```dart
Object name = 'Bob';
name = 213;
```

这就是 `fundamentals/dart/01_variables.dart` 里 `testVariable4` 的写法。推断版本 `var name = 'Bob'` 会把类型定成 `String`，随后再赋整数会在编译期被拒绝。

确实要关掉静态检查时才用 `dynamic`。日常代码用 `Object` 或 `Object?`。

类型已经能推断出来、只是想写明时：

```dart
String name = 'Bob';
```

## 空安全

Dart 的空安全是健全的。对一个实际为 `null` 的值去读属性或调用方法，叫做空引用错误。`null` 自己支持的 `toString()` 和 `hashCode` 除外。编译器在运行前拦截这类访问。

例如 `int` 变量 `i` 如果是 `null`，`i.abs()` 就不能执行。没有空安全的语言往往要到运行时才崩溃。

空安全带来三条规则。

**类型自己决定能不能是 `null`。** 末尾加 `?` 才允许 `null`：

```dart
String? name; // 可以是 null，也可以是字符串
String name;  // 不能是 null
```

**使用前必须已经有值。** 可空变量的默认值就是 `null`，所以声明之后已经算初始化过。非空变量没有默认值，Dart 不允许你读到一个尚未赋值的变量。

**可空类型不能直接调用方法或读取属性。** 同样，`toString()` 和 `hashCode` 例外，因为 `null` 自己就有它们。

因此下面两类问题会变成编辑期的分析错误，而不是上线后才出现：

- 非空变量还没有用非空值初始化
- 把 `null` 赋给非空变量

## 默认值

未赋值的可空变量初值是 `null`。数字也一样，因为数字同样是对象：

```dart
int? lineCount;
assert(lineCount == null);
```

`assert(condition)` 在开发时会在条件为假时抛异常。发布产物会忽略 `assert`。

非空变量必须在使用前赋值：

```dart
int lineCount = 0;
```

局部变量可以先声明、后赋值。只要每条会用到它的路径上都已经赋过值，编译器就接受。下面的 `print` 是合法的，因为两个分支都给了 `lineCount`：

```dart
int lineCount;

if (weLikeToCount) {
  lineCount = countLines();
} else {
  lineCount = 0;
}

print(lineCount);
```

顶层变量和类里的实例变量是惰性初始化的：初始化表达式在这个变量第一次被使用时才执行。

## late

`late` 有两种用途。

- 声明一个非空变量，但把赋值推迟到声明之后。
- 把初始化推迟到第一次使用。

控制流分析通常看得出局部变量在使用前已经赋了非空值。顶层变量和实例变量做不到同样的判断，编译器也就不去猜。你确定使用前一定会赋值时，用 `late` 告诉它：

```dart
late String description;

void main() {
  description = 'Feijoada!';
  print(description);
}
```

如果一直到使用时都还没赋值，读取这个 `late` 变量会在运行时抛错。

`late` 不负责推断类型。顶层写 `var name;` 且没有初值时，类型是 `dynamic`，默认值是 `null`，所以不必加 `late`。`var` 占的就是类型的位置，不能再写成 `var String? name;`。可空字符串直接声明为 `String? name;`。

| 声明 | 静态类型 | 未赋值时 | 赋过 `'John'` 之后 |
| --- | --- | --- | --- |
| `var name;` | `dynamic` | `null` | 仍是 `dynamic`，字符串方法不会被检查 |
| `String? name;` | `String?` | `null` | 仍是 `String?`，使用前要处理 `null` |
| `late String name;` | `String` | 还没有值，读取会在运行时抛错 | `String`，可以直接调用字符串方法 |

`late` 变量在声明时就写了初值的话，初值要等到第一次读取才计算：

```dart
late String temperature = readThermometer();
```

`temperature` 从没被读过，`readThermometer()` 就不会执行。这适合两种情况：初始化很贵，而且这个变量可能根本用不到；或者这是实例变量，初始化表达式需要用到 `this`。

## final 和 const

`final` 和 `const` 都让这个名字只能指向一个对象。差别是这个对象还能不能改，以及它的内容必须在什么时候定下来。

`final` 只锁名字。程序运行到这一行时算出对象，之后这个名字不能再指向别的东西。对象里面如果本来就能改，仍然可以改：

```dart
final objects = ['John', 'Jane'];
objects.add('Jill'); // 可以。还是原来那个列表，只是多了一个元素
objects = ['别人']; // 编译错误。名字不能改去指另一个列表
```

右边也可以是运行时才知道的值，例如 `final time = DateTime.now();`。每次运行，时刻都可以不同，但这次运行里 `time` 不能再改指到另一个时刻。

`const` 更严。值必须在编译时就完全确定，而且对象从里到外都不能再改：

```dart
const objects = ['John', 'Jane'];
objects.add('Jill'); // 运行时错误。这个列表是封死的
objects = ['别人']; // 编译错误。名字同样不能改
```

`DateTime.now()` 要等程序跑起来才知道现在几点，所以不能写成 `const time = DateTime.now();`。字符串、数字，以及由这些常量算出来的结果，才可以是 `const`。

| | 名字还能不能改指到别处 | 对象里面还能不能改 | 值何时确定 |
| --- | --- | --- | --- |
| `var objects = [...]` | 能 | 能 | 运行到这一行 |
| `final objects = [...]` | 不能 | 能 | 运行到这一行 |
| `const objects = [...]` | 不能 | 不能 | 编译时 |

`const` 变量本身也是 `final`，所以名字那一层同样锁住。可以代替 `var`，也可以和类型写在一起，例如 `final String nickname = 'Bobby';`。

实例变量可以是 `final`，不能是 `const`。类里的常量要写成 `static const`。

```dart
final name = 'Bob';
final String nickname = 'Bobby';
```

`name = 'Alice'` 是编译错误：`final` 变量只能设置一次。

`const` 的值必须在编译期就能确定，例如数字、字符串、另一个常量，或者由常量构成的运算：

```dart
const bar = 1000000;
const double atm = 1.01325 * bar;
```

`const` 不只用来声明变量，也可以用来创建常量值，以及声明能创建常量的构造函数。普通变量也可以持有一个常量值：

```dart
var foo = const [];
final bar = const [];
const baz = []; // 等价于 const []
```

`const` 声明的初值表达式里，多余的 `const` 可以省略，上面的 `baz` 就是这样。

`foo` 既不是 `final` 也不是 `const`，所以这个名字以后可以改指向别处，哪怕它现在指向一个常量列表：

```dart
foo = [1, 2, 3];
```

`baz` 本身是常量变量，不能再赋值：

```dart
baz = [42]; // 错误
```

常量表达式里还可以使用类型判断和转换（`is`、`as`）、集合里的 `if`，以及展开（`...`、`...?`）：

```dart
const Object i = 3;
const list = [i as int];
const map = {if (i is int) i: 'int'};
const set = {if (list is List<int>) ...list};
```

`const` 用在列表、映射和类上的进一步规则，分别在后面的 Built-in types 和 Classes 里。Flutter 里的 `const MyApp()` 也是这一层：这棵界面在编译时就能确定，运行中也不会改。

## 通配符变量

通配符变量需要语言版本至少 3.7。本机的 Dart 3.13 已经满足。

名字写成 `_` 的局部变量或参数是占位符，不建立绑定。有初始化表达式的话，表达式仍会执行，只是结果读不出来。同一个作用域里可以有多个 `_`，不会因为重名冲突。

它不能用在顶层声明或可能影响库私有性的成员上。库私有仍然是「以 `_` 开头的普通名字」，例如 `_counter`，那是另一个规则。

可以写成通配符的位置：

```dart
void main() {
  var _ = 1;
  int _ = 2;
}

for (var _ in list) {}

try {
  throw '!';
} catch (_) {
  print('oops');
}
```

列表解构时，`..._` 把第一项之后的元素全部丢掉，并且不建立绑定：

```dart
var [name, ..._] = ['John', 'Jane', 'Jim'];
print(name); // John
```

这和 ES6 的 `const [name, ...rest] = ...` 是同一种拆法。ES6 的剩余元素仍会放进一个新数组。Dart 的 `..._` 不创建这个数组，后面也不能读 `_`。列表至少要有一项，否则模式对不上，运行时会抛错。只有一项时剩余部分是空的，`name` 仍然取到那一项。

循环里的一项本身如果是一对值，也在这一个循环变量里解构，丢掉不需要的那一项：

```dart
final people = [(1, 'Ada'), (2, 'Bob')];

for (var (_, person) in people) {
  print(person);
}
```

泛型参数、函数类型参数和函数参数也可以是 `_`：

```dart
class T<_> {}

void genericFunction<_>() {}

list.where((_) => true);

void f(void g(int _, bool _)) {}
```

打开 lint `unnecessary_underscores` 之后，分析器会标出以前为了避开重名而写成 `__`、`___` 的参数，提示改成一个不绑定的 `_`。
