//
//  EnemyViewController.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#import "EnemyViewController.h"
#import "EnemyViewIndicator.h"
#import "EnemyView.h"

int const CONTENT_WIDTH = 960;
int const I4IR_HEIGHT = 568;
int const I35IR_HEIGHT = 480;
int const WIDTH = 320;
int const DWIDTH = 640;

int const IMAGE_WIDTH = 53;
int const IMAGE_HEIGHT = 93;
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
int const INDICATOR_WIDTH = 30;
int const INDICATOR_HEIGHT = 30;

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
+(NSMutableArray *)generateEnemies:(int)number_of_enemies delegate:(id)delegate;
{
    NSMutableArray *enemies = [[[NSMutableArray alloc] init] autorelease];
    CGRect indicatorFrame = CGRectMake(EV_ZERO,
                                       EV_ZERO,
                                       INDICATOR_WIDTH,
                                       INDICATOR_HEIGHT);
    
    for(int i=EV_ZERO; i < number_of_enemies; i++)
    {
        EnemyViewController *enemy = [[[EnemyViewController alloc] init] autorelease];
        enemy.delegate = delegate;
        EnemyViewIndicator *indicator = [[[EnemyViewIndicator alloc] initWithFrame:indicatorFrame] autorelease];
        enemy.indicator = indicator;
        
        enemies[i] = enemy;
        enemy = nil;
        indicator = nil;
        [delegate enemyViewCreated:enemies[i]];
    }
    return enemies;
}

-(void)viewDidLoad
{
    CGPoint random = [self getRandomPointInRandomQuadrant];
    CGRect frame = CGRectMake(random.x, random.y, IMAGE_WIDTH, IMAGE_HEIGHT);
    EnemyView *view = [[EnemyView alloc] initWithFrame:frame];

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
                                                selector:@selector(fireLifeTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.enemyView viewRefreshWithTime:self.lifeTimeCurrent];
}

-(void)startLifeTimerWithIndicator
{
    if(_isEnemyPermanentlyExpired == NO)
    {
        [self startLifeTimer];
        [self.delegate enemyDidAppear:self];
    }
}

-(void)fireLifeTimer:(NSTimer *)timer
{
    self.lifeTimeCurrent--;
    if(_isEnemyPermanentlyExpired == YES)
    {
        [self invalidateTimer];
    } else
    {
        if (self.lifeTimeCurrent == EV_ZERO)
            [self expireLifeTimerWithEnemyDefeated:NO];
        else
            [self.enemyView viewRefreshWithTime:self.lifeTimeCurrent];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self expireLifeTimerWithEnemyDefeated:YES];
}

-(void)expireLifeTimerWithEnemyDefeated:(BOOL)boolean
{
    [self invalidateTimer];
    if(boolean == YES)
    {
        [self.enemyView changeImageToCaught];
        [self.delegate enemyWasDefeated];
    }    
    [self animateEnemySpawn];
}

-(void)animateEnemySpawn
{
    [UIView animateWithDuration:APPEAR_DURATION
                     animations:^{
                         self.enemyView.alpha = NOT_VISIBLE;
                     }
                     completion:^(BOOL finished)
     {
         [self.enemyView changeImageToNormal];
         [self respawnEnemyAtRandomPoint];
         
         [UIView animateWithDuration:DISAPPEAR_DURATION
                          animations:^{
                              self.enemyView.alpha = VISIBLE;
                          }
                          completion:^(BOOL finished)
          {
              [self startLifeTimerWithIndicator];
          }];
     }];
}

-(void)respawnEnemyAtRandomPoint
{
    self.currentFrame = _enemyView.frame;
    _currentFrame.origin = [self getRandomPointInRandomQuadrant];
    self.enemyView.frame = _currentFrame;
}

-(CGPoint)getRandomPointInRandomQuadrant
{
    _randomQuadrant = arc4random() % GAME_QUADRANTS;
    _randomPoint = [self getRandomPoint];
    
    if (_randomQuadrant == THIRD)
        _randomPoint.x += DWIDTH;
    else if (_randomQuadrant == SECOND)
        _randomPoint.x += WIDTH;
    
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

-(void)dealloc
{
    [_enemyView release];
    _enemyView = nil;
    
    [_lifeTimer release];
    _lifeTimer = nil;

    [super dealloc];
}
@end
