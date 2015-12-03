//
//  GuestureLock.h
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestureLock : UIViewController

/** 设置手势密码 */
+ (instancetype)GuestureLockSetPassword:(UIViewController *)vc successBlock:(void (^)())success failBlock:(void (^)(GuestureLock *failGuestureLock))fail;


/** 验证手势密码: 方法内部没有做是否存在密码检查，使用之前先检查密码 */
+ (instancetype)GuestureLockVerifyPassword:(UIViewController *)vc successBlock:(void (^)())success failBlock:(void (^)(GuestureLock *failGuestureLock))fail;

/** 从后台弹出验证密码，和上一个方法区别在于没有返回按钮 */
+ (instancetype)GuestureLockVerifyPwdFromBackground:(UIViewController *)vc successBlock:(void (^)())success failBlock:(void (^)(GuestureLock *failGuestureLock))fail;

/** 修改手势密码 */
+ (instancetype)GuestureLockModifyPassword:(UIViewController *)vc successBlock:(void (^)())success failBlock:(void (^)(GuestureLock *failGuestureLock))fail;

/** 删除密码 */
+ (void)removeGuesturePassword;

/** 是否设置了密码 YES:已经设置 NO:没有设置 */
+ (BOOL)hasGuesturePassword;

@end

