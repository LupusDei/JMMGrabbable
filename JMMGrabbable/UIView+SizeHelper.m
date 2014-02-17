//
//  UIView+SizeHelper.m
//
//  Created by Justin Martin on 8/30/13.
//  Copyright (c) 2013 JMM. All rights reserved.
//

#import "UIView+SizeHelper.h"

@implementation UIView (SizeHelper)

-(void) withWidth:(float)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(void) withHeight:(float)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
-(void) withX:(float)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
-(void) withY:(float)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(float)width {
    return self.frame.size.width;
}
-(float)height {
    return self.frame.size.height;
}
-(float)x {
    return self.frame.origin.x;
}
-(float)y {
    return self.frame.origin.y;
}

@end
