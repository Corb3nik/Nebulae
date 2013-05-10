//
//  GameOverMenu.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-03-06.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverMenu.h"
#import "GameModeScene.h"
#import "GameplayFlowController.h"
#import "GameplayPhysicsLayer.h"
#import "MainMenu.h"
#import "DifficultyManager.h"

@implementation GameOverMenu




- (void)animateGameOverScreen {
	
	NSMutableArray *bodiesWithSprites = [[NSMutableArray alloc] init];
	NSArray *reverseArray; // The reverse array of the filtered bodiesWIthSprites array
	NSInteger i = 1; // Indexer
	
	CCTexture2D *lost = [[CCSprite spriteWithFile:@"gLost.png"] texture]; // Make bubbles gray
	
	GameplayPhysicsLayer *gameplayPhysics = [GameModeScene sharedScene].lGameplayPhysicsLayer;
	
	CCSprite *gameOver = [CCSprite spriteWithFile:@"GameOver.png"];
	[gameOver setPosition:CGPointMake(160, 400)];
	[gameOver setOpacity:0];
	

	
	// Filter bodies for sprites
	for (NSValue *value in gameplayPhysics.inGameBodies ) {
	
		cpBody *body = (cpBody *)[value pointerValue];
		
		
		if (body->data) {
			[bodiesWithSprites addObject:[NSValue valueWithPointer:body]];
		}
		
	}
	// Reverse the array of sprites found
	reverseArray = [[bodiesWithSprites reverseObjectEnumerator] allObjects];
	
	// Make them regroup at center
	for (NSValue *value in reverseArray) {
		
		cpBody *body = [value pointerValue];
		CCSprite *sprite = body->data;
		cpBodySetUserData(body, nil);
		[sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:(0.05 * i)],[CCCallFuncO actionWithTarget:sprite selector:@selector(setTexture:) object:lost],[CCDelayTime actionWithDuration:(0.05 * (arc4random() % 15))], [CCJumpBy actionWithDuration:2 position:CGPointMake(0, -1000) height:200 jumps:2], nil]];
		
	 i++;
		
	}
	
	[gameOver runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:2 *(0.05 * i)] two:[CCFadeIn actionWithDuration:0.5]]];
	[self addChild:gameOver];
	[self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:5] two:[CCCallFunc actionWithTarget:self selector:@selector(drawButtons)]]];
	
	
	[bodiesWithSprites release];
	

}

- (void)drawButtons {

	CCProgressTimer *newGameBox = [[CCProgressTimer alloc] initWithSprite:[CCSprite spriteWithFile:@"GameOverButtons.png"]];
	[newGameBox setPosition:CGPointMake(100, 270)];
	newGameBox.type = kCCProgressTimerTypeRadial;
	[newGameBox runAction:[CCProgressTo actionWithDuration:0.5 percent:100]];
	[self addChild:newGameBox];
	
	
	CCProgressTimer *quitBox = [[CCProgressTimer alloc] initWithSprite:[CCSprite spriteWithFile:@"GameOverButtons.png"]];
	[quitBox setPosition:CGPointMake(220, 200)];
	quitBox.type = kCCProgressTimerTypeRadial;
	[quitBox runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.5] two:[CCProgressTo actionWithDuration:0.5 percent:100]]];
	[self addChild:quitBox];
	
	[self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.5] two:[CCCallFunc actionWithTarget:self selector:@selector(drawLabels)]]];


}

- (void)drawLabels {

	
	CCLabelTTF *retryText = [CCLabelTTF labelWithString:@"Retry" fontName:@"Arial" fontSize:21];
	CCLabelTTF *quitText = [CCLabelTTF labelWithString:@"Quit" fontName:@"Arial" fontSize:21];
	CCMenu *menu = [[CCMenu alloc] init];
	
	retryLabel = [[CCMenuItemLabel alloc] initWithLabel:retryText target:self selector:@selector(resetScene)];
	[retryLabel setColor:ccRED];
	[retryLabel setPosition:CGPointMake(-60, 30)];
	[retryLabel setOpacity:0];
	[retryLabel runAction:[CCFadeIn actionWithDuration:0.5]];
	
	quitLabel = [[CCMenuItemLabel alloc] initWithLabel:quitText target:self selector:@selector(mainMenuScene)];
	[quitLabel setColor:ccRED];
	[quitLabel setPosition:CGPointMake(60, -40)];
	[quitLabel setOpacity:0];
	[quitLabel runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.5] two:[CCFadeIn actionWithDuration:0.5]]];
	
	[menu addChild:quitLabel];
	[menu addChild:retryLabel];
	
	[self addChild:menu z:20];
	
}


- (void)resetScene {
	
	DifficultyManager *manager = [DifficultyManager sharedManager];
	[manager resetScoresWithGameOver:YES];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameModeScene gameModeScene] withColor:ccWHITE]];


}

- (void)mainMenuScene {
	DifficultyManager *manager = [DifficultyManager sharedManager];
	[manager resetScoresWithGameOver:YES];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene] withColor:ccBLACK]];
	
}
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
- (void)dealloc {

	[retryLabel dealloc];
	[quitLabel dealloc];
	
	
	
	[super dealloc];



}
- (id)init
{
    self = [super init];
    if (self) {
		[self setIsTouchEnabled:YES];
        gameplayFlow = [GameModeScene sharedScene].lGameplayFlowController;
    }
    return self;
}
@end
