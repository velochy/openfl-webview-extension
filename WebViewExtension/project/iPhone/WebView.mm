#import <UIKit/UIKit.h>
#include <hx/CFFI.h>
// The CFFI.h is pretty helpful in understanding what is going on. 
// However CFFIAPI.h is even better!
#include <Native.h>

// Based mainly on two sources:
// http://stackoverflow.com/questions/15821743/how-to-show-a-uiwebview-after-app-launch-only-after-the-page-loads
// https://github.com/SuatEyrice/NMEWebview
// http://iosdeveloperzone.com/2013/11/20/tutorial-building-a-web-browser-with-uiwebview-revisited-part-3/

@interface ViewController: UIViewController <UIWebViewDelegate>
{
    UIWebView * webView;
    UIView * splashScreen;
}

@property AutoGCRoot *onURLChangingCallback;
@property AutoGCRoot *onLoadCallback;
@property AutoGCRoot *onDestroyedCallback;

- (NSString *)callScript:(NSString *)script;
- (void)navigateTo:(NSURL *)url;
- (void)destroy; // Do we need this???

- (void)informError:(NSError*)error; 

@end

@implementation ViewController

- (void)viewDidLoad
{
    NSLog(@"view did load");

    [super viewDidLoad];

    CGRect rect = [[UIScreen mainScreen] bounds];

    splashScreen = [[[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil] objectAtIndex:0];
    splashScreen.frame = rect;
    [self.view addSubview:splashScreen];

    webView = [[UIWebView alloc] initWithFrame:rect];
    [webView setDelegate:self];

    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];

    // Do any additional setup after loading the view, typically from a nib.
}

// WebView controls

- (NSString *)callScript:(NSString *)script
{
    if (webView==nil) return @"";
    return [webView stringByEvaluatingJavaScriptFromString:script];
}
    
- (void)navigateTo:(NSURL *)url
{
    if (webView==nil) return;
    NSLog(@"NAVIGATE!");
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
}
  
- (void)destroy // Do we need this???
{
    val_call0(_onDestroyedCallback->get());
    
    [webView stopLoading];
    [webView removeFromSuperview];
    [webView release];
    webView = nil;
}

- (void)informError:(NSError*)error
{
    UIAlertView* alertView = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Error", @"Title for error alert.")
                          message:[error localizedDescription] delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK button in error alert.")
                          otherButtonTitles:nil];
    [alertView show];
}

// UIWebView Delegate stuff

- (void)webViewDidFinishLoad:(UIWebView *)curWebView
{
    [splashScreen removeFromSuperview];
    [self.view addSubview:curWebView];

    val_call0(_onLoadCallback->get());
}

- (BOOL)webView:(UIWebView *)instance shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  BOOL res = (BOOL)val_bool(val_call1(_onURLChangingCallback->get(), 
      alloc_string([
        [[request URL] absoluteString] 
        cStringUsingEncoding:NSUTF8StringEncoding
      ])));
  //NSLog(@"ONCHANGE %s %d",[url cStringUsingEncoding:NSUTF8StringEncoding],res);
  return res;
}

- (void)webView:(UIWebView *)instance didFailLoadWithError:(NSError *)error
{
    [self informError:error];
}

@end

namespace webviewextension {
	ViewController *instance;

	void initWV(value _onURLChangingCallback, value _onLoadCallback, value _onDestroyedCallback) {

        NSLog(@"initing");
		if(instance == nil)
            instance = [[ViewController alloc] init];

		instance.onURLChangingCallback = new AutoGCRoot(_onURLChangingCallback);
		instance.onLoadCallback = new AutoGCRoot(_onLoadCallback);
		instance.onDestroyedCallback = new AutoGCRoot(_onDestroyedCallback);
		
        NSLog(@"making WVC the RVC");
        [[UIApplication sharedApplication] keyWindow].rootViewController = instance;
	}

    const char * callScriptInWV(const char * script){
        return [[instance callScript:[NSString stringWithUTF8String:script]]
                cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
	void navigateWV (const char *url) {
		NSURL *_url = [[NSURL alloc] initWithString:[NSString stringWithUTF8String:url]];
		[instance navigateTo:_url];
	}


    void navigateWVFile(const char * fname) {
        NSString *fpath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:fname] ofType:@"html"];
        [instance navigateTo: [NSURL fileURLWithPath:fpath]];
    }

	void destroyWV () {
		[instance release];
		instance = nil;
	}
}
