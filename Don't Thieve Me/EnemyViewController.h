//
//  EnemyViewController.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import <UIKit/UIKit.h>
@protocol EnemyControllerDelegate
@optional
-(void)enemyWasDefeated;
-(void)enemyWasNotDefeated;
@end

@interface EnemyViewController : UIViewController
@property (nonatomic, assign) id delegate;
@end
