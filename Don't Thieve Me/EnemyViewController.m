//
//  EnemyViewController.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import "EnemyViewController.h"
#import "EnemyView.h"

int const CONTENT_WIDTH = 960;
int const I4IR_HEIGHT = 568;
int const I35IR_HEIGHT = 480;
int const WIDTH = 320;
int const DWIDTH = 640;

int const IMAGE_WIDTH = 40;
int const IMAGE_HEIGHT = 70;
int const SCREEN_BORDER = 10;
int const GAME_LABEL_BORDER = 50;
int const INT_HUNDRED = 100;
float const FLOAT_HUNDRED = 100;

float const LIFE_TIMER = 5;
int const CLOCK_TICK = 1;

float const APPEAR_DURATION = 0.4;
float const DISAPPEAR_DURATION = 0.4;
float const VISIBLE = 1;
float const NOT_VISIBLE = 0;
int const EV_ZERO=0;

int const GAME_QUADRANTS = 3;
typedef enum
{
    FIRST = 0,
    SECOND = 1,
    THIRD = 2,
}GameQuadrant;

@interface EnemyViewController ()
@property (nonatomic, retain) EnemyView *enemyView;
@property (nonatomic, assign) float lifeTimeCurrent;

@property (nonatomic, assign) GameQuadrant randomQuadrant;
@property (nonatomic, assign) CGPoint randomPoint;
@property (nonatomic, assign) CGRect currentFrame;
@end

@implementation EnemyViewController
-(void)loadView
{
    EnemyView *view = [[EnemyView alloc] initAtPoint:[self getRandomPointInRandomQuadrant]];
    self.enemyView = view;
    self.enemyView.controller = self;
    self.isEnemyPermanentlyExpired = NO;
    [self setView:self.enemyView];
    [view release];
}

-(void)startLifeTimer
{
    self.lifeTimeCurrent = LIFE_TIMER;
    self.lifeTimer = [NSTimer scheduledTimerWithTimeInterval:CLOCK_TICK
                                                  target:self
                                                selector:@selector(lifeTimerFire:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.enemyView viewRefreshWithTime:self.lifeTimeCurrent];
}

-(void)lifeTimerFire:(NSTimer *)timer
{
    self.lifeTimeCurrent--;
    if(_isEnemyPermanentlyExpired == YES)
    {
        [self.lifeTimer invalidate];
        self.lifeTimer = nil;
    } else
    {
        if (self.lifeTimeCurrent == EV_ZERO)
        {
            [self expireLifeTimerWithEnemyDefeated:NO];
        } else
        {
            [self.enemyView viewRefreshWithTime:self.lifeTimeCurrent];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self expireLifeTimerWithEnemyDefeated:YES];
}

-(void)expireLifeTimerWithEnemyDefeated:(BOOL)boolean
{
    [self.lifeTimer invalidate];
    self.lifeTimer = nil;
    
        if(boolean == YES)
        {
            [self.delegate enemyWasDefeated];
            self.enemyView.image = [UIImage imageNamed:@"enemy_caught"];
        }
        if(boolean == NO)
            [self.delegate enemyWasNotDefeated];
        
        [UIView animateWithDuration:APPEAR_DURATION
                         animations:^{
                             self.enemyView.alpha = NOT_VISIBLE;
                         }
                         completion:^(BOOL finished)
         {
             if(boolean == YES)
                 self.enemyView.image = [UIImage imageNamed:@"enemy_burglar"];
             self.currentFrame = _enemyView.frame;
             _currentFrame.origin = [self getRandomPointInRandomQuadrant];
             self.enemyView.frame = _currentFrame;
             [UIView animateWithDuration:DISAPPEAR_DURATION
                              animations:^{
                                  self.enemyView.alpha = VISIBLE;
                              }
                              completion:^(BOOL finished)
              {
                  if(_isEnemyPermanentlyExpired == NO)
                  {
                      [self startLifeTimer];
                      [self.delegate enemyDidAppear:self];
                  } else
                  {
                      [self.lifeTimer invalidate];
                      self.lifeTimer = nil;
                  }
              }];
         }];
    
}
-(CGPoint)getRandomPointInRandomQuadrant
{
    _randomQuadrant = arc4random() % GAME_QUADRANTS;
    _randomPoint = [self getRandomPoint];
    if (_randomQuadrant == THIRD)
    {
        _randomPoint.x += DWIDTH;
    } else if (_randomQuadrant == SECOND)
    {
        _randomPoint.x += WIDTH;
    }
    return _randomPoint;
}

-(CGPoint)getRandomPoint
{
    _randomPoint = CGPointMake((arc4random() % ((WIDTH - IMAGE_WIDTH - SCREEN_BORDER)*INT_HUNDRED)/FLOAT_HUNDRED),
                               (arc4random() % ((I35IR_HEIGHT-IMAGE_HEIGHT-GAME_LABEL_BORDER))*INT_HUNDRED)/FLOAT_HUNDRED);
    return _randomPoint;
}
-(void)invalidateTimer
{
    [self.lifeTimer invalidate];
    self.lifeTimer = nil;
}
@end
