//
//  GuestureLock.m
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import "GuestureLock.h"
#import "GuestureLockView.h"
#import "GuestureLockTopBarView.h"
#import "Masonry.h"
#import "GLMacros.h"
#import "GLPromptLabel.h"
#import "GLPromptView.h"
#import "CoreArchive.h"

#define GLDrawLockViewPadding (GLScreenWidth/10.0) /** 密码绘制框 和背景视图间隔 */

@interface GuestureLock () <GLTopBarDelegate>

/** 导航栏 */
@property (nonatomic, weak) GuestureLockTopBarView *topBarView;

/** 导航栏标题 */
@property (nonatomic, copy) NSArray *topBarViewTitles;

/** 提示标签 */
@property (nonatomic, weak) GLPromptLabel *promptLabel;
@property (nonatomic, copy) NSArray *promptLabelInitText;

/** 绘制手势锁视图 */
@property (nonatomic, weak) GuestureLockView *guestureLockView;

/** 操作类型 */
@property (nonatomic, assign) GuestureLockType guestureLockType;

/** 成功 */
@property (nonatomic, copy) void (^successBlock)();

/** 失败:添加参数的目的是为了在在操作失败的时候，用户可以有更多的自主处理权 */
@property (nonatomic, copy) void (^failBlock)(GuestureLock *failGuestureLock);


/****************** just for set password, 仅用于设置密码 ******************/
/** 上部提示九宫格 */
@property (nonatomic, weak) GLPromptView *promptView;

/********* just for verify password, 仅用于验证密码 *********/
/** 忘记密码 */
@property (nonatomic, weak) UIButton *forgetPwdButton;

/** hide back button on navigation bar, 隐藏导航栏返回按钮 */
@property (nonatomic, assign) BOOL bHideBackButton;

/********* just for modify password, 仅用于重置密码 *********/
/** 验证密码成功，重置密码 */
@property (nonatomic, assign) BOOL isSettingPassword;

@end

@implementation GuestureLock

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)lockViewBlocks {
    
    /********* touch begin *********/
    self.guestureLockView.GLViewBeginTouch = ^(NSString *strMsg){
        
        [self.promptLabel showNormalMsg:strMsg];
    };
    
    
    /********* set password blocks 设置密码 *********/
    
    self.guestureLockView.GLSetPwdSelectedItemsTag = ^(NSArray *selectedItemsTag) {
        self.promptView.selectedItems = selectedItemsTag;
        [self.promptLabel showNormalMsg:m_strGLSetPwdConfirmPassword];
    };
    
    self.guestureLockView.GLSetPwdSuccess = ^{
        if (_successBlock) _successBlock();
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.guestureLockView.GLPwdLessThanMinLenth = ^{
        [self.promptLabel showWarningMsg:mstrGLPwdLessThanMinLength];
    };
    
    self.guestureLockView.GLSetPwdDifferentWithOrignal = ^{
        [self.promptLabel showWarningMsg:mstrGLPwdDifferentFromOrignal];
    };
    
    
    /********* verify password blocks 验证密码 *********/
    
    self.guestureLockView.GLVerifyPwdSuccess = ^{
        if (_successBlock) _successBlock();
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.guestureLockView.GLVerifyCountLeft = ^(NSInteger verifyCountLeft) {
        [self.promptLabel showWarningMsg:m_strGLVerifyPwdCountLeft(verifyCountLeft)];
    };
    
    self.guestureLockView.GLVerifyPwdFailed = ^{
        if (_failBlock) _failBlock(self);
        [self.promptLabel showWarningMsg:m_strGLVerifyPwdFailed];
    };
    
    /********* modify password blocks 验证密码 *********/
    self.guestureLockView.GLModifyPwdSuccessOnVerifyPwd = ^{
        self.isSettingPassword = YES;
        [self.promptLabel showNormalMsg:m_strGLModifyPwdSuccessWhileVerifyPwd];
    };
    
    self.guestureLockView.GLModifyPwdFailedOnVerifyPwd = ^{
        if (_failBlock) _failBlock(self);
        [self.promptLabel showWarningMsg:m_strGLVerifyPwdFailed];
    };
}

+ (GuestureLock *)guestureLock:(UIViewController *)vc {
    GuestureLock *lock = [[GuestureLock alloc] init];
    
    [vc presentViewController:lock animated:NO completion:nil];
    
    return lock;
}

#pragma mark - outter interface
+ (instancetype)GuestureLockSetPassword:(UIViewController *)vc successBlock:(void (^)())success failBlock:(void (^)(GuestureLock *failGuestureLock))fail {
    
    GuestureLock *guestureLock = [self guestureLock:vc];
    
    guestureLock.guestureLockType = GLType_setPassword;
    
    guestureLock.successBlock = success;
    guestureLock.failBlock = fail;
    
    return guestureLock;
}

+ (instancetype)GuestureLockVerifyPassword:(UIViewController *)vc successBlock:(void (^)())success failBlock:(void (^)(GuestureLock *failGuestureLock))fail {
    
    GuestureLock *guestureLock = [self guestureLock:vc];
    
    guestureLock.guestureLockType = GLType_verifyPassword;
    guestureLock.successBlock = success;
    guestureLock.failBlock = fail;
    
    return guestureLock;
}

+ (instancetype)GuestureLockVerifyPwdFromBackground:(UIViewController *)vc successBlock:(void (^)())success failBlock:(void (^)(GuestureLock *failGuestureLock))fail {
    
    GuestureLock *guestureLock = [self guestureLock:vc];
    
    guestureLock.bHideBackButton = YES;
    guestureLock.guestureLockType = GLType_verifyPassword;
    guestureLock.successBlock = success;
    guestureLock.failBlock = fail;
    
    return guestureLock;
}

/** 一直想用上面的两个方法来试一下，但是绞尽脑汁没想出来。。。。 */
+ (instancetype)GuestureLockModifyPassword:(UIViewController *)vc successBlock:(void (^)())success failBlock:(void (^)(GuestureLock *failGuestureLock))fail {
    
    GuestureLock *guestureLock = [self guestureLock:vc];
    
    guestureLock.guestureLockType = GLType_resetPassword;
    guestureLock.successBlock = success;
    guestureLock.failBlock = fail;
    
    return guestureLock;
}

+ (void)removeGuesturePassword {
    
    [CoreArchive removeStrForKey:m_strGLPasswordKey];
}

+ (BOOL)hasGuesturePassword {
    
    return nil != [CoreArchive strForKey:m_strGLPasswordKey];
}

#pragma mark - getters && setters
/**
 * getters
 */
- (NSArray *)topBarViewTitles {
    
    if (!_topBarViewTitles) {
        _topBarViewTitles = [NSArray arrayWithObjects:@"", @"设置密码", @"验证密码", @"修改密码", nil];
    }
    return _topBarViewTitles;
}

- (NSArray *)promptLabelInitText {
    
    if (!_promptLabelInitText) {
        _promptLabelInitText = [NSArray arrayWithObjects:@"", m_strGLSetPwdForFirstTime, m_strGLVerifyPwdBegin, m_strGLVerifyPwdBegin, nil];
    }
    return _promptLabelInitText;
}

- (GuestureLockTopBarView *)topBarView {
    
    if (!_topBarView) {
        GuestureLockTopBarView *topBarView = [[GuestureLockTopBarView alloc] initWithTitle:self.topBarViewTitles[self.guestureLockType]];
        [self.view addSubview:topBarView];
        _topBarView = topBarView;
        [topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.equalTo(self.view);
            make.height.equalTo(@(64));
        }];
    }
    return _topBarView;
}

- (GuestureLockView *)guestureLockView {
    
    if (!_guestureLockView) {
        GuestureLockView *GLView = [[GuestureLockView alloc] init];
        [self.view addSubview:GLView];
        _guestureLockView = GLView;
        [GLView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.promptLabel.mas_bottom).offset(20);
            make.left.equalTo(self.view).offset(GLDrawLockViewPadding);
            make.right.equalTo(self.view).offset(-GLDrawLockViewPadding);
            make.height.equalTo(@(GLScreenWidth - 2*GLDrawLockViewPadding));
        }];
    }
    return _guestureLockView;
}

- (GLPromptLabel *)promptLabel {
    
    if (!_promptLabel) {
        GLPromptLabel *label = [[GLPromptLabel alloc] init];
        [self.view addSubview:label];
        self.promptLabel = label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (GLType_setPassword == _guestureLockType ||
                _isSettingPassword) {
                make.top.equalTo(self.promptView.mas_bottom).offset(20);
            } else {
                make.top.equalTo(self.view.mas_top).offset(84);
            }
            make.height.equalTo(@40);
            make.left.and.right.equalTo(self.view);
        }];
    }
    return _promptLabel;
}

- (void)setIsSettingPassword:(BOOL)isSettingPassword {
    
    _isSettingPassword = isSettingPassword;
    if (_isSettingPassword) {
        [self.view addSubview:self.promptView];
        [self.promptLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(164);
        }];
    }
}

- (GLPromptView *)promptView {
    
    if (!_promptView) {
        GLPromptView *promptView = [[GLPromptView alloc] init];
        [self.view addSubview:promptView];
        _promptView = promptView;
        [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(84);
            make.height.equalTo(@60);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@60);
        }];
    }
    return _promptView;
}

- (UIButton *)forgetPwdButton {
    
    if (!_forgetPwdButton) {
        UIButton *forgetPwdButton = [[UIButton alloc] init];
        [forgetPwdButton setTitle:@"使用其它方式验证" forState:UIControlStateNormal];
        [forgetPwdButton setTitleColor:m_colorGLButtonText forState:UIControlStateNormal];
        [forgetPwdButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetPwdButton];
        _forgetPwdButton = forgetPwdButton;
        [forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-40);
            make.height.equalTo(@(m_numGLButtonHeight));
            make.left.and.right.equalTo(self.view);
        }];
    }
    return _forgetPwdButton;
}

#warning what to do if forget password
- (void)forgetPassword {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * setters
 */
- (void)setGuestureLockType:(GuestureLockType)guestureLockType {
    
    _guestureLockType = guestureLockType;
    
    self.topBarView.GLTopBarDelegate = self;
    if (NO == _bHideBackButton) {
        [self.topBarView addLeftButtonWithTitle:@"返回"];
    }
    
    [self loadSubviewsForDifferentGLType];
    [self lockViewBlocks];
    self.guestureLockView.guestLockType = guestureLockType;
    [self.promptLabel showNormalMsg:self.promptLabelInitText[self.guestureLockType]];
}


#pragma mark - GLTopBarDelegate
- (void)GuestureLockTopBarLeftButton {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Others
/** 根据不同的 guestureLockType 加载不同的视图 */
- (void)loadSubviewsForDifferentGLType {
    
    if (GLType_setPassword == _guestureLockType) [self.view addSubview:self.promptView];
    
    if (GLType_verifyPassword == _guestureLockType) [self.view addSubview:self.forgetPwdButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end