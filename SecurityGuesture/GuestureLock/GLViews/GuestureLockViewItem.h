//
//  GuestureLockViewItem.h
//  SecurityGuesture
//
//  Created by Rockey on 15/11/29.
//  Copyright © 2015年 Rockey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GLItemState_unselect = 0,   /** 未选中 */
    GLItemState_select,         /** 选中 */
    GLItemState_warning         /** 选中，并且显示错误 */
} GLItemState;

@interface GuestureLockViewItem : UIView

/** item state (Item 状态)  */
@property (nonatomic, assign) GLItemState itemState;

/** item 箭头方向 */
@property (nonatomic, assign) CGFloat itemDirect;

/** item 箭头方向是否有效 */
@property (nonatomic, assign) BOOL isItemDirectValid;

@end

