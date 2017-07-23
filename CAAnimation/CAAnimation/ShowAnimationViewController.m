//
//  ShowAnimationViewController.m
//  CAAnimation
//
//  Created by Ans on 2017/5/14.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import "ShowAnimationViewController.h"

@interface ShowAnimationViewController ()<CAAnimationDelegate>



/** 动画layer*/
@property (nonatomic, strong) CALayer *layer;

@end

@implementation ShowAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _selectorName;
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    [self navgation];
}


- (void)navgation {
    [self creatBtnWith:_selectorName complete:^(UIButton *btn) {
        SEL sel = NSSelectorFromString(_selectorName);
        [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame = CGRectMake(0, 100, 100, 100);
        btn.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:btn];
    }];
    
    
    [self addNavgationLeftItem:nil];
}

/**
 * 向下移动扫描条
 **********************
 * timingFunction 的创建
 * https://github.com/YouXianMing/Tween-o-Matic-CN?spm=5176.100239.blogcont29568.8.G3flzY
 */
#pragma mark - moveDown
- (void)moveDown {
    
    // layer
    [self.view.layer addSublayer:self.layer];
    self.layer.frame = CGRectMake(50, 50, 200, 1);
    self.layer.backgroundColor = [UIColor blackColor].CGColor;
    
    // 终点位置
    CGPoint endPosition  = CGPointMake(self.layer.position.x, self.layer.position.y + 200);
    
    // 动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    animation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    animation.toValue = [NSValue valueWithCGPoint:endPosition];
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:
                                0.20 :0.03 :0.13 :1.00]; 
    animation.duration = 1.f;
    
    // 动画后 改变 layer的实际位置
    self.layer.position = endPosition;
    
    // 添加动画
    [self.layer addAnimation:animation forKey:@"moveDown"];
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"start:%@",anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"Stop:%@",anim);
    [self.layer removeFromSuperlayer];
}



#pragma mark - touchMove
- (void)touchMove {
    // layer 
    [self.view.layer addSublayer:self.layer];
    self.layer.frame = CGRectMake(0, 0, 100, 100);
    self.layer.position = self.view.center;  
    self.layer.backgroundColor = [UIColor redColor].CGColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // animat
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.f];
    [CATransaction setAnimationTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
     ];
    
    self.layer.position = [[touches anyObject] locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(self.layer.position));
    [CATransaction commit];
}




#pragma mark - lazy
- (CALayer *)layer {
    if (!_layer) {
        _layer = [CALayer layer];
    }
    return _layer;
}


@end
