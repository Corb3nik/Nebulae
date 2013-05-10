//
//  GameplayPhysicsLayer.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-11-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@class GameplayVisualsLayer;
@class GameplayTouchHandler;
@class GameplayAnimationController;
@class GameplayFlowController;
@interface GameplayPhysicsLayer : CCLayer  {
	
	cpSpace *space; // The virtual chipmunk space where simulations take place
	GameplayVisualsLayer *gameplayVisuals;
	GameplayTouchHandler *gameplayTouch;
	GameplayAnimationController *gameplayAnimation;
	GameplayFlowController *gameplayFlow;
	
	cpShape *topBorder;
	cpShape *ground;
	cpShape *leftBorder;
	cpShape *rightBorder;
	cpBody *borders;
	NSMutableArray *inGameBodies;
	
	cpBody *gBullet;
	cpBody *gBubbleSlot;
	CCSprite *gAwaitingBubble;
	
	BOOL isBulletActive;
}

@property (assign) cpSpace *space;
@property (retain) NSMutableArray *inGameBodies;
@property (assign) BOOL isBulletActive;

// Ingame Features
@property (assign) cpShape *topBorder;
@property (assign) cpShape *ground;
@property (assign) cpShape *leftBorder;
@property (assign) cpShape *rightBorder;
@property (assign) cpBody *borders;

@property (assign) cpBody *gBullet;
@property (assign) cpBody *gBubbleSlot;
@property (assign) cpBody *gAwaitingBullet;
@property (assign) CCSprite *gAwaitingBubble;

- (void) drawBubblesWithX:(int)x andY:(int)y andBubbles:(BOOL)draw;
- (void) proppelBullet;
- (void) createBorders;
- (void) generateBulletWithSprite:(CCSprite *)bulletImage andPosition:(CGPoint)point;
- (void) initializeCounterparts;
- (void) moveNewBubble;
@end
