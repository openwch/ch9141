// CH9140DLLDemo.h : PROJECT_NAME Ӧ�ó������ͷ�ļ�
//

#pragma once

#ifndef __AFXWIN_H__
	#error "�ڰ������ļ�֮ǰ������stdafx.h�������� PCH �ļ�"
#endif

#include "resource.h"		// ������


// CCH9140DLLDemoApp:
// �йش����ʵ�֣������ CH9140DLLDemo.cpp
//

class CCH9140DLLDemoApp : public CWinApp
{
public:
	CCH9140DLLDemoApp();

// ��д
	public:
	virtual BOOL InitInstance();

// ʵ��

	DECLARE_MESSAGE_MAP()
};

extern CCH9140DLLDemoApp theApp;