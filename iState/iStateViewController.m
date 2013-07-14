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
	// Do any additional setup after loading the view.
}

-(void) setupSuperState
{
    [self initStateMachinewithOptions:@{
         @"initialState": @"initializing",
         @"states":@{
             @"initializing":@{
               iStateAllowedTransitions: @[@"loaded"],
                 iStateAllowedMethods  : @[@"foo:", @"bar", @"foo:bar:"]
             },
             @"loaded":@{
               iStateAllowedTransitions: @[],
                 iStateAllowedMethods  : @[@"foo:"]
             }
         },
     
     }] ;
    
    
    [super viewDidLoad];
    
    [self foo:@"tim"];
    [self foo:@"test" bar:@[@1,@2]];
    [self bar];
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
                    iStateAllowedMethods  : @[@"foo:", @"bar", @"foo:bar:"]
                },
                @"loaded":@{
                    iStateAllowedTransitions: @[],
                    iStateAllowedMethods  : @[@"foo:"]
                }
            },
    
            } eventNotificationType:iStateEventNotificationsUseDelegate] ;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(methodHandled:) name:iStateEventHandled object:nil];
    
    
    if([stateMachine handle:@selector(foo:) withArguments:@[@"tom"]]){
        NSLog(@"Can handle");
    }
    if([stateMachine handle:@selector(foo:bar:) withArguments:@[@"tom",@[@1,@2,@3]]]){
        NSLog(@"can handle");
    }
    
    NSLog(@"current state %@", stateMachine.currentState);
    /// Try to change states
    if([stateMachine transition:@"loaded"]){
        NSLog(@"we can transition");
        NSLog(@"current state %@", stateMachine.currentState);
        NSLog(@"previous state %@", stateMachine.previousState);
    }
    
    // Now in new state try methods
    if([stateMachine handle:@selector(foo:) withArguments:@[@"tom"]]){
        NSLog(@"Can handle");
    }
    if([stateMachine handle:@selector(foo:bar:) withArguments:@[@"tom",@[@1,@2,@3]]]){
        NSLog(@"can handle");
    }
    
    // Try to transition to non-existent state
    [stateMachine transition:@"doesntexist"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)foo:(NSString *)name
{
    NSLog(@"child foo %@",name);
}
-(void)bar{
    NSLog(@"child bar");
}
-(void)foo:(NSString *)name bar:(NSArray *)last
{
    NSLog(@"child foo:bar: %@ %@", name, last);
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
    NSLog(@"delegate transition complete data: %@", data);
}
-(void)iStateTransitionFailed:(NSDictionary *)data
{
    NSLog(@"delegate transition failed data: %@", data);
}
@end
