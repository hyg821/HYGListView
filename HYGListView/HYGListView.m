//
//  HYGListView.m
//  HYGListView
//
//  Created by 侯英格 on 16/5/24.
//  Copyright © 2016年 侯英格. All rights reserved.
//

#import "HYGListView.h"
#import <objc/runtime.h>

@implementation UIView (Addition)

static char*hygOldheight;

-(NSNumber *)oldHeight{
    NSNumber* number=objc_getAssociatedObject(self, & hygOldheight);
    return  number;
}

-(void)setOldHeight:(NSNumber *)oldHeight{
    objc_setAssociatedObject(self, &hygOldheight, oldHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface HYGListView()
@property(nonatomic,assign)CGSize size;
@end

@implementation HYGListView

-(instancetype)init{
    self=[super init];
    [self addNotification];
    return self;
}

-(void)addNotification{
}


-(HYGListView*)initWithViewArray:(NSMutableArray*)viewArray{
    self=[super init];
    self.viewArray=viewArray;
    return self;
}


-(void)setViewArray:(NSMutableArray *)viewArray{
    [self checkSubView];
    _viewArray=viewArray;
    [self reloadSize];
}

-(void)setViewArray:(NSMutableArray *)viewArray andAnimation:(BOOL)animation{
    [self checkSubView];
    _viewArray=viewArray;
    [self reloadSizeWithAnimation:animation];
}


-(void)checkSubView{
    if (_viewArray.count!=0) {
        for (UIView*view in self.subviews) {
            [view removeFromSuperview];
        }
        _viewArray=nil;
    }
}

-(void)reloadSize{
    self.size=CGSizeMake(self.frame.size.width,0);
    for (UIView*view in self.viewArray) {
        [self addSubview:view];
    }
    __block UIView*lastView;
    [self.viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx==0) {
            lastView.frame=CGRectMake(0, 0,self.frame.size.width,lastView.frame.size.height);
            lastView=(UIView*)obj;
        }else{
            UIView*newView=(UIView*)obj;
            newView.frame=CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height, self.frame.size.width, newView.frame.size.height);
            lastView=newView;
        }
        self.size=CGSizeMake(self.frame.size.width,self.size.height+lastView.frame.size.height);
    }];
    self.contentSize=CGSizeMake(self.frame.size.width, self.size.height);
    NSLog(@"%@",NSStringFromCGSize(self.contentSize));
}


-(void)reloadSizeWithRow:(NSInteger)row{
    self.size=CGSizeMake(self.frame.size.width,0);
    __block CGFloat viewHeight=0;
    [self.viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx==row) {
            UIView*reloadLastView=[self.viewArray objectAtIndex:row-1];
            UIView*lastView=(UIView*)obj;
            viewHeight=lastView.frame.size.height;
            lastView.frame=CGRectMake(0,reloadLastView.frame.size.height+reloadLastView.frame.origin.y,self.frame.size.width,0);
        }
        [self addSubview:(UIView*)obj];
    }];
    __block UIView*lastView;
    [UIView animateWithDuration:0.2 animations:^{
        [self.viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx<row) {
                lastView=(UIView*)obj;
                NSLog(@"%@",NSStringFromCGRect(lastView.frame));
            }
            if (idx==row) {
                UIView*reloadLastView=[self.viewArray objectAtIndex:row-1];
                lastView=(UIView*)obj;
                lastView.frame=CGRectMake(0,reloadLastView.frame.size.height+reloadLastView.frame.origin.y,self.frame.size.width,viewHeight);
            }else if(idx>row){
                UIView*newView=(UIView*)obj;
                newView.frame=CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height, self.frame.size.width, newView.frame.size.height);
                lastView=newView;
            }
            self.size=CGSizeMake(self.frame.size.width,self.size.height+lastView.frame.size.height);
            NSLog(@"idx=%lu   %f",(unsigned long)idx,self.size.height);
        }];
        self.contentSize=CGSizeMake(self.frame.size.width, self.size.height);
    }];
}


-(void)reloadSizeWithAnimation:(BOOL)animation{
    if (animation==YES) {
        [UIView animateWithDuration:0.3 animations:^{
            [self reloadSize];
        }];
    }else{
        [self reloadSize];
    }
}

-(void)reloadSizeWithRow:(NSInteger)row andAnimation:(BOOL)animation{
    if (animation==YES) {
        [self reloadSizeWithRow:row];
    }else{
        [self reloadSizeWithRow:row];
    }
}

-(void)addView:(UIView*)view WithRow:(NSInteger)row andAnimation:(BOOL)animation{
    [self.viewArray insertObject:view atIndex:row];
    [self reloadSizeWithRow:row andAnimation:animation];
}

-(void)deleteRow:(NSInteger)row{
    if (self.viewArray.count>=row+1) {
        UIView*view=[self.viewArray objectAtIndex:row];
        [self.viewArray removeObject:view];
        [self reloadSizeWithAnimation:YES];
        [self privateDeleteView:view];
    }
}

-(void)deleteView:(UIView*)view{
    for (UIView*vx in self.viewArray) {
        if ([vx isEqual:view]) {
            [self.viewArray delete:vx];
            [self reloadSizeWithAnimation:YES];
            [self privateDeleteView:vx];
            break;
        }
    }
}

-(void)privateDeleteView:(UIView*)view{
    [UIView animateWithDuration:0.2 animations:^{
        view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,0);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

-(void)scrollToRow:(NSInteger)row{
    NSLog(@"%.f",self.contentInset.top);
    if (self.viewArray.count>=row+1) {
        UIView*view=[self.viewArray objectAtIndex:row];
        NSLog(@"%f",view.frame.origin.y+view.frame.size.height);
        NSLog(@"%f",self.contentSize.height+[UIScreen mainScreen].bounds.size.height-self.contentInset.top);
        if (view.frame.origin.y+view.frame.size.height+[UIScreen mainScreen].bounds.size.height-self.contentInset.top>self.contentSize.height) {
            [self setContentOffset:CGPointMake(0, self.contentSize.height-[UIScreen mainScreen].bounds.size.height) animated:YES];
        }else{
            [self setContentOffset:CGPointMake(0, view.frame.origin.y-self.contentInset.top) animated:YES];
        }
    }
}

-(void)scrollToView:(UIView*)view{
    for (UIView*vx in self.viewArray) {
        if ([vx isEqual:view]) {
            NSInteger row= [self.viewArray indexOfObject:vx];
            [self scrollToRow:row];
        }
    }
}

/**隐藏某一行*/
-(void)hidenRow:(NSInteger)row{
    if (self.viewArray.count>=row+1) {
        UIView*view=[self.viewArray objectAtIndex:row];
        if (view.frame.size.height!=0) {
            [self privateHidenOrShow:YES WithView:view];
            [self reloadSizeWithAnimation:YES];
        }
    }
}

/**隐藏某一个view*/
-(void)hidenView:(UIView*)view{
    for (UIView*vx in self.viewArray) {
        if ([vx isEqual:view]) {
            NSInteger row= [self.viewArray indexOfObject:vx];
            [self hidenRow:row];
        }
    }
}

/**显示某一行*/
-(void)showRow:(NSInteger)row{
    if (self.viewArray.count>=row+1) {
        UIView*view=[self.viewArray objectAtIndex:row];
        [self privateHidenOrShow:NO WithView:view];
        [self reloadSizeWithAnimation:YES];
    }

}
/**显示某一个view*/
-(void)showView:(UIView*)view{
    for (UIView*vx in self.viewArray) {
        if ([vx isEqual:view]) {
            NSInteger row= [self.viewArray indexOfObject:vx];
            [self showRow:row];
        }
    }
}

-(void)privateHidenOrShow:(BOOL)showOrHiden WithView:(UIView*)view{
    //show
    if (showOrHiden==YES) {
        view.oldHeight=@(view.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 0);
        }];
    }
    //hiden
    else{
        if ([view.oldHeight doubleValue]!=0) {
            [UIView animateWithDuration:0.2 animations:^{
                view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [view.oldHeight doubleValue]);
            }];
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
