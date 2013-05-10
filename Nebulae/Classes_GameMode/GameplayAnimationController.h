//
//  GameplayAnimationController.h
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
@class GameplayFlowController;
@interface GameplayAnimationController : CCLayer{

	NSMutableArray *sameColorBubbleCounter;
	NSMutableArray *unatachedBubbles;

	GameplayPhysicsLayer *gameplayPhysics;
	GameplayTouchHandler *gameplayTouch;
	GameplayVisualsLayer *gameplayVisuals;
	GameplayFlowController *gameplayFlow;
	
}

@property (retain) NSMutableArray *sameColorBubbleCounter;
@property (retain) NSMutableArray *unatachedBubbles;

- (void) initializeCounterparts;
- (void) animateBubblePop;
- (void) animateBubbleFallWithBubbles:(NSMutableArray *)bubbles;
- (void) animateBubbleAppearence;
- (void) showShortScoreWithAmount:(NSInteger)amount fallen:(BOOL)isFallen atPosition:(CGPoint)point;
- (void) startTimer;
- (void) animateWall;

@end
	