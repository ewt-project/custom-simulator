
// TitanMFCDlg.cpp : implementation file
//

#include "stdafx.h"
#include "TitanMFC.h"
#include "TitanMFCDlg.h"
#include "afxdialogex.h"
#include <iostream>
#include <sstream>
#include <fstream>
#include "windows.h"

//#include "RRI_SlicerInterface.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CTitanMFCDlg dialog



CTitanMFCDlg::CTitanMFCDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(IDD_TITANMFC_DIALOG, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);

	m_cameraChanged = false;
}

void CTitanMFCDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_WIGGLE_TEXT, m_wiggleText);
	DDX_Control(pDX, IDC_START, m_StartButton);
}

BEGIN_MESSAGE_MAP(CTitanMFCDlg, CDialogEx)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_START, &CTitanMFCDlg::OnBnClickedStart)
	ON_NOTIFY(UDN_DELTAPOS, IDC_SPIN1, &CTitanMFCDlg::OnDeltaposSpin1)
	ON_NOTIFY(UDN_DELTAPOS, IDC_SPIN2, &CTitanMFCDlg::OnDeltaposSpin2)
	ON_NOTIFY(UDN_DELTAPOS, IDC_SPIN3, &CTitanMFCDlg::OnDeltaposSpin3)
	ON_BN_CLICKED(IDCANCEL, &CTitanMFCDlg::OnBnClickedCancel)
	ON_BN_CLICKED(IDC_WIGGLE, &CTitanMFCDlg::OnBnClickedWiggle)
	ON_BN_CLICKED(IDC_BUTTON2, &CTitanMFCDlg::OnBnClickedButton2)
END_MESSAGE_MAP()


// CTitanMFCDlg message handlers

BOOL CTitanMFCDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

									// TODO: Add extra initialization here
	m_cameraXAngle = 0;
	m_cameraYAngle = 0;
	m_cameraZAngle = 0;

	m_isThreadRunning = false;
	m_isThreadPaused = false;
	m_stopThisCrazyThing = false;//initially stopped
	m_removeContainer = false;

	//create container to contain the masses

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CTitanMFCDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//**********************************************************************************************************
//MAIN
//**********************************************************************************************************
void CTitanMFCDlg::GenerateYeeModel()
{
	
	sim.reset();

	srand(time(NULL));

	Vec yellow = Vec(1.0, 1.0, 0.0);
	Vec red = Vec(1, 0, 0);
	Vec black = Vec(0, 0, 0);
	Vec purple = Vec(1, 0, 1);


	//=================================================================================================
	//parameters to change
	//=================================================================================================
	//enable this if you want to see the expansion but not "wiggle" the lattice

	//lattice parameters
	long latticeDimension = 10;
		long row = latticeDimension;
		long column = latticeDimension;
		long stacks = latticeDimension;

	Vec fixedMassColour = red;

	//mass parameters and spring
	double distanceBetweenMasses = 2.718 * 2;//[m]
	double granuleMass =  1.0;//[Kg]
	double waveCenterMass = 1836 * granuleMass;//[Kg]
	double springConstantVertex =  1.66e3;//spring parameters
	double springConstantCenter =  1.91e3;//

	//This parameter determines which masses get hooked up to each other.
	//if you set this to 1.0, it will hook up only the center masses.
	//if you set this to 1.1, it will hoop up the edges too.
	double springLengthFactor = 1.1;//1.0
	double maxSpringLength = distanceBetweenMasses * springLengthFactor;
	
	//time parameters
	double timeDelta = 0.001;//simulation time for each mass
	double extensionFactor = 1.1;// 1.618;//
	double zoomFactor = 1.0;

	
	//==============================================================================================
	//Reset Viewport
	//==============================================================================================
	

	double cameraPos = 50;// (double)latticeDimension * distanceBetweenMasses / zoomFactor;
	//Change these to change change default viewport
	Vec axis = Vec(0, 1, 0);
	Vec position(40, 40, 40);
	//reset viewport/camera to point to the lattice

#ifdef GRAPHICS
	sim.setViewport(Vec(cameraPos, cameraPos, cameraPos), position, axis);
#endif
	//==============================================================================================


	//Generate a BCC lattice of masses with dimensions
	GenerateBCCLattice(granuleMass, distanceBetweenMasses, stacks, column, row);


#define FIND_OUTER_MASSES
#ifdef FIND_OUTER_MASSES
	double outerFactor = 2.2;
	double maxDistance = distanceBetweenMasses * latticeDimension / outerFactor;
	FindOuterMasses(maxDistance, fixedMassColour);
#endif


	long numberOfMasses = container->masses.size();


//#define SELECT_WAVE_CENTER_MASS
#ifdef SELECT_WAVE_CENTER_MASS

	long waveCenterIndex = FindCenterMass();

	bool selectRandomWaveCenter = true;//set this to true for random wavecenter

	for (int i = 0; i < 5; i++)
	{
		waveCenterIndex = rand() % numberOfMasses;

		Mass* fixMass = container->masses.at(waveCenterIndex);
		fixMass->m = waveCenterMass;
		fixMass->color = Vec(0, 1, 1);//acqa colour
	}

#endif


#define ADD_SPRINGS
#ifdef ADD_SPRINGS
	//Hook up the masses to springs
	AddSprings(distanceBetweenMasses, maxSpringLength, springConstantCenter, springConstantVertex);//connect up masses that are close to each other
	sim.defaultRestLength();
#endif	



	sim.setAllDeltaTValues(timeDelta); //Set Simulation Time resolution [s] for eeah mass


	sim.setGlobalAcceleration(Vec(0, 0, 0));


	long count = -1;
	bool firstTimeIn = true;


	sim.start();
	double motionAngle = 0.0;
	double phaseAngleInc = 0.01;


	bool pull = false;
	while (!m_stopThisCrazyThing)    //while (sim.time() < 100.0)	
	{
		motionAngle += phaseAngleInc;

		sim.pause(sim.time() + 0.01);
		//sim.pause(sim.time() + 1.0);

		sim.getAll();

		container->rotate(Vec(1,0,0) , m_cameraXAngle);
		container->rotate(Vec(0, 1, 0), m_cameraYAngle);
		container->rotate(Vec(0, 0, 1), m_cameraZAngle);
		m_cameraXAngle = 0;
		m_cameraYAngle = 0;
		m_cameraZAngle = 0;


		//currently, this chunk of code is only executed once
		if (m_wiggle)
		{

			count++;

			if (count == 20)
			{
				count = 0;
				//reverse push and pull
				if (pull)
				{
					pull = false;
				}
				else
				{
					pull = true;
				}
			}

			for (int i = 0; i < numberOfMasses; i++)
			{
				Mass* mass = container->masses.at(i);
				Vec location = mass->pos;

				//only wiggle the red ones
				if (mass->color == fixedMassColour)
				{


#define EXPAND_LATTICE
#ifdef EXPAND_LATTICE
					Vec origin = Vec(0, 0, 0);

					Vec extendedPoint;
					if (pull)
					{

						extendedPoint = extend_line(origin, location, 1.0 + phaseAngleInc);//extend out
							
					}
					else
					{
						extendedPoint = extend_line(origin, location, 1.0 - phaseAngleInc);//extend in
					}


					mass->pos[0] = extendedPoint[0];
					mass->pos[1] = extendedPoint[1];
					mass->pos[2] = extendedPoint[2];

					//mass->m = waveCenterMass;//set mass to a much heavier mass
#endif

					//#define EXPAND_LATTICE
//#define CIRCULATE_POINTS
#ifdef CIRCULATE_POINTS
						

					Vec newPosition;
					mass->pos[0] = newPosition[0];
					mass->pos[1] = newPosition[1];
					mass->pos[2] = newPosition[2];

					//mass->m = waveCenterMass;//set mass to a much heavier mass
#endif
						

				}

			}


			
			long numberOfMasses = container->masses.size();
			for (int i = 0; i < numberOfMasses; i++)
			{
				Mass* mass = container->masses.at(i);
	
			}

			sim.setAll();
			sim.resume();

			//Sleep(5);//give up the CPU for other processes

		}
	}


	sim.stop();


	Sleep(100);//wait a bit then shutdown 

	m_isThreadRunning = false;
}

/*bool pull = false;
	while (!m_stopThisCrazyThing)    //while (sim.time() < 100.0)	
	{
		motionAngle += phaseAngleInc;

		sim.pause(sim.time() + 0.01);
		//sim.pause(sim.time() + 1.0);

		sim.getAll();


		//currently, this chunk of code is only executed once
		if (m_wiggle)
		{

			count++;

			if (count % 2 == 0)
			{
				//reverse push and pull
				if (pull)
				{
					pull = false;
				}
				else
				{
					pull = true;
				}

				for (int i = 0; i < numberOfMasses; i++)
				{
					Mass* mass = container->masses.at(i);
					Vec location = mass->pos;

					//only wiggle the red ones
					if (mass->color == fixedMassColour)
					{


#define EXPAND_LATTICE
#ifdef EXPAND_LATTICE
						Vec origin = Vec(0, 0, 0);

						Vec extendedPoint;
						if (pull)
						{

							extendedPoint = extend_line(origin, location, extensionFactor);//extend out
							
						}
						else
						{
							extendedPoint = extend_line(origin, location, 1/extensionFactor);//extend in
						}


						mass->pos[0] = extendedPoint[0];
						mass->pos[1] = extendedPoint[1];
						mass->pos[2] = extendedPoint[2];

						//mass->m = waveCenterMass;//set mass to a much heavier mass
#endif
						

					}

				}

				//firstTimeIn = false;
				//m_wiggle = false;

			}
		


			{
				m_View1.GetSlicer()->ClearBuffer(0);
				long numberOfMasses = container->masses.size();
				for (int i = 0; i < numberOfMasses; i++)
				{
					Mass* mass = container->masses.at(i);
					AddMassToVolume(mass);
				}
			}


			m_View1.Invalidate();



			sim.setAll();
			sim.resume();

			//Sleep(5);//give up the CPU for other processes

		}
	}

*/


/*double valueX = GetRandomValue(wiggleFactor);//returns a value between 1 and -1 * wiggleFactor
		double valueY = GetRandomValue(wiggleFactor);//returns a value between 1 and -1 * wiggleFactor
		double valueZ = GetRandomValue(wiggleFactor);//returns a value between 1 and -1 * wiggleFactor*/
void CTitanMFCDlg::GenerateBCCLattice(double massValue, double distanceBetweenMasses, const long stacks, const long columns, const long rows)
{

	
	Vec yellow = Vec(1.0, 1.0, 0.0);
	Vec red = Vec(1.0, 0, 0);
	Vec green = Vec(0.0, 1.0, 0.0);

	double zSize = (double)stacks * distanceBetweenMasses;
	double ySize = (double)columns * distanceBetweenMasses;
	double xSize = (double)rows * distanceBetweenMasses;

	double zStart = -zSize / 2.0;
	double yStart = -ySize / 2.0;
	double xStart = -xSize / 2.0;

	double maxDistance = distanceBetweenMasses * columns/2;


	double posZ = zStart;


#define DO_FIRST_HALF
#ifdef DO_FIRST_HALF

	posZ = zStart + distanceBetweenMasses / 2.0;
	for (int z = 0; z < stacks; z++)
	{
		double posY = yStart + distanceBetweenMasses /2.0;

		for (int y = 0; y < columns; y++)
		{
			double posX = xStart + distanceBetweenMasses/2.0;
			for (int x = 0; x < rows; x++)
			{
				double distance = sqrt((posX)*(posX) + (posY*posY) + (posZ)*(posZ));
				if (distance < maxDistance)
				{

					Mass* mass = sim.createMass(Vec(posX, posY, posZ));
					mass->color = yellow;
					mass->m = massValue;//[kg]

					container->add(mass);

				}

				posX += distanceBetweenMasses;
			}

			posY += distanceBetweenMasses;
		}

		posZ += distanceBetweenMasses;
	}
#endif

//#define ADD_CENTER_MASS
#ifdef ADD_CENTER_MASS
	Mass* mass2 = sim.createMass(Vec(0, 0, 0));
	mass2->color = red;
	mass2->m = massValue;//[kg]
#endif

	
#define DO_SECOND_HALF
#ifdef DO_SECOND_HALF
	//generate Red masses between the yellow masses
	posZ = zStart + distanceBetweenMasses;
	 
	for (int z = 0; z < stacks - 1; z++)
	{
		double posY = yStart + distanceBetweenMasses;

		for (int y = 0; y < columns - 1; y++)
		{
			double posX = xStart + distanceBetweenMasses;
			for (int x = 0; x < rows - 1; x++)
			{

				double distance = sqrt((posX)*(posX)  +  (posY*posY) + (posZ)*(posZ));
				//only add mass within a certain radius
				if (distance < maxDistance)
				{
					double red = 1.0;// abs(GetRandomValue(1));
					double green = 1.0;// abs(GetRandomValue(1));
					double blue = 0;// abs(GetRandomValue(1));

					Mass* mass = sim.createMass(Vec(posX, posY, posZ));
					mass->color = Vec(red, green, blue);
					mass->m = massValue;//[kg]

					
					container->add(mass);
					
				}

				posX += distanceBetweenMasses;
			}

			posY += distanceBetweenMasses;
		}

		posZ += distanceBetweenMasses;
	}
#endif


#define FIND_CENTER_MASS
#ifdef FIND_CENTER_MASS

	//colour the center mass red
	long centerMassIndex = FindCenterMass();
	Mass* centerMass = container->masses[centerMassIndex];
	centerMass->color = Vec(1, 0, 0);

#endif

}


//#define WRITE_MASSES_TO_FILE
#ifdef WRITE_MASSES_TO_FILE
char outstring[100];
std::fstream dFile = std::fstream("c:/Scans/Masses.txt", std::ios::out | std::ios::binary);
#endif




#ifdef WRITE_MASSES_TO_FILE
//write to file
CString output;
output.Format("%3.5lf %3.5lf $3.5lf\n", posX, posY, posZ);
dFile.write(output.GetString(), output.GetLength());
#endif

void CTitanMFCDlg::AddSprings(double distanceBetweenMasses, double maxSpringLength, double springConstantCenter, double springConstantVertex)
{
	long numberOfMasses = container->masses.size();
	for (int i = 0; i < numberOfMasses; i++)
	{
		Mass* mass1 = container->masses.at(i);

		for (int j = i; j < numberOfMasses; j++)
		{
			Mass* mass2 = container->masses.at(j);

			//calcuate the distance between masses
			double lengthX = mass1->pos[0] - mass2->pos[0];
			double lengthY = mass1->pos[1] - mass2->pos[1];
			double lengthZ = mass1->pos[2] - mass2->pos[2];
			double distance = sqrt(lengthX*lengthX + lengthY*lengthY + lengthZ*lengthZ);

			if (mass1 != mass2)//only hook up masses that are different
			{
				if (distance <  maxSpringLength)  //only hook up masses that are adjacent to each other
				{

					//spring->changeType(PASSIVE_SOFT, 0.0);
					//enum SpringType {PASSIVE_SOFT, PASSIVE_STIFF, ACTIVE_CONTRACT_THEN_EXPAND, ACTIVE_EXPAND_THEN_CONTRACT};

					Spring* spring = sim.createSpring(mass1, mass2);
					if (distance < distanceBetweenMasses)
					{
						
						spring->_k = springConstantCenter;
					}
					else
					{
						spring->_k = springConstantVertex;
					}
					
					

					container->add(spring);
				}
			}
		}
	}

}

void CTitanMFCDlg::WriteToFile(std::string filePath, std::string text)
{

	char outstring[100];
	sprintf_s(outstring, "%s\n", text);

	std::fstream dFile = std::fstream(filePath.c_str(), std::ios::out | std::ios::binary);
	dFile.seekg(0, std::ios_base::end);

	dFile.close();

}

void CTitanMFCDlg::FindOuterMasses(double maxDistance, Vec color)
{
	//find center mass
	long numberOfMasses = container->masses.size();
	for (int i = 0; i < numberOfMasses; i++)
	{
		Mass* mass = container->masses.at(i);
		double distance = sqrt(mass->pos[0] * mass->pos[0] + mass->pos[1] * mass->pos[1] + mass->pos[2] * mass->pos[2]);
		
		if (distance > maxDistance)
		{
			mass->color = color;
			mass->fix();
		}
	}
}

void CTitanMFCDlg::FindInnerMasses(double minDistance, Vec color)
{
	//find center mass
	long numberOfMasses = container->masses.size();
	for (int i = 0; i < numberOfMasses; i++)
	{
		Mass* mass = container->masses.at(i);
		double distance = sqrt(mass->pos[0] * mass->pos[0] + mass->pos[1] * mass->pos[1] + mass->pos[2] * mass->pos[2]);

		if (distance < minDistance)
		{
			mass->color = color;
		}
	}
}


long CTitanMFCDlg::FindCenterMass()
{
	//=======================================================================================
	//Find Center mass and colour it green
	//=======================================================================================
	long centerMassIndex = -1;
	//find center mass
	long numberOfMasses = container->masses.size();
	double minDistance = 100000;
	for (int i = 0; i < numberOfMasses; i++)
	{
		Mass* mass = container->masses.at(i);
		double distance = sqrt(mass->pos[0] * mass->pos[0] + mass->pos[1] * mass->pos[1] + mass->pos[2] * mass->pos[2]);
		if (distance < minDistance)
		{
			minDistance = distance;
			centerMassIndex = i;
		}

	}

	return centerMassIndex;
	//===========================================================================================================
	
}


double CTitanMFCDlg::GetMaxRadius(long latticeDimension, double distanceBetweenMasses)
{
	double radius = (distanceBetweenMasses * (double)latticeDimension) / 2.0 - (distanceBetweenMasses * (double)latticeDimension) / 10;

	//double radius = (distanceBetweenMasses / 2 * (latticeDimension - (latticeDimension / 10.0)));
	return radius;
}

double CTitanMFCDlg::GetMinRadius(long latticeDimension, double distanceBetweenMasses)
{
	double radius = (distanceBetweenMasses * (double)latticeDimension) / 2.0 - (distanceBetweenMasses * (double)latticeDimension) / 10.0;

	//double radius = (distanceBetweenMasses / 2 * (latticeDimension - (latticeDimension / 10.0)));
	return radius;
}





void CTitanMFCDlg::TestRandomMasses()
{
	double factor = 3;

	Container* container = sim.createContainer();

	srand(time(NULL));
	for (int i = 0; i < 200; i++)
	{
		double valueX = factor * GetRandomValue(factor);
		double valueY = factor * GetRandomValue(factor);
		double valueZ = factor * GetRandomValue(factor);

		Vec massCenter = Vec(valueX, valueY, valueZ);
		Mass* mass = sim.createMass(massCenter);
		container->add(mass);
	}

	long numberOfMasses = container->masses.size();
	for (int i = 0; i < numberOfMasses; i++)
	{
		Mass* mass1 = container->masses.at(i);
		double red = (rand() % 255) / 255.0;
		double green = (rand() % 255) / 255.0;
		double blue = (rand() % 255) / 255.0;

		mass1->color = Vec(red, green, blue);
		mass1->setDrag(0.9999);

		for (int j = i; j < numberOfMasses; j++)
		{
			Mass* mass2 = container->masses.at(j);

			if (mass1 != mass2)
			{
				Spring* spring = sim.createSpring(mass1, mass2);
				container->add(spring);
			}
		}
	}

	sim.setGlobalAcceleration(Vec(0, 0, 0));

	sim.start();


}
//generates a normalized value between 1 and -1
double CTitanMFCDlg::GetRandomValue(double factor)
{
	double value = ((double)(rand() % 3000) - 3000.0 / 2.0) / 1500;//generate a value between -1 and +1;

	return value*factor;
}




// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CTitanMFCDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void CTitanMFCDlg::OnBnClickedStart()
{

	if (!m_isThreadRunning)
	{
		container = sim.createContainer();
		m_thread = AfxBeginThread(threadFunction, this, THREAD_PRIORITY_NORMAL);
		m_isThreadRunning = true;
		m_stopThisCrazyThing = false;
		m_StartButton.SetWindowTextA("STOP");
		m_simulationDone = false;
		return;
	}
	else
	{
		m_stopThisCrazyThing = true;
		m_StartButton.SetWindowTextA("Start");
		m_simulationDone = true;
	}

/*
	if (m_isThreadPaused)
	{
		m_isThreadPaused = false;
		m_StartButton.SetWindowTextA("Resume");
	}
	else
	{
		m_isThreadPaused = true;
		m_StartButton.SetWindowTextA("Pause");
	}
*/

}





#ifdef DEAD_CODE_REGION

//#define WRITE_TO_FILE
#ifdef WRITE_TO_FILE
long numberOfMasses = container->masses.size();
long numberOfSprings = container->springs.size();

std::string filePath = "c:/Scans/Masses.txt";
std::fstream dFile = std::fstream(filePath.c_str(), std::ios::out | std::ios::binary);

for (int i = 0; i < numberOfSprings; i++)
{
	Spring* spring = container->springs.at(i);
	Mass* left = spring->_left;
	Mass* right = spring->_right;

	Vec force = spring->getForce();

	double distanceX = left->pos[0] - right->pos[0];
	double distanceY = left->pos[1] - right->pos[1];
	double distanceZ = left->pos[2] - right->pos[2];
	double distanceBetweenMasses = sqrt(distanceX*distanceX + distanceY*distanceY + distanceZ * distanceZ);


	char outstring[200];
	sprintf_s(outstring, "DistanceBetweenMasses: %lf  FX: %lf  FY: %lf FZ: %lf\n", distanceBetweenMasses, force[0], force[1], force[2]);
	dFile.write(outstring, strlen(outstring));


}//for

dFile.close();
done = true;
#endif


#ifdef LOCK_DOWN_EDGE_MASSES	
////(m_distanceBetweenMasses / 2 * (m_latticeDimension - (m_latticeDimension / 10.0))) - m_distanceBetweenMasses / 2;
if (radius < (GetMaxRadius() - m_distanceBetweenMasses / 2))
{
	mass->color = yellow;
}
else//lock down outside masses
{
	mass->color = red;
	mass->fix();//fix all masses beyond maximum radius
}
#endif


void CTitanMFCDlg::TestConstraints()
{
	sim.setViewport(Vec(20, 20, 10), Vec(0, 0, 10), Vec(0, 0, 1)); // move the viewport so you can see the cubes

	l1 = sim.createLattice(Vec(0, 0, 20), Vec(5, 5, 5), 5, 5, 5);
	//sim.createPlane(Vec(0, 0, 1), 0);

	l1->masses[0]->addConstraint(CONSTRAINT_PLANE, Vec(0, 0, 1), 0);
	l1->masses[20]->addConstraint(DIRECTION, Vec(0, 1, 1), 0);
	l1->masses[0]->setDrag(100); // add drag to the mass with drag coefficient C equal to 100.

	sim.start();

	while (sim.time() < 10.0)
	{
		sim.pause(sim.time() + 1.0);

		sim.get(l1); // get lattice data from the GPU;
		l1->setSpringConstants(10000 * exp(-sim.time() / 3)); // exponential decay of the spring constant
		sim.set(l1); // push the lattice data to the GPU;

		sim.resume();
	}

	sim.stop();


}

void CTitanMFCDlg::MakeYeeLattice()
{
	m_massCount = 0;

	long iterations = 1;

	double cameraPos = 5;
	double cameraLoc = 0;

	m_cameraPosition[0] = cameraPos;
	m_cameraPosition[1] = cameraPos;
	m_cameraPosition[2] = cameraPos;

	m_cameraLocation[0] = cameraLoc;
	m_cameraLocation[1] = cameraLoc;
	m_cameraLocation[2] = cameraLoc;

	m_cameraNormal[0] = 0;
	m_cameraNormal[1] = 0;
	m_cameraNormal[2] = 1;


	sim.setViewport(m_cameraPosition, m_cameraLocation, m_cameraNormal); // set the viewport

	double middle = 0.0;
	double centerX = middle;
	double centerY = -middle;
	double centerZ = -middle;

	double distanceBetweenMasses = 0.5;

	m_red = 1.0; m_green = 1.0; m_blue = 0;

	Vec center(centerX, centerY, centerZ);
	CreateSpringMasses(center, distanceBetweenMasses);




	//for (int k = 1; k < iterations; k++)
	{
		VecArray newVecArray;
		long vecSize = g_vecArray.size();


		long j = 0;
		for (int j = 0; j < vecSize; j++)
		{
			Vec point = g_vecArray.at(j);
			newVecArray.push_back(point);
		}
		long newVecSize = newVecArray.size();
		//for (int i = 0; i < newVecSize; i++)
		int i = 0;
		m_red = 0.0; m_green = 0.0; m_blue = 1.0;
		{
			Vec newCenter = newVecArray.at(i);
			CreateSpringMasses(newCenter, distanceBetweenMasses);

		}
	}

	sim.defaultRestLength();
	sim.setAllSpringConstantValues(100000); // Spring constant [N/m]
	sim.setAllDeltaTValues(0.0001); //Simulation Time resolution [s]

									//sim.setGlobalAcceleration(Vec(0, 0, 0));


	for (int i = 0; i < m_massCount; i++)
	{
		Mass* mass = sim.getMassByIndex(i);
		mass->fix();

	}


	//sim.createPlane(Vec(0, 0, 1), 0);//positive is down and negative is up

	// run Simulation
	//sim.setBreakpoint(10.0);
	sim.start(); //Starts the simulation


	while (sim.time() < 10.0)
	{
		sim.pause(sim.time() + 1.0);

		m_cameraLocation[2] -= 1.0;
		sim.moveViewport(m_cameraLocation); // set the viewport

		sim.resume();
	}



	//delete stuff here

}

void CTitanMFCDlg::CreateSpringMasses(Vec center, double offset)
{
	double minDistance = offset / 10.0;
	Mass* centerMass;
	long index = IsOnList(center[0], center[1], center[2], minDistance);

	if (index >= 0)
	{
		centerMass = sim.getMassByIndex(index);

	}
	else
	{
		centerMass = sim.createMass(center); m_massCount++;

	}



	double centerX = center[0];
	double centerY = center[1];
	double centerZ = center[2];



	//calculate the corners of the box around the center mass
	g_vecArray.clear();
	Vec plusPlusPlus = Vec(centerX + offset, centerY + offset, centerZ + offset); g_vecArray.push_back(plusPlusPlus);
	Vec plusPlusMinus = Vec(centerX + offset, centerY + offset, centerZ - offset); g_vecArray.push_back(plusPlusMinus);
	Vec plusMinusPlus = Vec(centerX + offset, centerY - offset, centerZ + offset); g_vecArray.push_back(plusMinusPlus);
	Vec plusMinusMinus = Vec(centerX + offset, centerY - offset, centerZ - offset); g_vecArray.push_back(plusMinusMinus);
	Vec minusPlusPlus = Vec(centerX - offset, centerY + offset, centerZ + offset); g_vecArray.push_back(minusPlusPlus);
	Vec minusPlusMinus = Vec(centerX - offset, centerY + offset, centerZ - offset); g_vecArray.push_back(minusPlusMinus);
	Vec minusMinusPlus = Vec(centerX - offset, centerY - offset, centerZ + offset); g_vecArray.push_back(minusMinusPlus);
	Vec minusMinusMinus = Vec(centerX - offset, centerY - offset, centerZ - offset); g_vecArray.push_back(minusMinusMinus);

	MassArray massArray;



	for (int i = 0; i<g_vecArray.size(); i++)
		//===============================================================================================
	{
		//create mass one. Hook up to center spring
		Vec point = g_vecArray.at(i);
		long index = IsOnList(point[0], point[1], point[2], minDistance);
		if (index >= 0)
		{
			Mass* m1 = sim.getMassByIndex(index);
			//sim.createSpring(centerMass, m1);
			massArray.push_back(m1);
		}
		else
		{
			Mass* m1 = sim.createMass(point); m_massCount++;
			m1->color[0] = m_red;
			m1->color[1] = m_green;
			m1->color[2] = m_blue;
			//sim.createSpring(centerMass, m1);
			massArray.push_back(m1);
		}


	}

	//===============================================================================================

	//now, hook up the corners
	//#define HOOK_UP_CORNERS
#ifdef HOOK_UP_CORNERS
	sim.createSpring(massArray[0], massArray[1]);//plusPlusPlus----plusPlusMinus
	sim.createSpring(massArray[0], massArray[4]);//plusPlusPlus----minusPlusPlus
	sim.createSpring(massArray[0], massArray[2]);//plusPlusPlus----plusMinusPlus

	sim.createSpring(massArray[7], massArray[6]);//minusMinusMinus----minusMinusPlus
	sim.createSpring(massArray[7], massArray[3]);//minusMinusMinus----plusMinusMinus
	sim.createSpring(massArray[7], massArray[5]);//minusMinusMinus----minusPlusMinus

	sim.createSpring(massArray[2], massArray[3]);//plusMinusPlus----plusMinusMinus
	sim.createSpring(massArray[4], massArray[5]);//minusPlusPlus----minusPlusMinus
	sim.createSpring(massArray[6], massArray[4]);//minusMinusPlus----minusPlusPlus
	sim.createSpring(massArray[6], massArray[2]);//minusMinusPlus----plusMinusPlus
	sim.createSpring(massArray[3], massArray[1]);//plusMinusMinus----plusPlusMinus
	sim.createSpring(massArray[5], massArray[1]);//minusPlusMinus----plusPlusMinus
#endif
												 //===============================================================================================

}

long CTitanMFCDlg::IsOnList(double x, double y, double z, double minDistance)
{
	bool isOnList = false;
	long index = -1;

	long size = sim.masses.size();

	for (int i = 0; i < size; i++)
	{
		Mass* mass = sim.masses.at(i);
		Vec point = mass->pos;
		double distance = sqrt((x - point[0])*(x - point[0]) + (y - point[1])*(y - point[1]) + (z - point[2])*(z - point[2]));
		if (distance < minDistance)
		{
			isOnList = true;
			index = i;
			break;
		}
	}

	return index;
}
#endif


void CTitanMFCDlg::SetXCameraAngle(double angle)
{
	m_cameraXAngle = angle;
}
void CTitanMFCDlg::SetYCameraAngle(double angle)
{
	m_cameraYAngle = angle;

}
void CTitanMFCDlg::SetZCameraAngle(double angle)
{
	m_cameraZAngle = angle;
}

UINT CTitanMFCDlg::threadFunction(LPVOID pParam)
{

	CTitanMFCDlg *thread = (CTitanMFCDlg *)pParam;

	thread->GenerateYeeModel();

	return 0;
}




void CTitanMFCDlg::OnDeltaposSpin1(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMUPDOWN pNMUpDown = reinterpret_cast<LPNMUPDOWN>(pNMHDR);
	// TODO: Add your control notification handler code here
	int change = pNMUpDown->iDelta;
	m_cameraXAngle = (double)change / 10.0;

	*pResult = 0;

	m_cameraChanged = true;
}


void CTitanMFCDlg::OnDeltaposSpin2(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMUPDOWN pNMUpDown = reinterpret_cast<LPNMUPDOWN>(pNMHDR);
	// TODO: Add your control notification handler code here
	int change = pNMUpDown->iDelta;
	m_cameraYAngle = (double)change / 10.0;


	*pResult = 0;

	m_cameraChanged = true;
}


void CTitanMFCDlg::OnDeltaposSpin3(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMUPDOWN pNMUpDown = reinterpret_cast<LPNMUPDOWN>(pNMHDR);
	// TODO: Add your control notification handler code here
	int change = pNMUpDown->iDelta;
	m_cameraZAngle = (double)change / 10.0;
	*pResult = 0;

	m_cameraChanged = true;
}


void CTitanMFCDlg::OnBnClickedStart2()
{
	ShutDown();
}


void CTitanMFCDlg::ShutDown()
{
	if (m_isThreadRunning)
	{
		m_stopThisCrazyThing = true;
		bool done = false;
		while (!done)
		{
			if (m_isThreadRunning)
			{
				Sleep(100);
			}
			else
			{
				done = true;
			}
		}
	}
}

void CTitanMFCDlg::OnBnClickedCancel()
{
	// TODO: Add your control notification handler code here

	ShutDown();


	CDialogEx::OnCancel();
}


void CTitanMFCDlg::OnBnClickedWiggle()
{

	if (m_wiggle)
	{
		//m_wiggle = false;
		//m_wiggleText.SetWindowTextA("Wiggle OFF");
	}
	else//currently, "wiggle" is a one time only perturbation
	{
		m_wiggle = true;
		m_wiggleText.SetWindowTextA("Wiggle ON");
	}
}



void CTitanMFCDlg::OnBnClickedButton2()
{

}
