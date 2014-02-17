//
//  JMMGrabbableViewController.m
//  JMMGrabbable
//
//  Created by Justin Martin on 2/17/14.
//  Copyright (c) 2014 JMM. All rights reserved.
//

#import "JMMGrabbableViewController.h"

static CGFloat const kJMMGrabbableHeaderHeight = 64.0f;
static CGFloat const kJMMDockTriggerHeight = 420.0f;
static CGFloat const kJMMDockReleaseHeight = 150.0f;
#define kBlueColor  [UIColor colorWithRed:43.0f/255 green:91.0f/255 blue:148.0f/255 alpha:1]

@interface JMMGrabbableViewController () <UICollisionBehaviorDelegate>
@property (nonatomic, weak) UIView *referenceView;
@end

@implementation JMMGrabbableViewController {
    UIView *_headerView;
    UIGravityBehavior *_gravity;
    UIDynamicAnimator *_animator;
    UISnapBehavior *_snap;
    CGPoint _previousTouchPoint;
    CGPoint _startPoint;
    BOOL _draggingView;
    BOOL _viewDocked;
}

-(instancetype) initWithReferenceView:(UIView *)view andResponder:(id<GrabbableResponder>)responder {
    self = [super init];
    self.referenceView = view;
    self.grabbableResponder = responder;
    [self.view withY:self.referenceView.height - kJMMGrabbableHeaderHeight];
    _startPoint = self.view.center;
    [self.referenceView addSubview:self.view];
    return self;
}

-(void) loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kJMMGrabbableHeaderHeight)];
    _headerView.backgroundColor = kBlueColor;
    [self.view addSubview:_headerView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_headerView addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_headerView addGestureRecognizer:tap];
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.referenceView];
    _gravity = [[UIGravityBehavior alloc] init];
    [_animator addBehavior:_gravity];
    _gravity.magnitude = 4.0f;
    [_gravity addItem:self.view];
    UICollisionBehavior *col = [[UICollisionBehavior alloc] initWithItems:@[self.view]];
    [col addBoundaryWithIdentifier:@"BottomShelf" fromPoint:CGPointMake(0, self.view.y + self.view.height + 1) toPoint:CGPointMake(self.view.width, self.view.y + self.view.height + 1)];
    [col addBoundaryWithIdentifier:@"TopShelf" fromPoint:CGPointMake(0, -1) toPoint:CGPointMake(self.view.width, -1)];
    col.collisionDelegate = self;
    [_animator addBehavior:col];
    
    UIDynamicItemBehavior *behave = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
    behave.allowsRotation = NO;
    [_animator addBehavior:behave];
}

-(void) handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint touch = [gesture locationInView:self.referenceView];
    UIView *draggedView = self.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _draggingView = YES;
        _previousTouchPoint = touch;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged && _draggingView) {
        CGFloat yOffset = _previousTouchPoint.y - touch.y;
        if (draggedView.center.y - yOffset < _startPoint.y || _viewDocked) {
            draggedView.center = CGPointMake(draggedView.center.x, draggedView.center.y - yOffset);
            _previousTouchPoint = touch;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded && _draggingView) {
        _draggingView = NO;
        [self addVelocityToView:draggedView fromGesture:gesture];
        [_animator updateItemUsingCurrentState:draggedView];
        [self tryToDock];
    }
}

-(void) handleTap:(UITapGestureRecognizer *)gesture {
    if (_viewDocked) {
        [self undockView];
    }
    else {
        [self dockView];
    }
}

-(void) tryToDock {
    if (!_viewDocked && self.view.y < kJMMDockTriggerHeight) {
        [self dockView];
    }
    else if (_viewDocked && self.view.y >= kJMMDockReleaseHeight) {
        [self undockView];
    }
}

-(void) dockView {
    _snap = [[UISnapBehavior alloc] initWithItem:self.view snapToPoint:CGPointMake(self.referenceView.center.x, self.referenceView.center.y + 20)];
    [_animator addBehavior:_snap];
    [self setAlphaWhenViewDocked:self.view alpha:0];
    _viewDocked = YES;
}
-(void) undockView {
    [_animator removeBehavior:_snap];
    [self setAlphaWhenViewDocked:self.view alpha:1];
    _viewDocked = NO;
}

-(void) addVelocityToView:(UIView *)view fromGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint vel = [gesture velocityInView:self.view];
    vel.x = 0;
    UIDynamicItemBehavior *b = [self itemBehaviorForView:view];
    [b addLinearVelocity:vel forItem:view];
}

-(void) setAlphaWhenViewDocked:(UIView *)view alpha:(CGFloat)alpha {

}

-(UIDynamicItemBehavior *) itemBehaviorForView:(UIView *)view {
	for (UIDynamicItemBehavior *b in _animator.behaviors) {
        if (b.class == [UIDynamicItemBehavior class]) {
            if ([b.items firstObject] == view) {
                return b;
            }
        }
    }
    return nil;
}

-(void) collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    if ([@"TopShelf" isEqual:identifier]) {
        [self tryToDock];
    }
}
@end
