//
//  GLMacros.h
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#ifndef GLMacros_h
#define GLMacros_h


/**************************** debug 调试 ****************************/
#ifdef DEBUG
#define debuglog(...) NSLog(__VA_ARGS__)
#define debugLogMethod() NSLog(@"****** funtion is %s. ******\n", __func__)
#else
#define debuglog(...)
#define debuglogMethod()
#endif



/**************************** enums 枚举 ****************************/
/** 操作类型 */
typedef enum {
    
    GLType_invalid = 0,     /** 默认为无效的类型 */
    GLType_setPassword,     /** 设置密码 */
    GLType_verifyPassword,  /** 验证密码 */
    GLType_resetPassword,   /** 修改密码 */
    GLType_removePassword   /** 清除密码 */
} GuestureLockType;



/**************************** 数字常量 ****************************/
#define m_numGLVerifyPwdMaxErrorCount 5 /** 验证密码最大输入错误次数 */

#define m_numGLMinimumPwdLength 4   /** 密码最小长度 */

#define m_numGLTouchEndStayTime 0.8f /** touchEnd 之后，错误提示停留时间 */

#define m_numGLButtonHeight 40.0f /** 按钮高度 */

#define m_numGLLineWidth 0.8f    /** 绘图使用的线宽 */

#define m_numGLSolidCircleScale 0.3f /** 实心圆相对 item 大小比例 */

#define m_numGLGoldSectionLine 0.4  /** 黄金分割线 */


/**************************** 字符串常量 ****************************/

#define m_strGLPasswordKey @"GuestureLockPasswordKey"   /** 密码存取的键值 */

/**
 *  just for set password, 仅供设置密码使用
 */
/** 密码长度小于最小长度 */
#define mstrGLPwdLessThanMinLength [NSString stringWithFormat:@"至少连接%d个点，请重新绘制",m_numGLMinimumPwdLength]

/** 设置密码两次密码不一样 */
#define mstrGLPwdDifferentFromOrignal @"与第一次绘制不一致，请重新绘制"

/** 第一次设置密码 */
#define m_strGLSetPwdForFirstTime @"请绘制手势密码"

/** 再次确认手势密码 */
#define m_strGLSetPwdConfirmPassword @"请再次绘制手势密码"


/**
 *  just for verify password, 仅供验证密码使用
 */
/** 开始验证密码 */
#define m_strGLVerifyPwdBegin @"请绘制已设置的手势密码"

/** 密码验证错误，剩余验证次数为 verifyCountLeft */
#define m_strGLVerifyPwdCountLeft(verifyCountLeft) [NSString stringWithFormat:@"密码错误, 还可以再输入%ld次", (verifyCountLeft)]

/** 验证密码失败 */
#define m_strGLVerifyPwdFailed [NSString stringWithFormat:@"验证达到最大次数(%d次),手势密码失效", (m_numGLVerifyPwdMaxErrorCount)]

/**
 *  just for modify password, 仅供修改密码使用
 */
/** 修改密码时，验证密码成功 */
#define m_strGLModifyPwdSuccessWhileVerifyPwd @"密码验证成功,请重新设置密码"



/**************************** colors 颜色 ****************************/
/** 使用 R, G, B, A 四种参数设置色彩 */
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define m_colorGLBackroung RGBA(255,255,255,1)  /** GuestureLock 背景颜色 */

#define m_colorGLViewItemUnselect RGBA(241,241,241,1) /** 图像未选中时得颜色 */

#define m_colorGLViewItemSelect RGBA(34,178,246,1)  /** 图像选中时得颜色 */

#define m_colorGLViewItemWarning [UIColor redColor] /** viewItem报错颜色 */

#define m_colorGLPromptItemUnselected RGBA(34,178,246,1)  /** promptView 图像未选中时得颜色 */

#define m_colorGLPromptItemSelected RGBA(34,178,246,1)  /** promptView 图像选中时得颜色 */

#define m_colorGLWarningText RGBA(254,82,92,1)  /** warning 文本颜色 */

#define m_colorGLNavgationBar RGBA(34,178,246,1)    /** 导航栏颜色 */

#define m_colorGLButtonText m_colorGLViewItemSelect     /** 按钮字体颜色 */



/**************************** 变量 ****************************/
/****************** view size && rect size &&... ******************/

#define GLScreenWidth [[UIScreen mainScreen] bounds].size.width /** 屏幕宽度 */

#define ViewWidth(view) ((view).frame.size.width)   /** 视图宽度 */

#define ViewHeight(view) ((view).frame.size.height) /** 视图高度 */

/** CGRect rect中心 */
#define rectCenter(rect) CGPointMake((rect).origin.x + (rect).size.width/2.0, (rect).origin.y + (rect).size.height/2.0)


#endif /* GLMacros_h */
