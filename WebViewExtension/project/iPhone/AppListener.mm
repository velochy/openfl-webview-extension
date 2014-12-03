#import <UIKit/UIKit.h>
#include <hx/CFFI.h>
// The CFFI.h is pretty helpful in understanding what is going on. 
// However CFFIAPI.h is even better!
#include <Native.h>

@interface AppListener: NSObject {}

@property AutoGCRoot *onResignCallback;
@property AutoGCRoot *onResumeCallback;

-(void)onResign;
-(void)onResume;

@end

@implementation AppListener

- (id)init
{
    self = [super init];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(onResign) name:UIApplicationWillResignActiveNotification object:nil];
    [nc addObserver:self selector:@selector(onResume) name:UIApplicationDidBecomeActiveNotification object:nil];
   
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [nc removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    [super dealloc];
}

- (void)onResign
{
    if (_onResignCallback!=nil) val_call0(_onResignCallback->get());
}

- (void)onResume
{
    if (_onResumeCallback!=nil) val_call0(_onResumeCallback->get());
}

@end

namespace webviewextension {
	AppListener *appListener;

	void initAL(value _onResignCallback, value _onResumeCallback) {
        NSLog(@"initing AppListener");
        if(appListener == nil) appListener = [[AppListener alloc] init];

		appListener.onResignCallback = new AutoGCRoot(_onResignCallback);
		appListener.onResumeCallback = new AutoGCRoot(_onResumeCallback);
	}

    // Helper functions

	void Log(const char * msg) {
		NSLog(@"%s",msg);
	}

	void StackTrace() {
		NSLog(@"Stack: %@",[NSThread callStackSymbols]);
	}
}
