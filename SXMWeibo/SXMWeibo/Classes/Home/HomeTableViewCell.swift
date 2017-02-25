//
//  HomeTableViewCell.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/2/12.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    // 配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    // 配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    // 配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var iconImageView: UIImageView!
    // 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    // 正文
    @IBOutlet weak var contentLabel: UILabel!
    
    var viewModel: StatusViewModel? {
        didSet{
            // 设置头像
            iconImageView.sd_setImageWithURL(viewModel?.icon_URL)
            
            // 认证图标
            verifiedImageView.image = viewModel?.verified_image
            
            // 会员图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.blackColor()
            if let image = viewModel?.mbrankImage {
                vipImageView.image = image
                nameLabel.textColor = UIColor.orangeColor()
            }
            
            // 昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            timeLabel.text = viewModel?.created_Time
          
            // 来源
            sourceLabel.text = viewModel?.source_Text
            
            contentLabel.text = viewModel?.status.text
            
            // 更新配图
            pictureCollectionView.reloadData()
            let (itemSize, clvSize) = calculateSize()
            // 更新cell尺寸
            if itemSize != CGSizeZero {
                flowLayout.itemSize = itemSize
            }
            // 更新collectionView尺寸
            pictureCollectionViewHeightCons.constant = clvSize.height
            pictureCollectionViewWidthCons.constant = clvSize.width
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置正文最大宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 10
        iconImageView.layer.cornerRadius = 30
    }
    
    // MARK: - 内部控制方法
    
    // 计算cell和collectionview的尺寸
    private func calculateSize() -> (CGSize, CGSize) {
        let count = viewModel?.thumbnail_pic?.count ?? 0
        // 无配图
        if count == 0 {
            return (CGSizeZero, CGSizeZero)
        }
        
        // 一张配图
        if count == 1 {
            let key = viewModel?.thumbnail_pic!.first!.absoluteString
            // 获取缓存的图片
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            return (image.size, image.size)
        }
        
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        let imageMargin: CGFloat = 10
        // 四张配图
        if count == 4 {
            let col = 2
            let row = col
            let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
            let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
            return (CGSize(width: width, height: height), CGSize(width: width, height: height))
        }
        
        let col = 3
        let row = (count - 1) / 3 + 1
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
    }

}

extension HomeTableViewCell: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! HomePictureCell
//        cell.backgroundColor = UIColor.redColor()
        cell.url = viewModel!.thumbnail_pic![indexPath.item]
        return cell
    }
}

class HomePictureCell: UICollectionViewCell {
    var url: NSURL? {
        didSet {
            customIconImageView.sd_setImageWithURL(url)
        }
    }
    
    @IBOutlet weak var customIconImageView: UIImageView!
    
    
}
