//
//  iStateElephantTest.h
//  iState
//
//  Created by Alex Reynolds on 7/20/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "iElephantTestViewController.h"
@interface iStateElephantTest : SenTestCase{
    NSDictionary *_states;
    BOOL _blockOnEnterCalled;
    BOOL _blockOnExitCalled;

    
}

@property(nonatomic,strong) iElephantTestViewController *testViewController;


@end
