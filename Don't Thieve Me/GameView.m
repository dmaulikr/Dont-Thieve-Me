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

float const SWIPE_OBJ_DURATION = 0.3;

int const I4IR_WIDTH = 320;
int const I4IR_DWIDTH = 640;
int const NUMBER_OF_SCREENS = 3;

int const GV_ZERO = 0;
int const GV_NONE = 0;

@interface GameView()
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation GameView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect entireRect = frame;
        entireRect.size.width *= NUMBER_OF_SCREENS;
        self.contentSize = entireRect.size;
        self.scrollEnabled = NO;

        if(frame.size.height == 480)
        {
            UIImage *image = [UIImage imageNamed:MAP_IMG_I35];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [self addSubview:imageView];
            [imageView release];
        } else
        {
            UIImage *image = [UIImage imageNamed:MAP_IMG_I4];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [self addSubview:imageView];
            [imageView release];
        }
     
#pragma mark Swipe Gesture Recognizers
        UISwipeGestureRecognizer *swipeToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(viewRightScreen)];
        swipeToLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeToLeft];
        UISwipeGestureRecognizer *swipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(viewLeftScreen)];
        swipeToRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeToRight];
    }
    return self;
}

-(void)viewRightScreen
{
    _currentPoint = self.bounds.origin;
    if (_currentPoint.x == I4IR_DWIDTH)
    {} else
    {
        _currentPoint.x +=I4IR_WIDTH;
        [UIView animateWithDuration:SWIPE_OBJ_DURATION
                              delay:GV_NONE
                            options:GV_NONE
                         animations:^{
                             [self.controller viewScrollDirection:SCROLL_RIGHT];
                         }
                         completion:NULL];
        [self setContentOffset:_currentPoint
                      animated:YES];
    }
}

-(void)viewLeftScreen
{
    _currentPoint = self.bounds.origin;
    if (_currentPoint.x == GV_ZERO)
    {} else
    {
        _currentPoint.x -= I4IR_WIDTH;
        [UIView animateWithDuration:SWIPE_OBJ_DURATION
                              delay:GV_NONE
                            options:GV_NONE
                         animations:^{
                             [self.controller viewScrollDirection:SCROLL_LEFT];
                         }
                         completion:NULL];

        [self setContentOffset:_currentPoint
                      animated:YES];
    }
}
@end
