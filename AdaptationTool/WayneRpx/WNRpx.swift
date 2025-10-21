//
//  WNRpx.swift
//
//  Created by wayne on 2020/5/20



public typealias WNRpx = WNResponsiveLayout

@objc public class WNResponsiveLayout: NSObject {
    private override init() {
        // do nothing
    }
    private static let shared = WNResponsiveLayout.init()

    @objc var scale: CGFloat {
        UIScreen.main.scale
    }
    
    private var _samWNeWidth: CGFloat = 375.0
    private lazy var _ratio: CGFloat = UIScreen.main.bounds.size.width / _samWNeWidth
    
    /// 视觉稿的 samWNe 宽度, default is 375
    @objc public static var samWNeWith: CGFloat {
        get { WNResponsiveLayout.shared._samWNeWidth }
        set {
            WNResponsiveLayout.shared._samWNeWidth = newValue
            WNResponsiveLayout.shared._ratio = UIScreen.main.bounds.size.width / WNResponsiveLayout.shared._samWNeWidth
        }
    }
    
    /// iPad zoom scale.abc_ default is 1.5
    @objc public static var iPadZoomScale: CGFloat = 1.5
    
    /// default means width ratio
    @objc static public var ratio: CGFloat {
        get { WNResponsiveLayout.shared._ratio }
    }
    
    /// 设置全局禁用 Rpx, 默认不禁用。
    /// 以下情况会忽略全局禁用设置：
    /// - 手动指定单个 rpx 的可用屏幕类型值。如：`10.rpx(iPad: 20)`
    /// - 手动指定单个 rpx 的可用屏幕类型。如：`10.rpx([.iPad])`
    public static var isGlobalEnabled: Bool = true
    
    /// 设置全局禁用 Rpx 的屏幕类型
    /// - Parameter types: 需要禁用 rpx 的屏幕类型集合
    /// 以下情况会忽略该设置：
    /// - 手动指定单个 rpx 的可用屏幕类型值。如：`10.rpx(iPad: 20)`
    /// - 手动指定单个 rpx 的可用屏幕类型。如：`10.rpx([.iPad])`
    public static func setGlobalDisabledTypes(_ types: Set<WNScreenType>) {
        WNResponsiveLayout.isGlobalEnabled = !types.contains(WNScreen.screenType)
    }
    
    
    // MARK: - Calculate
    /// 计算 rpx 值（带屏幕类型控制）
    /// - Parameters:
    ///   - value: 原始值
    ///   - manualEnableTypes: 手动指定生效的屏幕类型集合
    /// - Returns: 计算后的值
    ///   - 当 manualEnableTypes 包含当前屏幕类型或全局启用时，返回计算后的值
    ///   - 否则返回原始值
    static func calculateDefault(_ value: CGFloat, manualEnableTypes: Set<WNScreenType>) -> CGFloat {
        let enable = WNResponsiveLayout.isGlobalEnabled || manualEnableTypes.contains(WNScreen.screenType)
        guard enable else {
            return value
        }
        return calculate(value, iPad: roundToNearestZeroOrFive(value * WNResponsiveLayout.iPadZoomScale), enable: enable)
    }
    
    /// 计算 rpx 值（带设备特定值）
    /// - Parameters:
    ///   - value: 原始值
    ///   - iPad: iPad 设备上的特定值，如果为 nil 则使用计算值
    ///   - proMax: iPhone Pro Max 设备上的特定值，如果为 nil 则使用计算值
    ///   - plus: iPhone Plus 设备上的特定值，如果为 nil 则使用计算值
    ///   - standard: 标准尺寸 iPhone 设备上的特定值，如果为 nil 则使用计算值
    ///   - small: 小屏设备上的特定值，如果为 nil 则使用计算值
    ///   - iPhone5: 兼容旧版，等同于 small 参数
    ///   - enable: 是否启用 rpx 计算，默认跟随全局设置
    /// - Returns: 计算后的值
    static func calculate(
        _ value: CGFloat,
        iPad: CGFloat? = nil,
        proMax: CGFloat? = nil,
        plus: CGFloat? = nil,
        standard: CGFloat? = nil,
        small: CGFloat? = nil,
        iPhone5: CGFloat? = nil,
        enable: Bool = WNResponsiveLayout.isGlobalEnabled
    ) -> CGFloat {
        // 根据当前设备类型返回对应的特定值
        switch WNScreen.screenType {
        case .iPad:
            if let iPad = iPad {
                return roundToNearestZeroOrFive(iPad)
            }
        case .iPhoneProMax:
            if let proMax = proMax {
                return roundToNearestZeroOrFive(proMax)
            }
        case .iPhonePlus:
            if let plus = plus {
                return roundToNearestZeroOrFive(plus)
            }
        case .iPhoneStandard:
            if let standard = standard {
                return roundToNearestZeroOrFive(standard)
            }
        case .iPhoneSmall:
            // 优先使用 small，如果没有则使用 iPhone5（兼容旧代码）
            if let small = small ?? iPhone5 {
                return roundToNearestZeroOrFive(small)
            }
        }
        
        guard enable else {
            return value
        }
        return roundToNearestZeroOrFive(value * ratio)
    }

    public static func roundToNearestZeroOrFive(_ number: CGFloat) -> CGFloat {
        let integerPart = floor(number)
        let decimalPart = number - integerPart
        let roundedDecimal: Double
        if decimalPart < 0.25 {
            roundedDecimal = 0.0
        } else if decimalPart < 0.75 {
            roundedDecimal = 0.5
        } else {
            roundedDecimal = 1.0
        }
        let roundedNumber = integerPart + roundedDecimal
        return roundedNumber
    }
}

// MARK: - CGFloat Extension
public extension CGFloat {
    /// 对当前数值进行 rpx 计算
    /// 使用全局设置判断是否启用自适应
    var rpx: CGFloat {
        return WNResponsiveLayout.calculateDefault(self, manualEnableTypes: [])
    }
    
    /// 对当前数值进行 rpx 计算，仅在指定的屏幕类型下生效
    /// - Parameter enabledTypes: 启用 rpx 的屏幕类型集合
    /// - Returns: 在指定屏幕类型下计算的 rpx 值，其他类型返回原始值
    func rpx(_ enabledTypes: Set<WNScreenType>) -> CGFloat {
        return WNResponsiveLayout.calculateDefault(self, manualEnableTypes: enabledTypes)
    }
    
    /// 对当前数值进行 rpx 计算，在 iPad 上使用特定值
    /// - Parameter iPad: iPad 上使用的特定值
    /// - Returns: 在 iPad 上返回指定值，其他设备返回 rpx 计算值
    func rpx(iPad: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(self, iPad: iPad)
    }
    
    /// 对当前数值进行 rpx 计算，在 Pro Max 设备上使用特定值
    /// - Parameter proMax: Pro Max 上使用的特定值
    /// - Returns: 在 Pro Max 上返回指定值，其他设备返回 rpx 计算值
    func rpx(proMax: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(self, proMax: proMax)
    }
    
    /// 对当前数值进行 rpx 计算，在 Plus 设备上使用特定值
    /// - Parameter plus: Plus 上使用的特定值
    /// - Returns: 在 Plus 上返回指定值，其他设备返回 rpx 计算值
    func rpx(plus: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(self, plus: plus)
    }
    
    /// 对当前数值进行 rpx 计算，在小屏设备上使用特定值
    /// - Parameter small: 小屏设备上使用的特定值
    /// - Returns: 在小屏设备上返回指定值，其他设备返回 rpx 计算值
    func rpx(small: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(self, small: small)
    }
    
    /// 兼容旧版：对当前数值进行 rpx 计算，在小屏设备上使用特定值
    /// - Parameter iPhone5: 小屏设备上使用的特定值（实际用于所有小屏设备）
    /// - Returns: 在小屏设备上返回指定值，其他设备返回 rpx 计算值
    @available(*, deprecated, renamed: "rpx(small:)", message: "请使用 rpx(small:) 替代")
    func rpx(iPhone5: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(self, iPhone5: iPhone5)
    }
    
    /// 对当前数值进行 rpx 计算，为不同设备类型指定不同值
    /// - Parameters:
    ///   - iPad: iPad 上使用的特定值（可选）
    ///   - proMax: Pro Max 上使用的特定值（可选）
    ///   - plus: Plus 上使用的特定值（可选）
    ///   - standard: 标准尺寸上使用的特定值（可选）
    ///   - small: 小屏设备上使用的特定值（可选）
    /// - Returns: 在对应设备上返回指定值，未指定的设备返回 rpx 计算值
    func rpx(iPad: CGFloat? = nil, proMax: CGFloat? = nil, plus: CGFloat? = nil, standard: CGFloat? = nil, small: CGFloat? = nil) -> CGFloat {
        return WNResponsiveLayout.calculate(self, iPad: iPad, proMax: proMax, plus: plus, standard: standard, small: small)
    }
    
    /// 兼容旧版：对当前数值进行 rpx 计算，在 iPad 和小屏设备上使用特定值
    /// - Parameters:
    ///   - iPad: iPad 上使用的特定值
    ///   - iPhone5: 小屏设备上使用的特定值
    /// - Returns: 在对应设备上返回指定值，其他设备返回 rpx 计算值
    @available(*, deprecated, message: "请使用 rpx(iPad:small:) 替代")
    func rpx(iPad: CGFloat, iPhone5: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(self, iPad: iPad, iPhone5: iPhone5)
    }
}

// MARK: - Int Extension
public extension Int {
    /// 对当前数值进行 rpx 计算
    /// 使用全局设置判断是否启用自适应
    /// - Returns: 计算后的 CGFloat 值
    var rpx: CGFloat {
        return WNResponsiveLayout.calculateDefault(CGFloat(self), manualEnableTypes: [])
    }
    
    /// 对当前数值进行 rpx 计算，仅在指定的屏幕类型下生效
    /// - Parameter enabledTypes: 启用 rpx 的屏幕类型集合
    /// - Returns: 在指定屏幕类型下计算的 rpx 值，其他类型返回原始值转换为 CGFloat
    func rpx(_ enabledTypes: Set<WNScreenType>) -> CGFloat {
        return WNResponsiveLayout.calculateDefault(CGFloat(self), manualEnableTypes: enabledTypes)
    }
    
    /// 对当前数值进行 rpx 计算，在 iPad 上使用特定值
    /// - Parameter iPad: iPad 上使用的特定值
    /// - Returns: 在 iPad 上返回指定值，其他设备返回 rpx 计算值
    func rpx(iPad: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), iPad: iPad)
    }
    
    /// 对当前数值进行 rpx 计算，在 Pro Max 设备上使用特定值
    /// - Parameter proMax: Pro Max 上使用的特定值
    /// - Returns: 在 Pro Max 上返回指定值，其他设备返回 rpx 计算值
    func rpx(proMax: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), proMax: proMax)
    }
    
    /// 对当前数值进行 rpx 计算，在 Plus 设备上使用特定值
    /// - Parameter plus: Plus 上使用的特定值
    /// - Returns: 在 Plus 上返回指定值，其他设备返回 rpx 计算值
    func rpx(plus: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), plus: plus)
    }
    
    /// 对当前数值进行 rpx 计算，在小屏设备上使用特定值
    /// - Parameter small: 小屏设备上使用的特定值
    /// - Returns: 在小屏设备上返回指定值，其他设备返回 rpx 计算值
    func rpx(small: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), small: small)
    }
    
    /// 兼容旧版：对当前数值进行 rpx 计算，在小屏设备上使用特定值
    /// - Parameter iPhone5: 小屏设备上使用的特定值
    /// - Returns: 在小屏设备上返回指定值，其他设备返回 rpx 计算值
    @available(*, deprecated, renamed: "rpx(small:)", message: "请使用 rpx(small:) 替代")
    func rpx(iPhone5: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), iPhone5: iPhone5)
    }
    
    /// 对当前数值进行 rpx 计算，为不同设备类型指定不同值
    /// - Parameters:
    ///   - iPad: iPad 上使用的特定值（可选）
    ///   - proMax: Pro Max 上使用的特定值（可选）
    ///   - plus: Plus 上使用的特定值（可选）
    ///   - standard: 标准尺寸上使用的特定值（可选）
    ///   - small: 小屏设备上使用的特定值（可选）
    /// - Returns: 在对应设备上返回指定值，未指定的设备返回 rpx 计算值
    func rpx(iPad: CGFloat? = nil, proMax: CGFloat? = nil, plus: CGFloat? = nil, standard: CGFloat? = nil, small: CGFloat? = nil) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), iPad: iPad, proMax: proMax, plus: plus, standard: standard, small: small)
    }
    
    /// 兼容旧版：对当前数值进行 rpx 计算，在 iPad 和小屏设备上使用特定值
    /// - Parameters:
    ///   - iPad: iPad 上使用的特定值
    ///   - iPhone5: 小屏设备上使用的特定值
    /// - Returns: 在对应设备上返回指定值，其他设备返回 rpx 计算值
    @available(*, deprecated, message: "请使用 rpx(iPad:small:) 替代")
    func rpx(iPad: CGFloat, iPhone5: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), iPad: iPad, iPhone5: iPhone5)
    }
}

// MARK: - Double Extension
public extension Double {
    /// 对当前数值进行 rpx 计算
    /// 使用全局设置判断是否启用自适应
    /// - Returns: 计算后的 CGFloat 值
    var rpx: CGFloat {
        return WNResponsiveLayout.calculateDefault(CGFloat(self), manualEnableTypes: [])
    }
    
    /// 对当前数值进行 rpx 计算，仅在指定的屏幕类型下生效
    /// - Parameter enabledTypes: 启用 rpx 的屏幕类型集合
    /// - Returns: 在指定屏幕类型下计算的 rpx 值，其他类型返回原始值转换为 CGFloat
    func rpx(_ enabledTypes: Set<WNScreenType>) -> CGFloat {
        return WNResponsiveLayout.calculateDefault(CGFloat(self), manualEnableTypes: enabledTypes)
    }
    
    /// 对当前数值进行 rpx 计算，在 iPad 上使用特定值
    /// - Parameter iPad: iPad 上使用的特定值
    /// - Returns: 在 iPad 上返回指定值，其他设备返回 rpx 计算值
    func rpx(iPad: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), iPad: iPad)
    }
    
    /// 对当前数值进行 rpx 计算，在 Pro Max 设备上使用特定值
    /// - Parameter proMax: Pro Max 上使用的特定值
    /// - Returns: 在 Pro Max 上返回指定值，其他设备返回 rpx 计算值
    func rpx(proMax: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), proMax: proMax)
    }
    
    /// 对当前数值进行 rpx 计算，在 Plus 设备上使用特定值
    /// - Parameter plus: Plus 上使用的特定值
    /// - Returns: 在 Plus 上返回指定值，其他设备返回 rpx 计算值
    func rpx(plus: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), plus: plus)
    }
    
    /// 对当前数值进行 rpx 计算，在小屏设备上使用特定值
    /// - Parameter small: 小屏设备上使用的特定值
    /// - Returns: 在小屏设备上返回指定值，其他设备返回 rpx 计算值
    func rpx(small: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), small: small)
    }
    
    /// 兼容旧版：对当前数值进行 rpx 计算，在小屏设备上使用特定值
    /// - Parameter iPhone5: 小屏设备上使用的特定值
    /// - Returns: 在小屏设备上返回指定值，其他设备返回 rpx 计算值
    @available(*, deprecated, renamed: "rpx(small:)", message: "请使用 rpx(small:) 替代")
    func rpx(iPhone5: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), iPhone5: iPhone5)
    }
    
    /// 对当前数值进行 rpx 计算，为不同设备类型指定不同值
    /// - Parameters:
    ///   - iPad: iPad 上使用的特定值（可选）
    ///   - proMax: Pro Max 上使用的特定值（可选）
    ///   - plus: Plus 上使用的特定值（可选）
    ///   - standard: 标准尺寸上使用的特定值（可选）
    ///   - small: 小屏设备上使用的特定值（可选）
    /// - Returns: 在对应设备上返回指定值，未指定的设备返回 rpx 计算值
    func rpx(iPad: CGFloat? = nil, proMax: CGFloat? = nil, plus: CGFloat? = nil, standard: CGFloat? = nil, small: CGFloat? = nil) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), iPad: iPad, proMax: proMax, plus: plus, standard: standard, small: small)
    }
    
    /// 兼容旧版：对当前数值进行 rpx 计算，在 iPad 和小屏设备上使用特定值
    /// - Parameters:
    ///   - iPad: iPad 上使用的特定值
    ///   - iPhone5: 小屏设备上使用的特定值
    /// - Returns: 在对应设备上返回指定值，其他设备返回 rpx 计算值
    @available(*, deprecated, message: "请使用 rpx(iPad:small:) 替代")
    func rpx(iPad: CGFloat, iPhone5: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(self), iPad: iPad, iPhone5: iPhone5)
    }
}

// MARK: - NSNumber Extension
@objc public extension NSNumber {
    /// 对当前数值进行 rpx 计算
    /// 使用全局设置判断是否启用自适应
    /// 主要用于 Objective-C 调用
    /// - Returns: 计算后的 CGFloat 值
    @objc var rpx: CGFloat {
        return WNResponsiveLayout.calculateDefault(CGFloat(doubleValue), manualEnableTypes: [])
    }
    
    /// 对当前数值进行 rpx 计算，在 iPad 上使用特定值
    /// - Parameter iPad: iPad 上使用的特定值
    /// - Returns: 在 iPad 上返回指定值，其他设备返回 rpx 计算值
    @objc func rpx(iPad: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(doubleValue), iPad: iPad)
    }
    
    /// 对当前数值进行 rpx 计算，在 Pro Max 设备上使用特定值
    /// - Parameter proMax: Pro Max 上使用的特定值
    /// - Returns: 在 Pro Max 上返回指定值，其他设备返回 rpx 计算值
    @objc func rpx(proMax: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(doubleValue), proMax: proMax)
    }
    
    /// 对当前数值进行 rpx 计算，在 Plus 设备上使用特定值
    /// - Parameter plus: Plus 上使用的特定值
    /// - Returns: 在 Plus 上返回指定值，其他设备返回 rpx 计算值
    @objc func rpx(plus: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(doubleValue), plus: plus)
    }
    
    /// 对当前数值进行 rpx 计算，在小屏设备上使用特定值
    /// - Parameter small: 小屏设备上使用的特定值
    /// - Returns: 在小屏设备上返回指定值，其他设备返回 rpx 计算值
    @objc func rpx(small: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(doubleValue), small: small)
    }
    
    /// 兼容旧版：对当前数值进行 rpx 计算，在小屏设备上使用特定值
    /// - Parameter iPhone5: 小屏设备上使用的特定值
    /// - Returns: 在小屏设备上返回指定值，其他设备返回 rpx 计算值
    @available(*, deprecated, renamed: "rpx(small:)", message: "请使用 rpx(small:) 替代")
    @objc func rpx(iPhone5: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(doubleValue), iPhone5: iPhone5)
    }
    
    /// 对当前数值进行 rpx 计算，为所有设备类型指定不同值
    /// - Parameters:
    ///   - iPad: iPad 上使用的特定值
    ///   - proMax: Pro Max 上使用的特定值
    ///   - plus: Plus 上使用的特定值
    ///   - standard: 标准尺寸上使用的特定值
    ///   - small: 小屏设备上使用的特定值
    /// - Returns: 在对应设备上返回指定值，未指定的设备返回 rpx 计算值
    @objc func rpxWithIPad(_ iPad: CGFloat, proMax: CGFloat, plus: CGFloat, standard: CGFloat, small: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(doubleValue), iPad: iPad, proMax: proMax, plus: plus, standard: standard, small: small)
    }
    
    /// 兼容旧版：对当前数值进行 rpx 计算，在 iPad 和小屏设备上使用特定值
    /// - Parameters:
    ///   - iPad: iPad 上使用的特定值
    ///   - iPhone5: 小屏设备上使用的特定值
    /// - Returns: 在对应设备上返回指定值，其他设备返回 rpx 计算值
    @available(*, deprecated, message: "请使用 rpxWithIPad:proMax:plus:standard:small: 替代")
    @objc func rpx(iPad: CGFloat, iPhone5: CGFloat) -> CGFloat {
        return WNResponsiveLayout.calculate(CGFloat(doubleValue), iPad: iPad, iPhone5: iPhone5)
    }
}
