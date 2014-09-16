//
//  EnemyView.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import "EnemyView.h"

NSString *const CHAR_IMAGE = @"enemy_burglar";
NSString *const CHAR_IMAGE_C = @"enemy_caught";
NSString *const RESET_TEXT = @"";

float const CHAR_CTR_X = 26.5;
float const CHAR_CTR_Y = 73;
float const CHAR_CTR_W = 10;
float const CHAR_CTR_H = 15;

@interface EnemyView()
@property UILabel *labelLifeTime;
@end

@implementation EnemyView
-(id)initAtPoint:(CGPoint)point
{
    UIImage *image = [UIImage imageNamed:CHAR_IMAGE];
    CGRect frame = CGRectMake(point.x,
                              point.y,
                              image.size.width,
                              image.size.height);
    
    self= [super initWithFrame:frame];
    self.image = image;
    self.userInteractionEnabled = YES;
    
    frame = CGRectMake(CHAR_CTR_X,
                       CHAR_CTR_Y,
                       CHAR_CTR_W,
                       CHAR_CTR_H);

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    self.labelLifeTime = label;
    self.labelLifeTime.textColor = [UIColor whiteColor];
    [self addSubview:_labelLifeTime];
    [label release];
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.controller touchesBegan:touches withEvent:event];
}

-(void)viewRefreshWithTime:(float)time
{
    self.labelLifeTime.text = [NSString stringWithFormat:@"%.0f",time];
}

-(void)viewReset
{
    self.labelLifeTime.text = RESET_TEXT;
}
@end
