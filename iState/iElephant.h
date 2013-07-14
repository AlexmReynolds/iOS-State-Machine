//
//  iElephant.h
//  iState
//
//  Created by Alex Reynolds on 7/12/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface iElephant : UIViewController{

}

@property (nonatomic,strong,readonly) NSString *currentState;
@property (nonatomic, strong,readonly) NSString *previousState;


-(void)initStateMachinewithOptions:(NSDictionary *)options;
-(BOOL)handle:(SEL)method withArguments:(NSArray *)args;
-(BOOL)transition:(NSString *)desiredState;
@end
