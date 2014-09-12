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
#import "GameStore.h"

#import "EnemyViewIndicator.h"
#import "EnemyViewController.h"

int const ZERO = 0;
int const NUMBER_OF_ENEMIES = 5;
int const INIT_TIME = 10;
int const END_TIME = 0;

int const INIT_SCORE = 0;
int const SCORE_PER_HIT = 1;
int const GAME_CLOCK_TICK = 1;

int const ARROW_IMG_WIDTH = 30;
int const ARROW_IMG_HEIGHT = 30;
int const ARROW_TO_SCREEN_MARGIN = 5;

int const GAME_HEIGHT = 480;
int const GAME_WIDTH = 320;

float const GAME_VISIBLE = 1.0;
float const GAME_NOT_VISIBLE = 0.0;

NSString *const KEYPATH_HIGHSCORE = @"high score";
NSString *const KEYPATH_HIGHSCORE_N_SCORES = @"SCORES";
NSString *const KEYPATH_HIGHSCORE_1 = @"1";

NSString *const LABEL_NEW_HIGH_SCORE = @"\nNew High Score!";
typedef enum
{
    FIRST_SCREEN = 0,
    SECOND_SCREEN = GAME_WIDTH,
    THIRD_SCREEN = GAME_WIDTH*2,
}offsetScreen;

@interface GameViewController () <EnemyControllerDelegate>
@property (nonatomic, retain) GameView *entireView;
@property (nonatomic, retain) GameLabelView *labelView;
@property (nonatomic, assign) CGPoint currentPosition;
@property (nonatomic, assign) offsetScreen currentQuadrant;

@property (nonatomic, assign) NSDictionary *scores;

@property (nonatomic, assign) float timeCurrent;
@property (nonatomic, assign) int scoreCurrent;

@property (nonatomic, retain) NSTimer *gameClock;

@property (nonatomic, retain) NSMutableArray *enemies;
@property (nonatomic, retain) NSMutableArray *indicators;
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
                  withScore:INIT_SCORE
             withEnemyCount:NUMBER_OF_ENEMIES];
}

#pragma Game Setup
-(void)beginGameWithTime:(float)time withScore:(int)score withEnemyCount:(int)count
{
    self.enemies = [NSMutableArray array];
    self.indicators = [NSMutableArray array];
    for(int i=ZERO; i < NUMBER_OF_ENEMIES; i++)
    {
        EnemyViewController *enemy = [[[EnemyViewController alloc] init] autorelease];
        enemy.delegate = self;
        
        EnemyViewIndicator *indicator = [[[EnemyViewIndicator alloc] init] autorelease];
        enemy.indicator = indicator;
        
        self.enemies[i] = enemy;
        self.indicators[i] = indicator;
        [self.view addSubview:[(EnemyViewController *)self.enemies[i] view]];
        [self.view addSubview:(EnemyViewIndicator *)self.indicators[i]];
        
        enemy = nil;
        indicator = nil;
    }

    _timeCurrent = time;
    _scoreCurrent = score;
    _entireView.userInteractionEnabled = YES;
    _gameClock = [NSTimer scheduledTimerWithTimeInterval:GAME_CLOCK_TICK
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
-(void)endGame
{
    _entireView.userInteractionEnabled = NO;
    [_gameClock invalidate];
    _gameClock = nil;
    for(int i=ZERO; i < NUMBER_OF_ENEMIES; i++)
    {
        [[(EnemyViewController *)self.enemies[i] view] removeFromSuperview];
        [(EnemyViewIndicator *)self.indicators[i] removeFromSuperview];
    }
    //Check for high score
    self.scores = [[[GameStore sharedStore] allGameFiles] valueForKeyPath:KEYPATH_HIGHSCORE][KEYPATH_HIGHSCORE_1];
    int highest_score = [self.scores[KEYPATH_HIGHSCORE_N_SCORES] intValue];

    NSString *stringScore = [NSString stringWithFormat:@"%i",_scoreCurrent];
    _labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:stringScore];
    _labelView.gameOverLabel.alpha = GAME_VISIBLE;

    if(_scoreCurrent > highest_score)
    {
        _labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:LABEL_NEW_HIGH_SCORE];
        [[GameStore sharedStore] setNewHighScore:_scoreCurrent];
    }
    
    
}

#pragma Game Events
-(void)enemyWasDefeated
{
    _scoreCurrent += SCORE_PER_HIT;
    [self gameRefresh];
}
-(void)enemyWasNotDefeated
{
    
}
-(void)enemyDidAppear:(EnemyViewController *)enemy
{
    _currentPosition = _entireView.contentOffset;
    if(_currentPosition.x == THIRD_SCREEN && enemy.view.frame.origin.x < THIRD_SCREEN)
    {
        [self indicateEnemy:enemy
                 atPosition:_currentPosition
              withDirection:LEFT];
    }
    else if (_currentPosition.x == SECOND_SCREEN && enemy.view.frame.origin.x < SECOND_SCREEN)
    {
        [self indicateEnemy:enemy
                 atPosition:_currentPosition
              withDirection:LEFT];
    }
    else if (_currentPosition.x == SECOND_SCREEN && enemy.view.frame.origin.x > THIRD_SCREEN)
    {
        [self indicateEnemy:enemy
                 atPosition:_currentPosition
              withDirection:RIGHT];
    }
    else if(_currentPosition.x == FIRST_SCREEN && enemy.view.frame.origin.x > SECOND_SCREEN)
    {
        [self indicateEnemy:enemy
                 atPosition:_currentPosition
              withDirection:RIGHT];
    }
}
-(void)indicateEnemy:(EnemyViewController *)enemy atPosition:(CGPoint)position withDirection:(enumImage)direction
{
    position.y = enemy.view.frame.origin.y;
    if (direction == LEFT)
        position.x += ARROW_TO_SCREEN_MARGIN;
    if (direction == RIGHT)
        position.x = (position.x + GAME_WIDTH) - (ARROW_IMG_WIDTH + ARROW_TO_SCREEN_MARGIN);
    [enemy.indicator setImageDirection:direction atPoint:position];
}

@end
