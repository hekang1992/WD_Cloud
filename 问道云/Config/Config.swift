//
//  Config.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit
import Lottie
import Toaster
import SAMKeychain
import TYAlertController
import RxSwift

let ROOT_VC = "ROOT_VC"

let RISK_VC = "RISK_VC"

let DILI_VC = "DILI_VC"

let SCREEN_WIDTH = UIScreen.main.bounds.size.width

let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

let SHOW_HOME_LAUNCH = "SHOW_HOME_LAUNCH"

/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
let kGtAppId = "GTCNT3ZJsDArVl4BIZsce2"

let kGtAppKey = "OQc1Yk8iat8wtPDhO0G2l6"

let kGtAppSecret = "YSziclPG4rAZZW87YkKfd3"

//高德地图key
let ATUO_MAP_KEY = "be5c7fd08d404c308286ca0ce04629d0"

extension Double {
    func pix() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

extension CGFloat {
    func pix() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

extension Int {
    func pix() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

//颜色
extension UIColor {
    convenience init?(cssStr: String) {
        let hexString = cssStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard hexString.hasPrefix("#") else {
            return nil
        }
        let hexCode = hexString.dropFirst()
        guard hexCode.count == 6, let rgbValue = UInt64(hexCode, radix: 16) else {
            return nil
        }
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func random() -> UIColor {
        return UIColor(red: randomNumber(),
                       green: randomNumber(),
                       blue: randomNumber(),
                       alpha: 1.0)
    }
    
    private class func randomNumber() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
}

extension UIView {
    
    func removeAllSubviews() {
        while let subview = self.subviews.first {
            subview.removeFromSuperview()
        }
    }
    
    func setTopCorners(radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
    }
}

//字体
extension UIFont {
    class func regularFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.pix(), weight: .regular)
    }
    
    class func mediumFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.pix(), weight: .medium)
    }
    
    class func boldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.pix(), weight: .bold)
    }
    
    class func semiboldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.pix(), weight: .semibold)
    }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let location = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let offset = CGPoint(
            x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let adjustedLocation = CGPoint(x: location.x - offset.x, y: location.y - offset.y)
        
        let index = layoutManager.characterIndex(for: adjustedLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(index, targetRange)
    }
}

//按钮图片和文字的位置
enum ButtonEdgeInsetsStyle {
    case top // image in top，label in bottom
    case left  // image in left，label in right
    case bottom  // image in bottom，label in top
    case right // image in right，label in left
}

extension UIButton {
    func layoutButtonEdgeInsets(style: ButtonEdgeInsetsStyle, space: CGFloat) {
        setNeedsLayout()
        layoutIfNeeded()
        var labelWidth: CGFloat = 0.0
        var labelHeight: CGFloat = 0.0
        var imageEdgeInset = UIEdgeInsets.zero
        var labelEdgeInset = UIEdgeInsets.zero
        let imageWith = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
        labelWidth = min(labelWidth, frame.width - space - imageWith!)
        labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        
        switch style {
        case .top:
            if ((self.titleLabel?.intrinsicContentSize.width ?? 0) + (imageWith ?? 0)) > frame.width {
                let imageOffsetX = (frame.width - imageWith!) / 2
                imageEdgeInset = UIEdgeInsets(top: -labelHeight - space / 2.0, left: imageOffsetX, bottom: 0, right: -imageOffsetX)
            } else {
                imageEdgeInset = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
            }
            labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith!, bottom: -imageHeight! - space / 2.0, right: 0)
        case .left:
            imageEdgeInset = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
            labelEdgeInset = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
        case .bottom:
            imageEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
            labelEdgeInset = UIEdgeInsets(top: -imageHeight! - space / 2.0, left: -imageWith!, bottom: 0, right: 0)
        case .right:
            imageEdgeInset = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith! - space / 2.0, bottom: 0, right: imageWith! + space / 2.0)
        }
        self.titleEdgeInsets = labelEdgeInset
        self.imageEdgeInsets = imageEdgeInset
    }
}

//图片拓展
extension UIImage {
    class func imageOfText(_ text: String,
                           size: (CGFloat, CGFloat),
                           bgColor: UIColor = .random(),
                           textColor: UIColor = .white,
                           cornerRadius: CGFloat = 5) -> UIImage? {
        // 过滤空""
        if text.isEmpty { return nil }
        // 取第一个字符
        let letter = (text as NSString).substring(to: 1)
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(sise, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if cornerRadius > 0 {
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        }
        // 设置填充颜色
        ctx.setFillColor(bgColor.cgColor)
        // 填充绘制
        ctx.fill(rect)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        
        let attr = [
            NSAttributedString.Key.foregroundColor : textColor,
            NSAttributedString.Key.font : UIFont.boldFontOfSize(size: minSide * 0.6),
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.kern: 0
        ] as [NSAttributedString.Key : Any]
        
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.attributedText = .init(string: letter, attributes: attr)
        textLabel.sizeToFit()
        let textW = textLabel.frame.width
        let textH = textLabel.frame.height
        textLabel.drawText(in: .init(x: minSide / 2 - textW / 2, y: minSide / 2 - textH / 2, width: textW, height: textH))
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    //创建二维码
    class func qrImageForString(qrString: String?, qrImage: UIImage? = nil) -> UIImage? {
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: .utf8, allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage
            
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            // 返回二维码image
            //let codeImage = UIImage(ciImage: colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5)))
            let codeImage = UIImage(ciImage: colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
            
            // 中间都会放想要表达意思的图片
            if let iconImage = qrImage {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width,
                                  height: codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
}

extension String {
    var removingEmojis: String {
        return self.filter { !$0.isEmoji }
    }
    
    var htmlToAttributedString: NSAttributedString? {
        do {
            let data = Data(self.utf8)
            return try NSAttributedString(data: data, options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)
        } catch {
            print("Error converting HTML to attributed string: \(error)")
            return nil
        }
    }
    
}

extension Character {
    var isEmoji: Bool {
        // 判断是否为表情符号
        return (0x1F600...0x1F64F).contains(self.unicodeScalars.first!.value) ||  // Emoticons
        (0x1F300...0x1F5FF).contains(self.unicodeScalars.first!.value) ||  // Misc Symbols and Pictographs
        (0x1F680...0x1F6FF).contains(self.unicodeScalars.first!.value) ||  // Transport and Map
        (0x2600...0x26FF).contains(self.unicodeScalars.first!.value) ||   // Misc symbols
        (0x2700...0x27BF).contains(self.unicodeScalars.first!.value)      // Dingbats
    }
}

// 定义一个类或扩展来封装振动反馈
class HapticFeedbackManager {
    
    // 通用的振动反馈方法
    static func triggerImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare()  // 可选：提前准备
        feedbackGenerator.impactOccurred()  // 触发振动
    }
    
    // 通知反馈（成功、错误、警告）
    static func triggerNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()  // 可选：提前准备
        feedbackGenerator.notificationOccurred(type)  // 触发振动
    }
    
    // 选择反馈（例如滚动选择器）
    static func triggerSelectionFeedback() {
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.prepare()  // 可选：提前准备
        feedbackGenerator.selectionChanged()  // 触发振动
    }
}

//获取导航栏高度
class StatusHeightManager {
    
    static var statusBarHeight: CGFloat {
        var height: CGFloat = 20.0;
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!!
            height = window.safeAreaInsets.top
        }
        return height
    }
    
    static var navigationBarHeight: CGFloat {
        var navBarHeight: CGFloat = 64.0;
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!!
            let safeTop = window.safeAreaInsets.top
            navBarHeight = safeTop > 0 ? (safeTop + 44) : 44
        }
        return navBarHeight
    }
    
    static var allHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
    
    static var safeAreaBottomHeight: CGFloat {
        var safeHeight: CGFloat = 0;
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!!
            safeHeight = window.safeAreaInsets.bottom
        }
        return safeHeight
    }
    
    static var tabBarHeight: CGFloat {
        return 49 + safeAreaBottomHeight
    }
}

//hud
class PlaHudView: UIView {
    
    lazy var hudView: LottieAnimationView = {
        let hudView = LottieAnimationView(name: "loading.json", bundle: Bundle.main)
        hudView.layer.cornerRadius = 12
        hudView.animationSpeed = 1.2
        hudView.loopMode = .loop
        hudView.play()
        hudView.backgroundColor = .white.withAlphaComponent(0.85)
        return hudView
    }()
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(grayView)
        grayView.addSubview(hudView)
        hudView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        grayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

class ViewHud {
    
    static let loadView = PlaHudView()
    
    static func hideLoadView() {
        DispatchQueue.main.async {
            loadView.removeFromSuperview()
        }
    }
    
    static func addLoadView() {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.windows.first {
                DispatchQueue.main.async {
                    loadView.frame = keyWindow.bounds
                    keyWindow.addSubview(loadView)
                }
            }
        }
    }
    
}

//showmessage
class ToastViewConfig {
    static func showToast(message: String) {
        ToastView.appearance().font = UIFont.boldSystemFont(ofSize: 20)
        let toast = Toast(text: message, duration: 1.0)
        if let window = UIApplication.shared.windows.first {
            let centerY = SCREEN_HEIGHT * 0.5
            ToastView.appearance().bottomOffsetPortrait = centerY
            ToastView.appearance().bottomOffsetLandscape = centerY
        }
        toast.show()
    }
}

class PushLoginConfig {
    static func popLogin(from viewController: UIViewController) {
        let loginVc = WDLoginViewController()
        let rootVc = WDNavigationController(rootViewController: loginVc)
        rootVc.modalPresentationStyle = .overFullScreen
        viewController.present(rootVc, animated: true, completion: nil)
    }
}

//电话号码*******
class PhoneNumberFormatter {
    static func formatPhoneNumber(phoneNumber: String) -> String {
        if phoneNumber.count == 11 {
            let start = phoneNumber.prefix(3)
            let end = phoneNumber.suffix(3)
            let masked = String(repeating: "*", count: phoneNumber.count - 6)
            return start + masked + end
        }
        return phoneNumber
    }
}

class PercentageConfig {
    static func formatToPercentage(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent // 设置为百分比样式
        // 检查小数部分是否为 0
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            formatter.minimumFractionDigits = 0 // 如果是整数，不显示小数部分
            formatter.maximumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 1 // 否则显示 1 位小数
            formatter.maximumFractionDigits = 1
        }
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(value * 100)%"
    }
}

//无数据页面
class LLemptyView: UIView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "wushujuimage")
        return bgImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.font = .regularFontOfSize(size: 15)
        mlabel.textColor = UIColor.init(cssStr: "#999999")
        mlabel.textAlignment = .center
        mlabel.text = "暂无相关数据"
        return mlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(bgImageView)
        addSubview(mlabel)
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.bottom.left.right.equalToSuperview()
        }
        bgImageView.snp.makeConstraints { make in
            make.left.equalTo((SCREEN_WIDTH - 163) * 0.5)
            make.top.equalToSuperview().offset(150)
            make.size.equalTo(CGSize(width: 163, height: 163))
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.top.equalTo(bgImageView.snp.bottom).offset(10)
            make.height.equalTo(21)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//无网络页面
class NoNetView: BaseView {
    
    var refreshBlock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "duanwangimge")
        return bgImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.font = .regularFontOfSize(size: 20)
        mlabel.textColor = UIColor.init(cssStr: "#666666")
        mlabel.textAlignment = .center
        mlabel.text = "加载失败"
        return mlabel
    }()
    
    lazy var refreshBtn: UIButton = {
        let refreshBtn = UIButton(type: .custom)
        refreshBtn.setImage(UIImage(named: "shuaxinimage"), for: .normal)
        refreshBtn.setTitle("点击刷新", for: .normal)
        refreshBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        refreshBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        return refreshBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(bgImageView)
        addSubview(mlabel)
        addSubview(refreshBtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(230)
            make.size.equalTo(CGSize(width: 110, height: 110))
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(10)
            make.height.equalTo(28)
        }
        refreshBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mlabel.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 88, height: 21))
        }
        refreshBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.refreshBlock?()
        }).disposed(by: disposeBag)
        refreshBtn.layoutButtonEdgeInsets(style: .left, space: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//获取当前控制器
extension UIViewController {
    class func getCurrentViewController() -> UIViewController {
        let rootVc = keyWindow?.rootViewController
        let currentVc = getCurrentViewController(rootVc!)
        return currentVc
    }
    
    class func getCurrentViewController(_ rootVc: UIViewController) -> UIViewController {
        var currentVc: UIViewController
        var rootCtr = rootVc
        if rootCtr.presentedViewController != nil {
            rootCtr = rootVc.presentedViewController!
        }
        if rootVc.isKind(of: UITabBarController.classForCoder()) {
            currentVc = getCurrentViewController((rootVc as! UITabBarController).selectedViewController!)
        } else if rootVc.isKind(of: UINavigationController.classForCoder()) {
            currentVc = getCurrentViewController((rootVc as! UINavigationController).visibleViewController!)
        } else {
            currentVc = rootCtr
        }
        return currentVc
    }
}

// 弹窗
class ShowAlertManager {
    
    /// 获取当前的视图控制器
    static func getTopViewController() -> UIViewController? {
        // 获取应用的所有窗口
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        
        // 获取最顶部的视图控制器
        var topController = windows.first?.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
    
    /// 通用的Alert封装方法
    /// - Parameters:
    ///   - title: 弹窗标题
    ///   - message: 弹窗内容
    ///   - confirmTitle: 确认按钮标题
    ///   - cancelTitle: 取消按钮标题（默认为nil，即没有取消按钮）
    ///   - confirmAction: 点击确认按钮的回调
    ///   - cancelAction: 点击取消按钮的回调（默认为nil）
    static func showAlert(title: String?,
                          message: String?,
                          confirmTitle: String = "确认",
                          cancelTitle: String? = "取消",
                          confirmAction: (() -> Void)? = nil,
                          cancelAction: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 添加确认按钮
        let confirmButton = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmAction?() // 点击确认按钮时执行的操作
        }
        alert.addAction(confirmButton)
        
        // 如果有取消按钮，则添加
        if let cancelTitle = cancelTitle {
            let cancelButton = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelAction?()
            }
            alert.addAction(cancelButton)
        }
        
        // 获取当前视图控制器并呈现提示框
        if let topController = getTopViewController() {
            topController.present(alert, animated: true, completion: nil)
        }
    }
}

//获取缓存方法
class GetCacheConfig {
    /// 获取缓存大小，单位为 MB
    static func getCacheSizeInMB() -> String {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        var totalSize: UInt64 = 0
        
        if let enumerator = FileManager.default.enumerator(at: cacheURL, includingPropertiesForKeys: [.totalFileAllocatedSizeKey], options: [], errorHandler: nil) {
            for case let fileURL as URL in enumerator {
                do {
                    let resourceValues = try fileURL.resourceValues(forKeys: [.totalFileAllocatedSizeKey])
                    if let fileSize = resourceValues.totalFileAllocatedSize {
                        totalSize += UInt64(fileSize)
                    }
                } catch {
                    print("Error getting file size: \(error)")
                }
            }
        }
        
        // 将字节转换为 MB
        let sizeInMB = Double(totalSize) / (1024 * 1024)
        return String(format: "%.2f MB", sizeInMB)
    }
    
    static func clearCache() {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil, options: [])
            for fileURL in contents {
                try FileManager.default.removeItem(at: fileURL)
            }
            print("Cache cleared successfully.")
        } catch {
            print("Error clearing cache: \(error)")
        }
    }
    
}

//密码验证
class PasswordConfig {
    static  func isPasswordValid(_ password: String) -> Bool {
        // 检查长度是否符合
        guard password.count >= 8 && password.count <= 20 else {
            return false
        }
        
        // 定义正则表达式模式
        let letterPattern = ".*[A-Za-z]+.*" // 至少一个字母
        let digitPattern = ".*[0-9]+.*"     // 至少一个数字
        let specialCharPattern = ".*[^A-Za-z0-9]+.*" // 至少一个特殊字符（不包括空格）
        
        // 创建正则表达式
        let letterRegex = try! NSRegularExpression(pattern: letterPattern)
        let digitRegex = try! NSRegularExpression(pattern: digitPattern)
        let specialCharRegex = try! NSRegularExpression(pattern: specialCharPattern)
        
        // 检查各类字符是否存在
        let hasLetter = letterRegex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.utf16.count)) != nil
        let hasDigit = digitRegex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.utf16.count)) != nil
        let hasSpecialChar = specialCharRegex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.utf16.count)) != nil
        
        // 至少两种类型组合
        let validCount = [hasLetter, hasDigit, hasSpecialChar].filter { $0 }.count
        return validCount >= 2
    }
    
}

//获取手机号码
class GetPhoneNumberManager {
    static func getPhoneNum() -> String {
        return UserDefaults.standard.object(forKey: WDY_PHONE) as? String ?? ""
    }
}

class PaddedLabel: UILabel {
    var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

//标签颜色
class TypeColorConfig {
    static func labelTextColor(form label: PaddedLabel) {
        let text = label.text ?? ""
        if text.contains("注销") {
            label.textColor = UIColor.init(cssStr: "#FF7D00")
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 2
            label.layer.borderColor = UIColor.init(cssStr: "#FF7D00")?.cgColor
        }else if text.contains("吊销") {
            label.textColor = UIColor.init(cssStr: "#F55B5B")
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 2
            label.layer.borderColor = UIColor.init(cssStr: "#F55B5B")?.cgColor
        }else {
            label.textColor = UIColor.init(cssStr: "#4DC929")
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 2
            label.layer.borderColor = UIColor.init(cssStr: "#4DC929")?.cgColor
        }
    }
}

//获取支付ID
class GetStoreIDManager {
    static func storeID(with comboNumber: Any) -> String {
        return "wdy.goods.\(comboNumber)"
    }
}

//数字滚动动画
class NumberAnimator {
    static func animateNumber(on label: UILabel, from startValue: Int, to endValue: Int, duration: TimeInterval) {
        let animationDuration = duration
        let stepCount = 100
        let stepDuration = animationDuration / Double(stepCount)
        DispatchQueue.global(qos: .userInteractive).async {
            for step in 0...stepCount {
                let progress = Double(step) / Double(stepCount)
                let newValue = Int(Double(startValue) + progress * Double(endValue - startValue))
                
                DispatchQueue.main.async {
                    label.text = "\(newValue)"
                }
                Thread.sleep(forTimeInterval: stepDuration)
            }
        }
    }
}

//倒计时30分钟
class CountdownTimer {
    
    typealias CountdownUpdate = (String) -> Void
    // 定义倒计时完成后的回调
    typealias CountdownCompletion = () -> Void
    
    private var timer: Timer?
    private var remainingTime: Int
    
    // 初始化方法
    init(startTime: String, durationInMinutes: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let startDate = dateFormatter.date(from: startTime) else {
            fatalError("无效的起始时间格式")
        }
        
        let targetDate = startDate.addingTimeInterval(TimeInterval(durationInMinutes * 60))
        let currentTime = Date()
        self.remainingTime = Int(targetDate.timeIntervalSince(currentTime))
    }
    
    // 开始倒计时
    func startCountdown(update: @escaping CountdownUpdate, completion: @escaping CountdownCompletion) {
        // 如果倒计时已经结束，不启动定时器
        if remainingTime <= 0 {
            update("00:00") // 倒计时已结束
            completion()
            return
        }
        
        // 启动每秒触发的定时器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {  timer in
            //            guard let self = self else { return }
            
            // 更新剩余时间
            self.remainingTime -= 1
            
            // 计算分钟和秒数
            let minutes = self.remainingTime / 60
            let seconds = self.remainingTime % 60
            
            // 格式化为 "mm:ss" 格式
            let timeString = String(format: "00:%02d:%02d", minutes, seconds)
            
            // 每秒更新一次显示
            update(timeString)
            
            // 如果倒计时结束，停止定时器并执行完成回调
            if self.remainingTime <= 0 {
                timer.invalidate()
                update("00:00") // 倒计时结束时显示 00:00
                completion() // 执行完成回调
            }
        }
    }
    
    // 停止倒计时
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
}

class NoCopyTextField: WLUnitField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // 如果是复制操作，直接返回false来禁止执行
        if action == #selector(UIResponder.copy(_:)) {
            return false
        }
        // 对于其他操作，继续执行默认行为
        return super.canPerformAction(action, withSender: sender)
    }
}

//获取IDFV
let WDY_ONE = "WDY_ONE"
let WDY_TWO = "WDY_TWO"
class GetIDFVConfig {
    static func getIDFV() -> String {
        if let uuid = SAMKeychain.password(forService: WDY_ONE, account: WDY_TWO), !uuid.isEmpty {
            return uuid
        }
        guard let deviceIDFV = UIDevice.current.identifierForVendor?.uuidString else {
            return ""
        }
        let isSuccess = SAMKeychain.setPassword(deviceIDFV, forService: WDY_ONE, account: WDY_TWO)
        return isSuccess ? deviceIDFV : ""
    }
    
}

//红色文字
class GetRedStrConfig: NSObject {
    
    static func getRedStr(from count: String?, fullText: String, colorStr: String? = "#F55B5B", font: UIFont? = UIFont.mediumFontOfSize(size: 15)) -> NSAttributedString {
        // 确保 count 有效，默认为 0
        let countValue = count ?? ""
        // 创建可变富文本字符串
        let attributedString = NSMutableAttributedString(string: fullText)
        // 查找 count 的范围
        if let range = fullText.range(of: "\(countValue)") {
            // 转换为 NSRange
            let nsRange = NSRange(range, in: fullText)
            // 设置指定范围内的文字颜色
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor(cssStr: colorStr ?? "") ?? UIColor.black,
                                          range: nsRange)
            attributedString.addAttribute(.font,
                                          value: font as Any,
                                          range: nsRange)
        }
        
        return attributedString
    }
    
}

class ViewControllerUtils {
    /// 通过当前视图获取所在的控制器
    static func findViewController(from view: UIView) -> WDBaseViewController? {
        var responder: UIResponder? = view
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? WDBaseViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    /// 通过当前视图获取导航控制器
    static func findNavigationController(from view: UIView) -> UINavigationController? {
        guard let viewController = findViewController(from: view) else {
            return nil
        }
        return viewController.navigationController
    }
    
    /// 通过当前视图 Push 到新的控制器
    static func pushViewController(from view: UIView, to targetViewController: UIViewController, animated: Bool = true) {
        guard let navigationController = findNavigationController(from: view) else {
            print("Current view is not embedded in a navigation controller")
            return
        }
        navigationController.pushViewController(targetViewController, animated: animated)
    }
}

class TagsLabelColorConfig {
    
    static func nameLabelColor(from tagView: UILabel) {
        let currentTitle = tagView.text ?? ""
        if currentTitle.contains("经营异常") || currentTitle.contains("被执行人") || currentTitle.contains("失信被执行人") || currentTitle.contains("限制高消费") || currentTitle.contains("票据违约") || currentTitle.contains("债券违约") {
            tagView.backgroundColor = .init(cssStr: "#F55B5B")?.withAlphaComponent(0.1)
            tagView.textColor = .init(cssStr: "#F55B5B")
            tagView.layer.borderColor = UIColor.clear.cgColor
        }else if currentTitle.contains("存续") {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#4DC929")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("注销") {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#FF7D00")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("吊销")  {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#F55B5B")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("小微企业") || currentTitle.contains("高新技术企业") || currentTitle.contains("国有控股") || currentTitle.contains("国有独资") || currentTitle.contains("国有全资") || currentTitle.contains("深主板") || currentTitle.contains("沪主板") || currentTitle.contains("港交所") || currentTitle.contains("北交所") || currentTitle.contains("发债"){
            tagView.backgroundColor = .init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
            tagView.textColor = .init(cssStr: "#547AFF")
            tagView.layer.borderColor = UIColor.clear.cgColor
        } else {
            tagView.backgroundColor = .init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
            tagView.textColor = .init(cssStr: "#547AFF")
            tagView.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
}

class ShowAgainLoginConfig {
    
    static let disposeBag = DisposeBag()
    
    static func againLoginView() {
        let againLoginView = PopAgainLoginView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 300))
        let alertVc = TYAlertController(alert: againLoginView, preferredStyle: .alert)!
        let vc = ShowAlertManager.getTopViewController()
        vc?.present(alertVc, animated: true)
        
        againLoginView.cancelBtn.rx.tap.subscribe(onNext: {
            vc?.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
            })
        }).disposed(by: disposeBag)
        
        againLoginView.sureBtn.rx.tap.subscribe(onNext: {
            vc?.dismiss(animated: true, completion: {
                let loginVc = WDLoginViewController()
                let rootVc = WDNavigationController(rootViewController: loginVc)
                rootVc.modalPresentationStyle = .overFullScreen
                vc?.present(rootVc, animated: true)
                WDLoginConfig.removeLoginInfo()
                loginVc.loginView.backBtn.rx.tap.subscribe(onNext: {
                    loginVc.loginView.phoneTx.resignFirstResponder()
                    NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                }).disposed(by: disposeBag)
            })
        }).disposed(by: disposeBag)
        
    }
    
}

final class URLQueryAppender {
    static func appendQueryParameters(to url: String, parameters: [String: String]) -> String? {
        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url?.absoluteString
    }
}
