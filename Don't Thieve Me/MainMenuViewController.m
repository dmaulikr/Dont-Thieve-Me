//
//  MainMenuViewController.m
//  Don't Thieve Me
//
//  Created by Robert De Guzman on 9/16/14.
//
//

#import "MainMenuViewController.h"
#import "GameViewController.h"

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(!self.gvc)
        {
            GameViewController *game = [[GameViewController alloc] init];
            self.gvc = game;
            [game release];
        }
    }
    return self;
}

- (IBAction)pressedStartButton:(id)sender {
    [self.navigationController pushViewController:_gvc animated:NO];
}

@end
