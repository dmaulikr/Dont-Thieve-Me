//
//  EnemyView.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import "EnemyView.h"
@interface EnemyView()

@end

@implementation EnemyView
-(id)initAtPoint:(CGPoint)point
{
    UIImage *image = [UIImage imageNamed:@"enemy_burglar"];
    CGRect frame = CGRectMake(point.x,
                              point.y,
                              image.size.width,
                              image.size.height);
    self= [super initWithFrame:frame];
    self.image = image;
    self.userInteractionEnabled = YES;
    
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_controller touchesBegan:touches withEvent:event];
}
@end
