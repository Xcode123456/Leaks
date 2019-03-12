//
//  UINavigationController+Leaks.m
//  dfas
//
//  Created by 午马 on 2019/3/12.
//  Copyright © 2019 午马. All rights reserved.
//

#import "UINavigationController+Leaks.h"
#import <objc/message.h>
extern const char * key;
@implementation UINavigationController (Leaks)
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //MARK:---重写这个的目的是为了检测在堆栈中的VC，不检测不在堆栈中的VC（eg 一开始初始化的几个nav）
        [self ls_swizzleOriginSEL:@selector(popViewControllerAnimated:) currentSEL: @selector(ls_popViewControllerAnimated:)];
    });
}
+(void)ls_swizzleOriginSEL:(SEL)originSEL
                currentSEL:(SEL)currentSEL{
    Method originMethod = class_getInstanceMethod([self class], originSEL);
    Method currentMethod = class_getInstanceMethod([self class], currentSEL);
    method_exchangeImplementations(originMethod, currentMethod);
}

- (UIViewController *)ls_popViewControllerAnimated:(BOOL)animated{
    UIViewController * popVC = [self ls_popViewControllerAnimated:animated];
    objc_setAssociatedObject(popVC, &key, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return popVC;
}
@end
