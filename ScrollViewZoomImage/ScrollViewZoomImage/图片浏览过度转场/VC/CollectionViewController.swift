//
//  CollectionViewController.swift
//  ScrollViewZoomImage
//
//  Created by Ans on 2017/7/18.
//  Copyright © 2017年 Ans. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

private let sectionPadding: CGFloat = 20.0

private let itemMargin: CGFloat = 5
private let itemWidth: CGFloat = (UIScreen.main.bounds.width - 3*itemMargin) / 4
private let itemHeight: CGFloat = itemWidth

class CollectionViewController: UICollectionViewController {
    
    fileprivate lazy var modalDelegate = ModalAnimationDelegate()
    
    lazy var items: [ShowItem] = {
        var tempItems = [ShowItem]()
        for i in 1...10 {
            let item = ShowItem(dict: ["imageName" : "\(i)" as AnyObject])
            tempItems.append(item)
        }
        return tempItems
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        self.collectionView!.backgroundColor = .lightGray
        self.collectionView!.contentInset = UIEdgeInsets(top: sectionPadding, left: 0, bottom: sectionPadding, right: 0)
        
        let layout = self.collectionView?.collectionViewLayout
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return }
        //flowLayout.sectionInset = UIEdgeInsets(top: 0, left: sectionPadding, bottom: 0, right: sectionPadding)
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = itemMargin
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical
    }

}

// MARK: UICollectionViewDataSource
extension CollectionViewController {

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
        item.showBigImage = false
        cell.item = item
    
        return cell
    }
}

// MARK: UICollectionViewDelegate、TransitioningDelegate
extension CollectionViewController: UIViewControllerTransitioningDelegate {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoVC = PhotoBrowseCollectionViewController()
        photoVC.indexPath = indexPath
        photoVC.items = items
        
        let image  = imageForView(view)
        photoVC.presentView = UIImageView(image: image)
        
        photoVC.transitioningDelegate = modalDelegate
        photoVC.modalPresentationStyle = .custom
        present(photoVC, animated: true) {
            
        }
    }

    func imageForView(_ view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContext(view.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return image!
    }
}
