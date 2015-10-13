//
//  AirPlaneModel.m
//  打飞机练习2
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "AirPlaneModel.h"
#define SIZE ([UIScreen mainScreen ].bounds.size)
#define LEFT_LENGTH 1

@implementation AirPlaneModel

-(id)init{

    if (self = [super initWithFrame:CGRectMake((SIZE.width - 40)/2, SIZE.height - 80, 40, 40)]) {

    }
    return self;
}

-(void)moveLeftOrRight{

        
        if (-1 == self.direction.intValue ) {
        CGRect rect = self.frame;
        rect.origin.x -= LEFT_LENGTH;
        self.frame = rect;
    }
    
    if (1 == (int)self.direction.intValue) {
        CGRect rect = self.frame;
        rect.origin.x += LEFT_LENGTH;
        self.frame = rect;
    }
    

    
}

@end
