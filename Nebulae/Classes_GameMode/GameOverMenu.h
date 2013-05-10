//
//  GameOverMenu.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-03-06.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameplayFlowController;
@interface GameOverMenu : CCLayer {
    

	GameplayFlowController *gameplayFlow;
	
	CCMenuItemLabel *quitLabel;
	CCMenuItemLabel *retryLabel;


}

- (void) animateGameOverScreen;
- (void) drawButtons;
- (void) drawLabels;

- (void) resetScene;
- (void) mainMenuScene;
@end
