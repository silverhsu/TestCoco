//
//  Monster.m
//  TestCoco
//
//  Created by Yunke Liu on 7/16/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import "Monster.h"


@implementation Monster

@synthesize hp = _hp;
@synthesize speed = _speed;

@end


//Creeper:
//1hp
@implementation Creeper

+(id)monster
{
    Creeper *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"Icon-Small.png"] autorelease]))
    {
        monster.hp = 1;
        monster.speed = 200/1;
    }
    return monster;
}

@end


//Tank monster:
//3hp
@implementation Tank

+(id)monster
{
    Tank *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"Icon.png"] autorelease]))
    {
        monster.hp = 3;
        monster.speed = 100/1;
    }
    return monster;
}

@end