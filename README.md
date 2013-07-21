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

## Initializing the machine
Initializing the state machine is easy. To init the machine pass in a reference to the object that it is to track. Pass in a NSDictionary of options.
##Options
iStateInitialState is the state you want the machine to start up in.
states is a NSArray of state objects.
State is a NSDictionary that contains what states it can trasition to, what methods are allowed, and blocks to execute on entering or exiting the state

##Event notifications
Notifications for state change, method calls, or failures can be sent via delegate methods or broadcast via notification center.

##Using the Machine

Using is very easy. Store the machine in an instance variable then call
```[self.stateMachine transition:@"loaded"];```
This will try to transition. If the state is allowed and exists it will change states, fire the onExit and onEnter blocks, and fire the notifcations.
```[self.stateMachine handle:@"goRed" withArguments:nil];```
Will try to call a method. IF the method is allowed it will call it with the argument array passed in and fire the notifications.

Check out the xCode project. Launch the app to test the iState machine in a basic UI.



##iElephant Examples
iElephant is somewhat different. It uses the same basic setup and same basic methods. The biggest difference is that instead of calling ```[stateMachine handle....]``` you call the method as you normall would ```[self foobar]```

iElephant under the hood intercepts the method calls listed in the setup and when those are called it checks to see if they are allow, calls the methods and fires the notifications via methods in the subclass.

Initing the iElephant is simple. Just call ```[self initStateMachinewithOptions:]```
Using is very easy.
```[self transition:@"loaded"];```
This will try to transition. If the state is allowed and exists it will change states, fire the onExit and onEnter blocks, and fire the notifcations.
```[self goRed];```

iState
