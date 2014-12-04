/* IAMenuController.h
 * IAMenuController
 *
 * Created by Mark Adams on 12/16/11.
 * MIT License
 */

#import <UIKit/UIKit.h>

extern NSString *const IAMenuWillOpenNotification;
extern NSString *const IAMenuDidOpenNotification;
extern NSString *const IAMenuWillCloseNotification;
extern NSString *const IAMenuDidCloseNotification;

@interface IAMenuController : UIViewController

@property (nonatomic, strong) UIViewController *menuViewController;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic, assign) CGFloat percentageOfScreenWidthUsedByMenu;

- (id)initWithMenuViewController:(UIViewController *)menu contentViewController:(UIViewController *)content;
- (void)toggleMenu;

@end

@interface UIViewController (IAMenuController)

- (IAMenuController *)menuController;

@end
