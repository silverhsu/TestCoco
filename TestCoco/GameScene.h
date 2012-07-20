//
//  GameLayer.h
//  TestCoco
//
//  Created by Yunke Liu on 7/15/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MusicLayer.h"
#import "Level.h"
#import "Monster.h"

@interface GameLayer : CCLayerColor {
    CCSprite *_player;
    CCSprite *_camera;
    int enemiesDestroyed;
    int multiplier;
    int stars;
    
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    
    Level *_currentLevel;
    
    CGSize _winSize;
    
    float xPosition,previousXPosition,xVelocity,previousXVelocity,deltaXVelocity,sensitivity;
    float velocityCap;
    float accelerationCap;
    
    float accelY;
    
    MusicLayer *_musicLayer;
}

@property (nonatomic, assign) CGSize winSize;
@property (nonatomic, retain) Level *currentLevel;
@property (nonatomic, retain) MusicLayer *musicLayer;

-(id)initWithLayer:(MusicLayer *)layer;

-(void)reset;

-(void)addTarget:(Monster *)monster;

-(void)fireProjectile;

@end

@interface GameScene : CCScene
{
    GameLayer *_gameLayer;
}

@property (nonatomic, retain) GameLayer *gameLayer;

+(id)sceneWithLevel:(Level *)level;

@end