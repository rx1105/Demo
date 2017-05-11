//
//  ViewController.m
//  DynamicLibraryTest
//
//  Created by Ans on 2017/5/10.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import "ViewController.h"
#import <DynamicLibrary/DynamicLibrary.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[ImageBrowser new] changeBackgorundColor:self.view];
}
20874942769

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
