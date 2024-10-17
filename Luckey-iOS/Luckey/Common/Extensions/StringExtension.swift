
import UIKit

// MARK: - String
extension String {
    public func colorWithHex() -> UIColor? {
        return UIColor(hexString: self)
    }

    public func labelHeight(inWidth: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: inWidth,
                                          height: CGFloat.greatestFiniteMagnitude)
            )
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = font
            label.text = self
            label.sizeToFit()
            return label.frame.height
    }
}
