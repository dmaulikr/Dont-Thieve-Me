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
@property (nonatomic, retain) UIImage *caught;
@property (nonatomic, retain) UIImage *normal;

-(void)refreshViewWithTime:(float)time;
-(void)resetLifeTimeView;
-(void)changeImageToCaught;
-(void)changeImageToNormal;
@end
