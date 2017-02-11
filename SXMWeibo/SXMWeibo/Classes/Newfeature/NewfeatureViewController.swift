//
//  NewfeatureViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/2/8.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import SnapKit

class NewfeatureViewController: UIViewController {

    private var maxCount = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension NewfeatureViewController: UICollectionViewDataSource {
    
    // 多少组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newfeatureCell", forIndexPath: indexPath) as! SXMNewfeatureCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.purpleColor()
        cell.index = indexPath.item
        return cell
    }
}

extension NewfeatureViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // 注意: 传入的cell和indexPath都是上一页的, 而不是当前页
//        SXMLog(indexPath.item)
        
        // 1.手动获取当前显示的cell对应的indexPath
        let index = collectionView.indexPathsForVisibleItems().last!
        SXMLog(index.item)
        // 2.根据指定的indexPath获取当前显示的cell
        let currentCell = collectionView.cellForItemAtIndexPath(index) as! SXMNewfeatureCell
        if index.item == (maxCount - 1) {
//            SXMLog("最后一页")
            currentCell.startAnimation()
        }
    }
}

// MARK: - 自定义Cell
class SXMNewfeatureCell: UICollectionViewCell {
    
    var index: Int = 0
        {
        didSet {
            let name = "new_feature_\(index + 1)"
            iconView.image = UIImage(named: name)
            
            startButton.hidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    // MARK: - 外部控制方法
    func startAnimation() {
        startButton.hidden = false
        // 放大动画
        /*
        第一个参数: 动画时间
        第二个参数: 延迟时间
        第三个参数: 震幅 0.0~1.0, 值越小震动越列害
        第四个参数: 加速度, 值越大震动越列害
        第五个参数: 动画附加属性
        第六个参数: 执行动画的block
        第七个参数: 执行完毕后回调的block
        */
        startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        startButton.userInteractionEnabled = false
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
                self.startButton.userInteractionEnabled = true
        })
    }
    
    // MARK: - 内部控制方法
    private func setupUI() {
        // 添加字控件
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        iconView.snp_makeConstraints { (make) -> Void in            
            make.edges.equalTo(0)
        }
        
        startButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-120)
        }
    }
    
    @objc private func startBtnClick() {
        /*
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
        */
        NSNotificationCenter.defaultCenter().postNotificationName(SXMSwichRootViewController, object: true)
    }
    
    // MARK: - lazy
    private lazy var iconView = UIImageView()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton(imageName: nil, backgroundImageName: "new_feature_button")
        btn.addTarget(self, action: Selector("startBtnClick"), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}

// MARK: - 自定义布局
class SXMNewfeatureLayout: UICollectionViewFlowLayout {
    // 准备布局
    override func prepareLayout() {
        // 设置cell尺寸
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        // 滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 分页
        collectionView?.pagingEnabled = true
        // 禁用回弹效果
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}