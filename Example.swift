//
//  Example.swift
//  WayneRpx 使用示例
//
//  这个文件展示了 WayneRpx 的各种使用方法
//

import UIKit
import WayneRpx

// MARK: - 基础使用示例

class BasicExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 基础 rpx 自适应
        let width = 100.rpx       // 根据屏幕宽度自动缩放
        let height = 50.rpx       // Int/Double/CGFloat 都支持
        
        // 2. 创建视图
        let label = UILabel()
        label.frame = CGRect(x: 20.rpx, y: 50.rpx, width: 200.rpx, height: 40.rpx)
        label.font = UIFont.systemFont(ofSize: 16.rpx)
        label.text = "自适应标签"
        view.addSubview(label)
        
        // 3. 为不同设备指定值
        let spacing = 20.rpx(iPad: 40)  // iPhone 自动计算，iPad 使用 40
        let titleSize = 18.rpx(iPad: 24, small: 16)  // iPad 24, 小屏 16, 其他自动
        
        // 4. 完整指定所有设备
        let buttonHeight = 44.rpx(
            iPad: 60,
            proMax: 50,
            plus: 48,
            standard: 44,
            small: 40
        )
    }
}

// MARK: - 设备检测示例

class DeviceDetectionExample {
    
    func example() {
        // 检测设备类型
        if WNIsIPad {
            print("这是 iPad")
        }
        
        if WNIsSmallScreen {
            print("这是小屏设备（SE/Mini）")
        }
        
        if WNIsIPhonePlus {
            print("这是 Plus 系列")
        }
        
        if WNIsIPhoneProMax {
            print("这是 Pro Max 系列")
        }
        
        // 检测屏幕特征
        if WNHasDynamicIsland {
            print("这台设备有灵动岛")
        }
        
        if WNIsIPhoneX {
            print("这是刘海屏/挖孔屏设备")
        }
        
        // 使用 switch 精确判断
        switch WNCurrentScreenType {
        case .iPhoneSmall:
            print("小屏设备")
        case .iPhoneStandard:
            print("标准尺寸")
        case .iPhonePlus:
            print("Plus 系列")
        case .iPhoneProMax:
            print("Pro Max 系列")
        case .iPad:
            print("iPad")
        }
    }
}

// MARK: - 安全区域处理示例

class SafeAreaExampleView: UIView {
    
    private let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 使用安全区域
        let topOffset = WNSafeTop  // 顶部安全区（刘海/灵动岛）
        let bottomOffset = WNSafeBottom  // 底部安全区（Home Indicator）
        
        // 导航栏高度
        let navigationHeight = WNSafeNavigationHeight  // 状态栏 + 44
        
        // 标签栏高度
        let tabBarHeight = WNSafeTabBarHeight  // 49 + 底部安全区
        
        // 布局内容视图
        contentView.frame = CGRect(
            x: 0,
            y: navigationHeight,
            width: WNScreenWidth,
            height: WNScreenHeight - navigationHeight - tabBarHeight
        )
        
        addSubview(contentView)
    }
}

// MARK: - 自定义导航栏示例

class CustomNavigationBar: UIView {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 背景色
        backgroundColor = .white
        
        // 导航栏高度自适应安全区
        let height = WNSafeNavigationHeight
        frame = CGRect(x: 0, y: 0, width: WNScreenWidth, height: height)
        
        // 返回按钮
        let buttonSize = 44.rpx
        backButton.frame = CGRect(
            x: 10.rpx,
            y: WNSafeTop + (44 - buttonSize) / 2,
            width: buttonSize,
            height: buttonSize
        )
        addSubview(backButton)
        
        // 标题
        titleLabel.frame = CGRect(
            x: 80.rpx,
            y: WNSafeTop,
            width: WNScreenWidth - 160.rpx,
            height: 44
        )
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.rpx)
        addSubview(titleLabel)
    }
}

// MARK: - 自适应 CollectionView 示例

class AdaptiveCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    // 根据设备类型返回不同的列数
    private var columnCount: Int {
        switch WNCurrentScreenType {
        case .iPad:
            return 4
        case .iPhoneProMax:
            return 3
        case .iPhonePlus:
            return 3
        case .iPhoneStandard:
            return 2
        case .iPhoneSmall:
            return 2
        }
    }
    
    // 自适应间距
    private var itemSpacing: CGFloat {
        return 12.rpx(iPad: 20, proMax: 16, small: 8)
    }
    
    // 自适应边距
    private var sectionInset: UIEdgeInsets {
        let inset = 16.rpx(iPad: 24, small: 12)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = itemSpacing
        layout.sectionInset = sectionInset
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
}

extension AdaptiveCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = sectionInset
        let spacing = itemSpacing
        let totalSpacing = inset.left + inset.right + spacing * CGFloat(columnCount - 1)
        let width = (collectionView.bounds.width - totalSpacing) / CGFloat(columnCount)
        return CGSize(width: width, height: width * 1.2)
    }
}

extension AdaptiveCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
}

// MARK: - 个人资料页面示例

class ProfileViewController: UIViewController {
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let bioLabel = UILabel()
    private let editButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // 头像大小：iPad 120, 标准 80, 小屏 60
        let avatarSize = 80.rpx(iPad: 120, small: 60)
        avatarImageView.frame = CGRect(
            x: (WNScreenWidth - avatarSize) / 2,
            y: WNSafeNavigationHeight + 30.rpx,
            width: avatarSize,
            height: avatarSize
        )
        avatarImageView.layer.cornerRadius = avatarSize / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .lightGray
        view.addSubview(avatarImageView)
        
        // 名字标签
        nameLabel.frame = CGRect(
            x: 40.rpx,
            y: avatarImageView.frame.maxY + 20.rpx,
            width: WNScreenWidth - 80.rpx,
            height: 30.rpx
        )
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20.rpx(iPad: 28, small: 18))
        nameLabel.text = "Wayne"
        view.addSubview(nameLabel)
        
        // 简介标签
        bioLabel.frame = CGRect(
            x: 40.rpx,
            y: nameLabel.frame.maxY + 10.rpx,
            width: WNScreenWidth - 80.rpx,
            height: 60.rpx
        )
        bioLabel.textAlignment = .center
        bioLabel.numberOfLines = 0
        bioLabel.font = UIFont.systemFont(ofSize: 14.rpx(iPad: 18, small: 12))
        bioLabel.textColor = .gray
        bioLabel.text = "iOS Developer\n热爱编程和开源"
        view.addSubview(bioLabel)
        
        // 编辑按钮
        let buttonWidth = 200.rpx(iPad: 300, small: 160)
        let buttonHeight = 44.rpx(iPad: 60, small: 40)
        editButton.frame = CGRect(
            x: (WNScreenWidth - buttonWidth) / 2,
            y: bioLabel.frame.maxY + 30.rpx,
            width: buttonWidth,
            height: buttonHeight
        )
        editButton.setTitle("编辑资料", for: .normal)
        editButton.backgroundColor = .systemBlue
        editButton.layer.cornerRadius = 8.rpx
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.rpx(iPad: 20))
        view.addSubview(editButton)
    }
}

// MARK: - 全局配置示例

class GlobalConfigExample {
    
    static func setupGlobalConfig() {
        // 在 AppDelegate 中设置
        
        // 1. 修改基准宽度（如果设计稿不是 375pt）
        WNResponsiveLayout.sampleWidth = 390.0
        
        // 2. 修改 iPad 缩放系数
        WNResponsiveLayout.iPadZoomScale = 2.0
        
        // 3. 全局禁用 rpx（调试用）
        // WNResponsiveLayout.isGlobalEnabled = false
        
        // 4. 禁用特定设备的 rpx
        // WNResponsiveLayout.setGlobalDisabledTypes([.iPad])
    }
}

// MARK: - Objective-C 互操作示例

/*
 在 Objective-C 中使用：
 
 // 基础使用
 CGFloat width = @(100).rpx;
 
 // 指定设备值
 CGFloat spacing = [@(20) rpxWithIpad:40];
 CGFloat fontSize = [@(16) rpxWithProMax:18];
 
 // 完整指定
 CGFloat height = [@(50) rpxWithIPad:80
                               proMax:60
                                 plus:55
                             standard:50
                                small:45];
 
 // 设备检测
 if (WNIsIPad) {
     // iPad 处理
 }
 
 if (WNHasDynamicIsland) {
     // 灵动岛设备
 }
 
 // 屏幕信息
 CGFloat screenWidth = WNScreenWidth;
 CGFloat safeTop = WNSafeTop;
 CGFloat navHeight = WNSafeNavigationHeight;
 */

