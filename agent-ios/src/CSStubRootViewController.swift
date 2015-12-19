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

        let webView = UIWebView.init(frame: culcAvailableViewRect())

        // ローカルのファイルのフルパスを取得する
        let path = self.setupBundleFilePath(Config())

        NSURLProtocol.registerClass(CSURLProtocol)

        webView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: path))) // TODO: リソースが取得できなかった時のエラーハンドリング

        self.view.addSubview(webView)
    }

    // override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}

    /* private methods */
    private func setupBundleFilePath(config: Config) -> String {
        let path: String = NSBundle.mainBundle().pathForResource(config.localEntoryFile,
                                                                  ofType: "html",
                                                                  inDirectory: config.localDirName)!
        return path
    }

    private func culcAvailableViewRect() -> CGRect {

        let frameSizeRect = UIScreen.mainScreen().bounds

        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height

        let availableViewHeight = CGRect.init(x: 0,
                                              y: statusBarHeight,
                                              width: frameSizeRect.width,
                                              height: frameSizeRect.height - statusBarHeight)
        return availableViewHeight
    }

}
