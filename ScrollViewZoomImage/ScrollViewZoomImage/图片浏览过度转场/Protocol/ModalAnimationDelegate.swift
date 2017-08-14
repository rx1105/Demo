//
//  ModalAnimationDelegate.swift
//  ScrollViewZoomImage
//
//  Created by Ans on 2017/7/18.
//  Copyright © 2017年 Ans. All rights reserved.
//

import UIKit

class ModalAnimationDelegate: NSObject {
    fileprivate var isPresentAnimationing: Bool = true
}

extension ModalAnimationDelegate: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresentAnimationing = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresentAnimationing = false
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresentAnimationing ? presentViewAnimation(transitionContext) : dismissViewAnimation(transitionContext)
    }
}

extension ModalAnimationDelegate {
    func presentViewAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        
        // 1. 添加目标View为转场View
        
        // 1.1 获取过渡View
        guard let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        // 1.2 获取容器View
        let containerView = transitionContext.containerView
        print(destinationView)
        print(containerView)
        
        // 1.3 过渡 view 添加到容器上
        containerView.addSubview(destinationView)
        
        // 2. 设置控制器
        // 2.1 获取目标VC
        let desVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? PhotoBrowseCollectionViewController
        // 获取当前浏览的indexPath
        guard let indexPath = desVC?.indexPath else { return }
        
        // 2.2 获取
        // 当前跳转的控制器的导航控制器
        guard let navC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UINavigationController else { return }
        guard let collectionVC = navC.topViewController as? UICollectionViewController else { return }
        
        // 2.2.3
        guard let currentCollectionView = collectionVC.collectionView else { return }
        
        // 2.2.4 获取当前选中的cell
        guard let selectedCell = currentCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else { return }

        // 3. 设置动画
        // 3.1 新建一个imageView添加到目标view上
        guard let image = selectedCell.imageView.image else { return }
        let animateView = UIImageView()
        animateView.image = image
        animateView.contentMode = .scaleAspectFill
        animateView.clipsToBounds = true
        // 3.1.1 坐标转换
        let originFrame = currentCollectionView.convert(selectedCell.frame, to: UIApplication.shared.keyWindow)
        // 3.1.2 设置frame
        animateView.frame = originFrame
        containerView.addSubview(animateView)
        
        // 3.1.3 动画结束后显示的frame
        let endFrame = coverImageFrameToFullScreen(image)
        // 3.1.4 设置透明
        destinationView.alpha = 0
        
        // 3.2 执行动画
        UIView.animate(withDuration: 0.5, animations: {
            // 3.2.1 改为全屏
            animateView.frame = endFrame
            
        }) { (completed) in
            // 3.2.2 设置完成转场
            animateView.removeFromSuperview()
            destinationView.alpha = 1
            
            transitionContext.completeTransition(true)
        }
        
    }
    
    func dismissViewAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        // 1. 取出View
        // from View
        let transitionView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let containerView = transitionContext.containerView
        
        // 2. 取出 from
        // 2.1 取出 from.VC
        guard let desVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        guard let desCollectionVC = desVC as? UICollectionViewController else { return }
        // 2.2 取出 from.view
        guard let presentView = desCollectionVC.collectionView else { return }
        // 2.3 取出 对应cell
        guard let dismissCell = presentView.visibleCells.first as? ImageCollectionViewCell else { return }
        
        // 3. 设置动画
        // 3.1 新建一个imageView添加到目标view上
        guard let image = dismissCell.imageView.image else { return }
        let animateView = UIImageView()
        animateView.contentMode = .scaleAspectFill
        animateView.clipsToBounds = true
        // 3.1.1 设置图片
        animateView.image = image
        // 3.1.2 设置frame
        animateView.frame = dismissCell.imageView.frame
        containerView.addSubview(animateView)
        // 3.1.3 动画结束后显示的frame
        guard let indexPath = presentView.indexPath(for: dismissCell) else { return }
        
        // 取出要返回的控制器view
        guard let navC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController else { return }
        guard let toVC = navC.topViewController as? UICollectionViewController else { return }
        guard let originView = toVC.collectionView else { return }
        
        
        // 取出对应cell
        let originCell = originView.cellForItem(at: indexPath)
        if originCell == nil {
            originView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            originView.layoutIfNeeded()
        }
        guard let cell = originView.cellForItem(at: indexPath) else { return }
        let originFrame = originView.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        // 3.2 执行动画
        UIView.animate(withDuration: 0.5, animations: {
            animateView.frame = originFrame
            transitionView?.alpha = 0
        }) { (_) in
            animateView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

        
    }
}

extension ModalAnimationDelegate {
    
    func coverImageFrameToFullScreen(_ image: UIImage) -> CGRect {
        let w: CGFloat = UIScreen.main.bounds.width
        let h: CGFloat = w/image.size.width * image.size.height
        let x: CGFloat = 0
        let y: CGFloat = (UIScreen.main.bounds.height - h) * 0.5
        return CGRect(x: x, y: y, width: w, height: h)
    }
}




