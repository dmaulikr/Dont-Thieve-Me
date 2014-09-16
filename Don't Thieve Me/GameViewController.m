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

#import "EnemyView.h"
#import "EnemyViewIndicator.h"
#import "EnemyViewController.h"

int const ZERO = 0;
int const NUMBER_OF_ENEMIES = 5;
int const INIT_TIME = 30;
int const END_TIME = 0;

int const INIT_SCORE = 0;
int const SCORE_PER_HIT = 5
;
int const GAME_CLOCK_TICK = 1;

int const ARROW_IMG_WIDTH = 30;
int const ARROW_IMG_HEIGHT = 30;
int const ARROW_TO_SCREEN_MARGIN = 5;

int const GAME_HEIGHT = 480;
int const GAME_WIDTH = 320;

float const GAME_VISIBLE = 1.0;
float const GAME_NOT_VISIBLE = 0.0;

NSString *const KEYPATH_HIGHSCORE = @"high score";
NSString *const KEYPATH_HIGHSCORE_N_SCORES = @"SCORE";
NSString *const KEYPATH_HIGHSCORE_1 = @"1";

NSString *const LABEL_NEW_HIGH_SCORE = @"\nNew High Score!";
NSString *const LABEL_HIGH_SCORE = @"\nHigh Score: ";

typedef enum
{
    SCREEN_1 = 0,
    SCREEN_2 = GAME_WIDTH,
    SCREEN_3 = GAME_WIDTH*2,
}offsetScreen;

@interface GameViewController () <EnemyControllerDelegate>
@property (nonatomic, retain) GameView *entireView;
@property (nonatomic, retain) GameLabelView *labelView;
@property (nonatomic, assign) CGPoint currentPosition;
@property (nonatomic, assign) offsetScreen currentQuadrant;

@property (nonatomic, assign) NSDictionary *scores;

@property (nonatomic, assign) float timeCurrent;
@property (nonatomic, assign) int scoreCurrent;
@property (nonatomic, assign) int highScore;

@property (nonatomic, retain) NSTimer *gameClock;

@property (nonatomic, retain) NSMutableArray *enemies;
@property (nonatomic, retain) NSMutableArray *indicators;

@property (nonatomic, retain) UILongPressGestureRecognizer *gr; //For debugging only
@end

@implementation GameViewController
-(void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    GameView *view = [[GameView alloc] initWithFrame:applicationFrame];
    self.entireView = view;
    [self setView:self.entireView];
    [view release];
    
    GameLabelView *lView = [[GameLabelView alloc] initWithFrame:applicationFrame];
    self.labelView = lView;
    self.entireView.controller = self.labelView;
    [self.view addSubview:self.labelView];
    [lView release];

    [self beginGameWithTime:INIT_TIME
                  withScore:INIT_SCORE
             withEnemyCount:NUMBER_OF_ENEMIES];
}

#pragma Game Setup
-(void)beginGameWithTime:(float)time withScore:(int)score withEnemyCount:(int)count
{
    if(!self.enemies)
    {
        self.enemies = [NSMutableArray array];
    }
    if(!self.indicators)
    {
        self.indicators = [NSMutableArray array];
    }
    for(int i=ZERO; i < NUMBER_OF_ENEMIES; i++)
    {

        EnemyViewController *enemy = [[[EnemyViewController alloc] init] autorelease];
        enemy.delegate = self;
        
        EnemyViewIndicator *indicator = [[[EnemyViewIndicator alloc] init] autorelease];
        enemy.indicator = indicator;
        self.enemies[i] = enemy;
        self.indicators[i] = indicator;
        
        
        //FOR DEBUGGING ONLY
        self.labelView.gameOverLabel.alpha = GAME_NOT_VISIBLE;
        self.labelView.gameOverLabel.text = @"GAME OVER\nScore: ";
        
        [self.view addSubview:[(EnemyViewController *)self.enemies[i] view]];
        [self.view addSubview:(EnemyViewIndicator *)self.indicators[i]];
        [enemy startLifeTimer];
        
        enemy = nil;
        indicator = nil;
    }

    self.timeCurrent = time;
    self.scoreCurrent = score;

    self.gameClock = [NSTimer scheduledTimerWithTimeInterval:GAME_CLOCK_TICK
                                                  target:self
                                                selector:@selector(gameClockFire:)
                                                userInfo:nil
                                                 repeats:YES];
    self.entireView.userInteractionEnabled = YES;
    [self gameRefresh];
}

-(void)gameRefresh
{
    [self.labelView viewRefreshWithTime:self.timeCurrent withScore:self.scoreCurrent];
}

-(void)gameClockFire:(NSTimer *)timer
{
    self.timeCurrent--;
    [self gameRefresh];
    if(self.timeCurrent == END_TIME)
    {
        [self endGame];
    }
}

-(void)endGame
{
//    self.entireView.userInteractionEnabled = NO;
    [self.gameClock invalidate];
    self.gameClock = nil;
    for(int i=ZERO; i<NUMBER_OF_ENEMIES; i++)
    {
        [self.enemies[i] setIsEnemyPermanentlyExpired:YES];
    }
    for(int i=ZERO; i<NUMBER_OF_ENEMIES; i++)
    {
        UIView *lastEnemyView = [self.enemies[i] view];
        [lastEnemyView removeFromSuperview];
        UIView *lastIndicatorView = self.indicators[i];
        [lastIndicatorView removeFromSuperview];
    }
    [self.enemies removeAllObjects];
    [self.indicators removeAllObjects];

    [self checkForHighScore];
    
    //FOR DEBUGGING ONLY
    self.gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(longpress)];
    [self.entireView addGestureRecognizer:self.gr];
}
-(void)longpress
{
    [self beginGameWithTime:INIT_TIME
                  withScore:INIT_SCORE
             withEnemyCount:NUMBER_OF_ENEMIES];
    [self.entireView removeGestureRecognizer:self.gr];
}

-(void)checkForHighScore
{
    if(!self.scores)
    {
        NSLog(@"SCORES");
        self.scores = [[[GameStore sharedStore] allGameFiles] valueForKeyPath:KEYPATH_HIGHSCORE][KEYPATH_HIGHSCORE_1];
    }
    if(!self.highScore)
    {
        NSLog(@"HIGHSCORE");
        self.highScore = [self.scores[KEYPATH_HIGHSCORE_N_SCORES] intValue];
    }
    
    NSLog(@"STRINGSCORE");
    NSString *stringScore = [NSString stringWithFormat:@"%i",_scoreCurrent];
    self.labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:stringScore];
    self.labelView.gameOverLabel.alpha = GAME_VISIBLE;
    
    NSLog(@"IFSCORE");
    if(_scoreCurrent > _highScore)
    {
        self.labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:LABEL_NEW_HIGH_SCORE];
        [[GameStore sharedStore] setNewHighScore:_scoreCurrent];
    } else
    {
        stringScore = [NSString stringWithFormat:@"%i",_highScore];
        self.labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:LABEL_HIGH_SCORE];
        self.labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:stringScore];
    }
}
#pragma Game Events
-(void)enemyWasDefeated
{
    self.scoreCurrent += SCORE_PER_HIT;
    [self gameRefresh];
}

-(void)enemyWasNotDefeated
{
    
}

-(void)enemyDidAppear:(EnemyViewController *)enemy
{
    self.currentPosition = _entireView.contentOffset;
    float enemyFrameOriginX = enemy.view.frame.origin.x;
    float currentPositionX = _currentPosition.x;
    
    if((currentPositionX == SCREEN_3 && enemyFrameOriginX < SCREEN_3) ||
       (currentPositionX == SCREEN_2 && enemyFrameOriginX < SCREEN_2))
    {
        [self indicateEnemy:enemy
                 atPosition:self.currentPosition
              withDirection:LEFT];
    }
    else if ((currentPositionX == SCREEN_2 && enemyFrameOriginX > SCREEN_3) ||
             (currentPositionX == SCREEN_1 && enemyFrameOriginX > SCREEN_2))
    {
        [self indicateEnemy:enemy
                 atPosition:self.currentPosition
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
