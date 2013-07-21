//
//  iElephantTestViewController.h
//  iState
//
//  Created by Alex Reynolds on 7/20/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "iElephant.h"

@interface iElephantTestViewController : iElephant{
    
}

@property(nonatomic) BOOL _redCalled;
@property(nonatomic) BOOL _blueCalled;
@property(nonatomic) BOOL _greenCalled;
@property(nonatomic) BOOL _delegateTrainsitionCalled;
@property(nonatomic) BOOL _delegateTrainsitionFailedCalled;
@property(nonatomic) BOOL _delegateHandledCalled;
@property(nonatomic) BOOL _delegateNoHandlerCalled;
@property(nonatomic) BOOL _methodWasCalled;


-(void)goRed;
-(void)goBlue;
-(void)goGreen;
@end
