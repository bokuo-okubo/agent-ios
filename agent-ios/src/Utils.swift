//
//  Utils.swift
//  ReactNativeWithPods
//
//  Created by Yohei Okubo on 11/26/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation

// for debugging.
func p<T>(objs: T...) -> [String] {
  return objs.map({ print( String($0) ); return String($0) })
}


// stringRange maker
internal func stringRange(target: String, from: Int, to: Int)
  -> Range<String.CharacterView.Index> {
    let idx = target.startIndex
    let length = target.characters.count
    let isCursorInnerString = from + to < length

    if isCursorInnerString {
      return Range(start: idx.advancedBy(from), end: idx.advancedBy(from).advancedBy(to) )
    } else if from > length {
      return Range(start: target.endIndex, end: target.endIndex )
    } else {
      return Range(start: idx.advancedBy(from), end: target.endIndex )
    }
}

// an operator being able to join two dictionaries
func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
  for (k, v) in right {
    left.updateValue(v, forKey: k)
  }
}
