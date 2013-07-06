//
//  Credits.m
//  Nebulae
//
//  Created by Ian Bouchard on 2013-06-09.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Credits.h"
#import "SettingsMenu.h"

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

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[SettingsMenu scene] withColor:ccWHITE]];

}

- (void)onEnter { //Visuals

    [super onEnter];
    
    [credits runAction:[CCMoveTo actionWithDuration:30 position:CGPointMake(160, 0)]];
    [quitButton runAction:[CCMoveTo actionWithDuration:30 position:CGPointMake(0, -190)]];
}


- (id)init //Preload music
{
    self = [super init];
    if (self) {
        
        CCMenu *menu = [CCMenu node];
        CCSprite *quitSprite = [CCSprite spriteWithFile:@"Quit.png"];
        CCSprite *selectedQuitSprite = [CCSprite spriteWithFile:@"Quit.png"];
        [selectedQuitSprite setScale:1.1];
        
        credits = [CCSprite spriteWithFile:@"CreditNames.png"];
        [credits setPosition:CGPointMake(160, -800)];
        [self addChild:credits];
        
        quitButton = [CCMenuItemSprite itemWithNormalSprite:quitSprite selectedSprite:selectedQuitSprite disabledSprite:Nil target:self selector:@selector(changeSceneToSettingsMenu)];
        
        [quitButton setPosition:CGPointMake(0, -1040)];
        
        
        [menu addChild:quitButton];
        [self addChild:menu];
    }
    return self;
}
@end
