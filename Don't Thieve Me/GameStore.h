//
//  GameStore.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/12/14.
//
//

#import <Foundation/Foundation.h>

@interface GameStore : NSObject
+(id)sharedStore;
-(NSDictionary *)allGameFiles;
-(void)setNewHighScore:(int)score;
@end