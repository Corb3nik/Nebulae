//
//  PauseMenu.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-04-02.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PauseMenu.h"
#import "DifficultyManager.h"
#import "MainMenu.h"
#import "GameModeScene.h"
#import "SimpleAudioEngine.h"
#import "GameplayFlowController.h"
@implementation PauseMenu



- (void)mainMenuScene {
	DifficultyManager *manager = [DifficultyManager sharedManager];
	[manager resetScoresWithGameOver:YES];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene] withColor:ccBLACK]];
	
}

- (void)resumeGame {
	GameplayTouchHandler *gameplayTouch = [GameModeScene sharedScene].lGameplayTouchHandler;
    GameplayFlowController *gameplayFlow = [GameModeScene sharedScene].lGameplayFlowController;
    [gameplayFlow restartTimer];
	[[SimpleAudioEngine sharedEngine] playEffect:@"Selection.mp3"];
	[gameplayTouch registerWithTouchDispatcher];
	[self removeFromParentAndCleanup:YES];
	[self release];

}
- (void)onEnter {
	[super onEnter];
	
	
	// PLay sound
	[[SimpleAudioEngine sharedEngine] playEffect:@"SelectionReverse.mp3"];
	
	// Draw the titles of the pause menu
	CCSprite *pauseMenuTitle = [CCSprite spriteWithFile:@"PauseMenu.png"];
	[pauseMenuTitle setPosition:CGPointMake(160, 240)];
	[self addChild:pauseMenuTitle z:45];
	
	// Draw the background
	CCSprite *pauseBackground = [CCSprite spriteWithFile:@"Background.png"];
	[pauseBackground setPosition:CGPointMake(160, 240)];
	[self addChild:pauseBackground z:30];
	
	// Draw the slider for the background volume
	CCControlSlider *backgroundSlider = [CCControlSlider sliderWithBackgroundFile:@"VolumeBackground.png" progressFile:@"Fill.png" thumbFile:@"Thumb.png"];
	[backgroundSlider setMinimumValue:0.0];
	[backgroundSlider setMaximumValue:0.6];
	[backgroundSlider setValue:[[SimpleAudioEngine sharedEngine] backgroundMusicVolume]];
	[backgroundSlider setPosition:CGPointMake(160, 320)];
	[backgroundSlider setTag:123];
	[self addChild:backgroundSlider z:45];
	
	[backgroundSlider addTarget:[DifficultyManager sharedManager] action:@selector(volumeChanged:) forControlEvents:CCControlEventValueChanged];
	
	//... slider for the sound effects volume
	CCControlSlider *effectBackground = [CCControlSlider sliderWithBackgroundFile:@"VolumeBackground.png" progressFile:@"Fill.png" thumbFile:@"Thumb.png"];
	[effectBackground setMinimumValue:0.0];
	[effectBackground setMaximumValue:0.6];
	[effectBackground setValue:[[SimpleAudioEngine sharedEngine] effectsVolume]];
	[effectBackground setPosition:CGPointMake(160, 260)];
	[effectBackground setTag:456];
	[self addChild:effectBackground z:45];
	
	[effectBackground addTarget:[DifficultyManager sharedManager] action:@selector(volumeChanged:) forControlEvents:CCControlEventValueChanged];

	CCMenu *menu = [CCMenu node];
	CCSprite *resumeNormal = [CCSprite spriteWithFile:@"Resume.png"];
	CCSprite *resumeSelected = [CCSprite spriteWithFile:@"Resume.png"];
	[resumeSelected setScale:1.2];
	
	CCSprite *quitNormal = [CCSprite spriteWithFile:@"Quit.png"];
	CCSprite *quitSelected = [CCSprite spriteWithFile:@"Quit.png"];
	[quitSelected setScale:1.2];
	
	CCMenuItemSprite *resume = [CCMenuItemSprite itemWithNormalSprite:resumeNormal selectedSprite:resumeSelected target:self selector:@selector(resumeGame)];
	[resume setPosition:CGPointMake(-30, -60)];
	
	CCMenuItemSprite *quit = [CCMenuItemSprite itemWithNormalSprite:quitNormal selectedSprite:quitSelected target:self selector:@selector(mainMenuScene)];
	[quit setPosition:CGPointMake(30, -140)];
	
	[menu addChild:resume];
	[menu addChild:quit];
	[self addChild:menu z:45];

}

@end
