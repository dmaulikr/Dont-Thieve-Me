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
    LEFT_ARROW,
    RIGHT_ARROW
}enumIndicator;

@interface EnemyViewIndicator : UIImageView
-(void)setImageDirection:(enumIndicator)direction;
-(void)setImageDirection:(enumIndicator)direction atPoint:(CGPoint)point;
@end
