//
//  GameOverLayer.h
//  TestCoco
//
//  Created by Yunke Liu on 7/15/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
    CCLabelTTF *_label;
}
@property (nonatomic,retain) CCLabelTTF *label;
@end

@interface GameOverScene : CCScene {
    GameOverLayer *_layer;
}
@property (nonatomic,retain) GameOverLayer *layer;
@end