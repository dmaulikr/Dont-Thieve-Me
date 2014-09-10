//
//  Constants.h
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/10/14.
//
//

#ifndef Don_t_Thieve_Me_Constants_h
#define Don_t_Thieve_Me_Constants_h
#endif

int const I4IR_WIDTH = 320;
int const I4IR_HEIGHT = 568;
int const CONTENT_WIDTH = 960;
int const I4IR_DWIDTH = 640;

//int const WIDTH = 320;

float const SWIPE_OBJ_DURATION = 0.3;
NSString *const MAP_IMG = @"dtm_map_med";

//LABELVIEW Constants
NSString *const TEXT_TIMER = @"Timer: ";
NSString *const TEXT_SCORE = @"Score: ";

//GAMEVIEWCONTROLLER Constants
int const INIT_TIME = 60;
int const END_TIME = 0;

int const INIT_SCORE = 0;
int const SCORE_PER_HIT = 1;

int const GAME_CLOCK_TICK = 1;


//ENEMYVIEW Constants
NSString *const CHAR_IMAGE = @"enemy_burglar";
NSString *const RESET_TEXT = @"";

//ENEMYVIEWCONTROLLER Constants
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
