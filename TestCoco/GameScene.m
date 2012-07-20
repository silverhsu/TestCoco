//
//  GameLayer.m
//  TestCoco
//
//  Created by Yunke Liu on 7/15/12.
//  Copyright 2012 Washington University in St. Louis. All rights reserved.
//

#import "GameScene.h"
#import "MusicLayer.h"
#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"

@implementation GameScene

@synthesize gameLayer = _gameLayer;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(id) sceneWithLevel:(Level *)level
{
	// 'scene' is an autorelease object.
	GameScene *scene = [GameScene node];
	
    MusicLayer *musicLayer = [MusicLayer node];
    
	// 'layer' is an autorelease object.
    GameLayer *gameLayer = [[[GameLayer alloc] initWithLayer:musicLayer] autorelease];
    
    gameLayer.currentLevel = level;
    
	// add layer as a child to scene
	[scene addChild: gameLayer];
    [scene addChild: musicLayer];
    
	// return the scene
    return scene;
}

-(void)dealloc
{
    self.gameLayer = nil;
    [super dealloc];
}

@end

@implementation GameLayer

@synthesize musicLayer = _musicLayer;
@synthesize currentLevel = _currentLevel;
@synthesize winSize = _winSize;

-(id)initWithLayer:(MusicLayer *)layer
{
    if((self = [self init]))
    {
        _musicLayer = layer;
        [_musicLayer schedule:@selector(gameLogic:) interval:1.0];
    }
    return self;
}

-(id) init
{
    if((self = [super initWithColor:ccc4(0, 0, 0, 0)]))
    {
        _targets = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.mp3"];
        self.isTouchEnabled = YES;
        
        enemiesDestroyed = 0;
        multiplier = 1;
        stars = 0;
        
        CGSize wSize = [[CCDirector sharedDirector] winSize];
        
        CGRect world = CGRectMake(0, 0, (wSize.width*2)-100, wSize.height);
        
        _winSize = world.size;
        
        //_winSize = [[CCDirector sharedDirector] winSize];
        _player = [CCSprite spriteWithFile:@"Icon-Small.png"];
        _player.position = ccp(_winSize.width/2, _player.contentSize.height/2);
        [self addChild:_player];
        
        _camera = [CCSprite node];
        //_camera.position = ccp(_
        _player.position = ccp(_winSize.width/2, _player.contentSize.height/2);
        
        [self runAction:[CCFollow actionWithTarget:_player worldBoundary:world]];
        
        // Sets variables for movement to proper initial values
        velocityCap = 12.0;
        accelerationCap = 7.0;
        xPosition = _player.position.x;
        previousXPosition = xPosition;
        xVelocity = 0.0;
        previousXVelocity = 0.0;
        deltaXVelocity = 0.0;
        sensitivity = 3.0*_winSize.width;
        
        self.isAccelerometerEnabled = YES;
        
        while (stars < 100)
        {
            [self makeStars];
            stars++;
        }
        
        [self scheduleUpdate];
        
        [self schedule:@selector(gameLogic:)];
    }
    return self;
}

-(void)makeStars
{
    float x = fmodf(arc4random(),_winSize.width);
    float y = fmodf(arc4random(), _winSize.height);
    
    CCSprite *star = [CCSprite node];
    star.position = ccp(x,y);
    
    [self addChild:star];
    [self drawPoint:star.position];
    star.tag = 3;
    
    int duration = _winSize.width/50.0;    
    
    id actionMove = [CCMoveTo actionWithDuration:duration position:ccp(x,0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [star runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)drawPoint:(CGPoint)point
{
    NSLog(@"here");
    glColorMask(255, 255, 255, 255);
    glLineWidth(5.0);
    ccDrawLine(point, _player.position);
    
    //ccDrawPoint(point);
}

-(void)reset
{
    for (CCSprite *target in _targets)
    {
        [self removeChild:target cleanup:YES];
    }
    [_targets removeAllObjects];
    
    for (CCSprite *projectile in _projectiles)
    {
        [self removeChild:projectile cleanup:YES];
    }
    [_projectiles removeAllObjects];
    
    //REMOVE BACKGROUND CODE GOES HERE
    
    //ADD NEW BACKGROUND CODE GOES HERE
    
    //SET CURRENT BACKGROUND TO NEW BG
    
    self.isTouchEnabled = YES;
        
    [self schedule:@selector(update:)];
    [self schedule:@selector(gameLogic:)];
}

-(void) gameLogic:(ccTime)dt
{
    if ((_currentLevel.wave.nextSpawn < _currentLevel.wave.totalSpawns) && ([_currentLevel checkTime] == 1))
    {
        Monster *monster = [_currentLevel action];
        if (monster != nil)
            [self addTarget:monster];
    }
}


-(void) update:(ccTime)dt
{
 /*   while(stars < 100)
    {
        glEnable(GL_LINES);
        glColorMask(255, 255, 255, 255);
        CGPoint p = ccp(_winSize.width/2,_winSize.height/2);
        ccDrawLine(p, _player.position);
        NSLog(@"here");
        stars++;
    }
   */ 
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
            //[[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"]; //PLAY OTHER SOUND
            [_targets removeObject:target];
            enemiesDestroyed += 1;
            [self removeChild:target cleanup:YES];
        }
    }
    [targetsHit release];
    
    //PLAYER MOVEMENT
        
    // Calculates velocity based on appropriate accelerometer data and crops to Velocity Cap
    xVelocity = accelY * dt * sensitivity;
    xVelocity = max(min(velocityCap, xVelocity),-velocityCap);
        
    // Calculates delta velocity aka acceleration and crops to Acceleration Cap
    deltaXVelocity = xVelocity - previousXVelocity;
    deltaXVelocity = max(min(accelerationCap, deltaXVelocity),-accelerationCap);
    
    // Combines elements for position and caps to limits of window size
    xPosition = previousXPosition + previousXVelocity + deltaXVelocity;
    xPosition = max(min(_winSize.width, xPosition), 0);
    
    _player.position = ccp(xPosition,_player.position.y);
    
    previousXPosition = xPosition;
    previousXVelocity = xVelocity;
    
    
    if ((_currentLevel.wave.nextSpawn == _currentLevel.wave.totalSpawns) && ([_targets count] == 0))
    {
        //[self unschedule:@selector(update:)];
        //[self unschedule:@selector(gameLogic:)];
//        [currentLevel nextWave]; <- for parallel stages!!!
        if (_currentLevel.currentWave < _currentLevel.totalWaves)
        {
            /*id delay = [CCDelayTime actionWithDuration:4];
            id nextWave = [CCCallFunc actionWithTarget:_currentLevel selector:@selector()];
            id reset = [CCCallFunc actionWithTarget:self selector:@selector(reset:)];
            id sequence = [CCSequence actions:delay, nextWave, reset, nil];
            [self runAction:sequence];*/
            [_currentLevel nextWave];
            [self reset];
        }
        else
        {
            GameOverScene *gameOverScene = [GameOverScene node];
            [gameOverScene.layer.label setString:[NSString stringWithFormat:@"You Win",enemiesDestroyed]];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
    }
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
#define kFilteringFactor 0.1
#define kRestAccelX -0.6
#define kShipMaxPointsPerSec (winSize.height*0.5)
#define kMaxDiffX 0.2
    
    UIAccelerationValue rollingY;
    
    rollingY = (acceleration.y * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor));
    
    accelY = acceleration.y - rollingY;
}

-(void) spriteMoveFinished:(id)sender
{
    CCSprite *sprite = (CCSprite *)sender;

    if (sprite.tag == 3)
    {
        float x = fmodf(arc4random(),_winSize.width);
        
        sprite.position = ccp(x,_winSize.height);
                        
        int speed = _winSize.width/50.0;    
        
        id actionMove = [CCMoveTo actionWithDuration:speed position:ccp(x,0)];
        id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
        [sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    }
    
    if (sprite.tag == 1 && sprite.position.y > -sprite.contentSize.height/2)
    {
        Monster * temp = (Monster *)sender;
        int direction = (sprite.position.x < sprite.contentSize.width) ? 0:1;
        
        int speed = _winSize.width/temp.speed;	
        id actionMove = [CCMoveTo actionWithDuration:speed position:(direction == 1) ? ccp(sprite.contentSize.width/2,sprite.position.y-30) : ccp(_winSize.width - sprite.contentSize.width/2,sprite.position.y-30)];
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
            [gameOverScene.layer.label setString:[NSString stringWithFormat:@"You Lose: %d targets destroyed",enemiesDestroyed]];
            [_targets removeObject:sprite];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
        [self removeChild:sprite cleanup:YES];
    }
}

-(void) addTarget:(Monster *)monster
{
    //CCSprite *target = [CCSprite spriteWithFile:@"Icon.png"];
    Monster *target = monster;
    
    target.tag = 1;
    [_targets addObject:target];
    
    int actualY = _winSize.height;
    
    target.position = ccp(_winSize.width + (target.contentSize.width/2), actualY);
    [self addChild:target];

    int speed = _winSize.width/target.speed;    
    
    id actionMove = [CCMoveTo actionWithDuration:speed position:ccp(target.contentSize.width/2,actualY-30)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    int fire = [_musicLayer checkTouchEvent:touches withEvent:event];
    if (fire == 1 || fire == 2)
    {
        [self fireProjectile];
    }
}

-(void)cleanUpItem:(id)sender
{
    CCSprite *sprite = sender;
    [self removeChild:sprite cleanup:YES];
}

-(void)fireProjectile
{
    CCSprite *projectile = [CCSprite spriteWithFile:@"yunkeball.png"];
    projectile.position = ccp(_player.position.x,_player.position.y);
    projectile.tag = 2;
    [_projectiles addObject:projectile];

    CGPoint endPoint;
    endPoint = ccp(projectile.position.x,_winSize.height+projectile.contentSize.height/2);
    
    [self addChild:projectile];
    float distance = sqrtf(powf((endPoint.x - projectile.position.x),2) + powf((endPoint.y - projectile.position.y),2));
    
    float velocity = 200/1;
    float time = distance/velocity;
    
    id actionMove = [CCMoveTo actionWithDuration:time position:endPoint];
    [projectile runAction:[CCSequence actions:actionMove,[CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],nil]];
}

/*
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];

    for (int i = 0; i < 2; i++)
    {
    CCSprite *projectile = [CCSprite spriteWithFile:@"yunkeball.png"];
    projectile.position = ccp(winSize.width/2,_player.contentSize.height/2);
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
}
*/

-(void) dealloc
{
    [_targets release];
    _targets = nil;
    [_projectiles release];
    _projectiles = nil;
    
    [super dealloc];
}

@end
