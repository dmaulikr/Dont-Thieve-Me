//
//  EnemyViewIndicator.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/11/14.
//
//

#import "EnemyViewIndicator.h"

NSString *const imageLeft = @"dtm_arrow_left";
NSString *const imageRight = @"dtm_arrow_right";

float const IND_VISIBLE = 1.0;
float const IND_NOT_VISIBLE = 0.0;

float const IND_APPEAR_DURATION = 0.2;
float const IND_DISAPPEAR_DURATION = 0.5;

int const IND_NONE = 0;

@interface EnemyViewIndicator ()
@property (nonatomic, retain) UIImage *arrowImageLeft;
@property (nonatomic, retain) UIImage *arrowImageRight;
@property (nonatomic, assign) CGRect currentFrame;
@end

@implementation EnemyViewIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.arrowImageLeft = [UIImage imageNamed:imageLeft];
        self.arrowImageRight = [UIImage imageNamed:imageRight];
        self.alpha = IND_NOT_VISIBLE;
    }
    return self;
}

-(void)setImageDirection:(enumIndicator)direction
{
    if (direction == LEFT_ARROW)
        self.image = self.arrowImageLeft;
    else if (direction == RIGHT_ARROW)
        self.image = self.arrowImageRight;
}

-(void)setImageDirection:(enumIndicator)direction atPoint:(CGPoint)point
{
    [self setImageDirection:direction];
    [self moveViewToPoint:point];

    [self animateShowIndicatorWithCompletion:^(BOOL finished) {
        [self animateHideIndicatorWithCompletion:NULL];
    }];
}

-(void)moveViewToPoint:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(void)animateShowIndicatorWithCompletion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0)
{
    [UIView animateWithDuration:IND_APPEAR_DURATION
                          delay:IND_NONE
                        options:IND_NONE
                     animations:^{
                         self.alpha = IND_VISIBLE;
                     }
                     completion:completion];
}

-(void)animateHideIndicatorWithCompletion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0)
{
    [UIView animateWithDuration:IND_DISAPPEAR_DURATION
                          delay:IND_NONE
                        options:IND_NONE
                     animations:^{
                         self.alpha = IND_NOT_VISIBLE;
                     }
                     completion:completion];
}

-(void)dealloc
{
    [_arrowImageLeft release];
    _arrowImageLeft = nil;
    
    [_arrowImageRight release];
    _arrowImageRight = nil;
    
    [super dealloc];
}
@end
