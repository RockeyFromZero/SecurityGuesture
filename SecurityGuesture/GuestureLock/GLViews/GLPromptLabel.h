//
//  GLPromptLabel.h
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLPromptLabel : UILabel

/** 一般提示 */
- (void)showNormalMsg:(NSString *)messgae;

/** 警告信息 */
- (void)showWarningMsg:(NSString *)message;

/** 提示信息 */
- (void)showPromptMsg:(NSString *)message;

@end

