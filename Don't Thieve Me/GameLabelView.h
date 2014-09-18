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

-(void)refreshViewWithTime:(float)time;
-(void)refreshViewWithScore:(int)score;
-(void)refreshViewWithTime:(float)time withScore:(int)score;
-(void)resetGameOverLabel;
-(void)isGameOverLabelHidden:(BOOL)boolean;

-(void)showGameOverWithScore:(int)score withHighScore:(int)highscore;
-(void)showGameOverWithNewHighScore:(int)score;
-(void)resetLabelPosition;
@end
