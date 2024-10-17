import UIKit

public enum ButtonImagePositionStyle {
    case top
    case left
    case right
    case bottom
}

extension UIButton {
    public func layoutButton(style: ButtonImagePositionStyle, imageTitleSpace: CGFloat) {
        
        // 1. 得到imageView和titleLabel的宽、高
        let imageWidth: CGFloat = self.imageView?.image?.size.width ?? 0
        let imageHeight: CGFloat  = self.imageView?.image?.size.height ?? 0
        
        let labelWidth = self.titleLabel?.size.width ?? 0
        let labelHeight = self.titleLabel?.size.height ?? 0
        
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-imageTitleSpace/2.0,
                                           left: 0,
                                           bottom: 0,
                                           right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0,
                                           left: -imageWidth,
                                           bottom: -imageHeight-imageTitleSpace/2.0,
                                           right: 0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: -imageTitleSpace/2.0,
                                           bottom: 0,
                                           right: imageTitleSpace/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0,
                                           left: imageTitleSpace/2.0,
                                           bottom: 0,
                                           right: -imageTitleSpace/2.0)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: -labelHeight-imageTitleSpace/2.0,
                                           right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-imageTitleSpace/2.0,
                                           left: -imageWidth,
                                           bottom: 0,
                                           right: 0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: labelWidth+imageTitleSpace/2.0,
                                           bottom: 0,
                                           right: -labelWidth-imageTitleSpace/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0,
                                           left: -imageWidth-imageTitleSpace/2.0,
                                           bottom: 0,
                                           right: imageWidth+imageTitleSpace/2.0)
        }
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}
