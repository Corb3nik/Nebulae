//
//  SummaryMenu.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-03-03.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SummaryMenu.h"
#import "GameModeScene.h"
#import "GameplayFlowController.h"
#import "GameplayVisualsLayer.h"
#import "MainMenu.h"
#import "DifficultyManager.h"

@implementation SummaryMenu

- (void)animateSummaryScreen {
	
    
	elapsedTime = [gameplayFlow.end timeIntervalSinceDate:gameplayFlow.start];
    [[SimpleAudioEngine sharedEngine] stopEffect:[[DifficultyManager sharedManager] dangerSoundID]];
    [[SimpleAudioEngine sharedEngine] stopEffect:[[DifficultyManager sharedManager] alarmSoundID]];

    
	///// --------------- TITLES ------------------ /////
	// Show the "Cleared" title
	CCSprite *cleared = [CCSprite spriteWithFile:@"LevelCleared.png"];
	[cleared setPosition:CGPointMake(164, 405)];
	[cleared setOpacity:0];
	[cleared runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.5] two:[CCFadeIn actionWithDuration:0.5]]];
	[self addChild:cleared];
	
	// Show the destroyed bubbles label
	CCLabelTTF *poppedBubblesTitle = [CCLabelTTF labelWithString:@"Popped Bubbles : " fontName:@"Arial" fontSize:15];
	[poppedBubblesTitle setColor:ccGREEN];
	[poppedBubblesTitle setPosition:CGPointMake(121, 350)];
	[poppedBubblesTitle setOpacity:0];
	[poppedBubblesTitle runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:2] two:[CCFadeIn actionWithDuration:0.5]]];
	[self addChild:poppedBubblesTitle];
	

	//show the fallen bubbles label
	CCLabelTTF *droppedBubblesTitle = [CCLabelTTF labelWithString:@"Dropped Bubbles : " fontName:@"Arial" fontSize:15];
	[droppedBubblesTitle setColor:ccGREEN];
	[droppedBubblesTitle setPosition:CGPointMake(118, 330)];
	[droppedBubblesTitle setOpacity:0];
	[droppedBubblesTitle runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:2.7] two:[CCFadeIn actionWithDuration:0.5]]];
	[self addChild:droppedBubblesTitle];
	
	// Show time bonus
	CCLabelTTF *timeTitle = [CCLabelTTF labelWithString:@"Time : " fontName:@"Arial" fontSize:15];
	[timeTitle setColor:ccGREEN];
	[timeTitle setPosition:CGPointMake(160, 310)];
	[timeTitle setOpacity:0];
	[timeTitle runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:3.4] two:[CCFadeIn actionWithDuration:0.5]]];
	[self addChild:timeTitle];
	
	// show the total score label
	CCLabelTTF *totalScoreTitle = [CCLabelTTF labelWithString:@"Total Score : " fontName:@"Arial" fontSize:15];
	[totalScoreTitle setColor:ccGREEN];
	[totalScoreTitle setPosition:CGPointMake(138, 280)];
	[totalScoreTitle setOpacity:0];
	[totalScoreTitle runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:4.1] two:[CCFadeIn actionWithDuration:0.5]]];
	[self addChild:totalScoreTitle];
	
	///// ---------------- VALUES --------------------////
	
	// Destroyed Bubbles amount
	destroyedBubblesScoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:15];
	[destroyedBubblesScoreLabel setString:[NSString stringWithFormat:@"%i", gameplayFlow.destroyedBubbles.count]];
	[destroyedBubblesScoreLabel setColor:ccGREEN];
	[destroyedBubblesScoreLabel setOpacity:0];
	[destroyedBubblesScoreLabel setPosition:CGPointMake(230, 350)];
	[self addChild:destroyedBubblesScoreLabel];
	
	[destroyedBubblesScoreLabel runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:4.1] two:[CCFadeIn actionWithDuration:0.1]]];
	
	//Fallen bubbles amount
	fallenBubblesScoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:15];
	[fallenBubblesScoreLabel setString:[NSString stringWithFormat:@"%i", gameplayFlow.fallenBubbles.count]];
	[fallenBubblesScoreLabel setOpacity:0];
	[fallenBubblesScoreLabel setColor:ccGREEN];
	[fallenBubblesScoreLabel setPosition:CGPointMake(230, 330)];
	[self addChild:fallenBubblesScoreLabel];
	
	[fallenBubblesScoreLabel runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:4.8] two:[CCFadeIn actionWithDuration:0.1]]];
	
	// Time
	
	timeBonusScoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:15];
	[timeBonusScoreLabel setString:[NSString stringWithFormat:@"%0.1f", elapsedTime]];
	[timeBonusScoreLabel setOpacity:0];
	[timeBonusScoreLabel setColor:ccGREEN];
	[timeBonusScoreLabel setPosition:CGPointMake(230, 310)];
	[self addChild:timeBonusScoreLabel];
	[timeBonusScoreLabel runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:5.5] two:[CCFadeIn actionWithDuration:0.1]]];
	
	
	totalScoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:15];
	[totalScoreLabel setOpacity:0];
	[totalScoreLabel setColor:ccGREEN];
	[totalScoreLabel setPosition:CGPointMake(230, 280)];
	[self addChild:totalScoreLabel];
	
	
	// Show real score
	[destroyedBubblesScoreLabel runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:7] two:[CCCallFunc actionWithTarget:self selector:@selector(generateDestroyedBubblesScore)]]];
	[fallenBubblesScoreLabel runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:7] two:[CCCallFunc actionWithTarget:self selector:@selector(generateFallenBubblesScore)]]];
	[timeBonusScoreLabel runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:7] two:[CCCallFunc actionWithTarget:self selector:@selector(generateTimeScore)]]];
	
	[totalScoreLabel runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:7.5] two:[CCCallFunc actionWithTarget:self selector:@selector(generateTotalScore)]]];
	
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)generateDestroyedBubblesScore { // Show the popped bubbles value

	DifficultyManager *manager = [DifficultyManager sharedManager];
	
	
	// Display the calculated score
	[destroyedBubblesScoreLabel runAction:[CCFadeOut actionWithDuration:0.2]];
	[destroyedBubblesScoreLabel setString:[NSString stringWithFormat:@"%i", manager.poppedBubbleScore]];
	[destroyedBubblesScoreLabel runAction:[CCFadeIn actionWithDuration:0.2]];
	

}

- (void)generateFallenBubblesScore { // show the dropped bubbles value
	
	DifficultyManager *manager = [DifficultyManager sharedManager];
	
	// Display the calculated score
	[fallenBubblesScoreLabel runAction:[CCFadeOut actionWithDuration:0.2]];
	[fallenBubblesScoreLabel setString:[NSString stringWithFormat:@"%i", manager.droppedBubbleScore]];
	[fallenBubblesScoreLabel runAction:[CCFadeIn actionWithDuration:0.2]];
	


}
- (void)generateTimeScore { // show the time bonus

	
	DifficultyManager *manager = [DifficultyManager sharedManager];
	NSInteger score = (90 - elapsedTime) * 588;
	
	if (elapsedTime <= 15) {
		score = 50000;
	}
	//Display the calculated score
	[timeBonusScoreLabel runAction:[CCFadeOut actionWithDuration:0.2]];
	if (elapsedTime <= 90) {
	[timeBonusScoreLabel setString:[NSString stringWithFormat:@"%i", score]];
		manager.timeBonusScore = score;


	}
	else {
		[timeBonusScoreLabel setString:@"0"];
	}
	
	[gameplayVisuals updateTotalScoreLabel];
	
	[timeBonusScoreLabel runAction:[CCFadeIn actionWithDuration:0.2]];

}
- (void)generateTotalScore {

	
	DifficultyManager *manager = [DifficultyManager sharedManager];

	[gameplayVisuals updateTotalScoreLabel];
	
	
	//Display the calculated score
	
	[totalScoreLabel runAction:[CCFadeOut actionWithDuration:0.2]];
	[totalScoreLabel setString:[NSString stringWithFormat:@"%i",manager.poppedBubbleScore + manager.timeBonusScore + manager.droppedBubbleScore]];
	[totalScoreLabel runAction:[CCFadeIn actionWithDuration:0.2]];
	
	
	CCLabelTTF *nextLevelLabel = [CCLabelTTF labelWithString:@"Tap to continue" fontName:@"Arial" fontSize:25];
	[nextLevelLabel setPosition:CGPointMake(160, 140)];
	[nextLevelLabel runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCMoveBy actionWithDuration:0.5 position:CGPointMake(0, 10)] two:[CCMoveBy actionWithDuration:0.5 position:CGPointMake(0, -10)]]]];
	[nextLevelLabel setColor:ccc3(8, 220, 0)];
	[nextLevelLabel setOpacity:0];
	[nextLevelLabel runAction:[CCFadeIn actionWithDuration:0.5]];
	[self addChild:nextLevelLabel];
}

- (void)resetScene {
	
	DifficultyManager *manager = [DifficultyManager sharedManager];
	[gameplayVisuals updateTotalScoreLabel];
	
	manager.matchScore = manager.roundScore; // Sets the final score for that round
	
	[manager resetScoresWithGameOver:NO];
	[manager raiseLevel];
	[GameModeScene removeSharedScene];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameModeScene gameModeScene] withColor:ccWHITE]];
	
}

//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

	[self resetScene];
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];

	return NO;
}



- (id)init
{
    self = [super init];
    if (self) {
        
		gameplayFlow = [GameModeScene sharedScene].lGameplayFlowController;
		gameplayVisuals = [GameModeScene sharedScene].lGameplayVisualsLayer;
    }
    return self;
}

@end
