//
//  GameplayStatusController.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-01-25.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
@class GameplayPhysicsLayer;
@class GameplayTouchHandler;
@class GameplayVisualsLayer;

@interface GameplayStatusController : NSObject{

	NSMutableArray *sameColorBubbleCounter;
	NSMutableArray *unatachedBubbles;
	BOOL connectedToBorder;
	
	GameplayPhysicsLayer *gameplayPhysics;
	GameplayTouchHandler *gameplayTouch;
	GameplayVisualsLayer *gameplayVisuals;
}

@property (strong) NSMutableArray *sameColorBubbleCounter;
@property (strong) NSMutableArray *unatachedBubbles;
@property BOOL connectedToBorder;

- (void) initializeCounterparts;
- (void) animateBubblePop;
- (void) animateBubbleFallWithBubbles:(NSMutableArray *)bubbles;
@end
	