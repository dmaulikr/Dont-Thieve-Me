//
//  GameStore.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/12/14.
//
//

#import "GameStore.h"


NSString *const GAMESTORE_FILEPATH = @"game.json";
NSString *const PATH_FOR_RESOURCE = @"game";
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
//            [self writeToSandBox:json];
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

-(NSDictionary *)allGameFiles
{
    return _privateGameFiles;
}

//-(void)writeToSandBox:(NSDictionary *)dictionary
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask,
//                                                         YES);
//    
//    self.filePath = [paths objectAtIndex:FIRST_OBJECT];
//    self.filePath = [self.filePath stringByAppendingPathComponent:GAMESTORE_FILEPATH];
//
//    [[NSString stringWithFormat:@"%@",dictionary] writeToFile:self.filePath
//                 atomically:YES
//                   encoding:NSUTF8StringEncoding
//                      error:nil];
//}

-(void)setNewHighScore:(int)score
{
//    _highScoreDictionary = [_privateGameFiles valueForKeyPath:@"high score"][@"1"];
    self.convertedInteger = [NSString stringWithFormat:@"%i",score];
    [GameStore sharedStore];
     NSLog(@"1: %@",_privateGameFiles);
    [_privateGameFiles[@"high score"][@"1"] setValue:self.convertedInteger
                                forKey:GPATH_HS_1_SCORE];
    NSLog(@"2: %@",_privateGameFiles);
//    [self writeToSandBox:self.privateGameFiles];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    
    self.filePath = [paths objectAtIndex:FIRST_OBJECT];
    self.filePath = [self.filePath stringByAppendingPathComponent:GAMESTORE_FILEPATH];
    
    [[NSString stringWithFormat:@"%@",self.privateGameFiles] writeToFile:self.filePath
                                                   atomically:YES
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
}
@end
