//
//  GameLabelView.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/9/14.
//
//

#import <UIKit/UIKit.h>
@class GameView;

@interface GameLabelView : UIView
@property (nonatomic, retain) UILabel *scoreLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *highScoreLabel;
@property (nonatomic, retain) UILabel *gameOverLabel;

-(void)viewRefreshWithTime:(float)time;
-(void)viewRefreshWithScore:(int)score;
-(void)viewRefreshWithTime:(float)time withScore:(int)score;
@end
