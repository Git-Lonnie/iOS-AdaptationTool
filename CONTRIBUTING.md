# 贡献指南

感谢你考虑为 WayneRpx 做出贡献！

## 如何贡献

### 报告 Bug

如果你发现了 Bug，请创建一个 Issue，并包含以下信息：

1. **Bug 描述**: 清楚地描述问题
2. **复现步骤**: 详细的复现步骤
3. **期望行为**: 你期望发生什么
4. **实际行为**: 实际发生了什么
5. **环境信息**:
   - iOS 版本
   - 设备型号
   - Xcode 版本
   - WayneRpx 版本
6. **示例代码**: 如果可能，提供最小可复现代码

### 提交功能请求

如果你有新功能的想法：

1. 先检查 Issues 中是否已有类似的请求
2. 创建新的 Issue，详细描述：
   - 功能需求
   - 使用场景
   - 期望的 API 设计
   - 可能的实现方案

### 提交代码

#### 开发流程

1. **Fork 仓库**

   点击页面右上角的 Fork 按钮

2. **克隆到本地**

   ```bash
   git clone https://github.com/你的用户名/iOS-AdaptationTool.git
   cd iOS-AdaptationTool
   ```

3. **创建新分支**

   ```bash
   git checkout -b feature/你的功能名
   # 或
   git checkout -b fix/bug描述
   ```

4. **进行修改**

   - 保持代码风格一致
   - 添加必要的注释
   - 更新相关文档

5. **测试你的修改**

   - 在多种设备上测试（如果可能）
   - 确保没有破坏现有功能
   - 添加新的测试用例（如果适用）

6. **提交修改**

   ```bash
   git add .
   git commit -m "feat: 添加新功能的描述"
   # 或
   git commit -m "fix: 修复某个bug的描述"
   ```

   提交信息格式：
   - `feat:` 新功能
   - `fix:` Bug 修复
   - `docs:` 文档更新
   - `style:` 代码格式调整（不影响功能）
   - `refactor:` 重构
   - `perf:` 性能优化
   - `test:` 测试相关
   - `chore:` 构建/工具相关

7. **推送到 GitHub**

   ```bash
   git push origin feature/你的功能名
   ```

8. **创建 Pull Request**

   - 访问你 Fork 的仓库
   - 点击 "New Pull Request"
   - 填写 PR 描述，说明你的修改

#### Pull Request 要求

- **清晰的描述**: 说明做了什么改动，为什么这样做
- **关联 Issue**: 如果修复了某个 Issue，在描述中提及
- **保持简洁**: 一个 PR 只做一件事
- **代码质量**: 
  - 遵循 Swift 代码规范
  - 添加适当的注释
  - 保持向后兼容
- **文档更新**: 如果改变了 API，更新相关文档
- **测试**: 确保所有测试通过

### 代码规范

#### Swift 代码风格

```swift
// 1. 使用 4 个空格缩进
// 2. 类型和协议使用 PascalCase
class MyClass { }
protocol MyProtocol { }

// 3. 变量和函数使用 camelCase
var myVariable: String
func myFunction() { }

// 4. 常量使用 camelCase
let myConstant = 42

// 5. 每行不超过 120 字符
// 6. 函数之间空一行
// 7. MARK 注释分组代码
// MARK: - Public Methods
// MARK: - Private Methods
```

#### 文档注释

```swift
/// 对当前数值进行 rpx 计算
/// - Parameter iPad: iPad 上使用的特定值
/// - Returns: 计算后的 CGFloat 值
func rpx(iPad: CGFloat) -> CGFloat {
    // 实现
}
```

#### 命名规范

- **清晰优于简洁**: `backgroundColor` 优于 `bgColor`
- **描述性命名**: 函数名应该清楚地表达功能
- **避免缩写**: 除非是众所周知的缩写（如 URL、ID）
- **布尔值**: 使用 `is`、`has`、`should` 等前缀

### 版本兼容性

- 保持向后兼容
- 如果必须破坏兼容性，清楚地标注
- 使用 `@available` 标记废弃的 API
- 提供迁移指南

### 文档

如果你的改动影响了使用方式，请更新：

- `README.md` - 主要文档和示例
- `USAGE.md` - 详细使用指南
- `CHANGELOG.md` - 更新日志
- 代码注释 - 保持注释最新

### 测试

虽然目前项目还没有单元测试，但建议：

1. **手动测试**
   - 在不同设备上测试（小屏、标准、Plus、Pro Max、iPad）
   - 测试横竖屏切换
   - 测试安全区域处理

2. **边界情况**
   - 极小值和极大值
   - nil 值处理
   - 特殊设备型号

3. **性能**
   - 确保不会造成性能问题
   - 避免不必要的计算

## 项目结构

```
iOS-AdaptationTool/
├── Sources/
│   └── WayneRpx/
│       ├── WNRpx.swift      # 核心 rpx 计算逻辑
│       └── WNScreen.swift   # 屏幕信息和设备检测
├── README.md                # 项目介绍
├── USAGE.md                 # 使用指南
├── CHANGELOG.md             # 更新日志
├── LICENSE                  # 许可证
├── CONTRIBUTING.md          # 贡献指南
├── Example.swift            # 使用示例
└── Package.swift            # Swift Package 配置
```

## 发布流程

维护者发布新版本时：

1. 更新版本号
2. 更新 `CHANGELOG.md`
3. 创建 Git tag
4. 发布 GitHub Release

## 获得帮助

如果你有任何问题：

1. 查看 [使用指南](USAGE.md)
2. 搜索现有的 Issues
3. 创建新的 Issue 提问
4. 联系作者: QQ 540378725

## 行为准则

- 尊重所有贡献者
- 使用友好和包容的语言
- 接受建设性批评
- 关注对社区最有利的事情
- 对其他社区成员表示同理心

## 许可证

通过贡献，你同意你的贡献将在 MIT 许可证下发布。

---

再次感谢你的贡献！每一个贡献都让 WayneRpx 变得更好。🎉

