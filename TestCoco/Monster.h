//
//  Monster.h
//  TestCoco
//
//  Created by Yunke Liu on 7/16/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Monster : CCSprite {
    float _hp;
    float _speed;
    
    NSString *image;
    
    int state;
}

@property (nonatomic, assign) float hp;
@property (nonatomic, assign) float speed;

+(id)monster;
-(id)action;

@end

@interface Creeper : Monster
{
}
@end

@interface Tank : Monster
{
}
@end