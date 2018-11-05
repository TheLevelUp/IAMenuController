/* AppDelegate.m
 * IAMenuController
 *
 * Created by Mark Adams on 12/8/11.
 * MIT License
 */

#import "AppDelegate.h"
#import "IAMenuController.h"
#import "ListViewController.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidPostNotification:)
                                               name:IAMenuWillOpenNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidPostNotification:)
                                               name:IAMenuDidOpenNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidPostNotification:)
                                               name:IAMenuWillCloseNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidPostNotification:)
                                               name:IAMenuDidCloseNotification object:nil];

  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];

  MainViewController *mvc = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mvc];

  ListViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
  IAMenuController *drawerController = [[IAMenuController alloc] initWithMenuViewController:lvc
                                                                      contentViewController:nav];

  self.window.rootViewController = drawerController;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)menuDidPostNotification:(NSNotification *)notification {
  NSLog(@"%@", notification);
}

@end
