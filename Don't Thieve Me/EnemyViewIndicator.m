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

-(void)setImageDirection:(enumImage)direction
{
    if (direction == LEFT)
    {
        self.image = self.arrowImageLeft;
    } else if (direction == RIGHT)
    {
        self.image = self.arrowImageRight;
    }
}

-(void)setImageDirection:(enumImage)direction atPoint:(CGPoint)point
{
    [self setImageDirection:direction];
    self.currentFrame = self.frame;
    _currentFrame.origin = point;
    self.frame = _currentFrame;

    [self animateShowIndicatorWithCompletion:^(BOOL finished) {
        [self animateHideIndicatorWithCompletion:NULL];
    }];
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
@end
