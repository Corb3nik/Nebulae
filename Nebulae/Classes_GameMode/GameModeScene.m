//
//  GameModeScene.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-11-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameModeScene.h"
#import "GameplayVisualsLayer.h"
#import "GameplayPhysicsLayer.h"
#import "GameplayTouchHandler.h"
#import "GameplayAnimationController.h"
#import "GameplayFlowController.h"

#import "SummaryMenu.h"
#import "GameOverMenu.h"
#import "SimpleAudioEngine.h"

static GameModeScene* sGameModeScene; // Global variable that will hold the current GameModeScene object during its lifetime.

@implementation GameModeScene

@synthesize lGameplayVisualsLayer,lGameplayPhysicsLayer, lGameplayTouchHandler, lGameplayAnimationController, lGameplayFlowController, lSummaryMenu, lGameOverMenu;



+ (GameModeScene*)sharedScene{ // Getter method for the GameModeScene instance.

	return sGameModeScene;
}

+ (void) removeSharedScene { // Remove the pointer to the GameModeScene instance

	sGameModeScene = nil;

}
- (void)volumeChanged:(CCControlSlider *)sender {

	NSInteger tag = [sender tag];
	if (tag == 123) { // Background volume changed
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:[sender value]];
	}
	
	if (tag == 456) {
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:[sender value]];
	}
}
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//

+(CCScene *) gameModeScene
{
	// 'scene' is an autorelease object.
	GameModeScene *gameModeScene = [GameModeScene node];
	
	sGameModeScene.lGameplayVisualsLayer = [GameplayVisualsLayer node];
	sGameModeScene.lGameplayPhysicsLayer = [GameplayPhysicsLayer node]; // Allocate and initialize
	sGameModeScene.lGameplayTouchHandler = [GameplayTouchHandler node];
	sGameModeScene.lGameplayAnimationController = [GameplayAnimationController node];
	sGameModeScene.lGameplayFlowController = [[GameplayFlowController alloc] init];
	sGameModeScene.lSummaryMenu = [SummaryMenu node];
	sGameModeScene.lGameOverMenu = [GameOverMenu node];

	[gameModeScene addChild:gameModeScene.lGameplayVisualsLayer z:0 tag:tagVisualsLayer]; //Set as the children of gameModeScene
	[gameModeScene addChild:gameModeScene.lGameplayPhysicsLayer z:0 tag:tagPhysicsLayer];
	[gameModeScene addChild:gameModeScene.lGameplayTouchHandler z:0 tag:tagTouchHandler]; // We do not add the animation/flow controller because they are not layers to be added to the scene
	[gameModeScene addChild:gameModeScene.lGameplayAnimationController z:0 tag:tagAnimationController];
	[gameModeScene addChild:gameModeScene.lSummaryMenu z:0 tag:tagSummaryMenu];
	[gameModeScene addChild:gameModeScene.lGameOverMenu z:0 tag:tagGameOverMenu];
	
	// Initialize the references to other layers within the following classes
	[gameModeScene.lGameplayPhysicsLayer initializeCounterparts];
	[gameModeScene.lGameplayVisualsLayer initializeCounterparts];
	[gameModeScene.lGameplayTouchHandler initializeCounterparts];
	[gameModeScene.lGameplayAnimationController initializeCounterparts];
	[gameModeScene.lGameplayFlowController initializeCounterparts];
	
	
	
	
	
	return (CCScene*)gameModeScene;
}
- (void)onEnter {
	
	[super onEnter];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"StageMusic.mp3"];


}


- (id)init
{
    self = [super init];
    if (self) {
		sGameModeScene = self;
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"Alarm.mp3"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"Danger.mp3"];
		
    }
    return self;
}


- (void)onExit
{
	[self removeAllChildrenWithCleanup:YES];
	[super onExit];
}

- (void)dealloc {
	
	
	[lGameplayVisualsLayer release];
	[lGameplayPhysicsLayer release];
	[lGameplayTouchHandler release];
	[lGameplayAnimationController release];
	[lGameplayFlowController release];
	[lSummaryMenu release];
	[lGameOverMenu release];
	[super dealloc];

}
@end
