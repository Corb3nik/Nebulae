//
//  GameplayVisualsLayer.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-09-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameModeScene.h"
#import "GameplayVisualsLayer.h"
#import "GameplayPhysicsLayer.h"
#import "GameplayTouchHandler.h"
#import "GameplayAnimationController.h"
#import "GameplayFlowController.h"

#import "DifficultyManager.h"


NSString *maps[] = {

	@"moon5.png",
	@"DeadPlanet.png"

};

@implementation GameplayVisualsLayer

//Properties
@synthesize inGameBubbles;
@synthesize correspondingInGameColors;
@synthesize gun;
@synthesize wall;
@synthesize inGameTotalScoreLabel;
@synthesize planetBackground;

//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//

- (void)createBubblesWithStartingPointX:(int)x Y:(int)y andAmountOfBubbles:(int)amount withBubbles:(BOOL)draw{ //Create the level

	int newX = x; // Will contain the newly assigned x coordinate
	
	for (int i = 1; i <= amount; i++) { // Create the amount of bubbles asked
		
		[gameplayPhysics drawBubblesWithX:newX andY:y andBubbles:draw];
		newX = x + (i * 43); //Set the newly created x coordinate
		
		
		
	}
}




- (void)generateBulletWithPosition:(CGPoint)point {
	
	CCSprite *selectedSprite; // Contains the selected sprite to be used as a bullet
	NSString *spriteFrame;
	NSInteger n = [inGameBubbles count]; // Number of bubbles ingame
	NSArray *tmp;
	if (n > 0) {

		tmp = [[NSSet setWithArray:correspondingInGameColors] allObjects];
		
		if (tmp.count > 0) {
			spriteFrame = [tmp objectAtIndex:rand() % [tmp count]];
			//		selectedSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", spriteFrame]]; // Contains the bullet
			selectedSprite = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"%@.png", spriteFrame ]];
			[correspondingInGameColors addObject:spriteFrame]; // Add the bubble color to the first array
			[inGameBubbles addObject:selectedSprite]; // add its corresponding bubble in the second array
			
			[selectedSprite setOpacity:0];
			[selectedSprite setScale:0.8];
			[selectedSprite setPosition:point];
			[self addChild:selectedSprite]; // Add it in the scene
			[selectedSprite runAction:[CCFadeIn actionWithDuration:0.7]]; // Make the following bubble fade in
			
			[gameplayPhysics generateBulletWithSprite:selectedSprite andPosition:point]; // Generate the shapes
			[selectedSprite release]; // Decrement the selectedSprite retain count by 1 (-1)
		}
	}

}

- (void)rotateGun:(NSInteger)duration withAngle:(NSInteger)angle {

		[gun runAction:[CCRotateBy actionWithDuration:sensitivity angle:angle]]; // Rotate the gun by 360 degrees either towards the left or the right

}
- (void)updateTotalScoreLabel { // Use the variable stored in the difficulty manager to update the score label with an animation

	DifficultyManager *manager = [DifficultyManager sharedManager];
	
	manager.roundScore = manager.poppedBubbleScore + manager.droppedBubbleScore + manager.timeBonusScore + manager.matchScore;
	
	//Set the value of the score
	[inGameTotalScoreLabel setString:[NSString stringWithFormat:@"%i", manager.roundScore]];
	//Do a zoom-in/zoom-out motion
	[inGameTotalScoreLabel runAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:0.2 scale:1.2] two:[CCScaleTo actionWithDuration:0.2 scale:1]]];


}
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//

- (void) initializeCounterparts {

	gameplayPhysics = [GameModeScene sharedScene].lGameplayPhysicsLayer;
	gameplayTouch = [GameModeScene sharedScene].lGameplayTouchHandler;
	gameplayAnimation = [GameModeScene sharedScene].lGameplayAnimationController;
	gameplayFlow = [GameModeScene sharedScene].lGameplayFlowController;

}


- (void)update:(ccTime)dt{ //Check if the gun reaches an angle of 50 or -50 then stop the current rotation action
	
	//Rotation of the gun and when to stop it
	if (gun.rotation < -70 || gun.rotation > 70) {
		[gun stopAllActions];
		(gun.rotation < -70) ? (gun.rotation = -70): (gun.rotation = 70);
	}
	
	
}

- (void)onEnter {

	[super onEnter];
	

	DifficultyManager *manager = [DifficultyManager sharedManager];
	
	//Show window size
	int width = [[CCDirector sharedDirector] winSize].width;

	//Add in game bubbles
	[self createBubblesWithStartingPointX:56 Y:426 andAmountOfBubbles:6 withBubbles:YES];
	[self createBubblesWithStartingPointX:79 Y:388 andAmountOfBubbles:5 withBubbles:YES];
	[self createBubblesWithStartingPointX:56 Y:350 andAmountOfBubbles:6 withBubbles:YES];
	[self createBubblesWithStartingPointX:79 Y:312 andAmountOfBubbles:5 withBubbles:YES];
	[self createBubblesWithStartingPointX:56 Y:274 andAmountOfBubbles:6 withBubbles:YES];
	[self createBubblesWithStartingPointX:79 Y:236 andAmountOfBubbles:5 withBubbles:YES];
	[self createBubblesWithStartingPointX:56 Y:198 andAmountOfBubbles:6 withBubbles:NO];
	[self createBubblesWithStartingPointX:79 Y:160 andAmountOfBubbles:5 withBubbles:NO];
	[self createBubblesWithStartingPointX:56 Y:122 andAmountOfBubbles:6 withBubbles:NO];
	[self createBubblesWithStartingPointX:79 Y:84 andAmountOfBubbles:5 withBubbles:NO];

	
	//Add gun
	gun = [CCSprite spriteWithFile:@"RailGun.png"];
	[gun setPosition:ccp(width/2 , 0)];
	[gun setAnchorPoint:ccp(0.49, 0.28)];
	[gun setScale:0.5];
	[self addChild:gun z:-1];

	//Add bullet
	[self generateBulletWithPosition:CGPointMake(163, 0)]; //Generates the first bullet in the game
	[self generateBulletWithPosition:CGPointMake(8, 16)];

	//Schedule the update method
	[self scheduleUpdate];
	
	// Draw background
	
	NSString *chosenMap = maps[arc4random() % 2];
	
	if ([chosenMap isEqualToString:@"moon5.png"]) {
		planetBackground = [CCSprite spriteWithFile:chosenMap ];
		[planetBackground setPosition:CGPointMake(200, 170)];
		[planetBackground setScale:0.2];
	}
	
	if ([chosenMap isEqualToString:@"DeadPlanet.png"]) {
		planetBackground = [CCSprite spriteWithFile:chosenMap];
		[planetBackground setPosition:CGPointMake(0, -200)];
	}

	[self addChild:planetBackground z:-5];
	
	// Draw borders
	CCSprite *gameBorders = [CCSprite spriteWithFile:@"GameBorders.png"];
	[gameBorders setPosition:CGPointMake(160, 240)];
	[self addChild:gameBorders z:5	];
	
	// Draw the laser beam
	CCSprite *laserBeam = [CCSprite spriteWithFile:@"LaserBeam.png"];
	[laserBeam setPosition:CGPointMake(160, 84)];
	[laserBeam setScaleY:0.5];
	[self addChild:laserBeam];
	
	// Draw the wall
	wall = [CCSprite spriteWithFile:@"Wall.png"];
	[wall setPosition:CGPointMake(160, 615)];
	[self addChild:wall];
	
	// Draw the in game score label (top right)
	inGameTotalScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", manager.matchScore] fontName:@"Arial" fontSize:15];
	[inGameTotalScoreLabel setPosition:CGPointMake(223, 463)];
	[self addChild:inGameTotalScoreLabel z:6];
	
	// Draw the level label on the left side of the screen
	CCLabelTTF *stageLabel = [CCLabelTTF labelWithString:@"Stage" dimensions:CGSizeMake(10, 170) hAlignment:UITextAlignmentCenter vAlignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeClip fontName:@"HelveticaNeue-Bold" fontSize:15];
	CCLabelTTF *levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", [manager level]] dimensions:CGSizeMake(20, 50) hAlignment:UITextAlignmentCenter fontName:@"HelveticaNeue-Bold" fontSize:15];
	[stageLabel setColor:ccGREEN];
	[stageLabel setPosition:CGPointMake(15, 130)];
	[levelLabel setColor:ccGREEN];
	[levelLabel setPosition:CGPointMake(15, 50)];
	[self addChild:levelLabel z:15];
	[self addChild:stageLabel z:15];

	
	//Check all the displayed colors
	[manager setAmountOfShotsForNextWallDropFromRemainingColors:correspondingInGameColors];
	
	
}
- (void)onEnterTransitionDidFinish {
	[super onEnterTransitionDidFinish];

	DifficultyManager *manager = [DifficultyManager sharedManager];
	NSInteger firstDigit = [manager level] / 10; // Get the first digit of the level number
	NSInteger secondDigit = [manager level] % 10; // Second digit
	
	CCSprite *stage = [CCSprite spriteWithFile:@"Stage.png"]; // Show the stage label
	[stage setOpacity:0];
	[stage setPosition:CGPointMake(180, 240)];
	[stage runAction:[CCSequence actions:[CCFadeIn actionWithDuration:1], [CCDelayTime actionWithDuration:1], [CCFadeOut actionWithDuration:1], nil]];

	
	CCSprite *firstDigitLabel = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i.png", firstDigit]]; // Show the first digit
	[firstDigitLabel setPosition:CGPointMake(150, 240)];
	[firstDigitLabel setOpacity:0];
	[firstDigitLabel runAction:[CCSequence actions:[CCFadeIn actionWithDuration:1],[CCDelayTime actionWithDuration:1],[CCFadeOut actionWithDuration:1], nil]];
	[self addChild:firstDigitLabel z:15];

	CCSprite *secondDigitLabel = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i.png", secondDigit]]; // Show the second digit
	[secondDigitLabel setPosition:CGPointMake(180, 240)];
	[secondDigitLabel setOpacity:0];
	[secondDigitLabel runAction:[CCSequence actions:[CCFadeIn actionWithDuration:1],[CCDelayTime actionWithDuration:1],[CCFadeOut actionWithDuration:1], nil]];
	[self addChild:secondDigitLabel z:15];
	
	
	
	
	[self addChild: stage z:15];
}
- (id)init
{
    self = [super init];
    if (self) {

		//Instance Variables Initialization
		bubbleCounter = 0;
		sensitivity = 4;
		inGameBubbles = [[NSMutableArray alloc] init];
		correspondingInGameColors = [[NSMutableArray alloc] init];

		
		
	}
    return self;
}


- (void)dealloc {

	// Release properties
	[inGameBubbles release];
	[correspondingInGameColors release];
	[super dealloc];
}
@end