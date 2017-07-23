//
//  BaseViewController.h
//  CAAnimation
//
//  Created by Ans on 2017/5/14.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)creatBtnWith:(NSString *)title complete:(void(^)(UIButton*))callback;

- (void)addNavgationLeftItem:(NSString*)title;

@end
