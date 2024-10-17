
import UIKit

extension UIViewController {
    @objc public static func topViewController() -> UIViewController? {
        if let rootVC = UIApplication.shareAppdelegate()?.tabBarController {
            return self.topViewController(fromVC: rootVC)
        }
        return nil
    }
    
    static func topViewController(fromVC: UIViewController?) -> UIViewController? {
        if let presentedVC = fromVC?.presentedViewController {
            return self.topViewController(fromVC: presentedVC)
        }
        else if let navi = fromVC as? UINavigationController {
            return self.topViewController(fromVC: navi.topViewController)
        } else if let tab = fromVC as? UITabBarController {
            return self.topViewController(fromVC: tab.selectedViewController)
        }  else {
            return fromVC
        }
    }
    
    static func push(toVC: UIViewController, animated: Bool = true) {
        guard let navi = topViewController()?.navigationController else {
            return
        }
        if navi.viewControllers.count == 1 {
            toVC.hidesBottomBarWhenPushed = true
        }
        navi.pushViewController(toVC, animated: animated)
    }
}
