
// WCHBleDemoDlg.h: 头文件
//

#pragma once

#pragma comment (lib,"WCHBLEDLL.lib")

// CWCHBleDemoDlg 对话框
class CWCHBleDemoDlg : public CDialogEx
{
// 构造
public:
	CWCHBleDemoDlg(CWnd* pParent = nullptr);	// 标准构造函数

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_WCHBLEDEMO_DIALOG };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButtonScandev();
	afx_msg void OnBnClickedButtonOpendev();
	afx_msg void OnBnClickedButtonGetservice();
	afx_msg void OnBnClickedButtonGetfeature();
	afx_msg void OnBnClickedButtonGetaction();
	afx_msg void OnBnClickedButtonNotify();
	afx_msg void OnBnClickedButtonRead();
	afx_msg void OnBnClickedButtonWrite();
	afx_msg void OnBnClickedButtonClrread();
	afx_msg void OnBnClickedButtonClrwrite();
	afx_msg void OnCbnSelchangeComboFeature();
	CListCtrl m_list_dev;
	CComboBox m_combo_service;
	CComboBox m_combo_feature;

	CString m_edit_write;
	CString m_edit_read;
	afx_msg void OnCbnSelchangeComboService();
	afx_msg void OnBnClickedCheckHex();
	afx_msg void OnBnClickedCheckHex2();
	CString Char2Hex(char* pdata, int length);
	afx_msg void OnEnChangeEditWrite();
	BOOL CharToHex(CHAR* pInChar, CHAR* pOutChar);
	afx_msg void OnBnClickedButtonVersion();
};
