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
int const WIDTH = 320;
int const DWIDTH = 640;
//int const I4IR_WIDTH = 320; //unused for now, but will be used later on

int const IMAGE_WIDTH = 40;
int const IMAGE_HEIGHT = 70;

float const LIFE_TIMER = 5;
int const CLOCK_TICK = 1;

float const APPEAR_DURATION = 0.2;
float const DISAPPEAR_DURATION = 0.2;
float const VISIBLE = 1;
float const NOT_VISIBLE = 0;

int const GAME_QUADRANTS = 3;
typedef enum
{
    FIRST = 0,
    SECOND = 1,
    THIRD = 2,
}GameQuadrant;

@interface EnemyViewController ()
@property (nonatomic, retain) EnemyView *enemyView;
@property (nonatomic, retain) NSTimer *lifeTimer;
@property (nonatomic, assign) float lifeTimeCurrent;

@property (nonatomic, assign) GameQuadrant randomQuadrant;
@property (nonatomic, assign) CGPoint randomPoint;
@property (nonatomic, assign) CGRect currentFrame;
@end

@implementation EnemyViewController
-(void)loadView
{
    EnemyView *view = [[EnemyView alloc] initAtPoint:[self getRandomPointInRandomQuadrant]];
    _enemyView = view;
    _enemyView.controller = self;
    
    [self setView:_enemyView];
    [view release];
    
    [self startLifeTimer];
}
-(void)startLifeTimer
{
    _lifeTimeCurrent = LIFE_TIMER;
    _lifeTimer = [NSTimer scheduledTimerWithTimeInterval:CLOCK_TICK
                                                  target:self
                                                selector:@selector(lifeTimerFire:)
                                                userInfo:nil
                                                 repeats:YES];
    [_enemyView viewRefreshWithTime:_lifeTimeCurrent];
}

-(void)lifeTimerFire:(NSTimer *)timer
{
    _lifeTimeCurrent--;
    if (_lifeTimeCurrent == 0)
    {
        [self expireLifeTimerWithEnemyDefeated:NO];
    } else
    {
        [_enemyView viewRefreshWithTime:_lifeTimeCurrent];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self expireLifeTimerWithEnemyDefeated:YES];
}

-(void)expireLifeTimerWithEnemyDefeated:(BOOL)boolean
{
    [_lifeTimer invalidate];
    _lifeTimer = nil; //Should I keep nil here or just remove it? The timer restarts at the end of this method
    if(boolean == YES)
        [_delegate enemyWasDefeated];
    if(boolean == NO)
        [_delegate enemyWasNotDefeated];
    
    [UIView animateWithDuration:APPEAR_DURATION
                     animations:^{
                         _enemyView.alpha = NOT_VISIBLE;
                     }
                     completion:^(BOOL finished)
     {
         _currentFrame = _enemyView.frame;
         _currentFrame.origin = [self getRandomPointInRandomQuadrant];
         _enemyView.frame = _currentFrame;
         [UIView animateWithDuration:DISAPPEAR_DURATION
                          animations:^{
                              _enemyView.alpha = VISIBLE;
                          }
                          completion:^(BOOL finished)
          {
              [self startLifeTimer];
          }];
     }];
}

-(CGPoint)getRandomPointInRandomQuadrant
{
    _randomQuadrant = arc4random() % GAME_QUADRANTS;
    _randomPoint = [self getRandomPoint];
    
//    METHOD ALREADY WORKING, but I would still like to do some testing just to make sure
//    NSLog(@"Q %i", _randomQuadrant);
//    NSLog(@"XY %.2f %.2f",_randomPoint.x,_randomPoint.y);

    if (_randomQuadrant == THIRD)
    {
//        NSLog(@"Third!");
        _randomPoint.x += DWIDTH;
    } else if (_randomQuadrant == SECOND)
    {
//        NSLog(@"Second!");
        _randomPoint.x += WIDTH;
    } else
    {
//        NSLog(@"First!");
    }
    return _randomPoint;
}
-(CGPoint)getRandomPoint
{
    _randomPoint = CGPointMake((arc4random() % ((WIDTH-IMAGE_WIDTH-10)*100)/100),
                               (arc4random() % ((I4IR_HEIGHT-IMAGE_HEIGHT-40))*100)/100);
    return _randomPoint;
}
@end
