# 構想

Condoの構想をつらつらと

拡張子は.cdか.coかなぁ

どっちが見栄えが良いかなぁ

できるだけspecificな解釈は面倒になってくるのでやめたい。
全ては関数だという考え方は面白いのでこれを採用したい感じもある。

## 実装言語
Nimがちょっと気になるので、それを使ってみようかなぁ


## set
```python
a = {1,2,3};
a = {a:1, b:2, c:3};

a.b
```

## list
```python
a = [1,2,3];

a[3]
```

## block(function)
```python
()

if (condition) (true) [(b_else)]

if (b)
(
    let a 3
    let b 5
)


rep: Int- = (|i proc|
    proc i;
    rep i-1 proc;
)

let sum 3
rep 3 (|i| sum += i)

```



## type

#### 型とは

型については何も分かっていないので勉強してから策定したい気もするけど基本的なものなので、、
([Type Theory](https://en.wikipedia.org/wiki/Type_theory))
とりあえず、プログラム内のオブジェクトの抽象化ということで理解させていただくと；；、
型によって処理を分けたり、型によって意味的な正しさのチェックを施したりするのに使えそうです。

折角抽象化をやるなら型に型があっても良いと思うので、例えば`int`と`float`などをまとめた`numeric`があっても良いよね

となると、~~抽象化しているものの集合が大切で逆にそれ以外の情報は持たないと考えてよいはずなのでこれをthings型で表現する~~
**無限集合の場合もあるヨ！！**

無限集合を抽象化の対象としている場合は述語論理式、有限集合の場合はその集合が型が持つべき情報。(こういう条件分岐嫌いだけどしょうがないかぁ、、無限ェ、、)

型の合成は型の型としてみなして良いかな、、型を値の抽象化として定義するならば、型の合成は型の型とみなして良い気もする。とすれば、値以上の抽象化はすべて型によってできるのでおｋかな？

あと、型にスコープは導入したほうが良いだろうか。スコープの利点として、メモリの再利用とか、名前汚染を防いだりとかの目的がありそう。型のデータ量は少ないのでメモリの問題としてはないんだけど。



#### 型の型

```python
type Tnumerical [int, float];
type numerical (union int float);
# (union [1,2,3] [4,5,6]) <=> [1,2,3,4,5,6]
```

この２つの型の差に気をつけないといけない




#### 型の表記
とりあえず明示的に書くようにします、、

全てを関数として扱うことに注意して、型の書き方

`int-bool`は整数を受け取ってboolを返す関数の型を表す。

手続き型の要素も（自分が書きやすいので）存分に残しておきたいので、戻り値がない関数（これは関数と言ってよいのかは正直良くわからないけど）
は`int-`とでも書く。

変数も関数とみなせるので`int`とかく。

**型の大文字小文字はどうしようかなぁ**
* 大文字のほうが見やすい？

* 大文字書くのめんどくさい, 串刺記法と合わない貴ガス


#### 型の定義

type関数を用いるようにする。type関数には、型の情報である、具体集合（集合?）か含まれる条件式（things-boolかな？）を渡す。

型を作るのに必要な情報は、*その型が何を抽象化しているのか*ということのみであるはずなので、
```python
# type: symbol-things-
# type: symbol-typed-
# listからthingsへの変換関数(型の暗黙変換はどうするべきか)

type bool ['true', 'false'];
# things-list暗黙変換
type numeric (union float int)

```



## functions

基本的に多用される（ように設計している）`()`は関数を表す

置いておくと実行されるべき時に実行される

* 名前の付け方
* 引数の設定

変数も関数として扱えるのでせっかくなので統一したいと考えると`let`で関数を定義できるのが自然

なお`let #symbol: type ()  <->  #symbol: type = ()`



```python
# 引数の受け取り方


# 関数定義

let fact 
(|n|

)

```



セミコロンはどうしようか、、
