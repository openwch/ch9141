// CH9140DLLDemoDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "afxmt.h"
#include "CH9140DLLDemo.h"
#include "CH9140DLLDemoDlg.h"
#include "CH9140DLL.h"
#pragma comment (lib,"CH9140DLL.lib")


#ifdef _DEBUG
#define new DEBUG_NEW
#endif

//全局变量区
#define MESSAGEBOX_TITLE	"CH9140DLLDemo"	  // messagebox标题

CWnd* MainDlg = NULL;
BLENameDevID g_BLEDev[MAX_PATH];
CH9140HANDLE g_DevHandle;
char g_BlePath[100] = "";
char g_BleName[100] = "";
int g_MTU = 0;
CMutex g_BleRecvCmutex;
HANDLE g_RecvEvent = NULL;
char g_BleRecvData[102400] = "";
char g_RecvCopyBuf[102400] = "";
int g_BleRecvLen = 0;
char g_TransBuf[102400] = "";
char g_send_char[1030] = "";
int g_send_len = 0;

DWORD WINAPI BleRxThread(LPVOID lpparam);

// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// 对话框数据
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CCH9140DLLDemoDlg 对话框




CCH9140DLLDemoDlg::CCH9140DLLDemoDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CCH9140DLLDemoDlg::IDD, pParent)
	, m_edit_write(_T(""))
	, m_edit_read(_T(""))
	, m_edit_readhex(_T(""))
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	MainDlg = (CWnd*)this;
}

void CCH9140DLLDemoDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_BUAD, m_combo_buad);
	DDX_Control(pDX, IDC_COMBO_DATA, m_combo_data);
	DDX_Control(pDX, IDC_COMBO_STOP, m_combo_stop);
	DDX_Control(pDX, IDC_COMBO_CHECK, m_combo_check);
	DDX_Control(pDX, IDC_LIST_DEV, m_list_dev);
	DDX_Text(pDX, IDC_EDIT_WRITE, m_edit_write);
	DDX_Text(pDX, IDC_EDIT_READ, m_edit_read);
	DDX_Text(pDX, IDC_EDIT_READHEX, m_edit_readhex);
}

BEGIN_MESSAGE_MAP(CCH9140DLLDemoDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON_VERSION, &CCH9140DLLDemoDlg::OnBnClickedButtonVersion)
	ON_BN_CLICKED(IDC_BUTTON_SCANDEV, &CCH9140DLLDemoDlg::OnBnClickedButtonScandev)
	ON_BN_CLICKED(IDC_BUTTON_OPENDEV, &CCH9140DLLDemoDlg::OnBnClickedButtonOpendev)
	ON_BN_CLICKED(IDC_BUTTON_SETCOM, &CCH9140DLLDemoDlg::OnBnClickedButtonSetcom)
	ON_BN_CLICKED(IDC_BUTTON_CLRREAD, &CCH9140DLLDemoDlg::OnBnClickedButtonClrread)
	ON_BN_CLICKED(IDC_BUTTON_CLRSEND, &CCH9140DLLDemoDlg::OnBnClickedButtonClrsend)
	ON_BN_CLICKED(IDC_BUTTON_SEND, &CCH9140DLLDemoDlg::OnBnClickedButtonSend)
	ON_EN_CHANGE(IDC_EDIT_WRITE, &CCH9140DLLDemoDlg::OnEnChangeEditWrite)
	ON_BN_CLICKED(IDC_CHECK_FLOWCTRL, &CCH9140DLLDemoDlg::OnBnClickedCheckFlowctrl)
	ON_BN_CLICKED(IDC_CHECK_DTR, &CCH9140DLLDemoDlg::OnBnClickedCheckDtr)
	ON_BN_CLICKED(IDC_CHECK_RTS, &CCH9140DLLDemoDlg::OnBnClickedCheckRts)
	ON_BN_CLICKED(IDC_CHECK_HEXRECV, &CCH9140DLLDemoDlg::OnBnClickedCheckHexrecv)
	ON_BN_CLICKED(IDC_CHECK_HEXSEND, &CCH9140DLLDemoDlg::OnBnClickedCheckHexsend)
END_MESSAGE_MAP()


// CCH9140DLLDemoDlg 消息处理程序

BOOL CCH9140DLLDemoDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
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
	m_list_dev.InsertColumn(2, _T("Mac地址"), LVCFMT_CENTER, rect.Width() / 6 + 20, 1);
	m_list_dev.InsertColumn(3, _T("详细信息"), LVCFMT_CENTER, rect.Width() / 3 * 2 - 20, 2);

	CH9140Init();

	SendDlgItemMessage(IDC_EDIT_READ, EM_LIMITTEXT, 0xFFFFFFFF, 0);

	g_RecvEvent = CreateEvent(NULL, FALSE, FALSE, NULL);
	CloseHandle(CreateThread(NULL, 0, BleRxThread, this, 0, NULL));			//创建蓝牙接收文件线程

	Support = CH9140IsBluetoothOpened();
	if (!Support) {
		MessageBox("请打开系统蓝牙以确保正常使用！", MESSAGEBOX_TITLE, MB_ICONERROR);
	}

	m_combo_buad.AddString(_T("1200"));
	m_combo_buad.AddString(_T("2400"));
	m_combo_buad.AddString(_T("4800"));
	m_combo_buad.AddString(_T("9600"));
	m_combo_buad.AddString(_T("14400"));
	m_combo_buad.AddString(_T("19200"));
	m_combo_buad.AddString(_T("38400"));
	m_combo_buad.AddString(_T("57600"));
	m_combo_buad.AddString(_T("115200"));
	m_combo_buad.AddString(_T("230400"));
	m_combo_buad.AddString(_T("1000000"));
	m_combo_buad.SetCurSel(8);

	m_combo_stop.AddString(_T("1"));
	m_combo_stop.AddString(_T("2"));
	m_combo_stop.SetCurSel(0);

	m_combo_check.AddString(_T("无"));
	m_combo_check.AddString(_T("奇校验"));
	m_combo_check.AddString(_T("偶校验"));
	m_combo_check.AddString(_T("标志位"));
	m_combo_check.AddString(_T("空白位"));
	m_combo_check.SetCurSel(0);

	m_combo_data.AddString(_T("5"));
	m_combo_data.AddString(_T("6"));
	m_combo_data.AddString(_T("7"));
	m_combo_data.AddString(_T("8"));
	m_combo_data.SetCurSel(3);

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CCH9140DLLDemoDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CCH9140DLLDemoDlg::OnPaint()
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
		CDialog::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CCH9140DLLDemoDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

VOID CALLBACK FunDevConnChange(void* hDev, UCHAR ConnectStatus)
{
	CCH9140DLLDemoDlg* pDlg = (CCH9140DLLDemoDlg*)MainDlg;

	if (ConnectStatus == 0) {
		pDlg->GetDlgItem(IDC_BUTTON_SETCOM)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_CHECK_FLOWCTRL)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_BUTTON_SEND)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_CHECK_RTS)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_CHECK_DTR)->EnableWindow(FALSE);
		pDlg->GetDlgItem(IDC_LIST_DEV)->EnableWindow(TRUE);
		pDlg->GetDlgItem(IDC_BUTTON_OPENDEV)->SetWindowText("打开设备");
	}
}

VOID CALLBACK FunRecvModemCallBack(void* hDev, BOOL DCD,BOOL RI, BOOL DSR, BOOL CTS)
{
	CCH9140DLLDemoDlg* pDlg = (CCH9140DLLDemoDlg*)MainDlg;

	((CButton*)pDlg->GetDlgItem(IDC_CHECK_CTS))->SetCheck(CTS);
	((CButton*)pDlg->GetDlgItem(IDC_CHECK_DSR))->SetCheck(DSR);
	((CButton*)pDlg->GetDlgItem(IDC_CHECK_RING))->SetCheck(RI);
	((CButton*)pDlg->GetDlgItem(IDC_CHECK_DCD))->SetCheck(DCD);
}

/*BLE read回调函数*/
VOID CALLBACK FunReadCallBack(void* ParamInf, PCHAR ReadBuf, ULONG ReadBufLen)
{
	g_BleRecvCmutex.Lock();
	memcpy(&g_BleRecvData[g_BleRecvLen], ReadBuf, ReadBufLen);
	g_BleRecvLen += ReadBufLen;
	g_BleRecvCmutex.Unlock();
	SetEvent(g_RecvEvent);

}

/*
接收线程
接收线程一直都在，在没有接收的时候会等待事件触发
*/
DWORD WINAPI BleRxThread(LPVOID lpparam)
{
	CCH9140DLLDemoDlg* pDlg = (CCH9140DLLDemoDlg*)MainDlg;
	DWORD RecvLen = 0;
	CString TempString = "";

	while (1) {
		WaitForSingleObject(g_RecvEvent, INFINITE);
		g_BleRecvCmutex.Lock();
		memset(g_RecvCopyBuf, 0, sizeof(g_RecvCopyBuf));
		memcpy(g_RecvCopyBuf, g_BleRecvData, g_BleRecvLen);
		memset(g_BleRecvData, 0, g_BleRecvLen);
		RecvLen = g_BleRecvLen;
		g_BleRecvLen = 0;
		g_BleRecvCmutex.Unlock();

		SendDlgItemMessage(MainDlg->m_hWnd, IDC_EDIT_READ, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
		SendDlgItemMessage(MainDlg->m_hWnd, IDC_EDIT_READ, EM_REPLACESEL, 0, (LPARAM)g_RecvCopyBuf);
		SendDlgItemMessage(MainDlg->m_hWnd, IDC_EDIT_READ, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);

		TempString = "";
		TempString = pDlg->Char2Hex(g_RecvCopyBuf, RecvLen);
		memset(g_TransBuf, 0, sizeof(g_TransBuf));
		memcpy(g_TransBuf, TempString, TempString.GetLength());
		SendDlgItemMessage(MainDlg->m_hWnd, IDC_EDIT_READHEX, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
		SendDlgItemMessage(MainDlg->m_hWnd, IDC_EDIT_READHEX, EM_REPLACESEL, 0, (LPARAM)g_TransBuf);
		SendDlgItemMessage(MainDlg->m_hWnd, IDC_EDIT_READHEX, EM_SETSEL, 0xFFFFFFFE, 0xFFFFFFFE);
	
	}
	return 0;
}

void CCH9140DLLDemoDlg::OnBnClickedButtonVersion()
{
	// TODO: 在此添加控件通知处理程序代码
	UCHAR Version = 0;
	Version = CH9140GetBluetoothVer();
	switch (Version) {
	case 0:
		MessageBox("控制器版本为1.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 1:
		MessageBox("控制器版本为1.1", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 2:
		MessageBox("控制器版本为1.2", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 3:
		MessageBox("控制器版本为2.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 4:
		MessageBox("控制器版本为2.1", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 5:
		MessageBox("控制器版本为3.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 6:
		MessageBox("控制器版本为4.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 7:
		MessageBox("控制器版本为4.1", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 8:
		MessageBox("控制器版本为4.2", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 9:
		MessageBox("控制器版本为5.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 10:
		MessageBox("控制器版本为5.1", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 11:
		MessageBox("控制器版本为5.2", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	}
}

void CCH9140DLLDemoDlg::OnBnClickedButtonScandev()
{
	// TODO: 在此添加控件通知处理程序代码
	int ScanTimes = 1000, ScanNum = 20, ListCount = 0;
	char DevIDFilter[100] = "";
	CHAR BleMac[100] = "";
	PCHAR MacTemp = NULL;

	if (!CH9140IsBluetoothOpened()) {
		MessageBox("请先打开系统蓝牙！", MESSAGEBOX_TITLE, MB_ICONERROR);
		return;
	}

	memset(g_BLEDev, 0, sizeof(g_BLEDev));
	CH9140EnumDevice(ScanTimes, DevIDFilter, g_BLEDev, (ULONG*)&ScanNum);
	m_list_dev.DeleteAllItems();
	for (int i = 0; i < ScanNum; ++i) {
		memcpy(BleMac, g_BLEDev[i].DevID, 100);
		MacTemp = strchr(BleMac, '-');
		m_list_dev.InsertItem(ListCount, (char*)g_BLEDev[i].Name);
		m_list_dev.SetItemText(ListCount, 1, MacTemp + 1);
		m_list_dev.SetItemText(ListCount, 2, (char*)g_BLEDev[i].DevID);
		ListCount++;
	}
}

void CCH9140DLLDemoDlg::OnBnClickedButtonOpendev()
{
	// TODO: 在此添加控件通知处理程序代码
	if (g_DevHandle != NULL) {
		CH9140CloseDevice(g_DevHandle);
		g_DevHandle = NULL;
		GetDlgItem(IDC_BUTTON_OPENDEV)->SetWindowText("打开设备");
		GetDlgItem(IDC_BUTTON_SETCOM)->EnableWindow(FALSE);
		GetDlgItem(IDC_CHECK_FLOWCTRL)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON_SEND)->EnableWindow(FALSE);
		GetDlgItem(IDC_CHECK_RTS)->EnableWindow(FALSE);
		GetDlgItem(IDC_CHECK_DTR)->EnableWindow(FALSE);
		GetDlgItem(IDC_LIST_DEV)->EnableWindow(TRUE);
	} else {
		CString TmpPath = "", TmpName = "";
		POSITION Pos;
		int nItem = 0, Len = 0, TotalItem = 0;

		Pos = m_list_dev.GetFirstSelectedItemPosition(); // 获取选中行
		nItem = m_list_dev.GetNextSelectedItem(Pos);
		TmpPath = m_list_dev.GetItemText(nItem, 2);
		TmpName = m_list_dev.GetItemText(nItem, 0);

		memset(g_BlePath, 0, sizeof(g_BlePath));
		memset(g_BleName, 0, sizeof(g_BleName));
		Len = TmpPath.GetLength();
		memcpy(g_BlePath, TmpPath, Len);
		Len = TmpName.GetLength();
		memcpy(g_BleName, TmpName, Len);

		g_DevHandle = CH9140UartOpenDevice(g_BlePath, FunDevConnChange, FunRecvModemCallBack, FunReadCallBack);
		if (g_DevHandle == NULL) {
			MessageBox("打开设备失败！", MESSAGEBOX_TITLE, MB_ICONWARNING);
			return;
		} else {
			GetDlgItem(IDC_BUTTON_OPENDEV)->SetWindowText("关闭设备");
			GetDlgItem(IDC_BUTTON_SETCOM)->EnableWindow(TRUE);
			GetDlgItem(IDC_CHECK_FLOWCTRL)->EnableWindow(TRUE);
			GetDlgItem(IDC_BUTTON_SEND)->EnableWindow(TRUE);
			GetDlgItem(IDC_LIST_DEV)->EnableWindow(FALSE);
			TotalItem = m_list_dev.GetItemCount();
			for(int i = 0; i < TotalItem; ++i){
				m_list_dev.SetCheck(i, FALSE);
			}
			m_list_dev.SetCheck(nItem, TRUE);
		}
	}
}

void CCH9140DLLDemoDlg::OnBnClickedButtonSetcom()
{
	// TODO: 在此添加控件通知处理程序代码
	int baudRate = 0, dataBit = 0, stopBit = 0;
	int parity = m_combo_check.GetCurSel();

	baudRate = GetDlgItemInt(IDC_COMBO_BUAD);
	dataBit = GetDlgItemInt(IDC_COMBO_DATA);
	stopBit = GetDlgItemInt(IDC_COMBO_STOP);
	if(!CH9140UartSetSerialBaud(g_DevHandle, baudRate, dataBit, stopBit, parity)) {
		MessageBox("设置串口参数失败！", MESSAGEBOX_TITLE, MB_ICONWARNING);
	} else {
		MessageBox("设置串口参数成功！", MESSAGEBOX_TITLE, MB_ICONASTERISK);
	}
}

void CCH9140DLLDemoDlg::OnBnClickedButtonClrread()
{
	// TODO: 在此添加控件通知处理程序代码
	m_edit_read = "";
	SetDlgItemText(IDC_EDIT_READ, m_edit_read);
	SetDlgItemText(IDC_EDIT_READHEX, m_edit_read);
}

void CCH9140DLLDemoDlg::OnBnClickedButtonClrsend()
{
	// TODO: 在此添加控件通知处理程序代码
	m_edit_write = "";
	memset(g_send_char, 0, sizeof(g_send_char));
	g_send_len = 0;
	SetDlgItemText(IDC_EDIT_WRITE, m_edit_write);
}

void CCH9140DLLDemoDlg::OnBnClickedButtonSend()
{
	// TODO: 在此添加控件通知处理程序代码
	int Ret = 0;

	Ret = CH9140UartWriteBuffer(g_DevHandle, g_send_char, g_send_len);
	if (Ret != g_send_len) {
		MessageBox("写入特征值失败！", MESSAGEBOX_TITLE, MB_ICONWARNING);
		return;
	}

}

/********************************************两个字符拼接成十六进制数*************************************************/
BOOL CCH9140DLLDemoDlg::CharToHex(CHAR* pInChar, CHAR* pOutChar)
{
	CHAR h, l;

	if (&pInChar[0] == NULL || &pInChar[1] == NULL) {
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

/*将char型数据转换成16进制的两个字符*/
CString CCH9140DLLDemoDlg::Char2Hex(char* pdata, int length)
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

void CCH9140DLLDemoDlg::OnEnChangeEditWrite()
{
	// TODO:  如果该控件是 RICHEDIT 控件，则它将不会
	// 发送该通知，除非重写 CDialog::OnInitDialog()
	// 函数并调用 CRichEditCtrl().SetEventMask()，
	// 同时将 ENM_CHANGE 标志“或”运算到掩码中。

	// TODO:  在此添加控件通知处理程序代码
	char tempbuf[1030] = "";
	int lasteditlen = 0;
	UpdateData(TRUE);
	if (((CButton*)GetDlgItem(IDC_CHECK_HEXSEND))->GetCheck() == 1) {

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
			MessageBox("输入请不要超过1024字节！", MESSAGEBOX_TITLE, MB_ICONWARNING);
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

void CCH9140DLLDemoDlg::OnBnClickedCheckFlowctrl()
{
	// TODO: 在此添加控件通知处理程序代码
	bool flow = ((CButton*)GetDlgItem(IDC_CHECK_FLOWCTRL))->GetCheck();
	int DTR = ((CButton*)GetDlgItem(IDC_CHECK_DTR))->GetCheck();
	int RTS = ((CButton*)GetDlgItem(IDC_CHECK_RTS))->GetCheck();
	
	if(flow) {
		GetDlgItem(IDC_CHECK_DTR)->EnableWindow(TRUE);
		GetDlgItem(IDC_CHECK_RTS)->EnableWindow(TRUE);
	} else {
		GetDlgItem(IDC_CHECK_DTR)->EnableWindow(FALSE);
		GetDlgItem(IDC_CHECK_RTS)->EnableWindow(FALSE);
	}
	if(!CH9140UartSetSerialModem(g_DevHandle, flow, DTR, RTS)) {
		MessageBox("设置串口流控失败！", MESSAGEBOX_TITLE, MB_ICONWARNING);
	} else {
		MessageBox("设置串口流控成功！", MESSAGEBOX_TITLE, MB_ICONASTERISK);
	}
}

void CCH9140DLLDemoDlg::OnBnClickedCheckDtr()
{
	// TODO: 在此添加控件通知处理程序代码
	bool flow = ((CButton*)GetDlgItem(IDC_CHECK_FLOWCTRL))->GetCheck();
	int DTR = ((CButton*)GetDlgItem(IDC_CHECK_DTR))->GetCheck();
	int RTS = ((CButton*)GetDlgItem(IDC_CHECK_RTS))->GetCheck();
	
	if(!CH9140UartSetSerialModem(g_DevHandle, flow, DTR, RTS)) {
		MessageBox("设置串口流控失败！", MESSAGEBOX_TITLE, MB_ICONWARNING);
	} else {
		MessageBox("设置串口流控成功！", MESSAGEBOX_TITLE, MB_ICONASTERISK);
	}
}

void CCH9140DLLDemoDlg::OnBnClickedCheckRts()
{
	// TODO: 在此添加控件通知处理程序代码
	bool flow = ((CButton*)GetDlgItem(IDC_CHECK_FLOWCTRL))->GetCheck();
	int DTR = ((CButton*)GetDlgItem(IDC_CHECK_DTR))->GetCheck();
	int RTS = ((CButton*)GetDlgItem(IDC_CHECK_RTS))->GetCheck();
	
	if(!CH9140UartSetSerialModem(g_DevHandle, flow, DTR, RTS)) {
		MessageBox("设置串口流控失败！", MESSAGEBOX_TITLE, MB_ICONWARNING);
	} else {
		MessageBox("设置串口流控成功！", MESSAGEBOX_TITLE, MB_ICONASTERISK);
	}
}

void CCH9140DLLDemoDlg::OnBnClickedCheckHexrecv()
{
	// TODO: 在此添加控件通知处理程序代码
	bool Select = ((CButton*)GetDlgItem(IDC_CHECK_HEXRECV))->GetCheck();
	if(Select){
		GetDlgItem(IDC_EDIT_READ)->ShowWindow(SW_HIDE);
		GetDlgItem(IDC_EDIT_READHEX)->ShowWindow(SW_SHOW);
	} else {
		GetDlgItem(IDC_EDIT_READ)->ShowWindow(SW_SHOW);
		GetDlgItem(IDC_EDIT_READHEX)->ShowWindow(SW_HIDE);
	}
}

void CCH9140DLLDemoDlg::OnBnClickedCheckHexsend()
{
	// TODO: 在此添加控件通知处理程序代码
	CString Temp = "";

	if (((CButton*)GetDlgItem(IDC_CHECK_HEXSEND))->GetCheck() == 1) {
		Temp = Char2Hex(g_send_char, g_send_len);
		m_edit_write = Temp;
	} else {
		m_edit_write = g_send_char;
	}

	GetDlgItem(IDC_EDIT_WRITE)->SetWindowText(m_edit_write);
}
