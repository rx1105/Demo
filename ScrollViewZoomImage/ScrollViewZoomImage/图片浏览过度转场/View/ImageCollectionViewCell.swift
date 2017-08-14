//
//  ImageCollectionViewCell.swift
//  ScrollViewZoomImage
//
//  Created by Ans on 2017/7/19.
//  Copyright © 2017年 Ans. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    lazy var imageView = UIImageView()
    var zoomImageView: ZoomImageScrollView!
    
    var item: ShowItem? {
        didSet {
            
            guard let item = item else { return }
            
            guard let image = UIImage(named: item.imageName) else { return }
            
            imageView.image = image
            
            zoomImageView.setImage(image)
            
            if item.showBigImage {
                zoomImageView.imageView.contentMode = .scaleAspectFit
                
            } else {
                zoomImageView.isUserInteractionEnabled = false
                zoomImageView.imageView.contentMode = .scaleAspectFill
            }
    

        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        zoomImageView = ZoomImageScrollView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        contentView.addSubview(zoomImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCollectionViewCell {
    
    // 单击
    func singTapCallback(_ click: @escaping ()->()) {
        zoomImageView.singTapCallback = { click()}
    }
    
    // 滑动
    func panGesCallback(_ click: @escaping (CGFloat)->()) {
        zoomImageView.panGesCallback = { scale in
            click(scale)
        }
    }
}
