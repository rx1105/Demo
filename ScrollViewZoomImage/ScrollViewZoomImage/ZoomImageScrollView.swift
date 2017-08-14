//
//  ZoomImageScrollView.swift
//  ScrollViewZoomImage
//
//  Created by Ans on 2017/7/18.
//  Copyright © 2017年 Ans. All rights reserved.
//

import UIKit



class ZoomImageScrollView: UIScrollView {

//    var isShowBigImage: Bool = false
    
    let selfFrame: CGRect
    
    var imageView: UIImageView!
    
    // 手势回调
    var singTapCallback: (()->())?
    
    var panGesCallback: ((CGFloat)->())?
    
    /// 双击放大图片时的目标比例
    public var imageZoomScaleForDoubleTap: CGFloat = 2.0
    
    /// 记录pan手势开始时imageView的位置
    fileprivate var beganFrame = CGRect.zero
    
    /// 记录pan手势开始时，手势位置
    fileprivate var beganTouch = CGPoint.zero
    
    override init(frame: CGRect) {
        
        selfFrame = frame
        imageView = UIImageView(frame: frame)
        
        super.init(frame: frame)
        
        addSubview(imageView)
        
        // 3. 设置缩放
        // 3.1 设置代理
        delegate = self
        // 3.2 设置缩放比例
        maximumZoomScale = 2.0
        minimumZoomScale = 0.5
        
        clipsToBounds = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        
        addGestureRec()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZoomImageScrollView {
    func setupUI(_ image: UIImage) {
        
        imageView = UIImageView(image: image)
        
       
        
        
        // 1. 添加imageView
        
        
//        // 2. 设置contentSize = image.size
//        contentSize = image.size
        
        
    }
    
    func setImage(_ image: UIImage) {
        
        imageView.image = image
        
        // 重设cell frame
        imageView.frame = selfFrame
        contentSize = selfFrame.size
        frame = selfFrame
        
//        // 2. 设置contentSize = image.size
//        contentSize = frame.size
    }
}

extension ZoomImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 设置为contentSize.center
        imageView.center = centerOfContentSize
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentOffset.y + bounds.height > contentSize.height {
            print("上拉")
            return
        }
        
        if contentOffset.y < 0 {
//            print("下拉")
             let scale = min(1.0, max(0.3, 1 -  abs(contentOffset.y) / bounds.height))
            
            print(scale)
            let rate = scale/2*scale
            imageView.frame = CGRect(x: 0, y: contentOffset.y, width: contentSize.width*rate, height: contentSize.height*rate)
            panGesCallback?(scale)
            
            let width = contentSize.width * scale
            let height = contentSize.height * scale

            // 计算x和y。保持手指在图片上的相对位置不变。
            // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
            let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
//            let currentTouchDeltaX = xRate * width
//            let x = currentTouch.x - currentTouchDeltaX
//
//            let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
//            let currentTouchDeltaY = yRate * height
//            let y = currentTouch.y - currentTouchDeltaY
//            
//            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
}

extension ZoomImageScrollView {
    
    /// 计算contentSize应处于的中心位置
    fileprivate var centerOfContentSize: CGPoint {
        let deltaWidth = bounds.width - contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = bounds.height - contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: contentSize.width * 0.5 + offsetX,
                       y: contentSize.height * 0.5 + offsetY)
    }
    
    /// 取图片适屏size
    fileprivate var fitSize: CGSize {
        guard let image = imageView.image else {
            return CGSize.zero
        }
        let width = bounds.width
        let scale = image.size.height / image.size.width
        return CGSize(width: width, height: scale * width)
    }
}

// MARK:- GestureRecognizer
extension ZoomImageScrollView {
    
    func addGestureRec() {
        
//        imageView.isUserInteractionEnabled = true
        
        // 1. 添加手势
        // 长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        superview?.addGestureRecognizer(longPress)
        
        // 双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        // 单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(onSingleTap))
        addGestureRecognizer(singleTap)
        singleTap.require(toFail: doubleTap)
        
        // 拖动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        superview?.addGestureRecognizer(pan)
    }
    
    
    /// 响应单击
    func onSingleTap() {
        singTapCallback?()
    }
    
    /// 响应双击
    func onDoubleTap(_ dbTap: UITapGestureRecognizer) {
        // 如果当前没有任何缩放，则放大到目标比例
        // 否则重置到原比例
        if zoomScale == 1.0 {
            // 以点击的位置为中心，放大
            let pointInView = dbTap.location(in: imageView)
            let w = bounds.width / imageZoomScaleForDoubleTap
            let h = bounds.height / imageZoomScaleForDoubleTap
            let x = pointInView.x - (w / 2.0)
            let y = pointInView.y - (h / 2.0)
            zoom(to: CGRect(x: x, y: y, width: w, height: h), animated: true)
        } else {
            setZoomScale(1.0, animated: true)
        }
    }
    
    /// 响应拖动
    func onPan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            beganFrame = imageView.frame
            beganTouch = pan.location(in: self)
        case .changed:
            // 拖动偏移量
            let translation = pan.translation(in: self)
//            let currentTouch = pan.location(in: self)
            
            // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
            let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))
            
//            let width = beganFrame.width * scale
//            let height = beganFrame.height * scale
//            
//            // 计算x和y。保持手指在图片上的相对位置不变。
//            // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
//            let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
//            let currentTouchDeltaX = xRate * width
//            let x = currentTouch.x - currentTouchDeltaX
//            
//            let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
//            let currentTouchDeltaY = yRate * height
//            let y = currentTouch.y - currentTouchDeltaY
//            
//            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
            
            // 通知代理，发生了缩放。代理可依scale值改变背景蒙板alpha值
//            if let dlg = photoBrowserCellDelegate {
//                dlg.photoBrowserCell(self, didPanScale: scale)
//            }
            panGesCallback?(scale)
        case .ended, .cancelled:
            if pan.velocity(in: self).y > 0 {
                // dismiss
                onSingleTap()
            } else {
                // 取消dismiss
                endPan()
            }
        default:
            endPan()
        }
    }
 
    private func endPan() {
//        if let dlg = photoBrowserCellDelegate {
//            dlg.photoBrowserCell(self, didPanScale: 1.0)
//        }
        // 如果图片当前显示的size小于原size，则重置为原size
        let size = fitSize
        let needResetSize = imageView.bounds.size.width < size.width
            || imageView.bounds.size.height < size.height
        UIView.animate(withDuration: 0.25) {
            self.imageView.center = self.centerOfContentSize
            if needResetSize {
                self.imageView.bounds.size = size
            }
        }
    }
    
    /// 响应长按
    func onLongPress(_ press: UILongPressGestureRecognizer) {
//        if press.state == .began, let dlg = photoBrowserCellDelegate, let image = imageView.image {
//            dlg.photoBrowserCell(self, didLongPressWith: image)
//        }
    }

}

extension ZoomImageScrollView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        
        
        beganFrame = imageView.frame
        beganTouch = pan.location(in: self)
        
//        let velocity = pan.velocity(in: self)
        // 向上滑动时，不响应手势
//        if velocity.y < 0 {
//            return false
//        }
        // 横向滑动时，不响应pan手势
//        if abs(Int(velocity.x)) > Int(velocity.y) {
//            return false
//        }
        
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
//        if contentOffset.y > 0 {
//            return false
//        }
        return true
    }
}
