//
//  GuestureLockTopBarView.h
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLTopBarDelegate <NSObject>

@optional
/** 左侧按钮点击代理 */
- (void)GuestureLockTopBarLeftButton;

/** 右侧按钮点击代理 */
- (void)GuestureLockTopBarRightButton;

@end

@interface GuestureLockTopBarView : UIView

@property (nonatomic, weak) id <GLTopBarDelegate> GLTopBarDelegate;

/** 初始化标题 */
- (instancetype)initWithTitle:(NSString *)title;

/** 添加导航栏左侧按钮 (图片/标题) */
- (void)addLeftButtonWithImage:(UIImage *)image;
- (void)addLeftButtonWithTitle:(NSString *)title;

/** 添加导航栏右侧按钮 (图片/标题) */
- (void)addRightButtonWithImage:(UIImage *)image;
- (void)addRightButtonWithTitle:(NSString *)title;


@end

