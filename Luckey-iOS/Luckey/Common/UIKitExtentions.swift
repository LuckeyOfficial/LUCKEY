import SwifterSwift
import Reachability
import UIKit
import SwiftDate
import Haptica

public let CommonLeftInset: CGFloat = 20

public struct UIStyles {
    static let commonLeftInset: CGFloat = 20
}

extension String {
    
}

// MARK: - UIButton
private var ExtendEdgeInsetsKey: Void?
extension UIButton {
    var extendEdgeInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &ExtendEdgeInsetsKey) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
        set {
            objc_setAssociatedObject(self, &ExtendEdgeInsetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if extendEdgeInsets == .zero || !self.isEnabled || self.isHidden || self.alpha < 0.01 {
            return super.point(inside: point, with: event)
        }
        let newRect = extendRect(bounds, extendEdgeInsets)
        return newRect.contains(point)
    }

    private func extendRect(_ rect: CGRect, _ edgeInsets: UIEdgeInsets) -> CGRect {
        let x = rect.minX - edgeInsets.left
        let y = rect.minY - edgeInsets.top
        let w = rect.width + edgeInsets.left + edgeInsets.right
        let h = rect.height + edgeInsets.top + edgeInsets.bottom
        return CGRect(x: x, y: y, width: w, height: h)
    }
}

// MARK: - UIView
extension UIView {
    public func contentShot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func addTapGesture(target: Any?, action: Selector) {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tap)
    }
    
    public var bottom: CGFloat {
        self.y + self.height
    }
    
    public var right: CGFloat {
        self.x + self.width
    }
}

// MARK: - UIViewController
extension UIViewController {
    public func configCommonNavigationBar() {
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor.mainBackground
//        appearance.shadowImage = UIImage.init(color: .clear, size: CGSize(width: 1, height: 1))
//        appearance.shadowColor = .clear
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundImage = UIImage()
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        self.navigationController?.navigationBar.compactAppearance = appearance
//        if #available(iOS 15.0, *) {
//            self.navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
//        }
        configNavigtionBar(alpha: 1)
    }
    
    public func configNavigtionBar(alpha: CGFloat) {
        if #available(iOS 15.0, *) {
            self.navigationController?.navigationBar.compactScrollEdgeAppearance?.backgroundColor = UIColor(white: 0, alpha: alpha)
            self.navigationController?.navigationBar.compactScrollEdgeAppearance?.backgroundEffect = nil
        }
        self.navigationController?.navigationBar.standardAppearance.backgroundEffect = nil
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundEffect = nil
        self.navigationController?.navigationBar.compactAppearance?.backgroundEffect = nil
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.mainBackground.withAlphaComponent(alpha)
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor.mainBackground.withAlphaComponent(alpha)
        self.navigationController?.navigationBar.compactAppearance?.backgroundColor = UIColor.mainBackground.withAlphaComponent(alpha)
    }
    
    public var deviceNavigationBottomY: CGFloat {
        let tabBarController = UIApplication.shareAppdelegate()?.tabBarController
        guard let navigation = tabBarController?.viewControllers?.first as? UINavigationController else {
            return 0
        }
        return navigation.navigationBar.height + statusBarHeight()
    }
    
    public var tabBarHeight: CGFloat {
        UIApplication.shareAppdelegate()?.tabBarController?.tabBar.height ?? 0
    }
    
    public var bottomSafeAreaHeight: CGFloat {
        UIApplication.shareAppdelegate()?.window?.safeAreaInsets.bottom ?? 0
    }
    
    public var topSafeAreaHeight: CGFloat {
        UIApplication.shareAppdelegate()?.window?.safeAreaInsets.top ?? 0
    }
}

// MARK: - UIScrollView
extension UIScrollView {
    public func scrollToTop(animated: Bool) {
        setContentOffset(CGPoint(x: -self.contentInset.left, y: -self.contentInset.top), animated: animated)
    }
}

// MARK: - UITextField
extension UITextField {
    public var isEmpty: Bool {
        self.text?.isEmpty ?? true
    }
}
// MARK: - UIDevice
extension UIDevice {
    public static var isReachable: Bool {
        do {
            let reachability = try Reachability()
            return reachability.connection != .unavailable
        } catch  {
            return false
        }
    }
}

extension Date {
    func stringInCurrentRegion(formate: String) -> String {
        return self.convertTo(region: .current).toFormat(formate)
    }
}

extension UIButton {
    func enableHaptic(type: HapticFeedbackStyle = .medium) {
        self.isHaptic = true
        self.hapticType = .impact(type)
    }
}

public func statusBarHeight() -> CGFloat {
    let scene = UIApplication.shared.connectedScenes.first
    guard let windowScene = scene as? UIWindowScene else { return 0 }
    guard let statusBarManager = windowScene.statusBarManager else { return 0 }
    return statusBarManager.statusBarFrame.height
}
