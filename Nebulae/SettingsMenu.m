//
//  SettingsMenu.m
//  Nebulae
//
//  Created by Ian Bouchard on 2013-05-17.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SettingsMenu.h"
#import "CCControlSlider.h"
#import "SimpleAudioEngine.h"
#import "DifficultyManager.h"
#import "MainMenu.h"
@implementation SettingsMenu
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	SettingsMenu *scene = [SettingsMenu node];
	// Add layers you want initialized
	CCLayer *layer = [CCLayer node];
    
    [scene addChild:layer];
	
	// return the scene
	return scene;
}

- (void)changeSceneToMainMenu {

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu scene] withColor:ccBLACK]];

}


- (void)onEnter {
    [super onEnter];
    
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
	
    // Add the button elements
	[effectBackground addTarget:[DifficultyManager sharedManager] action:@selector(volumeChanged:) forControlEvents:CCControlEventValueChanged];
    CCSprite *background = [CCSprite spriteWithFile:@"SettingsMenu.png"];
    [background setPosition:CGPointMake(160, 240)];
        
    
    [self addChild:background];
    


    CCMenu *menu = [CCMenu menuWithItems:nil];
    
    CCSprite *backButton = [CCSprite spriteWithFile:@"BackButton.png"];
	CCSprite *backButtonSelected = [CCSprite spriteWithFile:@"BackButton.png"];
	[backButtonSelected setScale:1.1];
	
    CCSprite *helpButton = [CCSprite spriteWithFile:@"HelpButton.png"];
	CCSprite *helpButtonSelected = [CCSprite spriteWithFile:@"HelpButton.png"];
	[helpButtonSelected setScale:1.1];
	
    CCSprite *creditsButton = [CCSprite spriteWithFile:@"CreditsButton.png"];
    CCSprite *creditsButtonSelected = [CCSprite spriteWithFile:@"CreditsButton.png"];
    [creditsButtonSelected setScale:1.1];
	
    CCMenuItemSprite *back = [CCMenuItemSprite itemWithNormalSprite:backButton selectedSprite:backButtonSelected target:self selector:@selector(changeSceneToMainMenu)];
	[back setPosition:CGPointMake(0, -180)];
	
	CCMenuItemSprite *help = [CCMenuItemSprite itemWithNormalSprite:helpButton selectedSprite:helpButtonSelected target:nil selector:nil];
	[help setPosition:CGPointMake(-80, -110)];
	
    CCMenuItemSprite *credits = [CCMenuItemSprite itemWithNormalSprite:creditsButton selectedSprite:creditsButtonSelected target:nil selector:nil];
	[credits setPosition:CGPointMake(80, -110)];
    
    
	[menu addChild:back];
    [menu addChild:help];
    [menu addChild:credits];
	[self addChild:menu z:46];
}

@end