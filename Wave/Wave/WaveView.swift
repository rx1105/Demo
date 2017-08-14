//
//  WaveView.swift
//  Wave
//
//  Created by Ans on 2017/7/5.
//  Copyright © 2017年 Ans. All rights reserved.
//  Copy  Github  Demo  ::  https://github.com/Josin22/JSWave/

import UIKit

class WaveView: UIView {
    // MARK:- public Point
    var waveCenterHBlock: ((_ waveCenterY: CGFloat) -> ())?// 浪的 center.Y 的变化
    
    var waveCurvature: CGFloat = 1.5// 浪弯曲度
    var waveSpeed: CGFloat = 0.1// 浪速
    // 浪高
    var waveHeight: CGFloat = 5 {
        didSet {// 设置layer.frame
            var frame = bounds
            frame.origin.y = frame.height - waveHeight
            frame.size.height = waveHeight
            
            realWaveLayer.frame = frame
            maskWaveLayer.frame = frame
        }
    }
    
    // 实浪颜色
    var realWaveColor: UIColor = .white {
        didSet {// 设置layer.fillColor
            realWaveLayer.fillColor = realWaveColor.cgColor
        }
    }
    
    // 遮罩浪颜色
    var maskWaveColor: UIColor = UIColor.white.withAlphaComponent(0.4) {
        didSet {
            maskWaveLayer.fillColor = maskWaveColor.cgColor
        }
    }
    
    
    // MARK:- fileprivate Point
    fileprivate var timer: CADisplayLink!
    fileprivate lazy var realWaveLayer: CAShapeLayer = { [weak self] in
        let layer = CAShapeLayer()
        guard let weakSelf = self else { return layer }
        
        var frame = weakSelf.bounds
        frame.origin.y = frame.height - weakSelf.waveHeight
        frame.size.height = weakSelf.waveHeight
        layer.frame = frame
        
        layer.fillColor = weakSelf.realWaveColor.cgColor
        
        return layer
    }()
    
    fileprivate lazy var maskWaveLayer: CAShapeLayer = { [weak self] in
        let layer = CAShapeLayer()
        guard let weakSelf = self else { return layer }
        
        var frame = weakSelf.bounds
        frame.origin.y = frame.height - weakSelf.waveHeight
        frame.size.height = weakSelf.waveHeight
        layer.frame = frame
        
        layer.fillColor = weakSelf.maskWaveColor.cgColor
        
        return layer
    }()
    
    fileprivate var offset: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 添加波浪线
extension WaveView {
    
    @objc fileprivate func wave() {
        //
        offset+=waveSpeed
        
        let width: CGFloat = bounds.width
        let height: CGFloat = waveHeight
        
        // realWave
        let realPath = CGMutablePath()
        realPath.move(to: CGPoint(x: 0, y: height))
        var realY: CGFloat = 0
        
        // maskWave
        let maskPath = CGMutablePath()
        maskPath.move(to: CGPoint(x: 0, y: height))
        var maskY: CGFloat = 0
        
        // 添加波浪线
        for x in 0...Int(width) {
            realY = height * CGFloat(sinf(Float(0.01 * waveCurvature * CGFloat(x) + offset * 0.45)))
            realPath.addLine(to: CGPoint(x: CGFloat(x), y: realY))
            
            maskY = -realY
            maskPath.addLine(to: CGPoint(x: CGFloat(x), y: maskY))
        }
        
        // 变化的中间Y值
        let centX = bounds.width / 2
        let centY = height * CGFloat(sinf(Float(0.01 * self.waveCurvature * centX + offset*0.45)))
        // 传出Y
        waveCenterHBlock?(centY)
        
        // 赋值
        realPath.addLine(to: CGPoint(x: width, y: height))
        realPath.addLine(to: CGPoint(x: 0, y: height))
        realPath.closeSubpath()
        realWaveLayer.path = realPath
        realWaveLayer.fillColor = realWaveColor.cgColor
        
        maskPath.addLine(to: CGPoint(x: width, y: height))
        maskPath.addLine(to: CGPoint(x: 0, y: height))
        maskPath.closeSubpath()
        maskWaveLayer.path = maskPath
        maskWaveLayer.fillColor = maskWaveColor.cgColor
        
    }
}

// MARK:- 外部调用方法
extension WaveView {
    
    func setupUI() {
        layer.addSublayer(realWaveLayer)
        layer.addSublayer(maskWaveLayer)
    }
    
    func startAnimation() {
        timer = CADisplayLink(target: self, selector: #selector(wave))
        timer.add(to: .current, forMode: .commonModes)
    }
    
    func stopAnimation() {
        timer.invalidate()
        timer = nil
    }
}
