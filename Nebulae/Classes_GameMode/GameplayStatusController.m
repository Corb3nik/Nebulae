
//
//  GameplayStatusController.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-01-25.
//
//

#import "GameplayStatusController.h"
#import "GameplayPhysicsLayer.h"
#import "GameplayVisualsLayer.h"
#import "GameplayTouchHandler.h"
#import "GameModeScene.h"


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

void eachShape(cpShape *shape, void *data);
void checkForFloatingBubbles(cpShape *shape, cpFloat distance, cpVect point, void *data);

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




@implementation GameplayStatusController
@synthesize sameColorBubbleCounter;
@synthesize connectedToBorder;
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
	
	
	for (NSValue *value in bubbles) { // Get the shape of each same-colored sprite
		
		currentShape = [value pointerValue];
		currentBubble = (__bridge CCSprite *)currentShape->body->data; // Get the sprite for the shape
			
			currentShape->body->data = NULL; //We use nil because the data pointer is supposed to be our sprite
			[currentBubble runAction:[CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.7 position:CGPointMake(currentBubble.position.x, -50)]rate:2]]; // Make the bubbles grow then pop
			cpShapeSetCollisionType(currentShape, IDLE); // Reset the shape back to the specs of a bubbleslot
			cpShapeSetLayers(currentShape, BUBBLE_SLOTS);
		

		}





}
- (void)animateBubblePop {

	NSInteger chainedBubbles = [sameColorBubbleCounter count]; // Contains number of chained bubbles

	CCSprite *currentBubble; // currently selected bubble sprite
	cpShape *currentShape; // curently selected bubble shape
	NSUInteger index;
		
	for (NSValue *value in sameColorBubbleCounter) { // Get the shape of each same-colored sprite
		
		currentShape = [value pointerValue];
		currentBubble = (__bridge CCSprite *)currentShape->body->data; // Get the sprite for the shape
		currentShape->group = CP_NO_GROUP;
		if (chainedBubbles >= 3) { // If the amount of same-colored bubbles is equal or more than 3
			
			[currentBubble runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1 scale:1.5],[[CCHide action]copy], nil]]; // Make the bubbles grow then pop
			cpShapeSetCollisionType(currentShape, IDLE); // Reset the shape back to the specs of a bubbleslot
			cpShapeSetLayers(currentShape, BUBBLE_SLOTS);
			
			
			index = [gameplayVisuals.inGameBubbles indexOfObject:currentBubble];
			[gameplayVisuals.inGameBubbles removeObjectAtIndex:index];
			[gameplayVisuals.correspondingInGameColors removeObjectAtIndex:index];
			
		}
		
	}

	if (chainedBubbles >= 3) {
		
		checkForFloatingBubbles(gameplayPhysics.topBorder, IDLE, cpv(IDLE, IDLE), NULL);
		cpSpaceEachShape(gameplayPhysics.space, eachShape, NULL);
		[self animateBubbleFallWithBubbles:unatachedBubbles];
		
	}
	
	
	for (NSValue *value in gameplayPhysics.inGameBodies) {
		cpBody *tmp = [value pointerValue];
		
		if (tmp->shapeList_private->collision_type == BUBBLE_TYPE) {
			tmp->shapeList_private->group = CP_NO_GROUP;
			tmp->shapeList_private->isFloating = cpTrue;
		}
	}
	
	[unatachedBubbles removeAllObjects];
	[sameColorBubbleCounter removeAllObjects]; // Remove all objects in the sameColorBubbleCounter array


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
	
}

- (id)init
{
    self = [super init];
    if (self) {
		
		sameColorBubbleCounter = [[NSMutableArray alloc] init];
		unatachedBubbles = [[NSMutableArray alloc] init];
		connectedToBorder = YES;
	}
    return self;
}
@end
