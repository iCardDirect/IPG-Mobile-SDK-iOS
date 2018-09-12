//
//  AppDelegate.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 12/15/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ICCheckout.initialize(withMerchantId: "112",
                              originator: "33",
                              currency: .EUR,
                              certificate: ICConstants.Security.publicCertificate,
                              privateKey: ICConstants.Security.privateKey,
                              bundle: .main,
                              keyIndex: 1,
                              isSandbox: true)
        
        return true
    }
}
