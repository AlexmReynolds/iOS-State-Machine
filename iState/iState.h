//
//  iState.h
//  iState
// iState is a state object that tracks state of another object
// iState can send events via delegate or notifications. This allows single or multiple objects to listen
// iState checks if methods can be handled and fires them if the state is correct.
//
//  Created by Alex Reynolds on 7/13/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@protocol iStateMachineDelegate <NSObject>

@optional
-(void)iStateMethodHandled:(NSDictionary *)data;
-(void)iStateMethodNoHandler:(NSDictionary *)data;
-(void)iStateTransitionCompleted:(NSDictionary *)data;
-(void)iStateTransitionFailed:(NSDictionary *)data;

@end


typedef enum iStateEvent : NSUInteger {
    kStateEventHandled,
    kStateEventNoHandler,
    kStateEventTransitioned,
    kStateEventTransitionFailed
} iStateEvent;

typedef enum iStateEventNoticiationType : NSUInteger {
    iStateEventNotificationsUseDelegate,
    iStateEventNotificationsUseNotificationCenter
} iStateEventNoticiationType;


@interface iState : NSObject{
    NSDictionary *_states;
    id _delegate;
    iStateEventNoticiationType _sendEventsUsingNotificationType;
}

@property (nonatomic,strong,readonly) NSString *currentState;
@property (nonatomic, strong,readonly) NSString *previousState;

-(id)initStateMachineForObject:(id)object withOptions:(NSDictionary *)options eventNotificationType:(iStateEventNoticiationType)eventNotificationType;
-(void)setSendEventsUsingNotificationType:(iStateEventNoticiationType)type;
-(BOOL)handle:(SEL)method withArguments:(NSArray *)args;
-(void)trigger:(NSString *)customEventName withData:(NSDictionary *)data;
-(BOOL)transition:(NSString *)desiredState;
-(NSString *)getState;
@end
