//
//  AppDelegate.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-10-11.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class DifficultyManager;
@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
	DifficultyManager *manager;
	CCDirectorIOS	*__unsafe_unretained director_;							// weak ref
}

@property (nonatomic, strong) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;

@end
