//
//  GameView.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/9/14.
//
//

#import "GameView.h"

NSString *const MAP_IMG_I4 = @"dtm_map_med";
NSString *const MAP_IMG_I35 =@"dtm_med480";

int const GAME_I4IR_WIDTH = 320;
int const GAME_I35IR_HEIGHT = 480;
int const NUMBER_OF_SCREENS = 3;
int const MAX_SCROLL_VALUE_LEFT = 0;
int const MAX_SCROLL_VALUE_RIGHT = 640;

float const SWIPE_ANIMATION_DURATION = 0.3;

int const GV_NONE = 0;

typedef enum {
    MOVE_SCREEN_LEFT = 0,
    MOVE_SCREEN_RIGHT = 1
}animateDirection;

@interface GameView()
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation GameView
#pragma mark GameView Initializers
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect entireRect = frame;
        entireRect.size.width *= NUMBER_OF_SCREENS;
        self.contentSize = entireRect.size;
        self.scrollEnabled = NO;
        
        [self setUpGameScreenWithFrame:frame];
        [self setUpGestureRecognizers];
    }
    return self;
}

-(void)setUpGameScreenWithFrame:(CGRect)frame
{
    NSString *mapName = (frame.size.height == GAME_I35IR_HEIGHT) ? MAP_IMG_I35 : MAP_IMG_I4;
    UIImage *image = [UIImage imageNamed:mapName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    [imageView release];
}

-(void)setUpGestureRecognizers
{
    UISwipeGestureRecognizer *swipeToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(wasSwipedLeft)];
    swipeToLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeToLeft];

    UISwipeGestureRecognizer *swipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(wasSwipedRight)];
    swipeToRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeToRight];
}

-(void)resetGameView
{
    _currentPoint = self.bounds.origin;
    _currentPoint.x = MAX_SCROLL_VALUE_LEFT;
}

#pragma mark Swipe Actions and Animations
-(void)wasSwipedLeft
{
    _currentPoint = self.bounds.origin;
    if (_currentPoint.x != MAX_SCROLL_VALUE_RIGHT)
    {
        _currentPoint.x += GAME_I4IR_WIDTH;
        [self animateScreenWithDirection:MOVE_SCREEN_RIGHT];
    }
}

-(void)wasSwipedRight
{
    _currentPoint = self.bounds.origin;
    if (_currentPoint.x != MAX_SCROLL_VALUE_LEFT)
    {
        _currentPoint.x -= GAME_I4IR_WIDTH;
        [self animateScreenWithDirection:MOVE_SCREEN_LEFT];
    }
}

-(void)animateScreenWithDirection:(animateDirection)direction
{
    [UIView animateWithDuration:SWIPE_ANIMATION_DURATION
                          delay:GV_NONE
                        options:GV_NONE
                     animations:^{
                         if(direction == MOVE_SCREEN_LEFT)
                             [self.controller scrollScreenInDirection:SCROLL_LEFT];
                         if(direction == MOVE_SCREEN_RIGHT)
                             [self.controller scrollScreenInDirection:SCROLL_RIGHT];
                     }
                     completion:NULL];
    [self setContentOffset:_currentPoint
                  animated:YES];
}
@end
