//
//  iStateViewController.h
//  iState
//
//  Created by Alex Reynolds on 7/12/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iElephant.h"
#import "iState.h"
@interface iStateViewController : iElephant<iStateMachineDelegate>{
    iState *stateMachine;
}

@end
