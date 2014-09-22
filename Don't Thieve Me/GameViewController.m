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

int const INIT_TIME = 30; //The length of time the game will run
int const INIT_SCORE = 0; //Starting score
int const NUMBER_OF_ENEMIES = 5; //The number of enemies appearing in all the screens at any given time
int const SCORE_PER_HIT = 1; //The number added to the score for every enemy defeated

int const GAME_CLOCK_TICK = 1;
int const END_TIME = 0;
int const GVC_ZERO = 0;

int const ARROW_IMG_WIDTH = 30;
int const ARROW_IMG_HEIGHT = 30;
int const ARROW_TO_SCREEN_MARGIN = 5;

int const GAME_WIDTH = 320;

NSString *const DICTIONARY_FILENAME = @"high score";

typedef enum
{
    SCREEN_1 = 0,
    SCREEN_2 = GAME_WIDTH,
    SCREEN_3 = GAME_WIDTH*2,
}offsetScreen;

NSString *const GAMESTORE_FILEPATH = @"scores.json";
NSString *const PATH_FOR_RESOURCE = @"scores";
NSString *const JSON_TYPE = @"json";
int const FIRST_OBJECT = 0;

@interface GameViewController () <EnemyControllerDelegate>
@property (nonatomic, retain) GameView *entireView;
@property (nonatomic, retain) GameLabelView *gameTextView;
@property (nonatomic, assign) CGPoint currentPosition;
@property (nonatomic, assign) offsetScreen currentQuadrant;

@property (nonatomic, assign) float currentTime;
@property (nonatomic, assign) int currentScore;
@property (nonatomic, assign) int highScore;
@property (nonatomic, assign) BOOL isGameOngoing;

@property (nonatomic, retain) NSTimer *gameClock;
@property (nonatomic, retain) NSMutableArray *enemies;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation GameViewController
#pragma mark GameViewController Initializers
-(void)viewDidLoad
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    [self setUpGameViewWithFrame:applicationFrame];
    [self setUpGameLabelViewWithFrame:applicationFrame];
    [self readFileFromSandBox];
    
    self.longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(longPressedScreen)] autorelease];
}

-(void)setUpGameViewWithFrame:(CGRect)frame
{
    GameView *view = [[GameView alloc] initWithFrame:frame];
    self.entireView = view;
    [self setView:self.entireView];
    [view release];
}

-(void)setUpGameLabelViewWithFrame:(CGRect)frame
{
    GameLabelView *labelView = [[GameLabelView alloc] initWithFrame:frame];
    self.gameTextView = labelView;
    self.entireView.controller = self.gameTextView;
    [self.view addSubview:self.gameTextView];
    [labelView release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self beginGameWithTime:INIT_TIME
                  withScore:INIT_SCORE
             withEnemyCount:NUMBER_OF_ENEMIES];
}

#pragma mark Game Setup
-(void)beginGameWithTime:(float)time withScore:(int)score withEnemyCount:(int)count
{
    if(!_isGameOngoing)
    {
        self.enemies = [EnemyViewController generateEnemies:count
                                                   delegate:self];
        [self setCurrentScore:score];
        [self.gameTextView resetLabelPosition];
        [self setGameStartingPosition];
        
        
        [self beginGameWithTime:time];
        [self setIsGameOngoing:YES];
        [self refreshGame];
    }
}

-(void)beginGameWithTime:(float)time
{
    self.currentTime = time;
    self.gameClock = [NSTimer scheduledTimerWithTimeInterval:GAME_CLOCK_TICK
                                                      target:self
                                                    selector:@selector(fireGameClock:)
                                                    userInfo:nil
                                                     repeats:YES];
}

-(void)enemyViewCreated:(EnemyViewController *)enemyView
{
    [self.view addSubview:enemyView.view];
    [self.view addSubview:enemyView.indicator];
    [enemyView startLifeTimer];
}

-(void)setGameStartingPosition
{
    _currentPosition.x = GVC_ZERO;
    self.entireView.contentOffset = _currentPosition;
}

-(void)refreshGame
{
    [self.gameTextView refreshViewWithTime:_currentTime
                              withScore:_currentScore];
    [self.gameTextView resetGameOverLabel];
}

-(void)fireGameClock:(NSTimer *)timer
{
    self.currentTime--;
    [self refreshGame];
    if(_currentTime == END_TIME)
    {
        [self endGame];
    }
}

#pragma mark End Game Modifiers
-(void)endGame
{
    [self removeGameObjects];
    BOOL isNewHighScoreAchieved = [self didPlayerAchieveHighScore];
    [self showGameOverScreenDidAchieveHighScore:isNewHighScoreAchieved];

    [self.gameTextView isGameOverLabelHidden:NO];
    [self.entireView addGestureRecognizer:self.longPressGesture];
}

-(void)removeGameObjects
{
    [self.gameClock invalidate];
    self.gameClock = nil;

    for(EnemyViewController *enemyView in self.enemies)
    {
        [enemyView setIsEnemyPermanentlyExpired:YES];
        [enemyView.view removeFromSuperview];
        [enemyView.indicator removeFromSuperview];
    }
    [self.enemies removeAllObjects];
}

-(BOOL)didPlayerAchieveHighScore
{
    if(_currentScore > _highScore)
        return YES;
    else
        return  NO;
}

-(void)showGameOverScreenDidAchieveHighScore:(BOOL)highScoreIsAchieved
{
    if(highScoreIsAchieved) {
        self.highScore = _currentScore;
        [self writeFileToSandBox];
        [self.gameTextView showGameOverWithNewHighScore:_currentScore];
    }
    else
        [self.gameTextView showGameOverWithScore:_currentScore
                                withHighScore:_highScore];
    
    [self.gameTextView refreshViewWithGameOverLabels];
}

-(void)longPressedScreen
{
    [self.entireView removeGestureRecognizer:self.longPressGesture];
    [self setIsGameOngoing:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark Game Events
-(void)enemyWasDefeated
{
    self.currentScore += SCORE_PER_HIT;
    [self refreshGame];
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
                 atPosition:_currentPosition
              withDirection:LEFT_ARROW];
    }
    else if ((currentPositionX == SCREEN_2 && enemyFrameOriginX > SCREEN_3) ||
             (currentPositionX == SCREEN_1 && enemyFrameOriginX > SCREEN_2))
    {
        [self indicateEnemy:enemy
                 atPosition:_currentPosition
              withDirection:RIGHT_ARROW];
    }
}

-(void)indicateEnemy:(EnemyViewController *)enemy atPosition:(CGPoint)position withDirection:(enumIndicator)direction
{
    position.y = enemy.view.frame.origin.y;
    if (direction == LEFT_ARROW)
        position.x += ARROW_TO_SCREEN_MARGIN;
    if (direction == RIGHT_ARROW)
        position.x = (position.x + GAME_WIDTH) - (ARROW_IMG_WIDTH + ARROW_TO_SCREEN_MARGIN);
    [enemy.indicator setImageDirection:direction atPoint:position];
}

#pragma mark Game Helper Methods
-(void)readFileFromSandBox
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[self dictionaryFilePath]];
    self.highScore = [[dictionary valueForKey:DICTIONARY_FILENAME] intValue];
}

-(void)writeFileToSandBox
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:self.highScore]
                                                                         forKey:DICTIONARY_FILENAME];
    [[NSString stringWithFormat:@"%@",dictionary] writeToFile:[self dictionaryFilePath]
                                                   atomically:YES
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    
}

-(NSString *)dictionaryFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *filePath = [paths objectAtIndex:FIRST_OBJECT];
    filePath = [filePath stringByAppendingPathComponent:GAMESTORE_FILEPATH];
    return filePath;
}

-(NSMutableArray *)enemies
{
    if(_enemies == nil) {
        _enemies = [[NSMutableArray alloc] init];
    }
    return _enemies;
}

-(void)dealloc
{
    [_entireView release];
    _entireView = nil;
    [_gameTextView release];
    _gameTextView = nil;
    
    [_gameClock invalidate];
    _gameClock = nil;

    _enemies = nil;
    
    [super dealloc];
}
@end