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


-(void)setupStateMachine:(NSDictionary *)options{
    NSDictionary *states = [options objectForKey:@"states"];
    NSLog(@"STATEs %@", states);
    NSMutableDictionary *methodsToIntercept = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *state in [states allKeys]){
        NSLog(@"state %@", state);
        if([[states objectForKey:state] objectForKey:@"allowedMethods"]){
            NSArray *allowedMethods = [[[states objectForKey:state] objectForKey:@"allowedMethods"] copy];
            NSLog(@"Object has key");
            for (NSString *methodName in allowedMethods){
                [methodsToIntercept setObject:methodName forKey:methodName];
            }

        }
    }
    [self addInterceptorsForMethods:methodsToIntercept ToObject:self];

}
void dynamicMethodIMP(id self, SEL _cmd, ...) {
    NSLog(@"HERE %@", NSStringFromSelector(_cmd));
    NSString *oldName = [NSString stringWithFormat:@"%@%@",@"abc",NSStringFromSelector(_cmd)];
    SEL callOld = NSSelectorFromString(oldName);
    
    va_list ap;
    va_start(ap, _cmd);
    NSMethodSignature *signature = [self methodSignatureForSelector:callOld];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:callOld]];
    int argc = [signature numberOfArguments];
    char *ptr = (char *)ap;
    for (int i = 2; i < argc; i++) {
        const char *type = [signature getArgumentTypeAtIndex:i];
        [invocation setArgument:ptr atIndex:i];
        NSUInteger size;
        NSGetSizeAndAlignment(type, &size, NULL);
        ptr += size;
    }
    va_end(ap);
    
    
    
    

    [invocation setTarget:self];
    [invocation setSelector:callOld];
    [invocation invoke];
}
-(NSString *)getState
{
    
}

-(BOOL)transitionToState:(NSString *)desiredState
{
    
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"called");
}
- (void)addInterceptorsForMethods:(NSDictionary *)methodNames ToObject:(id)object  {
    NSLog(@"methods to intercept %@", methodNames);
    NSDictionary *methodStrings = [methodNames copy];
    Class objectClass = object_getClass(object);
    NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class c = NSClassFromString(newClassName);
    if (c == nil) {
        c = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        for (NSString *methodName in [methodStrings allKeys]){
            SEL selectorToOverride = NSSelectorFromString(methodName);
            NSString *oldName = [NSString stringWithFormat:@"%@%@",@"abc",NSStringFromSelector(selectorToOverride)];
            NSLog(@"new name %@", oldName);
            if ([self respondsToSelector:selectorToOverride]){
                NSLog(@"method exists");
            }
            // if the class responds to the stored selector name then we already copied it so return
            if ([c respondsToSelector:NSSelectorFromString(oldName)]){
                NSLog(@"continue");
                continue;
            }
            
            
            SEL copySel = sel_registerName([oldName UTF8String]);
            NSLog(@"new class name %@", newClassName);
            // this class doesn't exist; create it
            // allocate a new class

            // get the info on the method we're going to override
            Method m = class_getInstanceMethod(objectClass, selectorToOverride);
            // Store old method
            NSLog(@"%s",method_getTypeEncoding(m));
            class_addMethod(c, copySel, method_getImplementation(m), method_getTypeEncoding(m));
            
            // add the method to the new class
            class_addMethod(c, selectorToOverride, (IMP)dynamicMethodIMP, method_getTypeEncoding(m));
        }

        

        // register the new class with the runtime
        objc_registerClassPair(c);
    }
    // change the class of the object
    object_setClass(object, c);
}

@end
