//
//  HYGListView.h
//  HYGListView
//
//  Created by 侯英格 on 16/5/24.
//  Copyright © 2016年 侯英格. All rights reserved.
//


/*
    HYGListView 仅适用于 手写代码 tableview 难以复用的情况 抛弃了协议代理方式
    自己管理自己的view 大小  十分简单
 
 */


#import <UIKit/UIKit.h>

@interface HYGListView : UIScrollView
@property(nonatomic,strong)NSMutableArray*viewArray;
@property(nonatomic,assign)BOOL cellIsNeedsize;

/**初始化方法*/
-(HYGListView*)initWithViewArray:(NSMutableArray*)viewArray;

/**修改viewArray*/
-(void)setViewArray:(NSMutableArray *)viewArray;
/**修改viewArray 带动画*/
-(void)setViewArray:(NSMutableArray *)viewArray andAnimation:(BOOL)animation;

/**刷新list列表 带动画*/
-(void)reloadSizeWithAnimation:(BOOL)animation;
/**刷新列表*/
-(void)reloadSize;

/**增加一个view在某一行*/
-(void)addView:(UIView*)view WithRow:(NSInteger)row andAnimation:(BOOL)animation;
/**删除某一行的view*/
-(void)deleteRow:(NSInteger)row;
/**删除某一个view*/
-(void)deleteView:(UIView*)view;

/**滚动到某一行*/
-(void)scrollToRow:(NSInteger)row;
/**滚动到某一个view*/
-(void)scrollToView:(UIView*)view;
@end
