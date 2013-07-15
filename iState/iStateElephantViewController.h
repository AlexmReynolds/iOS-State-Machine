//
//  iStateElephantViewController.h
//  iState
//
//  Created by Alex Reynolds on 7/14/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iElephant.h"
@interface iStateElephantViewController : iElephant

@property (weak, nonatomic) IBOutlet UILabel *currentStateLabel;
- (IBAction)redButtonClicked:(id)sender;
- (IBAction)blueButtonClicked:(id)sender;
- (IBAction)greenButtonClicked:(id)sender;
@end
