//
//  GameplayFlowController.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-02-18.
//
//

#import <Foundation/Foundation.h>
@class GameplayPhysicsLayer;
@class GameplayTouchHandler;
@class GameplayVisualsLayer;
@class GameplayAnimationController;
@class  SummaryMenu;
@class GameOverMenu;
@interface GameplayFlowController : NSObject {


	GameplayPhysicsLayer *gameplayPhysics;
	GameplayTouchHandler *gameplayTouch;
	GameplayVisualsLayer *gameplayVisuals;
	GameplayAnimationController *gameplayAnimation;
	SummaryMenu *summaryMenu;
	GameOverMenu *gameOverMenu;
	
	// Status iVars
	NSTimer *update;
	
	
}
// Status variables
@property (assign) BOOL isScreenEmpty;
@property (assign) BOOL isGameOver;
@property (assign) BOOL isGameStarted;

// Summary info
@property (retain) NSMutableArray *destroyedBubbles;
@property (retain) NSMutableArray *fallenBubbles;

//Timers
@property (retain) NSDate *start;
@property (retain) NSDate *end;


- (void) initializeCounterparts;
- (void) isLevelFinish;
- (void) addBubblesToSummaryTable:(CCSprite *) sprite fallen:(BOOL) isFallen;
- (void) showPauseMenu;
@end
