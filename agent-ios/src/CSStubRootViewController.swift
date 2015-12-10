//
//  ViewController.swift
//  agent-ios
//
//  Created by Yohei Okubo on 12/10/15.
//  Copyright © 2015 bko. All rights reserved.
//

import UIKit

class CSStubRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let frameSizeRect = UIScreen.mainScreen().bounds
        let webView = UIWebView.init(frame: frameSizeRect)

        // ローカルのファイルのフルパスを取得する
        let path = self.setupBundleFilePath(Config())

        NSURLProtocol.registerClass(CSURLProtocol)

        webView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: path))) // TODO: リソースが取得できなかった時のエラーハンドリング
        self.view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* private methods */
    private func setupBundleFilePath(config: Config) -> String {
        print(config)
        let path : String = NSBundle.mainBundle().pathForResource(config.localEntoryFile,
                                                                  ofType: "html",
                                                                  inDirectory: config.localDirName)!
        return path
    }

}

