//
//  AirPlaneModel.h
//  打飞机练习2
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirPlaneModel : UIButton


@property(nonatomic,copy)NSString * direction;


-(void)moveLeftOrRight;

@end
