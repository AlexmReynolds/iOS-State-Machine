//
//  iState.h
//  iState
//
//  Created by Alex Reynolds on 7/13/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface iState : NSObject{
    NSDictionary *_states;
    NSString *_currentState;
    id _owner;
}
extern NSString* const iStateAllowedMethods;
extern NSString* const iStateAllowedTransitions;

-(id)initStateMachineForObject:(id)object withOptions:(NSDictionary *)options;
-(BOOL)handle:(SEL)method withArguments:(NSArray *)args;
-(BOOL)transition:(NSString *)desiredState;
@end
