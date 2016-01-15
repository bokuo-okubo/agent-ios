//
//  Token.swift
//
//
//  Created by Yohei Okubo on 1/5/16.
//
//

/**
*  Tokenらしく振舞うもの
*/
public protocol Tokenable {

  var label: Labelable { get }
  var value: String { get }

  /**
   公開イニシャライザ

   - parameter label: labelオブジェクト
   - parameter value: Tokenの対象になる実際の文字列

   - returns: Token
   */
  static func create(label label: Labelable, value: String) -> Self

  /* Atom */
  static func create(value value: String) -> Self

  /* Empty */
  static func create() -> Self
}

// MARK: - Tokenableの拡張実装
extension Tokenable {

  /**
   複数のTokenを一つのTokenとしてまとめる

   - parameter tokens: 幾つかのToken

   - returns: 一つのToken
   */
  public static func unify(label label: Labelable, tokens: [Self]) -> Self {
    return Self.create(
      label: label,
      value: tokens.map { $0.value }.reduce("") { $0 + $1 })
  }
  /**
   flattenのショートカット

   - parameter tokens: 幾つかのToken

   - returns: 一つのToken
   */
  public static func unify(label label: Labelable, tokens: Self...) -> Self {
    return unify(label: label, tokens: tokens)
  }
}


/**
 *  EggにおけるTokenの実体
 */
public struct Token: Tokenable {

  public let label: Labelable
  public let value: String
  public var name: String {
    return label.name
  }
  public var key: String {
    return label.key
  }

  private init(label: Labelable, value: String) {
    self.label = label
    self.value = value
  }

  public static func create(label label: Labelable, value: String) -> Token {
    return Token(label: label, value: value)
  }

  public static func create(value value: String) -> Token {
    return Token(label: Label(name: LabelTypes.ATOM, key: value), value: value)
  }

  public static func create() -> Token {
    return Token(label: Label(name: LabelTypes.EMPTY), value: "")
  }
}

// MARK: - ArrayExtentions
public extension Array where Element: Tokenable {

  /**
   Tokenの列を、新しい一つのTokenにする

   - parameter name: 新しいTokenの名前

   - returns: 新しいToken
   */
  func unify(name name: String, key: String? = nil) -> Element {
    func returning(lab: Label) -> Element {
      return Element.create(
        label: lab,
        value: self.map { $0.value }.reduce("") { $0 + $1 })
    }

    switch key {
    case.Some:
      let lab = Label(name: name, key: key!)
      return returning(lab)
    case.None:
      let lab = Label(name: name, key: self.reduce("") { $0 + $1.label.key })
      return returning(lab)
    }
  }

  func concat() -> Element {
    return Element.create(
      label: self.map { $0.label }.reduce(Label()) { $0.add($1) },
      value: self.map { $0.value }.reduce("") { $0 + $1 })
  }
}
