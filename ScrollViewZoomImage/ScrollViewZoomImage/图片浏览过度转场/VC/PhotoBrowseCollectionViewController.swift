//
//  PhotoBrowseCollectionViewController.swift
//  ScrollViewZoomImage
//
//  Created by Ans on 2017/7/19.
//  Copyright © 2017年 Ans. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

private let cellMargin: CGFloat = 0.0

private let itemWidth: CGFloat = UIScreen.main.bounds.width + cellMargin
private let itemHeight: CGFloat = UIScreen.main.bounds.height

// MARK:- Init
class PhotoBrowseCollectionViewController: UICollectionViewController {
    
    var items: [ShowItem]!
    var indexPath: IndexPath!
    
    var presentView: UIImageView!

    /// 转场协调器
    fileprivate weak var animatorCoordinator: ScaleAnimatorCoordinator?
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
}

// MARK:- CollectionView
extension PhotoBrowseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentView.alpha = 0
        view.addSubview(presentView)
        
        collectionView?.frame = UIScreen.main.bounds
        collectionView?.frame.size.width = UIScreen.main.bounds.width + cellMargin
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        collectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: false)

        
        // Do any additional setup after loading the view.
    }
}

// MARK:- UICollectionview DataSource&Delegate
extension PhotoBrowseCollectionViewController {

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        let item = items[indexPath.item]
        item.showBigImage = true
        cell.item = item
        
        // 调用
        cell.singTapCallback { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        cell.panGesCallback { [weak self] scale in
            self?.animatorCoordinator?.updateCurrentHiddenView(cell)
            
            // 实测用scale的平方，效果比线性好些
            let alpha = scale * scale
//            collectionView.window?.alpha = alpha
//            self?.view.backgroundColor = .clear
            
            self?.presentView.alpha = 1 - alpha
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        dismiss(animated: true, completion: nil)
//    }
    
    var relatedView: UIView? {
        return collectionView?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
}



