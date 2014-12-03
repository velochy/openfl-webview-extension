package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

class WebViewExtension
{
    private static var initwv : Dynamic;
    private static var navigatewv : Dynamic;
    private static var navigatewvfile : Dynamic;
    private static var callscriptinwv : Dynamic;
    private static var destroywv : Dynamic;

    private static var inital : Dynamic;
    private static var logger : Dynamic;
    private static var stacktrace : Dynamic;

    private static var wv_initialized: Bool = false;

    private static function initWVAPI() {
        if (initwv != null) return;
        initwv = Lib.load("webviewextension","initwv", 3);
        navigatewv = Lib.load("webviewextension","navigatewv", 1);
        navigatewvfile = Lib.load("webviewextension","navigatewvfile", 1);
        destroywv = Lib.load("webviewextension","destroywv", 0);
        callscriptinwv = Lib.load("webviewextension","callscriptinwv", 1);
    }

    public static function initWV(onURLChange: String->Bool, onPageLoad: Void->Void, onDestroy: Void->Void):Void
    {
        if (!wv_initialized) {
            initWVAPI();
            initwv(onURLChange, 
                onPageLoad,
                function() { onDestroy(); wv_initialized=false; });
            wv_initialized = true;
        }
    }

    public static function callScriptInWV(script:String): String {
        if (wv_initialized) return callscriptinwv(script);
        return '';
    }
    
    public static function navigateWV(url:String):Void
    {
        if (wv_initialized) navigatewv(url);
    }

    // NB! filename is <without> extension (.html)
    public static function navigateWVFile(fname:String):Void
    {
        if (wv_initialized) navigatewvfile(fname);
    }
    
    public static function destroyWV():Void
    {
        if (wv_initialized) destroywv();
    }

    public static function initAL(onResign: Void->Void, onResume: Void->Void) {
        if (inital==null) inital = Lib.load("webviewextension","inital", 2);
        inital(onResign,onResume);
    }

    public static function log(msg: String) {
        if (logger==null) logger = Lib.load("webviewextension","log", 1);
        logger(msg);
    }

    public static function stackTrace() {
        if (stacktrace==null) stacktrace = Lib.load("webviewextension","stacktrace", 0);
        stacktrace();
    }
}
