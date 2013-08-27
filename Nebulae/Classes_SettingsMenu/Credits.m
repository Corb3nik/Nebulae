//
//  Credits.m
//  Nebulae
//
//  Created by Ian Bouchard on 2013-06-09.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Credits.h"
#import "SettingsMenu.h"
#import "SimpleAudioEngine.h"
@implementation Credits
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	Credits *scene = [Credits node];
    
	// Add layers you want initialized
	// return the scene
	return scene;
}

- (void)changeSceneToSettingsMenu {

    [[SimpleAudioEngine sharedEngine] playEffect:@"Transition.mp3"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[SettingsMenu scene] withColor:ccWHITE]];

}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self changeSceneToSettingsMenu];
    return NO;
}
- (void)onEnter { //Visuals

    [super onEnter];
    
    [credits runAction:[CCMoveTo actionWithDuration:15 position:CGPointMake(160, 0)]];
}


- (id)init //Preload music
{
    self = [super init];
    if (self) {
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        credits = [CCSprite spriteWithFile:@"CreditNames.png"];
        [credits setPosition:CGPointMake(160, -700)];
        [self addChild:credits];
        
        
    }
    return self;
}

- (void)onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];


}
@end
