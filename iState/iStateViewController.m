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
    // Create a reference to self if we are going to call self from the blocks
    // Arc uses __weak to break retain cycles
    #if __has_feature(objc_arc)
        __block typeof(self) stateSelf = self;
    #else
        __weak typeof(self) stateSelf = self;
    #endif
    
    // Declare a block used for an onEnter or onExit method
    void (^aBlock)(void)= ^{[stateSelf testit];};
    void (^bBlock)(void)= ^{
        NSLog(@"onExit");
    };
    
    // Options is an NSDictionary
    // States is an array of state objects
    // State is an object that defines allowedTransitions, allowedMethods, and blocks to call onEnter and onExit of the state
    // OnEnter and OnExit take a block. You can declare the block inline or pass in a block reference.
    
        stateMachine = [[iState alloc ]initStateMachineForObject:self withOptions:@{
            iStateInitialState: @"initializing",
            @"states":@{
                @"initializing":@{
                        iStateOnEnter : [aBlock copy],
                        iStateOnExit : [bBlock copy],
                    iStateAllowedTransitions: @[@"loaded"],
                    iStateAllowedMethods  : @[]
                },
                @"loaded":@{
                    iStateOnEnter : ^{NSLog(@"on enter loaded");},
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
-(void)testit
{
    NSLog(@"test ref");
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
