//
//  QRCodeCreateViewController.swift
//  SXMWeibo
//
//  Created by 申铭 on 17/1/21.
//  Copyright © 2017年 shenming. All rights reserved.
//

import UIKit

class QRCodeCreateViewController: UIViewController {

    // 二维码容器
    @IBOutlet weak var customImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 还原滤镜的默认属性
        filter?.setDefaults()
        // 设置需要生产二维码的数据到滤镜中
        filter?.setValue("https://github.com/LarkNan".dataUsingEncoding(NSUTF8StringEncoding), forKeyPath: "InputMessage")
        // 取出生成好的二维码的图片
        guard let ciImage = filter?.outputImage else {
            return
        }
//        customImageView.image = UIImage(CIImage: ciImage)
        customImageView.image = createNonInterpolatedUIImageFormCIImage(ciImage, size: 300)
    }
    
    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }

}
