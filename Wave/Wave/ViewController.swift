//
//  ViewController.swift
//  Wave
//
//  Created by Ans on 2017/7/5.
//  Copyright © 2017年 Ans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addWaveView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    func addWaveView() {
        
        let waveView = WaveView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        waveView.backgroundColor = .red
        view.addSubview(waveView)
        //
        let imageWidth: CGFloat = 50
        let imageX = (waveView.bounds.width - imageWidth) / 2
        var imageFrame = CGRect(x: imageX, y: 0, width: imageWidth, height: imageWidth)
        let imageView = UIView(frame: imageFrame)
        imageView.backgroundColor = .orange
        imageView.layer.cornerRadius = imageWidth*0.5
        waveView.addSubview(imageView)
        
        //
        waveView.waveCenterHBlock = { waveCenterY in
            imageFrame.origin.y = (waveView.bounds.height - imageFrame.height) + (waveCenterY - waveView.waveHeight)
            imageView.frame = imageFrame
        }
        //
        waveView.startAnimation()
    }
}

