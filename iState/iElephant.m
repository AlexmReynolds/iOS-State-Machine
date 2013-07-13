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
    
    for (NSDictionary *state in [states allKeys]){
        NSLog(@"state %@", state);
        if([[states objectForKey:state] objectForKey:@"allowedMethods"]){
            NSArray *allowedMethods = [[[states objectForKey:state] objectForKey:@"allowedMethods"] copy];
            NSLog(@"Object has key");
            for (NSString *methodName in allowedMethods){
                SEL sel = NSSelectorFromString(methodName);
                [self addInterceptorMethod:sel ToObject:self];
            }
        }
    }

}
void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@"HERE %@", NSStringFromSelector(_cmd));
    NSString *oldName = [NSString stringWithFormat:@"%@%@",@"abc",NSStringFromSelector(_cmd)];
    SEL callOld = NSSelectorFromString(oldName);
    [self performSelector:callOld];
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
- (void)addInterceptorMethod:(SEL)selector ToObject:(id)object  {
    Class objectClass = object_getClass(object);
    SEL selectorToOverride = selector; // this is the method name you want to override
    NSString *oldName = [NSString stringWithFormat:@"%@%@",@"abc",NSStringFromSelector(selectorToOverride)];
    
    
    IMP theImplementation = [self methodForSelector:selectorToOverride];
    Method method = class_getInstanceMethod([self class],selectorToOverride);
    SEL copySel =sel_registerName([oldName UTF8String]);
    NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class c = NSClassFromString(newClassName);
    if (c == nil) {
        // this class doesn't exist; create it
        // allocate a new class
        c = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        // get the info on the method we're going to override
        Method m = class_getInstanceMethod(objectClass, selectorToOverride);
        // Store old method

        class_addMethod(c, copySel, method_getImplementation(method), "v@:@");
        
        // add the method to the new class
        class_addMethod(c, selectorToOverride, (IMP)dynamicMethodIMP, method_getTypeEncoding(m));
        

        // register the new class with the runtime
        objc_registerClassPair(c);
    }
    // change the class of the object
    object_setClass(object, c);
}

@end
