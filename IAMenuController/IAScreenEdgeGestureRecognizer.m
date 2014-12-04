/* IAScreenEdgeGestureRecognizer.m
 * IAMenuController
 *
 * Created by Gordon Fontenot on 10/22/13.
 * Copyright (c) 2013 Mark Adams. All rights reserved.
 */

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "IAScreenEdgeGestureRecognizer.h"

@implementation IAScreenEdgeGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action {
  self = [super initWithTarget:target action:action];
  if (!self) return nil;

  self.cancelsTouchesInView = YES;

  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches allObjects][0];
  CGPoint location = [touch locationInView:self.view];
  if (location.x > 50) {
    self.state = UIGestureRecognizerStateFailed;
    return;
  }

  [super touchesBegan:touches withEvent:event];
}

@end
