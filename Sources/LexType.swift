//
//  LexType.swift
//  Egg
//
//  Created by Yohei Okubo on 1/12/16.
//  Copyright © 2016 bko. All rights reserved.
//

// ENUMにできる?
struct LexType {

  static func ATOM(str: String) -> String {
    return NameCreater.wrap(("ATOM(", ")"))(name: str)
  }

  static let EMPTY = "EMPTY"

  static func NOT(str: String) -> String {
    return "NOT\(str)"
  }

  static let EOF = "EOF"

  static func MANY(str: String) -> String {
    return "MANY\(str)"
  }

  static func SEQ(strs: [String]) -> String {
    return "SEQ(\(strs.reduce("", combine: +)))"
  }

  static let CONCAT = "CONCAT"

  static func OPTION(str: String) -> String {
    return "OPTION(\(str))"
  }

  static let OR = "OR"
  static let MAP = "MAP"
  static let UNIFY = "UNIFY"
}
