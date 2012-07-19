//
//  Level.h
//  TestCoco
//
//  Created by Yunke Liu on 7/17/12.
//  Copyright (c) 2012 Washington University in St. Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Wave.h"

@interface Level : NSObject
{
    Level *_level;
    
    Wave *_wave;

    int _currentWave;
    int _totalWaves;
}

@property (nonatomic, retain) Level *level;
@property (nonatomic, retain) Wave *wave;
@property (nonatomic, assign) int currentWave;
@property (nonatomic, assign) int totalWaves;

-(id)action;
-(int)checkTime;
@end

