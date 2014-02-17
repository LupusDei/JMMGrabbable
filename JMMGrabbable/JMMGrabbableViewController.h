//
//  JMMGrabbableViewController.h
//  JMMGrabbable
//
//  Created by Justin Martin on 2/17/14.
//  Copyright (c) 2014 JMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrabbableResponder <NSObject>

@optional
-(void) grabbableActive;
-(void) grabbableDeactive;
-(void) grabbableBeingGrabbed;

@end

@interface JMMGrabbableViewController : UIViewController

@property (nonatomic, strong) id<GrabbableResponder> grabbableResponder;


-(instancetype) initWithReferenceView:(UIView *)view andResponder:(id<GrabbableResponder>)responder;

@end
