//
//  Level.m
//  TestCoco
//
//  Created by Yunke Liu on 7/17/12.
//  Copyright (c) 2012 Washington University in St. Louis. All rights reserved.
//

#import "Level.h"
#import "Monster.h"

@implementation Level

@synthesize level = _level;
@synthesize wave = _wave;
@synthesize currentWave = _currentWave;
@synthesize totalWaves = _totalWaves;

//bg music
//generic beats
-(id)init
{
    if((self = [super init]))
    {
        _currentWave = 1;
    }
    return self;
}
-(id)action
{
    Monster *monster = [_wave makeSpawn];
    
    return monster;
}

-(int)checkTime
{
    return [_wave checkTime];
}

-(void)nextWave
{
    _wave = [_wave nextWave];
    _currentWave++;
}

-(void)dealloc
{
    _currentWave = 1;
    [_wave release];
    [super dealloc];
}

@end