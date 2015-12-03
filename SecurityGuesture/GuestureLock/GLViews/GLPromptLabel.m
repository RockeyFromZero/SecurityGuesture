//
//  GLPromptLabel.m
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import "GLPromptLabel.h"

@interface GLPromptLabel ()

@end

@implementation GLPromptLabel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.textColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}


- (void)showNormalMsg:(NSString *)messgae {
    
    self.textColor = [UIColor blackColor];
    self.text = messgae;
}

- (void)showWarningMsg:(NSString *)message {
    
    self.textColor = [UIColor redColor];
    self.text = message;
}

- (void)showPromptMsg:(NSString *)message {
    
    self.textColor = [UIColor orangeColor];
    self.text = message;
}

@end


