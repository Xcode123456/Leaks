//
//  TestView.m
//  dfas
//
//  Created by 午马 on 2019/3/12.
//  Copyright © 2019 午马. All rights reserved.
//

#import "TestView.h"

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tBlock = ^(){
            NSLog(@"%@",self);
        };
    }
    return self;
}
-(void)dealloc{
    
    NSLog(@"%@---dealloc",self);
    
}


@end
