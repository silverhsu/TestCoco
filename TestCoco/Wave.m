//
//  Wave.m
//  TestCoco
//
//  Created by Yunke Liu on 7/18/12.
//  Copyright (c) 2012 Washington University in St. Louis. All rights reserved.
//

#import "Wave.h"
#import "Monster.h"

@implementation Wave

@synthesize nextSpawn = _nextSpawn;
@synthesize totalSpawns = _totalSpawns;
@synthesize startTime = _startTime;

-(id)init
{
    if((self = [super init]))
    {
        _spawnList = [[NSMutableArray alloc] init];
        _spawnTime = [[NSMutableArray alloc] init];
        _startTime = [NSDate date];
    }
    return self;
}

-(id)makeSpawn
{
    if (_nextSpawn < _totalSpawns)
    {
        Monster *monster = [_spawnList objectAtIndex:_nextSpawn];
        _nextSpawn++;
        return monster;
    }
    return nil;
}

-(int)checkTime
{
    if (_nextSpawn < _totalSpawns)
    {
        if ([[_spawnTime objectAtIndex:_nextSpawn] timeIntervalSinceNow] <= 0)
        {
            return 1;
        }
    }
    return 0;
}

-(void)dealloc
{
    [_spawnList release];
    [_spawnTime release];
    [_startTime release];
    [super dealloc];
}

@end
