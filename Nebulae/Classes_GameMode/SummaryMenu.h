//
//  SummaryMenu.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-03-03.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameplayFlowController;
@class GameplayVisualsLayer;
@interface SummaryMenu : CCLayer {
    
	CCLabelTTF *destroyedBubblesScoreLabel;
	CCLabelTTF *fallenBubblesScoreLabel;
	CCLabelTTF *totalScoreLabel;
	CCLabelTTF *timeBonusScoreLabel;
	
	float elapsedTime;
	
	
	
	GameplayFlowController *gameplayFlow;
	GameplayVisualsLayer *gameplayVisuals;
	
}

@property float elapsedTime;

// Screen emptied
- (void) resetScene;
- (void) animateSummaryScreen;
- (void) generateDestroyedBubblesScore;
- (void) generateFallenBubblesScore;
- (void) generateTimeScore;
- (void) generateTotalScore;

// Game over
@end
