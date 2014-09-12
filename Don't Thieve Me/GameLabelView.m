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

@interface GameLabelView()<GameScrollDelegate>
@property (nonatomic, assign) CGRect currentFrame;
@end

@implementation GameLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentFrame = frame;
        //Convert next lines' variables to constant variables
        CGRect labelRect = CGRectMake(_currentFrame.size.width/(_currentFrame.size.width/10),
                                      _currentFrame.size.height - 30.0,
                                      _currentFrame.size.width/3,
                                      _currentFrame.size.height/20);

        UILabel *timer = [[UILabel alloc] initWithFrame:labelRect];
        timer.textColor = [UIColor whiteColor];
        _timeLabel = timer;
        [self addSubview:_timeLabel];
        [timer release];
        
        labelRect.origin.x += frame.size.width/3;
        UILabel *score = [[UILabel alloc] initWithFrame:labelRect];
        score.textColor = [UIColor whiteColor];
        _scoreLabel = score;
        [self addSubview:_scoreLabel];
        [score release];
        
        labelRect = frame;
        labelRect.origin.x /= 2 - (labelRect.size.width/4);
        labelRect.origin.y /= 2 - (labelRect.size.height/4);
        UILabel *gameover = [[UILabel alloc] initWithFrame:labelRect];
        gameover.textAlignment = NSTextAlignmentCenter;
        gameover.font = [UIFont boldSystemFontOfSize:35];
        gameover.numberOfLines = 0;
        gameover.textColor = [UIColor whiteColor];
        gameover.text = GAME_OVER;
        gameover.alpha = 0;
        _gameOverLabel = gameover;
        
        [self addSubview:_gameOverLabel];
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
    
    self.frame = _currentFrame;
}

-(void)viewRefreshWithTime:(float)time
{
    _timeLabel.text = [NSString stringWithFormat:@"%@: %.0f",TEXT_TIMER,time];
}
-(void)viewRefreshWithScore:(int)score
{
    _scoreLabel.text = [NSString stringWithFormat:@"%@: %i",TEXT_SCORE,score];
}
-(void)viewRefreshWithTime:(float)time withScore:(int)score
{
    [self viewRefreshWithTime:time];
    [self viewRefreshWithScore:score];
}
@end