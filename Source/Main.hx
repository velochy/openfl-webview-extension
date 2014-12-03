import haxe.CallStack;

import flash.display.Sprite;
import flash.Lib;
import flash.events.Event;
import flash.events.UncaughtErrorEvent;

class Main extends Sprite 
{
  public static var instance: Main;

  private var callables: Map<String,Array<Dynamic>->Dynamic>;

  private var inited: Bool = false;
  private var silent: Bool = false;

  // HAXE INTERNAL

  public static function triggerEvent(eventName: String, data:Dynamic = null, silent:Bool = false) {
      if (!silent) trace(eventName + " triggered");
      WebViewExtension.callScriptInWV('trigger("'+eventName+'",'+haxe.Json.stringify(data)+');');
  }

  public function echo(name: Dynamic, value: Dynamic):Void {
    triggerEvent(Std.string(name),Std.string(value));
  }

  static function main() {
    // custom trace => send to log
    haxe.Log.trace = function(v:Dynamic, ?pos:haxe.PosInfos):Void {
      WebViewExtension.log(pos.fileName+':'+Std.string(pos.lineNumber)+': '+Std.string(v));
    };

    Lib.current.addChild(new Main()); // this causes instance to be created and set

    instance.init();
  }

  public function new() 
  {
    super();
    instance = this;
  }

  public function init() {

    if (inited) return;
    inited = true;

    var resign = function():Void {
      trace("onResign");
    };

    var resume = function():Void {
      trace("onResume");
    };

    trace("INIT AL!");
    WebViewExtension.initAL(resign,resume);

    var url_change = function(url:String):Bool {

      // Intercept calls to haxe code
      if (url.substr(0,5)=="haxe:") {
        var data = haxe.Json.parse(StringTools.urlDecode(url.substr(5)));

        if (!silent) trace("Called: "+Std.string(data.name));

        var fn = callables.get(data.name);
        if (fn==null) 
          trace("Error: no callable "+data.name);
        else {
          var res = fn(data.args);
        }
          
        return false;
      }
      else {
        if (!silent) trace("onURLChanging: " + url);
        return true;
      }
    };
    
    var pageload = function(): Void {
      // Let page know haxe code is present and ready
      triggerEvent('initialize', { 
          backend:'HaXe'
        });
    }

    var destroyed = function():Void {
      trace("onDestroyed");
    };

    trace("INIT WV!");
    WebViewExtension.initWV(url_change,pageload,destroyed);
    WebViewExtension.navigateWVFile("index");
    //WebViewExtension.navigateWV("http://www.google.com");


    callables = new Map();

    trace("ADD ECHO!");
    instance.addJSCallback('echo','echo');
  }

  private function addJSCallback(name: String, action: String) {
      var method = Reflect.field(this, action),
          self = this;
      var wrappedAction = function(args: Array<Dynamic>): Dynamic  {
          try {
              return Reflect.callMethod(self, method, args);
          } catch (e: Dynamic) {
              trace('Error in callback'+name);//, e, "stack:", CallStack.exceptionStack());
          }
          return -1;
      };

      callables.set(name,wrappedAction);
  }

  private static function addExceptionHandler() {
      if( Lib.current.stage != null ) {
          Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(
              UncaughtErrorEvent.UNCAUGHT_ERROR,
              uncaughtErrorHandler);
          return true;
      }
      return false;
  }

  private static function uncaughtErrorHandler(event:UncaughtErrorEvent) {
      trace(event);
  }
}
