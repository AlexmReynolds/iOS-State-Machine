//
//  iStateViewController.m
//  iState
//
//  Created by Alex Reynolds on 7/12/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "iStateViewController.h"

@interface iStateViewController ()

@end

@implementation iStateViewController

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
    [self setupStateObject];
	// Do any additional setup after loading the view.
}

-(void) setupSuperState
{
    [self setupStateMachine:@{
         @"initialState": @"initializing",
         @"states":@{
             @"initializing":@{
               iStateAllowedTransitions: @[@"loaded"],
                 iStateAllowedMethods  : @[@"foo:", @"bar", @"foo:bar:"]
             },
             @"loaded":@{
               iStateAllowedTransitions: @[],
                 iStateAllowedMethods  : @[@"foo:"]
             }
         },
     
     }] ;
    
    
    [super viewDidLoad];
    
    [self foo:@"tim"];
    [self foo:@"test" bar:@[@1,@2]];
    [self bar];
}

-(void) setupStateObject
{
        stateMachine = [[iState alloc ]initStateMachineForObject:self withOptions:@{
            @"initialState": @"initializing",
            @"states":@{
                @"initializing":@{
                    iStateAllowedTransitions: @[@"loaded"],
                    iStateAllowedMethods  : @[@"foo:", @"bar", @"foo:bar:"]
                },
                @"loaded":@{
                    iStateAllowedTransitions: @[],
                    iStateAllowedMethods  : @[@"foo:"]
                }
            },
    
         }] ;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(methodHanded:) name:@"handled" object:nil];
    
    
    if([stateMachine handle:@selector(foo:) withArguments:@[@"tom"]]){
        NSLog(@"handle");
    }
    if([stateMachine handle:@selector(foo:bar:) withArguments:@[@"tom",@[@1,@2,@3]]]){
        NSLog(@"handle");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)foo:(NSString *)name
{
    NSLog(@"child foo %@",name);
}
-(void)bar{
    NSLog(@"child bar");
}
-(void)foo:(NSString *)name bar:(NSArray *)last
{
    NSLog(@"%@ %@", name, last);
}


#pragma mark - events

-(void)methodHanded:(NSNotification*)notification
{
    NSDictionary *data = [notification userInfo];
    NSLog(@"handled data: %@", data);
}
@end
