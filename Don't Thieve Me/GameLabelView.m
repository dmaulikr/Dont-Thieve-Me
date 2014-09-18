//
//  GameLabelView.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/9/14.
//
//

#import "GameLabelView.h"
#import "GameView.h"

NSString *const TEXT_TIMER = @"Timer: ";
NSString *const TEXT_SCORE = @"Score: ";

NSString *const GAME_OVER_LABEL = @"GAME OVER\nScore: ";
NSString *const GAME_OVER_LABEL_N = @"\nNew High Score!";
NSString *const GAME_OVER_LABEL_H = @"\n High Score: ";

float const RESET_POINT_VALUE = 0;

float const WIDTH_ORIGIN_MODIFIER = 10;
float const SIZE_ORIGIN_MODIFIER = 30.0;
float const WIDTH_MODIFIER = 3;
float const HEIGHT_MODIFIER = 20;
float const SCORE_WIDTH_ORIGIN_MODIFIER = 3;
float const GAMEOVER_X_MODIFIER = 2;
float const GAMEOVER_Y_MODIFIER = 2;
float const GAMEOVER_WIDTH_MODIFIER = 4;
float const GAMEOVER_HEIGHT_MODIFIER = 4;
int const GAMEOVER_NUMBER_OF_LINES = 0;
int const GAMEOVER_FONT_SIZE = 35;
float const GAMEOVER_ALPHA_VISIBLE = 1;
float const GAMEOVER_ALPHA_NOT_VISIBLE = 0;


@interface GameLabelView()<GameScrollDelegate>
@property (nonatomic, assign) CGRect currentFrame;
@end

@implementation GameLabelView
#pragma mark GameLabelView Initializers
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentFrame = frame;
        CGRect labelRect = CGRectMake(_currentFrame.size.width/(_currentFrame.size.width/WIDTH_ORIGIN_MODIFIER),
                                      _currentFrame.size.height - SIZE_ORIGIN_MODIFIER,
                                      _currentFrame.size.width/WIDTH_MODIFIER,
                                      _currentFrame.size.height/HEIGHT_MODIFIER);

        [self setUpTimerLabelWithFrame:labelRect];
        
        labelRect.origin.x += frame.size.width/SCORE_WIDTH_ORIGIN_MODIFIER;
        [self setUpScoreLabelWithFrame:labelRect];
        
        labelRect = frame;
        labelRect.origin.x /= GAMEOVER_X_MODIFIER - (labelRect.size.width/GAMEOVER_WIDTH_MODIFIER);
        labelRect.origin.y /= GAMEOVER_Y_MODIFIER - (labelRect.size.height/GAMEOVER_HEIGHT_MODIFIER);
        [self setUpGameOverLabelWithFrame:labelRect];
    }
    return self;
}

-(void)setUpTimerLabelWithFrame:(CGRect)frame
{
    UILabel *timer = [[UILabel alloc] initWithFrame:frame];
    timer.textColor = [UIColor whiteColor];
    self.timeLabel = timer;
    [self addSubview:self.timeLabel];
    [timer release];
}

-(void)setUpScoreLabelWithFrame:(CGRect)frame
{
    UILabel *score = [[UILabel alloc] initWithFrame:frame];
    score.textColor = [UIColor whiteColor];
    self.scoreLabel = score;
    [self addSubview:self.scoreLabel];
    [score release];
}

-(void)setUpGameOverLabelWithFrame:(CGRect)frame
{
    UILabel *gameover = [[UILabel alloc] initWithFrame:frame];
    gameover.textAlignment = NSTextAlignmentCenter;
    gameover.font = [UIFont boldSystemFontOfSize:GAMEOVER_FONT_SIZE];
    gameover.numberOfLines = GAMEOVER_NUMBER_OF_LINES;
    gameover.textColor = [UIColor whiteColor];
    gameover.alpha = GAMEOVER_ALPHA_NOT_VISIBLE;
    self.gameOverLabel = gameover;
    
    [self addSubview:self.gameOverLabel];
    [gameover release];
}

#pragma mark GameLabelView Scroll Action
-(void)scrollScreenInDirection:(swipeDirection)direction
{
    if (direction == SCROLL_LEFT)
        _currentFrame.origin.x -= self.frame.size.width;
    if (direction == SCROLL_RIGHT)
        _currentFrame.origin.x += self.frame.size.width;
    
    self.frame = self.currentFrame;
}

#pragma mark GameLabelView Display Methods
-(void)refreshViewWithTime:(float)time
{
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %.0f",TEXT_TIMER,time];
}

-(void)refreshViewWithScore:(int)score
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%@: %i",TEXT_SCORE,score];
}

-(void)refreshViewWithTime:(float)time withScore:(int)score
{
    [self refreshViewWithTime:time];
    [self refreshViewWithScore:score];
}

-(void)resetGameOverLabel
{
    self.gameOverLabel.text = GAME_OVER_LABEL;
    [self isGameOverLabelHidden:YES];
}

-(void)resetLabelPosition
{
    _currentFrame.origin.x = RESET_POINT_VALUE;
    self.frame = self.currentFrame;
}

-(void)isGameOverLabelHidden:(BOOL)boolean
{
    if(boolean == YES) {
        self.gameOverLabel.alpha = GAMEOVER_ALPHA_NOT_VISIBLE;
        [self.gameOverLabel sendSubviewToBack:self];
    }
    if(boolean == NO) {
        self.gameOverLabel.alpha = GAMEOVER_ALPHA_VISIBLE;
        [self.gameOverLabel bringSubviewToFront:self];
    }
}

-(void)showGameOverWithScore:(int)score withHighScore:(int)highscore
{
    NSString *string = [NSString stringWithFormat:@"%@%i%@%i",GAME_OVER_LABEL,score,GAME_OVER_LABEL_H,highscore];
    self.gameOverLabel.text = string;
}

-(void)showGameOverWithNewHighScore:(int)score
{
    NSString *string = [NSString stringWithFormat:@"%@%i%@",GAME_OVER_LABEL,score,GAME_OVER_LABEL_N];
    self.gameOverLabel.text = string;
}

-(void)dealloc
{
    [_scoreLabel release];
    _scoreLabel = nil;
    [_timeLabel release];
    _timeLabel = nil;
    [_highScoreLabel release];
    _highScoreLabel = nil;
    [_gameOverLabel release];
    _gameOverLabel = nil;
    
    [super dealloc];
}
@end