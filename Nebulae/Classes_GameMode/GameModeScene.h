//
//  GameModeScene.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-11-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CCControlExtension.h"
@class GameplayVisualsLayer;
@class GameplayPhysicsLayer;
@class GameplayTouchHandler;
@class GameplayAnimationController;
@class GameplayFlowController;

@class SummaryMenu;
@class GameOverMenu;
enum {

	tagVisualsLayer,
	tagPhysicsLayer,
	tagTouchHandler,
	tagAnimationController,
	tagSummaryMenu,
	tagGameOverMenu,
};



@interface GameModeScene : CCLayer {

}

@property (retain) GameplayVisualsLayer *lGameplayVisualsLayer;
@property (retain) GameplayPhysicsLayer *lGameplayPhysicsLayer;
@property (retain) GameplayTouchHandler *lGameplayTouchHandler;
@property (retain) GameplayAnimationController *lGameplayAnimationController;
@property (retain) GameplayFlowController *lGameplayFlowController;

@property (retain) SummaryMenu *lSummaryMenu;
@property (retain) GameOverMenu *lGameOverMenu;


@property (assign) NSInteger backgroundVolume;
@property (assign) NSInteger soundEffectVolume;



+ (CCScene*) gameModeScene; //Creates the scene containing the layers for the main gaming interface.
+ (GameModeScene*) sharedScene; //Accessor method for the GameModeScene instance.
+ (void) removeSharedScene;


- (void)volumeChanged:(CCControlSlider *)sender;
@end
