//
//  EnemyView.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import "EnemyView.h"

NSString *const CHAR_IMAGE = @"enemy_burglar";

NSString *const RESET_TEXT = @"";

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
    
    //Still moving this around, figuring out the best place to insert the label, will replace with const when fixed
    frame = CGRectMake(self.bounds.size.width/2,
                       self.bounds.size.height-20,
                       10,
                       15);
    
    _labelLifeTime = [[UILabel alloc] initWithFrame:frame];
    _labelLifeTime.textColor = [UIColor whiteColor];
//    _labelLifeTime.backgroundColor = [UIColor redColor];
    [self addSubview:_labelLifeTime];
    
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_controller touchesBegan:touches withEvent:event];
}
-(void)viewRefreshWithTime:(float)time
{
    _labelLifeTime.text = [NSString stringWithFormat:@"%.0f",time];
}
-(void)viewReset
{
    _labelLifeTime.text = RESET_TEXT;
}
@end
