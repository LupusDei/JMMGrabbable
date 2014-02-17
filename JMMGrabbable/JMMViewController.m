//
//  JMMViewController.m
//  JMMGrabbable
//
//  Created by Justin Martin on 2/17/14.
//  Copyright (c) 2014 JMM. All rights reserved.
//

#import "JMMViewController.h"
#import "JMMGrabbableViewController.h"

@interface JMMViewController () <GrabbableResponder>

@end

@implementation JMMViewController {
	JMMGrabbableViewController *_grabbable;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _grabbable = [[JMMGrabbableViewController alloc] initWithReferenceView:self.view andResponder:self];
	self.view.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
