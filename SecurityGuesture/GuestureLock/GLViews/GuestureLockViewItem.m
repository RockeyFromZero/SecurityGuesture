//
//  GuestureLockViewItem.m
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import "GuestureLockViewItem.h"
#import "GLMacros.h"

@interface GuestureLockViewItem ()

@end

@implementation GuestureLockViewItem

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.itemState = GLItemState_unselect;
        self.isItemDirectValid = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /** 旋转视图 */
    [self rotateViewForNormalAngle:ctx rect:rect];
    
    UIColor *color = m_colorGLViewItemSelect;
    if (GLItemState_warning == _itemState) {
        color = m_colorGLViewItemWarning;
    }
    [color set];
    
    [self outerCircle:ctx rect:rect];
    
    if (GLItemState_unselect != _itemState) {
        
        [self innerCircle:ctx rect:rect];
        [self directTriangle:ctx rect:rect];
    }
}

/**
 *  Quartz2D 旋转
 *  参考：http://www.cnblogs.com/smileEvday/archive/2013/05/25/IOSImageEdit.html
 */
- (void)rotateViewForNormalAngle:(CGContextRef)ctx rect:(CGRect)rect {
    
    if (NO == _isItemDirectValid) return;
    
    CGFloat translateXY = rect.size.width * 0.5f;
    CGContextTranslateCTM(ctx, translateXY, translateXY);
    CGContextRotateCTM(ctx, _itemDirect);
    CGContextTranslateCTM(ctx, -translateXY, -translateXY);
}

- (void)outerCircle:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGMutablePathRef outterCirclePath = CGPathCreateMutable();
    CGFloat wh = rect.size.width - 2.0f;
    CGFloat origineX = rect.origin.x + 1.0f;
    CGFloat origineY = rect.origin.y + 1.0f;
    CGRect circleRect = (CGRect){{origineX, origineY}, {wh, wh}};
    CGContextAddEllipseInRect(ctx, circleRect);
    CGContextAddPath(ctx, outterCirclePath);
    CGContextStrokePath(ctx);
    CGPathRelease(outterCirclePath);
}

- (void)innerCircle:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGMutablePathRef innerCirclePath = CGPathCreateMutable();
    CGFloat wh = rect.size.width * 0.4;
    CGFloat origineX = rectCenter(rect).x - wh / 2.0;
    CGFloat origineY = rectCenter(rect).y - wh / 2.0;
    CGRect circleRect = (CGRect){{origineX, origineY}, {wh, wh}};
    CGContextAddEllipseInRect(ctx, circleRect);
    CGContextAddPath(ctx, innerCirclePath);
    CGContextFillEllipseInRect(ctx, circleRect);
    CGContextStrokePath(ctx);
    CGPathRelease(innerCirclePath);
}

- (void)directTriangle:(CGContextRef)ctx rect:(CGRect)rect {
    
    if (NO == _isItemDirectValid) return;
    
    CGPoint rectCenter = rectCenter(rect);
    CGMutablePathRef trianglePath = CGPathCreateMutable();
    
    CGPoint orignalPoint = CGPointMake(rectCenter.x + rect.size.width * 0.25, rectCenter.y - rect.size.width/10.0);
    CGPoint secondPoint = CGPointMake(rectCenter.x + rect.size.width * 0.35, rectCenter.y);
    CGPoint thirdPoint = CGPointMake(orignalPoint.x, rectCenter.y + rect.size.width/10.0f);
    CGPathMoveToPoint(trianglePath, nil, orignalPoint.x, orignalPoint.y);
    CGPathAddLineToPoint(trianglePath, nil, secondPoint.x, secondPoint.y);
    CGPathAddLineToPoint(trianglePath, nil, thirdPoint.x, thirdPoint.y);
    
    CGContextAddPath(ctx, trianglePath);
    
    CGContextFillPath(ctx);
    CGPathRelease(trianglePath);
}

#pragma mark - getters && setters
- (void)setItemState:(GLItemState)itemState {
    
    _itemState = itemState;
    [self setNeedsDisplay];
}

- (void)setItemDirect:(CGFloat)itemDirect {
    
    _itemDirect = itemDirect;
    [self setNeedsDisplay];
}

@end

