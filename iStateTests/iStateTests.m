//
//  iStateTests.m
//  iStateTests
//
//  Created by Alex Reynolds on 7/12/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "iStateTests.h"

@implementation iStateTests

- (void)setUp
{
    _blockcalled = NO;
    _delegateTrainsitionCalled= NO;
    _delegateTrainsitionFailedCalled = NO;
    _delegateHandledCalled = NO;
    _delegateNoHandlerCalled = NO;
    _methodWasCalled = NO;
    [super setUp];
    self.stateMachine = [[iState alloc ]initStateMachineForObject:self withOptions:@{
                                                iStateInitialState: @"initializing",
                          @"states":@{
                          @"initializing":@{
                                                    iStateOnEnter : ^{ [self blockTest];},
                                                     iStateOnExit : ^{ [self blockTest];},
                                          iStateAllowedTransitions: @[@"loaded"],
                                            iStateAllowedMethods  : @[]
                          },
                          @"loaded":@{
                                                   iStateOnEnter : ^{ [self blockTest];},
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
    // Set-up code here.
}

- (void)tearDown
{
    _blockcalled = NO;
    _delegateTrainsitionCalled= NO;
    _delegateTrainsitionFailedCalled = NO;
    _delegateHandledCalled = NO;
    _delegateNoHandlerCalled = NO;
    _methodWasCalled = NO;
    // Tear-down code here.
    
    [super tearDown];
}
-(void)blockTest{
    _blockcalled = YES;
    
}

- (void)testInitialState
{
    NSString *testState = @"initializing";
    STAssertEquals(self.stateMachine.currentState, testState, @"Initial state should be %@",testState);
}
-(void)testTransitionStateChange
{
    NSLog(@"current State %@",self.stateMachine.currentState);
    NSString *desiredState = @"loaded";
    [self.stateMachine transition:desiredState];
    STAssertEquals(self.stateMachine.currentState, desiredState, @"Initial state should be %@",desiredState);
}

-(void)testHandleCallsMethod
{
    NSString *desiredState = @"loaded";
    [self.stateMachine transition:desiredState];
    desiredState = @"blue";
    [self.stateMachine transition:desiredState];
    NSLog(@"currents State %@",self.stateMachine.currentState);
    [self.stateMachine handle:NSSelectorFromString(@"goBlue") withArguments:nil];
    STAssertTrue(_methodWasCalled, @"Method caled for method goBlue");
}

-(void)testDelegateTransitionEventSuccess
{
        NSLog(@"current State %@",self.stateMachine.currentState);
    NSString *desiredState = @"loaded";
    [self.stateMachine transition:desiredState];
    STAssertEquals(self.stateMachine.currentState, desiredState, @"Initial state should be %@",desiredState);
    STAssertTrue(_delegateTrainsitionCalled, @"Tranition success delegate event called");
}
-(void)testDelegateTransitionEventFailed
{
    NSString *desiredState = @"blue";
    [self.stateMachine transition:desiredState];
    STAssertEquals(self.stateMachine.currentState, self.stateMachine.currentState, @"Initial state should be %@",self.stateMachine.currentState);
    STAssertTrue(_delegateTrainsitionFailedCalled, @"Tranition faled delegate event called");
}
-(void)testDelegateMethodHandleFailed
{
    NSString *desiredState = @"loaded";
    [self.stateMachine transition:desiredState];
    [self.stateMachine handle:NSSelectorFromString(@"goBlue") withArguments:nil];
    STAssertTrue(_delegateNoHandlerCalled, @"No handler for method goBlue");
}
-(void)testDelegateMethodHandleSuccess
{
    NSString *desiredState = @"loaded";
    [self.stateMachine transition:desiredState];
    desiredState = @"blue";
    [self.stateMachine transition:desiredState];
            NSLog(@"currents State %@",self.stateMachine.currentState);
    [self.stateMachine handle:NSSelectorFromString(@"goBlue") withArguments:nil];
    STAssertTrue(_delegateHandledCalled, @"Method handled for method goBlue");
}

-(void)testOnEnterBlockCalled
{
    NSString *desiredState = @"loaded";
    [self.stateMachine transition:desiredState];
    STAssertTrue(_blockcalled, @"On Enter Block was called");
}



//// TEST METHODS

-(void)goBlue
{
    _methodWasCalled = YES;
}


//DELEGATE METHODS

#pragma mark - delegate events

-(void)iStateMethodHandled:(NSDictionary *)data
{
    _delegateHandledCalled = YES;
}

-(void)iStateMethodNoHandler:(NSDictionary *)data
{
    _delegateNoHandlerCalled = YES;
    NSLog(@"delegate no handler data: %@", data);
    
}
-(void)iStateTransitionCompleted:(NSDictionary *)data
{
    _delegateTrainsitionCalled= YES;
    NSLog(@"delegate transition complete data: %@", data);
}
-(void)iStateTransitionFailed:(NSDictionary *)data
{
    _delegateTrainsitionFailedCalled = YES;
    NSLog(@"delegate transition failed data: %@", data);
}
@end
