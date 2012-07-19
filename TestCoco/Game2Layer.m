//
//  Game2Layer.m
//  TestCoco
//
//  Created by Yunke Liu on 7/17/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import "Game2Layer.h"
#import "Monster.h"
#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"

@implementation Game2Layer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Game2Layer *layer = [Game2Layer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) gameLogic:(ccTime)dt
{
    /*    if (multiplier * 10 < projectilesDestroyed)
     {
     multiplier++;
     }
     for (int i = 0; i < multiplier; i++)
     {
     [self addTarget];
     }
     */
    [self addTarget];
}

-(void) spriteMoveFinished:(id)sender
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *sprite = (CCSprite *)sender;
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
}

-(void) addTarget
{
    //CCSprite *target = [CCSprite spriteWithFile:@"Icon.png"];
    Monster *target = nil;
    if ((projectilesDestroyed != 0) && ((projectilesDestroyed % 4) == 0))
    {
        target = [Tank monster];
    }
    else
    {
        target = [Creeper monster];
    }
    
    target.tag = 1;
    [_targets addObject:target];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //int minY = target.contentSize.height/2;
    //int maxY = winSize.height - target.contentSize.height/2;
    //int rangeY = maxY - minY;
    //int actualY = (arc4random() % rangeY) + minY;
    int actualY = winSize.height;
    
    target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
    [self addChild:target];
    NSLog(@"%f",target.speed);
    NSLog(@"%f",winSize.width);
    NSLog(@"%f",target.speed/winSize.width);
    int speed = winSize.width/target.speed;//.85;//target.speed/winSize.width;
    
    //int speed = 3.0;
    
    id actionMove = [CCMoveTo actionWithDuration:speed position:ccp(target.contentSize.width/2,actualY-30)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    
    
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
}

-(id) init
{
    if((self = [super initWithColor:ccc4(255, 255, 255, 255)]))
    {
        _targets = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.mp3"];
        self.isTouchEnabled = YES;
        
        projectilesDestroyed = 0;
        multiplier = 1;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        player = [CCSprite spriteWithFile:@"Icon-Small.png"];
        player.position = ccp(winSize.width/2, player.contentSize.height/2);
        [self addChild:player];
        
        [self schedule:@selector(gameLogic:) interval:1.0];
        [self schedule:@selector(update:)];
    }
    return self;
}

-(void) dealloc
{
    [_targets release];
    _targets = nil;
    [_projectiles release];
    _projectiles = nil;
    
    [super dealloc];
}

@end
