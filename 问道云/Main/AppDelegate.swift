//
//  AppDelegate.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import DYFStore
import StoreKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        keyBordManager()
        rootVcPush()
        openWechat()
        initIAPSDK()
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = WDNavigationController(rootViewController: WDTabBarController())
        window?.makeKeyAndVisible()
        return true
    }
    
}

extension AppDelegate: WXApiDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        
    }
    
    private func openWechat() {
        WXApi.registerApp("wx24b1a40f5ff2811e", universalLink: "https://www.wintaocloud.com/iOS/")
    }
    
    private func keyBordManager() {
        let manager = IQKeyboardManager.shared
        manager.enable = true
        manager.shouldResignOnTouchOutside = true
    }
    
    func rootVcPush() {
        NotificationCenter.default.addObserver(self, selector: #selector(setUpRootVc(_ :)), name: NSNotification.Name(ROOT_VC), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goRiskVc(_ :)), name: NSNotification.Name(RISK_VC), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goDiliVc(_ :)), name: NSNotification.Name(DILI_VC), object: nil)
    }
    
    @objc func setUpRootVc(_ notification: Notification) {
        window?.rootViewController = WDNavigationController(rootViewController: WDTabBarController())
    }
    
    @objc func goRiskVc(_ notification: Notification) {
        let tabBarVc = WDTabBarController()
        tabBarVc.selectedIndex = 1
        window?.rootViewController = WDNavigationController(rootViewController: tabBarVc)
    }
    
    @objc func goDiliVc(_ notification: Notification) {
        let tabBarVc = WDTabBarController()
        tabBarVc.selectedIndex = 2
        window?.rootViewController = WDNavigationController(rootViewController: tabBarVc)
    }
    
}

//内购相关
extension AppDelegate: DYFStoreAppStorePaymentDelegate {
    
    //
    func didReceiveAppStorePurchaseRequest(_ queue: SKPaymentQueue, payment: SKPayment, forProduct product: SKProduct) {
        
    }
    
    func initIAPSDK() {
        SKIAPManager.shared.addStoreObserver()
        DYFStore.default.enableLog = true
        DYFStore.default.addPaymentTransactionObserver()
        DYFStore.default.delegate = self
    }
    
}
