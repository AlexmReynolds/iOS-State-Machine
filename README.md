iState
======
iState is a state machine for iOS. There are two version of iState, iState and iElephant.

iState is a NSObject state machine that a class can init to track the class' state machine.

iElephant is a superclass that tracks the state of a subclass.

##iState Examples

```objectivec
    // Create a reference to self if we are going to call self from the blocks
    // Arc uses __weak to break retain cycles
    #if __has_feature(objc_arc)
        __block typeof(self) stateSelf = self;
    #else
        __weak typeof(self) stateSelf = self;
    #endif
    
    // Declare a block used for an onEnter or onExit method
    void (^aBlock)(void)= ^{[stateSelf testit];};
    void (^bBlock)(void)= ^{
        NSLog(@"onExit");
    };
    
    // Options is an NSDictionary
    // States is an array of state objects
    // State is an object that defines allowedTransitions, allowedMethods, and blocks to call onEnter and onExit of the state
    // OnEnter and OnExit take a block. You can declare the block inline or pass in a block reference.
    
        stateMachine = [[iState alloc ]initStateMachineForObject:self withOptions:@{
            iStateInitialState: @"initializing",
            @"states":@{
                @"initializing":@{
                        iStateOnEnter : [aBlock copy],
                        iStateOnExit : [bBlock copy],
                    iStateAllowedTransitions: @[@"loaded"],
                    iStateAllowedMethods  : @[]
                },
                @"loaded":@{
                    iStateOnEnter : ^{NSLog(@"on enter loaded");},
                    iStateAllowedTransitions: @[@"red",@"blue"],
                    iStateAllowedMethods  : @[]
                },
                @"blue":@{
                                iStateAllowedTransitions: @[@"red",@"green"],
                                  iStateAllowedMethods  : @[@"goBlue"]
                },
                @"red":@{
                                iStateAllowedTransitions: @[@"blue"],
                                  iStateAllowedMethods  : @[@"goRed"]
                },
                @"green":@{
                                iStateAllowedTransitions: @[@"blue"],
                                  iStateAllowedMethods  : @[@"goGreen"]
                }
            },
    
            } eventNotificationType:iStateEventNotificationsUseDelegate] ;
```

##iElephant Examples
iState
