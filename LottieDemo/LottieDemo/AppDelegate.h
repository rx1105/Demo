//
//  AppDelegate.h
//  LottieDemo
//
//  Created by Ans on 2017/5/5.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

