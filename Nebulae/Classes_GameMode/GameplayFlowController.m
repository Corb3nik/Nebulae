//
//  GameplayFlowController.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-02-18.
//
//
#import "GameModeScene.h"
#import "GameplayFlowController.h"
#import "GameplayVisualsLayer.h"
#import "GameplayPhysicsLayer.h"
#import "GameplayTouchHandler.h"
#import "GameplayAnimationController.h"
#import "MainMenu.h"

#import "DifficultyManager.h"
#import "SummaryMenu.h"
#import "GameOverMenu.h"
#import "PauseMenu.h"
@implementation GameplayFlowController

@synthesize isScreenEmpty;
@synthesize isGameOver;

@synthesize destroyedBubbles;
@synthesize fallenBubbles;

@synthesize start, end;
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
- (void)addBubblesToSummaryTable:(CCSprite *)sprite fallen:(BOOL)isFallen{

	if (isFallen == NO) {
		[destroyedBubbles addObject:sprite];
	}
	else {
	
		[fallenBubbles addObject:sprite];
	
	}


}
- (void)isLevelFinish {

	if (isScreenEmpty == YES) {

		[gameplayVisuals.planetBackground stopAllActions];
		end = [NSDate date];
		summaryMenu = [GameModeScene sharedScene].lSummaryMenu;
		
		[gameplayVisuals.wall runAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(160, 615)]];
		[summaryMenu animateSummaryScreen];
		
		// Disable everything
		[gameplayTouch disableAllTouches]; // Disable further touching if all the bubbles in the screen have been wiped
		[update invalidate]; //Stop the timer
	}
	
	
	
	if (isGameOver == YES) {
		
		
		[gameplayVisuals.planetBackground stopAllActions];
		gameOverMenu = [GameModeScene sharedScene].lGameOverMenu;
		
		[gameplayVisuals.wall runAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(160, 615)]];
		[gameOverMenu runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.2] two:[CCCallFunc actionWithTarget:gameOverMenu selector:@selector(animateGameOverScreen)]]];
		
		// Disable everything
		[gameplayTouch disableAllTouches]; // Disable further touching if all the bubbles in the screen have been wiped
		[update invalidate]; //Stop the timer

	}


}
- (void)showPauseMenu {
	
	PauseMenu *pauseMenu = [[PauseMenu alloc] init]; // Creates a new instance of the pause menu
    [self pauseTimer];
	[gameplayTouch disableAllTouches];
	[[GameModeScene sharedScene] addChild:pauseMenu];



}
- (void)pauseTimer {
    end = [[NSDate date]retain];
    summaryMenu.elapsedTime = summaryMenu.elapsedTime + [end timeIntervalSinceDate:start];
     
}
- (void) restartTimer {
    start = [[NSDate date]retain];
    
}
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//



- (void)initializeCounterparts {

	
	gameplayVisuals = [GameModeScene sharedScene].lGameplayVisualsLayer;
	gameplayTouch = [GameModeScene sharedScene].lGameplayTouchHandler;
	gameplayPhysics = [GameModeScene sharedScene].lGameplayPhysicsLayer;
	gameplayAnimation = [GameModeScene sharedScene].lGameplayAnimationController;
	summaryMenu = [GameModeScene sharedScene].lSummaryMenu;
}

- (id)init
{
    self = [super init];
    if (self) {
	
		
		[self setIsGameStarted:NO];
		[self setIsGameOver:NO];
		[self setIsScreenEmpty:NO];
		
		update = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(isLevelFinish) userInfo:NULL repeats:YES];

		
		destroyedBubbles = [[NSMutableArray alloc] init];
		fallenBubbles  = [[NSMutableArray alloc] init];
		
		
		
		
    }
    return self;
}

- (void)dealloc {
	
	// Release all summary arrays
	[destroyedBubbles release];
	[fallenBubbles release];
	[super dealloc];

}




@end
