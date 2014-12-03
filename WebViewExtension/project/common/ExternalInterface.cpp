#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include "Native.h"


using namespace webviewextension;

// WebView stuff

static void initwv (value onURLChange, value onLoad, value onDestroy)
{
	initWV(onURLChange, onLoad, onDestroy);
}
DEFINE_PRIM (initwv, 3);

static value callscriptinwv(value script) {
	return alloc_string(callScriptInWV(val_get_string(script)));
}
DEFINE_PRIM (callscriptinwv, 1);

static void navigatewv (value inputValue)
{
	navigateWV(val_get_string(inputValue));
}
DEFINE_PRIM (navigatewv, 1);

static void navigatewvfile (value inputValue)
{
	navigateWVFile(val_get_string(inputValue));
}
DEFINE_PRIM (navigatewvfile, 1);

static void destroywv ()
{
	destroyWV();
}
DEFINE_PRIM (destroywv, 0);

// App listener for resign/resume

static void inital (value onResign, value onResume)
{
	initAL(onResign, onResume);
}
DEFINE_PRIM (inital, 2);


// Helpful functions for debugging

static void log (value str)
{
	Log(val_get_string(str));
}
DEFINE_PRIM (log, 1);

static void stacktrace()
{
	StackTrace();
}
DEFINE_PRIM (stacktrace, 0);


extern "C"
{
	void webviewextension_main ()
	{

	}
	DEFINE_ENTRY_POINT (native_main);

	int webviewextension_register_prims ()
	{
		return 0;
	}
}