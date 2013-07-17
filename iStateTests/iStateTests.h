//
//  iStateTests.h
//  iStateTests
//
//  Created by Alex Reynolds on 7/12/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "iState.h"
@interface iStateTests : SenTestCase{
    NSDictionary *_states;
    BOOL _blockOnEnterCalled;
    BOOL _blockOnExitCalled;
    BOOL _delegateTrainsitionCalled;
    BOOL _delegateTrainsitionFailedCalled;
    BOOL _delegateHandledCalled;
    BOOL _delegateNoHandlerCalled;
    BOOL _methodWasCalled;
    
}
@property (nonatomic, strong) iState *stateMachine;

@end
