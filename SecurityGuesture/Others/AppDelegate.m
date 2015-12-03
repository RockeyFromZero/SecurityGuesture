//
//  AppDelegate.m
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"
#import "GuestureLock.h"

#define m_appWindowRootVC [[[UIApplication sharedApplication] delegate] window].rootViewController

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    TestViewController *testVC = [[TestViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:testVC];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    /** 如果此处 time 设置成比较大的数值，可能会导致 app 进入后台后，控制器依旧没有切换到验证手势密码；如果 time 设置成过小的数值，在 app 进入后台前，用户可能会看到控制器切换的过程，因为屏幕会闪现；这两种情况都会影响用户体验 */
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(showGuestureLock) userInfo:nil repeats:NO];
}

- (void)showGuestureLock {
    
    /** 在开发过程中 vc 应该是进入后台之前的 view controller */
    [GuestureLock GuestureLockVerifyPwdFromBackground:m_appWindowRootVC successBlock:^{
        
    } failBlock:^(GuestureLock *failGuestureLock){
        
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    /** 已经进行过测试，如果在此处(进入前台前)添加手势, 所做的操作是无效的，iOS在后台只能进行所规定的 (例如：播放音乐）等特定的几种操作，其它都是无效操作；所以如果想要在进入前台的时候验证手势密码，只能在 app 进入后台之前足够短的时间内，为 app 添加验证手势 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
