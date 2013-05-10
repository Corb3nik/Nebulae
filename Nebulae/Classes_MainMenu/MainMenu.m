//
//  HelloWorldLayer.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-09-15.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "MainMenu.h"
#import "AppDelegate.h"
#import "GameModeScene.h"
#pragma mark - MainMenu

// HelloWorldLayer implementation
@implementation MainMenu

// Helper class method that creates a Scene with the MainMenu as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) changeSceneToGameMode {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2 scene:[GameModeScene gameModeScene] withColor:ccBLACK]];


}
- (void)drawPlayButton {

	UIBezierPath *path = [UIBezierPath bezierPath];
	CGPoint position = ccpAdd(ccp(160, 240),[playButton position]);
	position = [[CCDirector sharedDirector] convertToGL: position];
	CGPoint play1 = CGPointMake(position.x -20, position.y + 20);
	CGPoint play2 = CGPointMake(position.x - 100, position.y + 20);
	
	// Create a trajectory for the path
	playTrajectory = [CAShapeLayer layer];
	[path moveToPoint: position];
	[path addLineToPoint:play1];
	[path moveToPoint:play1];
	[path addLineToPoint:play2];
	
	// Set its attributes
	[playTrajectory setPath:path.CGPath];
	[playTrajectory setStrokeColor:[[UIColor greenColor] CGColor]];
	[playTrajectory setFillColor:[[UIColor blackColor] CGColor]];
	[playTrajectory setLineWidth:1];
	[playTrajectory setStrokeEnd:0.0];
	// Draw it.
	[[CCDirector sharedDirector].view.layer addSublayer:playTrajectory];
	
	// Add text
	playLabel = [CCLabelTTF labelWithString:@"Play" fontName:@"Arial" fontSize:20];
	[playLabel setPosition:[[CCDirector sharedDirector] convertToUI:CGPointMake(play2.x + 20, play2.y - 10)]];
	 [playLabel setColor:ccGREEN];
	[playLabel setOpacity:0];
	
	[self addChild:playLabel];


}
- (void)drawSettingsButton {

	
	UIBezierPath *path = [UIBezierPath bezierPath];
	CGPoint position = ccpAdd(ccp(160, 240),[settingsButton position]);
	position = [[CCDirector sharedDirector] convertToGL:position];
	CGPoint play1 = CGPointMake(position.x - 20, position.y - 20);
	CGPoint play2 = CGPointMake(position.x - 160, position.y - 20);
	
	// Create a trajectory for the path
	settingsTrajectory = [CAShapeLayer layer];
	[path moveToPoint: position];
	[path addLineToPoint:play1];
	[path moveToPoint:play1];
	[path addLineToPoint:play2	];
	
	// Set its attributes
	[settingsTrajectory setPath:path.CGPath];
	[settingsTrajectory setStrokeColor:[[UIColor greenColor] CGColor]];
	[settingsTrajectory setFillColor:[[UIColor blackColor] CGColor]];
	[settingsTrajectory setLineWidth:1];
	[settingsTrajectory setStrokeEnd:0.0];
	// Draw it.
	[[CCDirector sharedDirector].view.layer addSublayer:settingsTrajectory];
	
	// Add text
	settingsLabel = [CCLabelTTF labelWithString:@"Settings" fontName:@"Arial" fontSize:20];
	[settingsLabel setPosition:[[CCDirector sharedDirector] convertToUI:CGPointMake(play2.x + 40, play2.y - 10)]];
	[settingsLabel setColor:ccGREEN];
	[settingsLabel setOpacity:0];
	
	[self addChild:settingsLabel z:2];


}

- (void)animateLine	{
	
	if ([playLabel self]) {
		[playTrajectory setStrokeEnd:1.0];
		[playLabel runAction:[CCFadeIn actionWithDuration:1]];
	}
	
	if ([settingsLabel self]) {
		[settingsTrajectory setStrokeEnd:1.0];
		[settingsLabel runAction:[CCFadeIn actionWithDuration:1]];
	}
}

- (void)animatePlayButtonSelection {

	[playButton setIsEnabled:NO]; 
	[settingsButton setIsEnabled:NO];
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"SelectionReverse.mp3"];
	[[SimpleAudioEngine sharedEngine] playEffect:@"Rumble.mp3"];
	// Red planet actions
	[planet runAction:[CCMoveTo actionWithDuration:2 position:CGPointMake(-150, -250)]];
	
	// Move the earth
	[playButton runAction:[CCSpawn actions:[CCMoveTo actionWithDuration:2 position:CGPointMake(0, 0)],[CCScaleTo actionWithDuration:2 scale:0.4],[CCRotateBy actionWithDuration:2 angle:15 ], nil]];
	
	// Move the galaxy
	[settingsButton runAction:[CCMoveTo actionWithDuration:1.5 position:CGPointMake(300, -400)]];
	
	//Remove text
	[settingsTrajectory removeFromSuperlayer];
	[settingsLabel removeFromParentAndCleanup:YES];
	settingsTrajectory = nil;
	settingsLabel = nil;
	
	[playTrajectory removeFromSuperlayer];
	[playLabel removeFromParentAndCleanup:YES];
	playTrajectory = nil;
	playLabel = nil;

	[self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:2] two:[CCCallFunc actionWithTarget:self selector:@selector(changeSceneToGameMode)]]];

}
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra

- (void)onExitTransitionDidStart {

	[[SimpleAudioEngine sharedEngine] playEffect:@"Transition.mp3"];
	[super onExitTransitionDidStart];


}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		CCMenu *menu = [CCMenu menuWithItems:nil];
	
		
		//------Menu Elements------//
		background = [CCSprite spriteWithFile:@"SpaceBackground.png"];
		planet = [CCSprite spriteWithFile:@"RedPlanet.png"];
		
		// Play button initializing
		playButton = [CCMenuItemImage itemWithNormalImage:@"PlayButton.png" selectedImage:nil target:self selector:@selector(animatePlayButtonSelection)];
		//Settings button initializing
		settingsButton = [CCMenuItemImage itemWithNormalImage:@"SettingsButton.png" selectedImage:nil target:self selector:@selector(animatePlayButtonSelection)];
		
		// Title
		CCSprite *title = [CCSprite spriteWithFile:@"Title.png"];
		[title setPosition:CGPointMake(160, 255)];
		[title setOpacity:0];
		[self addChild:title z:5];
		[title runAction:[CCFadeIn actionWithDuration:1]];
		
		// Background
		background.position = ccp(size.width/2, size.height/2);
		
		// Planet
		planet.position = ccp(-75, size.height/2);
		planet.scale = 1;
		[planet runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:300 angle:360]]];
		
		// Play Button
		playButton.position = ccp(120, 160);
		playButton.scale = 0.05;
		
		// Settings Button
		settingsButton.position = ccp(140, -200);
		settingsButton.scale = 0.8;
	
		[menu addChild:playButton];
		[menu addChild:settingsButton];
				
		[self addChild:background z:0];
		[self addChild:planet z:0];
		[self addChild:menu z:1];
		
		// Schedule the animation for the lines
		[NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(animateLine) userInfo:NULL repeats:NO] ;
		
		[self drawSettingsButton];
		[self drawPlayButton];
	
		//play background music
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ThemeSong.mp3"];
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.3];
		[[SimpleAudioEngine sharedEngine] playEffect:@"Transition.mp3"];

		
	}
	return self;
}

@end
