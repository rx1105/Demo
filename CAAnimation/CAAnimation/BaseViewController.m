//
//  BaseViewController.m
//  CAAnimation
//
//  Created by Ans on 2017/5/14.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Navgation Item

- (void)creatBtnWith:(NSString *)title complete:(void(^)(UIButton*))callback {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    callback(button);
}


- (void)addNavgationLeftItem:(NSString*)title {
    if (!title) {
        title = @"返回";
    }
    
    [self creatBtnWith:title complete:^(UIButton *btn) {
        btn.backgroundColor = [UIColor orangeColor];
        [btn addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, 50, 50);
        
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barBtnItem;
    }];
    
}


- (void)leftItemClick:(UIButton*)btn {
    NSLog(@"%s",__func__);
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
