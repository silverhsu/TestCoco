//
//  Level1.m
//  TestCoco
//
//  Created by Yunke Liu on 7/18/12.
//  Copyright (c) 2012 Washington University in St. Louis. All rights reserved.
//

#import "Level1.h"
#import "Level1Waves.h"

@implementation Level1

-(id)init
{
    if((self = [super init]))
    {
        _wave = [[Wave1 alloc] init];
        _totalWaves = 3;
    }
    return self;
}

-(void)dealloc
{
    [_wave release];
    [super dealloc];
}

@end
