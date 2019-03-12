//
//  UIView+Leaks.m
//  dfas
//
//  Created by 午马 on 2019/3/12.
//  Copyright © 2019 午马. All rights reserved.
//

#import "UIView+Leaks.h"
#import <objc/message.h>

@implementation UIView (Leaks)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //替换类的方法
        [self ls_swizzleOriginSEL:@selector(willMoveToSuperview:) currentSEL:@selector(ls_willMoveToSuperview:)];
    });
}

+(void)ls_swizzleOriginSEL:(SEL)originSEL
                currentSEL:(SEL)currentSEL{
    Method originMethod = class_getInstanceMethod([self class], originSEL);
    Method currentMethod = class_getInstanceMethod([self class], currentSEL);
    method_exchangeImplementations(originMethod, currentMethod);
}

-(void)ls_willMoveToSuperview:(UIView*)newView{
    
    if ([self isCustomClass]) {
        if (!newView) {
            [self willDealloc];
        }
    }
}

//MARK:----即将都用dealloc
- (void)willDealloc{
    __weak typeof(self) weakSelf = self;
    //延时3s 留足释放内存时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        //TODO:----这个的原理就是通过给nil发送方法，如何不为空就执行，为nil不执行
        [strongSelf isNotDealloc];
    });
}

//MARK:----打印没有释放的view
- (void)isNotDealloc{
    NSLog(@"🍎🍎🍎🍎🍎🍎🍎%@ is not dealloc🍎🍎🍎🍎🍎🍎🍎",NSStringFromClass([self class]));
}

- (BOOL)isCustomClass{
    NSBundle *mainB = [NSBundle bundleForClass:[self class]];
    //比较
    if (mainB == [NSBundle mainBundle]) {
        //自定义类
        return YES;
    }else{
        //系统类
        return NO;
    }
}

@end
