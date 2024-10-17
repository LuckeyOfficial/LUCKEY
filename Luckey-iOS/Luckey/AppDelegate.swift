import UIKit
import Lottie

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    fileprivate(set) weak var tabBarController: UITabBarController?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "app_launched_time_interval")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
            let tabBarController = UITabBarController()
            window?.rootViewController = tabBarController
            self.tabBarController = tabBarController
        window?.makeKeyAndVisible()
        LottieConfiguration.shared.renderingEngine = .coreAnimation
        LottieConfiguration.shared.decodingStrategy = .legacyCodable
        return true
    }
    
    private func fireBaseConfig() {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}

extension UIApplication {
    static func shareAppdelegate() -> AppDelegate? {
        return self.shared.delegate as? AppDelegate
    }
    
    static func switchToTabBarController(_ completion: (() -> Void)? = nil) {
        let vc = UITabBarController()
        UIApplication.shareAppdelegate()?.tabBarController = vc
        shareAppdelegate()?.window?.switchRootViewController(to: vc,
                                                             options: .transitionCrossDissolve,
                                                             completion)
    }
}

