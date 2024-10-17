import UIKit
import ViewAnimator

extension UICollectionView {
    public func reloadWithAnimation() {
        self.reloadData()
        self.performBatchUpdates({
            UIView.animate(views: self.orderedVisibleCells,
                           animations: [AnimationType.vector((CGVector(dx: 30, dy: 0))), AnimationType.zoom(scale: 0.2)],
                           animationInterval: 0.2,
                           duration: 0.4,
                           completion: nil)
        }, completion: nil)
    }
}

class SlideTextShiningAnimation {
    public var animationView: UIView?
    
    private lazy var shadowBackgroundColor = UIColor(white: 1, alpha: 0.5)
    private lazy var shadowForegroundColor = UIColor.white
    private var shadowWidth: CGFloat = 40
    
    public func start() {
        guard let animationView = animationView else {
            return
        }

        let gradient = CAGradientLayer()
        gradient.frame = animationView.bounds
        shadowWidth = animationView.width / 4
        
        let gradientSize: CGFloat = self.shadowWidth / animationView.width
        let startLocations = [0,
                              NSNumber.init(value: gradientSize/2.0),
                              NSNumber.init(value: gradientSize)]
        let endLocations = [NSNumber.init(value: 1.0 - gradientSize),
                            NSNumber.init(value: (1.0 - gradientSize/2.0)),
                            1]
        gradient.colors = [shadowBackgroundColor.cgColor,
                           shadowForegroundColor.cgColor,
                           shadowBackgroundColor.cgColor]
        gradient.locations = startLocations
        gradient.startPoint = CGPoint(x: 0 - gradientSize * 2, y: 0.5)
        gradient.endPoint = CGPoint(x: 1 + gradientSize * 2, y: 0.5)
        animationView.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = startLocations
        animation.toValue = endLocations
        animation.repeatCount = Float.infinity
        animation.duration = 3
        gradient.add(animation, forKey: nil)
    }
}
