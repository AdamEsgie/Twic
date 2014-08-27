

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TwitterRequest.h"
#import "DataManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  TwitterRequest *tw = [[TwitterRequest alloc] init];
  [tw getAccountsWithCompletionHandler:^(NSArray *accounts) {
    [self.window setRootViewController:[[MainViewController alloc] initWithFrame:self.window.bounds andAccounts:accounts]];
    [self.window makeKeyAndVisible];
  }];
  
  return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
 
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}


@end
