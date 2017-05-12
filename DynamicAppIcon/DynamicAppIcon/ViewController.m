//
//  ViewController.m
//  DynamicAppIcon
//
//  Created by Ans on 2017/5/10.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)setAppIconWithName:(NSString*)iconName {
    
    // 是否支持更换appicon
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
        return;
    }
    
    // 传入nil时显示原图标 primaryIcon
    if ([iconName isEqualToString:@""]) {
        iconName = nil;
    }
    [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setAppIconWithName:@"晴"];
}

@end
