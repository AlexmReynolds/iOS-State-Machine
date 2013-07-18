//
//  iElephant.m
//  iState
//
//  Created by Alex Reynolds on 7/12/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "iElephant.h"

@interface iElephant ()

@end

@implementation iElephant
@synthesize currentState = _currentState;
@synthesize previousState = _previousState;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)initStateMachinewithOptions:(NSDictionary *)options{
    _states = [options objectForKey:@"states"];
    if(!_states){
        return false;
    }
    if([options objectForKey:iStateInitialState]){
        ElephantLog(@"HEREEEEE %@",[options objectForKey:iStateInitialState]);
        _currentState = [options objectForKey:iStateInitialState];
        ElephantLog(@"current state %@", _currentState);
    }
    ElephantLog(@"STATEs %@", _states);
    NSMutableDictionary *methodsToIntercept = [[NSMutableDictionary alloc] init];
    if(_states)
    for (NSDictionary *state in [_states allKeys]){
        ElephantLog(@"state %@", state);
        if([[_states objectForKey:state] objectForKey:iStateAllowedMethods]){
            NSArray *allowedMethods = [[[_states objectForKey:state] objectForKey:iStateAllowedMethods] copy];
            ElephantLog(@"Object has key");
            for (NSString *methodName in allowedMethods){
                [methodsToIntercept setObject:methodName forKey:methodName];
            }

        }
    }
    [self addInterceptorsForMethods:methodsToIntercept ToObject:self];
    return true;

}
void dynamicMethodIMP(id self, SEL _cmd, ...) {
    
    ElephantLog(@"HERE %@", NSStringFromSelector(_cmd));
    NSString *methodName = NSStringFromSelector(_cmd);
    NSString *oldName = [NSString stringWithFormat:@"%@%@",@"abc",methodName];
    SEL callOld = NSSelectorFromString(oldName);
    
    Method m = class_getInstanceMethod([self class], callOld);
    char returnType[128];
    method_getReturnType(m, returnType, sizeof(returnType));
    ElephantLog( @"Return type: %s", returnType );
    

    if ([self methodCallAllowed:methodName]){
        ElephantLog(@"HERE1");
        va_list ap;
        va_start(ap, _cmd);
        NSMethodSignature *signature = [self methodSignatureForSelector:callOld];
                ElephantLog(@"HERE2");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:callOld]];
        int argc = [signature numberOfArguments];
        char *ptr = (char *)ap;
                ElephantLog(@"HERE3");
        for (int i = 2; i < argc; i++) {
                    ElephantLog(@"HERE4");
            const char *type = [signature getArgumentTypeAtIndex:i];
            [invocation setArgument:ptr atIndex:i];
            NSUInteger size;
            NSGetSizeAndAlignment(type, &size, NULL);
            ptr += size;
        }
        va_end(ap);
        
        
        
        
        ElephantLog(@"here5");
        [invocation setTarget:self];
        [invocation setSelector:callOld];
        [invocation invoke];
        // If we have a non-void method then we get the return value and pass along
        if (strncmp(returnType, "v", 1) != 0){
            ElephantLog(@"here");
            id returnValue;
            [invocation getReturnValue:&returnValue];
            ElephantLog(@"return val %@", returnValue);
        }
    }

}
-(NSString *)getState
{
    return _currentState;
}

-(void)callOnEnterBlock:(NSString *)state
{
    if (![_states objectForKey:state]){
        return;
    }
    if([[_states objectForKey:state] objectForKey:iStateOnEnter]){
        
        if([[[_states objectForKey:state] objectForKey:iStateOnEnter] isKindOfClass:NSClassFromString(@"NSBlock")]){
            ElephantLog(@"have a value for on enter");
            
            void (^afunc)(void) = [[_states objectForKey:state] objectForKey:iStateOnEnter];
            afunc();
        } else {
            ElephantLog(@"Not a block so onEnter Cant be called");
            
        }
    }
}
-(void)callOnExitBlock:(NSString *)state
{
    if (![_states objectForKey:state]){
        return;
    }
    if([[_states objectForKey:state] objectForKey:iStateOnExit]){
        if([[[_states objectForKey:state] objectForKey:iStateOnExit] isKindOfClass:NSClassFromString(@"NSBlock")]){
            ElephantLog(@"have a value for on exit");
            void (^afunc)(void) = [[_states objectForKey:state] objectForKey:iStateOnExit];
            afunc();
        } else {
            ElephantLog(@"Not a block so onExit Cant be called");
            
        }
    }
    
}

-(BOOL)methodCallAllowed:(NSString *)method
{
    BOOL canHandle = NO;
    NSArray *allowedMethods;
    if([self stateHasDefinedAllowedMethods:_currentState]){
        
        allowedMethods = [[[_states objectForKey:_currentState] objectForKey:iStateAllowedMethods] copy];
        for(NSString *methodName in allowedMethods){
            if([methodName isEqualToString:method]){
                [self sendEvent:kStateEventHandled withData:@{@"method":method}];
                canHandle = YES;
                break;
                
            }
        }
        
    }
    if(!canHandle){
        [self sendEvent:kStateEventNoHandler withData:@{@"method":method}];
    }
    
    return canHandle;
}
-(BOOL)transition:(NSString *)desiredState{
    ElephantLog(@"current states %@ %@", _currentState, _previousState);
    NSArray *allowedTransitions;
    BOOL canTransition = NO;
    if ([self stateHasDefinedAllowedTransitions:_currentState]){
        allowedTransitions = [[[_states objectForKey:_currentState] objectForKey:iStateAllowedTransitions] copy];
        for(NSString *allowedStates in allowedTransitions){
            if([allowedStates isEqualToString:desiredState]){
                canTransition = YES;
                [self callOnExitBlock:_currentState];
                _previousState = _currentState;
                _currentState = desiredState;
                [self callOnEnterBlock:_currentState];
                [self sendEvent:kStateEventTransitioned withData:@{@"currentState":_currentState, @"previousState":_previousState}];
                break;
            }
        }
    }
    if(!canTransition){
        [self sendEvent:kStateEventTransitionFailed withData:@{@"currentState":_currentState,@"desiredState":desiredState}];
    }
    return canTransition;
}

-(void)sendEvent:(iStateEvent)event withData:(NSDictionary *)data
{
    ElephantLog(@"event data: %@",data);
    switch (event){
        case kStateEventHandled:
            if ([self respondsToSelector:@selector(iStateMethodHandled:)]){
                [self performSelector:@selector(iStateMethodHandled:) withObject:data];
            }
            break;
        case kStateEventNoHandler:
            if ([self respondsToSelector:@selector(iStateMethodNoHandler:)]){
                [self performSelector:@selector(iStateMethodNoHandler:) withObject:data];
            }
            break;
        case kStateEventTransitioned:
            if ([self respondsToSelector:@selector(iStateTransitionCompleted:)]){
                [self performSelector:@selector(iStateTransitionCompleted:) withObject:data];
            }
            break;
        case kStateEventTransitionFailed:
            if ([self respondsToSelector:@selector(iStateTransitionFailed:)]){
                [self performSelector:@selector(iStateTransitionFailed:) withObject:data];
            }
            break;
    }
}


-(BOOL)handle:(SEL)method withArguments:(NSArray *)args{
    return YES;
}
- (id)forwardingTargetForSelector:(SEL)aSelector {
    ElephantLog(@"called");
}


-(BOOL) stateHasDefinedAllowedMethods:(NSString *)state
{
    if (_states && [[_states objectForKey:state] objectForKey:iStateAllowedMethods]){
        return YES;
    } else{
        return NO;
    }
}
-(BOOL) stateHasDefinedAllowedTransitions:(NSString *)state
{
    if (_states && [[_states objectForKey:state] objectForKey:iStateAllowedTransitions]){
        return YES;
    } else{
        return NO;
    }
}



// Add interceptors makes copies of state methods and replaces the existing selector with the state machine checker
// The original method is stored using methodname plus a prefix.
- (void)addInterceptorsForMethods:(NSDictionary *)methodNames ToObject:(id)object  {
    ElephantLog(@"methods to intercept %@", methodNames);
    NSDictionary *methodStrings = [methodNames copy];
    Class objectClass = object_getClass(object);
    NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class c = NSClassFromString(newClassName);
    if (c == nil) {
        c = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        for (NSString *methodName in [methodStrings allKeys]){
            SEL selectorToOverride = NSSelectorFromString(methodName);
            NSString *oldName = [NSString stringWithFormat:@"%@%@",@"abc",NSStringFromSelector(selectorToOverride)];
            ElephantLog(@"new name %@", oldName);
            if (![self respondsToSelector:selectorToOverride]){
                ElephantLog(@"Invalid method: %@ passed to state machine", methodName);
                ElephantLog(@"There is no valid method for that methdodName");
                continue;
            }
            // if the class responds to the stored selector name then we already copied it so return
            if ([c respondsToSelector:NSSelectorFromString(oldName)]){
                ElephantLog(@"continue");
                continue;
            }
            
            
            SEL copySel = sel_registerName([oldName UTF8String]);
            ElephantLog(@"new class name %@", newClassName);
            // this class doesn't exist; create it
            // allocate a new class

            // get the info on the method we're going to override
            Method m = class_getInstanceMethod(objectClass, selectorToOverride);
            // Store old method
            
            // Our interceptor method doesn't return anything
            // First get the types from the method, this includes args and return
            const char * consttype = method_getTypeEncoding(m);
            char type[80];
            
            // Convert the types to char so we can manipulate it
            strcpy(type, consttype);
            
            ElephantLog(@"%s",type);
            
            // Change it so our interceptor always is void typed
            type[0] = 'v';
            ElephantLog(@"%s",type);
            class_addMethod(c, copySel, method_getImplementation(m), method_getTypeEncoding(m));
            
            // add the method to the new class
            class_addMethod(c, selectorToOverride, (IMP)dynamicMethodIMP, type);
        }

        

        // register the new class with the runtime
        objc_registerClassPair(c);
    }
    // change the class of the object
    object_setClass(object, c);
}

// Elephant log is so you can quickly disable state logs in your app
void ElephantLog(NSString *format, ...){
#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
#endif
}

@end


