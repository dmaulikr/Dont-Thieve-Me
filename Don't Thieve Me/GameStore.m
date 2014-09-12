//
//  GameStore.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/12/14.
//
//

#import "GameStore.h"
@interface GameStore()
@property (nonatomic, assign) NSMutableDictionary *privateGameFiles;
@property (nonatomic, assign) NSString *filePath;

@property (nonatomic, assign) NSDictionary *highScoreDictionary;
@property (nonatomic, assign) NSString *convertedInteger;
@end

@implementation GameStore
-(id)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[GameStore sharedStore"];
    return self;
}
-(id)initPrivate
{
    self = [super init];
    
    NSLog(@"Creating GameStore");
    if(self)
    {
        //CREATE PATH TO SANDBOX
        NSLog(@"Creating path to local");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
        
        self.filePath = [paths objectAtIndex:0];
        self.filePath = [self.filePath stringByAppendingPathComponent:@"game.json"];
        
        //CHECK IF THERE IS AN EXISTING SANDBOX FILE
//        NSLog(@"Creating existingDictionary.");
        
        self.privateGameFiles = [NSMutableDictionary dictionaryWithContentsOfFile:self.filePath];
        
        if(!self.privateGameFiles)
        {
            //NO SANDBOX FILE. CREATE ONE FROM TEMPLATE
            NSLog(@"Dictionary does not exist!");
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"game"
                                                                 ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:jsonPath];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:nil];
            //WRITE TO SAND BOX
            [self writeToSandBox:json];
            
            //RETRIEVE FILE
            self.privateGameFiles = [NSMutableDictionary dictionaryWithContentsOfFile:self.filePath];
        }
        //DISPLAY FILE JUST TO MAKE SURE
//        NSLog(@"%@",self.privateGameFiles[@"high score"]);

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
-(void)writeToSandBox:(NSDictionary *)dictionary
{
    [[NSString stringWithFormat:@"%@",dictionary] writeToFile:self.filePath
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:nil];
}

-(void)setNewHighScore:(int)score
{
    self.highScoreDictionary = [_privateGameFiles valueForKeyPath:@"high score"][@"1"];
    
    self.convertedInteger = [NSString stringWithFormat:@"%i",score];
    [self.highScoreDictionary setValue:self.convertedInteger
                                forKey:@"SCORE"];
    
    NSLog(@"New Dictionary: %@",_privateGameFiles);
    [self writeToSandBox:self.privateGameFiles];
}
@end
