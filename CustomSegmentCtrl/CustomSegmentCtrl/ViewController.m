//
//  ViewController.m
//  CustomSegmentCtrl
//
//  Created by Ans on 2017/5/12.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import "ViewController.h"

#import "HighLightSegmentCtrl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *titles = @[@"Apple", @"Swift", @"Object-C", @"JavaStript"];
    HighLightSegmentCtrl *segment = [[HighLightSegmentCtrl alloc] initWithTitles:titles];
    segment.frame = CGRectMake(20, 100, CGRectGetWidth(self.view.frame)-40, 50);
    
    [self.view addSubview:segment];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
