# 更新日志

所有重要的项目更改都将记录在此文件中。

## [1.0.0] - 2024-10-22

### 新增功能

#### 设备类型分类
- 支持 5 种精确的设备类型分类
  - `iPhoneSmall`: SE 系列、Mini 等小屏设备 (≤ 375pt)
  - `iPhoneStandard`: 标准尺寸 iPhone (390-393pt)
  - `iPhonePlus`: Plus 系列 (414pt)
  - `iPhoneProMax`: Pro Max 系列 (≥ 428pt)
  - `iPad`: 所有 iPad 设备

#### Rpx 自适应布局
- `.rpx` 属性用于自动适配所有设备
- 支持为每种设备类型指定不同的值
  - `.rpx(iPad:)` - 仅指定 iPad 值
  - `.rpx(proMax:)` - 仅指定 Pro Max 值
  - `.rpx(plus:)` - 仅指定 Plus 值
  - `.rpx(small:)` - 仅指定小屏值
  - `.rpx(iPad:proMax:plus:standard:small:)` - 指定所有设备值
- 支持限定生效的设备类型 `.rpx([.iPad, .iPhoneProMax])`

#### 设备检测
- `WNIsIPad` - 检测是否为 iPad
- `WNIsSmallScreen` - 检测小屏设备
- `WNIsIPhonePlus` - 检测 Plus 系列
- `WNIsIPhoneProMax` - 检测 Pro Max 系列
- `WNIsIPhoneX` - 检测刘海屏/挖孔屏
- `WNHasDynamicIsland` - 检测灵动岛设备
- `WNCurrentScreenType` - 获取当前设备类型

#### 屏幕信息
- `WNScreenWidth/Height` - 屏幕尺寸
- `WNSafeTop/Bottom` - 安全区域
- `WNSafeAreaInsets` - 完整安全区
- `WNSafeStatusBarHeight` - 状态栏高度
- `WNSafeNavigationHeight` - 导航栏总高度
- `WNSafeTabBarHeight` - 标签栏总高度

#### 全局配置
- `WNResponsiveLayout.sampleWidth` - 修改基准宽度（默认 375pt）
- `WNResponsiveLayout.iPadZoomScale` - iPad 缩放系数（默认 1.5）
- `WNResponsiveLayout.isGlobalEnabled` - 全局开关
- `WNResponsiveLayout.setGlobalDisabledTypes()` - 禁用特定设备类型

#### Objective-C 支持
- 完整的 `@objc` 支持
- `NSNumber` 扩展支持 `.rpx`
- 所有主要 API 都可以在 OC 中使用

### 改进
- 自动舍入到 0.0、0.5、1.0 避免像素模糊
- 支持 CGFloat、Int、Double 类型
- 自动监听安全区域变化
- 优化了设备类型判断逻辑

### 兼容性
- 保留所有旧版 API（标记为 deprecated）
- `WNIsIPhone5` → `WNIsSmallScreen`
- `.rpx(iPhone5:)` → `.rpx(small:)`

### 系统要求
- iOS 13.0+
- Swift 5.0+
- Xcode 11.0+

### 支持设备
- iPhone SE (1/2/3代)
- iPhone 12/13 mini
- iPhone 12/13/14/15/16 全系列
- iPhone 6/7/8 Plus
- iPhone 12/13/14/15/16 Pro Max
- 所有 iPad 型号

---

## 未来计划

### [1.1.0] - 计划中

- 支持横屏适配
- SwiftUI 支持
- 更多预设设备配置模板

### [1.2.0] - 计划中

- 动态字体大小支持
- 适配 visionOS
- 性能优化

---

**格式说明**
- `新增功能` - 新增的功能
- `改进` - 对现有功能的改进
- `修复` - Bug 修复
- `破坏性变更` - 不兼容的 API 变更
- `弃用` - 即将移除的功能

