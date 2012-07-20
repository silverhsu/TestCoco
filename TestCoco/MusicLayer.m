//
//  MyCocos2DClass.m
//  TestCoco
//
//  Created by Yunke Liu on 7/17/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import "MusicLayer.h"
#import "SimpleAudioEngine.h"


@implementation MusicLayer

@synthesize mainBeats = _mainBeats;
@synthesize offBeats = _offBeats;

-(id) init
{
    if((self = [super init]))
    {
        _mainBeats = [[NSMutableArray alloc] init];
        _offBeats = [[NSMutableArray alloc] init];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.mp3"];
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void)gameLogic:(ccTime)dt
{
    id delay = [CCDelayTime actionWithDuration:0.5];
    id call1 = [CCCallFunc actionWithTarget:self selector:@selector(addMainBeat:)];
    id call2 = [CCCallFunc actionWithTarget:self selector:@selector(addOffBeat:)];
    
    id sequence = [CCSequence actions:call1,delay,call1,call2,nil];
    [self runAction:sequence];
    //[self addMainBeat];
}

-(void)spriteMoveFinished:(id)sender
{
    CCSprite *sprite = sender;
    if (sprite.tag == 1)
    {
        [_mainBeats removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
    }
    else if(sprite.tag == 2)
    {
        [_offBeats removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
    }
}

-(void)addMainBeat:(id)sender
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *beat = [CCSprite spriteWithFile:@"bigtest.png"];
    beat.tag = 1;
    [_mainBeats addObject:beat];
    
    beat.position = ccp(beat.contentSize.width/2, winSize.height);
    [self addChild:beat];
    
    float speed = 5.0;
    
    id actionMove = [CCMoveTo actionWithDuration:speed position:ccp(beat.contentSize.width/2, -beat.contentSize.height/2)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [beat runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)addOffBeat:(id)sender
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *beat = [CCSprite spriteWithFile:@"RedNote.png"];
    beat.tag = 2;
    [_offBeats addObject:beat];
    
    beat.position = ccp(winSize.width - beat.contentSize.width/2, winSize.height);
    [self addChild:beat];
    
    float speed = 5.0;
    
    id actionMove = [CCMoveTo actionWithDuration:speed position:ccp(winSize.width - beat.contentSize.width/2, -beat.contentSize.height/2)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [beat runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(int)checkTouchEvent:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    CCSprite *offBeat = [_offBeats objectAtIndex:0];
    CCSprite *mainBeat = [_mainBeats objectAtIndex:0];
    
    CGRect offBeatRect = 
    CGRectMake(offBeat.position.x - (offBeat.contentSize.width/2), 
               offBeat.position.y - (offBeat.contentSize.height/2), 
               offBeat.contentSize.width, 
               offBeat.contentSize.height);
    
    CGRect mainBeatRect = 
    CGRectMake(mainBeat.position.x - (mainBeat.contentSize.width/2), 
               mainBeat.position.y - (mainBeat.contentSize.height/2), 
               mainBeat.contentSize.width, 
               mainBeat.contentSize.height);
    CGRect checkMainRect = CGRectMake(0, 0, mainBeat.contentSize.width, mainBeat.contentSize.height);
    
    CGRect checkOffRect = CGRectMake(winSize.width - offBeat.contentSize.width, 0, offBeat.contentSize.width, mainBeat.contentSize.height);
    
    if (CGRectIntersectsRect(mainBeatRect, checkMainRect) && CGRectContainsPoint(mainBeatRect, touchPoint))
    {
        [self playNice:mainBeat.position];
        [self removeChild:mainBeat cleanup:YES];
        [_mainBeats removeObject:mainBeat];
        return 1;
    }
    else if (CGRectIntersectsRect(offBeatRect, checkOffRect) && CGRectContainsPoint(offBeatRect, touchPoint))
    {
        [self playNice:offBeat.position];
        [self removeChild:offBeat cleanup:YES];
        [_offBeats removeObject:offBeat]; 
        return 2;
    }
    return 0;
}

-(void)playNice:(CGPoint)position
{
    CCSprite *nice = [CCSprite spriteWithFile:@"Nice.png"];
    nice.position = position;
    [self addChild:nice];
    id rotate = [CCEaseElasticInOut actionWithAction:[CCRotateBy actionWithDuration:0 angle:-15/360*3.1415926535*2]];
    id scale1 = [CCScaleTo actionWithDuration:0.1 scale:1.25];
    id scale2 = [CCScaleTo actionWithDuration:0.3 scale:0.25];
    id deleteSelf = [CCCallFuncN actionWithTarget:self selector:@selector(cleanUpItem:)];
    id sequence = [CCSequence actions:rotate, scale1, scale2, deleteSelf, nil];
    [nice runAction:sequence];
}

-(void)cleanUpItem:(id)sender
{
    CCSprite *sprite = sender;
    [self removeChild:sprite cleanup:YES];
}

@end
