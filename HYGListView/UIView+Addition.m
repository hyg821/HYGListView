//
//  UIView+Addition.m
//  HYGListView
//
//  Created by 侯英格 on 16/5/25.
//  Copyright © 2016年 侯英格. All rights reserved.
//

#import "UIView+Addition.h"
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
