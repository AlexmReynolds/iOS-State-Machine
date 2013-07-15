//
//  iStateElephantViewController.m
//  iState
//
//  Created by Alex Reynolds on 7/14/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "iStateElephantViewController.h"

@interface iStateElephantViewController ()

@end

@implementation iStateElephantViewController

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
    [super viewDidLoad];
    [self setupSuperState];
    
    // Controller loaded so change state;
    [self transition:@"loaded"];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupSuperState
{
    BOOL stateMachineInitialized = [self initStateMachinewithOptions:@{
     iStateInitialState: @"initializing",
     @"states":@{
         @"initializing":@{
                 iStateAllowedTransitions: @[@"loaded"],
                   iStateAllowedMethods  : @[]
         },
         @"loaded":@{
                 iStateAllowedTransitions: @[@"blue",@"red"],
                   iStateAllowedMethods  : @[@"goBlue", @"goRed"]
         },
         @"blue":@{
                 iStateAllowedTransitions: @[@"red", @"green"],
                   iStateAllowedMethods  : @[@"goBlue"]
         },
         @"red":@{
                 iStateAllowedTransitions: @[@"blue"],
                   iStateAllowedMethods  : @[@"goRed"]
         },
         @"green":@{
                 iStateAllowedTransitions: @[@"blue"],
                   iStateAllowedMethods  : @[@"goGreen"]
         }
     },
     
     }] ;
    
    
    [super viewDidLoad];
}

-(void)goRed{
    self.view.backgroundColor = [UIColor redColor];
}
-(void)goBlue{
    self.view.backgroundColor = [UIColor blueColor];
}
-(void)goGreen{
    self.view.backgroundColor = [UIColor greenColor];
}
- (IBAction)redButtonClicked:(id)sender {
    [self transition:@"red"];
    [self goRed];
}

- (IBAction)blueButtonClicked:(id)sender {
    [self transition:@"blue"];
    [self goBlue];
}

- (IBAction)greenButtonClicked:(id)sender {
    [self transition:@"green"];
    [self goGreen];
}

#pragma mark - Events
-(void)iStateTransitionFailed:(NSDictionary *)data
{
    NSLog(@"FAILED %@", data);
}
-(void)iStateTransitionCompleted:(NSDictionary *)data
{
    _currentStateLabel.text = self.currentState;
    NSLog(@"Complete %@", data);
}
-(void)iStateMethodHandled:(NSDictionary *)data
{
    NSLog(@"Handled %@", data);
}
-(void)iStateMethodNoHandler:(NSDictionary *)data
{
    NSLog(@"NotHandled %@", data);
}
@end
