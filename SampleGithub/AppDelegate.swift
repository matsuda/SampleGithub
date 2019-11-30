//
//  AppDelegate.swift
//  SampleGithub
//
//  Created by Kosuke Matsuda on 2019/11/27.
//  Copyright © 2019 Kosuke Matsuda. All rights reserved.
//

import UIKit
import API

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let dict = Bundle.main.infoDictionary {
            if let token = dict["GitHubAPIToken"] as? String {
                print("token >>>>>>> \(token)")
                GitHubConfig.shared.token = token
            }
        }
        return true
    }
}
