//
//  ViewController.swift
//  ScrollViewZoomImage
//
//  Created by Ans on 2017/7/18.
//  Copyright © 2017年 Ans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var zoomImageView = ZoomImageScrollView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension ViewController {
    fileprivate func setupUI() {
        let image = UIImage(named: "1222.jpeg")
        zoomImageView.setupUI(image!)
        view.addSubview(zoomImageView)
        
    }
}

