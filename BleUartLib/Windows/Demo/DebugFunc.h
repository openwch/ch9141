#ifndef		_DEBUGFUNC_H
#define		_DEBUGFUNC_H

//显示格式化字符串
VOID  DbgPrint (LPCTSTR lpFormat,...);
/*显示上次运行错误*/
//void ShowLastError(PCHAR FuncName);
void ShowLastError(LPCTSTR lpFormat,...) ;
/*将十六进制字符转换成十进制码,数字转换成字符用ltoa()函数*/
ULONG mStrToBcd(PCHAR str); 
double GetCurrentTimerVal();//获取硬件计数器已运行时间,ms为单位,比GetTickCount更准确
//延时函数,以ms为单位
VOID DelayTime1(double TimerVal);//定时值为ms,其定时误差一般不超过0.5微秒，精度与CPU等机器配置有关

#endif