//
//  GameStore.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/12/14.
//
//

#import "GameStore.h"

NSString *const GAMESTORE_FILEPATH = @"scores.json";
NSString *const PATH_FOR_RESOURCE = @"scores";
NSString *const JSON_TYPE = @"json";

NSString *const GPATH_HS = @"high score";
NSString *const GPATH_HS_1 = @"1";
NSString *const GPATH_HS_1_SCORE = @"SCORE";

NSString *const RAISE_EXCEPTION = @"Singleton";
NSString *const FORMAT = @"Use +[GameStore sharedStore";

int const FIRST_OBJECT = 0;

@interface GameStore()
@property (nonatomic, assign) NSMutableDictionary *privateGameFiles;
@property (nonatomic, assign) NSString *filePath;
@property (nonatomic, assign) BOOL *fileRetrieved;

@property (nonatomic, assign) NSDictionary *highScoreDictionary;
@property (nonatomic, assign) NSString *convertedInteger;
@end

@implementation GameStore
-(id)init
{
    [NSException raise:RAISE_EXCEPTION
                format:FORMAT];
    return self;
}

-(id)initPrivate
{
    self = [super init];
    if(self)
    {
        //CREATE PATH TO SANDBOX
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
        
        self.filePath = [paths objectAtIndex:FIRST_OBJECT];
        self.filePath = [self.filePath stringByAppendingPathComponent:GAMESTORE_FILEPATH];
        
        //CHECK IF THERE IS AN EXISTING SANDBOX FILE
        self.privateGameFiles = [NSMutableDictionary dictionaryWithContentsOfFile:self.filePath];
        
        if(!self.privateGameFiles)
        {
            //NO SANDBOX FILE. CREATE ONE FROM TEMPLATE
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:PATH_FOR_RESOURCE
                                                                 ofType:JSON_TYPE];
            NSData *data = [NSData dataWithContentsOfFile:jsonPath];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:nil];
            //WRITE TO SAND BOX
            [[NSString stringWithFormat:@"%@",json] writeToFile:self.filePath
                                                                      atomically:YES
                                                                        encoding:NSUTF8StringEncoding
                                                                           error:nil];
            
            //RETRIEVE FILE
            self.privateGameFiles = [NSMutableDictionary dictionaryWithContentsOfFile:self.filePath];
        }
    }
    return self;
}

+(id)sharedStore
{
    static GameStore *sharedStore;
    if(!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

-(int)getHighScoreIntValue
{
    return [[_privateGameFiles valueForKey:@"high score"] intValue];
}

-(void)storeHighScoreWithIntValue:(int)score
{
    NSLog(@"Begin HS-Storing");
    [_privateGameFiles setObject:[NSNumber numberWithInt:score]
                         forKey:@"high score"];
    NSLog(@"%@",_privateGameFiles);
    NSLog(@"End HS_Storing");
}
@end
