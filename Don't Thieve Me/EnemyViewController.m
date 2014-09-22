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

float const LIFE_TIMER = 5;
int const CLOCK_TICK = 1;

float const APPEAR_DURATION = 0.4;
float const DISAPPEAR_DURATION = 0.4;

typedef enum
{
    FIRST_QUADRANT = 0,
    SECOND_QUADRANT = 1,
    THIRD_QUADRANT = 2,
}GameQuadrant;

int const SECOND_QUADRANT_POSITION = 320;
int const THIRD_QUADRANT_POSITION = 640;
int const GAME_QUADRANTS = 3;

float const VISIBLE = 1;
float const NOT_VISIBLE = 0;
int const EV_ZERO=0;
int const INT_HUNDRED = 100;
float const FLOAT_HUNDRED = 100;

int const I35IR_HEIGHT = 480;
int const EVC_WIDTH = 320;
int const IMAGE_WIDTH = 53;
int const IMAGE_HEIGHT = 93;
int const SCREEN_BORDER = 10;
int const GAME_LABEL_BORDER = 50;
int const INDICATOR_WIDTH = 30;
int const INDICATOR_HEIGHT = 30;

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
    [self.enemyView refreshViewWithTime:self.lifeTimeCurrent];
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
            [self.enemyView refreshViewWithTime:self.lifeTimeCurrent];
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
         [self respawnEnemyAtRandomPointInRandomQuadrant];
         
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

-(void)respawnEnemyAtRandomPointInRandomQuadrant
{
    self.currentFrame = _enemyView.frame;
    _currentFrame.origin = [self getRandomPointInRandomQuadrant];
    self.enemyView.frame = _currentFrame;
}

-(CGPoint)getRandomPointInRandomQuadrant
{
    _randomQuadrant = arc4random() % GAME_QUADRANTS;
    _randomPoint = [self getRandomPoint];
    
    if (_randomQuadrant == THIRD_QUADRANT)
        _randomPoint.x += THIRD_QUADRANT_POSITION;
    else if (_randomQuadrant == SECOND_QUADRANT)
        _randomPoint.x += SECOND_QUADRANT_POSITION;
    
    return _randomPoint;
}

-(CGPoint)getRandomPoint
{
    _randomPoint = CGPointMake((arc4random() % ((EVC_WIDTH - IMAGE_WIDTH - SCREEN_BORDER)*INT_HUNDRED)/FLOAT_HUNDRED),
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
