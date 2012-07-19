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

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MusicLayer *layer = [MusicLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if((self = [super initWithColor:ccc4(255, 255, 255, 255)]))
    {
        mainBeats = [[NSMutableArray alloc] init];
        offBeats = [[NSMutableArray alloc] init];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.mp3"];
        self.isTouchEnabled = YES;
        
        //projectilesDestroyed = 0;
        //multiplier = 1;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        //player = [CCSprite spriteWithFile:@"Icon-Small.png"];
        //player.position = ccp(winSize.width/2, player.contentSize.height/2);
        //[self addChild:player];
        
        [self schedule:@selector(gameLogic1:) interval:2.0];
        //[self schedule:@selector(gameLogic2:) interval:1.0];
        //[self schedule:@selector(update:)];
    }
    return self;
}

-(void) gameLogic1:(ccTime)dt
{
    id delay = [CCDelayTime actionWithDuration:1];
    id call1 = [CCCallFuncN actionWithTarget:self selector:@selector(addMainBeat:)];
    id call2 = [CCCallFuncN actionWithTarget:self selector:@selector(addOffBeat:)];
    
    id sequence = [CCSequence actions:call1,delay,call2,nil];
    [self runAction:sequence];
}
/*
-(void)gameLogic2:(ccTime)dt
{
    id delay = [CCDelayTime actionWithDuration:0.5];
    id sequence = [CCSequence actions: delay, nil];
    [self runAction:sequence];
    [self addOffBeat];
}*/

-(void)addMainBeat:(id)sender
{
    CCSprite *beat = [CCSprite spriteWithFile:@"Icon-Small.png"];
    beat.tag = 1;
    [mainBeats addObject:beat];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    beat.position = ccp(beat.contentSize.width/2, winSize.height);
    [self addChild:beat];
    
    float speed = 5.0;
    
    id actionMove = [CCMoveTo actionWithDuration:speed position:ccp(beat.contentSize.width/2, -beat.contentSize.height/2)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [beat runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)addOffBeat:(id)sender
{
    CCSprite *beat = [CCSprite spriteWithFile:@"Icon-Small.png"];
    beat.tag = 2;
    [offBeats addObject:beat];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    beat.position = ccp(winSize.width - beat.contentSize.width/2, winSize.height);
    [self addChild:beat];
    
    float speed = 5.0;
    
    id actionMove = [CCMoveTo actionWithDuration:speed position:ccp(winSize.width - beat.contentSize.width/2, -beat.contentSize.height/2)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [beat runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)spriteMoveFinished:(id)sender
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *sprite = (CCSprite *)sender;
    if (sprite.tag == 1)
    {
        [mainBeats removeObject:sprite];
    }
    else
    {
        [offBeats removeObject:sprite];
    }
    [self removeChild:sprite cleanup:YES];
    
    
    /*
    if (sprite.tag == 1 && sprite.position.y > -sprite.contentSize.height/2)
    {
        Monster * temp = (Monster *)sender;
        int direction = (sprite.position.x < sprite.contentSize.width) ? 0:1;
        
        NSLog(@"%f",temp.speed);
        
        int speed = winSize.width/temp.speed;	
        id actionMove = [CCMoveTo actionWithDuration:speed position:(direction == 1) ? ccp(sprite.contentSize.width/2,sprite.position.y-30) : ccp(winSize.width - sprite.contentSize.width/2,sprite.position.y-30)];
        id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
        //[[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];	
        [sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    }
    else
    {
        if (sprite.tag == 2)
        {
            [_projectiles removeObject:sprite];
        }
        else
        {
            GameOverScene *gameOverScene = [GameOverScene node];
            [gameOverScene.layer.label setString:[NSString stringWithFormat:@"You Lose: %d targets destroyed",projectilesDestroyed]];
            [_targets removeObject:sprite];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
        [self removeChild:sprite cleanup:YES];
    }
     */
}

-(bool)checkBound:(CGRect)rect
{
            [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
    CGRect checkRect =
    CGRectMake(0, rect.size.height, rect.size.width, rect.size.height);

    return CGRectIntersectsRect(rect, checkRect);
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];

    CCSprite *offBeat = [offBeats objectAtIndex:0];
    CCSprite *mainBeat = [mainBeats objectAtIndex:0];
    
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
        [self removeChild:mainBeat cleanup:YES];
        [mainBeats removeObject:mainBeat];
        [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
    }
    else if (CGRectIntersectsRect(offBeatRect, checkOffRect) && CGRectContainsPoint(offBeatRect, touchPoint))
    {
        [self removeChild:offBeat cleanup:YES];
        [offBeats removeObject:offBeat];       
        [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
    }
    
    /*
    for (int i = 0; i < 2; i++)
    {
        CCSprite *projectile = [CCSprite spriteWithFile:@"yunkeball.png"];
        projectile.position = ccp(winSize.width/2,player.contentSize.height/2);
        projectile.tag = 2;
        [_projectiles addObject:projectile];
        
        float offX = location.x - projectile.position.x;
        float offY = location.y - projectile.position.y;
        
        if (offY <= 0) return; //should never happen
        
        float ratio = offX/offY;
        
        float yDist = sqrtf(powf(winSize.height,2.0) + powf(winSize.height * ratio,2.0));
        float xDist = sqrtf(powf(winSize.width/2.0/ratio,2.0) + powf(winSize.width/2.0,2.0));
        
        CGPoint endPoint;
        if (xDist >= yDist)
        {
            endPoint = ccp(winSize.width/2.0 + winSize.height * ratio,winSize.height);
        }
        else
        {
            endPoint = ccp(ratio / fabsf(ratio) * (winSize.width/2) + winSize.width/2, winSize.width/2.0 / fabsf(ratio));
        }
        
        [self addChild:projectile];
        float distance = sqrtf(powf((endPoint.x - projectile.position.x),2) + powf((endPoint.y - projectile.position.y),2));
        
        float velocity = 200/1;
        float time = distance/velocity;
        
        id actionMove = [CCMoveTo actionWithDuration:time position:endPoint];
        [projectile runAction:[CCSequence actions:actionMove,[CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],nil]];
    }
     */
}
/*
-(void) update:(ccTime)dt
{
    NSMutableArray *targetsHit = [[NSMutableArray alloc] init];   
    for (Monster *target in _targets)
    {
        CGRect targetRect = 
        CGRectMake(target.position.x - (target.contentSize.width/2), 
                   target.position.y - (target.contentSize.height/2), 
                   target.contentSize.width, 
                   target.contentSize.height);
        
        NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
        
        for (CCSprite *projectile in _projectiles)
        {
            CGRect projectileRect = 
            CGRectMake(projectile.position.x - (projectile.contentSize.width/2),
                       projectile.position.y - (projectile.contentSize.height/2),
                       projectile.contentSize.width,
                       projectile.contentSize.height);
            if (CGRectIntersectsRect(projectileRect, targetRect))
            {
                [projectilesToDelete addObject:projectile];
            }
        }
        
        for (CCSprite *projectile in projectilesToDelete)
        {
            [_projectiles removeObject:projectile];
            [self removeChild:projectile cleanup:YES];
        }
        
        if (projectilesToDelete.count > 0)
        {
            [targetsHit addObject:target];
        }
        [projectilesToDelete release];
    }
    for (Monster *target in targetsHit)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
        if (target.hp > 1)
        {
            target.hp--;
        }
        else
        {
            //[[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
            [_targets removeObject:target];
            projectilesDestroyed += 1;
            [self removeChild:target cleanup:YES];
        }
    }
    [targetsHit release];
}*/

@end
