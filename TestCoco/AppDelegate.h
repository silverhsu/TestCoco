//
//  AppDelegate.h
//  TestCoco
//
//  Created by Yunke Liu on 7/14/12.
//  Copyright Washington University in St. Louis 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class MenuLayer;

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
    
    //NSMutableArray *_levels;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

//@property (nonatomic, retain) NSMutableArray *levels;
//@property (nonatomic, retain) CCScene *mainScene;
//@property (nonatomic, retain) 

@end
