//
//  Wave.h
//  TestCoco
//
//  Created by Yunke Liu on 7/18/12.
//  Copyright (c) 2012 Washington University in St. Louis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wave : NSObject
{
    NSMutableArray *_spawnList;
    NSMutableArray *_spawnTime;
    
    NSDate *_startTime;
    
    int _totalSpawns;
    
    int _nextSpawn;
}

@property (nonatomic, assign) int totalSpawns;
@property (nonatomic, assign) int nextSpawn;
@property (nonatomic, retain) NSDate *startTime;


-(id)makeSpawn;
-(int)checkTime;
-(id)nextWave;

@end
