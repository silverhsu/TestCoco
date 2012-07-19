//
//  Game2Layer.h
//  TestCoco
//
//  Created by Yunke Liu on 7/17/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Game2Layer : CCLayerColor {
    CCSprite *player;
    int projectilesDestroyed;
    int multiplier;
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
}
+(CCScene *) scene;
-(void) addTarget;

@end
