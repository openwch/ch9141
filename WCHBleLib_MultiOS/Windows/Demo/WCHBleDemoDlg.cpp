
// WCHBleDemoDlg.cpp: 实现文件
//

#include "pch.h"
#include "framework.h"
#include "WCHBleDemo.h"
#include "WCHBleDemoDlg.h"
#include "afxdialogex.h"
#include <BluetoothAPIs.h>
#pragma comment(lib,"Bthprops.lib")  

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

struct ParamInf
{
	WCHBLEHANDLE DevHandle;
	USHORT ServiceUUID;
	USHORT CharacteristicUUID;
};

//全局变量
CWnd* maindlg = NULL;
BLENameDevID g_BLEDev[MAX_PATH];
WCHBLEHANDLE g_devhandle;
char g_blepath[100] = "";
char g_blename[100] = "";
USHORT g_serviceUUID[100] = { 0 };
USHORT g_characteristicUUID[100] = { 0 };
ParamInf g_paramInf[MAX_PATH]; 
int g_MTU = 0;
CMutex g_blerecvcmutex;
HANDLE g_recvevent = NULL;
char g_blerecvdata[102400] = "";
char g_recvcopybuf[102400] = "";
int g_blerecvlen = 0;
char g_send_char[1030] = "";
int g_send_len = 0;
char g_transbuf[102400] = "";


DWORD WINAPI BleRxThread(LPVOID lpparam);

// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_ABOUTBOX };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CWCHBleDemoDlg 对话框



CWCHBleDemoDlg::CWCHBleDemoDlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_WCHBLEDEMO_DIALOG, pParent)
	, m_edit_write(_T(""))
	, m_edit_read(_T(""))
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	maindlg = (CWnd*)this;
}

void CWCHBleDemoDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST_DEV, m_list_dev);
	DDX_Control(pDX, IDC_COMBO_SERVICE, m_combo_service);
	DDX_Control(pDX, IDC_COMBO_FEATURE, m_combo_feature);
	DDX_Text(pDX, IDC_EDIT_WRITE, m_edit_write);
	DDX_Text(pDX, IDC_EDIT_READ, m_edit_read);
}

BEGIN_MESSAGE_MAP(CWCHBleDemoDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_SCANDEV, &CWCHBleDemoDlg::OnBnClickedButtonScandev)
	ON_BN_CLICKED(IDC_BUTTON_OPENDEV, &CWCHBleDemoDlg::OnBnClickedButtonOpendev)
	ON_BN_CLICKED(IDC_BUTTON_GETSERVICE, &CWCHBleDemoDlg::OnBnClickedButtonGetservice)
	ON_BN_CLICKED(IDC_BUTTON_GETFEATURE, &CWCHBleDemoDlg::OnBnClickedButtonGetfeature)
	ON_BN_CLICKED(IDC_BUTTON_GETACTION, &CWCHBleDemoDlg::OnBnClickedButtonGetaction)
	ON_BN_CLICKED(IDC_BUTTON_NOTIFY, &CWCHBleDemoDlg::OnBnClickedButtonNotify)
	ON_BN_CLICKED(IDC_BUTTON_READ, &CWCHBleDemoDlg::OnBnClickedButtonRead)
	ON_BN_CLICKED(IDC_BUTTON_WRITE, &CWCHBleDemoDlg::OnBnClickedButtonWrite)
	ON_BN_CLICKED(IDC_BUTTON_CLRREAD, &CWCHBleDemoDlg::OnBnClickedButtonClrread)
	ON_BN_CLICKED(IDC_BUTTON_CLRWRITE, &CWCHBleDemoDlg::OnBnClickedButtonClrwrite)
	ON_CBN_SELCHANGE(IDC_COMBO_FEATURE, &CWCHBleDemoDlg::OnCbnSelchangeComboFeature)
	ON_CBN_SELCHANGE(IDC_COMBO_SERVICE, &CWCHBleDemoDlg::OnCbnSelchangeComboService)
	ON_BN_CLICKED(IDC_CHECK_HEX, &CWCHBleDemoDlg::OnBnClickedCheckHex)
	ON_BN_CLICKED(IDC_CHECK_HEX2, &CWCHBleDemoDlg::OnBnClickedCheckHex2)
	ON_EN_CHANGE(IDC_EDIT_WRITE, &CWCHBleDemoDlg::OnEnChangeEditWrite)
	ON_BN_CLICKED(IDC_BUTTON_VERSION, &CWCHBleDemoDlg::OnBnClickedButtonVersion)
END_MESSAGE_MAP()


// CWCHBleDemoDlg 消息处理程序

BOOL CWCHBleDemoDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != nullptr)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。  当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码
	bool Support = FALSE;
	CRect rect;
	// 获取编程语言列表视图控件的位置和大小   
	m_list_dev.GetClientRect(&rect);
	// 为列表视图控件添加全行选中和栅格风格   
	m_list_dev.SetExtendedStyle(m_list_dev.GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES | LVS_EX_CHECKBOXES);
	// 为列表视图控件添加两列   
	m_list_dev.InsertColumn(1, _T("设备"), LVCFMT_CENTER, rect.Width() / 6, 0);
	m_list_dev.InsertColumn(2, _T("Mac地址"), LVCFMT_CENTER, rect.Width() / 3, 1);
	m_list_dev.InsertColumn(3, _T("详细信息"), LVCFMT_CENTER, rect.Width() / 2, 2);

	WCHBLEInit();

	SendDlgItemMessage(IDC_EDIT_READ, EM_LIMITTEXT, 0xFFFFFFFF, 0);

	g_recvevent = CreateEvent(NULL, FALSE, FALSE, NULL);
	CloseHandle(CreateThread(NULL, 0, BleRxThread, this, 0, NULL));			//创建蓝牙接收文件线程

	Support = WCHBLEIsLowEnergySupported();
	if (!Support) {
		MessageBox("控制器不支持低功耗蓝牙!", "WCHBleDemo", MB_ICONERROR);
	}
	Support = WCHBLEIsBluetoothOpened();
	if (!Support) {
		MessageBox("请打开系统蓝牙以确保正常使用！", "WCHBleDemo", MB_ICONERROR);
	}

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CWCHBleDemoDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。  对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CWCHBleDemoDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CWCHBleDemoDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


VOID CALLBACK FunDevConnChange(void* hDev, UCHAR ConnectStatus)
{
	CWCHBleDemoDlg* pDlg = (CWCHBleDemoDlg*)maindlg;

	if (ConnectStatus == 0) {
		pDlg->GetDlgItem(IDC_BUTTON_NOTIFY)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_BUTTON_READ)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_BUTTON_WRITE)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_BUTTON_GETSERVICE)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_BUTTON_GETFEATURE)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_BUTTON_GETACTION)->EnableWindow(FALSE);
		pDlg->m_combo_service.ResetContent();
		pDlg->m_combo_feature.ResetContent();
		pDlg->GetDlgItem(IDC_BUTTON_OPENDEV)->SetWindowText("打开设备");
	}
}

/*BLE read回调函数*/
VOID CALLBACK FunReadCallBack(void* ParamInf, PCHAR ReadBuf, ULONG ReadBufLen)
{
	g_blerecvcmutex.Lock();
	memcpy(&g_blerecvdata[g_blerecvlen], ReadBuf, ReadBufLen);
	g_blerecvlen += ReadBufLen;
	g_blerecvcmutex.Unlock();
	SetEvent(g_recvevent);

}

/*
接收线程
接收线程一直都在，在没有接收的时候会等待事件触发
*/
DWORD WINAPI BleRxThread(LPVOID lpparam)
{
	CWCHBleDemoDlg* pDlg = (CWCHBleDemoDlg*)maindlg;
	DWORD recvlen = 0;

	while (1) {
		WaitForSingleObject(g_recvevent, INFINITE);
		g_blerecvcmutex.Lock();
		memset(g_recvcopybuf, 0, sizeof(g_recvcopybuf));
		memcpy(g_recvcopybuf, g_blerecvdata, g_blerecvlen);
		memset(g_blerecvdata, 0, g_blerecvlen);
		recvlen = g_blerecvlen;
		g_blerecvlen = 0;
		g_blerecvcmutex.Unlock();

		SendDlgItemMessage(maindlg->m_hWnd, IDC_EDIT_READ, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
		SendDlgItemMessage(maindlg->m_hWnd, IDC_EDIT_READ, EM_REPLACESEL, 0, (LPARAM)g_recvcopybuf);
		SendDlgItemMessage(maindlg->m_hWnd, IDC_EDIT_READ, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
	
		CString temp = "";

		temp = pDlg->Char2Hex(g_recvcopybuf, recvlen);
		memset(g_transbuf, 0, sizeof(g_transbuf));
		memcpy(g_transbuf, temp, temp.GetLength());
		SendDlgItemMessage(maindlg->m_hWnd, IDC_EDIT_READHEX, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
		SendDlgItemMessage(maindlg->m_hWnd, IDC_EDIT_READHEX, EM_REPLACESEL, 0, (LPARAM)g_transbuf);
		SendDlgItemMessage(maindlg->m_hWnd, IDC_EDIT_READHEX, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
	
	}
	return 0;
}

void CWCHBleDemoDlg::OnBnClickedButtonScandev()
{
	// TODO: 在此添加控件通知处理程序代码
	int scanTimes = 1000, scannum = 20, listcount = 0;
	char DevIDFilter[100] = "";
	CHAR bleMac[100] = "";
	PCHAR mactemp = NULL;

	if (!WCHBLEIsBluetoothOpened()) {
		MessageBox("请先打开系统蓝牙！", "WCHBleDemo", MB_ICONERROR);
		return;
	}

	memset(g_BLEDev, 0, sizeof(g_BLEDev));
	WCHBLEEnumDevice(scanTimes, DevIDFilter, g_BLEDev, (ULONG*)&scannum);
	m_list_dev.DeleteAllItems();
	for (int i = 0; i < scannum; ++i) {
		memcpy(bleMac, g_BLEDev[i].DevID, 100);
		mactemp = strchr(bleMac, '-');
		m_list_dev.InsertItem(listcount, (char*)g_BLEDev[i].Name);
		m_list_dev.SetItemText(listcount, 1, mactemp + 1);
		m_list_dev.SetItemText(listcount, 2, (char*)g_BLEDev[i].DevID);
		listcount++;
	}
}


void CWCHBleDemoDlg::OnBnClickedButtonOpendev()
{
	// TODO: 在此添加控件通知处理程序代码
	if (g_devhandle != NULL) {
		WCHBLECloseDevice(g_devhandle);
		g_devhandle = NULL;
		GetDlgItem(IDC_BUTTON_OPENDEV)->SetWindowText("打开设备");
		GetDlgItem(IDC_BUTTON_NOTIFY)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON_READ)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON_WRITE)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON_GETSERVICE)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON_GETFEATURE)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON_GETACTION)->EnableWindow(FALSE);
		GetDlgItem(IDC_LIST_DEV)->EnableWindow(TRUE);
		m_combo_service.ResetContent();
		m_combo_feature.ResetContent();
	} else {
		CString tmppath = "", tmpname = "";
		POSITION pos;
		int nItem = 0, len = 0, TotalItem = 0;

		pos = m_list_dev.GetFirstSelectedItemPosition(); // 获取选中行
		nItem = m_list_dev.GetNextSelectedItem(pos);
		tmppath = m_list_dev.GetItemText(nItem, 2);
		tmpname = m_list_dev.GetItemText(nItem, 0);

		memset(g_blepath, 0, sizeof(g_blepath));
		memset(g_blename, 0, sizeof(g_blename));
		len = tmppath.GetLength();
		memcpy(g_blepath, tmppath, len);
		len = tmpname.GetLength();
		memcpy(g_blename, tmpname, len);

		g_devhandle = WCHBLEOpenDevice(g_blepath, FunDevConnChange);
		if (g_devhandle == NULL) {
			MessageBox("打开设备失败！", "WCHBleDemo", MB_ICONWARNING);
			return;
		} else {
			GetDlgItem(IDC_BUTTON_OPENDEV)->SetWindowText("关闭设备");
			GetDlgItem(IDC_BUTTON_GETSERVICE)->EnableWindow(TRUE);
			GetDlgItem(IDC_LIST_DEV)->EnableWindow(FALSE);
			TotalItem = m_list_dev.GetItemCount();
			for (int i = 0; i < TotalItem; ++i) {
				m_list_dev.SetCheck(i, FALSE);
			}
			m_list_dev.SetCheck(nItem, TRUE);
		}
	}
}


void CWCHBleDemoDlg::OnBnClickedButtonGetservice()
{
	// TODO: 在此添加控件通知处理程序代码
	int pUUIDArryLen = 20, ret = 0;
	CString transbuf("");

	ret = WCHBLEGetAllServicesUUID(g_devhandle, g_serviceUUID, (USHORT*)&pUUIDArryLen);
	if (ret != 0) {
		MessageBox("获取服务失败！", "WCHBleDemo", MB_ICONWARNING);
		return;
	}
	m_combo_service.ResetContent();
	for (int i = 0; i < pUUIDArryLen; ++i) {
		transbuf.Format("%02X", g_serviceUUID[i]);
		m_combo_service.AddString(transbuf);
	}
	m_combo_service.SetCurSel(0);
	ret = WCHBLEGetMtu(g_devhandle, (USHORT*)&g_MTU);
	if (ret != 0) {
		MessageBox("获取服务失败！", "WCHBleDemo", MB_ICONWARNING);
		return;
	}
	GetDlgItem(IDC_BUTTON_GETFEATURE)->EnableWindow(TRUE);
}


void CWCHBleDemoDlg::OnBnClickedButtonGetfeature()
{
	// TODO: 在此添加控件通知处理程序代码
	int pUUIDArryLen = 20, ret = 0, select = 0;
	CString transbuf("");

	select = ((CComboBox*)GetDlgItem(IDC_COMBO_SERVICE))->GetCurSel();
	ret = WCHBLEGetCharacteristicByUUID(g_devhandle, g_serviceUUID[select], g_characteristicUUID, (USHORT*)&pUUIDArryLen);
	if (ret != 0) {
		MessageBox("获取特征失败！", "WCHBleDemo", MB_ICONWARNING);
		return;
	}
	m_combo_feature.ResetContent();
	for (int i = 0; i < pUUIDArryLen; ++i) {
		transbuf.Format("%02X", g_characteristicUUID[i]);
		m_combo_feature.AddString(transbuf);
	}
	m_combo_feature.SetCurSel(0);
	GetDlgItem(IDC_BUTTON_GETACTION)->EnableWindow(TRUE);
}


void CWCHBleDemoDlg::OnBnClickedButtonGetaction()
{
	// TODO: 在此添加控件通知处理程序代码
	int pAction = 0, ret = 0, select1 = 0, select2 = 0;
	CString transbuf("");

	select1 = ((CComboBox*)GetDlgItem(IDC_COMBO_SERVICE))->GetCurSel();
	select2 = ((CComboBox*)GetDlgItem(IDC_COMBO_FEATURE))->GetCurSel();
	ret = WCHBLEGetCharacteristicAction(g_devhandle, g_serviceUUID[select1], g_characteristicUUID[select2], (ULONG*)&pAction);
	if (ret != 0) {
		MessageBox("获取特征支持操作失败！", "WCHBleDemo", MB_ICONWARNING);
		return;
	}

	if (pAction & 0x01) {
		GetDlgItem(IDC_BUTTON_READ)->EnableWindow(TRUE);
	} else {
		GetDlgItem(IDC_BUTTON_READ)->EnableWindow(FALSE);
	}
	if ((pAction >> 1) & 0x01) {
		GetDlgItem(IDC_BUTTON_WRITE)->EnableWindow(TRUE);
	} else {
		GetDlgItem(IDC_BUTTON_WRITE)->EnableWindow(FALSE);
	}
	if ((pAction >> 2) & 0x01) {
		GetDlgItem(IDC_BUTTON_NOTIFY)->EnableWindow(TRUE);
	} else {
		GetDlgItem(IDC_BUTTON_NOTIFY)->EnableWindow(FALSE);
	}
}


void CWCHBleDemoDlg::OnBnClickedButtonNotify()
{
	// TODO: 在此添加控件通知处理程序代码
	int ret = 0, select1 = 0, select2 = 0;
	CString status;

	select1 = ((CComboBox*)GetDlgItem(IDC_COMBO_SERVICE))->GetCurSel();
	select2 = ((CComboBox*)GetDlgItem(IDC_COMBO_FEATURE))->GetCurSel();
	g_paramInf[0].DevHandle = g_devhandle;
	g_paramInf[0].CharacteristicUUID = g_characteristicUUID[select2];
	g_paramInf[0].ServiceUUID = g_serviceUUID[select1];

	GetDlgItemText(IDC_BUTTON_NOTIFY, status);
	if (status == "打开订阅") {
		ret = WCHBLERegisterReadNotify(g_devhandle, g_serviceUUID[select1], g_characteristicUUID[select2], FunReadCallBack, (void*)&g_paramInf[0]);
		if (ret != 0) {
			MessageBox("打开订阅失败！", "WCHBleDemo", MB_ICONWARNING);
			return;
		}
		GetDlgItem(IDC_BUTTON_NOTIFY)->SetWindowText("关闭订阅");
	} else {
		ret = WCHBLERegisterReadNotify(g_devhandle, g_serviceUUID[select1], g_characteristicUUID[select2], NULL, (void*)&g_paramInf[0]);
		if (ret != 0) {
			MessageBox("关闭订阅失败！", "WCHBleDemo", MB_ICONWARNING);
			return;
		}
		GetDlgItem(IDC_BUTTON_NOTIFY)->SetWindowText("打开订阅");
	}
}


void CWCHBleDemoDlg::OnBnClickedButtonRead()
{
	// TODO: 在此添加控件通知处理程序代码
	int ret = 0, select1 = 0, select2 = 0, readlen = 512;
	char readbuf[512] = "";
	CString temp = "";

	select1 = ((CComboBox*)GetDlgItem(IDC_COMBO_SERVICE))->GetCurSel();
	select2 = ((CComboBox*)GetDlgItem(IDC_COMBO_FEATURE))->GetCurSel();

	ret = WCHBLEReadCharacteristic(g_devhandle, g_serviceUUID[select1], g_characteristicUUID[select2],
		readbuf, (UINT*)&readlen);
	if (ret != 0) {
		MessageBox("读取特征值失败！", "WCHBleDemo", MB_ICONWARNING);
		return;
	}
	SendDlgItemMessage(IDC_EDIT_READ, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
	SendDlgItemMessage(IDC_EDIT_READ, EM_REPLACESEL, 0, (LPARAM)readbuf);
	SendDlgItemMessage(IDC_EDIT_READ, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
	
	temp = Char2Hex(readbuf, readlen);
	memset(g_transbuf, 0, sizeof(g_transbuf));
	memcpy(g_transbuf, temp, temp.GetLength());
	SendDlgItemMessage(IDC_EDIT_READHEX, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
	SendDlgItemMessage(IDC_EDIT_READHEX, EM_REPLACESEL, 0, (LPARAM)g_transbuf);
	SendDlgItemMessage(IDC_EDIT_READHEX, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
}


void CWCHBleDemoDlg::OnBnClickedButtonWrite()
{
	// TODO: 在此添加控件通知处理程序代码
	int ret = 0, select1 = 0, select2 = 0, datalen = 0, sendedlen = 0;
	select1 = ((CComboBox*)GetDlgItem(IDC_COMBO_SERVICE))->GetCurSel();
	select2 = ((CComboBox*)GetDlgItem(IDC_COMBO_FEATURE))->GetCurSel();

	datalen = g_send_len;
	while (datalen > sendedlen) {
		if (datalen - sendedlen >= g_MTU - 3) {
			ret = WCHBLEWriteCharacteristic(g_devhandle, g_serviceUUID[select1], g_characteristicUUID[select2], 0,
				g_send_char + sendedlen, g_MTU - 3);
			sendedlen += g_MTU - 3;
		} else {
			ret = WCHBLEWriteCharacteristic(g_devhandle, g_serviceUUID[select1], g_characteristicUUID[select2], 0,
				g_send_char + sendedlen, (datalen - sendedlen));
			sendedlen += (datalen - sendedlen);
		}
		if (ret != 0) {
			MessageBox("写入特征值失败！", "WCHBleDemo", MB_ICONWARNING);
			return;
		}
		Sleep(10);
	}
}


void CWCHBleDemoDlg::OnBnClickedButtonClrread()
{
	// TODO: 在此添加控件通知处理程序代码
	m_edit_read = "";
	SetDlgItemText(IDC_EDIT_READ, m_edit_read);
	SetDlgItemText(IDC_EDIT_READHEX, m_edit_read);
}


void CWCHBleDemoDlg::OnBnClickedButtonClrwrite()
{
	// TODO: 在此添加控件通知处理程序代码
	m_edit_write = "";
	memset(g_send_char, 0, sizeof(g_send_char));
	g_send_len = 0;
	SetDlgItemText(IDC_EDIT_WRITE, m_edit_write);
}


void CWCHBleDemoDlg::OnCbnSelchangeComboFeature()
{
	// TODO: 在此添加控件通知处理程序代码
	GetDlgItem(IDC_BUTTON_NOTIFY)->EnableWindow(FALSE);
	GetDlgItem(IDC_BUTTON_READ)->EnableWindow(FALSE);
	GetDlgItem(IDC_BUTTON_WRITE)->EnableWindow(FALSE);
}


void CWCHBleDemoDlg::OnCbnSelchangeComboService()
{
	// TODO: 在此添加控件通知处理程序代码
	GetDlgItem(IDC_BUTTON_NOTIFY)->EnableWindow(FALSE);
	GetDlgItem(IDC_BUTTON_READ)->EnableWindow(FALSE);
	GetDlgItem(IDC_BUTTON_WRITE)->EnableWindow(FALSE);
}


void CWCHBleDemoDlg::OnBnClickedCheckHex()
{
	// TODO: 在此添加控件通知处理程序代码
	if (((CButton*)GetDlgItem(IDC_CHECK_HEX))->GetCheck() == 1) {
		GetDlgItem(IDC_EDIT_READ)->ShowWindow(SW_HIDE);
		GetDlgItem(IDC_EDIT_READHEX)->ShowWindow(SW_SHOW);

	} else {
		GetDlgItem(IDC_EDIT_READ)->ShowWindow(SW_SHOW);
		GetDlgItem(IDC_EDIT_READHEX)->ShowWindow(SW_HIDE);

	}
}

/*将char型数据转换成16进制的两个字符*/
CString CWCHBleDemoDlg::Char2Hex(char* pdata, int length)
{
	unsigned char* temp = (unsigned char*)malloc(length);
	CString tmpStr = "", testStr = "";

	memcpy(temp, pdata, length);
	for (int i = 0; i < length; i++) {
		testStr.Format("%02X ", temp[i]);
		tmpStr += testStr;
	}
	free(temp);
	temp = NULL;
	return tmpStr;
}

void CWCHBleDemoDlg::OnBnClickedCheckHex2()
{
	// TODO: 在此添加控件通知处理程序代码
	CString temp = "";

	if (((CButton*)GetDlgItem(IDC_CHECK_HEX2))->GetCheck() == 1) {
		//m_edit_recv = g_recv_hex;
		temp = Char2Hex(g_send_char, g_send_len);
		m_edit_write = temp;
	} else {
		//m_edit_recv = g_recv_char;
		m_edit_write = g_send_char;
	}

	GetDlgItem(IDC_EDIT_WRITE)->SetWindowText(m_edit_write);
}

/********************************************两个字符拼接成十六进制数*************************************************/
BOOL CWCHBleDemoDlg::CharToHex(CHAR* pInChar, CHAR* pOutChar)
{
	CHAR h, l;

	if (pInChar[0] == NULL || pInChar[1] == NULL) {
		return FALSE;
	}
	if (pInChar[1] == 0x00)
	{
		h = pInChar[0];
		l = h;
		h = 0x30;
	}
	else
	{
		h = pInChar[0]; //高4位
		l = pInChar[1]; //低4位
	}
	if (l >= '0' && l <= '9')
	{
		l = l - '0';
	}
	else if (l >= 'a' && l <= 'f')
	{
		l = l - 'a' + 0xa;
	}
	else if (l >= 'A' && l <= 'F')
	{
		l = l - 'A' + 0xa;
	}
	else
	{
		return FALSE;
	}
	if (h >= '0' && h <= '9')
	{
		h = h - '0';
	}
	else if (h >= 'a' && h <= 'f')
	{
		h = h - 'a' + 0xa;
	}
	else if (h >= 'A' && h <= 'F')
	{
		h = h - 'A' + 0xa;
	}
	else
	{
		return FALSE;
	}
	h <<= 4;
	h |= l;
	*pOutChar = h;
	return TRUE;
}

void CWCHBleDemoDlg::OnEnChangeEditWrite()
{
	// TODO:  如果该控件是 RICHEDIT 控件，它将不
	// 发送此通知，除非重写 CDialogEx::OnInitDialog()
	// 函数并调用 CRichEditCtrl().SetEventMask()，
	// 同时将 ENM_CHANGE 标志“或”运算到掩码中。

	// TODO:  在此添加控件通知处理程序代码
	char tempbuf[1030] = "";
	int lasteditlen = 0;
	UpdateData(TRUE);
	if (((CButton*)GetDlgItem(IDC_CHECK_HEX2))->GetCheck() == 1) {

		int datalen = m_edit_write.GetLength();
		if (datalen > lasteditlen) {
			if (datalen % 3 == 2) {
				m_edit_write += ' ';
				UpdateData(FALSE);
				((CEdit*)GetDlgItem(IDC_EDIT_WRITE))->SetSel(datalen + 1, -1);
			}
			lasteditlen = m_edit_write.GetLength();
		}
		else {

			if ((datalen + 1) % 3 == 0) {
				memcpy(tempbuf, m_edit_write, datalen - 2);
				m_edit_write = "";
				m_edit_write.Format("%s", tempbuf);
				lasteditlen = datalen - 2;
			} else {
				lasteditlen = datalen;
			}
			UpdateData(FALSE);
			((CEdit*)GetDlgItem(IDC_EDIT_WRITE))->SetSel(datalen + 1, -1);
		}
		g_send_len = lasteditlen / 3;
		memcpy(tempbuf, m_edit_write, m_edit_write.GetLength());
		memset(g_send_char, 0, sizeof(g_send_char));
		for (int i = 0; i < g_send_len; ++i) {
			CharToHex(tempbuf + i * 3, &g_send_char[i]);
		}
	} else {
		g_send_len = m_edit_write.GetLength();
		if (g_send_len > 1024) {
			MessageBox("输入请不要超过1024字节！", "WCHBleDemo", MB_ICONWARNING);
			memset(g_send_char, 0, sizeof(g_send_char));
			memcpy(g_send_char, m_edit_write, 1024);
			g_send_len = 1024;
			GetDlgItem(IDC_EDIT_WRITE)->SetWindowText(g_send_char);
			OutputDebugString(g_send_char);
		} else {
			memset(g_send_char, 0, sizeof(g_send_char));
			memcpy(g_send_char, m_edit_write, g_send_len);
		}

	}
}


void CWCHBleDemoDlg::OnBnClickedButtonVersion()
{
	// TODO: 在此添加控件通知处理程序代码
	UCHAR Version = 0;
	Version = WCHBLEGetBluetoothVer();
	switch (Version) {
	case 0:
		MessageBox("控制器版本为1.0", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 1:
		MessageBox("控制器版本为1.1", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 2:
		MessageBox("控制器版本为1.2", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 3:
		MessageBox("控制器版本为2.0", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 4:
		MessageBox("控制器版本为2.1", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 5:
		MessageBox("控制器版本为3.0", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 6:
		MessageBox("控制器版本为4.0", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 7:
		MessageBox("控制器版本为4.1", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 8:
		MessageBox("控制器版本为4.2", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 9:
		MessageBox("控制器版本为5.0", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 10:
		MessageBox("控制器版本为5.1", "WCHBleDemo", MB_ICONASTERISK);
		break;
	case 11:
		MessageBox("控制器版本为5.2", "WCHBleDemo", MB_ICONASTERISK);
		break;
	}
}