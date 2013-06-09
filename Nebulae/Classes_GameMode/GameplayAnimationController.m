
//
//  GameplayAnimationController.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-01-25.
//
//

#import "GameplayAnimationController.h"
#import "GameplayPhysicsLayer.h"
#import "GameplayVisualsLayer.h"
#import "GameplayTouchHandler.h"
#import "GameplayFlowController.h"
#import "GameModeScene.h"

#import "DifficultyManager.h"

//Stand-by macro
#define IDLE 4


//Collision Types
#define BULLET_TYPE 1
#define BUBBLE_TYPE 2
#define BORDER_TYPE 3
//Layers
#define DRAWN_BUBBLES 1
#define BUBBLE_SLOTS 2

//Groups
#define SELECTED 999
#define REMOVE_SLOTS 10
#define REMOVE_BULLET 20
#define REMOVE_BUBBLES 30

// Function prototypes declared in the GameplayPhysicsLayer class
void eachShape(cpShape *shape, void *data);
void checkForFloatingBubbles(cpShape *shape, cpFloat distance, cpVect point, void *data);
void offsetAllBodies(cpBody *body, void *data);
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//
//-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----////-----Functions-----//




@implementation GameplayAnimationController
@synthesize sameColorBubbleCounter;
@synthesize unatachedBubbles;


//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
- (void)animateBubbleFallWithBubbles:(NSMutableArray *)bubbles {
		
	CCSprite *currentBubble; // currently selected bubble sprite
	cpShape *currentShape; // curently selected bubble shape
	NSUInteger index;
	CGPoint initialPosition = CGPointMake(0, 0);

	for (NSValue *value in bubbles) { // Get the shape of each same-colored sprite
		
		currentShape = [value pointerValue];
		currentBubble = ( CCSprite *)currentShape->body->data; // Get the sprite for the shape
        
        if ([[[CCDirector sharedDirector ] view] gestureRecognizers] != Nil) { // If the user is unable to touch, do not play this effect
            [[SimpleAudioEngine sharedEngine] playEffect:@"Fall.mp3"];
        }

			currentShape->body->data = NULL; //We use nil because the data pointer is supposed to be our sprite
			[currentBubble runAction:[CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.7 position:CGPointMake(currentBubble.position.x, -100)]rate:2]]; // Make the bubbles grow then pop
			cpShapeSetCollisionType(currentShape, IDLE); // Reset the shape back to the specs of a bubbleslot
			cpShapeSetLayers(currentShape, BUBBLE_SLOTS);
		
		[gameplayFlow addBubblesToSummaryTable:currentBubble fallen:YES];
		
		
		index = [gameplayVisuals.inGameBubbles indexOfObject:currentBubble]; // Remove the fallen bubbles from the Corresponding and inGameBubbles array
		[gameplayVisuals.inGameBubbles removeObjectAtIndex:index];
		[gameplayVisuals.correspondingInGameColors removeObjectAtIndex:index];
		
		if (CGPointEqualToPoint(initialPosition, CGPointZero)) {
			initialPosition = [currentBubble position];
			[self showShortScoreWithAmount:[bubbles count] fallen:YES atPosition:initialPosition];
		}
		
		}
   


}

- (void)animateBubblePop {

	NSInteger chainedBubbles = [sameColorBubbleCounter count]; // Contains number of chained bubbles

	CCSprite *currentBubble; // currently selected bubble sprite
	cpShape *currentShape; // curently selected bubble shape
	NSUInteger index;
	CGPoint initialPosition = CGPointMake(0, 0);
	
	DifficultyManager *manager = [DifficultyManager sharedManager];

	
		
	for (NSValue *value in sameColorBubbleCounter) { // Get the shape of each same-colored sprite
		
		currentShape = [value pointerValue];
		currentBubble = ( CCSprite *)currentShape->body->data; // Get the sprite for the shape
		currentShape->group = CP_NO_GROUP;
        
		if (chainedBubbles >= 3) { // If the amount of same-colored bubbles is equal or more than 3
			
			[currentBubble runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1 scale:1.5],[CCHide action], nil]]; // Make the bubbles grow then pop
			cpShapeSetCollisionType(currentShape, IDLE); // Reset the shape back to the specs of a bubbleslot
			cpShapeSetLayers(currentShape, BUBBLE_SLOTS);
			
			[gameplayFlow addBubblesToSummaryTable:currentBubble fallen:NO] ;
		
			index = [gameplayVisuals.inGameBubbles indexOfObject:currentBubble]; // Remove the popped bubbles from the Corresponding and inGameBubbles array
			[gameplayVisuals.inGameBubbles removeObjectAtIndex:index];
			[gameplayVisuals.correspondingInGameColors removeObjectAtIndex:index];
			
			
			if (CGPointEqualToPoint(initialPosition, CGPointZero)) { // Run the short score animation once
				initialPosition = [currentBubble position];
				[self showShortScoreWithAmount:chainedBubbles fallen:NO atPosition:initialPosition];
			}
			
			if (currentShape->body->p.y <= 84) { // IF the bubble on the first row is popped - Do not end the game
				gameplayFlow.isGameOver = NO;
                
			}
			[[SimpleAudioEngine sharedEngine] playEffect:@"Explosion.mp3"];
		}
		
	}

		checkForFloatingBubbles(gameplayPhysics.topBorder, IDLE, cpv(IDLE, IDLE), NULL); // Check for floating bubbles
		cpSpaceEachShape(gameplayPhysics.space, eachShape, NULL); // Add each floating bubble in an array
		[self animateBubbleFallWithBubbles:unatachedBubbles]; // Animate the bubbles falling
	
	
	
	
	for (NSValue *value in gameplayPhysics.inGameBodies) { // Reset the group and Floating variables after scanning for floating Bubbles.
		cpBody *tmp = [value pointerValue];
		
		if (tmp->shapeList_private->collision_type == BUBBLE_TYPE) {
			tmp->shapeList_private->group = CP_NO_GROUP;
			tmp->shapeList_private->isFloating = cpTrue;
		}
	}
	[unatachedBubbles removeAllObjects]; // Remove all objets in the unatachedBubbles array
	[sameColorBubbleCounter removeAllObjects]; // Remove all objects in the sameColorBubbleCounter array
	
	if ([gameplayVisuals.inGameBubbles count] <= 1) {

		gameplayFlow.isScreenEmpty = YES;
	}
	
	[manager isShotAmountReached];

gameplayPhysics.isBulletActive = NO; // Set the bullet inactive

}
// ------ Bubble Generation ----- //
- (void)animateBubbleAppearence	{

	float time = 0.2;
	NSInteger index = 1;
	for (CCSprite *sprite in gameplayVisuals.inGameBubbles) {
		time = time + 0.2;
       CCAction *playSoundWhilePop = [CCSpawn actionOne:[CCScaleTo actionWithDuration:0.3 scale:0.8] two:[CCCallFuncO actionWithTarget:[SimpleAudioEngine sharedEngine] selector:@selector(playEffect:) object:@"Pop.mp3"]];
        
        [sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:time],playSoundWhilePop, nil]];

		index++;
	
	}
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:(index * 0.2)], [CCCallFunc actionWithTarget:gameplayTouch selector:@selector(registerWithTouchDispatcher)],[CCCallFunc actionWithTarget:self selector:@selector(startTimer)], nil]];


}

// ------ Wall animation ---- //
- (void)animateWall {
	
	NSInteger X = gameplayVisuals.wall.position.x; // Get the X and Y position of the wall
	NSInteger Y = gameplayVisuals.wall.position.y;
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"WallSlam.mp3"];
	[gameplayVisuals.wall setPosition:CGPointMake(X,Y - 38)]; // Offset the wall by 38 pixels
	cpSpaceEachBody(gameplayPhysics.space, offsetAllBodies, NULL); // MOve all the bodies in the sapce by 38 pixels
	gameplayPhysics.borders->p = ccp(gameplayPhysics.borders->p.x, gameplayPhysics.borders->p.y - 38); // MOve the borders

	[gameplayVisuals.planetBackground stopAllActions];
	[[DifficultyManager sharedManager] setShotsFired:0];
	[[DifficultyManager sharedManager] setAmountOfShotsForNextWallDropFromRemainingColors:gameplayVisuals.correspondingInGameColors];
}
- (void)showShortScoreWithAmount:(NSInteger)amount fallen:(BOOL)isFallen atPosition:(CGPoint)point {

	DifficultyManager *manager = [DifficultyManager sharedManager];

	
	
	if (gameplayFlow.isGameStarted == YES) { // Do not use scores from bubbles popped at map generation
		
		NSInteger score; // Contains the score for the group
		CCLabelTTF *scoreLabel = [[[CCLabelTTF alloc] init] autorelease]; // This will show the score
		
		if (isFallen == NO	) { // If the bubble was popped
			score = (pow(2, amount)) * 10;
			manager.poppedBubbleScore = manager.poppedBubbleScore + score;
		}
		if (isFallen == YES) { // iF the bubble fell
			score = (pow(2, amount)) * 20;
			manager.droppedBubbleScore = manager.droppedBubbleScore + score;
		}
		
		[scoreLabel setString:[NSString stringWithFormat:@"+%i", score]]; // Set the score
		[scoreLabel setFontName:@"Arial"];
		[scoreLabel setFontSize:25];
		[scoreLabel setPosition:point];
		
		if (score >= 500) { // If there are more than 5 bubbles popped or 4 fallen bubbles
			[scoreLabel setColor:ccGREEN]; // Show text green
			[scoreLabel setFontSize:28];
		}
		if (score >= 1000) { // if there are more than 10 bubbles popped / 7 bubbles fallen
			[scoreLabel setColor:ccGOLD]; // Show text golden
			[scoreLabel setFontSize:35];
		}
		
		// Update the ingame total score
		[gameplayVisuals updateTotalScoreLabel];
		[scoreLabel runAction:[CCSpawn actionOne:[CCMoveBy actionWithDuration:1 position:CGPointMake(0, 60)]two:[CCFadeOut actionWithDuration:1]]];
		[self addChild:scoreLabel];
		
	}
}

//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//

- (void)startTimer { // Starts the timer of the wall (green bar on the left side)
	[gameplayFlow setIsGameStarted:YES];
	gameplayFlow.start = [NSDate date];
}



- (void)initializeCounterparts {

	gameplayVisuals = [GameModeScene sharedScene].lGameplayVisualsLayer;
	gameplayTouch = [GameModeScene sharedScene].lGameplayTouchHandler;
	gameplayPhysics = [GameModeScene sharedScene].lGameplayPhysicsLayer;
	gameplayFlow = [GameModeScene sharedScene].lGameplayFlowController;

}

- (void)onEnterTransitionDidFinish { // Animate bubble pop once the transition is finish
	[super onEnterTransitionDidFinish];
	
	[self animateBubbleAppearence];
}

- (void)onEnter {
	[super onEnter];
	[self animateBubblePop];

}
- (id)init
{
    self = [super init];
    if (self) {
	
		sameColorBubbleCounter = [[NSMutableArray alloc] init];
		unatachedBubbles = [[NSMutableArray alloc] init];

		
	}
    return self;
}

- (void)dealloc {

	[sameColorBubbleCounter release];
	[unatachedBubbles release];
	[super dealloc];

}
@end
