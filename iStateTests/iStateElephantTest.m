//
//  iStateElephantTest.m
//  iState
//
//  Created by Alex Reynolds on 7/20/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "iStateElephantTest.h"

@implementation iStateElephantTest
@synthesize testViewController;
- (void)setUp
{
    _blockOnExitCalled = NO;
    _blockOnEnterCalled = NO;
    
    testViewController = [[iElephantTestViewController alloc] init];
    
    [testViewController initStateMachinewithOptions:@{
                                                     iStateInitialState: @"initializing",
                                                     @"states":@{
                                                             @"initializing":@{
                                                                     iStateOnEnter : ^{ [self onEnterBlock];},
                                                                     iStateOnExit : ^{ [self onExitBlock];},
                                                                     iStateAllowedTransitions: @[@"loaded"],
                                                                     iStateAllowedMethods  : @[]
                                                                     },
                                                             @"loaded":@{
                                                                     iStateOnEnter : ^{ [self onEnterBlock];},
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
                                                     
     }];
    
    
    
    
    
}
-(void)tearDown
{
    _blockOnExitCalled = NO;
    _blockOnEnterCalled = NO;
}


-(void)onEnterBlock{
    _blockOnEnterCalled = YES;
    
}
-(void)onExitBlock{
    _blockOnExitCalled = YES;
}


- (void)testInitialState
{
    NSString *initState = testViewController.currentState;
    STAssertTrue([initState isEqualToString:@"initializing"], @"Initial state is %@ ", initState);
}

-(void)testTransitionStateChange
{
    NSLog(@"current State %@",testViewController.currentState);
    NSString *desiredState = @"loaded";
    [testViewController transition:desiredState];
    STAssertEquals(testViewController.currentState, desiredState, @"New state %@ should be %@",testViewController.currentState,desiredState);
}

-(void)testMethodCallsAreInterceptedAndDesiredMethodIsCalled
{
    NSString *desiredState = @"loaded";
    [testViewController transition:desiredState];
    desiredState = @"blue";
    [testViewController transition:desiredState];
    NSLog(@"currents State %@",testViewController.currentState);
    [testViewController goBlue];
    NSLog(@"blue is %@", testViewController._blueCalled? @"true" : @"false");
    STAssertTrue(testViewController._blueCalled, @"Method caled for method goBlue");
}
-(void)testMethodCallsAreInterceptedAndBlocked
{
    NSString *desiredState = @"loaded";
    [testViewController transition:desiredState];
    desiredState = @"blue";
    [testViewController transition:desiredState];
    NSLog(@"currents State %@",testViewController.currentState);
    [testViewController goRed];
    STAssertFalse(testViewController._redCalled, @"Method caled for method goBlue");
}

-(void)testDelegateTransitionEventSuccess
{
    NSLog(@"current State %@",testViewController.currentState);
    NSString *desiredState = @"loaded";
    [testViewController transition:desiredState];
    STAssertEquals(testViewController.currentState, desiredState, @"Initial state should be %@",desiredState);
    STAssertTrue(testViewController._delegateTrainsitionCalled, @"Tranition success delegate event called");
}
-(void)testDelegateTransitionEventFailed
{
    NSString *desiredState = @"blue";
    [testViewController transition:desiredState];
    STAssertEquals(testViewController.currentState, testViewController.currentState, @"Initial state should be %@",testViewController.currentState);
    STAssertTrue(testViewController._delegateTrainsitionFailedCalled, @"Tranition faled delegate event called");
}
-(void)testDelegateMethodHandleFailed
{
    NSString *desiredState = @"loaded";
    [testViewController transition:desiredState];
    [testViewController goBlue];
    STAssertTrue(testViewController._delegateNoHandlerCalled, @"No handler for method goBlue");
}
-(void)testDelegateMethodHandleSuccess
{
    NSString *desiredState = @"loaded";
    [testViewController transition:desiredState];
    desiredState = @"blue";
    [testViewController transition:desiredState];
    NSLog(@"currents State %@",testViewController.currentState);
    [testViewController goBlue];
    STAssertTrue(testViewController._delegateHandledCalled, @"Method handled for method goBlue");
}

-(void)testOnEnterBlockCalled
{
    NSString *desiredState = @"loaded";
    [testViewController transition:desiredState];
    STAssertTrue(_blockOnEnterCalled, @"On Enter Block was called");
}
-(void)testOnExitBlockCalled
{
    NSString *desiredState = @"loaded";
    [testViewController transition:desiredState];
    STAssertTrue(_blockOnExitCalled, @"On exit Block was called");
}





@end
