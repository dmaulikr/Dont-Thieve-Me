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
-(void)enemyViewCreated:(EnemyViewController *)enemyView;
@optional
-(void)enemyWasDefeated;
-(void)enemyDidAppear:(EnemyViewController *)enemy;
@end

@interface EnemyViewController : UIViewController
@property (nonatomic, retain) NSTimer *lifeTimer;
@property (nonatomic, assign) BOOL isEnemyPermanentlyExpired;

@property (nonatomic, assign) id delegate;

@property (nonatomic, assign) id indicator;

+(NSMutableArray *)generateEnemies:(int)number_of_enemies delegate:(id)delegate;
-(void)startLifeTimer;
-(void)invalidateTimer;
@end
