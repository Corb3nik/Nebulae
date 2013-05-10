//
//  GameplayPhysicsLayer.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-11-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "GameModeScene.h"
#import "GameplayPhysicsLayer.h"
#import "GameplayVisualsLayer.h"
#import "GameplayTouchHandler.h"
#import "GameplayAnimationController.h"
#import "GameplayFlowController.h"
#import "CPDebugLayer.h"

#import "DifficultyManager.h"




//Stand-by macro
#define IDLE 4


//Collision Types
#define BULLET_TYPE 1
#define BUBBLE_TYPE 2
#define BORDER_TYPE 3
#define TOP_BORDER 25
//Layers
#define DRAWN_BUBBLES 1
#define BUBBLE_SLOTS 2
#define SELECTED 999
#define NOT_SELECTED 666

// Groups
#define GROUND 26
// Function prototypes 
static void bulletToBubbleTransition(cpSpace *space, void *obj, void *data);
static void eachBody(cpBody *body, void *data);
void eachShape(cpShape *shape, void *data);
static void insertBulletInSlot(cpShape *shape, cpContactPointSet *points, void *data);
static int begin(cpArbiter *arb, cpSpace *space, void *data);
static void checkForColorChain(cpShape *shape, cpFloat distance, cpVect point, void *data);
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


void offsetAllBodies(cpBody *body, void *data) { // Call this function to offset all the physics bodies by 38 towards the ground

	if (body->shapeList_private->collision_type != BULLET_TYPE) { // Offset everything except the bullets
	
	body->p = ccp(body->p.x, body->p.y - 38);
		
		if (body->p.y <= 84 && body->data != nil) { // If the bubbles get pushed under the end line.
			GameplayFlowController *gameplayFlow = [GameModeScene sharedScene].lGameplayFlowController;
			gameplayFlow.isGameOver = YES;
		}
		
}
	
}


void eachShape(cpShape *shape, void *data) { // Calls this function after each collision to check for floating bubbles

	GameplayAnimationController *gameplayAnimation = [GameModeScene sharedScene].lGameplayAnimationController;
	
	
	if (shape->layers == DRAWN_BUBBLES && shape->isFloating == cpTrue && shape->collision_type == BUBBLE_TYPE) {
		
		[gameplayAnimation.unatachedBubbles addObject:[NSValue valueWithPointer:shape]]; // Add the floating bubbles to the unatachedBubbles array
		shape->group = CP_NO_GROUP; // Reset its parameters
	}
	
}




void checkForFloatingBubbles(cpShape *shape, cpFloat distance, cpVect point, void *data){
	
	
	GameplayPhysicsLayer *gameplayPhysics = [GameModeScene sharedScene].lGameplayPhysicsLayer;
	
	if (shape->collision_type == TOP_BORDER) { // If the current shape is the top border

		shape->isFloating = cpFalse; // Set the shape as a grounded shape
		
		// Use the first shape found as the starting point
		cpSpaceNearestPointQuery(shape->space_private, CGPointMake(30, gameplayPhysics.borders->p.y + 480), 75, DRAWN_BUBBLES, SELECTED, checkForFloatingBubbles, NULL); // Look for other close shapes

		cpSpaceNearestPointQuery(shape->space_private, CGPointMake(95, gameplayPhysics.borders->p.y + 480), 75, DRAWN_BUBBLES, SELECTED, checkForFloatingBubbles, NULL); // Look for other close shapes
		cpSpaceNearestPointQuery(shape->space_private, CGPointMake(170, gameplayPhysics.borders->p.y + 480), 75, DRAWN_BUBBLES, SELECTED, checkForFloatingBubbles, NULL); // Look for other close shapes
		cpSpaceNearestPointQuery(shape->space_private, CGPointMake(255, gameplayPhysics.borders->p.y + 480), 75, DRAWN_BUBBLES, SELECTED, checkForFloatingBubbles, NULL); // Look for other close shapes
		cpSpaceNearestPointQuery(shape->space_private, CGPointMake(320, gameplayPhysics.borders->p.y + 480), 75, DRAWN_BUBBLES, SELECTED, checkForFloatingBubbles, NULL); // Look for other close shapes

	}
	if (shape->layers == DRAWN_BUBBLES) {
		shape->isFloating = cpFalse;
		shape->group = SELECTED; // Make the drawn bubble unselectable

		cpSpaceNearestPointQuery(gameplayPhysics.space, shape->body->p, 50, DRAWN_BUBBLES, SELECTED, checkForFloatingBubbles, NULL); // Look for other close shapes
	}
	
	
}
static void checkForColorChain(cpShape *shape, cpFloat distance, cpVect point, void *data) {

	
	// Instances of Physics - Status and Visuals class...
	GameplayPhysicsLayer *gameplayPhysics = [GameModeScene sharedScene].lGameplayPhysicsLayer;
	GameplayAnimationController *gameplayAnimation = [GameModeScene sharedScene].lGameplayAnimationController;
	GameplayVisualsLayer *gameplayVisuals = [GameModeScene sharedScene].lGameplayVisualsLayer;
	

	// Bubble Section //
	CCSprite *shapeSprite = ( CCSprite *)(shape->body->data); // The sprite of the scanned bubble
	NSUInteger bubbleIndex = [gameplayVisuals.inGameBubbles indexOfObject:shapeSprite]; // Get the index of the bubble
	
	// Bullet Section //
	cpShape *initialBody = data; // Get the bullet
	CCSprite *initialSprite = (CCSprite *)initialBody->body->data;	// The sprite of the bullet
	NSUInteger bulletIndex = [gameplayVisuals.inGameBubbles indexOfObject:initialSprite]; // Get the index of the bullet
	
	
	
	if ([[gameplayVisuals.correspondingInGameColors objectAtIndex:bubbleIndex] isEqualToString:[gameplayVisuals.correspondingInGameColors objectAtIndex:bulletIndex]]) { // Compare the texture names
		shape->group = SELECTED;
		
		[gameplayAnimation.sameColorBubbleCounter addObject:[NSValue valueWithPointer:shape]]; // Add the same colored bubble to the array
		cpSpaceNearestPointQuery(gameplayPhysics.space, shape->body->p, 50, DRAWN_BUBBLES, SELECTED, checkForColorChain, data); // Use the same colored shape to find other shapes
		

	}
}




static void bulletToBubbleTransition(cpSpace *space, void *obj, void *data	) { // Set the properties of the bullet to be the ones of a new bubble + generate a new bullet

	GameplayVisualsLayer *gameplayVisuals = [GameModeScene sharedScene].lGameplayVisualsLayer;
	GameplayAnimationController *gameplayAnimation = [GameModeScene sharedScene].lGameplayAnimationController;
	GameplayPhysicsLayer *gameplayPhysics = [GameModeScene sharedScene].lGameplayPhysicsLayer;
	GameplayFlowController *gameplayFlow = [GameModeScene sharedScene].lGameplayFlowController;
	if (gameplayPhysics.gBubbleSlot) { //Make sure that the following lines of code do not execute twice
		
		gameplayPhysics.gBubbleSlot->data = gameplayPhysics.gBullet->data; // Set the bullet data to be the one of the slot.
		gameplayPhysics.gBubbleSlot->shapeList_private->layers = DRAWN_BUBBLES; // Transforme the slot into a bubble
		gameplayPhysics.gBubbleSlot->shapeList_private->collision_type = BUBBLE_TYPE; // Change its collision type

		
		if (gameplayPhysics.gBubbleSlot->p.y <= 84) { // Has the bubble reached the line
			gameplayFlow.isGameOver = YES;
		}
		
		
		
		// ------ //
		// Check if the bubble is touching 2 others of the same color
		checkForColorChain(gameplayPhysics.gBubbleSlot->shapeList_private, IDLE, cpv(IDLE, IDLE), gameplayPhysics.gBubbleSlot->shapeList_private);// The use of IDLE in this situation is only to fill in the needed values/We do not need these values
		
		
		// Call the animation if there are at least 3 bubbles touching
		[gameplayAnimation animateBubblePop];
		
		// ---- Remove the shape used to help travel the bullet sprite ---/
		
		cpShape *bulletShape = gameplayPhysics.gBullet->shapeList_private;
		cpBody *bulletBody = gameplayPhysics.gBullet;
		
		cpSpaceRemoveShape(space, bulletShape);
		cpSpaceRemoveBody(space, bulletBody);
		cpShapeFree(bulletShape);
		cpBodyFree(bulletBody);
		
		gameplayPhysics.gBubbleSlot = NULL;
		gameplayPhysics.gBullet = NULL;
		
		[gameplayPhysics generateBulletWithSprite:gameplayPhysics.gAwaitingBubble andPosition:CGPointMake(163, 0)]; // set the awaiting bubble as the new bullet
		[gameplayVisuals generateBulletWithPosition:CGPointMake(8, 16)]; // Create a new awaiting bubble
		

	}


}
static void eachBody(cpBody *body, void *data) // Function called for each body in the space.
{
	CCSprite *sprite = ( CCSprite *)(body->data);
	if( sprite )
    {
		[sprite setPosition: body->p];
		
	}
}
static void insertBulletInSlot(cpShape *shape, cpContactPointSet *points, void *data){ // Inserting the bullet inside the slot
	GameplayPhysicsLayer *gameplayPhysics = [GameModeScene sharedScene].lGameplayPhysicsLayer;
	gameplayPhysics.gBubbleSlot = shape->body;  // Set the overlapping shape to be stored in the global variable gBubbleSlot

		cpFloat distance = cpShapeNearestPointQuery(gameplayPhysics.gBullet->shapeList_private, gameplayPhysics.gBubbleSlot->p, NULL); // Sets the distance between the bullet and the shape slot
		if (distance < 16 && shape->klass_private->type == CP_CIRCLE_SHAPE){ // If the bubble slot has a distance of 15 or less
			cpSpaceAddPostStepCallback(gameplayPhysics.gBubbleSlot->space_private, bulletToBubbleTransition, NULL, NULL); // Replace the data from the bullet to be stored as a bubble
		}

}
	
static int begin(cpArbiter *arb, cpSpace *space, void *data){ // The bullet has touched a bubble
	
	
	CP_ARBITER_GET_SHAPES(arb, a, b) // Get the two bodies colliding and set them in the cpBodies named a and b							// a = Bullet // b = entity
	if (b->collision_type != BORDER_TYPE) {
		cpBodySetVel(a->body, cpvzero); // Make the bullet stop on impact
		cpShapeSetLayers(a ,BUBBLE_SLOTS); // Change the specs of the bubble to only capture bubble slots
		cpShapeSetGroup(a, SELECTED); // Makes sure that borders arent capturable
		cpSpaceShapeQuery(space, a, (cpSpaceShapeQueryFunc)insertBulletInSlot, a); // Query the space for shapes with the same filtering options as <a>
	}
	else {
	
		[[SimpleAudioEngine sharedEngine] playEffect:@"Ricochet.mp3"];
		return cpTrue;
	}
	return cpFalse;
}

NSString *names[] = { // Array containing the name of the files used for drawing
    @"gBlue",
    @"gGreen",
    @"gPurple",
    @"gRed",
    @"gYellow",
	nil,
};



@implementation GameplayPhysicsLayer
@synthesize space;
@synthesize inGameBodies;
@synthesize topBorder, ground, leftBorder, rightBorder, borders;
@synthesize gBullet, gAwaitingBullet, gBubbleSlot;
@synthesize gAwaitingBubble;
@synthesize isBulletActive;

//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//
//----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------////----------------METHODS----------------//

- (void)moveNewBubble { // MOve the following bubble to the gun sprite

	
	[gAwaitingBubble runAction:[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(163, 0)]rate:2]]; // MOve the sprite to the gun
	
}


- (void)drawBubblesWithX:(int)x andY:(int)y andBubbles:(BOOL)draw {
	
	NSString *name = names[arc4random() % 6];
	CCSprite *sprite = nil;
	cpBody *body;
	cpShape *shape;


	
	if (name != nil && draw == YES) { // If a color has been selected and must be draw
		// create and add sprite
		sprite = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"%@.png", name]];  // Will contain the sprite object if name isn't Nil
		[gameplayVisuals.correspondingInGameColors addObject:name]; // Add the bubble color to the first array
		[gameplayVisuals.inGameBubbles addObject:sprite]; // add its corresponding bubble in the second array
		[gameplayVisuals addChild:sprite]; //Add the sprite to the VisualsLayer for printing on the screen
		[sprite setScale:0]; // Sets the scale to 0 for the starting animation
		[sprite release];

	}
	
		
	body = cpBodyNew(5, 1); // Create a new body containing the created shape
	cpBodySetPos(body, cpv(x,y)); // Set the body to the designated position
	shape = cpCircleShapeNew(body, 16, cpv(- 3, 0)); // Create a circle with a radius of 25 pixels with an offset of 4 pixels towards the left
	cpBodySetUserData(body, ( cpDataPointer)(sprite)); // Set the data of the body to be the newly created sprite
	cpShapeSetSensor(shape, cpTrue); // Set the shape as a sensor only.
	cpShapeSetLayers(shape, DRAWN_BUBBLES); // See top of file for the layer types
	cpShapeSetCollisionType(shape, BUBBLE_TYPE);
	cpSpaceAddShape(space, shape); // Add it to the simulator
	cpSpaceAddBody(space, body); // Add it to the simulator
	
	[inGameBodies addObject:[NSValue valueWithPointer:body]]; // Keep track of all the bodies
	
	if (draw == NO || name == nil) {
		cpShapeSetLayers(shape, BUBBLE_SLOTS); // Classified as a bubble slot (no sprites)
		cpShapeSetCollisionType(shape, IDLE	);
	}
	
	

}



- (void)createBorders{
	
	
	// 4 corners of the screen
	cpVect bottomLeft = cpv(0, 0);
	cpVect bottomRight = cpv([[CCDirector sharedDirector]winSize].width, 0);
	cpVect topLeft = cpv(0, [[CCDirector sharedDirector]winSize].height);
	cpVect topRight = cpv([[CCDirector sharedDirector]winSize].width, [[CCDirector sharedDirector]winSize].height);
	
	// Create a static body containing the borders
	borders = cpBodyNew(INFINITY, INFINITY);
	borders->p = ccp(0, 0);
	
	// Create each border
	leftBorder = cpSegmentShapeNew(borders, bottomLeft, topLeft, 35); // Left border with width of 30
	rightBorder = cpSegmentShapeNew(borders, bottomRight, topRight,35); // Right border with width of 30
	topBorder = cpSegmentShapeNew(borders, topLeft, topRight, 32); // Top border with width of 5
	
	// Set the layers for each border
	cpShapeSetLayers(topBorder, CP_ALL_LAYERS);
	cpShapeSetLayers(leftBorder, CP_ALL_LAYERS);
	cpShapeSetLayers(rightBorder, CP_ALL_LAYERS);
	
	//Set the collision type for each border
	cpShapeSetCollisionType(topBorder, TOP_BORDER);
	cpShapeSetCollisionType(leftBorder, BORDER_TYPE);
	cpShapeSetCollisionType(rightBorder, BORDER_TYPE);
	
	//Set the group for each border
	cpShapeSetGroup(topBorder, SELECTED);
	cpShapeSetGroup(leftBorder, SELECTED);
	cpShapeSetGroup(rightBorder, SELECTED);

	//Shape Properties
	cpShapeSetElasticity(leftBorder, 1.0);
	cpShapeSetElasticity(rightBorder, 1.0);
	
	// Property used when comparing mid air bubbles
	topBorder->isFloating = cpFalse;

	// Add them to the space
	cpSpaceAddShape(space, leftBorder);
	cpSpaceAddShape(space, rightBorder);
	cpSpaceAddShape(space, topBorder);
	

}


- (void)proppelBullet { //Called when double tapped

	float angle; // Contains the angle of the gun
	cpVect force; //Contains the force to be used on the bullet
	DifficultyManager *manager = [DifficultyManager sharedManager];
	
	[self setIsBulletActive:YES];
	if ([gameplayVisuals.gun rotation] < 0) { // If the gun points on the left side
		angle = (90 + gameplayVisuals.gun.rotation) * (M_PI/180); // Calibrate it and set it in radians
		force = cpvforangle(angle);
		force = cpvmult(force, 3000); // Multiply the force by 3000
		force.x = force.x * -1;
		cpBodyApplyImpulse(gBullet, force, cpvzero);
	}
	
	if ([gameplayVisuals.gun rotation] > 0) { // If the gun points on the right side
		angle = (90 + gameplayVisuals.gun.rotation) * (M_PI/180);
		force = cpvforangle(angle);
		force = cpvmult(force, 3000);
		force.x = force.x * -1;
		cpBodyApplyImpulse(gBullet, force, cpvzero);
	}
	
	if ([gameplayVisuals.gun rotation] == 0) { // if the gun is centered
		
		angle = (90 + gameplayVisuals.gun.rotation) * (M_PI/180);
		force = cpvforangle(angle);
		force = cpvmult(force, 3000);
		force.x = 0;
		cpBodyApplyImpulse(gBullet, force, cpvzero);
		
	}
	[manager setShotsFired:[manager shotsFired] + 1];
	[[SimpleAudioEngine sharedEngine] playEffect:@"LaserBeam.mp3"];
}

- (void)generateBulletWithSprite:(CCSprite *)bulletImage andPosition:(CGPoint)point{


	
	// ------- Initialize the bullet ------- //
	
	if (!gBullet) {
		gBullet = cpBodyNew(5, INFINITY);
		cpSpaceAddBody(space, gBullet);
	}

	
	cpShape *bulletShape;

	
	if (CGPointEqualToPoint(point, CGPointMake(163, 0))) {
		cpBodySetPos(gBullet, point);
		bulletShape = cpCircleShapeNew(gBullet, 16, cpv(- 3, 0));// Create a circle with a radius of 25 pixels with an offset of 4 pixels towards the left
		gBullet->shapeList_private = bulletShape;
		cpBodySetUserData(gBullet, ( cpDataPointer)(bulletImage)); // Set the bullet sprite as the data for the bullet's body
		cpShapeSetCollisionType(bulletShape, BULLET_TYPE);
		cpShapeSetLayers(bulletShape, DRAWN_BUBBLES);
		cpSpaceAddShape(space, bulletShape); // Add it to space
		cpShapeSetElasticity(gBullet->shapeList_private, 1.0); //Perfect bounce

	}
	if (CGPointEqualToPoint(point, CGPointMake(8, 16))) {

		gAwaitingBubble = bulletImage;


	}

}

//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
- (void) initializeCounterparts {
	
	gameplayVisuals = [GameModeScene sharedScene].lGameplayVisualsLayer;
	gameplayTouch = [GameModeScene sharedScene].lGameplayTouchHandler;
	gameplayAnimation = [GameModeScene sharedScene].lGameplayAnimationController;
	gameplayFlow = [GameModeScene sharedScene].lGameplayFlowController;

	
}


- (void)update:(ccTime)dt { // Method called every second
	int steps = 2;
	CGFloat delta = dt/(CGFloat)steps;
	
	for(int i=0; i<steps; i++)
    {
		cpSpaceStep(space, delta);
	}
    cpSpaceEachBody(space, (cpSpaceBodyIteratorFunc)eachBody, nil);
	
	for (NSValue *value in inGameBodies) {
		cpBody *body = (cpBody*)[value pointerValue];
		CCSprite *sprite = (CCSprite *)body->data;
		
		if ([sprite visible] == NO) {
			
			body->data = NULL;
		}
		
	}
	
	
}

- (void)onEnter {

	[super onEnter];	

	[self createBorders]; // Create the borders
	[self scheduleUpdate]; // Schedule an update every frame
	
}



- (id)init
{
    self = [super init];
    if (self) {

		
		space = cpSpaceNew(); // Create the chipmunk simulation space
		inGameBodies = [[NSMutableArray alloc] init];
		cpSpaceAddCollisionHandler(space, BULLET_TYPE, BUBBLE_TYPE, (cpCollisionBeginFunc)begin, NULL, NULL, NULL, NULL);
		cpSpaceAddCollisionHandler(space, BULLET_TYPE, TOP_BORDER, (cpCollisionBeginFunc)begin, NULL, NULL, NULL, NULL);
		cpSpaceAddCollisionHandler(space, BULLET_TYPE, BORDER_TYPE, (cpCollisionBeginFunc)begin, NULL, NULL, NULL, NULL);
		isBulletActive = NO;
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"LaserBeam.mp3"];
//		CCLayer *debugLayer = [[CPDebugLayer alloc] initWithSpace:space options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CPDebugLayerDrawBBs]];
//		[[GameModeScene sharedScene] addChild:debugLayer z:20]; // higher z than your ot
	
		
    }
    return self;
}

- (void)onExit {
	
	[self removeAllChildrenWithCleanup:YES];
	[self stopAllActions];
	[self unscheduleAllSelectors];
	
	// Remove all the shapes/bodies
	for (NSValue *value in inGameBodies) {
		cpBody *body = [value pointerValue];
		cpShape *shape = body->shapeList_private;
		
		cpSpaceRemoveShape(space, shape);
		cpSpaceRemoveBody(space, body);
		cpShapeFree(shape);
		cpBodyFree(body);
	}
	// Remove Borders
	cpSpaceRemoveShape(space, leftBorder);
	cpSpaceRemoveShape(space, rightBorder);
	cpSpaceRemoveShape(space, topBorder);
	
	cpShapeFree(leftBorder);
	cpShapeFree(rightBorder);
	cpShapeFree(topBorder);
	cpBodyFree(borders);
	
	//Remove gBullet and gAwaitingBullet
	cpSpaceRemoveBody(space, gBullet);
	cpSpaceRemoveShape(space, gBullet->shapeList_private);
	cpShapeFree(gBullet->shapeList_private);
	cpBodyFree(gBullet);
	
	cpSpaceFree(space);


	[super onExit];
	
}
- (void)dealloc {

	[inGameBodies release];
	[super dealloc];

}

@end
