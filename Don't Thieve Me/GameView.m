//
//  GameView.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/9/14.
//
//

#import "GameView.h"
int const I4IR_WIDTH = 320;
float const SWIPE_OBJ_DURATION = 0.3;
NSString *const MAP_IMG = @"dtm_map_med";

@interface GameView()
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation GameView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect entireRect = frame;
        entireRect.size.width *= 3;
        self.contentSize = entireRect.size;
        self.scrollEnabled = NO;

        UIImage *image = [UIImage imageNamed:MAP_IMG];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        [imageView release];
     
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
    if (_currentPoint.x == I4IR_WIDTH*2)
    {} else
    {
        _currentPoint.x +=I4IR_WIDTH;
        [UIView animateWithDuration:SWIPE_OBJ_DURATION
                              delay:0
                            options:0
                         animations:^{
                             [_controller viewScrolledRight];
                         }
                         completion:NULL];
        [self setContentOffset:_currentPoint
                      animated:YES];
    }
}
-(void)viewLeftScreen
{
    _currentPoint = self.bounds.origin;
    if (_currentPoint.x == 0)
    {} else
    {
        _currentPoint.x -= I4IR_WIDTH;
        [UIView animateWithDuration:SWIPE_OBJ_DURATION
                              delay:0
                            options:0
                         animations:^{
                             [_controller viewScrolledLeft];
                         }
                         completion:NULL];

        [self setContentOffset:_currentPoint
                      animated:YES];
    }
  }
@end
