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
NSString *const RESET_LABEL = @"";
float const CHAR_CTR_X = 26.5;
float const CHAR_CTR_Y = 73;
float const CHAR_CTR_W = 10;
float const CHAR_CTR_H = 15;

@interface EnemyView()
@property (nonatomic, assign) UILabel *labelLifeTime;
@end

@implementation EnemyView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpEnemyImages];
        
        frame = CGRectMake(CHAR_CTR_X,
                           CHAR_CTR_Y,
                           CHAR_CTR_W,
                           CHAR_CTR_H);
        [self setUpLifeTimeLabelWithFrame:frame];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setUpLifeTimeLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    self.labelLifeTime = label;
    self.labelLifeTime.textColor = [UIColor whiteColor];
    [self addSubview:self.labelLifeTime];
    [label release];
}

-(void)setUpEnemyImages
{
    UIImage *image = [UIImage imageNamed:CHAR_IMAGE];
    self.normal = image;
    image = [UIImage imageNamed:CHAR_IMAGE_C];
    self.caught = image;
    
    [self setImage:_normal];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.controller touchesBegan:touches withEvent:event];
}

-(void)refreshViewWithTime:(float)time
{
    self.labelLifeTime.text = [NSString stringWithFormat:@"%.0f",time];
}

-(void)resetLifeTimeView
{
    self.labelLifeTime.text = [NSString stringWithFormat:RESET_LABEL];
}
-(void)changeImageToCaught
{
    self.image = _caught;
}

-(void)changeImageToNormal
{
    self.image = _normal;
}

-(void)dealloc
{
    [_normal release];
    _normal = nil;
    [_caught release];
    _caught = nil;

    [super dealloc];
}
@end
