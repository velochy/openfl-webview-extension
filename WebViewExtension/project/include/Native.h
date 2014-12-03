#ifndef Native_H_
#define Native_H_

namespace webviewextension
{
  void initWV(value changeCallback, value onloadCallback, value destroyCallback);
  void navigateWV(const char *url);
  void navigateWVFile(const char *fname);
  const char * callScriptInWV(const char *url);
  void destroyWV();

  void initAL(value onResign, value onResume);

  void Log(const char * str);
  void StackTrace();
}

#endif