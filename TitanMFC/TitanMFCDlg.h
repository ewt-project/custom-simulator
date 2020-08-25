
// TitanMFCDlg.h : header file
//

#pragma once

#define TITAN_AVAILABLE
#ifdef TITAN_AVAILABLE


#include <Titan/sim.h>
#include "afxwin.h"
typedef std::vector<Vec> VecArray;
typedef std::vector<Mass*> MassArray;
typedef std::vector<Spring> SpringArray;
#endif


// CTitanMFCDlg dialog
class CTitanMFCDlg : public CDialogEx
{
	// Construction
public:
	CTitanMFCDlg(CWnd* pParent = NULL);	// standard constructor

										// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_TITANMFC_DIALOG };
#endif

protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support

	Simulation sim; // create the basic simulation object.
	void GenerateYeeModel();
	void GenerateBCCLattice(double massValue, double distanceBetweenMasses, const long stacks, const long columns, const long rows);
	void GenerateBCCLattice2(double massValue, double distanceBetweenMasses, const long stacks, const long columns, const long rows);
	//void AddSprings(double distanceBetweenMasses, double maxSpringLength);
	void AddSprings(double distanceBetweenMasses, double maxSpringLength, double springConstantCenter, double springConstantVertex);
	long FindCenterMass();
	void FindOuterMasses(double distanceBetweenMasses, Vec color);
	void FindInnerMasses(double minDistance, Vec color);

	bool m_isThreadRunning;
	bool m_isThreadPaused;
	bool m_stopThisCrazyThing;
	bool m_removeContainer;
	bool m_simulationDone;
	void ShutDown();
	void CleanUpContainer();

	//==================================================================================================================================
	//Given the start of a line and the end of a line, this extends the line by a certain factor.
	//Return: A point representing the new end of the line. 
	//==================================================================================================================================

	Vec extend_line(Vec ptBegin, Vec ptEnd, float factor)
	{
		Vec ptOut;
		ptOut[0] = ptBegin[0] + (ptEnd[0] - ptBegin[0]) * factor;
		ptOut[1] = ptBegin[1] + (ptEnd[1] - ptBegin[1]) * factor;
		ptOut[2] = ptBegin[2] + (ptEnd[2] - ptBegin[2]) * factor;

		return ptOut;
	}

	bool m_cameraChanged;
	bool m_constrainMassPositions;

	double GetMaxRadius(long latticeDimension, double distanceBetweenMasses);
	double GetMinRadius(long latticeDimension, double distanceBetweenMasses);

	void SetXCameraAngle(double angle);
	void SetYCameraAngle(double angle);
	void SetZCameraAngle(double angle);
	void WriteToFile(std::string filePath, std::string text);
	Container* container;

	//test random
	void TestRandomMasses();
	double GetRandomValue(double factor);

	bool m_wiggle;

	//thread stuff
	CWinThread*			m_thread;
	static UINT		    threadFunction(LPVOID pParam);

public:
	double minX, maxX, minY, maxY, minZ, maxZ;
	bool firstTimeIn;

	long m_latticeDimension;
	double m_cameraXAngle;
	double m_cameraYAngle;
	double m_cameraZAngle;


#ifdef TEST_TITAN_AVAILABLE


	Lattice * l1;
	VecArray g_vecArray;
	void MakeYeeLattice();
	void TestConstraints();
	long IsOnList(double x, double y, double z, double minDistance);
	void CreateSpringMasses(Vec center, double offset);




	Vec m_cameraPosition;
	Vec m_cameraLocation;
	Vec m_cameraNormal;

	long m_massCount;
	double m_red;
	double m_green;
	double m_blue;
#endif


	// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedStart();
	afx_msg void OnDeltaposSpin1(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnDeltaposSpin2(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnDeltaposSpin3(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnBnClickedStart2();
	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedWiggle();
	CStatic m_wiggleText;
	CButton m_StartButton;
	afx_msg void OnBnClickedButton2();
};
