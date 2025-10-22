//
//  WNScreen.swift
//  newDev
//
//  Created by wayne on 2020/5/15.abc_
//

import UIKit

public func KeyWindow() -> UIWindow? {
    if #available(iOS 15.0, *) {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    } else {
        return UIApplication.shared.windows.first
    }
}

public var WNScreenBounds: CGRect { WNScreen.screenBounds }
public var WNScreenWidth: CGFloat { WNScreen.screenWidth }
public var WNScreenHeight: CGFloat { WNScreen.screenHeight }
public var WNSafeAreaInsets: UIEdgeInsets { WNScreen.safeAreaInsets }
public var WNSafeTop: CGFloat { WNScreen.safeTop }
public var WNSafeBottom: CGFloat { WNScreen.safeBottom }
public var WNSafeStatusBarHeight: CGFloat { WNScreen.safeStatusBarHeight }
public var WNSafeNavigationHeight: CGFloat { WNScreen.safeNavigationHeight }
public var WNSafeTabBarHeight: CGFloat { WNScreen.safeTabBarHeight }
public var WNIsSmallScreen: Bool { WNScreen.isSmallScreen }
public var WNIsIPad: Bool { WNScreen.isIPad }
public var WNIsIPhoneX: Bool { WNScreen.isPhoneX }
public var WNIsSafeAreaInsetsScreen: Bool { WNScreen.isSafeAreaInsetsScreen }
public var WNIsIPhonePlus: Bool { WNScreen.isIPhonePlus }
public var WNIsIPhoneProMax: Bool { WNScreen.isIPhoneProMax }
public var WNHasDynamicIsland: Bool { WNScreen.hasDynamicIsland }

/// 获取当前设备的屏幕类型
public var WNCurrentScreenType: WNScreenType { WNScreen.screenType }

/// 兼容性保留：旧版 iPhone5 检测（实际检测所有小屏设备）
@available(*, deprecated, message: "请使用 WNIsSmallScreen 替代")
public var WNIsIPhone5: Bool { WNScreen.isSmallScreen }

public func WNFrameSize1(_ iPad: CGFloat, _ iPhone: CGFloat) -> CGFloat { 
    WNIsIPad ? iPad : iPhone 
}

public func WNFrameSize2(_ iPad: CGFloat, _ iPhoneStandard: CGFloat, _ iPhoneSmall: CGFloat) -> CGFloat { 
    WNIsIPad ? iPad : (WNIsSmallScreen ? iPhoneSmall : iPhoneStandard) 
}

public func WNFrameSize3(_ iPad: CGFloat, _ iPhoneProMax: CGFloat, _ iPhoneStandard: CGFloat, _ iPhoneSmall: CGFloat) -> CGFloat {
    if WNIsIPad {
        return iPad
    }
    if WNIsIPhoneProMax {
        return iPhoneProMax
    }
    if WNIsSmallScreen {
        return iPhoneSmall
    }
    return iPhoneStandard
}

/// 根据设备类型返回对应的尺寸
public func WNFrameSizeByType(iPad: CGFloat, iPhoneProMax: CGFloat, iPhonePlus: CGFloat, iPhoneStandard: CGFloat, iPhoneSmall: CGFloat) -> CGFloat {
    switch WNCurrentScreenType {
    case .iPad:
        return iPad
    case .iPhoneProMax:
        return iPhoneProMax
    case .iPhonePlus:
        return iPhonePlus
    case .iPhoneStandard:
        return iPhoneStandard
    case .iPhoneSmall:
        return iPhoneSmall
    }
}

/// 屏幕类型枚举，覆盖所有 iPhone 和 iPad 型号
public enum WNScreenType: CaseIterable {
    case iPhoneSmall      // SE系列, Mini 等小屏设备 (width <= 375)
    case iPhoneStandard   // 标准尺寸 iPhone (width 390-393)
    case iPhonePlus       // Plus 系列 (width 414)
    case iPhoneProMax     // Pro Max 系列 (width >= 428)
    case iPad             // 所有 iPad 设备
    
    /// 兼容旧版本的屏幕宽度
    public var baseWidth: CGFloat {
        switch self {
        case .iPhoneSmall:
            return 375.0
        case .iPhoneStandard:
            return 390.0
        case .iPhonePlus:
            return 414.0
        case .iPhoneProMax:
            return 430.0
        case .iPad:
            return 768.0
        }
    }
}

@objc public class WNScreen: NSObject {
    
    public static let shared = WNScreen()
    
    var safeTop: CGFloat = 0
    var safeBottom: CGFloat = 0
    var safeAreaInsets: UIEdgeInsets = .zero
    
    private var _screenType: WNScreenType = .iPhoneStandard
    
    private var safeAreaObservation: NSKeyValueObservation?

    override public init() {
        super.init()
        self.updateSafeAreaInsets()
        self.updateScreenType()
        setupSafeAreaObservation()
    }
    
    /// 根据屏幕尺寸判断设备类型
    private func updateScreenType() {
        if WNScreen.isIPad {
            _screenType = .iPad
            return
        }
        
        let width = min(WNScreen.screenWidth, WNScreen.screenHeight)
        
        // 根据屏幕宽度判断设备类型
        // iPhone SE 1/2/3, iPhone 12/13 mini: 375
        // iPhone 12/13/14/15/16: 390
        // iPhone 14/15/16 Plus: 414 (新Plus系列)
        // iPhone 12/13/14/15/16 Pro Max: 428-430
        
        if width <= 375 {
            _screenType = .iPhoneSmall
        } else if width <= 393 {
            _screenType = .iPhoneStandard
        } else if width <= 414 {
            _screenType = .iPhonePlus
        } else {
            _screenType = .iPhoneProMax
        }
    }
    
    static var screenType: WNScreenType {
        shared._screenType
    }
    
    private func setupSafeAreaObservation() {
        safeAreaObservation = WNScreen.window?.observe(\.safeAreaInsets, options: [.new]) { [weak self] _, change in
            guard let self = self,
                  let newInsets = change.newValue,
                  self.safeAreaInsets != newInsets else { return }
            
            self.updateSafeAreaInsets()
        }
    }
    
    public func updateSafeAreaInsets() {
        let newTop = WNScreen.window?.safeAreaInsets.top ?? 0.0
        let newBottom = WNScreen.window?.safeAreaInsets.bottom ?? 0.0
        let newInsets = WNScreen.window?.safeAreaInsets ?? .zero
        
        safeTop = newTop
        safeBottom = newBottom
        safeAreaInsets = newInsets
        
        // 安全区域变化时重新判断屏幕类型
        updateScreenType()
    }
    
    deinit {
        safeAreaObservation?.invalidate()
    }
}

private extension WNScreen {
    var isPhoneX: Bool {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return false
        }
        return safeAreaInsets != .zero
    }
}

@objc public extension WNScreen {
    
    static var window: UIWindow? { KeyWindow() }
    
    static var screenBounds: CGRect { UIScreen.main.bounds }
    
    static var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    
    static var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    static let screenScale: CGFloat = UIScreen.main.scale
    
    static let navigationBarHeight: CGFloat = 44.0
    
    static let tabBarHeight: CGFloat = 49.0
    
    static var safeAreaInsets: UIEdgeInsets { shared.safeAreaInsets }
    
    static var safeTop: CGFloat { shared.safeTop }
    
    static var safeBottom: CGFloat { shared.safeBottom }
    
    /// 状态栏高度（动态获取）
    static var safeStatusBarHeight: CGFloat {
        if shared.safeTop > 0.0 {
            return shared.safeTop
        }
        // 默认值根据设备类型返回
        return isSafeAreaInsetsScreen ? 44.0 : 20.0
    }
    
    static var safeNavigationHeight: CGFloat { safeStatusBarHeight + navigationBarHeight }
    
    static var safeTabBarHeight: CGFloat { shared.safeBottom + tabBarHeight }
    
    /// 小屏设备检测（SE 系列、Mini 等，宽度 <= 375）
    static var isSmallScreen: Bool { 
        min(screenWidth, screenHeight) <= 375.0 
    }
    
    /// Plus 系列检测（宽度 414）
    static var isIPhonePlus: Bool {
        guard !isIPad else { return false }
        let width = min(screenWidth, screenHeight)
        return width > 393 && width <= 414
    }
    
    /// Pro Max 系列检测（宽度 >= 428）
    static var isIPhoneProMax: Bool {
        guard !isIPad else { return false }
        let width = min(screenWidth, screenHeight)
        return width > 414
    }
    
    static let isIPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    /// 判断是否为刘海屏/挖孔屏设备
    static var isPhoneX: Bool {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return false
        }
        return isSafeAreaInsetsScreen
    }
    
    /// 判断是否有安全区域（刘海屏、灵动岛等）
    static var isSafeAreaInsetsScreen: Bool {
        shared.safeAreaInsets != .zero
    }
    
    /// 检测是否有 Dynamic Island（灵动岛）
    /// iPhone 14 Pro/Pro Max 及之后的 Pro 系列
    static var hasDynamicIsland: Bool {
        // Dynamic Island 设备的特征：safeTop >= 59
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return false
        }
        return shared.safeTop >= 59.0
    }

}

