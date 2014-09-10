//
//  GameViewController.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/9/14.
//
//

#import "GameViewController.h"
#import "GameView.h"
#import "GameLabelView.h"
#import "EnemyViewController.h"

int const INIT_TIME = 30;
int const INIT_SCORE = 0;
int const END_TIME = 0;
int const SCORE_PER_HIT = 1;

@interface GameViewController () <EnemyControllerDelegate>
@property (nonatomic, retain) GameView *entireView;
@property (nonatomic, retain) GameLabelView *labelView;

@property (nonatomic, assign) float timeCurrent;
@property (nonatomic, assign) int scoreCurrent;

@property (nonatomic, retain) NSTimer *gameClock;

@property (nonatomic, retain) EnemyViewController *enemy1;
@property (nonatomic, retain) EnemyViewController *enemy2;
@property (nonatomic, retain) EnemyViewController *enemy3;
@property (nonatomic, retain) EnemyViewController *enemy4;
@property (nonatomic, retain) EnemyViewController *enemy5;

@end

@implementation GameViewController
-(void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    GameView *view = [[GameView alloc] initWithFrame:applicationFrame];
    _entireView = view;
    [self setView:_entireView];
    [view release];
    
    GameLabelView *lView = [[GameLabelView alloc] initWithFrame:applicationFrame];
    _labelView = lView;
    _entireView.controller = _labelView;
    [self.view addSubview:_labelView];
    [lView release];
    
    [self beginGameWithTime:INIT_TIME
                       withScore:INIT_SCORE];
    
    EnemyViewController *enemy = [[EnemyViewController alloc] init];
    _enemy1 = enemy;
    _enemy1.delegate = self;
    [self.view addSubview:_enemy1.view];
    
    EnemyViewController *enemy2 = [[EnemyViewController alloc] init];
    _enemy2 = enemy2;
    _enemy2.delegate = self;
    [self.view addSubview:_enemy2.view];
    
    EnemyViewController *enemy3 = [[EnemyViewController alloc] init];
    _enemy3 = enemy3;
    _enemy3.delegate = self;
    [self.view addSubview:_enemy3.view];
    
    EnemyViewController *enemy4 = [[EnemyViewController alloc] init];
    _enemy4 = enemy4;
    _enemy4.delegate = self;
    [self.view addSubview:_enemy4.view];

}

-(void)beginGameWithTime:(float)time withScore:(int)score
{
    _timeCurrent = time;
    _scoreCurrent = score;
    _gameClock = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(gameClockFire:)
                                                userInfo:nil
                                                 repeats:YES];
    [self gameRefresh];
}

-(void)gameRefresh
{
    [_labelView viewRefreshWithTime:_timeCurrent withScore:_scoreCurrent];
}

-(void)gameClockFire:(NSTimer *)timer
{
    _timeCurrent--;
    [self gameRefresh];
    if(_timeCurrent == END_TIME)
    {
        [self endGame];
    }
}

-(void)enemyWasDefeated
{
    _scoreCurrent += SCORE_PER_HIT;
    [self gameRefresh];
}
-(void)enemyWasNotDefeated
{

}

-(void)endGame
{
    [_gameClock invalidate];
    _gameClock = nil;
    [_enemy1.view removeFromSuperview];
    [_enemy2.view removeFromSuperview];
    [_enemy3.view removeFromSuperview];
    [_enemy4.view removeFromSuperview];

    _entireView.userInteractionEnabled = NO;
    [_enemy1 release];
    [_enemy2 release];
    [_enemy3 release];
    [_enemy4 release];
}

@end
