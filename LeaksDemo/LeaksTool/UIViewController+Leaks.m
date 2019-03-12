//
//  UIViewController+Leaks.m
//  dfas
//
//  Created by 午马 on 2019/3/12.
//  Copyright © 2019 午马. All rights reserved.
//

#import "UIViewController+Leaks.h"
#import <objc/message.h>
const char* key;
@implementation UIViewController (Leaks)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //替换类的方法
        [self ls_swizzleOriginSEL:@selector(viewWillAppear:) currentSEL:@selector(ls_viewWillAppear:)];
        [self ls_swizzleOriginSEL:@selector(viewWillDisappear:) currentSEL:@selector(ls_viewWillDisappear:)];
        [self ls_swizzleOriginSEL:@selector(dismissViewControllerAnimated:completion:) currentSEL:@selector(ls_dismissViewControllerAnimated:completion:)];
    });
}

+(void)ls_swizzleOriginSEL:(SEL)originSEL
                currentSEL:(SEL)currentSEL{
    Method originMethod = class_getInstanceMethod([self class], originSEL);
    Method currentMethod = class_getInstanceMethod([self class], currentSEL);
    method_exchangeImplementations(originMethod, currentMethod);
    
}
-(void)ls_viewWillAppear:(BOOL)ani{
    [self ls_viewWillAppear:ani];
    objc_setAssociatedObject(self, &key, @(NO), OBJC_ASSOCIATION_ASSIGN);
}

-(void)ls_viewWillDisappear:(BOOL)ani{
    [self ls_viewWillDisappear:ani];
    if ([objc_getAssociatedObject(self, &key) boolValue]) {
        [self willDealloc];
    }
}
- (void)ls_dismissViewControllerAnimated:(BOOL)ani completion:(void (^ __nullable)(void))comp{
    [self ls_dismissViewControllerAnimated:ani completion:comp];
    [self willDealloc];
}
         
//MARK:----即将都用dealloc
- (void)willDealloc{
    __weak typeof(self) weakSelf = self;
    //延时2s 留足释放内存时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        //TODO:----这个的原理就是通过给nil发送方法，如何不为空就执行，为nil不执行
        [strongSelf isNotDealloc];
    });
}

//MARK:----打印没有释放的vc
- (void)isNotDealloc{
    NSLog(@"🍎🍎🍎🍎🍎🍎🍎%@ is not dealloc🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎",self);
}

@end
