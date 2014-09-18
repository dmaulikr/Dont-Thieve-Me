//
//  GameView.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/9/14.
//
//

#import <UIKit/UIKit.h>
@class GameViewController;

typedef enum
{
    SCROLL_LEFT = 0,
    SCROLL_RIGHT = 1
}swipeDirection;

@protocol GameScrollDelegate
-(void)scrollScreenInDirection:(swipeDirection)direction;
@end

@interface GameView : UIScrollView
@property (nonatomic, assign) id controller;
@end
