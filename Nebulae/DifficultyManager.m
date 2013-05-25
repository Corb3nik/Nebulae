//
//  DifficultyManager.m
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-03-09.
//
//

#import "DifficultyManager.h"
#import "GameModeScene.h"
#import "GameplayAnimationController.h"
#import "GameplayVisualsLayer.h"

static DifficultyManager *manager;

@implementation DifficultyManager
@synthesize roundScore, poppedBubbleScore, droppedBubbleScore, timeBonusScore, matchScore;
@synthesize shotsFired, shotsBaseValue;
@synthesize level;
@synthesize backgroundVolume, soundEffectVolume;
@synthesize dangerSoundID, alarmSoundID;
+ (DifficultyManager *)sharedManager {
	return manager;
}



- (void)setAmountOfShotsForNextWallDropFromRemainingColors:(NSMutableArray *)remainingColors  {
	
	NSArray *tmp = [[NSSet setWithArray:remainingColors] allObjects];
	NSInteger amountOfColorsRemaining = [tmp count];
	shotsBetweenWallDrops = shotsBaseValue + amountOfColorsRemaining;

}


- (void)resetScoresWithGameOver:(BOOL)isGameOver {

	if (isGameOver == YES) {
			matchScore = 0;
		level = 1;
	}
		roundScore = 0;
		poppedBubbleScore = 0;
		droppedBubbleScore = 0;
		timeBonusScore = 0;
	
	
	//difficulty
	shotsFired = 0;

}




- (void)isShotAmountReached {

	GameplayAnimationController *gameplayAnimation = [GameModeScene sharedScene].lGameplayAnimationController;
	GameplayVisualsLayer *gameplayVisuals = [GameModeScene sharedScene].lGameplayVisualsLayer;
	if (shotsFired == shotsBetweenWallDrops) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"WallAnimation.mp3"];
		[gameplayAnimation performSelector:@selector(animateWall) withObject:Nil afterDelay:0.2];
		[[SimpleAudioEngine sharedEngine] stopEffect:dangerSoundID];
		[[SimpleAudioEngine sharedEngine] stopEffect:alarmSoundID];
	}
	if (shotsFired == (shotsBetweenWallDrops - 2)) { // If the player has two more shot before the animation
		
		dangerSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"Danger.mp3"];
		[gameplayVisuals.planetBackground runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCMoveBy actionWithDuration:0.1 position:CGPointMake(5, 0)] two:[CCMoveBy actionWithDuration:0.1 position:CGPointMake(-5, 0)]]]];
	}
	if (shotsFired == (shotsBetweenWallDrops - 1)) { // one more shot
		alarmSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"Alarm.mp3"]; // Contain the sound ID
		[gameplayVisuals.planetBackground runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCMoveBy actionWithDuration:0.1 position:CGPointMake(10, 0)] two:[CCMoveBy actionWithDuration:0.1 position:CGPointMake(-10, 0)]]]];
		alSourcei(alarmSoundID, AL_LOOPING, 1);
	}
	

}


- (NSInteger)raiseLevel {

	level++; // Raise the level of the game
	if (level % 5 == 0) {
		shotsBaseValue--; // Shorten the base value for the time between wall drops
	}
	
	return level;

}

- (void)volumeChanged:(CCControlSlider *)sender {
    
	NSInteger tag = [sender tag];
	if (tag == 123) { // Background volume changed
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:[sender value]];
	}
	
	if (tag == 456) {
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:[sender value]];
	}
}
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//
//-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------////-----------Extra Settings-----------//

- (id)init
{
    self = [super init];
    if (self) {
        manager = self;
		
		roundScore = 0;
		poppedBubbleScore = 0;
		droppedBubbleScore = 0;
		timeBonusScore = 0;
		matchScore = 0;
		level = 1;
		
		//difficulty
		shotsBaseValue = 6;
		shotsFired = 0;
		shotsBetweenWallDrops = shotsBaseValue;

		// sound volume
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.3];
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.3];
		
    }
    return self;
}

@end
