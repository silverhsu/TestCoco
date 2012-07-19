//
//  MyCocos2DClass.h
//  TestCoco
//
//  Created by Yunke Liu on 7/17/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MusicLayer : CCLayerColor {
    NSMutableArray *mainBeats;
    NSMutableArray *offBeats;
}
+(CCScene *) scene;

-(void)addMainBeat;
-(void)addOffBeat;
-(bool)checkBounds:(CGRect)rect;
@end
