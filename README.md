# agent-ios

## Requirements

- Ruby ~> 2.0
- [SwiftLint](https://github.com/realm/SwiftLint)

## Setup

```
# this project uses swiftlint
$ brew install swiftlint

$ ./start.sh
    # => bundle install
    # => bundle exec pod install
    # => open xcode
```


## Test

```
$ ./test.sh
```


###ソースコードの説明
3/7 時点で、

- スタブとして動くWebViewController, NSURLプロトコルdelegateを実装したクラス
- Seudoサーバの実装
- パーサコンビネータ(Egg)
- パーサコンビネータを用いた、URLパスのコンパイラ

という実装を含んでいます。

### スタブとして動くWebViewController, NSURLプロトコルdelegateを実装したクラス
`~/agent-ios/src/` ディレクトリ以下にございます。
ビジネスロジック層を`Domain`
UIに関わるクラス群を`Presentation` 
ということでディレクトリ階層を定義しています。

### Seudoサーバの実装
`~/agent-ios/src/lib/` 以下にございます。

### パーサコンビネータ(Egg)
`~/Egg` 以下に別projectfileとしてございます。
agent-ios全体は `xcworkspace` 管理になっていて、
`Egg` 自体にはモジュール単体でのビルドスキーム、テストスキームを設定してあります。

### パーサコンビネータを用いた、URLパスのコンパイラ

`~/agent-ios/src/Domain/CSPathLexers.swift`
`~/agent-ios/src/Domain/CSPathCompiler.swift`
が対応しています。

`~/agent-ios/src/Domain/CSPathLexers.swift`
URLパススキームを読ませ、それがvalidであるかを判定します。
また、登録時のパススキームを、
URLリクエスト時に発火するマルチプレクサに登録する`key-value`の
`key`として保持する仕組みを設定しています。

`~/agent-ios/src/Domain/CSPathCompiler.swift`
コンパイル動作のトップレベルになります。
`- compile(pathScheme: String)` メソッドに
URLPathSchemeの文字列を渡すと、そのSchemeに対応した、RealPathLexerを返します。
RealPathLexerがパースした際の結果の値は、
`~/agent-ios/src/Domain/CSLexResult.swift`
で定義した、`agent-ios`由来の結果型になります。

