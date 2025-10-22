# iOS 屏幕适配工具 - 使用指南

## 概述

这是一个用于 iOS 应用程序的响应式布局工具，支持所有 iPhone 和 iPad 型号的自适应屏幕尺寸。

## 屏幕类型分类

工具将 iOS 设备分为以下五种类型：

| 类型 | 设备示例 | 屏幕宽度 | 说明 |
|------|---------|----------|------|
| **iPhoneSmall** | iPhone SE 1/2/3, iPhone 12/13 mini | ≤ 375pt | 小屏设备 |
| **iPhoneStandard** | iPhone 12/13/14/15/16 | 390-393pt | 标准尺寸 |
| **iPhonePlus** | iPhone 6/7/8 Plus, iPhone 14/15/16 Plus | 414pt | Plus 系列 |
| **iPhoneProMax** | iPhone 12/13/14/15/16 Pro Max | ≥ 428pt | 大屏 Pro Max |
| **iPad** | 所有 iPad 型号 | 768pt+ | iPad 系列 |

## 核心功能

### 1. 基础 rpx 自适应

默认以 375pt 为基准宽度，根据实际屏幕宽度自动缩放：

```swift
// 所有设备都自动适配
let width = 100.rpx      // iPhone 12: 104.0, iPhone 15 Pro Max: 114.7
let height = 50.rpx      // 自动计算比例
let fontSize = 16.rpx    // 字体大小也可以自适应
```

### 2. 修改基准宽度

如果你的设计稿不是 375pt，可以修改基准：

```swift
// 在 AppDelegate 中设置
WNResponsiveLayout.sampleWidth = 390.0  // 使用 390 作为基准宽度
```

### 3. 为不同设备指定特定值

#### 单一设备特定值

```swift
// 仅在 iPad 上使用不同值，其他设备自适应
let spacing = 20.rpx(iPad: 40)

// 仅在 Pro Max 上使用不同值
let buttonHeight = 44.rpx(proMax: 48)

// 仅在小屏设备上使用不同值
let iconSize = 24.rpx(small: 20)
```

#### 多设备特定值

```swift
// 为每种设备类型指定精确值
let titleSize = 18.rpx(
    iPad: 24,        // iPad 上 24pt
    proMax: 20,      // Pro Max 上 20pt
    plus: 19,        // Plus 上 19pt
    standard: 18,    // 标准尺寸 18pt
    small: 16        // 小屏 16pt
)

// 可以只指定部分设备，其他设备自动计算
let padding = 16.rpx(iPad: 24, small: 12)
```

### 4. 限定生效的设备类型

```swift
// 仅在 iPad 和 Pro Max 上自适应，其他设备返回原始值
let value = 50.rpx([.iPad, .iPhoneProMax])

// 仅在 iPhone 系列上自适应
let iPhoneValue = 30.rpx([.iPhoneSmall, .iPhoneStandard, .iPhonePlus, .iPhoneProMax])
```

### 5. 全局控制开关

```swift
// 全局禁用 rpx（所有 rpx 调用返回原始值）
WNResponsiveLayout.isGlobalEnabled = false

// 禁用特定设备类型的 rpx
WNResponsiveLayout.setGlobalDisabledTypes([.iPad])  // iPad 上不使用 rpx

// 手动指定的值不受全局开关影响
let spacing = 20.rpx(iPad: 40)  // 即使全局禁用，iPad 仍使用 40
```

## 设备检测功能

### 屏幕信息

```swift
// 屏幕尺寸
WNScreenWidth        // 屏幕宽度
WNScreenHeight       // 屏幕高度
WNScreenBounds       // 屏幕边界

// 安全区域
WNSafeTop            // 顶部安全区域（刘海/灵动岛高度）
WNSafeBottom         // 底部安全区域（Home Indicator 高度）
WNSafeAreaInsets     // 完整的安全区域

// 常用高度
WNSafeStatusBarHeight    // 状态栏高度
WNSafeNavigationHeight   // 导航栏总高度（状态栏 + 44）
WNSafeTabBarHeight       // 标签栏总高度（49 + 底部安全区）
```

### 设备类型检测

```swift
// 设备类型
WNIsIPad                 // 是否为 iPad
WNIsSmallScreen          // 是否为小屏设备（≤ 375pt）
WNIsIPhonePlus           // 是否为 Plus 系列
WNIsIPhoneProMax         // 是否为 Pro Max 系列

// 特殊屏幕特征
WNIsIPhoneX              // 是否为刘海屏/挖孔屏设备
WNIsSafeAreaInsetsScreen // 是否有安全区域
WNHasDynamicIsland       // 是否有灵动岛

// 获取当前设备的屏幕类型
let screenType = WNCurrentScreenType  // 返回 WNScreenType 枚举
```

### 根据设备返回不同值

```swift
// 两值选择（iPad vs iPhone）
let spacing = WNFrameSize1(40, 20)  // iPad: 40, iPhone: 20

// 三值选择（iPad vs 标准 iPhone vs 小屏）
let fontSize = WNFrameSize2(24, 18, 16)  // iPad: 24, 标准: 18, 小屏: 16

// 四值选择（iPad vs Pro Max vs 标准 vs 小屏）
let padding = WNFrameSize3(32, 24, 20, 16)

// 五值完整选择
let height = WNFrameSizeByType(
    iPad: 100,
    iPhoneProMax: 80,
    iPhonePlus: 75,
    iPhoneStandard: 70,
    iPhoneSmall: 60
)
```

## 实际使用场景

### 场景 1: 创建自适应 UI

```swift
class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 头像大小在不同设备上自适应
        let avatarSize = 80.rpx(iPad: 120, small: 60)
        
        // 布局间距
        let topPadding = WNSafeNavigationHeight + 20.rpx
        let sidePadding = 16.rpx(iPad: 32)
        
        // 字体大小
        let nameFont = UIFont.systemFont(ofSize: 20.rpx)
        let bioFont = UIFont.systemFont(ofSize: 14.rpx)
        
        setupUI(
            avatarSize: avatarSize,
            topPadding: topPadding,
            sidePadding: sidePadding,
            nameFont: nameFont,
            bioFont: bioFont
        )
    }
}
```

### 场景 2: 根据设备类型定制布局

```swift
class CollectionViewController: UIViewController {
    var columnCount: Int {
        switch WNCurrentScreenType {
        case .iPad:
            return 4
        case .iPhoneProMax, .iPhonePlus:
            return 3
        case .iPhoneStandard:
            return 2
        case .iPhoneSmall:
            return 2
        }
    }
    
    var itemSpacing: CGFloat {
        return 12.rpx(iPad: 20, proMax: 16, small: 8)
    }
}
```

### 场景 3: 处理安全区域

```swift
class CustomNavigationBar: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 自动适配刘海屏和灵动岛
        let topOffset = WNSafeTop
        let height = WNSafeNavigationHeight
        
        // 根据是否有灵动岛调整布局
        if WNHasDynamicIsland {
            // 灵动岛设备的特殊处理
            adjustForDynamicIsland()
        }
    }
}

class TabBarViewController: UITabBarController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 自动适配底部安全区域
        let tabBarHeight = WNSafeTabBarHeight
        tabBar.frame.size.height = tabBarHeight
    }
}
```

### 场景 4: 兼容旧代码

```swift
// 旧代码（仍然有效，但会提示弃用警告）
let oldSize = 100.rpx(iPhone5: 80)  // ⚠️ 建议使用 rpx(small:)

// 新代码（推荐）
let newSize = 100.rpx(small: 80)

// 旧的全局变量（仍然有效）
if WNIsIPhone5 {  // ⚠️ 建议使用 WNIsSmallScreen
    // 小屏设备处理
}

// 新的全局变量（推荐）
if WNIsSmallScreen {
    // 小屏设备处理
}
```

## Objective-C 兼容性

```objective-c
// 基础使用
CGFloat width = @(100).rpx;

// 指定设备值
CGFloat spacing = [@(20) rpxWithIpad:40];
CGFloat fontSize = [@(16) rpxWithProMax:18];
CGFloat padding = [@(16) rpxWithSmall:12];

// 完整指定所有设备
CGFloat height = [@(50) rpxWithIPad:80 
                              proMax:60 
                                plus:55 
                            standard:50 
                               small:45];

// 使用全局变量
if (WNIsIPad) {
    // iPad 处理
}

CGFloat screenWidth = WNScreenWidth;
CGFloat safeTop = WNSafeTop;
```

## 高级配置

### 自定义 iPad 缩放比例

```swift
// 默认 iPad 的缩放比例是 1.5
// 可以根据需求修改
WNResponsiveLayout.iPadZoomScale = 2.0  // iPad 上放大 2 倍
```

### 精确控制圆角

```swift
// roundToNearestZeroOrFive 会将小数部分舍入到 0, 0.5, 1.0
// 这样可以避免像素不对齐导致的模糊

let value = WNResponsiveLayout.roundToNearestZeroOrFive(12.3)  // 12.5
let value2 = WNResponsiveLayout.roundToNearestZeroOrFive(12.7) // 13.0
let value3 = WNResponsiveLayout.roundToNearestZeroOrFive(12.1) // 12.0
```

## 最佳实践

1. **设计稿基准**: 如果设计稿不是 375pt，在应用启动时修改 `sampleWidth`
2. **iPad 适配**: 建议为 iPad 单独指定值，而不是完全依赖自动缩放
3. **小屏优化**: 对于小屏设备（SE、Mini），适当减小元素尺寸以保证内容完整显示
4. **Pro Max 优化**: 对于大屏设备，可以适当增大元素以充分利用空间
5. **安全区域**: 始终使用 `WNSafeTop` 和 `WNSafeBottom` 处理刘海屏和底部安全区
6. **灵动岛**: 对于有灵动岛的设备，注意顶部空间可能更大
7. **类型检测**: 使用 `WNCurrentScreenType` 进行精确的设备类型判断

## 注意事项

1. 旧的 `iPhone5` 相关 API 已标记为弃用，但仍然可用
2. 现在 `isIPhone5` 实际检测的是所有宽度 ≤ 375pt 的设备（包括 iPhone SE 和 Mini）
3. 安全区域的检测依赖于 window 的 safeAreaInsets，在应用启动早期可能尚未准备好
4. 手动指定的设备特定值会忽略全局禁用设置

## 支持的设备列表

### iPhone
- **小屏**: SE 1/2/3 代, 12 mini, 13 mini
- **标准**: 12/13/14/15/16, 12/13/14/15/16 Pro
- **Plus**: 6 Plus, 6S Plus, 7 Plus, 8 Plus, 14 Plus, 15 Plus, 16 Plus
- **Pro Max**: 12 Pro Max, 13 Pro Max, 14 Pro Max, 15 Pro Max, 16 Pro Max

### iPad
- iPad, iPad Air, iPad Pro, iPad mini (所有型号)

## 版本兼容

- 支持 iOS 13.0+
- Swift 5.0+
- Objective-C 兼容

