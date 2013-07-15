//
//  iElephant.h
//  iState
// iElephant is a state machine that acts as a super class. This allows it to intercept method calls and fire events without a delegate or notification.
//
//  Created by Alex Reynolds on 7/12/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>


typedef enum iStateEvent : NSUInteger {
    kStateEventHandled,
    kStateEventNoHandler,
    kStateEventTransitioned,
    kStateEventTransitionFailed
} iStateEvent;

@interface iElephant : UIViewController{
    NSDictionary *_states;

}

@property (nonatomic,strong,readonly) NSString *currentState;
@property (nonatomic, strong,readonly) NSString *previousState;




-(BOOL)initStateMachinewithOptions:(NSDictionary *)options;
-(BOOL)handle:(SEL)method withArguments:(NSArray *)args;
-(BOOL)transition:(NSString *)desiredState;



@end
