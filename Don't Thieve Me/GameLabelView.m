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
        gameover.textAlignment = UITextAlignmentCenter;
        gameover.font = [UIFont boldSystemFontOfSize:40];
        gameover.textColor = [UIColor whiteColor];
        gameover.text = @"Game Over";
        gameover.alpha = 0;
        _gameOverLabel = gameover;
        [self addSubview:_gameOverLabel];
        [gameover release];
        
    }
    return self;
}

//Refactor these into -(void)viewscrolled:(scrollDirection)direction;
-(void)viewScrolledRight
{
    _currentFrame.origin.x += self.frame.size.width;
    self.frame = _currentFrame;
}
-(void)viewScrolledLeft
{
    _currentFrame.origin.x -= self.frame.size.width;
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