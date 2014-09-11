//
//  EnemyViewController.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import <UIKit/UIKit.h>
@class  EnemyViewController;
@protocol EnemyControllerDelegate
@optional
-(void)enemyWasDefeated;
-(void)enemyWasNotDefeated;
-(void)enemyDidAppear:(EnemyViewController *)enemy ;
@end

@interface EnemyViewController : UIViewController
@property (nonatomic, assign) id delegate;
@end
