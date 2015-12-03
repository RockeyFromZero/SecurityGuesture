//
//  GuestureLockView.m
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import <math.h>
#import "GuestureLockView.h"
#import "GuestureLockViewItem.h"
#import "GLMacros.h"
#import "CoreArchive.h"

@interface GuestureLockView ()

/** 绘制视图上面小单元格 */
@property (nonatomic, copy) NSArray *GLTotalItems;

/** 选中的单元格 */
@property (nonatomic, copy) NSMutableArray *selectedItems;

/** 选中的 item 的tag */
@property (nonatomic, copy) NSArray *selectedItemsTag;

/** 触摸位置 */
@property (nonatomic, assign) CGPoint touchPoint;

/** 触摸是否结束 yes for end */
@property (nonatomic, assign) BOOL isTouchEnd; /** 针对线条 */

/** 是否在提示报错 */
@property (nonatomic, assign) BOOL isShowWarning; /** 针对线条 */

/** 第一次设置密码 */
@property (nonatomic, copy) NSString *firstPassword;


/****************** just for verify password ******************/
/** 验证密码错误，剩余可以重新验证次数 */
@property (nonatomic, assign) NSInteger verifyCountLeft;

/****************** just for modify password ******************/
/** 修改密码时，验证密码成功 */
@property (nonatomic, assign) BOOL successOnVerifyPwdWhileModify;

@end

@implementation GuestureLockView

- (instancetype)init {
    
    self =  [super init];
    if (self) {
        self.backgroundColor = m_colorGLBackroung;
        [self prepareSubviews];
        
    }
    return self;
}

- (void)prepareSubviews {
    
    NSMutableArray *totalItems = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        GuestureLockViewItem *item = [[GuestureLockViewItem alloc] init];
        item.tag = i;
        [self addSubview:item];
        [totalItems addObject:item];
    }
    self.GLTotalItems = totalItems;
}

- (void)layoutSubviews {
    
    CGFloat itemWH = ViewWidth(self)/(3*(m_numGLGoldSectionLine+1));
    CGFloat origineXY = itemWH * m_numGLGoldSectionLine / 2.0f;
    [self.GLTotalItems enumerateObjectsUsingBlock:^(GuestureLockViewItem *item, NSUInteger idx, BOOL *stop) {
        
        CGFloat x = origineXY + itemWH * (1+m_numGLGoldSectionLine) * (idx/3);
        CGFloat y = origineXY + itemWH * (1+m_numGLGoldSectionLine) * (idx%3);
        item.frame = CGRectMake(x, y, itemWH, itemWH);
    }];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddRect(ctx, rect);
    [self.GLTotalItems enumerateObjectsUsingBlock:^(GuestureLockViewItem *obj, NSUInteger idx, BOOL *stop) {
        CGContextAddEllipseInRect(ctx, obj.frame);
    }];
    
    CGContextEOClip(ctx);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(ctx, 2.0f);
    [self.selectedItems enumerateObjectsUsingBlock:^(GuestureLockViewItem *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        if (0 == idx) {
            CGPathMoveToPoint(path, nil, center.x, center.y);
        } else {
            CGPathAddLineToPoint(path, nil, center.x, center.y);
        }
    }];
    
    if (!CGPointEqualToPoint(self.touchPoint, CGPointZero) && !self.isTouchEnd) {
        CGPathAddLineToPoint(path, nil, self.touchPoint.x, self.touchPoint.y);
    }
    
    CGContextAddPath(ctx, path);
    
    UIColor *color = _isShowWarning ? m_colorGLViewItemWarning : m_colorGLViewItemSelect;
    [color set];
    CGContextStrokePath(ctx);
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self beginTouch];
    self.isTouchEnd = NO;
    
    [self touchHandle:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchHandle:touches];
    
    self.touchPoint = [[touches anyObject] locationInView:self];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self checkPassword];
    [self clearLastLine];
    self.userInteractionEnabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:m_numGLTouchEndStayTime target:self selector:@selector(clearItems) userInfo:nil repeats:NO];
}

#pragma 处理手势密码结果
- (void)beginTouch {
    
    NSString *strMsg = [NSString string];
    if (GLType_setPassword == _guestLockType) {
        
        strMsg = _firstPassword ? m_strGLSetPwdConfirmPassword : m_strGLSetPwdForFirstTime;
    } else if (GLType_verifyPassword == _guestLockType) {
        
        strMsg = m_strGLVerifyPwdBegin;
    } else if (GLType_resetPassword == _guestLockType) {
        
        if (!_successOnVerifyPwdWhileModify) {
            strMsg = m_strGLVerifyPwdBegin;
        } else {
            
            strMsg = _firstPassword ? m_strGLSetPwdConfirmPassword : m_strGLSetPwdForFirstTime;
        }
    }
    
    if (_GLViewBeginTouch) _GLViewBeginTouch(strMsg);
}

- (void)checkPassword {
    if (self.selectedItems.count <= 0) {
        return;
    }
    
    if (GLType_setPassword == _guestLockType) {
        
        [self setPassword];
    }
    else if (GLType_verifyPassword == _guestLockType) {
        
        [self verifyPassword];
    } else if (GLType_resetPassword == _guestLockType) {
        
        [self modifyPassword];
    }
}

/** 设置密码 */
- (void)setPassword {
    
    if (self.selectedItems.count < m_numGLMinimumPwdLength) {
        if (_GLPwdLessThanMinLenth) _GLPwdLessThanMinLenth();
        return;
    }
    
    if ((nil == self.firstPassword) ||
        ([self.firstPassword isEqualToString:@""])) {
        
        [self saveOriginalPwd]; /** 第一次设置密码 */
    } else {
        
        if ([self pwdEqualToFirstPwd]) {
            
            if (_GLSetPwdSuccess) _GLSetPwdSuccess();
            [self savePassword];
        } else {
            
            [self showWarning];
            if (_GLSetPwdDifferentWithOrignal) _GLSetPwdDifferentWithOrignal();
        }
    }
}

- (void)savePassword {
    
    [CoreArchive setStr:self.firstPassword key:m_strGLPasswordKey];
}

- (void)saveOriginalPwd {
    
    NSMutableString *string = [NSMutableString string];
    NSMutableArray *array = [NSMutableArray array];
    for (GuestureLockView *item in self.selectedItems) {
        [string appendFormat:@"%ld", item.tag];
        [array addObject:@(item.tag)];
    }
    _firstPassword = string;
    self.selectedItemsTag = array;
}

- (BOOL)pwdEqualToFirstPwd {
    
    NSMutableString *password = [NSMutableString string];
    for (GuestureLockView *item in self.selectedItems) {
        [password appendFormat:@"%ld", item.tag];
    }
    return [password isEqualToString:self.firstPassword];
}

/** 验证密码 */
- (void)verifyPassword {
    
    NSString *pwdString = [CoreArchive strForKey:m_strGLPasswordKey];
    NSMutableString *currentPwd = [NSMutableString string];
    for (GuestureLockView *item in self.selectedItems) {
        [currentPwd appendFormat:@"%ld", item.tag];
    }
    
    if ([currentPwd isEqualToString:pwdString]) {
        
        if (_GLVerifyPwdSuccess) _GLVerifyPwdSuccess();
    } else {
        
        if (--_verifyCountLeft > 0) { /** 还可以验证 verifyCountLeft 次 */
            
            if (_GLVerifyCountLeft) _GLVerifyCountLeft(_verifyCountLeft);
        } else { /** 验证失败 */
            
            if (_GLVerifyPwdFailed) _GLVerifyPwdFailed();
        }
        
        [self showWarning];
    }
}

/** 修改密码 */
- (void)modifyPassword {
    
    if (NO == self.successOnVerifyPwdWhileModify) {
        
        [self verifyPwdOnModifyPwd];
    } else {
        
        [self setPassword];
    }
}

- (void)verifyPwdOnModifyPwd {
    
    NSString *pwdString = [CoreArchive strForKey:m_strGLPasswordKey];
    NSMutableString *currentPwd = [NSMutableString string];
    for (GuestureLockView *item in self.selectedItems) {
        [currentPwd appendFormat:@"%ld", item.tag];
    }
    
    if ([currentPwd isEqualToString:pwdString]) {
        
        self.successOnVerifyPwdWhileModify = YES;
        if (_GLModifyPwdSuccessOnVerifyPwd) _GLModifyPwdSuccessOnVerifyPwd();
    } else {
        
        if (--_verifyCountLeft > 0) { /** 还可以验证 verifyCountLeft 次 */
            
            if (_GLVerifyCountLeft) _GLVerifyCountLeft(_verifyCountLeft);
        } else { /** 验证失败 */
            
            if (_GLModifyPwdFailedOnVerifyPwd) _GLModifyPwdFailedOnVerifyPwd();
        }
        
        [self showWarning];
    }
}

#pragma mark select item
- (NSArray *)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    return _selectedItems;
}

- (void)touchHandle:(NSSet *)touches {
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    GuestureLockViewItem *currentItem = [self itemWithTouchLocation:touchPoint];
    if (nil == currentItem) return;
    [self setItemDirect:currentItem];
    [self.selectedItems addObject:currentItem];
    [self setNeedsDisplay];
}

- (void)clearLastLine { /** 擦处尾部多余的线头 */
    
    self.isTouchEnd = YES;
    [self setNeedsDisplay];
}

- (void)clearItems {
    
    _isShowWarning = NO;
    for (GuestureLockViewItem *item in self.selectedItems) {
        item.itemState = GLItemState_unselect;
        item.isItemDirectValid = NO;
    }
    [self.selectedItems removeAllObjects];
    self.touchPoint = CGPointMake(0, 0);
    self.userInteractionEnabled = YES;
    [self setNeedsDisplay];
}

- (GuestureLockViewItem *)itemWithTouchLocation:(CGPoint)location {
    
    GuestureLockViewItem *retItem = nil;
    for (GuestureLockViewItem *item in self.GLTotalItems) {
        if (CGRectContainsPoint(item.frame, location) &&
            (GLItemState_unselect == item.itemState)) {
            retItem = item;
            item.itemState = GLItemState_select;
            break;
        }
    }
    return retItem;
}

- (void)setItemDirect:(GuestureLockViewItem *)currentItem {
    
    if (0 == self.selectedItems.count) return;
    
    GuestureLockViewItem *lastItem = [self.selectedItems lastObject];
    
    /** d-value is 差值 in english */
    CGFloat dValueX = currentItem.center.x - lastItem.center.x;
    CGFloat dValueY = currentItem.center.y - lastItem.center.y;
    
    CGFloat aCosine = acos(dValueX/hypot(fabs(dValueX), fabs(dValueY)));
    CGFloat angle = (0 <= dValueY) ? aCosine : -aCosine;
    
    lastItem.isItemDirectValid = YES;
    lastItem.itemDirect = angle;
}

- (NSString *)firstPassword {
    if (!_firstPassword) {
        _firstPassword = [NSMutableString string];
    }
    return _firstPassword;
}

- (void)setSelectedItemsTag:(NSArray *)selectedItemsTag {
    
    _selectedItemsTag = selectedItemsTag;
    if (_GLSetPwdSelectedItemsTag) _GLSetPwdSelectedItemsTag(selectedItemsTag);
}

#pragma mark - getters && setters for outter property
- (void)setGuestLockType:(GuestureLockType)guestLockType {
    
    _guestLockType = guestLockType;
    if (GLType_verifyPassword == _guestLockType ||
        GLType_resetPassword == _guestLockType)
        _verifyCountLeft = m_numGLVerifyPwdMaxErrorCount;
}

#pragma mark - Others
- (void)showWarning {
    
    _isShowWarning = YES;
    
    for (GuestureLockViewItem *item in self.selectedItems) {
        item.itemState = GLItemState_warning;
    }
}

@end

