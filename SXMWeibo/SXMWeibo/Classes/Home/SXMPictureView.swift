//
//  SXMPictureView.swift
//  SXMWeibo
//
//  Created by 申铭 on 2017/3/12.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit
import SDWebImage

class SXMPictureView: UICollectionView, UICollectionViewDataSource {
    
    // 配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    // 配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    // 配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var viewModel: StatusViewModel? {
        didSet{
            // 更新配图
            reloadData()
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
        
        self.dataSource = self
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! HomePictureCell
        //        cell.backgroundColor = UIColor.redColor()
        cell.url = viewModel!.thumbnail_pic![indexPath.item]
        return cell
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

class HomePictureCell: UICollectionViewCell {
    var url: NSURL? {
        didSet {
            customIconImageView.sd_setImageWithURL(url)
        }
    }
    
    @IBOutlet weak var customIconImageView: UIImageView!
    
    
}
