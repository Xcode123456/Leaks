//
//  TestViewController.m
//  dfas
//
//  Created by 午马 on 2019/3/12.
//  Copyright © 2019 午马. All rights reserved.
//

#import "TestViewController.h"

#import "TestView.h"

typedef void(^testBlock)(void);
@interface TestViewController ()
@property (nonatomic,copy)testBlock tBlock;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    //MARK:---打开这个可以测试vc
    _tBlock = ^(){
        NSLog(@"%@",self);

    };
    [self addLocalView];
}


-(void)addLocalView{
    TestView*x = [[TestView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    x.backgroundColor = [UIColor greenColor];
    x.center = self.view.center;
    [self.view addSubview:x];
}

@end
