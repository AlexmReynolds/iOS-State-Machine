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
    [super viewDidLoad];
    [self setupStateObject];
    [stateMachine transition:@"loaded"];
	// Do any additional setup after loading the view.
}



// Init the state machine and pass in a dictionary of states, allowed methods, and transitions
// Set eventNotificationType so you can listen to notication center if you want multiple objects listening, or delegate if you want only one object listening.
-(void) setupStateObject
{
        stateMachine = [[iState alloc ]initStateMachineForObject:self withOptions:@{
            iStateInitialState: @"initializing",
            @"states":@{
                @"initializing":@{
                    iStateAllowedTransitions: @[@"loaded"],
                    iStateAllowedMethods  : @[]
                },
                @"loaded":@{
                    iStateAllowedTransitions: @[@"red",@"blue"],
                    iStateAllowedMethods  : @[]
                },
                @"blue":@{
                                iStateAllowedTransitions: @[@"red",@"green"],
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
    
            } eventNotificationType:iStateEventNotificationsUseDelegate] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goRed
{
    self.view.backgroundColor = [UIColor redColor];
}
-(NSString* )goBlue{
    self.view.backgroundColor = [UIColor blueColor];
    return @"STUFFF";
}
-(void)goGreen{
    self.view.backgroundColor = [UIColor greenColor];
}
- (IBAction)redButtonClicked:(id)sender {
    [stateMachine transition:@"red"];
    [stateMachine handle:@selector(goRed) withArguments:nil];
}

- (IBAction)blueButtonClicked:(id)sender {
    [stateMachine transition:@"blue"];
    [stateMachine handle:@selector(goBlue) withArguments:nil];
}

- (IBAction)greenButtonClicked:(id)sender {
    [stateMachine transition:@"green"];
    [stateMachine handle:@selector(goGreen) withArguments:nil];
}



#pragma mark - notification events
-(void) methodHandled:(NSNotification *)notification{
    NSDictionary *data = [notification userInfo];
    NSLog(@"Method Handled notification %@", data);
}



#pragma mark - delegate events

-(void)iStateMethodHandled:(NSDictionary *)data
{
    NSLog(@"delegate handled data: %@", data);
}

-(void)iStateMethodNoHandler:(NSDictionary *)data
{
    NSLog(@"delegate no handler data: %@", data);
    
}
-(void)iStateTransitionCompleted:(NSDictionary *)data
{
    self.currentStateLabel.text = stateMachine.currentState;
    NSLog(@"delegate transition complete data: %@", data);
}
-(void)iStateTransitionFailed:(NSDictionary *)data
{
    NSLog(@"delegate transition failed data: %@", data);
}

@end
