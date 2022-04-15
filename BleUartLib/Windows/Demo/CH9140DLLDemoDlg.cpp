// CH9140DLLDemoDlg.cpp : ʵ���ļ�
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

//ȫ�ֱ�����
#define MESSAGEBOX_TITLE	"CH9140DLLDemo"	  // messagebox����

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

// ����Ӧ�ó��򡰹��ڡ��˵���� CAboutDlg �Ի���

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// �Ի�������
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

// ʵ��
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


// CCH9140DLLDemoDlg �Ի���




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


// CCH9140DLLDemoDlg ��Ϣ�������

BOOL CCH9140DLLDemoDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// ��������...���˵�����ӵ�ϵͳ�˵��С�

	// IDM_ABOUTBOX ������ϵͳ���Χ�ڡ�
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

	// ���ô˶Ի����ͼ�ꡣ��Ӧ�ó��������ڲ��ǶԻ���ʱ����ܽ��Զ�
	//  ִ�д˲���
	SetIcon(m_hIcon, TRUE);			// ���ô�ͼ��
	SetIcon(m_hIcon, FALSE);		// ����Сͼ��

	// TODO: �ڴ���Ӷ���ĳ�ʼ������
	bool Support = FALSE;
	CRect rect;
	// ��ȡ��������б���ͼ�ؼ���λ�úʹ�С   
	m_list_dev.GetClientRect(&rect);
	// Ϊ�б���ͼ�ؼ����ȫ��ѡ�к�դ����   
	m_list_dev.SetExtendedStyle(m_list_dev.GetExtendedStyle() | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES | LVS_EX_CHECKBOXES);
	// Ϊ�б���ͼ�ؼ��������   
	m_list_dev.InsertColumn(1, _T("�豸"), LVCFMT_CENTER, rect.Width() / 6, 0);
	m_list_dev.InsertColumn(2, _T("Mac��ַ"), LVCFMT_CENTER, rect.Width() / 6 + 20, 1);
	m_list_dev.InsertColumn(3, _T("��ϸ��Ϣ"), LVCFMT_CENTER, rect.Width() / 3 * 2 - 20, 2);

	CH9140Init();

	SendDlgItemMessage(IDC_EDIT_READ, EM_LIMITTEXT, 0xFFFFFFFF, 0);

	g_RecvEvent = CreateEvent(NULL, FALSE, FALSE, NULL);
	CloseHandle(CreateThread(NULL, 0, BleRxThread, this, 0, NULL));			//�������������ļ��߳�

	Support = CH9140IsBluetoothOpened();
	if (!Support) {
		MessageBox("���ϵͳ������ȷ������ʹ�ã�", MESSAGEBOX_TITLE, MB_ICONERROR);
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

	m_combo_check.AddString(_T("��"));
	m_combo_check.AddString(_T("��У��"));
	m_combo_check.AddString(_T("żУ��"));
	m_combo_check.AddString(_T("��־λ"));
	m_combo_check.AddString(_T("�հ�λ"));
	m_combo_check.SetCurSel(0);

	m_combo_data.AddString(_T("5"));
	m_combo_data.AddString(_T("6"));
	m_combo_data.AddString(_T("7"));
	m_combo_data.AddString(_T("8"));
	m_combo_data.SetCurSel(3);

	return TRUE;  // ���ǽ��������õ��ؼ������򷵻� TRUE
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

// �����Ի��������С����ť������Ҫ����Ĵ���
//  �����Ƹ�ͼ�ꡣ����ʹ���ĵ�/��ͼģ�͵� MFC Ӧ�ó���
//  �⽫�ɿ���Զ���ɡ�

void CCH9140DLLDemoDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // ���ڻ��Ƶ��豸������

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// ʹͼ���ڹ����������о���
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// ����ͼ��
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//���û��϶���С������ʱϵͳ���ô˺���ȡ�ù��
//��ʾ��
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
		pDlg->GetDlgItem(IDC_BUTTON_OPENDEV)->SetWindowText("���豸");
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

/*BLE read�ص�����*/
VOID CALLBACK FunReadCallBack(void* ParamInf, PCHAR ReadBuf, ULONG ReadBufLen)
{
	g_BleRecvCmutex.Lock();
	memcpy(&g_BleRecvData[g_BleRecvLen], ReadBuf, ReadBufLen);
	g_BleRecvLen += ReadBufLen;
	g_BleRecvCmutex.Unlock();
	SetEvent(g_RecvEvent);

}

/*
�����߳�
�����߳�һֱ���ڣ���û�н��յ�ʱ���ȴ��¼�����
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
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	UCHAR Version = 0;
	Version = CH9140GetBluetoothVer();
	switch (Version) {
	case 0:
		MessageBox("�������汾Ϊ1.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 1:
		MessageBox("�������汾Ϊ1.1", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 2:
		MessageBox("�������汾Ϊ1.2", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 3:
		MessageBox("�������汾Ϊ2.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 4:
		MessageBox("�������汾Ϊ2.1", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 5:
		MessageBox("�������汾Ϊ3.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 6:
		MessageBox("�������汾Ϊ4.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 7:
		MessageBox("�������汾Ϊ4.1", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 8:
		MessageBox("�������汾Ϊ4.2", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 9:
		MessageBox("�������汾Ϊ5.0", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 10:
		MessageBox("�������汾Ϊ5.1", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	case 11:
		MessageBox("�������汾Ϊ5.2", MESSAGEBOX_TITLE, MB_ICONASTERISK);
		break;
	}
}

void CCH9140DLLDemoDlg::OnBnClickedButtonScandev()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	int ScanTimes = 1000, ScanNum = 20, ListCount = 0;
	char DevIDFilter[100] = "";
	CHAR BleMac[100] = "";
	PCHAR MacTemp = NULL;

	if (!CH9140IsBluetoothOpened()) {
		MessageBox("���ȴ�ϵͳ������", MESSAGEBOX_TITLE, MB_ICONERROR);
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
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	if (g_DevHandle != NULL) {
		CH9140CloseDevice(g_DevHandle);
		g_DevHandle = NULL;
		GetDlgItem(IDC_BUTTON_OPENDEV)->SetWindowText("���豸");
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

		Pos = m_list_dev.GetFirstSelectedItemPosition(); // ��ȡѡ����
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
			MessageBox("���豸ʧ�ܣ�", MESSAGEBOX_TITLE, MB_ICONWARNING);
			return;
		} else {
			GetDlgItem(IDC_BUTTON_OPENDEV)->SetWindowText("�ر��豸");
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
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	int baudRate = 0, dataBit = 0, stopBit = 0;
	int parity = m_combo_check.GetCurSel();

	baudRate = GetDlgItemInt(IDC_COMBO_BUAD);
	dataBit = GetDlgItemInt(IDC_COMBO_DATA);
	stopBit = GetDlgItemInt(IDC_COMBO_STOP);
	if(!CH9140UartSetSerialBaud(g_DevHandle, baudRate, dataBit, stopBit, parity)) {
		MessageBox("���ô��ڲ���ʧ�ܣ�", MESSAGEBOX_TITLE, MB_ICONWARNING);
	} else {
		MessageBox("���ô��ڲ����ɹ���", MESSAGEBOX_TITLE, MB_ICONASTERISK);
	}
}

void CCH9140DLLDemoDlg::OnBnClickedButtonClrread()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	m_edit_read = "";
	SetDlgItemText(IDC_EDIT_READ, m_edit_read);
	SetDlgItemText(IDC_EDIT_READHEX, m_edit_read);
}

void CCH9140DLLDemoDlg::OnBnClickedButtonClrsend()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	m_edit_write = "";
	memset(g_send_char, 0, sizeof(g_send_char));
	g_send_len = 0;
	SetDlgItemText(IDC_EDIT_WRITE, m_edit_write);
}

void CCH9140DLLDemoDlg::OnBnClickedButtonSend()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	int Ret = 0;

	Ret = CH9140UartWriteBuffer(g_DevHandle, g_send_char, g_send_len);
	if (Ret != g_send_len) {
		MessageBox("д������ֵʧ�ܣ�", MESSAGEBOX_TITLE, MB_ICONWARNING);
		return;
	}

}

/********************************************�����ַ�ƴ�ӳ�ʮ��������*************************************************/
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
		h = pInChar[0]; //��4λ
		l = pInChar[1]; //��4λ
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

/*��char������ת����16���Ƶ������ַ�*/
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
	// TODO:  ����ÿؼ��� RICHEDIT �ؼ�������������
	// ���͸�֪ͨ��������д CDialog::OnInitDialog()
	// ���������� CRichEditCtrl().SetEventMask()��
	// ͬʱ�� ENM_CHANGE ��־�������㵽�����С�

	// TODO:  �ڴ���ӿؼ�֪ͨ����������
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
			MessageBox("�����벻Ҫ����1024�ֽڣ�", MESSAGEBOX_TITLE, MB_ICONWARNING);
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
	// TODO: �ڴ���ӿؼ�֪ͨ����������
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
		MessageBox("���ô�������ʧ�ܣ�", MESSAGEBOX_TITLE, MB_ICONWARNING);
	} else {
		MessageBox("���ô������سɹ���", MESSAGEBOX_TITLE, MB_ICONASTERISK);
	}
}

void CCH9140DLLDemoDlg::OnBnClickedCheckDtr()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	bool flow = ((CButton*)GetDlgItem(IDC_CHECK_FLOWCTRL))->GetCheck();
	int DTR = ((CButton*)GetDlgItem(IDC_CHECK_DTR))->GetCheck();
	int RTS = ((CButton*)GetDlgItem(IDC_CHECK_RTS))->GetCheck();
	
	if(!CH9140UartSetSerialModem(g_DevHandle, flow, DTR, RTS)) {
		MessageBox("���ô�������ʧ�ܣ�", MESSAGEBOX_TITLE, MB_ICONWARNING);
	} else {
		MessageBox("���ô������سɹ���", MESSAGEBOX_TITLE, MB_ICONASTERISK);
	}
}

void CCH9140DLLDemoDlg::OnBnClickedCheckRts()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	bool flow = ((CButton*)GetDlgItem(IDC_CHECK_FLOWCTRL))->GetCheck();
	int DTR = ((CButton*)GetDlgItem(IDC_CHECK_DTR))->GetCheck();
	int RTS = ((CButton*)GetDlgItem(IDC_CHECK_RTS))->GetCheck();
	
	if(!CH9140UartSetSerialModem(g_DevHandle, flow, DTR, RTS)) {
		MessageBox("���ô�������ʧ�ܣ�", MESSAGEBOX_TITLE, MB_ICONWARNING);
	} else {
		MessageBox("���ô������سɹ���", MESSAGEBOX_TITLE, MB_ICONASTERISK);
	}
}

void CCH9140DLLDemoDlg::OnBnClickedCheckHexrecv()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
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
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	CString Temp = "";

	if (((CButton*)GetDlgItem(IDC_CHECK_HEXSEND))->GetCheck() == 1) {
		Temp = Char2Hex(g_send_char, g_send_len);
		m_edit_write = Temp;
	} else {
		m_edit_write = g_send_char;
	}

	GetDlgItem(IDC_EDIT_WRITE)->SetWindowText(m_edit_write);
}
