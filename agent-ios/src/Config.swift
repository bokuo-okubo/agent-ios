//
//  Config.swift
//  ReactNativeWithPods
//
//  Created by Yohei Okubo on 11/19/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation

struct Config {

    /*
    * TODO : 拡張性のあるConfig設定考える
    * - Dictionary? 型指定しないとあかん気がする
    * - Yaml? Json? どちらにしてもスキーマを定義しないとダメ？
    */

    // this config struct is TEMPORARY
    let hostName = "help.creativesurvey.com"

    let jsCodeLocation = "http://localhost:8081/index.ios.bundle?platform=ios&dev=true"

    let moduleName = "ReactNativeWithPods"

    let localEntoryFile = "index"

    let localDirName = "web"

}
