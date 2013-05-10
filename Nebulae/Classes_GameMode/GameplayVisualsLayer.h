//
//  GameplayVisualsLayer.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-09-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@class GameplayTouchHandler;
@class GameplayPhysicsLayer;
@class GameplayAnimationController;
@class GameplayFlowController;

@interface GameplayVisualsLayer : CCLayer{
	
	int bubbleCounter; //Amount of Bubbles
	int sensitivity; //Speed at which the gun will do a 360 degree rotation

	GameplayPhysicsLayer *gameplayPhysics;
	GameplayTouchHandler *gameplayTouch;
	GameplayAnimationController *gameplayAnimation;
	GameplayFlowController *gameplayFlow;
	
	
	
}

@property (retain) NSMutableArray *inGameBubbles;
@property (retain) NSMutableArray *correspondingInGameColors;
@property (retain) CCSprite *gun;
@property (retain) CCSprite *wall;
@property (retain) CCLabelTTF *inGameTotalScoreLabel;
@property (retain) CCSprite *planetBackground;



- (void) createBubblesWithStartingPointX:(int)x Y:(int)y andAmountOfBubbles:(int)amount withBubbles:(BOOL)draw;
- (void) update:(ccTime)dt;
- (void) generateBulletWithPosition:(CGPoint)point;
- (void) initializeCounterparts;
- (void) rotateGun:(NSInteger) duration withAngle:(NSInteger)angle;
- (void) updateTotalScoreLabel;
@end
