//
//  MainMenu.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2012-09-15.
//  Copyright IanBouchard 2012. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "SimpleAudioEngine.h"
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// MainMenu
@interface MainMenu : CCLayer
{
	CCMenuItem *playButton;
	CCLabelTTF *playLabel;
	
	CCMenuItem *settingsButton;
	CCLabelTTF *settingsLabel;
	
	CCSprite *background;
	CCSprite *planet;
	CAShapeLayer *playTrajectory;
	CAShapeLayer *settingsTrajectory;
	NSTimer *timer;
}

// returns a CCScene that contains the MainMenu as the only child
+(CCScene *) scene;
- (void) drawPlayButton;
- (void) drawSettingsButton;
- (void) animateLine;
- (void) animatePlayButtonSelection;
- (void) changeSceneToGameMode;
- (void) changeSceneToSettings;
@end
