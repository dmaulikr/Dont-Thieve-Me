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

#import "EnemyView.h"
#import "EnemyViewIndicator.h"
#import "EnemyViewController.h"

int const ZERO = 0;
int const NUMBER_OF_ENEMIES = 5;
int const INIT_TIME = 30;
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

NSString *const LABEL_NEW_HIGH_SCORE = @"\nNew High Score!";
NSString *const LABEL_HIGH_SCORE = @"\nHigh Score: ";
NSString *const LABEL_GAME_OVER = @"GAME OVER\nScore: ";

typedef enum
{
    SCREEN_1 = 0,
    SCREEN_2 = GAME_WIDTH,
    SCREEN_3 = GAME_WIDTH*2,
}offsetScreen;

NSString *const KEYPATH_HIGHSCORE = @"high score";
NSString *const KEYPATH_HIGHSCORE_N_SCORES = @"SCORE";
NSString *const KEYPATH_HIGHSCORE_1 = @"1";

NSString *const GAMESTORE_FILEPATH = @"scores.json";
NSString *const PATH_FOR_RESOURCE = @"scores";
NSString *const JSON_TYPE = @"json";
int const FIRST_OBJECT = 0;

@interface GameViewController () <EnemyControllerDelegate>
@property (nonatomic, retain) GameView *entireView;
@property (nonatomic, retain) GameLabelView *labelView;
@property (nonatomic, assign) CGPoint currentPosition;
@property (nonatomic, assign) offsetScreen currentQuadrant;

@property (nonatomic, assign) float timeCurrent;
@property (nonatomic, assign) int scoreCurrent;
@property (nonatomic, assign) BOOL isGameOngoing;

@property (nonatomic, retain) NSTimer *gameClock;

@property (nonatomic, retain) NSMutableArray *enemies;
@property (nonatomic, retain) NSMutableArray *indicators;

@property (nonatomic, retain) UILongPressGestureRecognizer *pressGesture;

@end

@implementation GameViewController
-(void)viewDidLoad
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
    
    self.pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(pressedPlayAgain)];
    
    [self readFileFromSandBox];

}

-(void)viewWillAppear:(BOOL)animated
{
    if(!_isGameOngoing)
    {
        [self beginGameWithTime:INIT_TIME
                      withScore:INIT_SCORE
                 withEnemyCount:NUMBER_OF_ENEMIES];
    }
}

#pragma Game Setup
-(void)beginGameWithTime:(float)time withScore:(int)score withEnemyCount:(int)count
{
    self.labelView.gameOverLabel.text = LABEL_GAME_OVER;
    self.labelView.gameOverLabel.alpha = GAME_NOT_VISIBLE;

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
    self.isGameOngoing = YES;
    _currentPosition.x = ZERO;
    self.entireView.contentOffset = _currentPosition;
    
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
        lastEnemyView = nil;
        UIView *lastIndicatorView = self.indicators[i];
        [lastIndicatorView removeFromSuperview];
        lastIndicatorView = nil;
    }
    [self.enemies removeAllObjects];
    [self.indicators removeAllObjects];
    
    if(_scoreCurrent > _highScore)
    {
        [self scoreRefreshWithNewHighScore:YES];
    } else
    {
        [self scoreRefreshWithNewHighScore:NO];
    }
    
    [self.entireView addGestureRecognizer:self.pressGesture];
}

-(void)scoreRefreshWithNewHighScore:(BOOL)boolean
{
    NSString *stringScore = [NSString stringWithFormat:@"%i",_scoreCurrent];
    self.labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:stringScore];
    
    if(boolean)
    {
        self.highScore = _scoreCurrent;
        self.labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:LABEL_NEW_HIGH_SCORE];
        [self writeFileToSandBox];
    } else
    {
        self.labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:LABEL_HIGH_SCORE];
        stringScore = [NSString stringWithFormat:@"%i",_highScore];
        self.labelView.gameOverLabel.text = [_labelView.gameOverLabel.text stringByAppendingString:stringScore];
    }
    
    self.labelView.gameOverLabel.alpha = GAME_VISIBLE;
}

-(void)pressedPlayAgain
{
    self.isGameOngoing = NO;
    [self.navigationController popViewControllerAnimated:NO];
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

-(void)readFileFromSandBox
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *filePath = [paths objectAtIndex:FIRST_OBJECT];
    filePath = [filePath stringByAppendingPathComponent:GAMESTORE_FILEPATH];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    self.highScore = [[dictionary valueForKey:@"high score"] intValue];
}
-(void)writeFileToSandBox
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *filePath = [paths objectAtIndex:FIRST_OBJECT];
    filePath = [filePath stringByAppendingPathComponent:GAMESTORE_FILEPATH];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:self.highScore]
                                                                         forKey:@"high score"];
    [[NSString stringWithFormat:@"%@",dictionary] writeToFile:filePath
                                                   atomically:YES
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    
}

@end
