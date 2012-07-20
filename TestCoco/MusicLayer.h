//
//  MyCocos2DClass.h
//  TestCoco
//
//  Created by Yunke Liu on 7/17/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MusicLayer : CCLayer {
    NSMutableArray *_mainBeats;
    NSMutableArray *_offBeats;
}

@property (nonatomic, retain) NSMutableArray *mainBeats;
@property (nonatomic, retain) NSMutableArray *offBeats;

-(int)checkTouchEvent:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)addMainBeat:(id)sender;
-(void)addOffBeat:(id)sender;

@end
