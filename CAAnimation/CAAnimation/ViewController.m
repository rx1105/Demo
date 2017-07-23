//
//  ViewController.m
//  CAAnimation
//
//  Created by Ans on 2017/5/12.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import "ViewController.h"

#import "ShowAnimationViewController.h"

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
    
    // 方法名
    _array = @[@"moveDown",
               @"touchMove",
               NSStringFromSelector(@selector(moveDown)),
               NSStringFromSelector(@selector(moveDown)),
               NSStringFromSelector(@selector(moveDown))];
    
    NSLog(@"%@",_array);
    
    // 约束值
    _colums = 3;
    _padding = 10;
    _itemHeight = 50;
    _itemWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - (_colums+1)*_padding) / _colums;
    
    // 添加按钮
    __weak typeof(self) weakSelf = self;
    [self creatButton:^(UIButton *btn) {
        [weakSelf.view addSubview:btn];
    }];
}


- (CGRect)getFrame:(NSUInteger)index {
    
    NSUInteger x = index % _colums;
    NSUInteger y = index / _colums;
    CGRect rect = CGRectMake(_padding+ x*(_padding+_itemWidth), 2*_padding+ y*(_padding+_itemHeight), _itemWidth, _itemHeight);
    return rect;
}

- (void)creatButton:(void(^)(UIButton *))callback {
    
    for (int i=0; i<_array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = [self getFrame:i];
        [btn setTitle:_array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        btn.backgroundColor = [UIColor lightGrayColor];
        
        //        SEL sel = NSSelectorFromString(_array[i]);
        //        [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        callback(btn);
    }
}


- (void)btnClick:(UIButton*)btn {
    ShowAnimationViewController *displayAnimatVC = [ShowAnimationViewController new];
    displayAnimatVC.selectorName = btn.titleLabel.text;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:displayAnimatVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

                                   

@end
