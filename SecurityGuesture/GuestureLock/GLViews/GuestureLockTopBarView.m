//
//  GuestureLockTopBarView.m
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import "GuestureLockTopBarView.h"
#import "Masonry.h"
#import "GLMacros.h"

@interface GuestureLockTopBarView ()

/** 导航栏右侧按钮 */
@property (nonatomic, weak) UIButton *rightButton;

/** 导航栏中间文本 */
@property (nonatomic, weak) UILabel *titleLabel;

/** 导航栏左侧按钮 */
@property (nonatomic, weak) UIButton *leftButton;

@end

@implementation GuestureLockTopBarView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = m_colorGLNavgationBar;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    
    self = [super init];
    if (self) {
        self.backgroundColor = m_colorGLNavgationBar;
        self.titleLabel.text = title;
    }
    return self;
}


#pragma mark - 外部方法
/** 添加导航栏左侧按钮 (图片/标题) */
- (void)addLeftButtonWithImage:(UIImage *)image {
    
}


- (void)addLeftButtonWithTitle:(NSString *)title {
    
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

/** 添加导航栏右侧按钮 (图片/标题) */
- (void)addRightButtonWithImage:(UIImage *)image {
    
}

- (void)addRightButtonWithTitle:(NSString *)title {
    
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


#pragma mark - getters && setters
- (UIButton *)leftButton {
    
    if (!_leftButton) {
        UIButton *leftButton = [[UIButton alloc] init];
        [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        _leftButton = leftButton;
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(20);
            make.width.and.height.equalTo(@40);
        }];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    
    if (!_rightButton) {
        UIButton *rightButton = [[UIButton alloc] init];
        [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        _rightButton = rightButton;
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(20);
            make.width.and.height.equalTo(@40);
        }];
    }
    return _rightButton;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.leftButton);
            make.left.equalTo(self.leftButton.mas_right);
            make.right.equalTo(self.rightButton.mas_left);
        }];
    }
    return _titleLabel;
}

#pragma mark - top bar delegate
- (void)leftButtonClicked:(UIButton *)sender {
    
    if (_GLTopBarDelegate && [_GLTopBarDelegate respondsToSelector:@selector(GuestureLockTopBarLeftButton)]) {
        [_GLTopBarDelegate GuestureLockTopBarLeftButton];
    }
}

- (void)rightButtonClicked:(UIButton *)sender {
    
}

@end

