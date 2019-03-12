//
//  TestView.h
//  dfas
//
//  Created by 午马 on 2019/3/12.
//  Copyright © 2019 午马. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^testBlock)(void);

@interface TestView : UIView
@property (nonatomic,copy)testBlock tBlock;

@end

NS_ASSUME_NONNULL_END
