//
//  GameView.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/9/14.
//
//

#import <UIKit/UIKit.h>
@class GameViewController;

@protocol GameScrollDelegate
-(void)viewScrolledRight;
-(void)viewScrolledLeft;
@end

@interface GameView : UIScrollView
@property (nonatomic, assign) id controller;
@end
