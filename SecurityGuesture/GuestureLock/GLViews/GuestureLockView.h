//
//  GuestureLockView.h
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMacros.h"

@interface GuestureLockView : UIView

/** 操作类型 */
@property (nonatomic, assign) GuestureLockType guestLockType;


/**
 * 反馈提示信息
 */
/** 开始触摸 */
@property (nonatomic, copy) void (^GLViewBeginTouch)(NSString *strMsg);




/******************** set password 设置密码 ********************/
/** 密码长度小于最小长度 */
@property (nonatomic, copy) void (^GLPwdLessThanMinLenth)();

/** 第一次设置密码成功，同时保存选中的 Items 的tag */
@property (nonatomic, copy) void (^GLSetPwdSelectedItemsTag)(NSArray *selectedItemtag);

/** 与第一次设置密码不相同 */
@property (nonatomic, copy) void (^GLSetPwdDifferentWithOrignal)();

/** 密码设置成功 */
@property (nonatomic, copy) void (^GLSetPwdSuccess)();


/******************** verify password 验证密码 ********************/
/** 验证密码成功 */
@property (nonatomic, copy) void (^GLVerifyPwdSuccess)();

/** 验证密码失败 */
@property (nonatomic, copy) void (^GLVerifyPwdFailed)();

/** 此次验证密码失败，还可以再验证 countLeft 次 */
@property (nonatomic, copy) void (^GLVerifyCountLeft) (NSInteger countLeft);



/******************** modify password 修改密码 ********************/
/** 验证成功、失败 */
@property (nonatomic, copy) void (^GLModifyPwdSuccessOnVerifyPwd)();
@property (nonatomic, copy) void (^GLModifyPwdFailedOnVerifyPwd)();




@end

