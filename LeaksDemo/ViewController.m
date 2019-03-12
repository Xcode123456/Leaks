//
//  ViewController.m
//  LeaksDemo
//
//  Created by 午马 on 2019/3/12.
//  Copyright © 2019 午马. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    TestViewController* vc = [TestViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
