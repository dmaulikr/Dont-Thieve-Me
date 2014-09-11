//
//  EnemyViewIndicator.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/11/14.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    LEFT,
    RIGHT
}enumImage;

@interface EnemyViewIndicator : UIImageView
@property (nonatomic, retain) UIImage *arrowImageLeft;
@property (nonatomic, retain) UIImage *arrowImageRight;
@property (nonatomic, assign) CGRect currentFrame;

-(void)setImageDirection:(enumImage)direction;
-(void)setImageDirection:(enumImage)direction atPoint:(CGPoint)point;
@end
