//
//  HighLightSegmentCtrl.m
//  CustomSegmentCtrl
//
//  Created by Ans on 2017/5/12.
//  Copyright © 2017年 Ans. All rights reserved.
//

#import "HighLightSegmentCtrl.h"

@interface HighLightSegmentCtrl ()

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,assign) float itemWidth;

@property (nonatomic,strong) UIView *highlightView;

@property (nonatomic,strong) UIView *colorView;

@property (nonatomic,strong) UIView *highlightLabelBgView;

@end

@implementation HighLightSegmentCtrl


- (instancetype)initWithTitles:(NSArray*)titles {
    if (self=[super init]) {
        _titles = titles;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    _itemWidth = CGRectGetWidth(rect) / self.titles.count;
    
    // 第一层
    [self addTitleLabelToSuper:self createLabel:^(UILabel *label) {
        label.textColor = [UIColor blackColor];
    }];
    
    // 第二层 设置突显区域
    _highlightView = [[UIView alloc] initWithFrame:[self getItemFrameWithIndex:0]];
    _highlightView.clipsToBounds = YES;
    [self addSubview:_highlightView];
    
    // 第三层 红色突显部分
    _colorView = [[UIView alloc] initWithFrame:_highlightView.bounds];
    _colorView.backgroundColor = [UIColor redColor];
    _colorView.layer.cornerRadius = 5;
    [self.highlightView addSubview:_colorView];
    
    // 第四层 添加白色字体的label
    _highlightLabelBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [self.highlightView addSubview:_highlightLabelBgView];
    [self addTitleLabelToSuper:_highlightLabelBgView createLabel:^(UILabel *label) {
        label.textColor = [UIColor whiteColor];
    }];
    
    // 点击事件
    [self addTopLayerButton];
}


- (CGRect)getItemFrameWithIndex:(NSUInteger)index {
    CGRect rect = CGRectMake(_itemWidth*index, 0, _itemWidth, CGRectGetHeight(self.frame));
    return rect;
}

- (void)addTitleLabelToSuper:(UIView *)view createLabel:(void(^)(UILabel *))callback {
    for (int i=0; i<_titles.count; i++) {
        CGRect frame = [self getItemFrameWithIndex:i];
        UILabel *lable = [[UILabel alloc] initWithFrame:frame];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = _titles[i];
        [view addSubview:lable];
        callback(lable);
    }
}

- (void)addTopLayerButton {
    for (int i=0; i<_titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = [self getItemFrameWithIndex:i];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)selectedItem:(UIButton*)sender {
    NSUInteger index = sender.tag;
    
    [UIView animateWithDuration:1 animations:^{
        
        self.highlightView.frame = [self getItemFrameWithIndex:index];
        self.highlightLabelBgView.frame = CGRectOffset(self.bounds, -(index*_itemWidth), 0);
        
    } completion:^(BOOL finished) {
        [self shakeAnimationForView:self.colorView];
    }];
}

/**
 *  抖动效果
 *
 *  @param view 要抖动的view
 */
- (void)shakeAnimationForView:(UIView *) view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 1, position.y);
    CGPoint y = CGPointMake(position.x - 1, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

@end
