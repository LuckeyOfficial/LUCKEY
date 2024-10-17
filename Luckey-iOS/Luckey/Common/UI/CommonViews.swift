import UIKit
import SnapKit
import SwifterSwift

class MarginLabel: UILabel {
    var contentInset: UIEdgeInsets = .zero
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect: CGRect = super.textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
        //根据edgeInsets，修改绘制文字的bounds
        rect.origin.x -= contentInset.left;
        rect.origin.y -= contentInset.top;
        rect.size.width += contentInset.left + contentInset.right;
        rect.size.height += contentInset.top + contentInset.bottom;
        return rect
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }
}

public class RightImageButton: UIButton {
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutButton(style: .right, imageTitleSpace: 2)
    }
}

class GradientPurpleLabel: UILabel {
    var normalTextColor: UIColor? {
        didSet {
            self.textColor = normalTextColor
        }
    }
    
    var enabelGradient: Bool = false {
        didSet {
            refreshContentTextColor()
        }
    }
    
    func refreshContentTextColor() {
        guard enabelGradient else {
            self.textColor = self.normalTextColor
            return
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        if self.height * self.width == 0 {
            return
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: [CGFloat] = [109.0/255, 1, 1, 1,
                                 230.0/255, 112.0/255, 1, 1]

        guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: nil, count: 2) else {
            return
        }
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: self.width, y: self.height)
        context.drawLinearGradient(gradient,
                                   start: start,
                                   end: end,
                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()
        self.textColor = UIColor(patternImage: gradientImage)
    }
}

// MARK: - GradientView
class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        CAGradientLayer.classForCoder()
    }
    var colors: [CGColor]?
    var locations: [NSNumber]?
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}

public class ActivityIndicatorContentView: UIView {
    func showActivity() {
        customView.isHidden = true
        indicatorView.startAnimating()
    }
    
    func stopActivity() {
        customView.isHidden = false
        indicatorView.stopAnimating()
    }
    
    public override var intrinsicContentSize: CGSize {
        customView.size
    }
    
    init(customView: UIView, size: CGSize) {
        self.customView = customView
        super.init(frame: CGRect(center: .zero, size: size))
        self.isUserInteractionEnabled = true
        self.addSubviews([customView, indicatorView])
        customView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(size)
        }
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private var customView: UIView
    
    private(set) lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        view.color = .white
        return view
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VisualEffectShadowView: UIVisualEffectView {
    init(effect: UIVisualEffect?,
         colors: [CGFloat] = [0.5, 0.5, 0.5, 0.5,
                              0, 0, 0, 0,
                              0, 0, 0, 0,
                              0.5, 0.5, 0.5, 0.5],
         locations: [CGFloat] = [0, 0.1, 0.9, 1],
         borderWidth: CGFloat = 2) {
        self.colors = colors
        self.locations = locations
        super.init(effect: effect)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.cornerRadius = 20
        self.layer.shadowRadius = 10
        self.layerBorderWidth = borderWidth
    }
    
    private var colors: [CGFloat]
    private var locations: [CGFloat]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             byRoundingCorners: .allCorners,
                                             cornerRadii: CGSize.zero).cgPath
        self.subviews.forEach {
            $0.layer.cornerRadius = 20
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let gradient = CGGradient(colorSpace: colorSpace,
                                        colorComponents: colors,
                                        locations: locations,
                                        count: locations.count) else {
            return
        }
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: self.width, y: self.height)
        context.drawLinearGradient(gradient,
                                   start: start,
                                   end: end,
                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()
        self.layerBorderColor = UIColor(patternImage: gradientImage)
    }
}

class GradientAndShadowBorderView: UIView {
    override class var layerClass: AnyClass {
        CAGradientLayer.classForCoder()
    }
    var colors: [CGColor] = [
        UIColor(red: 0.82, green: 0.729, blue: 1, alpha: 0.12).cgColor,
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.03).cgColor,
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.21).cgColor
    ]

    var locations: [NSNumber] = [0, 0.49, 1]
    var startPoint: CGPoint = CGPoint(x: 0.25, y: 0)
    var endPoint: CGPoint = CGPoint(x: 0.75, y: 1)

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.borderWidth = 1
        gradientLayer.cornerRadius = 20
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             byRoundingCorners: .allCorners,
                                             cornerRadii: CGSize.zero).cgPath
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let gradient = CGGradient(colorSpace: colorSpace,
                                        colorComponents: [209/255.0, 186/255.0, 1, 0.4,
                                                          0, 0, 0, 0.4,
                                                          0, 0, 0, 0,
                                                          194/255.0, 1, 1, 0.4],
                                        locations: [0, 0.45, 0.55, 1],
                                        count: 4) else {
            return
        }
        let start = CGPoint(x: 0.3 * self.width, y: self.height)
        let end = CGPoint(x: self.width * 0.7, y: 0)
        context.drawLinearGradient(gradient,
                                   start: start,
                                   end: end,
                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()
        self.layerBorderColor = UIColor(patternImage: gradientImage)
    }
}
