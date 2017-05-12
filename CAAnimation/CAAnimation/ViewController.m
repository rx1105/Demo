//
//  ViewController.m
//  CAAnimation
//
//  Created by Ans on 2017/5/12.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,assign) NSInteger itemWidth;
@property (nonatomic,assign) NSInteger itemHeight;
@property (nonatomic,assign) NSUInteger colums;
@property (nonatomic,assign) float padding;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _array = @[NSStringFromSelector(@selector(moveDown))];
    NSLog(@"%@",_array);
    _colums = 3;
    _padding = 10;
    _itemHeight = 50;
    _itemWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / _colums - 2*_padding;
}


- (void)getFrame:(NSUInteger)index {
    CGRect rect = CGRectMake(_padding+ index*_itemWidth, 2*_padding+ index, _itemWidth, _itemHeight);
}

- (void)creatButton:(void(^)(UIButton *))callback {
    
    for (int i=0; i<_array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =
    }
}


/**
 * 向下移动扫描条
 */
- (void)moveDown {
    // 初始化线条
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(50, 50, 200, 1);
    layer.backgroundColor = [UIColor blackColor].CGColor;
    
    // 终点位置
    CGPoint endPosition  = CGPointMake(layer.position.x, layer.position.y + 200);
    
    // 动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:layer.position];
    animation.toValue = [NSValue valueWithCGPoint:endPosition];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; // 也可自己设置 [CAMediaTimingFunction functionWithControlPoints:0.20 :0.03 :0.13 :1.00] https://github.com/YouXianMing/Tween-o-Matic-CN?spm=5176.100239.blogcont29568.8.G3flzY;
    animation.duration = 1.f;
    // 动画后 改变 layer的实际位置
    layer.position = endPosition;
    
    // 添加动画
    [layer addAnimation:animation forKey:@"moveDown"];
    
    // 添加layer
    [self.view.layer addSublayer:layer];
}


@end
