//
//  GameLayer.h
//  TestCoco
//
//  Created by Yunke Liu on 7/15/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Level.h"
#import "Monster.h"

@interface GameLayer : CCLayerColor {
    CCSprite *_player;
    int enemiesDestroyed;
    int multiplier;
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    Level *_currentLevel;
}

@property (nonatomic, retain) Level *currentLevel;

-(void)reset;

-(void)addTarget:(Monster *)monster;

@end

@interface GameScene : CCScene
{
    GameLayer *_layer;
}

@property (nonatomic, retain) GameLayer *layer;

+(id)sceneWithLevel:(Level *)level;

@end