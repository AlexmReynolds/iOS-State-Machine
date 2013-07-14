//
//  iState.h
//  iState
//
//  Created by Alex Reynolds on 7/13/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <Foundation/Foundation.h>

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
extern NSString* const iStateInitialState;
extern NSString* const iStateAllowedMethods;
extern NSString* const iStateAllowedTransitions;
extern NSString* const iStateEventHandled;
extern NSString* const iStateEventNoHandler;
extern NSString* const iStateEventTransitionComplete;
extern NSString* const iStateEventTransitionFailed;

-(id)initStateMachineForObject:(id)object withOptions:(NSDictionary *)options eventNotificationType:(iStateEventNoticiationType)eventNotificationType;
-(BOOL)handle:(SEL)method withArguments:(NSArray *)args;
-(BOOL)transition:(NSString *)desiredState;
@end
