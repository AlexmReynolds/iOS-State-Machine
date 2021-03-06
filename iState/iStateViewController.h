//
//  iStateViewController.h
//  iState
//
//  Created by Alex Reynolds on 7/12/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iState.h"
@interface iStateViewController : UIViewController<iStateMachineDelegate>{
    iState *stateMachine;
}

@property (weak, nonatomic) IBOutlet UILabel *currentStateLabel;
- (IBAction)redButtonClicked:(id)sender;
- (IBAction)blueButtonClicked:(id)sender;
- (IBAction)greenButtonClicked:(id)sender;
@end
