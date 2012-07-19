//
//  IASlideoutMenuController.h
//  IADrawerController
//
//  Created by Mark Adams on 12/16/11.
//  BSD License
//

#import <UIKit/UIKit.h>

@interface IAMenuController : UIViewController

@property (nonatomic, strong) UIViewController *contentViewController;

- (id)initWithMenuViewController:(UIViewController *)menu contentViewController:(UIViewController *)content barButtonItem:(UIBarButtonItem *)barButtonItem;

@end
