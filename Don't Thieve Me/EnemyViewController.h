//
//  EnemyViewController.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import <UIKit/UIKit.h>
@class  EnemyViewController;
@class EnemyViewIndicator;
@protocol EnemyControllerDelegate
-(void)enemyWasDefeated;
-(void)enemyWasNotDefeated;
-(void)enemyDidAppear:(EnemyViewController *)enemy ;
@end

@interface EnemyViewController : UIViewController
@property (nonatomic, retain) NSTimer *lifeTimer;
@property (nonatomic, assign) id delegate;

@property (nonatomic, assign) id indicator;
@end
