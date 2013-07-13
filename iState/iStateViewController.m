//
//  iStateViewController.m
//  iState
//
//  Created by Alex Reynolds on 7/12/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "iStateViewController.h"

@interface iStateViewController ()

@end

@implementation iStateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization


    }
    return self;
}
- (void)viewDidLoad
{
    [self setupStateMachine:@{
     
        @"states":@{
            @"initializing":@{
                @"allowedTransitions": @[],
                @"allowedMethods"  : @[@"foo", @"bar"]
            },
            @"loaded":@{
                @"allowedTransitions": @[],
                @"allowedMethods"  : @[@"foo"]
            }
        }
     
     }];
    
    [super viewDidLoad];
    [self foo];
    [self bar];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)foo
{
    NSLog(@"child foo");
}
-(void)bar{
    NSLog(@"child bar");
}
@end
