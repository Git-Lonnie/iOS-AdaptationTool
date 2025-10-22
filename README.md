# iOS 屏幕适配工具 (WayneRpx) 国产国产国产！！！

一个强大的 iOS 响应式布局工具，支持所有 iPhone 和 iPad 型号的自适应屏幕尺寸。

## ✨ 特性

- 🎯 **精确分类**: 支持 5 种设备类型（小屏、标准、Plus、Pro Max、iPad）
- 📱 **全设备支持**: 覆盖所有 iPhone 和 iPad 型号（包括最新的 iPhone 16 系列）
- 🔄 **自动适配**: 基于屏幕宽度自动计算尺寸比例
- 🎨 **灵活定制**: 可为每种设备类型指定不同的值
- 🛡️ **安全区域**: 完美处理刘海屏、灵动岛和底部安全区
- 🔌 **OC 兼容**: 完全支持 Objective-C 调用
- ⚡ **零侵入**: 通过扩展方法实现，不影响现有代码

## 📦 安装

### Swift Package Manager

在 Xcode 中添加依赖：

1. **通过 Xcode 界面添加**
   - File > Add Packages...
   - 输入仓库 URL: `https://github.com/Git-Lonnie/iOS-AdaptationTool.git`
   - 选择版本规则，点击 Add Package

2. **在 Package.swift 中添加**

```swift
dependencies: [
    .package(url: "https://github.com/Git-Lonnie/iOS-AdaptationTool.git", from: "1.0.0")
]
```

然后在 target 中添加依赖：

```swift
.target(
    name: "YourTarget",
    dependencies: ["WayneRpx"]
)
```

### 手动导入

直接将 `Sources/WayneRpx` 目录下的所有 Swift 文件拖入项目即可。

## 🚀 快速开始

### 导入框架

```swift
import WayneRpx
```

### 基础用法

```swift
// 自动适配所有设备
let width = 100.rpx       // 根据屏幕宽度自动缩放
let height = 50.rpx       // iPhone 12: 52.0, iPhone 15 Pro Max: 57.3

// 使用计算后的值
let label = UILabel()
label.frame = CGRect(x: 20.rpx, y: 50.rpx, width: 200.rpx, height: 40.rpx)
label.font = UIFont.systemFont(ofSize: 16.rpx)
```

### 为不同设备指定值

```swift
// iPad 使用不同值
let spacing = 20.rpx(iPad: 40)  // iPhone: 自动计算, iPad: 40

// 多设备定制
let titleSize = 18.rpx(
    iPad: 24,       // iPad 上 24pt
    proMax: 20,     // Pro Max 上 20pt
    plus: 19,       // Plus 上 19pt
    standard: 18,   // 标准 iPhone 上 18pt
    small: 16       // 小屏（SE/Mini）上 16pt
)
```

## 📊 设备分类

| 类型 | 设备示例 | 屏幕宽度 |
|------|---------|----------|
| **iPhoneSmall** | SE 1/2/3, 12/13 mini | ≤ 375pt |
| **iPhoneStandard** | 12/13/14/15/16 标准版 | 390-393pt |
| **iPhonePlus** | 6/7/8 Plus, 14/15/16 Plus | 414pt |
| **iPhoneProMax** | 12/13/14/15/16 Pro Max | ≥ 428pt |
| **iPad** | 所有 iPad 型号 | 768pt+ |

## 🔍 设备检测

```swift
// 设备类型
if WNIsIPad { }              // 是否为 iPad
if WNIsSmallScreen { }       // 是否为小屏（SE/Mini）
if WNIsIPhonePlus { }        // 是否为 Plus 系列
if WNIsIPhoneProMax { }      // 是否为 Pro Max 系列

// 特殊特征
if WNIsIPhoneX { }           // 是否为刘海屏/挖孔屏
if WNHasDynamicIsland { }    // 是否有灵动岛（14 Pro+）

// 精确类型
switch WNCurrentScreenType {
case .iPhoneSmall: break
case .iPhoneStandard: break
case .iPhonePlus: break
case .iPhoneProMax: break
case .iPad: break
}
```

## 📐 屏幕信息

```swift
// 屏幕尺寸
WNScreenWidth                // 屏幕宽度
WNScreenHeight               // 屏幕高度
WNScreenBounds               // 屏幕边界

// 安全区域
WNSafeTop                    // 顶部安全区高度（刘海/灵动岛）
WNSafeBottom                 // 底部安全区高度（Home Indicator）
WNSafeAreaInsets             // 完整安全区

// 常用高度
WNSafeStatusBarHeight        // 状态栏高度
WNSafeNavigationHeight       // 导航栏总高度（状态栏 + 44）
WNSafeTabBarHeight           // 标签栏总高度（49 + 底部安全区）
```

## 🎨 实际应用示例

### 创建自适应视图

```swift
class CustomView: UIView {
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 头像大小：小屏 60, 标准 80, iPad 120
        let avatarSize = 80.rpx(iPad: 120, small: 60)
        avatarImageView.frame = CGRect(x: 20.rpx, y: 20.rpx, 
                                       width: avatarSize, height: avatarSize)
        
        // 字体大小自适应
        nameLabel.font = UIFont.systemFont(ofSize: 18.rpx)
        
        // 间距自适应
        let spacing = 16.rpx(iPad: 32, small: 12)
        nameLabel.frame.origin.x = avatarImageView.frame.maxX + spacing
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
    }
}
```

### 处理安全区域

```swift
class CustomNavigationBar: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 自动适配顶部安全区
        let topOffset = WNSafeTop
        let totalHeight = WNSafeNavigationHeight
        
        frame = CGRect(x: 0, y: 0, 
                      width: WNScreenWidth, 
                      height: totalHeight)
        
        // 标题位置考虑安全区
        titleLabel.frame.origin.y = topOffset + 10.rpx
    }
}
```

### 根据设备类型定制

```swift
class CollectionViewController: UIViewController {
    private var columnCount: Int {
        switch WNCurrentScreenType {
        case .iPad:           return 4
        case .iPhoneProMax:   return 3
        case .iPhonePlus:     return 3
        case .iPhoneStandard: return 2
        case .iPhoneSmall:    return 2
        }
    }
    
    private var itemSpacing: CGFloat {
        return 12.rpx(iPad: 20, proMax: 16, small: 8)
    }
}
```

## ⚙️ 配置选项

### 修改基准宽度

```swift
// 默认基准宽度是 375pt
// 如果设计稿是其他尺寸，可以修改
WNResponsiveLayout.sampleWidth = 390.0
```

### 全局控制

```swift
// 全局禁用 rpx（调试时可能有用）
WNResponsiveLayout.isGlobalEnabled = false

// 禁用特定设备的 rpx
WNResponsiveLayout.setGlobalDisabledTypes([.iPad])
```

### iPad 缩放系数

```swift
// 默认 iPad 的缩放系数是 1.5
// 可根据需求调整
WNResponsiveLayout.iPadZoomScale = 2.0
```

## 🔧 Objective-C 支持

```objective-c
// 基础用法
CGFloat width = @(100).rpx;

// 指定设备值
CGFloat spacing = [@(20) rpxWithIpad:40];
CGFloat fontSize = [@(16) rpxWithProMax:18];
CGFloat padding = [@(16) rpxWithSmall:12];

// 设备检测
if (WNIsIPad) {
    // iPad 处理
}

if (WNHasDynamicIsland) {
    // 灵动岛设备处理
}

// 屏幕信息
CGFloat screenWidth = WNScreenWidth;
CGFloat safeTop = WNSafeTop;
CGFloat navHeight = WNSafeNavigationHeight;
```

## 📚 文档

- [完整使用指南](USAGE.md) - 详细的功能说明和示例
- [更新日志](CHANGELOG.md) - 版本更新和改进说明

## 🔄 从旧版本迁移

旧的 API 完全保留，不会破坏现有代码。建议逐步迁移到新 API：

```swift
// 旧 API（仍然可用）
let size = 100.rpx(iPhone5: 80)  // ⚠️ 弃用警告
if WNIsIPhone5 { }               // ⚠️ 弃用警告

// 新 API（推荐）
let size = 100.rpx(small: 80)    // ✅ 推荐
if WNIsSmallScreen { }           // ✅ 推荐
```

## ✅ 支持的设备

### iPhone
- iPhone SE (1/2/3 代)
- iPhone 12 mini, 13 mini
- iPhone 12/13/14/15/16
- iPhone 12/13/14/15/16 Pro
- iPhone 6/7/8 Plus
- iPhone 14/15/16 Plus
- iPhone 12/13/14/15/16 Pro Max

### iPad
- iPad (所有代数)
- iPad Air (所有代数)
- iPad Pro (所有尺寸)
- iPad mini (所有代数)

## 📋 系统要求

- iOS 13.0+
- Swift 5.0+
- Objective-C 兼容

## 🎯 最佳实践

1. **设计稿基准**: 根据设计稿宽度设置 `samWNeWith`
2. **iPad 优化**: 为 iPad 单独指定值，不要完全依赖自动缩放
3. **小屏优化**: 小屏设备适当减小尺寸，确保内容完整显示
4. **大屏优化**: Pro Max 设备适当增大尺寸，充分利用空间
5. **安全区域**: 始终使用 `WNSafeTop` 和 `WNSafeBottom`
6. **灵动岛**: 注意灵动岛设备的 `safeTop` 更大（≥59pt）

## 📄 许可证

MIT License

## 作者

Wayne

## 贡献

欢迎提交 Issue 和 Pull Request！

## 更新日志

### 1.0.0

**💡 提示**: 查看 [USAGE.md](USAGE.md) 了解更多高级用法和详细示例。


有问题联系QQ:540378725
