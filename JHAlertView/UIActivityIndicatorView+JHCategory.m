//
//  UIActivityIndicatorView+JHCategory.m
//  JHKit
//
//  Created by Lightech on 14-10-16.
//  Copyright (c) 2014年 Lightech. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2017 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "UIActivityIndicatorView+JHCategory.h"

@interface JHBaseView : UIView
- (void)jh_remove_timer;
@end
@implementation JHBaseView
- (void)jh_remove_timer{}
@end

@interface JHHourglassView : JHBaseView
@property (weak,    nonatomic) UIView       *upMaskView;
@property (weak,    nonatomic) UIView       *downMaskView;
@property (weak,    nonatomic) UIView       *sandView;
@property (strong,  nonatomic) NSTimer      *timer;
@end
@implementation JHHourglassView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView:frame];
    }
    return self;
}
- (void)initView:(CGRect)frame
{
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    [self jhSetupViews];
    [self jhSetupMethods];
}
- (void)jhSetupViews
{
    //开平方
    CGFloat uW = sqrt(self.frame.size.width*self.frame.size.width*0.5);
    UIColor *color = [UIColor whiteColor];
    
    //上倒三角
    UIView *upView = [[UIView alloc] init];
    upView.frame = CGRectMake(0, 0, uW, uW);
    upView.backgroundColor = color;
    upView.transform = CGAffineTransformMakeRotation(M_PI_4);
    upView.center = CGPointMake(upView.frame.size.width*0.5,0);
    [self addSubview:upView];
    
    //下正三角
    UIView *downView = [[UIView alloc] init];
    downView.frame = CGRectMake(0, 0, uW, uW);
    downView.backgroundColor = color;
    downView.transform = CGAffineTransformMakeRotation(M_PI_4);
    downView.center = CGPointMake(upView.frame.size.width*0.5,upView.frame.size.height);
    [self addSubview:downView];
    
    //上遮罩
    UIView *upMaskView = [[UIView alloc] init];
    upMaskView.backgroundColor = self.backgroundColor;
    upMaskView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    [self addSubview:upMaskView];
    _upMaskView = upMaskView;
    
    //下遮罩
    UIView *downMaskView = [[UIView alloc] init];
    downMaskView.backgroundColor = self.backgroundColor;
    downMaskView.frame = CGRectMake(0, self.frame.size.height*0.5, self.frame.size.width,self.frame.size.height*0.5);
    [self addSubview:downMaskView];
    _downMaskView = downMaskView;
    
    //下落
    UIView *sandView = [[UIView alloc] init];
    sandView.frame = CGRectMake(self.frame.size.width*0.5-0.8,self.frame.size.height*0.5-0.5,1.5, 0);
    sandView.backgroundColor = color;
    [self addSubview:sandView];
    _sandView = sandView;
}
- (void)jhSetupMethods
{
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)jhResetFrame
{
    if (_upMaskView.frame.size.height >= self.frame.size.height*0.5) {
        self.timer.fireDate = [NSDate distantFuture];
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
            CGRect frame1 = _upMaskView.frame;
            frame1.size.height = 0;
            _upMaskView.frame = frame1;
            
            CGRect frame2 = _sandView.frame;
            frame2.size.height = 0;
            _sandView.frame = frame2;
            
            CGRect frame3 = _downMaskView.frame;
            frame3.origin.y = self.frame.size.height*0.5;
            frame3.size.height = self.frame.size.height*0.5;
            _downMaskView.frame = frame3;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.timer.fireDate = [NSDate distantPast];
        });
        
    }else{
        CGRect frame1 = _upMaskView.frame;
        frame1.size.height +=1;
        _upMaskView.frame = frame1;
        
        if (_sandView.frame.size.height < self.frame.size.height*0.5) {
            CGRect frame2 = _sandView.frame;
            frame2.size.height += 5;
            _sandView.frame = frame2;
        }
        else
        {
            CGRect frame3 = _downMaskView.frame;
            frame3.size.height -=1.5;
            _downMaskView.frame = frame3;
        }
    }
}
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(jhResetFrame) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)jh_remove_timer
{
    [self.timer invalidate];
    self.timer = nil;
}
@end

@implementation UIActivityIndicatorView (JHCategory)
+ (UIActivityIndicatorView *)jhAIViewInsuperView:(UIView *)superView
                                        showInfo:(NSString *)text
                                            type:(int)type
{
    UIActivityIndicatorView *xAIView = [[UIActivityIndicatorView alloc] init];
    xAIView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;//37 x 37
    xAIView.backgroundColor = [UIColor blackColor];
    xAIView.hidesWhenStopped = YES;
    xAIView.layer.cornerRadius = 5;
    
    CGSize size = CGSizeZero;
    if (text.length > 0){
        size = [self jhAutoSize:text];
    }
    
    CGFloat width = size.width < 80 ? 80 : size.width + 40;
    CGFloat height = size.height > 20 ? 77 + size.height : 87;
    
    //宽度没有超过最大值时，保持 宽 与 高 相等
    if (width < [UIScreen mainScreen].bounds.size.width - 100){
        width = width < height ? height : width;
    }
    
    //高度不超过最大高度
    UIView *tView = nil;
    BOOL flag = NO;
    if (height > [UIScreen mainScreen].bounds.size.height - 150) {
        height = [UIScreen mainScreen].bounds.size.height - 150;
        
        //超过时，添加scrollView
        CGRect frame = CGRectMake(0, 57, width, height - 57);
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = frame;
        scrollView.contentSize = CGSizeMake(width, size.height);
        scrollView.showsVerticalScrollIndicator = NO;
        [xAIView addSubview:scrollView];
        
        flag = YES;
        tView = scrollView;
    }else{
        tView = xAIView;
    }
    
    xAIView.frame = CGRectMake(0, 0, width, height);
    
    //有显示信息
    if (text.length > 0)
    {
        //调整 控件 位置
        UIView *view = xAIView.subviews[0];
        CGRect frame = view.frame;
        frame.origin.y = 10;
        view.frame = frame;
        
        CGFloat l1Y = CGRectGetMaxY(view.frame) + 15;
        if (flag) {
            l1Y = 0;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10, l1Y, width-20, size.height);
        label.text = text;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = 1;
        [tView addSubview:label];
        
        if (type == 0) {
            xAIView.frame = CGRectMake(0, 0, width, height - view.frame.size.height);
            view.hidden = YES;
            
            if ([tView isKindOfClass:[UIScrollView class]]) {
                CGRect frame = tView.frame;
                frame.origin.y = 10;
                tView.frame = frame;
            }else{
                label.center = xAIView.center;
            }
        }
    }
    
    //沙漏
    if (type == 2) {
        [self jhAiview:xAIView jhAnimationView:[[JHHourglassView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)]];
    }

    xAIView.center = superView.center;
    
    if (superView) {
        [superView addSubview:xAIView];
    }
    return xAIView;
}
+ (CGSize)jhAutoSize:(NSString *)text
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 140;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;//居中
    
#if 0
    //单行
    CGSize size1 = CGSizeMake(MAXFLOAT, 20);
    CGFloat width1 = [text boundingRectWithSize:size1 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.width;
    
    if (width1 <= width){
        return CGSizeMake(width1, 20);
    }
#endif
    
    //多行
    CGSize size2 = CGSizeMake(width, MAXFLOAT);
    CGSize newSize = [text boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    return newSize;
}

+ (void)jhAiview:(UIActivityIndicatorView *)xAIView jhAnimationView:(JHBaseView *)baseView
{
    //调整 控件 位置
    UIView *view = xAIView.subviews[0];
    baseView.center = view.center;
    view.hidden = YES;
    [xAIView addSubview:baseView];
}

- (void)willMoveToSuperview:(UIView *)superView
{
    if (!superView) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[JHBaseView class]]) {
                [(JHBaseView *)view jh_remove_timer];
            }
        }
    }
}
@end
