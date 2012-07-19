//
//  Level1Wave.m
//  TestCoco
//
//  Created by Yunke Liu on 7/18/12.
//  Copyright (c) 2012 Washington University in St. Louis. All rights reserved.
//

#import "Level1Waves.h"
#import "Monster.h"

@implementation Wave1

-(id)init
{
    if((self = [super init]))
    {
        for (int i = 0; i < 30; i++)
        {
            [_spawnList addObject:[Creeper monster]];
            [_spawnTime addObject:[_startTime dateByAddingTimeInterval:1.0*i]];
        }
        
        _nextSpawn = 0;
        _totalSpawns = [_spawnList count];
        
    }
    return self;
}

-(id)nextWave
{
    return [[Wave2 alloc] init];
}

@end

@implementation Wave2

-(id)init
{
    if((self = [super init]))
    {
        for (int i = 0; i < 15; i++)
        {
            [_spawnList addObject:[Tank monster]];
            [_spawnTime addObject:[_startTime dateByAddingTimeInterval:1.5*i]];
        }
        
        _nextSpawn = 0;
        _totalSpawns = [_spawnList count];
        
    }
    return self;
}

-(id)nextWave
{
    return [[Wave3 alloc] init];
}
@end


@implementation Wave3

-(id)init
{
    if((self = [super init]))
    {
        for (int i = 0; i < 5; i++)
        {
            [_spawnList addObject:[Tank monster]];
            [_spawnTime addObject:[_startTime dateByAddingTimeInterval:1.5*i]];
        }
        
        for (int i = 5; i < 15; i++)
        {
            [_spawnList addObject:[Creeper monster]];
            [_spawnTime addObject:[_startTime dateByAddingTimeInterval:2.0*i]];
        }
        
        _nextSpawn = 0;
        _totalSpawns = [_spawnList count];
        
    }
    return self;
}

//-(id)nextWave
//{
//    return [[Wave3 alloc] init];
//}
@end