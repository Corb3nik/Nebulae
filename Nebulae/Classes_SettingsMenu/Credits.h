//
//  Credits.h
//  Nebulae
//
//  Created by Ian Bouchard on 2013-06-09.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Credits : CCScene {
    
    CCSprite *credits;
    CCMenuItemSprite *quitButton;
}
+ (CCScene *) scene;
- (void) changeSceneToSettingsMenu;
@end
