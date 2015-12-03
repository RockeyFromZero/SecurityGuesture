//
//  GLPromptView.m
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import "GLPromptView.h"
#import "GLPromptViewItem.h"

#import "GLMacros.h"

@interface GLPromptView ()

/** Items */
@property (nonatomic, copy) NSArray *itemsArray;

@end

@implementation GLPromptView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubElements];
    }
    return self;
}

- (void)loadSubElements {
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        GLPromptViewItem *item = [[GLPromptViewItem alloc] init];
        item.tag = i;
        item.backgroundColor = [UIColor clearColor];
        [self addSubview:item];
        [array addObject:item];
    }
    self.itemsArray = array;
}

- (void)layoutSubviews {
    
    CGFloat wh = (ViewWidth(self) - 6 * m_numGLLineWidth)/3.0f;
    for (GLPromptViewItem *item in self.itemsArray) {
        CGFloat originalX = item.tag/3 * wh + (2 * item.tag/3 + 1) * m_numGLLineWidth;
        CGFloat originalY = item.tag%3 * wh + 2 * (item.tag%3 + 1) * m_numGLLineWidth;
        item.frame = CGRectMake(originalX, originalY, wh, wh);
    }
}

- (void)drawRect:(CGRect)rect {
    
    for (int i = 0; i < _selectedItems.count; i++) {
        NSInteger index = [self.selectedItems[i] integerValue];
        GLPromptViewItem *item = self.itemsArray[index];
        item.isSelected = YES;
    }
}

#pragma mark - setters && getters
- (NSArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [NSArray array];
    }
    return _itemsArray;
}

- (void)setSelectedItems:(NSArray *)selectedItems {
    
    _selectedItems = selectedItems;
    [self setNeedsDisplay];
}

@end

