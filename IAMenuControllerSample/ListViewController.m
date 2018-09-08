/* ListViewController.m
 * IAMenuController
 *
 * Created by Mark Adams on 12/9/11.
 * MIT License
 */

#import "ListViewController.h"
#import "IAMenuController-Swift.h"
#import "MainViewController.h"

@interface NSArray (RandomObject)

- (id)randomObject;

@end

#pragma mark -

@implementation NSArray (RandomObject)

- (id)randomObject {
  NSUInteger randomInteger = arc4random_uniform(self.count);
  return [self objectAtIndex:randomInteger];
}

@end

#pragma mark -

@interface ListViewController ()

@property (nonatomic, strong) NSArray *possibleColors;

@end

#pragma mark -

@implementation ListViewController

@synthesize possibleColors;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.showsVerticalScrollIndicator = NO;

  self.possibleColors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor cyanColor], [UIColor greenColor],
                         [UIColor lightGrayColor], [UIColor magentaColor], [UIColor brownColor],
                         [UIColor orangeColor], nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MainViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
  mvc.view.backgroundColor = [self.possibleColors randomObject];
  self.menuController.contentViewController = mvc;
}

@end
