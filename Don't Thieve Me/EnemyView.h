//
//  EnemyView.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import <UIKit/UIKit.h>

@interface EnemyView : UIImageView
@property (nonatomic, assign) id controller;
//@property (nonatomic, retain) UILabel *spawnPointer;

-(id)initAtPoint:(CGPoint)point;
-(void)viewReset;
-(void)viewRefreshWithTime:(float)time;
//-(void)callSpawnPointer;

@end
