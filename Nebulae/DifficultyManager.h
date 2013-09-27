//
//  DifficultyManager.h
//  Bubblarium
//
//  Created by Ian Bouchard on 2013-03-09.
//
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
@interface DifficultyManager : NSObject {
	
	NSInteger shotsBetweenWallDrops;
	NSInteger shotsBaseValue;

}



@property (assign) NSInteger roundScore;
@property (assign) NSInteger matchScore;

@property (assign) NSInteger poppedBubbleScore;
@property (assign) NSInteger droppedBubbleScore;
@property (assign) NSInteger timeBonusScore;

@property (assign) NSInteger shotsFired;
@property (assign) NSInteger shotsBaseValue;

@property (assign) NSInteger level;

@property (assign) NSInteger backgroundVolume;
@property (assign) NSInteger soundEffectVolume;

@property (assign, readonly) ALuint dangerSoundID;
@property (assign, readonly) ALuint alarmSoundID;
+ (DifficultyManager *) sharedManager;


- (void) resetScoresWithGameOver:(BOOL)isGameOver;
- (void) setAmountOfShotsForNextWallDropFromRemainingColors:(NSMutableArray *)remainingColors;
- (void) isShotAmountReached;
- (void)volumeChanged:(id)sender;
- (NSInteger) raiseLevel;
@end
