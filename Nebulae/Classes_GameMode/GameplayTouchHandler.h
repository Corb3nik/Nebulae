//
//  GameplayTouchHandler.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-12-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@class GameplayPhysicsLayer;
@class GameplayVisualsLayer;
@class GameplayAnimationController;
@class GameplayFlowController;

@interface GameplayTouchHandler : CCLayer <CCTargetedTouchDelegate> {
	
	GameplayPhysicsLayer *gameplayPhysics;
	GameplayVisualsLayer *gameplayVisuals;
	GameplayAnimationController *gameplayAnimation;
	GameplayFlowController *gameplayFlow;
	UITapGestureRecognizer *tapRecognizer;
	UISwipeGestureRecognizer *swipeRecognizer;

}

- (void) initializeCounterparts;
- (void) disableAllTouches;
- (void) doubleTap;
@end
