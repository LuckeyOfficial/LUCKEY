import UIKit

open class CustomPresentAnimationViewController: UIViewController {
    open var enableTapDismiss: Bool {
        return true
    }
    
    open var animateView: UIView {
        return self.view
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = presentDelegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var presentDelegate = PresentTransitioningDelegate()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc private func dismissAction() {
        if enableTapDismiss {
            self.dismiss(animated: true)
        }
    }
}

class PresentTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimationController()
    }
}

class PresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let toVC = transitionContext.viewController(forKey: .to) as? CustomPresentAnimationViewController else {
            transitionContext.completeTransition(true)
            return
        }
        toView.frame = transitionContext.finalFrame(for: toVC)
        transitionContext.containerView.addSubview(toView)
        if transitionContext.isAnimated {
            let color = toVC.view.backgroundColor
            toVC.view.backgroundColor = .clear
            toVC.animateView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                toVC.animateView.alpha = 1.0
                toVC.animateView.transform = .identity
            }) { (_) in
                transitionContext.completeTransition(true)
            }
            UIView.animate(withDuration: 0.25, delay: 0) {
                toVC.view.backgroundColor = color
            } completion: { _ in
                
            }
        } else {
            transitionContext.completeTransition(true)
        }
    }
}

class DismissingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view(forKey: .from) {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.alpha = 0.0
            }) { (_) in
                transitionContext.completeTransition(true)
                fromView.alpha = 1.0
                fromView.removeFromSuperview()
            }
        }
    }
}
