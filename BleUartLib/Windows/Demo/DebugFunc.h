#ifndef		_DEBUGFUNC_H
#define		_DEBUGFUNC_H

//��ʾ��ʽ���ַ���
VOID  DbgPrint (LPCTSTR lpFormat,...);
/*��ʾ�ϴ����д���*/
//void ShowLastError(PCHAR FuncName);
void ShowLastError(LPCTSTR lpFormat,...) ;
/*��ʮ�������ַ�ת����ʮ������,����ת�����ַ���ltoa()����*/
ULONG mStrToBcd(PCHAR str); 
double GetCurrentTimerVal();//��ȡӲ��������������ʱ��,msΪ��λ,��GetTickCount��׼ȷ
//��ʱ����,��msΪ��λ
VOID DelayTime1(double TimerVal);//��ʱֵΪms,�䶨ʱ���һ�㲻����0.5΢�룬������CPU�Ȼ��������й�

#endif