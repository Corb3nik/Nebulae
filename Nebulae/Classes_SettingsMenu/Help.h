//
//  Help.h
//  Nebulae
//
//  Created by Ian Bouchard on 2013-08-24.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Help : CCScene  {
    
    CCSprite *helpImage;
    
}
+ (CCScene*) scene;
- (void) changeSceneToSettingsMenu;
- (void) moveBackgroundImage;

@end
