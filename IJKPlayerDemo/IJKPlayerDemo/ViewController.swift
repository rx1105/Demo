//
//  ViewController.swift
//  IJKPlayerDemo
//
//  Created by Ans on 2017/8/11.
//  Copyright © 2017年 Ans. All rights reserved.
//

import UIKit
import IJKMediaFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        // 1. 创建播放器
        let fileURL = Bundle.main.url(forResource: "60cbcd6f027ef2087a1a606bb9d39288", withExtension: "mp4")
        
        
        let player = IJKFFMoviePlayerController(contentURL: fileURL, with: IJKFFOptions.byDefault())
        view.addSubview((player?.view)!)
        
        
        player?.view.bounds = view.bounds
        player?.view.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        player?.shouldAutoplay = true
        
        player?.prepareToPlay()
        
    }


}

