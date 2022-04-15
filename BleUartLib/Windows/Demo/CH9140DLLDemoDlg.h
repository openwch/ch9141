// CH9140DLLDemoDlg.h : ͷ�ļ�
//

#pragma once
#include "afxwin.h"
#include "afxcmn.h"


// CCH9140DLLDemoDlg �Ի���
class CCH9140DLLDemoDlg : public CDialog
{
// ����
public:
	CCH9140DLLDemoDlg(CWnd* pParent = NULL);	// ��׼���캯��

// �Ի�������
	enum { IDD = IDD_CH9140DLLDEMO_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV ֧��


// ʵ��
protected:
	HICON m_hIcon;

	// ���ɵ���Ϣӳ�亯��
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	CComboBox m_combo_buad;
	CComboBox m_combo_data;
	CComboBox m_combo_stop;
	CComboBox m_combo_check;
	CListCtrl m_list_dev;
	CString m_edit_write;
	CString m_edit_read;
	CString m_edit_readhex;
	afx_msg void OnBnClickedButtonVersion();
	afx_msg void OnBnClickedButtonScandev();
	afx_msg void OnBnClickedButtonOpendev();
	afx_msg void OnBnClickedButtonSetcom();
	afx_msg void OnBnClickedButtonClrread();
	afx_msg void OnBnClickedButtonClrsend();
	afx_msg void OnBnClickedButtonSend();
	afx_msg void OnEnChangeEditWrite();
	
	BOOL CharToHex(CHAR* pInChar, CHAR* pOutChar);
	CString CCH9140DLLDemoDlg::Char2Hex(char* pdata, int length);
	afx_msg void OnBnClickedCheckFlowctrl();
	afx_msg void OnBnClickedCheckDtr();
	afx_msg void OnBnClickedCheckRts();
	afx_msg void OnBnClickedCheckHexrecv();
	afx_msg void OnBnClickedCheckHexsend();
};
