
import UIKit

extension UIColor {
    public func fillImage(_ rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    public static var mainPurple = "#D1BAFF".colorWithHex()!
    public static var primaryPurple = "#5044FF".colorWithHex()!
    public static var mainBackground = "#191922".colorWithHex()!
    public static var mainContentBackground = "#20202C".colorWithHex()!
}
