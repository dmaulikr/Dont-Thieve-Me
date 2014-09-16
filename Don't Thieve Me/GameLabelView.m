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
NSString *const GAME_OVER = @"GAME OVER\nScore: ";

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
int const GAMEOVER_ALPHA_NOT_VISIBLE = 0;
int const GAMEOVER_ALPHA_VISIBLE = 1;

@interface GameLabelView()<GameScrollDelegate>
@property (nonatomic, assign) CGRect currentFrame;
@end

@implementation GameLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentFrame = frame;
        CGRect labelRect = CGRectMake(_currentFrame.size.width/(_currentFrame.size.width/WIDTH_ORIGIN_MODIFIER),
                                      _currentFrame.size.height - SIZE_ORIGIN_MODIFIER,
                                      _currentFrame.size.width/WIDTH_MODIFIER,
                                      _currentFrame.size.height/HEIGHT_MODIFIER);

        UILabel *timer = [[UILabel alloc] initWithFrame:labelRect];
        timer.textColor = [UIColor whiteColor];
        self.timeLabel = timer;
        [self addSubview:self.timeLabel];
        [timer release];
        
        labelRect.origin.x += frame.size.width/SCORE_WIDTH_ORIGIN_MODIFIER;
        UILabel *score = [[UILabel alloc] initWithFrame:labelRect];
        score.textColor = [UIColor whiteColor];
        self.scoreLabel = score;
        [self addSubview:self.scoreLabel];
        [score release];
        
        labelRect = frame;
        labelRect.origin.x /= GAMEOVER_X_MODIFIER - (labelRect.size.width/GAMEOVER_WIDTH_MODIFIER);
        labelRect.origin.y /= GAMEOVER_Y_MODIFIER - (labelRect.size.height/GAMEOVER_HEIGHT_MODIFIER);
        UILabel *gameover = [[UILabel alloc] initWithFrame:labelRect];
        gameover.textAlignment = NSTextAlignmentCenter;
        gameover.font = [UIFont boldSystemFontOfSize:GAMEOVER_FONT_SIZE];
        gameover.numberOfLines = GAMEOVER_NUMBER_OF_LINES;
        gameover.textColor = [UIColor whiteColor];
        gameover.text = GAME_OVER;
        gameover.alpha = GAMEOVER_ALPHA_NOT_VISIBLE;
        self.gameOverLabel = gameover;
        
        [self addSubview:self.gameOverLabel];
        [gameover release];
    }
    return self;
}

-(void)viewScrollDirection:(swipeDirection)direction
{
    if (direction == SCROLL_LEFT)
        _currentFrame.origin.x -= self.frame.size.width;
    if (direction == SCROLL_RIGHT)
        _currentFrame.origin.x += self.frame.size.width;
    
    self.frame = self.currentFrame;
}

-(void)viewRefreshWithTime:(float)time
{
    self.timeLabel.text = [NSString stringWithFormat:@"%@: %.0f",TEXT_TIMER,time];
}

-(void)viewRefreshWithScore:(int)score
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%@: %i",TEXT_SCORE,score];
}

-(void)viewRefreshWithTime:(float)time withScore:(int)score
{
    [self viewRefreshWithTime:time];
    [self viewRefreshWithScore:score];
}
@end