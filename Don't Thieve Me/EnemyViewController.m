//
//  EnemyViewController.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import "EnemyViewController.h"
#import "EnemyView.h"

int const CONTENT_WIDTH = 960; //Float this
int const I4IR_HEIGHT = 568;
int const IMAGE_WIDTH = 40;
int const IMAGE_HEIGHT = 70;

float const LIFE_TIMER = 5;

float const APPEAR_DURATION = 0.4;
float const DISAPPEAR_DURATION = 0.4;

@interface EnemyViewController ()
@property (nonatomic, retain) EnemyView *enemyView;
@property (nonatomic, retain) NSTimer *lifeTimer;

@property (nonatomic, assign) CGPoint randomPoint; //Might pile up, move to game view or destroy quickly
@property (nonatomic, assign) CGRect currentFrame;
@end

@implementation EnemyViewController
-(void)loadView
{
    EnemyView *view = [[EnemyView alloc] initAtPoint:[self getRandomPoint]];
    _enemyView = view;
    _enemyView.controller = self;
    

    [self setView:_enemyView];
    [view release];
    
    [self startLifeTimer];
}
-(void)startLifeTimer
{
    _lifeTimer = [NSTimer scheduledTimerWithTimeInterval:LIFE_TIMER
                                                  target:self
                                                selector:@selector(lifeTimerFire:)
                                                userInfo:nil
                                                 repeats:NO];
}
-(void)lifeTimerFire:(NSTimer *)timer
{
    [self expireLifeTimerWithEnemyDefeaated:NO];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self expireLifeTimerWithEnemyDefeaated:YES];

}

-(void)expireLifeTimerWithEnemyDefeaated:(BOOL)boolean
{
    [_lifeTimer invalidate];
    if(boolean == YES)
        [_delegate enemyWasDefeated];
    if(boolean == NO)
        [_delegate enemyWasNotDefeated];
    
    [UIView animateWithDuration:APPEAR_DURATION
                     animations:^{
                         _enemyView.alpha = 0;
                     }
                     completion:^(BOOL finished)
     {
         _currentFrame = _enemyView.frame;
         _currentFrame.origin = [self getRandomPoint];
         _enemyView.frame = _currentFrame;
         [UIView animateWithDuration:DISAPPEAR_DURATION
                          animations:^{
                              _enemyView.alpha = 1.0;
                          }
                          completion:^(BOOL finished)
          {
              [self startLifeTimer];
          }];
     }];
}

-(CGPoint)getRandomPoint
{
    //Algorith sometimes reaches 4294967296.00, please check
    //The image is 40x70
    _randomPoint = CGPointMake(arc4random() % (CONTENT_WIDTH-IMAGE_WIDTH),
                               arc4random() % (I4IR_HEIGHT-IMAGE_HEIGHT));
    return _randomPoint;
    
}
@end
