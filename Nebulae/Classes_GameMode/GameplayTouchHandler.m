//
//  GameplayTouchHandler.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-12-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameplayTouchHandler.h"
#import "GameModeScene.h"
#import "GameplayPhysicsLayer.h"
#import "GameplayVisualsLayer.h"
#import "GameplayAnimationController.h"
#import "GameplayFlowController.h"
#import "DifficultyManager.h"


@implementation GameplayTouchHandler 

- (void)doubleTap {

	if ([gameplayPhysics isBulletActive] == NO) {
		
	[gameplayPhysics proppelBullet];
	[gameplayPhysics moveNewBubble];

	}
}

//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//

- (void) initializeCounterparts {
	
	gameplayPhysics = [GameModeScene sharedScene].lGameplayPhysicsLayer;
	gameplayVisuals = [GameModeScene sharedScene].lGameplayVisualsLayer;
	gameplayAnimation = [GameModeScene sharedScene].lGameplayAnimationController;
	gameplayFlow = [GameModeScene sharedScene].lGameplayFlowController;
	
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	
	
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event { // IF the person dragged his finger

	// Current Point
	CGPoint B = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	B = CGPointMake(B.x - 163, B.y); 
	
	// If there are no gesture recognizers activated on swipe
	if ([[touch gestureRecognizers] count] == 0) {
	// Get the angle
	float angle = -CC_RADIANS_TO_DEGREES(ccpToAngle(B)) + 90;
	// Apply it to the gun rotation
	[gameplayVisuals.gun setRotation:angle];
	}
}


-(void) registerWithTouchDispatcher
{
	
	// All the necessary parameters regarding touching
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	
	tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
	[tapRecognizer setNumberOfTapsRequired:2];
	[[[CCDirector sharedDirector] view] addGestureRecognizer:tapRecognizer];
	
	swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:gameplayFlow action:@selector(showPauseMenu)];
	[swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
	[swipeRecognizer setNumberOfTouchesRequired:2];
	[[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRecognizer];
}
- (void)disableAllTouches {
	// Remove all touch parameters
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[[[CCDirector sharedDirector]view]removeGestureRecognizer:tapRecognizer];
	[[[CCDirector sharedDirector]view]removeGestureRecognizer:swipeRecognizer];

}



- (void)dealloc {

	
	[tapRecognizer release];
	[swipeRecognizer release];
	[super dealloc];
	
}
@end
