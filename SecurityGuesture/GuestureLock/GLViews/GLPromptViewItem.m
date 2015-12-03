//
//  GLPromptViewItem.m
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import "GLPromptViewItem.h"
#import "GLMacros.h"

@implementation GLPromptViewItem

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *color = _isSelected ? m_colorGLPromptItemUnselected : m_colorGLPromptItemSelected;
    
    [color set];
    
    [self drawCircle:ctx rect:rect];
}

- (void)drawCircle:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGMutablePathRef unselectedCirclePath = CGPathCreateMutable();
    CGFloat wh = rect.size.width - 2.0f;
    CGFloat origineX = rect.origin.x + 1.0f;
    CGFloat origineY = rect.origin.y + 1.0f;
    CGRect circleRect = CGRectMake(origineX, origineY, wh, wh);
    CGContextAddEllipseInRect(ctx, circleRect);
    CGContextSetLineWidth(ctx, m_numGLLineWidth);
    CGContextAddPath(ctx, unselectedCirclePath);
    if (_isSelected) {
        CGContextFillEllipseInRect(ctx, circleRect);
    }
    CGContextStrokePath(ctx);
    CGPathRelease(unselectedCirclePath);
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    [self setNeedsDisplay];
}

@end

