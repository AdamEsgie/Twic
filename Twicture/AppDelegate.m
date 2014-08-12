

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TwitterRequest.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  TwitterRequest *tw = [[TwitterRequest alloc] init];
  NSArray *accounts = [tw getAccounts];
  
  [self.window setRootViewController:[[MainViewController alloc] initWithFrame:self.window.bounds andAccounts:accounts]];
  [self.window makeKeyAndVisible];
  
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
