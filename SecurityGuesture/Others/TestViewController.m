//
//  TestViewController.m
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import "GuestureLock.h"
#import "TestViewController.h"
#import "Masonry.h"
#import "GLMacros.h"

typedef enum {
    
    eventBtnTag_setPwd,
    eventBtnTag_verifyPwd,
    eventBtnTag_modifyPwd
} EventBtnTags;

@interface TestViewController ()

/** 失败，延时操作使用 */
@property (nonatomic, weak) GuestureLock *failGuestureLock;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = [NSArray arrayWithObjects:@"设置密码", @"验证密码", @"修改密码", nil];
    NSMutableArray *buttons = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [buttons addObject:buttons];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(100);
            make.width.equalTo(@100);
            make.top.equalTo(self.view).offset(100+i*(40+10));
            make.height.equalTo(@40);
        }];
    }
}

#pragma mark - button clicked
- (void)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case eventBtnTag_setPwd: {
            [self setGuesturePwd];
        }
            break;
        case eventBtnTag_verifyPwd: {
            [self verifyGuesturePwd];
        }
            break;
        case eventBtnTag_modifyPwd: {
            [self modifyGuesturePwd];
        }
            break;
            
        default:
            break;
    }
}

- (void)setGuesturePwd {
    debugLogMethod();
    [GuestureLock GuestureLockSetPassword:self successBlock:^{
        NSLog(@"set password success.\n");
    } failBlock:^(GuestureLock *failGuestureLock){
        
    }];
}

- (void)verifyGuesturePwd {
    debugLogMethod();
    [GuestureLock GuestureLockVerifyPassword:self successBlock:^{
        debuglog(@"verify password success.\n");
    } failBlock:^(GuestureLock *failGuestureLock){
        debuglog(@"verify password failed.\n");
        //        [failGuestureLock dismissViewControllerAnimated:YES completion:nil];
        [self dismissFailVCAfterDelay:failGuestureLock timeDelay:1.0f];
    }];
}

- (void)modifyGuesturePwd {
    debugLogMethod();
    [GuestureLock GuestureLockModifyPassword:self successBlock:^{
        debuglog(@"modify password success.");
    } failBlock:^(GuestureLock *failGuestureLock){
        debuglog(@"modify password failed.");
        //        [failGuestureLock dismissViewControllerAnimated:YES completion:nil];
        [self dismissFailVCAfterDelay:failGuestureLock timeDelay:2.0f];
        
    }];
}

- (void)dismissFailVCAfterDelay:(GuestureLock *)vc timeDelay:(CGFloat)delay {
    
    _failGuestureLock = vc;
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(dismissviewControllerAfterDelay) userInfo:nil repeats:NO];
}

- (void)dismissviewControllerAfterDelay {
    
    [_failGuestureLock dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

