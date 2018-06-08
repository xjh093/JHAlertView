//
//  JHAlertView.h
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

#import <UIKit/UIKit.h>

#define XX_HUD_SHOW_TEXT_ONLY(info,time,inView) \
XX_HUD_SHOW(info,time,inView,0,YES)

#define XX_HUD_SHOW_SYSTEM_ONLY(info,time,inView) \
XX_HUD_SHOW(info,time,inView,1,YES)

#define XX_HUD_SHOW_CUSTOM_ONLY(info,time,inView) \
XX_HUD_SHOW(info,time,inView,2,YES)

#define XX_HUD_SHOW_TEXT_ONLY_V1(info,time,inView,inWindow) \
XX_HUD_SHOW(info,time,inView,0,inWindow)

#define XX_HUD_SHOW_SYSTEM_ONLY_V1(info,time,inView,inWindow) \
XX_HUD_SHOW(info,time,inView,1,inWindow)

#define XX_HUD_SHOW_CUSTOM_ONLY_V1(info,time,inView,inWindow) \
XX_HUD_SHOW(info,time,inView,2,inWindow)

#define XX_HUD_SHOW(info,time,inView,type012,inWindow) \
[[JHAlertView alertView] jhShow:info duration:time toView:inView type:type012 addToWindowWhenViewIsNil:inWindow];

#define XX_HUD_HIDE \
[[JHAlertView alertView] jhHide];

@interface JHAlertView : UIView

+ (instancetype)alertView;

/**
 show a HUD

 @param info text to show
 @param duration time
 @param view super view
 @param type 0:only text, 1:system activityIndicator, 2:custom
 */
- (void)jhShow:(id)info duration:(CGFloat)duration toView:(UIView *)view type:(int)type addToWindowWhenViewIsNil:(BOOL)flag;
- (void)jhHide;

@end



