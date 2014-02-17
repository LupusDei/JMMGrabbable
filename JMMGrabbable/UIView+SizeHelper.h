//
//  UIView+SizeHelper.h
//
//  Created by Justin Martin on 8/30/13.
//  Copyright (c) 2013 JMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SizeHelper)

-(void) withWidth:(float)width;
-(void) withHeight:(float)height;
-(void) withX:(float)x;
-(void) withY:(float)y;

-(float)width;
-(float)height;
-(float)x;
-(float)y;

@end
