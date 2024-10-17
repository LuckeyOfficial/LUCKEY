import UIKit
import SwifterSwift

open class STSegmentPageController : UIViewController {
    private lazy var pageViewControllerMain: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    /// 数据源
    public lazy var dataSouceControll = [UIViewController]()
    /// 索引
    private lazy var nextIndex : Int = 0
    public lazy var currentIndex: Int = 0
    /// 实现自定义segmentControl的滚动视图
    public lazy var scrollView : UIScrollView = UIScrollView()

    var screenMainWidth: CGFloat {
        let windowWidth = UIApplication.shareAppdelegate()?.window?.size.width ?? UIScreen.main.bounds.size.width
        return windowWidth
    }
    var screenMainHeight: CGFloat {
        let windowHeight = UIApplication.shareAppdelegate()?.window?.size.height ?? UIScreen.main.bounds.size.height
        return windowHeight
    }
    public var segmentBarOriginX: CGFloat = 0.0
    public var segmentBarWidth: CGFloat = UIScreen.main.bounds.width
    public var segmentBarHeight: CGFloat = 46.0
    public var lineToBottomMargin: CGFloat = 12.0
    public var titleLabelFont = UIFont(name: "PingFangSC-Semibold", size: 14)
    public var buttonNormalColor: UIColor = UIColor.init(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1)
    public var buttonHighLightColor: UIColor = UIColor.init(red: 57 / 255.0, green: 116 / 255.0, blue: 255 / 255.0, alpha: 1)
    public var selectLineColor: UIColor = UIColor.init(red: 57 / 255.0, green: 116 / 255.0, blue: 255 / 255.0, alpha: 1)
    public var selectedBottomLineWidth: CGFloat = 9
    public var selectedBottomLineHeight: CGFloat = 2
    public var isSelectedBottomLineRoundCorner: Bool = false
    
    lazy var dataSource = [(menu: String, content: UIViewController)]()
    
    public var arrayTitle : Array<String> = []
    
    public var isShowShadow : Bool = true
    
    public weak var customSuperView: UIView?
    public var superView: UIView {
        get {
            if let aView = customSuperView {
                return aView
            } else {
                return view
            }
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if let aView = customSuperView {
            view.addSubview(aView)
        }
        self.dataSource = makeDataSource()
        createPageUI()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewControllerMain.view.frame = contentFrame()
    }
    
    
    open func makeDataSource() -> [(menu: String, content: UIViewController)] {
        let menu = ["", ""]
        return menu.map {
            let title = $0
            let vc = UIViewController()
            return (menu: title, content: vc)
        }
    }
    
    @objc open func contentFrame() -> CGRect {
        let bottomOffset: CGFloat = self.view.safeAreaInsets.bottom
        
        var contentRect: CGRect = .zero
        
        if let aView = customSuperView {
            let customRect = aView.frame
            contentRect = CGRect(x: customRect.minX, y: segmentBarHeight + 10, width: customRect.width, height: customRect.height - segmentBarHeight - 10)
        } else {
            contentRect = CGRect(x: 0, y: segmentBarHeight + 10, width: self.view.width, height: screenMainHeight - 64 - bottomOffset)
        }
        
        return contentRect
    }

    func createPageUI() {
        
        pageViewControllerMain.delegate = self
        pageViewControllerMain.dataSource = self
        addChild(pageViewControllerMain)
        superView.addSubview(pageViewControllerMain.view)
        pageViewControllerMain.didMove(toParent: self)
        
        for item in dataSource {
            let vc = item.content
            dataSouceControll.append(vc)
            arrayTitle.append(item.menu)
        }
       
        view.gestureRecognizers = pageViewControllerMain.gestureRecognizers
        
        setupSegmentBar()
        self.updateButtonNormalColor(color: buttonNormalColor)
        self.updateButtonHighLightColor(color: buttonHighLightColor)
        self.updateSelectLineColor(color: selectLineColor)
        if isShowShadow {
            self.addShadow()
        }
    }
    
    open func addSegmentBarView() {
        superView.addSubview(scrollView)
    }
    
    func setupSegmentBar() {
        scrollView.frame = CGRect(x: segmentBarOriginX, y: 0, width: segmentBarWidth, height: segmentBarHeight)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSegmentBarView()
        scrollView.contentSize = CGSize(width: segmentBarWidth, height: segmentBarHeight)
        
        ///设置滚动标题
        for i in 0..<self.dataSouceControll.count {
            let button = UIButton()
            button.frame = CGRect(x: 0.0 + segmentBarWidth/CGFloat(self.dataSouceControll.count) * CGFloat(i), y: 0, width: segmentBarWidth/CGFloat(self.dataSouceControll.count), height: segmentBarHeight)
            button.setTitle(self.arrayTitle[i], for: .normal)
            button.titleLabel?.font = titleLabelFont
            button.tag = i+1
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.addTarget(self, action: #selector(ActionButton), for: .touchUpInside)
            button.center.y = scrollView.center.y
            scrollView.addSubview(button)
            
            ///标题下划线
            let imageLine = UIImageView()
            imageLine.frame = CGRect(x: 0.0 + segmentBarWidth/CGFloat(self.dataSouceControll.count) * CGFloat(i), y: button.frame.height - lineToBottomMargin, width: selectedBottomLineWidth, height: selectedBottomLineHeight)
            if isSelectedBottomLineRoundCorner {
                imageLine.layer.masksToBounds = true
                imageLine.layer.cornerRadius = selectedBottomLineHeight/2
            }
            imageLine.tag = i+100
            imageLine.isHidden = true
            imageLine.center.x = button.center.x
            scrollView.addSubview(imageLine)
        }
    }
    
    public func relayoutSegmentBar() {
        scrollView.removeSubviews()
        setupSegmentBar()
        self.updateButtonNormalColor(color: buttonNormalColor)
        self.updateButtonHighLightColor(color: buttonHighLightColor)
        self.updateSelectLineColor(color: selectLineColor)
        self.slideToPage(index: currentIndex)
    }
    
    private func addShadow() {
        scrollView.layer.shadowColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        scrollView.layer.shadowOffset  = CGSize(width: 0, height: 2)
        scrollView.layer.shadowRadius  = 7
        scrollView.layer.masksToBounds = false
        scrollView.layer.shadowOpacity = 0.06
        scrollView.backgroundColor = UIColor.white
        let shadowSize = scrollView.layer.shadowRadius;
        let shadowRect = CGRect.init(x: -shadowSize, y: scrollView.bounds.size.height - shadowSize, width: scrollView.bounds.size.width + shadowSize, height: shadowSize)
        scrollView.layer.shadowPath = UIBezierPath.init(rect: shadowRect).cgPath
    }
    
    @objc public func slideToPage(index: Int) {
        var tmpIndex = index
        if (tmpIndex > dataSouceControll.count) {
            tmpIndex = dataSouceControll.count - 1
        }
        if (tmpIndex < 0) {
            tmpIndex = 0
        }
    
        pageViewControllerMain.setViewControllers([dataSouceControll[tmpIndex]], direction:.forward, animated: false, completion: nil)
        self.updateSelectBtn(index: index)
    }
    
    @objc public func ActionButton(button:UIButton) {
        self.slideToPage(index:button.tag-1)
    }
    
    
    private func updateButtonHighLightColor(color: UIColor) {
        for i in 0..<self.dataSouceControll.count {
            let button = scrollView.viewWithTag(i + 1) as? UIButton
            button?.setTitleColor(color, for: .selected)
        }
    }
    
    private func updateButtonNormalColor(color: UIColor) {
        for i in 0..<self.dataSouceControll.count {
            let button = scrollView.viewWithTag(i + 1) as? UIButton
            button?.setTitleColor(color, for: .normal)
        }
    }
    
    private func updateSelectLineColor(color: UIColor) {
        for i in 0..<self.dataSouceControll.count {
            let imageLine = scrollView.viewWithTag(i + 100) as? UIImageView
            imageLine?.backgroundColor = color
        }
    }
    
    @objc open func updateSelectBtn(index: Int) {
        currentIndex = index
        for i in 0..<self.dataSouceControll.count {
            let buttonAll = scrollView.viewWithTag(i + 1) as? UIButton
            let imageLine = scrollView.viewWithTag(i + 100) as? UIImageView
            if i == index {
                buttonAll?.isSelected = true
                imageLine?.isHidden = false
            }else{
                buttonAll?.isSelected = false
                imageLine?.isHidden = true
            }
        }
    }
}

extension STSegmentPageController: UIPageViewControllerDataSource {
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.dataSouceControll.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let controller = pendingViewControllers[0]
        self.nextIndex = self.dataSouceControll.firstIndex(of: controller)!
    }
}

extension STSegmentPageController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = self.dataSouceControll.firstIndex(of: viewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        guard let index1 = index else {
            return nil
        }
        return dataSouceControll[index1 - 1]
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.dataSouceControll.firstIndex(of: viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        if (index == self.dataSouceControll.count - 1) {
            return nil
        }
        
        guard let index1 = index else {
            return nil
        }
        
        return dataSouceControll[index1+1]
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.updateSelectBtn(index: self.nextIndex)
        }
    }

}
