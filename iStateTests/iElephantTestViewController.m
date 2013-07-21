//
//  iElephantTestViewController.m
//  iState
//
//  Created by Alex Reynolds on 7/20/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "iElephantTestViewController.h"

@interface iElephantTestViewController ()

@end

@implementation iElephantTestViewController

@synthesize _blueCalled,_greenCalled,_redCalled,_delegateHandledCalled,_delegateNoHandlerCalled,_delegateTrainsitionFailedCalled,_delegateTrainsitionCalled,_methodWasCalled;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self){
        _greenCalled = NO;
        _redCalled = NO;
        _blueCalled = NO;
        _delegateTrainsitionCalled= NO;
        _delegateTrainsitionFailedCalled = NO;
        _delegateHandledCalled = NO;
        _delegateNoHandlerCalled = NO;
        _methodWasCalled = NO;
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
-(void)goRed{
    _redCalled = YES;
    self.view.backgroundColor = [UIColor redColor];
}
-(void)goBlue{
    NSLog(@"Gone blue from test controller");
    _blueCalled = YES;
    self.view.backgroundColor = [UIColor blueColor];
}
-(void)goGreen{
    _greenCalled = YES;
    self.view.backgroundColor = [UIColor greenColor];
}

#pragma mark - delegate events

-(void)iStateMethodHandled:(NSDictionary *)data
{
    _delegateHandledCalled = YES;
}

-(void)iStateMethodNoHandler:(NSDictionary *)data
{
    _delegateNoHandlerCalled = YES;
    NSLog(@"delegate no handler data: %@", data);
    
}
-(void)iStateTransitionCompleted:(NSDictionary *)data
{
    _delegateTrainsitionCalled= YES;
    NSLog(@"delegate transition complete data: %@", data);
}
-(void)iStateTransitionFailed:(NSDictionary *)data
{
    _delegateTrainsitionFailedCalled = YES;
    NSLog(@"delegate transition failed data: %@", data);
}
@end
