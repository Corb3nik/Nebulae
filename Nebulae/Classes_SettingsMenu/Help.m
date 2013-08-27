//
//  Help.m
//  Nebulae
//
//  Created by Ian Bouchard on 2013-08-24.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Help.h"
#import "SettingsMenu.h"
#import "SimpleAudioEngine.h"

@implementation Help
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	Help *scene = [Help node];
	// Add layers you want initialized
	
	
	// return the scene
	return scene;
}

- (void)changeSceneToSettingsMenu {

    [[SimpleAudioEngine sharedEngine] playEffect:@"Transition.mp3"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[SettingsMenu scene] withColor:ccWHITE]];


}
- (void)moveBackgroundImage {
    [[self getChildByTag:123] removeFromParentAndCleanup:NO];
    
    if (!CGPointEqualToPoint(helpImage.position, CGPointMake(-640, 240))) {
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"SwipeTransition.mp3"];
        [helpImage runAction:[CCMoveBy actionWithDuration:0.3 position:CGPointMake(-320, 0)]];
    }
    else {
        [self changeSceneToSettingsMenu];
    }

}

- (id)init
{
    self = [super init];
    if (self) {
        
        helpImage = [CCSprite spriteWithFile:@"HelpSlideShow.png"];
        [helpImage setPosition:CGPointMake(960, 240)];
        [self addChild:helpImage];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveBackgroundImage)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [[[CCDirector sharedDirector] view] addGestureRecognizer:swipe];
        
        CCLabelTTF *nextLevelLabel = [CCLabelTTF labelWithString:@"Swipe left to continue" fontName:@"Arial" fontSize:25];
        [nextLevelLabel setPosition:CGPointMake(160, 140)];
        [nextLevelLabel runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCMoveBy actionWithDuration:0.5 position:CGPointMake(0, 10)] two:[CCMoveBy actionWithDuration:0.5 position:CGPointMake(0, -10)]]]];
        [nextLevelLabel setColor:ccc3(8, 220, 0)];
        [nextLevelLabel setOpacity:0];
        [nextLevelLabel runAction:[CCFadeIn actionWithDuration:0.5]];
        [self addChild:nextLevelLabel z:1 tag:123];
    }
    return self;
}

@end
