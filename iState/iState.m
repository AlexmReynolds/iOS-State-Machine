//
//  iState.m
//  iState
//
//  Created by Alex Reynolds on 7/13/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "iState.h"

@implementation iState

NSString* const iStateAllowedMethods = @"allowedMethods";
NSString* const iStateAllowedTransitions = @"allowedTransitions";
-(id)initStateMachineForObject:(id)object withOptions:(NSDictionary *)options{
    self = [super init];
    if (self){
        NSDictionary *states = [options objectForKey:@"states"];
        NSLog(@"STATEs %@", states);
        _states = states;
        if ([options objectForKey:@"initialState"]){
            _currentState = [options objectForKey:@"initialState"];
        }
        if(object){
            _owner = object;
        }
    }
    return self;
}
-(BOOL)handle:(SEL)method withArguments:(NSArray *)args
{

    BOOL canHandle = NO;
    NSArray *allowedMethods;
    NSString *desiredMethodString = NSStringFromSelector(method);
    if([self stateHasDefinedAllowedMethods:_currentState]){
        
        allowedMethods = [[[_states objectForKey:_currentState] objectForKey:iStateAllowedMethods] copy];
        for(NSString *methodName in allowedMethods){
            if([methodName isEqualToString:desiredMethodString]){
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_owner methodSignatureForSelector:method]];
                [invocation setTarget:_owner];
                [invocation setSelector:method];
                size_t ind = 2;
                for (id arg in args){
                    id argd = [args objectAtIndex:ind - 2 ];
                    [invocation setArgument:&argd atIndex:ind];
                    ind++;
                }

                [invocation invoke];
                [self sendEvent:@"handled" withData:@{@"method":desiredMethodString}];
                canHandle = YES;
                
            }
        }
        
        
        return canHandle;
    }

    
    return canHandle;
}
-(BOOL)transition:(NSString *)desiredState
{
    BOOL canTransition = NO;
    return canTransition;
}

-(NSString *)getState
{
    return _currentState;
}

-(BOOL) stateHasDefinedAllowedMethods:(NSString *)state
{
    if (_states && [[_states objectForKey:state] objectForKey:iStateAllowedMethods]){
        return YES;
    } else{
        return NO;
    }
}
-(void)sendEvent:(NSString *)event withData:(NSDictionary *)data
{
    [[NSNotificationCenter defaultCenter] postNotificationName:event object:nil userInfo:data];
}
@end
