//  VectPotential - 3D wave modelling platform.
//
//  (c) Copyright 1998 - 2020 : Declan Traill
//
//  For the Theory behind this model, see the following papers:
//
//  https://www.researchgate.net/publication/326646134_Wave_functions_for_the_electron_and_positron
//
//  https://www.researchgate.net/publication/342025994_Charged_particle_attraction_and_repulsion_explained_A_detailed_mechanism_based_on_particle_wave-functions
//
//  https://www.researchgate.net/publication/343206825_Electron_Wave_Function_-_Rest_Energy_Calculation
//
unit VectorPotential;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, ComCtrls, Math, Grids, Jpeg;

const
  STANDING_WAVE_ANALYSIS=false;
  TWO_PARTICLE_REFLECTION_FIELDS=true;

  // Number of points to divide by in vector functions across point groups
  nP=3;

{$IF TWO_PARTICLE_REFLECTION_FIELDS}
  GRID_LIMIT=270;
{$ELSE}
  GRID_LIMIT=280;
{$IFEND}

{$IF STANDING_WAVE_ANALYSIS}
  GRID_SIZE=100;
{$ELSE}
  GRID_SIZE=100;
{$IFEND}

type            {Type declaration for a vector resolved into x,y & z components}

{$IF STANDING_WAVE_ANALYSIS}
  FloatVar=single;
{$ELSE}
  FloatVar=single;
{$IFEND}

  Vector = record
    x: FloatVar;
    y: FloatVar;
    z: FloatVar;
  end;

  VectorGrp = record
    V0: Vector;
    V1: Vector;
    V2: Vector;
    V3: Vector;
    V4: Vector;
    V5: Vector;
    V6: Vector;
  end;

  ScalarGrp = record
    S0: FloatVar;
    S1: FloatVar;
    S2: FloatVar;
    S3: FloatVar;
    S4: FloatVar;
    S5: FloatVar;
    S6: FloatVar;
  end;

  point = record      {Type declaration for a grid point}
    PsiVect: Vector;
    Psi: FloatVar;
    Hertzian: Vector;
    Hertzian_scalar: Vector;
    ElectricPotential: FloatVar;
    VectorPotential: Vector;
    Electric: Vector;
    Magnetic: Vector;
    ChargeDensity: FloatVar;
    PsiCurlVect: Vector;
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
    particle_pos_Reflected: Vector;
    particle_neg_Reflected: Vector;
{$IFEND}
  end;

  PointGrp = record
    P0: point;
    P1: point;
    P2: point;
    P3: point;
    P4: point;
    P5: point;
    P6: point;
  end;

  Analysis_Values = record
    power_sum1: extended;
    power_sum2: extended;
    reflected_sum: extended;
    power_opposed_1_sum1: extended;
    power_opposed_1_sum2: extended;
    power_opposed_2_sum1: extended;
    power_opposed_2_sum2: extended;
    power_reflected_1_sum1: extended;
    power_reflected_1_sum2: extended;
    power_reflected_2_sum1: extended;
    power_reflected_2_sum2: extended;
    power_aligned_1_sum1: extended;
    power_aligned_1_sum2: extended;
    power_aligned_2_sum1: extended;
    power_aligned_2_sum2: extended;
    avg_power_opposed_1_sum1: extended;
    avg_power_opposed_1_sum2: extended;
    avg_power_opposed_2_sum1: extended;
    avg_power_opposed_2_sum2: extended;
    avg_power_reflected_1_sum1: extended;
    avg_power_reflected_1_sum2: extended;
    avg_power_reflected_2_sum1: extended;
    avg_power_reflected_2_sum2: extended;
    avg_power_aligned_1_sum1: extended;
    avg_power_aligned_1_sum2: extended;
    avg_power_aligned_2_sum1: extended;
    avg_power_aligned_2_sum2: extended;
    accel_1: extended;
    accel_2: extended;
    accel_3: extended;
    accel_4: extended;
    accel_5: extended;
    accel_6: extended;
    accel_avg: extended;
  end;

  PointPtr = ^point;     {Define a type: pointer to a grid point}
  BitmapPtr = ^TBitmap;  {Define a type: pointer to a bitmap}
  TColorPtr = ^TColor;   {Define a type: pointer to a 24 bit colour type (TColor)}

  EdgeMasks = array[1..9,1..3,1..3] of byte;  {Define the EdgeMasks array type}

  TForm1 = class(TForm)
    StartGroup: TGroupBox;
    Start1: TRadioButton;
    Start2: TRadioButton;
    start3: TRadioButton;
    Start4: TRadioButton;
    Start5: TRadioButton;
    Start6: TRadioButton;
    Start7: TRadioButton;
    Start8: TRadioButton;
    Start9: TRadioButton;
    Start10: TRadioButton;
    Start11: TRadioButton;
    Start12: TRadioButton;
    Start13: TRadioButton;
    Start14: TRadioButton;
    ZPlaneGroup: TGroupBox;
    ZPlane: TTrackBar;
    Z_Plane_Number: TEdit;
    MainGroup: TGroupBox;
    TimeDisplay: TEdit;
    ReScale: TSpinEdit;
    AmpDisplay: TEdit;
    TimeFreeze: TButton;
    Image1: TImage;
    DisplayLevel: TScrollBar;
    FieldGroup: TGroupBox;
    Field1: TRadioButton;
    Field2: TRadioButton;
    Field3: TRadioButton;
    Field4: TRadioButton;
    Field5: TRadioButton;
    StatsGroup: TGroupBox;
    Energy1: TEdit;
    Energy2: TEdit;
    Energy3: TEdit;
    Units1: TEdit;
    Units2: TEdit;
    Units3: TEdit;
    Energy_Msg1: TEdit;
    Energy_Msg2: TEdit;
    Energy_Msg3: TEdit;
    ColourGroup: TGroupBox;
    ColourX_Group: TGroupBox;
    ColourY_Group: TGroupBox;
    ColourZ_Group: TGroupBox;
    X_Red: TRadioButton;
    X_Green: TRadioButton;
    X_Blue: TRadioButton;
    Y_Red: TRadioButton;
    Y_Green: TRadioButton;
    Y_Blue: TRadioButton;
    Z_Red: TRadioButton;
    Z_Green: TRadioButton;
    Z_Blue: TRadioButton;
    X_Colour: TImage;
    Y_Colour: TImage;
    Z_Colour: TImage;
    DisplayOptionsGroup: TGroupBox;
    RendDisplay: TCheckBox;
    Vect_Arrows: TCheckBox;
    Vector_Group: TGroupBox;
    VectorX: TCheckBox;
    VectorY: TCheckBox;
    VectorZ: TCheckBox;
    Spacing_Text: TStaticText;
    Spacing_metres: TRadioButton;
    Spacing_pixels: TRadioButton;
    Bevel1: TBevel;
    FirstZ: TStaticText;
    LastZ: TStaticText;
    Z_Tiling: TButton;
    TileGrid: TDrawGrid;
    GridGroup: TGroupBox;
    GridX: TEdit;
    GridY: TEdit;
    GridZ: TEdit;
    GridXlabel: TLabel;
    GridYlabel: TLabel;
    GridZlabel: TLabel;
    RendGroup: TGroupBox;
    AspectControl: TCheckBox;
    AcceptGridSize: TButton;
    GreyscaleButton: TRadioButton;
    ColourButton: TRadioButton;
    X_grey: TRadioButton;
    Y_grey: TRadioButton;
    Z_grey: TRadioButton;
    AutoWarnTimer: TTimer;
    Timesteps: TSpinEdit;
    Label1: TLabel;
    RateOfTime: TScrollBar;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Spacing_gridpoints: TRadioButton;
    Button1: TButton;
    VectorSpacing: TEdit;
    RenderOption1: TRadioButton;
    RenderOption2: TRadioButton;
    RenderOption3: TRadioButton;
    ArrowScaleScroll: TScrollBar;
    Label3: TLabel;
    ActualGridWidth: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Button2: TButton;
    ViewFromTop: TCheckBox;
    AutoScaleGroup: TGroupBox;
    AutoWarn: TImage;
    Auto1: TRadioButton;
    Auto2: TRadioButton;
    Auto3: TRadioButton;
    Auto4: TRadioButton;
    Scale_3D: TCheckBox;
    field6: TRadioButton;
    Field7: TRadioButton;
    Field8: TRadioButton;
    Field9: TRadioButton;
    CheckBox3: TCheckBox;
    RadioButton1: TRadioButton;
    Y_none: TRadioButton;
    X_none: TRadioButton;
    Z_none: TRadioButton;
    Edit1: TEdit;
    Energy4: TEdit;
    Edit2: TEdit;
    SmoothingCheckBox: TCheckBox;
    Field10: TRadioButton;
    Start15: TRadioButton;
    Start16: TRadioButton;
    Start17: TRadioButton;
    EnergyCorrectionCheckBox: TCheckBox;
    Start18: TRadioButton;
    Start19: TRadioButton;
    Start20: TRadioButton;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    HFormulaCheckBox: TCheckBox;
    EFormulaCheckBox: TCheckBox;
    Start21: TRadioButton;
    Start22: TRadioButton;
    Start23: TRadioButton;
    DistBetween: TEdit;
    DistBetweenUnits: TLabel;
    DistBetweenLabel: TLabel;
    Field11: TRadioButton;
    Field12: TRadioButton;
    Profile_GroupBox: TGroupBox;
    Profile_RadioButton_Off: TRadioButton;
    Profile_RadioButton_GridSize: TRadioButton;
    Profile_RadioButton_Distance: TRadioButton;
    Profile_RadioButton_ActualSize: TRadioButton;
    ShowEnergy_CheckBox: TCheckBox;
    ProgressBar1: TProgressBar;
    Percent_c: TLabel;
    Start24: TRadioButton;
    Start25: TRadioButton;
    Start26: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Start2Click(Sender: TObject);
    procedure Field0Click(Sender: TObject);
    procedure Field1Click(Sender: TObject);
    procedure Field2Click(Sender: TObject);
    procedure Field3Click(Sender: TObject);
    procedure Field4Click(Sender: TObject);
    procedure Field5Click(Sender: TObject);
    procedure Field6Click(Sender: TObject);
    procedure Field7Click(Sender: TObject);
    procedure Field8Click(Sender: TObject);
    procedure Field9Click(Sender: TObject);
    procedure Field10Click(Sender: TObject);
    procedure Field11Click(Sender: TObject);
    procedure Field12Click(Sender: TObject);
    procedure start3Click(Sender: TObject);
    procedure Start4Click(Sender: TObject);
    procedure Start5Click(Sender: TObject);
    procedure Start6Click(Sender: TObject);
    procedure Start7Click(Sender: TObject);
    procedure Start8Click(Sender: TObject);
    procedure Start9Click(Sender: TObject);
    procedure Start10Click(Sender: TObject);
    procedure Start11Click(Sender: TObject);
    procedure Start12Click(Sender: TObject);
    procedure Start13Click(Sender: TObject);
    procedure Start14Click(Sender: TObject);
    procedure Start15Click(Sender: TObject);
    procedure Start16Click(Sender: TObject);
    procedure Start17Click(Sender: TObject);
    procedure Start18Click(Sender: TObject);
    procedure Start19Click(Sender: TObject);
    procedure Start20Click(Sender: TObject);
    procedure Start21Click(Sender: TObject);
    procedure Start22Click(Sender: TObject);
    procedure Start23Click(Sender: TObject);
    procedure Start24Click(Sender: TObject);
    procedure Start25Click(Sender: TObject);
    procedure Start26Click(Sender: TObject);
    procedure TimeFreezeClick(Sender: TObject);
    procedure ZPlaneChange(Sender: TObject);
    procedure DisplayLevelChange(Sender: TObject);
    procedure ReScaleChange(Sender: TObject);
    procedure X_RedClick(Sender: TObject);
    procedure X_GreenClick(Sender: TObject);
    procedure X_BlueClick(Sender: TObject);
    procedure X_greyClick(Sender: TObject);
    procedure Y_RedClick(Sender: TObject);
    procedure Y_GreenClick(Sender: TObject);
    procedure Y_BlueClick(Sender: TObject);
    procedure Y_greyClick(Sender: TObject);
    procedure Z_RedClick(Sender: TObject);
    procedure Z_GreenClick(Sender: TObject);
    procedure Z_BlueClick(Sender: TObject);
    procedure Z_greyClick(Sender: TObject);
    procedure GreyscaleButtonClick(Sender: TObject);
    procedure ColourButtonClick(Sender: TObject);
    procedure Auto1Click(Sender: TObject);
    procedure Auto2Click(Sender: TObject);
    procedure Auto3Click(Sender: TObject);
    procedure Auto4Click(Sender: TObject);
    procedure Vect_ArrowsClick(Sender: TObject);
    procedure VectorSpacingChange(Sender: TObject);
    procedure Z_TilingClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure VectorXClick(Sender: TObject);
    procedure VectorYClick(Sender: TObject);
    procedure VectorZClick(Sender: TObject);
    procedure Spacing_pixelsClick(Sender: TObject);
    procedure Spacing_metresClick(Sender: TObject);
    procedure Spacing_gridpointsClick(Sender: TObject);
    procedure RenderOption1Click(Sender: TObject);
    procedure RenderOption2Click(Sender: TObject);
    procedure RenderOption3Click(Sender: TObject);
    procedure RendDisplayClick(Sender: TObject);
    procedure AspectControlClick(Sender: TObject);
    procedure GridXChange(Sender: TObject);
    procedure GridYChange(Sender: TObject);
    procedure GridZChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AcceptGridSizeClick(Sender: TObject);
    procedure X_noneClick(Sender: TObject);
    procedure Y_noneClick(Sender: TObject);
    procedure Z_noneClick(Sender: TObject);
    procedure AutoWarnTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RateOfTimeChange(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ArrowScaleScrollChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ViewFromTopClick(Sender: TObject);
    procedure Scale_3DClick(Sender: TObject);
    procedure SmoothingCheckBoxClick(Sender: TObject);
    procedure EnergyCorrectionCheckBoxClick(Sender: TObject);
    procedure EFormulaCheckBoxClick(Sender: TObject);
    procedure HFormulaCheckBoxClick(Sender: TObject);
    procedure CheckBox12Click(Sender: TObject);
    procedure ActualGridWidthChange(Sender: TObject);
    procedure DistBetweenChange(Sender: TObject);
    procedure Profile_RadioButton_OffClick(Sender: TObject);
    procedure Profile_RadioButton_GridSizeClick(Sender: TObject);
    procedure Profile_RadioButton_DistanceClick(Sender: TObject);
    procedure Profile_RadioButton_ActualSizeClick(Sender: TObject);
  private
    { Private declarations }
     procedure WMSysCommand (var Msg: TWMSysCommand) ; message WM_SYSCOMMAND;
  public
    procedure Propagate;
    procedure ProfileCancel;
    procedure Initialise(first:boolean);
    procedure update_progress_bar(progress:single);
    procedure RecalcFields(scr:smallint);
    procedure UpdateBitmap(scr:smallint);
    procedure DisplayScreen(scr:smallint);
    function sign(number: extended): shortint;
    function Gauss(x: extended): extended;
    procedure UpdateDetails;
    procedure UpdateAxisColours(which: string);
    procedure Auto_Scale(scr: smallint);
    procedure MaxCheck(element: PointPtr);
    function VectSize(vect: Vector): extended;
    function BtoH(Bvect: Vector): Vector;
    function E_Energy(E_vect: Vector): extended;
    function B_Energy(B_vect: Vector): extended;
    procedure DrawArrow(ThisBitmap: Tbitmap;x,y: smallint; arrow: Vector);
    procedure NewBitmap(BmapPtr: BitmapPtr);
    procedure PlotPoint(Bmap: TBitmap; x, y: smallint);
    function RGB_Val(colour: Tcolor; primary: integer): byte;
    function EdgeCase(x, y, Xmin, Ymin, Xmax, Ymax: smallint): byte;
    function VectorInterpolate(v1, v2, v3, v4: Vector; Xfrac,
      Yfrac: extended): Vector;
    function Interpolate(val1, val2, val3, val4, Xfrac,
      Yfrac: extended): extended;
    procedure PlotQuadrant(Bmap: TBitmap; Quadrant: byte; RealX, RealY: extended);
    function GetActualX(x: smallint): smallint;
    function GetActualY(y: smallint): smallint;
    procedure SetTileSize;
    function Round2(realval: extended): int64;
    function GetRealX(x: extended): extended;
    function GetRealY(y: extended): extended;
    function ColourRange(value: extended; ScaleFactor: extended): byte;
    function VectToColours(vect: vector; ScaleFactor: extended): vector;
    function ByteLimit(value: extended): smallint;
    function VectByteLimit(vect: Vector): Vector;
    function VectorCross(v1, v2: Vector): Vector;
    function PowerFlow(Apoint: point): vector;
    function RMS_PowerFlow(Apoint: point): vector;
    function VectorProperty(field: byte; Apoint: point): vector;
    function PointNull(Apoint: point; DisplayField: smallint): boolean;
    function VectorNull(vect: Vector): boolean;
    function ReverseTColor(input: TColor): Tcolor;
    function MouseZplane: smallint;
    procedure TileCursor(Bmap: TBitmap; Tile: smallint; colour: TColor);
    procedure PlotPixel(x, y: smallint; Colour: TColor);
    procedure UpdateE_Energy(scr: smallint);
    procedure UpdateB_Energy(scr: smallint);
    procedure SetAspectRatio;
    procedure SetGridGlobals;
    procedure ReAllocGridMemory;
    function VectDiv(VectGroup: VectorGrp): extended;
    function VectCurl(VectGroup: VectorGrp): Vector;
    function PointGroup(scr, x, y, z: smallint): PointGrp;
    function VectorGroup(PntGroup: PointGrp; Field: smallint): VectorGrp;
    function ScalarGroup(PntGroup: PointGrp; Field: smallint): ScalarGrp;
    function IntegrateScalarGrp(ScalarGroup: ScalarGrp): extended;
    function IsVectorField(Field: smallint): boolean;
    procedure FindMaxVal(scr, Field: smallint);
    procedure FindAverageVal(scr, Field: smallint);
    function VectorDot(v1, v2: Vector): extended;
    function Normalize(v: Vector): Vector;
    function ScalarGrad(ScalarGroup: ScalarGrp): Vector;
    { Public declarations }
  end;

  procedure ProcSetGridGlobals(Form: TForm1);

const
{EdgeArray is an array used to determine which points exist within the range of}
{a rectangular region (such as a grid x/y plane) given a known edge condition}
{The edge condition is determined elsewhere by EdgeCase; its values range from}
{1 to 9 corresponding to the point in question residing at the topleft corner,}
{somewhere along the top edge, the topright corner... etc.}
{The values in the sub-arrays indicate which of the points surrounding the }
{point in question are in range: 1=in range, 0=out of range}

  EdgeArray : EdgeMasks = (((0,0,0),     {Top Left corner}
                            (0,1,1),
                            (0,1,1)),

                           ((0,0,0),     {Top Edge}
                            (1,1,1),
                            (1,1,1)),

                           ((0,0,0),     {Top Right Corner}
                            (1,1,0),
                            (1,1,0)),

                           ((0,1,1),     {Left Edge}
                            (0,1,1),
                            (0,1,1)),

                           ((1,1,1),     {Not on an Edge or Corner}
                            (1,1,1),
                            (1,1,1)),

                           ((1,1,0),     {Right Edge}
                            (1,1,0),
                            (1,1,0)),

                           ((0,1,1),     {Bottom Left Corner}
                            (0,1,1),
                            (0,0,0)),

                           ((1,1,1),     {Bottom Edge}
                            (1,1,1),
                            (0,0,0)),

                           ((1,1,0),     {Bottom Right Corner}
                            (1,1,0),
                            (0,0,0)));

  StartOptionCaptions : array[1..25] of String = (
                                  ('1: e'),
                                  ('2: p'),
                                  ('3: ee^^'),
                                  ('4: pp^^'),
                                  ('5: ep^^'),
                                  ('6: ee^>'),
                                  ('7: pp^>'),
                                  ('8: ep^>'),
                                  ('9: ee^<'),
                                  ('10: pp^<'),
                                  ('11: ep^<'),
                                  ('12: ee>>'),
                                  ('13: pp>>'),
                                  ('14: ep>>'),
                                  ('15: ee><'),
                                  ('16: pp><'),
                                  ('17: ep><'),
                                  ('18: ee^v'),
                                  ('19: pp^v'),
                                  ('20: ep^v'),
                                  ('21: e OUT'),
                                  ('22: e IN'),
                                  ('23: e BOTH'),
                                  ('24: Proton'),
                                  ('25: Neutron')
                                  );
const

  Default_GridWidth=GRID_SIZE;     {Default Number of Pixels wide}
  Default_GridHeight=GRID_SIZE;    {Default Number of Pixels high}
  Default_GridDepth=GRID_SIZE;     {Default Number of Pixels Deep}

  RATE_OF_TIME_DIVISOR=1E17;
  SpeedOfLight=2.99792458E8;   {Speed of Light in meters per second}
  Permittivity= 8.8541878176E-12; {Permittivity of free space (farad/m)}
  Permeability=4*Pi*1E-7; {Permeability of free space (Henry/m)}
  Hhat=1.054571596E-34;   {reduced Planck's constant}
  Ek=8.9875517873681764e9; {Coulomb's constant}
  alpha=0.007297352569311; {Fine Structure Constant}

  ElectronCharge=-(1.60217662E-19);
  PositronCharge=(1.60217662E-19);
  ProtonCharge=(1.60217662E-19);
  NeutronCharge=(0);

  ElectronMass=9.1093835611E-31;   // (8.187105650638658873144497804e-14 Joules)
  ElectronComptonWavelength=2*Pi*Hhat/(ElectronMass*SpeedOfLight); // 2.4263097661e-12
  ElectronComptonRadius=ElectronComptonWavelength/(2*Pi);  // 3.8615919275e-13
  ElectronClassicalRadius=alpha*ElectronComptonRadius;  // 2.8179397774e-15

  ProtonMass=1.6726219E-27;        // (1.503277594693615520970316e-10 Joules)
  ProtonComptonWavelength=2*Pi*Hhat/(ProtonMass*SpeedOfLight);  // 1.3214095964e-15
  ProtonComptonRadius=ProtonComptonWavelength/(2*Pi);  // 2.1030886911e-16
  ProtonClassicalRadius=alpha*ProtonComptonRadius;  // 1.5346979664e-18

  NeutronMass=1.6749274980495E-27; // (1.50534976288068915159493719318e-10 Joules)
  NeutronComptonWavelength=2*Pi*Hhat/(NeutronMass*SpeedOfLight);  // 1.3195906285e-15
  NeutronComptonRadius=NeutronComptonWavelength/(2*Pi);  // 2.1001937138e-16
  NeutronClassicalRadius=alpha*ProtonComptonRadius;  // 1.5346979664e-18

  ElectronNeutrinoMass=1.17726E-35;// (1.0580685217197059348664e-18 Joules)
  ElectronNeutrinoComptonWavelength=2*Pi*Hhat/(ElectronNeutrinoMass*SpeedOfLight);  // 1.8774260824e-07
  ElectronNeutrinoComptonRadius=ElectronNeutrinoComptonWavelength/(2*Pi);  // 2.988016413e-08
  ElectronNeutrinoClassicalRadius=alpha*ElectronNeutrinoComptonRadius;  // 2.1804609249e-10

  Max_E=0;  {Max value of Electric field to allow per pixel - Volts/m (0 value disables it)}
  Max_B=0;  {Max value of Magnetic field to allow per pixel - Tesla (0 value disables it)}

  RED=$1;      {Multiplication factor for 4-byte RGB colour}
  GREEN=$100;  {Multiplication factor for 4-byte RGB colour}
  BLUE=$10000; {Multiplication factor for 4-byte RGB colour}
  GREY=$7F7F7F;{Definition for white}
  BLACK=$0;    {Definition for black}
  RedMask=$FF;       {Masking value for colour separation}
  GreenMask=$FF00;   {Masking value for colour separation}
  BlueMask=$FF0000;  {Masking value for colour separation}
  START=1;     {AutoScaling constants}
  CONTINUAL=2; {AutoScaling constants}
  NEVER=3;     {AutoScaling constants}
  AVERAGE=4;   {AutoScaling constants}
  OneToOne=1;  {Rendering Option Constant - for 1 pixel per point}
  Chunky=2;    {Rendering Option Constant - for filled rectangle per point}
  Blend=3;     {Rendering Option Constant - colour blending betweem points}
  EdgeSize=3;  {Size of border between Tiled Z Planes & screen edge}

  PSI_VECTOR_FIELD=0;
  PSI_SCALAR_FIELD=1;
  ELECTRIC_POTENTIAL_FIELD=2;
  HERTZIAN_FIELD=3;
  VECTOR_POTENTIAL_FIELD=4;
  ELECTRIC_FIELD=5;
  MAGNETIC_FIELD=6;
  E_ELECTRIC_FIELD=7;
  E_MAGNETIC_FIELD=8;
  POWER_FLOW_FIELD=9;
  CHARGE_DENSITY_FIELD=10;
  PSI_CURL_VECTOR_FIELD=11;
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
  PARTICLE_POS_REFLECTED_FIELD=12;
  PARTICLE_NEG_REFLECTED_FIELD=13;
{$IFEND}

type
  { Create the array type }
  TDynamicArray = array of array of array of point; {[1..GridWidth,1..GridHeight,1..GridDepth] of point;}
  pointsPtr = ^TDynamicArray;
var
  Form1: TForm1;
  Bitmap1,Bitmap2: TBitmap;
  BitmapRed,BitmapGreen,BitmapBlue,BitmapGrey,BitmapBlack: TBitmap;

  // Note: the Grid (0,0,0) point is at the Top, Left & Back point of the Grid
  //       So X increments to the right, Y increments downwards, & Z increments out of the screen
  PPMx, PPMy, PPMz: Extended;
  points1: TDynamicArray;
//  points2: TDynamicArray;
  points: array[0..0] of pointsPtr;
  particle1_A: array of array of array of Vector;
  particle2_A: array of array of array of Vector;
  particle1_E: array of array of array of Vector;
  particle2_E: array of array of array of Vector;
  particle_1_2_B: array of array of array of Vector;
  particle1_Power: array of array of array of Vector;
  particle2_Power: array of array of array of Vector;
  analysis_results: array[1..18] of array[0..50] of Analysis_Values;
  ColourArray: array of array of TColor; {[1..GridWidth,1..GridHeight] of Tcolor;}
  SignArray: array of array of array of shortint; {[1..GridWidth,1..GridHeight,1..3] of shortint;}
  ColArray: array[1..9] of Tcolor;
  PntArray: array[1..9] of Vector;
  YLinePtrs: array of PByteArray;
  GridWidth,GridHeight,GridDepth: integer;
  New_GridWidth,New_GridHeight,New_GridDepth: integer;
  screen: smallint;
  StartOption,New_StartOption: smallint;
  New_DisplayField,DisplayField : smallint;
  Time,TimeStep : extended;
  RescaleFactor, New_ReScale : double;
  Z_Plane, New_ZPlane : smallint;
  FreezeTime, New_FreezeTime: Boolean;
  TileZ, New_TileZ: Boolean;
  ShowColour, New_ShowColour: Boolean;
  IsGrey,DoUpdate : Boolean;
  E_Energy_Tot,B_Energy_Tot,Etotal,MaxVal : extended;
  Amplification : extended;
  X_RGB,Y_RGB,Z_RGB : Tcolor;
  New_AutoScale,AutoScale: smallint;
  ZplanePos,OriginX,OriginY : smallint;
  FirstPass : boolean;
  ArrowScale: extended;
  ScrScaleX,ScrScaleY,HalfX,HalfY : extended;
  BitmapX,BitmapY: smallint;
  TileX,TileY,TileXcount,TileYcount : smallint;
  Aspect: extended;
  NullVect: Vector;
  NullPoint: Point;
  NullVectGrp: VectorGrp;
  NullScalarGrp: ScalarGrp;
  NullPointGrp: PointGrp;
  MyMouse: TMouse;
  AxisColours,New_AxisColours: string;
  Display_Level,New_DisplayLevel: integer;
  Rate_Of_Time,New_RateOfTime: integer;
  Arrows, New_Arrows: boolean;
  UpdateColours,ReDraw: boolean;
  CurrentBitmap: TBitmap;
  New_Render,Render: smallint;
  New_Rendered,Rendered: boolean;
  New_VectSpacing,VectSpacing: integer;
  TileScrScaleX,TileScrScaleY: double;
  TileHalfX,TileHalfY: extended;
  MaintainAspect,New_MaintainAspect,VectorChange: boolean;
  ActualWidth,ActualHeight,ActualDepth: extended;
  PointArea,PointVolume: extended;
  ScreenAspect: extended;
  dx,dy,dz: extended;
  ArrowsUnitsChange,AutoWarnState: boolean;
  TileRect: TRect;
  Quit: boolean;
  Timestep_count: smallint;
  FrameCount: integer;
  save_frames,save_3D,New_Flip_YZ,Flip_YZ: boolean;
  arrow_step: extended;
  New_ArrowScaleFactor: integer;
  ArrowScaleFactor: extended;
  Restart, StartOptionChanged: boolean;
  ViewTop: boolean;
  AllFields: boolean;
  smoothing: boolean;
  two_particles: boolean;
  particle1_x, particle2_x, p1_p2_diff : extended;
  Velocity: Extended;
  accel_avg, PercentBetweenParticles: extended;
  IterationCount: integer;
  EnergyCorrection: boolean;
  E_useFormula, H_useFormula: boolean;
  NumGridPoints: Extended;
  two_particle_analysis, two_particle_accel_profile_done, profile_changed: boolean;
  two_particle_accel_profile, two_particle_accel_dist_profile, two_particle_accel_actual_width_profile: boolean;
  myFile, myFile2 : TextFile;
  justRestored: boolean;
implementation

{$R *.DFM}
{$G-} {Disable Data Importation from Units - Improves Memory access efficiency}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Initialise(true);
  Propagate();
end;

procedure TForm1.WMSysCommand(var Msg: TWMSysCommand) ;
begin
   if Msg.CmdType = SC_RESTORE then justRestored:=true;

   DefaultHandler(Msg) ;
end;

function IsOpen(const txt:TextFile):Boolean;
const
  fmTextOpenRead = 55217;
  fmTextOpenWrite = 55218;
begin
  Result := (TTextRec(txt).Mode = fmTextOpenRead) or (TTextRec(txt).Mode = fmTextOpenWrite)
end;

procedure TForm1.Initialise(first:boolean);
var
  scr,i,j,k : smallint;
begin
  if first then begin
    points[0] := @points1;
//    points[1] := @points2;

    two_particles:=false;
    Restart:=true;
    StartOptionChanged:=true;
    FreezeTime:=false;
    New_FreezeTime:=false;
    StartOption:=1;                {default to start config 3}
    New_StartOption:=StartOption;
    MyMouse:=TMouse.Create;        {Create a mouse variable}
    BitmapX:=Image1.Width;         {get width of picture control on the form}
    BitmapY:=Image1.Height;        {get height of picture control on the form}
    ScreenAspect:=BitmapY/BitmapX; {Calc Screen's aspect ratio}
    SetLength(YLinePtrs,BitmapY);  {determine size for array of bitmap line pointers}
    New_DisplayField:=PSI_VECTOR_FIELD;     {set default to displaying the PSI_VECTOR_FIELD field}
    NewBitmap(@Bitmap1);     {create a new blank 24bit bitmap}
    NewBitmap(@Bitmap2);     {create a new blank 24bit bitmap}
    BitmapRed := TBitmap.Create;     {create a bitmap for the red square}
    BitmapGreen := TBitmap.Create;   {create a bitmap for the green square}
    BitmapBlue := TBitmap.Create;    {create a bitmap for the blue square}
    BitmapGrey := TBitmap.Create;    {create a bitmap for the grey square}
    BitmapBlack := TBitmap.Create;    {create a bitmap for the black square}
    BitmapRed.LoadFromFile('red.bmp');      {load the red square from disk}
    BitmapGreen.LoadFromFile('green.bmp');  {load the green square from disk}
    BitmapBlue.LoadFromFile('blue.bmp');    {load the blue square from disk}
    BitmapGrey.LoadFromFile('grey.bmp');  {load the blue square from disk}
    BitmapBlack.LoadFromFile('black.bmp');  {load the black square from disk}

    New_ShowColour:=true;            {default to displaying a colour image}
    AutoScale:=AVERAGE;              {default autoscale option to at AVERAGE}
    New_TileZ:=false;                {default Z plane Tiling option}
    New_Arrows:=true;                {default to Vector Arrows On}
    New_Render:=Blend;               {default to Colour Blended Rendering}
    New_Rendered:=true;              {default to Rendered Display On}
    New_DisplayLevel:=1995;          {default Level slider to (2000 - n)*1000%}
    New_RateOfTime:=RateOfTime.Position; {default Rate of Time slider}
    New_MaintainAspect:=true;        {Default Aspect Ratio Control setting}
    New_AutoScale:=AVERAGE;          {Default AutoScale option to AVERAGE}
    GridWidth:=0;                    {Ensure a full update occurs}
    GridHeight:=0;
    GridDepth:=0;
    New_GridWidth:=Default_GridWidth;     {set default Grid Dimensions}
    New_GridHeight:=Default_GridHeight;
    New_GridDepth:=Default_GridDepth;
    VectorChange:=false;              {initialise flag}
    New_Flip_YZ:=false;
    Flip_YZ:=false;
    New_ArrowScaleFactor := ArrowScaleScroll.Position;
    ViewTop := ViewFromTop.Checked;

    // Don't reset these if profiling - so frames can be captured of the whole profile if needed
    if two_particle_accel_profile_done then begin
      FrameCount:=1;
      save_frames:=false;
      save_3D:=false;
    end;

    if STANDING_WAVE_ANALYSIS then begin
       StartOption:=20;            {default to start config 18}
       New_StartOption:=StartOption;
//       EnergyCorrectionCheckBox.Checked := false;
       EnergyCorrection := EnergyCorrectionCheckBox.Checked;
       ActualGridWidth.Text:='2.0E-11';
       Start18.Visible:=true;
       Start19.Visible:=true;
       Start20.Visible:=true;
       CheckBox4.Visible:=true;
       CheckBox5.Visible:=true;
       CheckBox6.Visible:=true;
       CheckBox7.Visible:=true;
       CheckBox8.Visible:=true;
       CheckBox9.Visible:=true;
       CheckBox10.Visible:=true;
       CheckBox11.Visible:=true;
       CheckBox12.Visible:=true;
    end;
  end;

  ProcSetGridGlobals(Self);

  Start1.Checked:=false;
  Start2.Checked:=false;
  Start3.Checked:=false;
  Start4.Checked:=false;
  Start5.Checked:=false;
  Start6.Checked:=false;
  Start7.Checked:=false;
  Start8.Checked:=false;
  Start9.Checked:=false;
  Start10.Checked:=false;
  Start11.Checked:=false;
  Start12.Checked:=false;
  Start13.Checked:=false;
  Start14.Checked:=false;
  Start15.Checked:=false;
  Start16.Checked:=false;
  Start17.Checked:=false;
  Start18.Checked:=false;
  Start19.Checked:=false;
  Start20.Checked:=false;
  Start21.Checked:=false;
  Start22.Checked:=false;
  Start23.Checked:=false;
  Start24.Checked:=false;
  Start25.Checked:=false;
  Start26.Checked:=false;

  case StartOption of
   1: begin  // if electron being modelled
      Start1.Checked:=true;
      end;

   2: begin  // if positron being modelled
      Start2.Checked:=true;
      end;

   3: begin  // if two electrons being modelled
      Start3.Checked:=true;
      end;

   4: begin  // if two positrons being modelled
      Start4.Checked:=true;
      end;

   5: begin  // if an electron and a positron being modelled
      Start5.Checked:=true;
      end;

   6: begin  // if two electrons being modelled
      Start6.Checked:=true;
      end;

   7: begin  // if two positrons being modelled
      Start7.Checked:=true;
      end;

   8: begin  // if an electron and a positron being modelled
      Start8.Checked:=true;
      end;

   9: begin  // if two electrons being modelled
      Start9.Checked:=true;
      end;

   10: begin  // if two positrons being modelled
       Start10.Checked:=true;
       end;

   11: begin  // if an electron and a positron being modelled
       Start11.Checked:=true;
       end;

   12: begin  // if an electron and a positron being modelled
       Start12.Checked:=true;
       end;

   13: begin  // if an electron and a positron being modelled
       Start13.Checked:=true;
       end;

   14: begin  // if an electron and a positron being modelled
       Start14.Checked:=true;
       end;

   15: begin  // if an electron and a positron being modelled
       Start15.Checked:=true;
       end;

   16: begin  // if an electron and a positron being modelled
       Start16.Checked:=true;
       end;

   17: begin  // if an electron and a positron being modelled
       Start17.Checked:=true;
       end;

   18: begin  // if an electron and a positron being modelled
      Start18.Checked:=true;
      end;

   19: begin  // if an electron and a positron being modelled
      Start19.Checked:=true;
      end;

   20: begin  // if an electron and a positron being modelled
      Start20.Checked:=true;
      end;

   21: begin  // if electron OUT wave being modelled
      Start21.Checked:=true;
      end;

   22: begin  // if electron IN wave being modelled
      Start22.Checked:=true;
      end;

   23: begin  // if electron OUT+IN wave being modelled
      Start23.Checked:=true;
      end;

   24: begin  // if proton being modelled
      Start24.Checked:=true;
      end;

   25: begin  // if neutron being modelled
      Start25.Checked:=true;
      end;

   26: begin  // if neutrino being modelled
      Start26.Checked:=true;
      end;
  end;

  with NullVect do begin
    x:=0;
    y:=0;
    z:=0;
  end;
  with NullPoint do begin
    Electric:=NullVect;
    Magnetic:=NullVect;
  end;
  with NullVectGrp do begin
    v0:=NullVect;
    v1:=NullVect;
    v2:=NullVect;
    v3:=NullVect;
    v4:=NullVect;
    v5:=NullVect;
    v6:=NullVect;
  end;
  with NullScalarGrp do begin
    s0:=0;
    s1:=0;
    s2:=0;
    s3:=0;
    s4:=0;
    s5:=0;
    s6:=0;
  end;
  with NullPointGrp do begin
    p0:=NullPoint;
    p1:=NullPoint;
    p2:=NullPoint;
    p3:=NullPoint;
    p4:=NullPoint;
    p5:=NullPoint;
    p6:=NullPoint;
  end;
  Form1.visible:=true;       {show the Form (user interface)}
  Image1.visible:=true;      {ensure the Image is visible}
  Screen:=0;                 {start by displaying bitmap1}
  DisplayScreen(Screen);     {make it visible}
  New_DisplayLevel:=1995;    {default Level slider to (2000 - n)*1000%}
  Time:=0;                   {set time to zero}
  Timestep_count:=0;
  MaxVal:=0;                 {ensure MaxVal is zero}

  // Don't reset these if profiling - so that they stay on the screen during profiling
  if two_particle_accel_profile_done then begin
    E_Energy_Tot:=0;           {ensure Electric field energy total=0}
    B_Energy_Tot:=0;           {ensure Magnetic field energy total=0}
    FrameCount:=1;
  end;

  Etotal:=0;                 {ensure integrated energy total=0}
  New_AxisColours:='ALL';    {set axis colour display boxes to match selections}
  UpdateDetails;             {Update all changed values & displayed text}
  DoUpdate:=false;           {Initial conditions set up via FirstPass}
  FirstPass:=true;
  AllFields:=false;
  accel_avg:=0;
  IterationCount:=0;
  EnergyCorrection := EnergyCorrectionCheckBox.Checked;
  E_useFormula := EFormulaCheckBox.Checked;
  H_useFormula := HFormulaCheckBox.Checked;

  scr:=0;
  if not first then          {if first initialisation then Grid zero'ed already}
    //for scr:=0 to 1 do             {scan both copies of the grid's points}
      for i:=0 to (GridWidth-2) do     {and set all values to zero}
        for j:=0 to (GridHeight-2) do
          for k:=0 to (GridDepth-2) do begin
            points[scr]^[i,j,k]:=NullPoint;
            particle1_A[i,j,k]:=NullVect;
            particle2_A[i,j,k]:=NullVect;
            particle1_E[i,j,k]:=NullVect;
            particle2_E[i,j,k]:=NullVect;
            particle_1_2_B[i,j,k]:=NullVect;
            particle1_Power[i,j,k]:=NullVect;
            particle2_Power[i,j,k]:=NullVect;
          end;
  ReDraw:=true;               {ensure redraw is enabled}
end;

function RunningAverage(old_count: integer; old_avg, new_value:extended): extended;
begin
  Result:= ((old_avg * old_count) + new_value) / (old_count + 1);
end;

procedure AnalysisWriteHeader();
begin
  // Write a couple of well known words to this file
  WriteLn(myFile, 'Two Particle Analysis For StartOption ' + StartOptionCaptions[StartOption]);
  WriteLn(myFile, '---------------------');
  WriteLn(myFile, '');
  WriteLn(myFile, '');
end;


procedure AnalysisSaveResults(StartOption: smallint; IterationCount: integer);
begin
  analysis_results[StartOption][IterationCount].avg_power_opposed_1_sum1 := analysis_results[StartOption][IterationCount].power_opposed_1_sum1/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_opposed_1_sum2 := analysis_results[StartOption][IterationCount].power_opposed_1_sum2/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_opposed_2_sum1 := analysis_results[StartOption][IterationCount].power_opposed_2_sum1/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_opposed_2_sum2 := analysis_results[StartOption][IterationCount].power_opposed_2_sum2/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_reflected_1_sum1 := analysis_results[StartOption][IterationCount].power_reflected_1_sum1/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_reflected_1_sum2 := analysis_results[StartOption][IterationCount].power_reflected_1_sum2/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_reflected_2_sum1 := analysis_results[StartOption][IterationCount].power_reflected_2_sum1/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_reflected_2_sum2 := analysis_results[StartOption][IterationCount].power_reflected_2_sum2/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_aligned_1_sum1 := analysis_results[StartOption][IterationCount].power_aligned_1_sum1/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_aligned_1_sum2 := analysis_results[StartOption][IterationCount].power_aligned_1_sum2/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_aligned_2_sum1 := analysis_results[StartOption][IterationCount].power_aligned_2_sum1/NumGridPoints;
  analysis_results[StartOption][IterationCount].avg_power_aligned_2_sum2 := analysis_results[StartOption][IterationCount].power_aligned_2_sum2/NumGridPoints;
  analysis_results[StartOption][IterationCount].accel_1 := analysis_results[StartOption][IterationCount].power_reflected_1_sum1 - analysis_results[StartOption][IterationCount].power_reflected_1_sum2 + analysis_results[StartOption][IterationCount].power_reflected_2_sum1 - analysis_results[StartOption][IterationCount].power_reflected_2_sum2;
  analysis_results[StartOption][IterationCount].accel_1 := analysis_results[StartOption][IterationCount].accel_1*PointArea/(SpeedOfLight*ElectronMass);
  analysis_results[StartOption][IterationCount].accel_2 := analysis_results[StartOption][IterationCount].power_reflected_1_sum1 - analysis_results[StartOption][IterationCount].power_reflected_1_sum2 - analysis_results[StartOption][IterationCount].power_reflected_2_sum1 + analysis_results[StartOption][IterationCount].power_reflected_2_sum2;
  analysis_results[StartOption][IterationCount].accel_2 := analysis_results[StartOption][IterationCount].accel_2*PointArea/(SpeedOfLight*ElectronMass);
  analysis_results[StartOption][IterationCount].accel_3 := -analysis_results[StartOption][IterationCount].power_reflected_1_sum1 + analysis_results[StartOption][IterationCount].power_reflected_1_sum2 + analysis_results[StartOption][IterationCount].power_reflected_2_sum1 - analysis_results[StartOption][IterationCount].power_reflected_2_sum2;
  analysis_results[StartOption][IterationCount].accel_3 := analysis_results[StartOption][IterationCount].accel_3*PointArea/(SpeedOfLight*ElectronMass);
  analysis_results[StartOption][IterationCount].accel_4 := -analysis_results[StartOption][IterationCount].power_reflected_1_sum1 + analysis_results[StartOption][IterationCount].power_reflected_1_sum2 - analysis_results[StartOption][IterationCount].power_reflected_2_sum1 + analysis_results[StartOption][IterationCount].power_reflected_2_sum2;
  analysis_results[StartOption][IterationCount].accel_4 := analysis_results[StartOption][IterationCount].accel_4*PointArea/(SpeedOfLight*ElectronMass);
  analysis_results[StartOption][IterationCount].accel_5 := analysis_results[StartOption][IterationCount].power_reflected_1_sum1 + analysis_results[StartOption][IterationCount].power_reflected_1_sum2 + analysis_results[StartOption][IterationCount].power_reflected_2_sum1 + analysis_results[StartOption][IterationCount].power_reflected_2_sum2;
  analysis_results[StartOption][IterationCount].accel_5 := analysis_results[StartOption][IterationCount].accel_5*PointArea/(SpeedOfLight*ElectronMass);
  analysis_results[StartOption][IterationCount].accel_6 := -analysis_results[StartOption][IterationCount].power_reflected_1_sum1 - analysis_results[StartOption][IterationCount].power_reflected_1_sum2 - analysis_results[StartOption][IterationCount].power_reflected_2_sum1 - analysis_results[StartOption][IterationCount].power_reflected_2_sum2;
  analysis_results[StartOption][IterationCount].accel_6 := analysis_results[StartOption][IterationCount].accel_6*PointArea/(SpeedOfLight*ElectronMass);
  analysis_results[StartOption][IterationCount].accel_avg := accel_avg;
end;

procedure AnalysisWriteResults(StartOption: smallint; IterationCount: integer);
var
  aligned_sum, opposed_sum, total_sum: extended;
begin
  aligned_sum:=analysis_results[StartOption][IterationCount].avg_power_aligned_1_sum1 + analysis_results[StartOption][IterationCount].avg_power_aligned_1_sum2 + analysis_results[StartOption][IterationCount].avg_power_aligned_2_sum1 + analysis_results[StartOption][IterationCount].avg_power_aligned_2_sum2;
  opposed_sum:=analysis_results[StartOption][IterationCount].avg_power_opposed_1_sum1 + analysis_results[StartOption][IterationCount].avg_power_opposed_1_sum2 + analysis_results[StartOption][IterationCount].avg_power_opposed_2_sum1 + analysis_results[StartOption][IterationCount].avg_power_opposed_2_sum2;

  WriteLn(myFile, 'avg_power_aligned_1_sum1: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_aligned_1_sum1));
  WriteLn(myFile, 'avg_power_aligned_1_sum2: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_aligned_1_sum2));
  WriteLn(myFile, 'avg_power_aligned_2_sum1: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_aligned_2_sum1));
  WriteLn(myFile, 'avg_power_aligned_2_sum2: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_aligned_2_sum2));
  WriteLn(myFile, 'avg_power_aligned_total: ' + FloatToStr(aligned_sum));
  WriteLn(myFile, 'avg_power_opposed_1_sum1: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_opposed_1_sum1));
  WriteLn(myFile, 'avg_power_opposed_1_sum2: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_opposed_1_sum2));
  WriteLn(myFile, 'avg_power_opposed_2_sum1: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_opposed_2_sum1));
  WriteLn(myFile, 'avg_power_opposed_2_sum2: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_opposed_2_sum1 + analysis_results[StartOption][IterationCount].avg_power_opposed_2_sum2));
  WriteLn(myFile, 'avg_power_opposed_total: ' + FloatToStr(opposed_sum));
  WriteLn(myFile, 'avg_power_total: ' + FloatToStr(aligned_sum + opposed_sum));
  WriteLn(myFile, 'avg_power_aligned_fraction: ' + FloatToStr(aligned_sum/(aligned_sum + opposed_sum)));
  WriteLn(myFile, 'avg_power_opposed_fraction: ' + FloatToStr(opposed_sum/(aligned_sum + opposed_sum)));
  WriteLn(myFile, 'avg_power_reflected_1_sum1: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_reflected_1_sum1));
  WriteLn(myFile, 'avg_power_reflected_1_sum2: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_reflected_1_sum2));
  WriteLn(myFile, 'avg_power_reflected_2_sum1: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_reflected_2_sum1));
  WriteLn(myFile, 'avg_power_reflected_2_sum2: ' + FloatToStr(analysis_results[StartOption][IterationCount].avg_power_reflected_2_sum2));
  WriteLn(myFile, 'accel_1: ' + FloatToStr(analysis_results[StartOption][IterationCount].accel_1));
  WriteLn(myFile, 'accel_2: ' + FloatToStr(analysis_results[StartOption][IterationCount].accel_2));
  WriteLn(myFile, 'accel_3: ' + FloatToStr(analysis_results[StartOption][IterationCount].accel_3));
  WriteLn(myFile, 'accel_4: ' + FloatToStr(analysis_results[StartOption][IterationCount].accel_4));
  WriteLn(myFile, 'accel_5: ' + FloatToStr(analysis_results[StartOption][IterationCount].accel_5));
  WriteLn(myFile, 'accel_6: ' + FloatToStr(analysis_results[StartOption][IterationCount].accel_6));
  WriteLn(myFile, 'accel_avg: ' + FloatToStr(analysis_results[StartOption][IterationCount].accel_avg));
  WriteLn(myFile, '');
end;

procedure TForm1.update_progress_bar(progress:single);
begin
  if progress > 100 then progress:=100;

  ProgressBar1.Min := 0;
  ProgressBar1.Max := 200;
  ProgressBar1.Position := Round(2*progress);
end;

procedure TForm1.RecalcFields(scr:smallint);
label
  NeutronNext;
var
  r,r1,r2,x,y,z,unit_x,unit_y,unit_z,actual_x,actual_y,actual_z,r_lower_limit : extended;
  theta, theta1, theta2, delta, delta1, delta2, theta_const, theta_const1, theta_const2, expTheta, lnTheta : extended;
  term0, term1, term1a, term1b, term2, term2a, term2b, term3, term3a, term3b : extended;
  psi_x, psi_y, psi_z, psi_x_particle1, psi_y_particle1, psi_z_particle1, psi_x_particle2, psi_y_particle2, psi_z_particle2 : extended;
  normal_x,normal_y,normal_z,dir_x,dir_y,dir_z : extended;
  scalar_amp, Vector_amp, SpinConstant, E_amp, A_amp : extended;
  NewScreen : smallint;
  xpos,ypos,zpos,midx,midy,midz:smallint;
  ThisGroup,NewGroup: PointGrp;
  vect,vect2,CurlVect,DivVect: vector;
  Scalar_Group: ScalarGrp;
  VectGrp: VectorGrp;
  I: Integer;
  ShellThickness: Extended;
  dist: longint;
  electron, positron, proton, neutron, neutrino, two_particle_composite: boolean;
  orthogonal_particles: boolean;
  particles_end_to_end: boolean;
  particle1_spin, particle2_spin, saved_sign: integer;
  pass, maxpass, n, x_sign: smallint;
  AveragePowerPerPoint,ReflectedPowerAtPoint,PressurePerPoint,Force,Accel: Extended;
  PowerSum_neg, PowerSum_pos, Pressure: Extended;
  PowerCount_neg, PowerCount_pos: integer;
  Power_x1, Power_x2, dot_v1v2, reflected_power: Extended;
  PrevVectorPotential, ElecFieldFromV, ElecFieldFromA: Vector;
  PowerCorrectionFactor_E, PowerCorrectionFactor_B, EnergyFactor: Extended;
  ElectricPotentialSum_pos, ElectricPotentialSum_neg, ElectricPotentialSum: extended;
  PsiSum, PsiSumXpos, PsiSumYpos, PsiSumZpos, PsiSumXneg, PsiSumYneg, PsiSumZneg: extended;
  ElecFieldCurl_Sum, ElecFieldFromV_Sum, ElecFieldFromA_Sum, ElecField_Sum, MagField_Sum, VectorPotential_Sum : extended;
  ElecFieldFromV_SignedHalf_SumX, ElecFieldFromA_SignedHalf_SumX : extended;
  ElecFieldGradDivPsi_SignedHalf_SumX, ElecFieldCurlCurlPsi_SignedHalf_SumX :extended;
  c1,c2,c3,A,DistFromCenter,ExpectedAccel,E_Energy_Sum,B_Energy_Sum,MeC_Hhat: Extended;
  field_stats: boolean;
  sine_wave_sum, neutron_quarks, neutrino_quarklets: boolean;
  progress, progress_inc, r_contracted, x_contracted, x_velocity, gamma, r_gamma: single;
  Qsin1, Qcos1, Qsin2, Qcos2, M, c, E0: extended;

begin
  progress:=0;
  progress_inc:=5.8;
  update_progress_bar(progress);

  NumGridPoints := (GridWidth*GridHeight*GridDepth);

  field_stats:= false;

  if two_particle_analysis then begin
    if IterationCount = 0 then begin
      // Try to open the Analysis.txt file for writing to
      AssignFile(myFile, 'Analysis' + IntToStr(StartOption) + '.txt');
      ReWrite(myFile);

      AnalysisWriteHeader();
    end;

    WriteLn(myFile, 'StartOption: ' + IntToStr(StartOption) + '  Timestep: ' + IntToStr(IterationCount));
    WriteLn(myFile, '');

    analysis_results[StartOption][IterationCount].power_sum1:=0;
    analysis_results[StartOption][IterationCount].power_sum2:=0;
    analysis_results[StartOption][IterationCount].reflected_sum:=0;
    analysis_results[StartOption][IterationCount].power_opposed_1_sum1:=0;
    analysis_results[StartOption][IterationCount].power_opposed_1_sum2:=0;
    analysis_results[StartOption][IterationCount].power_opposed_2_sum1:=0;
    analysis_results[StartOption][IterationCount].power_opposed_2_sum2:=0;
    analysis_results[StartOption][IterationCount].power_reflected_1_sum1:=0;
    analysis_results[StartOption][IterationCount].power_reflected_1_sum2:=0;
    analysis_results[StartOption][IterationCount].power_reflected_2_sum1:=0;
    analysis_results[StartOption][IterationCount].power_reflected_2_sum2:=0;
    analysis_results[StartOption][IterationCount].power_aligned_1_sum1:=0;
    analysis_results[StartOption][IterationCount].power_aligned_1_sum2:=0;
    analysis_results[StartOption][IterationCount].power_aligned_2_sum1:=0;
    analysis_results[StartOption][IterationCount].power_aligned_2_sum2:=0;
    analysis_results[StartOption][IterationCount].avg_power_opposed_1_sum1:=0;
    analysis_results[StartOption][IterationCount].avg_power_opposed_1_sum2:=0;
    analysis_results[StartOption][IterationCount].avg_power_opposed_2_sum1:=0;
    analysis_results[StartOption][IterationCount].avg_power_opposed_2_sum2:=0;
    analysis_results[StartOption][IterationCount].avg_power_reflected_1_sum1:=0;
    analysis_results[StartOption][IterationCount].avg_power_reflected_1_sum2:=0;
    analysis_results[StartOption][IterationCount].avg_power_reflected_2_sum1:=0;
    analysis_results[StartOption][IterationCount].avg_power_reflected_2_sum2:=0;
    analysis_results[StartOption][IterationCount].avg_power_aligned_1_sum1:=0;
    analysis_results[StartOption][IterationCount].avg_power_aligned_1_sum2:=0;
    analysis_results[StartOption][IterationCount].avg_power_aligned_2_sum1:=0;
    analysis_results[StartOption][IterationCount].avg_power_aligned_2_sum2:=0;
    analysis_results[StartOption][IterationCount].accel_1:=0;
    analysis_results[StartOption][IterationCount].accel_2:=0;
    analysis_results[StartOption][IterationCount].accel_3:=0;
    analysis_results[StartOption][IterationCount].accel_4:=0;
    analysis_results[StartOption][IterationCount].accel_5:=0;
    analysis_results[StartOption][IterationCount].accel_6:=0;
  end;

  maxpass:=3;
  particle1_spin:=1;
  particle2_spin:=1;
  orthogonal_particles:=false;
  particles_end_to_end:=false;
  sine_wave_sum:=false;
  E_Energy_Sum:=0;
  B_Energy_Sum:=0;

  proton:=false;
  neutron:=false;
  neutrino:=false;
  neutrino_quarklets:=false;
  two_particle_composite:=false;
  r_lower_limit:=ElectronComptonRadius;

  case StartOption of
   1: begin  // if electron being modeled
       electron:=true;
       positron:=false;
       two_particles:=false;
       maxpass:=1;
      end;

   2: begin  // if positron being modeled
       electron:=false;
       positron:=true;
       two_particles:=false;
       maxpass:=1;
       end;

   3: begin  // if two electrons being modeled
       electron:=true;
       positron:=false;
       two_particles:=true;
       end;

   4: begin  // if two positrons being modeled
       electron:=false;
       positron:=true;
       two_particles:=true;
       end;

   5: begin  // if an electron and a positron being modeled
       electron:=true;
       positron:=true;
       two_particles:=true;
       end;

   6: begin  // if two electrons being modeled orthogonally
       electron:=true;
       positron:=false;
       two_particles:=true;
       orthogonal_particles:=true;
       end;

   7: begin  // if two positrons being modeled orthogonally
       electron:=false;
       positron:=true;
       two_particles:=true;
       orthogonal_particles:=true;
       end;

   8: begin  // if an electron and a positron being modeled orthogonally
       electron:=true;
       positron:=true;
       two_particles:=true;
       orthogonal_particles:=true;
       end;

   9: begin  // if two electrons being modeled orthogonally - reversed 2nd axis
       electron:=true;
       positron:=false;
       two_particles:=true;
       orthogonal_particles:=true;
       particle2_spin:=-1;
       end;

   10: begin  // if two positrons being modeled orthogonally - reversed 2nd axis
       electron:=false;
       positron:=true;
       two_particles:=true;
       orthogonal_particles:=true;
       particle2_spin:=-1;
       end;

   11: begin  // if an electron and a positron being modeled orthogonally - reversed 2nd axis
       electron:=true;
       positron:=true;
       two_particles:=true;
       orthogonal_particles:=true;
       particle2_spin:=-1;
       end;

   12: begin  // if two electrons being modeled spins end to end
       electron:=true;
       positron:=false;
       two_particles:=true;
       particles_end_to_end:=true;
       end;

   13: begin  // if two positrons being modeled spins end to end
       electron:=false;
       positron:=true;
       two_particles:=true;
       particles_end_to_end:=true;
       end;

   14: begin  // if an electron and a positron being modeled spins end to end
       electron:=true;
       positron:=true;
       two_particles:=true;
       particles_end_to_end:=true;
       end;

   15: begin  // if two electrons being modeled spins end to end - reversed 2nd axis
       electron:=true;
       positron:=false;
       two_particles:=true;
       particles_end_to_end:=true;
       particle2_spin:=-1;
       end;

   16: begin  // if two positrons being modeled spins end to end - reversed 2nd axis
       electron:=false;
       positron:=true;
       two_particles:=true;
       particles_end_to_end:=true;
       particle2_spin:=-1;
       end;

   17: begin  // if an electron and a positron being modeled spins end to end - reversed 2nd axis
       electron:=true;
       positron:=true;
       two_particles:=true;
       particles_end_to_end:=true;
       particle2_spin:=-1;
       end;

   18: begin  // if two electrons being modeled spins end to end - reversed 2nd spin axis
       electron:=true;
       positron:=false;
       two_particles:=true;
       end;

   19: begin  // if two positrons being modeled spins end to end - reversed 2nd spin axis
       electron:=false;
       positron:=true;
       two_particles:=true;
       end;

   20: begin  // if an electron and a positron being modeled spins end to end - reversed 2nd spin axis
       electron:=true;
       positron:=true;
       two_particles:=true;
       end;

   21: begin  // if electron OUT wave being modeled
       electron:=true;
       positron:=false;
       two_particles:=false;
       sine_wave_sum:=true;
       maxpass:=1;
      end;

   22: begin  // if electron IN wave being modeled
       electron:=true;
       positron:=false;
       two_particles:=false;
       sine_wave_sum:=true;
       maxpass:=1;
      end;

   23: begin  // if electron OUT+IN wave being modeled
       electron:=true;
       positron:=false;
       two_particles:=false;
       sine_wave_sum:=true;
       maxpass:=1;
      end;

   24: begin  // if proton being modeled
       electron:=false;
       positron:=false;
       proton:=true;
       r_lower_limit:=ProtonComptonRadius;
       two_particles:=false;
       maxpass:=1;
      end;

   25: begin  // if neutron being modeled
       electron:=false;
       positron:=false;
       neutron:=true;
       r_lower_limit:=NeutronComptonRadius;
//       two_particle_composite:=true;
       two_particle_composite:=false;
       neutron_quarks:=true;
       sine_wave_sum:=neutron_quarks;
       two_particles:=false;
       maxpass:=1;
      end;

   26: begin  // if neutrino being modeled
       electron:=false;
       positron:=false;
       neutrino:=true;
       r_lower_limit:=ElectronNeutrinoComptonRadius;
       two_particle_composite:=false;
       neutrino_quarklets:=true;
       sine_wave_sum:=neutrino_quarklets;
       two_particles:=false;
       maxpass:=1;
      end;
  end;

  if StartOptionChanged then begin
    if (electron or positron or proton or neutron or neutrino) then begin
      if not EFormulaCheckBox.Enabled then begin
        EFormulaCheckBox.Checked:=true;
        HFormulaCheckBox.Checked:=true;
        EFormulaCheckBox.Enabled:=true;
        HFormulaCheckBox.Enabled:=true;
      end;
    end
    else begin
      EFormulaCheckBox.Checked:=false;
      HFormulaCheckBox.Checked:=false;
      EFormulaCheckBox.Enabled:=false;
      HFormulaCheckBox.Enabled:=false;
    end;

    if (proton or neutron) then begin
      // Note: at 270x270x270 GridSize, an actual width of 4E-14 (11 grid points per Compton wavelength) gives a very accurate energy calculation
      ActualGridWidth.Text:=FloatToStrf(1.5E-14,ffExponent,5,2); {display actual size in metres that grid represents}
      if (proton or neutron_quarks) then RateOfTime.Position:=3;
      ProcSetGridGlobals(Self);
      DoUpdate:=true;
      Restart:=true;
    end
    else if neutrino then begin
      // Note: at 270x270x270 a GridWidth of 142 Compton wavelengths gives a very accurate energy calculation
      if neutrino_quarklets then
        ActualGridWidth.Text:=FloatToStrf(2.0E-6,ffExponent,5,2) {display actual size in metres that grid represents}
      else
        ActualGridWidth.Text:=FloatToStrf(2.7E-5,ffExponent,5,2); {display actual size in metres that grid represents}
      RateOfTime.Position:=4000;
      New_RateOfTime:=RateOfTime.Position * 40000;
      ProcSetGridGlobals(Self);
      DoUpdate:=true;
      Restart:=true;
    end
    else begin
      // Note: at 270x270x270 GridSize, an actual width of 7.6E-11 (11 grid points per Compton wavelength) gives a very accurate energy calculation
      ActualGridWidth.Text:=FloatToStrf(3.0E-11,ffExponent,5,2); {display actual size in metres that grid represents}
      RateOfTime.Position:=4000;
      ProcSetGridGlobals(Self);
      DoUpdate:=true;
      Restart:=true;
    end;
  end;

  if maxpass=1 then progress_inc:=22;

  if two_particles then begin
    Percent_c.Visible:=false;
    DistBetweenLabel.Visible:=true;
    DistBetween.Visible:=true;
    DistBetweenUnits.Visible:=true;
    ShowEnergy_CheckBox.Visible:=true;
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
    Field11.Visible:=true;
    Field12.Visible:=true;
{$IFEND}
    if (Time = 0) then begin
      try
        PercentBetweenParticles:=strtofloat(DistBetween.Text);
        if (0 = PercentBetweenParticles) then begin
          DistBetween.Text:='50';
          PercentBetweenParticles:=strtofloat(DistBetween.Text);
        end;
        PercentBetweenParticles:=Round(PercentBetweenParticles*100)/100;
      except
        on E: Exception do begin
          PercentBetweenParticles:=30;
          DistBetween.Text:='30';
        end;
      end;
      DistFromCenter:=((PercentBetweenParticles/2)/100)*GridWidth;

      particle1_x:=GridWidth/2 - DistFromCenter;
      particle2_x:=GridWidth/2 + DistFromCenter;
      p1_p2_diff:=abs(particle2_x - particle1_x);
    end
    else begin
      p1_p2_diff:=abs(particle2_x - particle1_x);
      DistFromCenter:=p1_p2_diff/2;
      PercentBetweenParticles:=100*p1_p2_diff/GridWidth;
      PercentBetweenParticles:=Round(PercentBetweenParticles*100)/100;
      DistBetween.Text:=FloatToStrf(PercentBetweenParticles,ffFixed,4,2);
    end;
  end
  else begin
    Percent_c.Visible:=true;
    DistBetweenLabel.Visible:=false;
//    DistBetween.Visible:=false;
//    DistBetweenUnits.Visible:=false;
    ShowEnergy_CheckBox.Visible:=false;
    Field11.Visible:=false;
    Field12.Visible:=false;
  end;

  NewScreen:=0;
//  if scr=0 then NewScreen:=1 else NewScreen:=0; {determine which data to update}

  for pass := 1 to maxpass do begin
    if two_particles then begin
      if (pass = 1) then begin
        saved_sign:=particle2_spin;
        particle2_spin:=0;
      end
      else if (pass = 2) then begin
        particle2_spin:=saved_sign;
        saved_sign:=particle1_spin;
        particle1_spin:=0;
      end
      else begin
        particle1_spin:=saved_sign;
      end;
    end;

    if field_stats and (pass=1) then begin
      PsiSum:=0;
      PsiSumXpos:=0;
      PsiSumYpos:=0;
      PsiSumZpos:=0;
      PsiSumXneg:=0;
      PsiSumYneg:=0;
      PsiSumZneg:=0;
      ElectricPotentialSum_pos:=0;
      ElectricPotentialSum_neg:=0;
      ElectricPotentialSum:=0;
      ElecFieldCurl_Sum:=0;
      ElecFieldFromV_Sum:=0;
      ElecFieldFromV_SignedHalf_SumX:=0;
      ElecFieldFromA_SignedHalf_SumX:=0;
      ElecFieldGradDivPsi_SignedHalf_SumX:=0;
      ElecFieldCurlCurlPsi_SignedHalf_SumX:=0;
      ElecFieldFromA_Sum:=0;
      ElecField_Sum:=0;
      MagField_Sum:=0;
      VectorPotential_Sum:=0;
    end;

    if not Flip_YZ then begin

       midx:=Trunc(GridWidth/2);
       midy:=Trunc(GridHeight/2);
       midz:=Trunc(GridDepth/2);

       /////////////////////////////////////

       if neutrino then begin
         SpinConstant:=( Hhat / ElectronNeutrinoMass ); // Metres^2/(Radians*Second)
         delta := ( abs(ElectronCharge) * Hhat ) / ( 2 * Pi * ElectronNeutrinoMass * SpeedOfLight * Permittivity );

         // theta_const is in Radians/Second ( i.e. the same as solving E = hf for f, where E=mc^2, and h=2*Pi*Hhat,
         // then converting f to angular frequency w, via w = 2*Pi*f )
         // ( theta_const could be, equivalently : - c^2/SpinConstant )
         theta_const:=( -ElectronNeutrinoMass * sqr(SpeedOfLight) ) / Hhat;
       end
       else if proton then begin
         SpinConstant:=( Hhat / ProtonMass ); // Metres^2/(Radians*Second)
         delta := ( abs(ProtonCharge) * Hhat ) / ( 2 * Pi * ProtonMass * SpeedOfLight * Permittivity );

         // theta_const is in Radians/Second ( i.e. the same as solving E = hf for f, where E=mc^2, and h=2*Pi*Hhat,
         // then converting f to angular frequency w, via w = 2*Pi*f )
         // ( theta_const could be, equivalently : - c^2/SpinConstant )
         theta_const:=( -ProtonMass * sqr(SpeedOfLight) ) / Hhat;
       end
       else if neutron then begin
         if two_particle_composite then begin
           SpinConstant:=( Hhat / NeutronMass ); // Metres^2/(Radians*Second)
           delta1 := ( abs(ProtonCharge) * Hhat ) / ( 2 * Pi * ProtonMass * SpeedOfLight * Permittivity );
           delta2 := ( abs(ElectronCharge) * Hhat ) / ( 2 * Pi * ElectronMass * SpeedOfLight * Permittivity );

           // theta_const is in Radians/Second ( i.e. the same as solving E = hf for f, where E=mc^2, and h=2*Pi*Hhat,
           // then converting f to angular frequency w, via w = 2*Pi*f )
           // ( theta_const could be, equivalently : - c^2/SpinConstant )
           theta_const1:=( -ProtonMass * sqr(SpeedOfLight) ) / Hhat;
           theta_const2:=( -ElectronMass * sqr(SpeedOfLight) ) / Hhat;
         end
         else begin
           SpinConstant:=( Hhat / NeutronMass ); // Metres^2/(Radians*Second)
           delta := ( abs(ProtonCharge) * Hhat ) / ( 2 * Pi * NeutronMass * SpeedOfLight * Permittivity );

           // theta_const is in Radians/Second ( i.e. the same as solving E = hf for f, where E=mc^2, and h=2*Pi*Hhat,
           // then converting f to angular frequency w, via w = 2*Pi*f )
           // ( theta_const could be, equivalently : - c^2/SpinConstant )
           theta_const:=( -NeutronMass * sqr(SpeedOfLight) ) / Hhat;
         end;
       end
       else begin
         SpinConstant:=( Hhat / ElectronMass ); // Metres^2/(Radians*Second)
         delta := ( abs(ElectronCharge) * Hhat ) / ( 2 * Pi * ElectronMass * SpeedOfLight * Permittivity );

         // theta_const is in Radians/Second ( i.e. the same as solving E = hf for f, where E=mc^2, and h=2*Pi*Hhat,
         // then converting f to angular frequency w, via w = 2*Pi*f )
         // ( theta_const could be, equivalently : - c^2/SpinConstant )
         theta_const:=( -ElectronMass * sqr(SpeedOfLight) ) / Hhat;
       end;

       Application.ProcessMessages;
       if Restart then exit;

       if (pass = 1) then begin
         if (Time = 0) then begin
           if two_particles then Velocity:=0
           else particle1_x:=midx;
         end;

         if (two_particles and not ShowEnergy_CheckBox.Checked) then begin
           Edit1.Text:='Calculated Acceleration';
           Edit2.Text:='  m/s^2';

//           Energy_Msg3.Text:='Reflected Energy Components';
           Energy_Msg3.Text:='Expected Acceleration';
           Units3.text:='  m/s^2';
         end
         else begin
           Energy_Msg3.Text:='Total Energy';
           Units3.text:='  Joules';
           Edit2.Text:='  Joules';

{
           if (Time = 0) then begin

             Edit1.Text:='Total Energy  (Integrated)   ';
             Edit2.Text:='  Joules';

             Energy_Msg3.Text:='Total Energy';

             Etotal:=0;
             ShellThickness:=5E-15;

             for dist := 1 to 1000000000 do begin
               r:=dist*ShellThickness;

               term1:=ElectronCharge/(4*Pi*sqr(r)*Permittivity);

               // Twice the Electric Field energy (the Energy in the Magnetic field is equal to that in the Electric field
               // for a wave that satisfies the Classical Wave Equation).
               Etotal:=Etotal + 2*ShellThickness*(4*Pi*sqr(r)) * 0.5*Permittivity*sqr(term1);
             end;
           end;
}
         end;
       end;

       if neutrino then
         Etotal:=ElectronNeutrinoMass*sqr(SpeedOfLight)
       else if proton then
         Etotal:=(Permeability*sqr(SpeedOfLight) + 1/Permittivity)*sqr(ProtonCharge)/(8*Pi*ProtonClassicalRadius)
       else if neutron then begin
         if two_particle_composite then begin
           Etotal:=(Permeability*sqr(SpeedOfLight) + 1/Permittivity)*sqr(ProtonCharge)/(8*Pi*ProtonClassicalRadius);
           Etotal:=Etotal + (Permeability*sqr(SpeedOfLight) + 1/Permittivity)*sqr(ElectronCharge)/(8*Pi*ElectronClassicalRadius);
         end
         else begin
           Etotal:=NeutronMass*sqr(SpeedOfLight)
         end;
       end
       else
         Etotal:=(Permeability*sqr(SpeedOfLight) + 1/Permittivity)*sqr(ElectronCharge)/(8*Pi*ElectronClassicalRadius);

       if two_particles then Etotal := 2*Etotal;

       if not two_particles or ShowEnergy_CheckBox.Checked then begin
         // According to QM
         // See:  https://paradox-paradigm.nl/preface/the-equivalence-of-magnetic-and-kinetic-energy/the-moving-electron-and-magnetic-energy/
         Edit1.Text:='Actual Rest Energy   ';
         Energy4.Text:=FloatToStr(Etotal); {display total H field energy}
       end;

       //
       // Thus Total Electron Wave Equation (Ye) is:
       //
       // Ye = ((Qe*Hhat) / (2*Pi*r*i*Me*c*Eo )) * Exp( ( - i * Me * c^2 / Hhat ) * ( T – r/c ) )
       //
       // and the Electric Potential div(psi) in spherical coordinates is
       //
       // V = (Qe / ( 2 * Pi * r * Me * c * Eo )) * (Me * c * r – i * Hhat) *  Exp( ( - i * Me * c^2 / Hhat ) * ( T – r/c ) )
       //
       // Where:
       // Ye is Electron Wave Function (psi)
       // Qe is Electron's Charge
       // Pi is 3.14159 etc
       // Eo is the Permittivity of free space
       // Exp is the Exponential function
       // i is the Complex number (square root of -1)
       // Me is the Mass of an Electron
       // c is the speed of light
       // Hhat is the reduced Plancks constant ( i.e. h/(2*Pi) )
       // T is Time
       // r is the radial distance from the center of the Electron
       //
       // exp(-theta) = cos(theta) - isin(theta)
       // using x,y,z coordinates:
       // x = cos(theta)
       // y = sin(theta)

       // theta:=theta_const*(Time - k*r*r/2);
       //
       // term1:=delta/r
       //
       // term2:=cos(theta);
       // term3:=-sin(theta);
       //
       // if ( ViewTop ) then begin // Assign values to x, y, z coordinates, depending on view from the top or side.
       //   x:=term1 * term2;
       //   y:=term1 * term3;
       //   z:=0;
       // end
       // else begin
       //   x:=term1 * term2;
       //   y:=0;
       //   z:=term1 * term3;
       // end;

       Application.ProcessMessages;
       if Restart then exit;

       progress:=progress + progress_inc;
       update_progress_bar(progress);

       /////////////////////////////////////
       for xpos:=0 to GridWidth-1 do begin {scan grid's x coords}
         Application.ProcessMessages;
         if Restart then exit;

         for ypos:=0 to GridHeight-1 do begin {scan grid's y coords}
           for zpos:=0 to GridDepth-1 do begin {scan grid's z coords}
             ThisGroup:=PointGroup(scr, xpos, ypos, zpos);

             x:= xpos - midx;
             y:= ypos - midy;
             z:= zpos - midz;

             if two_particles then begin
               // get actual distance in metres
               r1:=sqrt( sqr((xpos - particle1_x)*dx) + sqr(y*dy) + sqr(z*dz) );
               if ( r1 < r_lower_limit ) then r1:=r_lower_limit;   // prevent divide by zero errors

               // get actual distance in metres
               r2:=sqrt( sqr((xpos - particle2_x)*dx) + sqr(y*dy) + sqr(z*dz) );
               if ( r2 < r_lower_limit ) then r2:=r_lower_limit;   // prevent divide by zero errors
             end
             else begin
               r:=sqrt( sqr(x*dx) + sqr(y*dy) + sqr(z*dz) );
               if ( r < r_lower_limit ) then r:=r_lower_limit;   // prevent divide by zero errors

               velocity := SpeedOfLight*(strtofloat(DistBetween.Text)/100);
               gamma := 1/(sqrt(1 - sqr(velocity)/sqr(SpeedOfLight)));

               x_contracted := (x*dx)/gamma;

               r_contracted:=sqrt( sqr(x_contracted) + sqr(y*dy) + sqr(z*dz) );
               if ( r_contracted < r_lower_limit ) then r_contracted:=r_lower_limit;   // prevent divide by zero errors

               r_gamma:=sqrt( sqr((x*dx)*gamma) + sqr(y*dy) + sqr(z*dz) );
               if ( r_gamma < r_lower_limit ) then r_gamma:=r_lower_limit;   // prevent divide by zero errors

               x_sign := 1;
               if (xpos < midx) then x_sign := -x_sign;
               x_velocity := sqrt(sqr(x*dx)/sqr(r))*x_sign*velocity;
             end;

             /////////////////////////////////////
             /// WAVE FUNCTION TO TEST
             ///
             ///
             case StartOption of
               1: begin  // if electron being modeled
                   theta:=theta_const*(Time - r/(SpeedOfLight + x_velocity));
                   term1:=sign(ElectronCharge) * delta/r_gamma;
               end;

               2: begin  // if positron being modeled
                   theta:=theta_const*(Time + r/(SpeedOfLight + x_velocity));
                   term1:=sign(PositronCharge) * delta/r_gamma;
               end;

               3: begin  // if two electrons being modeled
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time - r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(ElectronCharge) * delta/r2;
               end;

               4: begin  // if two positrons being modeled
                   theta1:=particle1_spin*theta_const*(Time + r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(PositronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               5: begin  // if an electron and a positron being modeled
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               6: begin  // if two electrons being modeled orthogonally
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time - r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(ElectronCharge) * delta/r2;
               end;

               7: begin  // if two positrons being modeled orthogonally
                   theta1:=particle1_spin*theta_const*(Time + r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(PositronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               8: begin  // if an electron and a positron being modeled orthogonally
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               9: begin  // if two electrons being modeled orthogonally - reversed 2nd axis
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time - r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(ElectronCharge) * delta/r2;
               end;

               10: begin  // if two positrons being modeled orthogonally - reversed 2nd axis
                   theta1:=particle1_spin*theta_const*(Time + r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(PositronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               11: begin  // if an electron and a positron being modeled orthogonally - reversed 2nd axis
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               12: begin  // if two electrons being modeled spins end to end
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time - r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(ElectronCharge) * delta/r2;
               end;

               13: begin  // if two positrons being modeled spins end to end
                   theta1:=particle1_spin*theta_const*(Time + r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(PositronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               14: begin  // if an electron and a positron being modeled spins end to end
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               15: begin  // if two electrons being modeled spins end to end - reversed 2nd axis
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time - r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(ElectronCharge) * delta/r2;
               end;

               16: begin  // if two positrons being modeled spins end to end - reversed 2nd axis
                   theta1:=particle1_spin*theta_const*(Time + r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(PositronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               17: begin  // if an electron and a positron being modeled spins end to end - reversed 2nd axis
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               18: begin  // if two electrons being modeled spins opposite - reversed 2nd spin axis
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time - r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(ElectronCharge) * delta/r2;
               end;

               19: begin  // if two positrons being modeled spins opposite - reversed 2nd spin axis
                   theta1:=particle1_spin*theta_const*(Time + r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(PositronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               20: begin  // if an electron and a positron being modeled spins opposite - reversed 2nd spin axis
                   theta1:=particle1_spin*theta_const*(Time - r1/SpeedOfLight);
                   theta2:=particle2_spin*theta_const*(Time + r2/SpeedOfLight);
                   term1a:=sign(ElectronCharge) * delta/r1;
                   term1b:=sign(PositronCharge) * delta/r2;
               end;

               21: begin  // if electron OUT wave being modeled
                   term1:=sign(ElectronCharge) * delta/r_gamma;

                   // X coordinate terms
                   term2:=0;

                   // each IN/OUT wave component is only half the wave-function amplitude
                   if not CheckBox4.Checked then term2:=term2 + 0.5*Cos(theta_const*(-Time + r/(SpeedOfLight - x_velocity)));  // IN   y2
                   //if not CheckBox5.Checked then term2:=term2 + 0.5*Cos(theta_const*(Time + r/(SpeedOfLight - x_velocity)));   // IN   y1
                   //if not CheckBox6.Checked then term2:=term2 - 0.5*Cos(theta_const*(Time + r/(SpeedOfLight - x_velocity)));   // IN   y5
                   if not CheckBox7.Checked then term2:=term2 + 0.5*Cos(theta_const*(-Time + r/(SpeedOfLight + x_velocity)));  // OUT  y6

                   // Y coordinate terms
                   term3:=0;
                   if not CheckBox8.Checked then term3:=term3 - 0.5*Sin(theta_const*(Time + r/(SpeedOfLight + x_velocity)));   // OUT  y7
                   if not CheckBox9.Checked then term3:=term3 - 0.5*Sin(theta_const*(-Time + r/(SpeedOfLight + x_velocity)));  // OUT  y3
                   if not CheckBox10.Checked then term3:=term3 - 0.5*Sin(theta_const*(-Time + r/(SpeedOfLight + x_velocity))); // OUT  y8
                   if not CheckBox11.Checked then term3:=term3 + 0.5*Sin(theta_const*(Time + r/(SpeedOfLight - x_velocity)));  // IN   y4

                   if FrameCount > 30 then begin
                     CheckBox1.Checked:=false;
                     save_frames:=false;
                   end;
               end;

               22: begin  // if electron IN wave being modeled
                   term1:=sign(ElectronCharge) * delta/r_gamma;

                   // X coordinate terms
                   term2:=0;

                   // each IN/OUT wave component is only half the wave-function amplitude
                   if CheckBox4.Checked then term2:=term2 + 0.5*Cos(theta_const*(-Time + r/(SpeedOfLight - x_velocity)));  // IN   y2
                   //if CheckBox5.Checked then term2:=term2 + 0.5*Cos(theta_const*(Time + r/(SpeedOfLight - x_velocity)));   // IN   y1
                   //if CheckBox6.Checked then term2:=term2 - 0.5*Cos(theta_const*(Time + r/(SpeedOfLight - x_velocity)));   // IN   y5
                   if CheckBox7.Checked then term2:=term2 + 0.5*Cos(theta_const*(-Time + r/(SpeedOfLight + x_velocity)));  // OUT  y6

                   // Y coordinate terms
                   term3:=0;
                   if CheckBox8.Checked then term3:=term3 - 0.5*Sin(theta_const*(Time + r/(SpeedOfLight + x_velocity)));   // OUT  y7
                   if CheckBox9.Checked then term3:=term3 - 0.5*Sin(theta_const*(-Time + r/(SpeedOfLight + x_velocity)));  // OUT  y3
                   if CheckBox10.Checked then term3:=term3 - 0.5*Sin(theta_const*(-Time + r/(SpeedOfLight + x_velocity))); // OUT  y8
                   if CheckBox11.Checked then term3:=term3 + 0.5*Sin(theta_const*(Time + r/(SpeedOfLight - x_velocity)));  // IN   y4

                   if FrameCount > 30 then begin
                     CheckBox1.Checked:=false;
                     save_frames:=false;
                   end;
               end;

               23: begin  // if electron OUT+IN wave being modeled
                   term1:=sign(ElectronCharge) * delta/r_gamma;

                   // X coordinate terms
                   term2:=0;

                   // each IN/OUT wave component is only half the wave-function amplitude
                   term2:=term2 + 0.5*Cos(theta_const*(-Time + r/(SpeedOfLight - x_velocity)));  // IN   y2
                   //term2:=term2 + 0.5*Cos(theta_const*(Time + r/(SpeedOfLight - x_velocity)));   // IN   y1
                   //term2:=term2 - 0.5*Cos(theta_const*(Time + r/(SpeedOfLight - x_velocity)));   // IN   y5
                   term2:=term2 + 0.5*Cos(theta_const*(-Time + r/(SpeedOfLight + x_velocity)));  // OUT  y6

                   // Y coordinate terms
                   term3:=0;
                   term3:=term3 - 0.5*Sin(theta_const*(Time + r/(SpeedOfLight + x_velocity)));   // OUT  y7
                   term3:=term3 - 0.5*Sin(theta_const*(-Time + r/(SpeedOfLight + x_velocity)));  // OUT  y3
                   term3:=term3 - 0.5*Sin(theta_const*(-Time + r/(SpeedOfLight + x_velocity)));  // OUT  y8
                   term3:=term3 + 0.5*Sin(theta_const*(Time + r/(SpeedOfLight - x_velocity)));   // IN   y4

                   if FrameCount > 30 then begin
                     CheckBox1.Checked:=false;
                     save_frames:=false;
                   end;
               end;

               24: begin  // if proton being modeled
                   theta:=theta_const*(Time + r/(SpeedOfLight + x_velocity));
                   term1:=sign(ProtonCharge) * delta/r_gamma;
               end;

               25: begin  // if neutron being modeled
                   if two_particle_composite then begin
                     theta1:=theta_const1*(Time + r/(SpeedOfLight + x_velocity));
                     theta2:=theta_const2*(Time - r/(SpeedOfLight + x_velocity));
                     term1a:=sign(ProtonCharge) * delta1/r_gamma;
                     term1b:=sign(ElectronCharge) * delta2/r_gamma;
                   end
                   else if neutron_quarks then begin
                     // IN component of Proton wave-function  = 2 UP Quarks (IN)
                     // OUT component of Proton wave-function = 1 DOWN Quark (OUT)
                     //
                     // In Neutron wave-function we have 1 UP & 2 DOWN Quarks, so:
                     // Neutron wave components:  IN = IN(Proton)/2 + OUT(Proton)*2

                     term1:=delta/r_gamma;

                     // X coordinate terms
                     term2:=0;

                     // each IN/OUT wave component is only half the wave-function amplitude
                     term2:=term2 + 2.0 * 0.5*Cos(theta_const*(-Time - r/(SpeedOfLight + x_velocity)));  // OUT   y2
                     //term2:=term2 + 2.0 * 0.5*Cos(theta_const*(Time - r/(SpeedOfLight + x_velocity)));   // OUT   y1
                     //term2:=term2 - 2.0 * 0.5*Cos(theta_const*(Time - r/(SpeedOfLight + x_velocity)));   // OUT   y5
                     term2:=term2 + 0.5 * 0.5*Cos(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));  // IN  y6

                     // Y coordinate terms
                     term3:=0;
                     term3:=term3 - 0.5 * 0.5*Sin(theta_const*(Time - r/(SpeedOfLight - x_velocity)));   // IN  y7
                     term3:=term3 - 0.5 * 0.5*Sin(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));  // IN  y3
                     term3:=term3 - 0.5 * 0.5*Sin(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));  // IN  y8
                     term3:=term3 + 2.0 * 0.5*Sin(theta_const*(Time - r/(SpeedOfLight + x_velocity)));   // OUT   y4

                     // Alternate (equivalent) formulation
                     if false then begin
                       // X coordinate terms
                       term2:=0;
                       term2:=term2 + 2*(1/2)*Cos(theta_const*(-Time - r/(SpeedOfLight + x_velocity)));  // DOWN
                       term2:=term2 + (1/4)*Cos(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));    // UP

                       // Y coordinate terms
                       term3:=0;
                       term3:=term3 - 2*(1/2)*Sin(theta_const*(-Time + r/(SpeedOfLight + x_velocity)));  // DOWN
                       term3:=term3 - (1/2)*Sin(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));    // UP
                       term3:=term3 + (1/4)*Sin(theta_const*(-Time + r/(SpeedOfLight - x_velocity)));    // UP
                     end;
                   end
                   else begin
                     theta:=theta_const*Time;
                     term1:=delta/r_gamma;
                   end;

                   if FrameCount > 44 then begin
                     CheckBox1.Checked:=false;
                     save_frames:=false;
                   end;
               end;

               26: begin  // if electron neutrino being modeled
                  if neutrino_quarklets then begin
                    // IN component of Proton wave-function  = 2 UP Quarks (IN)
                    // OUT component of Proton wave-function = 1 DOWN Quark (OUT)
                    //
                    // In Neutrino wave-function we have 1 UP & 2 DOWN Quarklets, so:
                    // Neutrino wave components:  IN = IN(Proton)/2 + OUT(Proton)*2

                    term1:=delta/r_gamma;

                    // X coordinate terms
                    term2:=0;

                    // each IN/OUT wave component is only half the wave-function amplitude
                    term2:=term2 + 2.0 * 0.5*Cos(theta_const*(-Time - r/(SpeedOfLight + x_velocity)));  // OUT   y2
                    //term2:=term2 + 2.0 * 0.5*Cos(theta_const*(Time - r/(SpeedOfLight + x_velocity)));   // OUT   y1
                    //term2:=term2 - 2.0 * 0.5*Cos(theta_const*(Time - r/(SpeedOfLight + x_velocity)));   // OUT   y5
                    term2:=term2 + 0.5 * 0.5*Cos(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));  // IN  y6

                    // Y coordinate terms
                    term3:=0;
                    term3:=term3 - 0.5 * 0.5*Sin(theta_const*(Time - r/(SpeedOfLight - x_velocity)));   // IN  y7
                    term3:=term3 - 0.5 * 0.5*Sin(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));  // IN  y3
                    term3:=term3 - 0.5 * 0.5*Sin(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));  // IN  y8
                    term3:=term3 + 2.0 * 0.5*Sin(theta_const*(Time - r/(SpeedOfLight + x_velocity)));   // OUT   y4

                    // Alternate (equivalent) formulation
                    if false then begin
                      // X coordinate terms
                      term2:=0;
                      term2:=term2 + 2*(1/2)*Cos(theta_const*(-Time - r/(SpeedOfLight + x_velocity)));  // DOWN
                      term2:=term2 + (1/4)*Cos(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));    // UP

                      // Y coordinate terms
                      term3:=0;
                      term3:=term3 - 2*(1/2)*Sin(theta_const*(-Time + r/(SpeedOfLight + x_velocity)));  // DOWN
                      term3:=term3 - (1/2)*Sin(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));    // UP
                      term3:=term3 + (1/4)*Sin(theta_const*(-Time + r/(SpeedOfLight - x_velocity)));    // UP
                    end;
                  end
                  else begin
                    theta:=theta_const*Time;
                    term1:=delta/r_gamma;
                  end;

                  if FrameCount > 236 then begin
                    CheckBox1.Checked:=false;
                    save_frames:=false;
                  end;
               end;
             end;

             if not sine_wave_sum then begin
               if (two_particles or two_particle_composite) then begin
                 SinCos(theta1, term3a, term2a);
                 SinCos(theta2, term3b, term2b);

                 // Note: the absolute value of the particle spin is used as the spin can take values of -1, 0 +1.
                 //       When it is 0 that particle is excluded from the calculation.
                 term1a := abs(particle1_spin)*term1a;
                 term1b := abs(particle2_spin)*term1b;

                 psi_x_particle1 := term1a * term2a;
                 psi_y_particle1 := term1a * term3a;
                 psi_z_particle1 := 0;

                 psi_x_particle2 := term1b * term2b;
                 psi_y_particle2 := term1b * term3b;
                 psi_z_particle2 := 0;
               end
               else begin
                 SinCos(theta, term3, term2);
               end;
             end;

             if not (two_particles or two_particle_composite) then begin
               psi_x := term1 * term2;
               psi_y := term1 * term3;
               psi_z := 0;
             end;

             // Assign values to x, y, z coordinates, depending on view from the top or side.
             with points[NewScreen]^[xpos,ypos,zpos].PsiVect do begin
               if (two_particles or two_particle_composite) then begin
                 if ( ViewTop ) then begin
                   if orthogonal_particles then begin
                     // x1' = x1
                     // y1' = y1
                     // z1' = z1
                     // x2' = z2
                     // y2' = y2
                     // z2' = -x2
                     x:=psi_x_particle1 + psi_z_particle2;
                     y:=psi_y_particle1 + psi_y_particle2;
                     z:=psi_z_particle1 - psi_x_particle2;
                   end
                   else if particles_end_to_end then begin
                     // x1' = z1
                     // y1' = y1
                     // z1' = -x1
                     // x2' = z2
                     // y2' = y2
                     // z2' = -x2
                     x:=psi_z_particle1 + psi_z_particle2;
                     y:=psi_y_particle1 + psi_y_particle2;
                     z:=-psi_x_particle1 - psi_x_particle2;
                   end
                   else begin
                     x:=psi_x_particle1 + psi_x_particle2;
                     y:=psi_y_particle1 + psi_y_particle2;
                     z:=psi_z_particle1 + psi_z_particle2;
                   end;
                 end
                 // If not 'view from top', then 'view from side' & screen axes are x & z, so z axis takes y component & y takes the z axis.
                 else begin
                   if orthogonal_particles then begin
                     // x1' = x1
                     // y1' = y1 -> z1
                     // z1' = z1 -> y1
                     // x2' = y2 -> z2
                     // y2' = -x2
                     // z2' = z2 -> y2
                     x:=psi_x_particle1 + psi_z_particle2;  // x1' + x2'
                     y:=psi_z_particle1 - psi_x_particle2;  // y1' + y2'
                     z:=psi_y_particle1 + psi_y_particle2;  // z1' + z2'
                   end
                   else if particles_end_to_end then begin
                     // x1' = y1 -> z1
                     // y1' = -x1
                     // z1' = z1 -> y1
                     // x2' = y2 -> z2
                     // y2' = -x2
                     // z2' = z2 -> y2
                     x:=psi_z_particle1 + psi_z_particle2;  // x1' + x2'
                     y:=-psi_x_particle1 - psi_x_particle2; // y1' + y2'
                     z:=psi_y_particle1 + psi_y_particle2;  // z1' + z2'
                   end
                   else begin
                     x:=psi_x_particle1 + psi_x_particle2;
                     y:=psi_z_particle1 + psi_z_particle2;
                     z:=psi_y_particle1 + psi_y_particle2;
                   end;
                 end;
                 points[NewScreen]^[xpos,ypos,zpos].Psi := term1a + term1b;
               end
               else begin
                 if ( ViewTop ) then begin
                   x:=psi_x;
                   y:=psi_y;
                   z:=psi_z;
                 end
                 else begin
                   x:=psi_x;
                   y:=psi_z;
                   z:=psi_y;
                 end;
                 points[NewScreen]^[xpos,ypos,zpos].Psi := term1;
               end;
             end;

             if field_stats and (pass=1) then begin
               PsiSum:=PsiSum + VectSize(points[NewScreen]^[xpos,ypos,zpos].PsiVect);
               if (points[NewScreen]^[xpos,ypos,zpos].PsiVect.x > 0) then PsiSumXpos:=PsiSumXpos + points[NewScreen]^[xpos,ypos,zpos].PsiVect.x;
               if (points[NewScreen]^[xpos,ypos,zpos].PsiVect.y > 0) then PsiSumYpos:=PsiSumYpos + points[NewScreen]^[xpos,ypos,zpos].PsiVect.y;
               if (points[NewScreen]^[xpos,ypos,zpos].PsiVect.z > 0) then PsiSumZpos:=PsiSumZpos + points[NewScreen]^[xpos,ypos,zpos].PsiVect.z;
               if (points[NewScreen]^[xpos,ypos,zpos].PsiVect.x < 0) then PsiSumXneg:=PsiSumXneg + points[NewScreen]^[xpos,ypos,zpos].PsiVect.x;
               if (points[NewScreen]^[xpos,ypos,zpos].PsiVect.y < 0) then PsiSumYneg:=PsiSumYneg + points[NewScreen]^[xpos,ypos,zpos].PsiVect.y;
               if (points[NewScreen]^[xpos,ypos,zpos].PsiVect.z < 0) then PsiSumZneg:=PsiSumZneg + points[NewScreen]^[xpos,ypos,zpos].PsiVect.z;
             end;

             ///
             ///
             /////////////////////////////////////

           end;
         end;
       end;   // end {scan grid's x coords}

       Application.ProcessMessages;
       if Restart then exit;

       progress:=progress + progress_inc;
       update_progress_bar(progress);

       for xpos:=0 to GridWidth-1 do begin {scan grid's x coords}
         Application.ProcessMessages;
         if Restart then exit;

         for ypos:=0 to GridHeight-1 do begin {scan grid's y coords}
           for zpos:=0 to GridDepth-1 do begin {scan grid's z coords}

             ThisGroup:=PointGroup(scr, xpos, ypos, zpos);
             NewGroup:=PointGroup(NewScreen, xpos, ypos, zpos);

             with points[NewScreen]^[xpos,ypos,zpos] do begin
               if (smoothing) then begin
                 x:= xpos - midx;
                 y:= ypos - midy;
                 z:= zpos - midz;

                 if two_particles then begin
                   // get actual distance in metres
                   r1:=sqrt( sqr((xpos - particle1_x)*dx) + sqr(y*dy) + sqr(z*dz) );
                   if ( r1 < r_lower_limit ) then r1:=r_lower_limit;   // prevent divide by zero errors

                   // get actual distance in metres
                   r2:=sqrt( sqr((xpos - particle2_x)*dx) + sqr(y*dy) + sqr(z*dz) );
                   if ( r2 < r_lower_limit ) then r2:=r_lower_limit;   // prevent divide by zero errors

                   ElectricPotential:=0;

                   if (pass=1) or (pass=3) then begin
                     if electron then
                       ElectricPotential:=ElectricPotential + abs(particle1_spin)*ElectronCharge/(4*Pi*r1*Permittivity)
                     else if positron then
                       ElectricPotential:=ElectricPotential + abs(particle1_spin)*PositronCharge/(4*Pi*r1*Permittivity)
                     else if proton then
                       ElectricPotential:=ElectricPotential + abs(particle1_spin)*ProtonCharge/(4*Pi*r1*Permittivity)
                     else if neutron then
                       ElectricPotential:=ElectricPotential + abs(particle1_spin)*NeutronCharge/(4*Pi*r1*Permittivity);
                   end;

                   if (pass=2) or (pass=3) then begin
                     if positron then
                       ElectricPotential:=ElectricPotential + abs(particle2_spin)*PositronCharge/(4*Pi*r2*Permittivity)
                     else if electron then
                       ElectricPotential:=ElectricPotential + abs(particle2_spin)*ElectronCharge/(4*Pi*r2*Permittivity)
                     else if proton then
                       ElectricPotential:=ElectricPotential + abs(particle2_spin)*ProtonCharge/(4*Pi*r1*Permittivity)
                     else if neutron then
                       ElectricPotential:=ElectricPotential + abs(particle2_spin)*NeutronCharge/(4*Pi*r1*Permittivity);
                   end;
                 end
                 else begin
                   // get actual distance in metres
                   r:=sqrt( sqr(x*dx) + sqr(y*dy) + sqr(z*dz) );
                   if ( r < r_lower_limit ) then r:=r_lower_limit;   // prevent divide by zero errors

                   if electron then
                     ElectricPotential:=ElectronCharge/(4*Pi*r*Permittivity)
                   else if positron then
                     ElectricPotential:=PositronCharge/(4*Pi*r*Permittivity)
                   else if proton then
                     ElectricPotential:=ProtonCharge/(4*Pi*r*Permittivity)
                   else if neutron then
                     ElectricPotential:=NeutronCharge/(4*Pi*r*Permittivity);
                 end;
               end
               else begin
                 // Curl of Psi Vector Field
                 VectGrp:=VectorGroup(NewGroup, PSI_VECTOR_FIELD);
                 PsiCurlVect:=VectCurl(VectGrp);
                 // Div of Psi Vector Field
                 ElectricPotential:=VectDiv(VectGrp);
               end;

               if field_stats and (pass=1) then begin
                 if (ElectricPotential > 0) then ElectricPotentialSum_pos:=ElectricPotentialSum_pos + ElectricPotential;
                 if (ElectricPotential < 0) then ElectricPotentialSum_neg:=ElectricPotentialSum_neg + ElectricPotential;
               end;
             end;
           end;
         end;
       end; // end {scan grid's x coords}

       if field_stats then ElectricPotentialSum:=ElectricPotentialSum_pos + ElectricPotentialSum_neg;

       Application.ProcessMessages;
       if Restart then exit;

       progress:=progress + progress_inc;
       update_progress_bar(progress);

       for xpos:=0 to GridWidth-1 do begin {scan grid's x coords}
         Application.ProcessMessages;
         if Restart then exit;

         for ypos:=0 to GridHeight-1 do begin {scan grid's y coords}
           for zpos:=0 to GridDepth-1 do begin {scan grid's z coords}

             ThisGroup:=PointGroup(scr, xpos, ypos, zpos);
             NewGroup:=PointGroup(NewScreen, xpos, ypos, zpos);

             { ThisGroup's points are assigned as follows:                         P3                  P5
                                                                                P1 P0 P2
                                                                                   P4            P6
             Where P5 & P6 are in the Z plane (P5 at the back and P6 at the front) }

             x:= xpos - midx;
             y:= ypos - midy;
             z:= zpos - midz;

             if (not smoothing) then begin
               // Curl of Psi Vector Potential Field
               VectGrp:=VectorGroup(NewGroup, PSI_CURL_VECTOR_FIELD);
               CurlVect:=VectCurl(VectGrp);
               if field_stats and (pass=1) then ElecFieldCurl_Sum:= ElecFieldCurl_Sum + VectSize(CurlVect);
             end;

             // Electric Field is: Grad(Div(Psi)) - d/dt of Vector Potential field
             Scalar_Group:=ScalarGroup(NewGroup, ELECTRIC_POTENTIAL_FIELD);

             // This is the Vector Laplacian of Psi, which is -grad of ElectricPotential minus dA/dt.
             // As Cartesian coordinates are being used, the Vector Laplacian is calculated as the
             // Scalar Laplacian on each x,y,z coordinate.
             // (will add the rest of the Electric field definition once the Vector Potential is known)
             // E = -grad(div(Psi)) - dA/dt
             vect:=ScalarGrad(Scalar_Group);

             // This is -grad(div(Psi))
             with ElecFieldFromV do begin
               x:= -vect.x;
               y:= -vect.y;
               z:= -vect.z;
             end;

             if field_stats and (pass=1) then begin
               ElecFieldFromV_Sum:= ElecFieldFromV_Sum + VectSize(ElecFieldFromV);

               if (xpos <= particle1_x) then begin
                 ElecFieldFromV_SignedHalf_SumX:= ElecFieldFromV_SignedHalf_SumX + ElecFieldFromV.x;
                 ElecFieldGradDivPsi_SignedHalf_SumX:= ElecFieldGradDivPsi_SignedHalf_SumX + vect.x;
                 ElecFieldCurlCurlPsi_SignedHalf_SumX:= ElecFieldCurlCurlPsi_SignedHalf_SumX + CurlVect.x;
               end;
             end;

             // From Schrodinger's wave equation:
             // d(psi)/dt = i * Hhat/ElectronMass * Laplacian(psi)
             //
             // Note: div(V) = Laplacian(psi)
             // SpinConstant = Hhat/ElectronMass
             //
             // So…
             // d(psi)/dt = i*SpinConstant*div(V)
             //
             // VectorPotential = (1/c^2)*d(psi)/dt
             //
             // A is orthogonal to and proportional to the div(V) vector
             // (multiplying by i rotates the vector 90 degrees in the complex plane).
             // so use the Normal vector to the div(V) vector and the Static Electric field amplitude (E_amp).

             with points[NewScreen]^[xpos,ypos,zpos].VectorPotential do begin
               if (smoothing) then begin
                 // get amplitude of Static Electric field component
                 E_amp:=VectSize(ElecFieldFromV);
                 if ( E_amp < 0.00000000000001 ) then E_amp:=0.00000000000001;   // prevent divide by zero errors

                 // Calculate the Unit & Normal vectors of the div(V) vector (depending on view from top or side)
                 with ElecFieldFromV do begin
                   unit_x:= x/E_amp;
                   unit_y:= y/E_amp;
                   unit_z:= z/E_amp;

                   if ( ViewTop ) then begin
                      normal_x:=unit_y;
                      normal_y:=-unit_x;
                      normal_z:=unit_z;
                   end
                   else begin
                      normal_x:=unit_z;
                      normal_y:=unit_y;
                      normal_z:=-unit_x;
                   end;
                 end;

                 x := normal_x*SpinConstant*E_amp/sqr(SpeedOfLight);
                 y := normal_y*SpinConstant*E_amp/sqr(SpeedOfLight);
                 z := normal_z*SpinConstant*E_amp/sqr(SpeedOfLight);
               end
               else begin
                 // Rotation Matrix, multiplying by i (viewed from the top):
                 //
                 // x' = -y
                 // y' = x
                 // z' = z
                 //
                 // But when viewed from the side z and y are swapped, so:
                 //
                 // x' = -z
                 // y' = y
                 // z' = x

                 // A = - (1/c^2)*dYe/dt = -i*(Me/Hhat)*Ye
                 if ( ViewTop ) then begin
                   if neutrino then begin
                     x := -(-(ElectronNeutrinoMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                     y := -((ElectronNeutrinoMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                     z := -((ElectronNeutrinoMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                   end
                   else if proton then begin
                     x := -(-(ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                     y := -((ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                     z := -((ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                   end
                   else if neutron then begin
                     if two_particle_composite then begin
                       x := -(-(ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                       y := -((ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                       z := -((ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                       x := x -(-(ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                       y := y -((ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                       z := z -((ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                     end
                     else begin
                       x := -(-(NeutronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                       y := -((NeutronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                       z := -((NeutronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                     end;
                   end
                   else begin
                     x := -(-(ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                     y := -((ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                     z := -((ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                   end;
                 end
                 else begin
                   if neutrino then begin
                     x := -(-(ElectronNeutrinoMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                     y := -((ElectronNeutrinoMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                     z := -((ElectronNeutrinoMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                   end
                   else if proton then begin
                     x := -(-(ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                     y := -((ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                     z := -((ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                   end
                   else if neutron then begin
                     if two_particle_composite then begin
                       x := -(-(ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                       y := -((ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                       z := -((ProtonMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                       x := x -(-(ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                       y := y -((ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                       z := z -((ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                     end
                     else begin
                       x := -(-(NeutronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                       y := -((NeutronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                       z := -((NeutronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                     end;
                   end
                   else begin
                     x := -(-(ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z);
                     y := -((ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y);
                     z := -((ElectronMass/Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x);
                   end;
                 end;
               end;
             end;

             if field_stats and (pass=1) then VectorPotential_Sum:= VectorPotential_Sum + VectSize(points[NewScreen]^[xpos,ypos,zpos].VectorPotential);

//             PrevVectorPotential:= points[scr]^[xpos,ypos,zpos].VectorPotential;

             if two_particles then begin
               if (pass=1) then begin
                 PrevVectorPotential:=particle1_A[xpos,ypos,zpos];
               end
               else if (pass=2) then begin
                 PrevVectorPotential:=particle2_A[xpos,ypos,zpos];
               end;
             end
             else begin
               PrevVectorPotential:=particle1_A[xpos,ypos,zpos];
             end;

             if (smoothing) then begin
               ElecFieldFromA.x := (1/TimeStep)*(points[NewScreen]^[xpos,ypos,zpos].VectorPotential.x - PrevVectorPotential.x);
               ElecFieldFromA.y := (1/TimeStep)*(points[NewScreen]^[xpos,ypos,zpos].VectorPotential.y - PrevVectorPotential.y);
               ElecFieldFromA.z := (1/TimeStep)*(points[NewScreen]^[xpos,ypos,zpos].VectorPotential.z - PrevVectorPotential.z);
             end
             else begin
               // dA/dt = -(Me*c/Hhat)^2*Ye
               if neutrino then begin
                 ElecFieldFromA.x := -sqr(ElectronNeutrinoMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x;
                 ElecFieldFromA.y := -sqr(ElectronNeutrinoMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y;
                 ElecFieldFromA.z := -sqr(ElectronNeutrinoMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z;
               end
               else if proton then begin
                 ElecFieldFromA.x := -sqr(ProtonMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x;
                 ElecFieldFromA.y := -sqr(ProtonMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y;
                 ElecFieldFromA.z := -sqr(ProtonMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z;
               end
               else if neutron then with ElecFieldFromA do begin
                 if two_particle_composite then begin
                   x := -sqr(ProtonMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x;
                   y := -sqr(ProtonMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y;
                   z := -sqr(ProtonMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z;
                   x := x -sqr(ElectronMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x;
                   y := y -sqr(ElectronMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y;
                   z := z -sqr(ElectronMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z;
                 end
                 else begin
                   ElecFieldFromA.x := -sqr(NeutronMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x;
                   ElecFieldFromA.y := -sqr(NeutronMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y;
                   ElecFieldFromA.z := -sqr(NeutronMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z;
                 end;
               end
               else begin
                 ElecFieldFromA.x := -sqr(ElectronMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.x;
                 ElecFieldFromA.y := -sqr(ElectronMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.y;
                 ElecFieldFromA.z := -sqr(ElectronMass * SpeedOfLight / Hhat)*points[NewScreen]^[xpos,ypos,zpos].PsiVect.z;
               end;
             end;

             if field_stats and (pass=1) then begin
               ElecFieldFromA_Sum:= ElecFieldFromA_Sum + VectSize(ElecFieldFromA);
               if (xpos <= particle1_x) then ElecFieldFromA_SignedHalf_SumX:= ElecFieldFromA_SignedHalf_SumX + ElecFieldFromA.x;
             end;

             // Electric Field is: -grad(div) of Psi (grad of ElectricPotential Field) - d/dt of Vector Potential field
             // In Electric, we already have -grad(div(Psi)), now subtract d/dt of Vector Potential field
             with points[NewScreen]^[xpos,ypos,zpos].Electric do begin
               // E = -grad(div(Psi)) - dA/dt
               x := ElecFieldFromV.x - ElecFieldFromA.x;
               y := ElecFieldFromV.y - ElecFieldFromA.y;
               z := ElecFieldFromV.z - ElecFieldFromA.z;
             end;

             // Note: this can only be selected for electrons/positrons/protons
             if E_useFormula and not smoothing then begin
               if two_particles then begin
                 // get actual distance in metres
                 r1:=sqrt( sqr((xpos - particle1_x)*dx) + sqr(y*dy) + sqr(z*dz) );
                 if ( r1 < r_lower_limit ) then r1:=r_lower_limit;   // prevent divide by zero errors

                 // get actual distance in metres
                 r2:=sqrt( sqr((xpos - particle2_x)*dx) + sqr(y*dy) + sqr(z*dz) );
                 if ( r2 < r_lower_limit ) then r2:=r_lower_limit;   // prevent divide by zero errors

                 if (pass=1) then begin
                   actual_x:=(xpos - particle1_x)*dx;
                   r:=r1;
                 end;
                 if (pass=2) then begin
                   actual_x:=(xpos - particle2_x)*dx;
                   r:=r2;
                 end;
               end
               else begin
                 // get actual distance in metres
                 r:=sqrt( sqr(x*dx) + sqr(y*dy) + sqr(z*dz) );
                 if ( r < r_lower_limit ) then r:=r_lower_limit;   // prevent divide by zero errors

                 actual_x:=x*dx;
               end;

               actual_y:=y*dy;
               actual_z:=z*dz;

               if proton then
                 MeC_Hhat:= (ProtonMass*SpeedOfLight/Hhat)
               else
                 MeC_Hhat:= (ElectronMass*SpeedOfLight/Hhat);

               // Get the Psi (Y) vector
               vect := points[NewScreen]^[xpos,ypos,zpos].PsiVect;

               // From Maple calculations:
               //
               with points[NewScreen]^[xpos,ypos,zpos].Electric do begin
                 if neutron or neutrino then begin
                   // Also had to make cos terms negative
				           Qsin1 := sqrt(4/5)*abs(ProtonCharge)*sin(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));
                   Qcos1 := sqrt(4/5)*abs(ProtonCharge)*cos(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));
                   Qsin2 := sqrt(4/5)*abs(ProtonCharge)*sin(theta_const*(-Time + r/(SpeedOfLight - x_velocity)));
                   Qcos2 := sqrt(4/5)*abs(ProtonCharge)*cos(theta_const*(-Time + r/(SpeedOfLight - x_velocity)));

                   c:=SpeedOfLight;
                   E0:=Permittivity;

                   if neutron then
                     M:=NeutronMass
                   else
                     M:=ElectronNeutrinoMass;
                 end;

                 if ( ViewTop ) then begin
                   if neutron or neutrino then begin
                     x:=((-(15/8)*Hhat*Qcos1*sqr(actual_x))/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                          ((15/8)*Qsin1*sqr(actual_x))/(Pi*Power(sqr(r),2)*E0) +
                          ((5/8)*Hhat*Qcos1)/(Pi*Power(sqr(r),(3/2))*M*c*E0) +
                          ((5/8)*Qcos1*M*c*sqr(actual_x))/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((5/8)*Qsin1)/(Pi*sqr(r)*E0) +
                          ((3/4)*Hhat*Qsin1)*(actual_y*actual_x)/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                          ((3/4)*Qcos1)*(actual_x*actual_y)/(Pi*Power(sqr(r),2)*E0) -
                          ((1/4)*Qsin1)*M*c*(actual_x*actual_y)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((9/8)*Hhat*Qsin2)*(actual_y*actual_x)/(Pi*Power(sqr(r),(5/2))*M*c*E0) +
                          ((9/8)*Qcos2)*(actual_x*actual_y)/(Pi*Power(sqr(r),2)*E0) -
                          ((3/8)*Qsin2)*M*c*(actual_x*actual_y)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((5/8)*c*Qcos1*M)/(Pi*r*E0*Hhat));

                     y:=((-(15/8)*Hhat*Qcos1*(actual_x*actual_y))/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                          ((15/8)*Qsin1*(actual_y*actual_x))/(Pi*Power(sqr(r),2)*E0) +
                          ((5/8)*Qcos1*M*c*(actual_y*actual_x))/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((3/4)*Hhat*Qsin1)*sqr(actual_y)/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                          ((3/4)*Qcos1)*sqr(actual_y)/(Pi*Power(sqr(r),2)*E0) -
                          ((1/4)*Hhat*Qsin1)/(Pi*Power(sqr(r),(3/2))*M*c*E0) -
                          ((1/4)*Qsin1)*M*c*sqr(actual_y)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((1/4)*Qcos1)/(Pi*sqr(r)*E0) +
                          ((9/8)*Hhat*Qsin2)*sqr(actual_y)/(Pi*Power(sqr(r),(5/2))*M*c*E0) +
                          ((9/8)*Qcos2*sqr(actual_y))/(Pi*Power(sqr(r),2)*E0) -
                          ((3/8)*Hhat*Qsin2)/(Pi*Power(sqr(r),(3/2))*M*c*E0) -
                          ((3/8)*Qsin2)*M*c*sqr(actual_y)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) -
                          ((3/8)*Qcos2)/(Pi*sqr(r)*E0) -
                          (1/sqr(c))*((1/4)*Power(c,3)*Qsin1*M/(Pi*r*E0*Hhat) +
                                      (3/8)*Power(c,3)*Qsin2*M/(Pi*r*E0*Hhat)));

                     z:=(-(15/8)*Hhat*Qcos1*(actual_x*actual_z)/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                         (15/8)*Qsin1*(actual_z*actual_x)/(Pi*Power(sqr(r),2)*E0) +
                         (5/8)*Qcos1*M*c*(actual_z*actual_x)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                         (3/4)*Hhat*Qsin1*(actual_y*actual_z)/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                         (3/4)*Qcos1*(actual_z*actual_y)/(Pi*Power(sqr(r),2)*E0) -
                         (1/4)*Qsin1*M*c*(actual_z*actual_y)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                         (9/8)*Hhat*Qsin2*(actual_y*actual_z)/(Pi*Power(sqr(r),(5/2))*M*c*E0) +
                         (9/8)*Hhat*Qcos2*(actual_z*actual_y)/(Pi*Power(sqr(r),2)*E0) -
                         (3/8)*Qsin2*M*c*(actual_z*actual_y)/(Pi*Power(sqr(r),(3/2))*E0*Hhat));
                   end
                   else begin
                     x:=(3*vect.x*r/Power(sqr(r),5/2))*sqr(actual_x) + MeC_Hhat*(3*vect.y*r/Power(sqr(r),2))*sqr(actual_x) -
                        vect.x*r/Power(sqr(r),3/2) - sqr(MeC_Hhat)*(vect.x*r/Power(sqr(r),3/2))*sqr(actual_x) -
                        MeC_Hhat*(vect.y*r/sqr(r)) + (3*vect.y*r/Power(sqr(r),5/2))*actual_x*actual_y -
                        MeC_Hhat*(3*vect.x*r/Power(sqr(r), 2))*actual_x*actual_y -
                        sqr(MeC_Hhat)*(vect.y*r/Power(sqr(r),3/2))*actual_x*actual_y - sqr(MeC_Hhat)*vect.x;

                     y:=(3*vect.x*r/Power(sqr(r),5/2))*actual_x*actual_y + MeC_Hhat*(3*vect.y*r/Power(sqr(r),2))*actual_x*actual_y -
                        sqr(MeC_Hhat)*(vect.x*r/Power(sqr(r),3/2))*actual_x*actual_y + (3*vect.y*r/Power(sqr(r),5/2))*sqr(actual_y) -
                        MeC_Hhat*(3*vect.x*r/Power(sqr(r), 2))*sqr(actual_y) - (vect.y*r/Power(sqr(r),3/2)) -
                        sqr(MeC_Hhat)*(vect.y*r/Power(sqr(r),3/2))*sqr(actual_y) + MeC_Hhat*(vect.x*r/sqr(r)) - sqr(MeC_Hhat)*vect.y;

                     z:=(3*vect.x*r/Power(sqr(r),5/2))*actual_x*actual_z + MeC_Hhat*(3*vect.y*r/Power(sqr(r),2))*actual_x*actual_z -
                        sqr(MeC_Hhat)*(vect.x*r/Power(sqr(r),3/2))*actual_x*actual_z + (3*vect.y*r/Power(sqr(r),5/2))*actual_y*actual_z -
                        MeC_Hhat*(3*vect.x*r/Power(sqr(r), 2))*actual_y*actual_z - sqr(MeC_Hhat)*(vect.y*r/Power(sqr(r),3/2))*actual_y*actual_z;
                   end;
                 end
                 else begin // remap y -> -z and z -> y
                   if neutron or neutrino then begin
                     x:=((-(15/8)*Hhat*Qcos1*sqr(actual_x))/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                          ((15/8)*Qsin1*sqr(actual_x))/(Pi*Power(sqr(r),2)*E0) +
                          ((5/8)*Hhat*Qcos1)/(Pi*Power(sqr(r),(3/2))*M*c*E0) +
                          ((5/8)*Qcos1*M*c*sqr(actual_x))/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((5/8)*Qsin1)/(Pi*sqr(r)*E0) +
                          ((3/4)*Hhat*Qsin1)*(actual_z*actual_x)/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                          ((3/4)*Qcos1)*(actual_x*actual_z)/(Pi*Power(sqr(r),2)*E0) -
                          ((1/4)*Qsin1)*M*c*(actual_x*actual_z)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((9/8)*Hhat*Qsin2)*(actual_z*actual_x)/(Pi*Power(sqr(r),(5/2))*M*c*E0) +
                          ((9/8)*Qcos2)*(actual_x*actual_z)/(Pi*Power(sqr(r),2)*E0) -
                          ((3/8)*Qsin2)*M*c*(actual_x*actual_z)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((5/8)*c*Qcos1*M)/(Pi*r*E0*Hhat));

                     y:=-((-(15/8)*Hhat*Qcos1*(actual_x*actual_y)/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                         (15/8)*Qsin1*(actual_y*actual_x)/(Pi*Power(sqr(r),2)*E0) +
                         (5/8)*Qcos1*M*c*(actual_y*actual_x)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                         (3/4)*Hhat*Qsin1*(actual_z*actual_y)/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                         (3/4)*Qcos1*(actual_y*actual_z)/(Pi*Power(sqr(r),2)*E0) -
                         (1/4)*Qsin1*M*c*(actual_y*actual_z)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                         (9/8)*Hhat*Qsin2*(actual_z*actual_y)/(Pi*Power(sqr(r),(5/2))*M*c*E0) +
                         (9/8)*Hhat*Qcos2*(actual_y*actual_z)/(Pi*Power(sqr(r),2)*E0) -
                         (3/8)*Qsin2*M*c*(actual_y*actual_z)/(Pi*Power(sqr(r),(3/2))*E0*Hhat)));

                     z:=(-(15/8)*Hhat*Qcos1*(actual_x*actual_z))/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                          ((15/8)*Qsin1*(actual_z*actual_x))/(Pi*Power(sqr(r),2)*E0) +
                          ((5/8)*Qcos1*M*c*(actual_z*actual_x))/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((3/4)*Hhat*Qsin1)*sqr(actual_z)/(Pi*Power(sqr(r),(5/2))*M*c*E0) -
                          ((3/4)*Qcos1)*sqr(actual_z)/(Pi*Power(sqr(r),2)*E0) -
                          ((1/4)*Hhat*Qsin1)/(Pi*Power(sqr(r),(3/2))*M*c*E0) -
                          ((1/4)*Qsin1)*M*c*sqr(actual_z)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) +
                          ((1/4)*Qcos1)/(Pi*sqr(r)*E0) +
                          ((9/8)*Hhat*Qsin2)*sqr(actual_z)/(Pi*Power(sqr(r),(5/2))*M*c*E0) +
                          ((9/8)*Qcos2*sqr(actual_z))/(Pi*Power(sqr(r),2)*E0) -
                          ((3/8)*Hhat*Qsin2)/(Pi*Power(sqr(r),(3/2))*M*c*E0) -
                          ((3/8)*Qsin2)*M*c*sqr(actual_z)/(Pi*Power(sqr(r),(3/2))*E0*Hhat) -
                          ((3/8)*Qcos2)/(Pi*sqr(r)*E0) -
                          (1/sqr(c))*((1/4)*Power(c,3)*Qsin1*M/(Pi*r*E0*Hhat) +
                                      (3/8)*Power(c,3)*Qsin2*M/(Pi*r*E0*Hhat));
                   end
                   else begin // remap y -> z and z -> -y
                     x:=(3*vect.x*r/Power(sqr(r),5/2))*sqr(actual_x) + MeC_Hhat*(3*vect.z*r/Power(sqr(r),2))*sqr(actual_x) -
                        vect.x*r/Power(sqr(r),3/2) - sqr(MeC_Hhat)*(vect.x*r/Power(sqr(r),3/2))*sqr(actual_x) -
                        MeC_Hhat*(vect.z*r/sqr(r)) + (3*vect.z*r/Power(sqr(r),5/2))*actual_x*actual_z -
                        MeC_Hhat*(3*vect.x*r/Power(sqr(r), 2))*actual_x*actual_z -
                        sqr(MeC_Hhat)*(vect.z*r/Power(sqr(r),3/2))*actual_x*actual_z - sqr(MeC_Hhat)*vect.x;

                     y:=(3*vect.x*r/Power(sqr(r),5/2))*actual_x*actual_y + MeC_Hhat*(3*vect.z*r/Power(sqr(r),2))*actual_x*actual_y -
                        sqr(MeC_Hhat)*(vect.x*r/Power(sqr(r),3/2))*actual_x*actual_y + (3*vect.z*r/Power(sqr(r),5/2))*actual_z*actual_y -
                        MeC_Hhat*(3*vect.x*r/Power(sqr(r), 2))*actual_z*actual_y - sqr(MeC_Hhat)*(vect.z*r/Power(sqr(r),3/2))*actual_z*actual_y;

                     z:=-((3*vect.x*r/Power(sqr(r),5/2))*actual_x*actual_z + MeC_Hhat*(3*vect.z*r/Power(sqr(r),2))*actual_x*actual_z -
                        sqr(MeC_Hhat)*(vect.x*r/Power(sqr(r),3/2))*actual_x*actual_z + (3*vect.z*r/Power(sqr(r),5/2))*sqr(actual_z) -
                        MeC_Hhat*(3*vect.x*r/Power(sqr(r), 2))*sqr(actual_z) - (vect.z*r/Power(sqr(r),3/2)) -
                        sqr(MeC_Hhat)*(vect.z*r/Power(sqr(r),3/2))*sqr(actual_z) + MeC_Hhat*(vect.x*r/sqr(r)) - sqr(MeC_Hhat)*vect.z);
                   end;
                 end;
               end;
             end;

             if field_stats and (pass=1) then ElecField_Sum:= ElecField_Sum + VectSize(points[NewScreen]^[xpos,ypos,zpos].Electric);
           end;
         end;
       end; // end {scan grid's x coords}

       Application.ProcessMessages;
       if Restart then exit;

       progress:=progress + progress_inc;
       update_progress_bar(progress);

       for xpos:=0 to GridWidth-1 do begin {scan grid's x coords}
         Application.ProcessMessages;
         if Restart then exit;

         for ypos:=0 to GridHeight-1 do begin {scan grid's y coords}
           for zpos:=0 to GridDepth-1 do begin {scan grid's z coords}
             x:= xpos - midx;
             y:= ypos - midy;
             z:= zpos - midz;

             if two_particles then begin
               // get actual distance in metres
               r1:=sqrt( sqr((xpos - particle1_x)*dx) + sqr(y*dy) + sqr(z*dz) );
               if ( r1 < r_lower_limit ) then r1:=r_lower_limit;   // prevent divide by zero errors

               // get actual distance in metres
               r2:=sqrt( sqr((xpos - particle2_x)*dx) + sqr(y*dy) + sqr(z*dz) );
               if ( r2 < r_lower_limit ) then r2:=r_lower_limit;   // prevent divide by zero errors

               if (pass=1) then begin
                 actual_x:=(xpos - particle1_x)*dx;
                 r:=r1;
               end;
               if (pass=2) then begin
                 actual_x:=(xpos - particle2_x)*dx;
                 r:=r2;
               end;
             end
             else begin
               // get actual distance in metres
               r:=sqrt( sqr(x*dx) + sqr(y*dy) + sqr(z*dz) );
               if ( r < r_lower_limit ) then r:=r_lower_limit;   // prevent divide by zero errors

               actual_x:=x*dx;
             end;

             actual_y:=y*dy;
             actual_z:=z*dz;

             ThisGroup:=PointGroup(scr, xpos, ypos, zpos);
             NewGroup:=PointGroup(NewScreen, xpos, ypos, zpos);

             // Calculate Magnetic B Field
             with points[NewScreen]^[xpos,ypos,zpos].Magnetic do begin

               // Note: this can only be selected for electrons/positrons/protons
               if H_useFormula and not smoothing then begin
                 if (pass=1) then particle_1_2_B[xpos,ypos,zpos]:=NullVect;
                 if (pass=3) then begin
                   x:=particle_1_2_B[xpos,ypos,zpos].x;
                   y:=particle_1_2_B[xpos,ypos,zpos].y;
                   z:=particle_1_2_B[xpos,ypos,zpos].z;
                 end
                 else begin
                   // Get the Psi (Y) vector
                   vect := points[NewScreen]^[xpos,ypos,zpos].PsiVect;

                   // From Maple calculations:
                   //
                   // B = Curl(A)
                   //
                   if neutron or neutrino then begin
                     // Also had to make cos terms negative
                     Qsin1 := sqrt(4/5)*abs(ProtonCharge)*sin(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));
                     Qcos1 := sqrt(4/5)*abs(ProtonCharge)*cos(theta_const*(-Time - r/(SpeedOfLight - x_velocity)));
                     Qsin2 := sqrt(4/5)*abs(ProtonCharge)*sin(theta_const*(-Time + r/(SpeedOfLight - x_velocity)));
                     Qcos2 := sqrt(4/5)*abs(ProtonCharge)*cos(theta_const*(-Time + r/(SpeedOfLight - x_velocity)));

                     c:=SpeedOfLight;
                     E0:=Permittivity;

                     if neutron then
                       M:=NeutronMass
                     else
                       M:=ElectronNeutrinoMass;
                   end;

                   if ( ViewTop ) then begin
                     if neutron or neutrino then begin
                       x:=-(5/8)*Qcos1/(c*Pi*Power(sqr(r),(3/2))*E0) +
                           (5/8)*Qsin1*M/(Pi*sqr(r)*E0*Hhat);

                       y:=(1/sqr(c))*( (1/4)*c*Qsin1/(Pi*Power(sqr(r),(3/2))*E0) +
                                       (1/4)*sqr(c)*Qcos1*M/(Pi*sqr(r)*E0*Hhat) +
                                       (3/8)*c*Qsin2/(Pi*Power(sqr(r),(3/2))*E0) -
                                       (3/8)*sqr(c)*Qcos2*M/(Pi*sqr(r)*E0*Hhat));

                       z:=x*actual_x + y*actual_y;

                       x:=x*actual_z;
                       y:=y*actual_z;
                     end
                     // For charged particles (electron, positron, proton):
                     //
                     // B = [(m/(Hhat*r^2))*Y_x*z + (m^2c/(r*Hhat^2))*Y_y*z,
                     //      (m/(Hhat*r^2))*Y_y*z - (m^2c/(r*Hhat^2)*Y_x*z,
                     //      -(m/(Hhat*r^2))*Y_x*x - (m^2c/(r*Hhat^2))*Y_y*x - (m/(Hhat*r^2))*Y_y*y + (m^2c/(r*Hhat^2)*Y_x*y]
                     else if proton then begin
                       x:=(ProtonMass/(Hhat*sqr(r)))*vect.x*actual_z + (sqr(ProtonMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.y*actual_z;
                       y:=(ProtonMass/(Hhat*sqr(r)))*vect.y*actual_z - (sqr(ProtonMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.x*actual_z;
                       z:=-(-(ProtonMass/(Hhat*sqr(r)))*vect.x*actual_x - (sqr(ProtonMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.y*actual_x -
                            (ProtonMass/(Hhat*sqr(r)))*vect.y*actual_y + (sqr(ProtonMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.x*actual_y);
                     end
                     else begin
                       x:=(ElectronMass/(Hhat*sqr(r)))*vect.x*actual_z + (sqr(ElectronMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.y*actual_z;
                       y:=(ElectronMass/(Hhat*sqr(r)))*vect.y*actual_z - (sqr(ElectronMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.x*actual_z;
                       z:=-(-(ElectronMass/(Hhat*sqr(r)))*vect.x*actual_x - (sqr(ElectronMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.y*actual_x -
                            (ElectronMass/(Hhat*sqr(r)))*vect.y*actual_y + (sqr(ElectronMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.x*actual_y);
                     end;
                   end
                   else begin // remap y -> -z and z -> y
                     if neutron or neutrino then begin
                       x:=-(5/8)*Qcos1/(c*Pi*Power(sqr(r),(3/2))*E0) +
                           (5/8)*Qsin1*M/(Pi*sqr(r)*E0*Hhat);

                       z:=(1/sqr(c))*( (1/4)*c*Qsin1/(Pi*Power(sqr(r),(3/2))*E0) +
                                       (1/4)*sqr(c)*Qcos1*M/(Pi*sqr(r)*E0*Hhat) +
                                       (3/8)*c*Qsin2/(Pi*Power(sqr(r),(3/2))*E0) -
                                       (3/8)*sqr(c)*Qcos2*M/(Pi*sqr(r)*E0*Hhat));

                       y:=-(x*actual_x + z*actual_z);

                       x:=x*actual_y;
                       z:=z*actual_y;
                     end
                     else if proton then begin  // remap y -> z and z -> y
                       x:=(ProtonMass/(Hhat*sqr(r)))*vect.x*actual_y + (sqr(ProtonMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.z*actual_y;
                       y:=-(-(ProtonMass/(Hhat*sqr(r)))*vect.x*actual_x - (sqr(ProtonMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.z*actual_x -
                            (ProtonMass/(Hhat*sqr(r)))*vect.z*actual_z + (sqr(ProtonMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.x*actual_z);
                       z:=(ProtonMass/(Hhat*sqr(r)))*vect.z*actual_y - (sqr(ProtonMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.x*actual_y;
                     end
                     else begin
                       x:=(ElectronMass/(Hhat*sqr(r)))*vect.x*actual_y + (sqr(ElectronMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.z*actual_y;
                       y:=-(-(ElectronMass/(Hhat*sqr(r)))*vect.x*actual_x - (sqr(ElectronMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.z*actual_x -
                            (ElectronMass/(Hhat*sqr(r)))*vect.z*actual_z + (sqr(ElectronMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.x*actual_z);
                       z:=(ElectronMass/(Hhat*sqr(r)))*vect.z*actual_y - (sqr(ElectronMass)*SpeedOfLight/(r*sqr(Hhat)))*vect.x*actual_y;
                     end;
                   end;

                   // if the second particle is a positron, we must reverse the direction of the magnetic field vector, as
                   // the above equation is for an electron.
                   if (pass = 2) and (positron or proton) then begin
                     x:=-x;
                     y:=-y;
                     z:=-z;
                   end;

                   // Double B magnitude (due to two equal components of B)
                   x:=2*x;
                   y:=2*y;
                   z:=2*z;

                   particle_1_2_B[xpos,ypos,zpos].x := particle_1_2_B[xpos,ypos,zpos].x + x;
                   particle_1_2_B[xpos,ypos,zpos].y := particle_1_2_B[xpos,ypos,zpos].y + y;
                   particle_1_2_B[xpos,ypos,zpos].z := particle_1_2_B[xpos,ypos,zpos].z + z;
                 end;
               end
               else begin
                 // Magnetic Field is Curl of Vector Potential Field
                 VectGrp:=VectorGroup(NewGroup, VECTOR_POTENTIAL_FIELD);
                 CurlVect:=VectCurl(VectGrp);

                 x:=CurlVect.x;
                 y:=CurlVect.y;
                 z:=CurlVect.z;

                 // Double B magnitude (due to two equal components of B)
                 x:=2*x;
                 y:=2*y;
                 z:=2*z;
               end;
             end;
             if field_stats and (pass=1) then MagField_Sum:= MagField_Sum + VectSize(points[NewScreen]^[xpos,ypos,zpos].Magnetic);
           end;
         end;
       end; // end {scan grid's x coords}

       Application.ProcessMessages;
       if Restart then exit;

       progress:=progress + progress_inc;
       update_progress_bar(progress);

       // Calculate the E and B field energies for each of the two particles,
       // then sum them for pass 3 when both particles are present simultaneously.
       if ((pass=1) or (pass=2)) then begin
         UpdateE_Energy(NewScreen);
         UpdateB_Energy(NewScreen);
         E_Energy_Sum := E_Energy_Sum + E_Energy_Tot;
         B_Energy_Sum := B_Energy_Sum + B_Energy_Tot;
       end
       else begin
         E_Energy_Tot := E_Energy_Sum;
         B_Energy_Tot := B_Energy_Sum;
       end;

       if EnergyCorrection then begin
         if ((pass=1) or (pass=2)) then
           EnergyFactor:=0.5
         else
           EnergyFactor:=1;

         PowerCorrectionFactor_E:=1;
         PowerCorrectionFactor_B:=1;

         if proton then begin
           if (E_Energy_Tot > 0)  then PowerCorrectionFactor_E:=sqrt((EnergyFactor*ProtonMass*SpeedOfLight*SpeedOfLight)/E_Energy_Tot); // correct for model inaccuracy
           if (B_Energy_Tot > 0)  then PowerCorrectionFactor_B:=sqrt((EnergyFactor*ProtonMass*SpeedOfLight*SpeedOfLight)/B_Energy_Tot); // correct for model inaccuracy
         end
         else if neutron then begin
           if (E_Energy_Tot > 0)  then PowerCorrectionFactor_E:=sqrt((EnergyFactor*NeutronMass*SpeedOfLight*SpeedOfLight)/E_Energy_Tot); // correct for model inaccuracy
           if (B_Energy_Tot > 0)  then PowerCorrectionFactor_B:=sqrt((EnergyFactor*NeutronMass*SpeedOfLight*SpeedOfLight)/B_Energy_Tot); // correct for model inaccuracy
         end
         else begin
           if (E_Energy_Tot > 0)  then PowerCorrectionFactor_E:=sqrt((EnergyFactor*ElectronMass*SpeedOfLight*SpeedOfLight)/E_Energy_Tot); // correct for model inaccuracy
           if (B_Energy_Tot > 0)  then PowerCorrectionFactor_B:=sqrt((EnergyFactor*ElectronMass*SpeedOfLight*SpeedOfLight)/B_Energy_Tot); // correct for model inaccuracy
         end;

         for xpos:=0 to GridWidth-1 do begin {scan grid's x coords}
           Application.ProcessMessages;
           if Restart then exit;

           for ypos:=0 to GridHeight-1 do begin {scan grid's y coords}
             for zpos:=0 to GridDepth-1 do begin {scan grid's z coords}

               with points[NewScreen]^[xpos,ypos,zpos].Electric do begin
                 x:=x*PowerCorrectionFactor_E;
                 y:=y*PowerCorrectionFactor_E;
                 z:=z*PowerCorrectionFactor_E;
               end;

               with points[NewScreen]^[xpos,ypos,zpos].Magnetic do begin
                 x:=x*PowerCorrectionFactor_B;
                 y:=y*PowerCorrectionFactor_B;
                 z:=z*PowerCorrectionFactor_B;
               end;

               if two_particles then begin
                 if (pass=1) then begin
                   particle1_A[xpos,ypos,zpos]:=points[NewScreen]^[xpos,ypos,zpos].VectorPotential;
                   particle1_E[xpos,ypos,zpos]:=points[NewScreen]^[xpos,ypos,zpos].Electric;
                 end
                 else if (pass=2) then begin
                   particle2_A[xpos,ypos,zpos]:=points[NewScreen]^[xpos,ypos,zpos].VectorPotential;
                   particle2_E[xpos,ypos,zpos]:=points[NewScreen]^[xpos,ypos,zpos].Electric;
                 end;
               end;
             end;
           end;
         end; // end {scan grid's x coords}

         UpdateE_Energy(NewScreen);
         UpdateB_Energy(NewScreen);
      end;  // end if (EnergyCorrection = 1)

      Application.ProcessMessages;
      if Restart then exit;

      progress:=progress + progress_inc;
      update_progress_bar(progress);

	    for xpos:=0 to GridWidth-1 do begin {scan grid's x coords}
        Application.ProcessMessages;
        if Restart then exit;

	      for ypos:=0 to GridHeight-1 do begin {scan grid's y coords}
	        for zpos:=0 to GridDepth-1 do begin {scan grid's z coords}

		        ThisGroup:=PointGroup(scr, xpos, ypos, zpos);
		        NewGroup:=PointGroup(NewScreen, xpos, ypos, zpos);

		        with points[NewScreen]^[xpos,ypos,zpos] do begin
		          VectGrp:=VectorGroup(NewGroup, ELECTRIC_FIELD);
		          ChargeDensity:=-Permittivity*VectDiv(VectGrp);
		        end;

		        if two_particles then begin
		          if (pass=1) then begin
                if not EnergyCorrection then begin
			            particle1_A[xpos,ypos,zpos]:=points[NewScreen]^[xpos,ypos,zpos].VectorPotential;
			            particle1_E[xpos,ypos,zpos]:=points[NewScreen]^[xpos,ypos,zpos].Electric;
				        end;
                particle1_Power[xpos, ypos, zpos]:=RMS_PowerFlow(NewGroup.P0);
		          end
		          else if (pass=2) then begin
                if not EnergyCorrection then begin
			            particle2_A[xpos,ypos,zpos]:=points[NewScreen]^[xpos,ypos,zpos].VectorPotential;
			            particle2_E[xpos,ypos,zpos]:=points[NewScreen]^[xpos,ypos,zpos].Electric;
			          end;
			          particle2_Power[xpos, ypos, zpos]:=RMS_PowerFlow(NewGroup.P0);
		          end;
		        end // end if (two_particles)
            else begin
              particle1_A[xpos,ypos,zpos]:=points[NewScreen]^[xpos,ypos,zpos].VectorPotential;
            end;
	        end;
	      end;
	    end; // end {scan grid's x coords}
    end; //if Flip_YZ
  end; // end: for pass := 1 to maxpass do begin

  Application.ProcessMessages;
  if Restart then exit;

  progress:=progress + 2;
  update_progress_bar(progress);

  if two_particles then begin
    c1:=0;
    c2:=0;
    c3:=0;
    PowerCount_neg:=0;
    PowerSum_neg:=0;
    PowerCount_pos:=0;
    PowerSum_pos:=0;

    for xpos:=0 to GridWidth-1 do begin {scan grid's x coords}
      Application.ProcessMessages;
      if Restart then exit;

      for ypos:=0 to GridHeight-1 do begin {scan grid's y coords}
        for zpos:=0 to GridDepth-1 do begin {scan grid's z coords}
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
          points[NewScreen]^[xpos,ypos,zpos].particle_pos_Reflected := NullVect;
          points[NewScreen]^[xpos,ypos,zpos].particle_neg_Reflected := NullVect;

          dot_v1v2:=VectorDot(particle1_Power[xpos, ypos, zpos], particle2_Power[xpos, ypos, zpos]);

          vect.x:=min(abs(particle1_Power[xpos, ypos, zpos].x),abs(particle2_Power[xpos, ypos, zpos].x));
          vect.y:=min(abs(particle1_Power[xpos, ypos, zpos].y),abs(particle2_Power[xpos, ypos, zpos].y));
          vect.z:=min(abs(particle1_Power[xpos, ypos, zpos].z),abs(particle2_Power[xpos, ypos, zpos].z));

          vect2.x:=1 * sign(particle1_Power[xpos, ypos, zpos].x) * sign(particle2_Power[xpos, ypos, zpos].x);
          vect2.y:=1 * sign(particle1_Power[xpos, ypos, zpos].y) * sign(particle2_Power[xpos, ypos, zpos].y);
          vect2.z:=1 * sign(particle1_Power[xpos, ypos, zpos].z) * sign(particle2_Power[xpos, ypos, zpos].z);

          if vect2.x < 0 then points[NewScreen]^[xpos,ypos,zpos].particle_neg_Reflected.x := -2*sign(particle1_Power[xpos, ypos, zpos].x)*vect.x;
          if vect2.y < 0 then points[NewScreen]^[xpos,ypos,zpos].particle_neg_Reflected.y := -2*sign(particle1_Power[xpos, ypos, zpos].y)*vect.y;
          if vect2.z < 0 then points[NewScreen]^[xpos,ypos,zpos].particle_neg_Reflected.z := -2*sign(particle1_Power[xpos, ypos, zpos].z)*vect.z;

          if vect2.x > 0 then points[NewScreen]^[xpos,ypos,zpos].particle_pos_Reflected.x := 2*sign(particle1_Power[xpos, ypos, zpos].x)*vect.x;
          if vect2.y > 0 then points[NewScreen]^[xpos,ypos,zpos].particle_pos_Reflected.y := 2*sign(particle1_Power[xpos, ypos, zpos].y)*vect.y;
          if vect2.z > 0 then points[NewScreen]^[xpos,ypos,zpos].particle_pos_Reflected.z := 2*sign(particle1_Power[xpos, ypos, zpos].z)*vect.z;

          // if not in the space between particles, reverse the sign of the reflected force
          if not ((xpos > particle1_x) and (xpos < particle2_x)) then with points[NewScreen]^[xpos,ypos,zpos] do begin
            particle_pos_Reflected.x := -particle_pos_Reflected.x;
            particle_pos_Reflected.y := -particle_pos_Reflected.y;
            particle_pos_Reflected.z := -particle_pos_Reflected.z;

            particle_neg_Reflected.x := -particle_neg_Reflected.x;
            particle_neg_Reflected.y := -particle_neg_Reflected.y;
            particle_neg_Reflected.z := -particle_neg_Reflected.z;
          end;
 {$IFEND}
          Power_x1:=particle1_Power[xpos, ypos, zpos].x;
          Power_x2:=particle2_Power[xpos, ypos, zpos].x;

          vect:=particle1_E[xpos,ypos,zpos];
          vect2:=particle2_E[xpos,ypos,zpos];
          vect.x:=0;
          vect2.x:=0;
          vect:=Normalize(vect);
          vect2:=Normalize(vect2);
          dot_v1v2:=abs(VectorDot(vect,vect2));

          ReflectedPowerAtPoint:=0;

          // Opposing Poynting vectors reflect off one another, so energy equal to the minimum magnitude of the two opposing vectors
          // reflects on each side of the meeting point. Also, for relected EM energy the force on each particle is twice that of absorption,
          // so each side of the relection point has a force equal to twice of the minimum magnitude of the two opposing vectors.
          //
          // For two particles with the same charge (two electrons or two positrons) the opposing vectors are in between the two particles, so the
          // force on each particle is outwards (away from the other particle). For two particles with opposite charges (an electron and a positron),
          // the opposing vectors are in the space on the outside of each particle (i.e. not in the space between the particle centers), thus the force
          // in this case is inwards for each particle (towards the other particle).
          //
          // For particles with the same charge:
          //
          // If |B1| is the magnitude of the total amount of power in Poynting vectors that are in opposition,
          // |C1| is the total amount of power in Poynting vectors that are in the same direction, |P1| is the total power,
          // A1 is the acceleration of each particle away from the other, and k is a constant of proportionality for the
          // resulting acceleration due to an amount of reflected power:
          //
          // |P1| = |B1| + |C1|
          // A1 = k*B1
          //
          // Similarly for particles with the opposite charge, but with the directions reversed:
          // B2 is the total amount of power in Poynting vectors that are in the same direction,
          // C2 is the total amount of power in Poynting vectors that are in opposition, P2 is the total power,
          // A2 is the acceleration of each particle away from the other, and k is a constant of proportionality for the
          // resulting acceleration due to an amount of reflected power:
          //
          // |P2| = |B2| + |C2|
          // A2 = k*C2
          //
          // So, as B1 is the amount of power for vectors that are in opposition (in the space between particles),
          // and as the vector fields in both cases (like charges and opposite charges) are the same except that in the second
          // case the vectors for the 2nd particle are reversed, we can say that:
          //
          // |B2| = |B1|,
          //
          // and therefore:

          // |C2| = |C1| also.
          //
          // Thus:
          //
          // |P2| = |B1| + |C1|
          //
          // Therefore, the amount of acceleration two oppositely charged particles experience towards each other is proportional
          // to the amount of power for Poynting vectors in the same direction (in the space between the particles), as well as
          // being proportional to the amount of power in opposing vectors in the space outside the particles.

          // The Force imparted upon reflection is double the incident radiation pressure
          reflected_power:=2*dot_v1v2*min(abs(Power_x1),abs(Power_x2));

          if two_particle_analysis then begin
            analysis_results[StartOption][IterationCount].power_sum1 := analysis_results[StartOption][IterationCount].power_sum1 + abs(Power_x1);
            analysis_results[StartOption][IterationCount].power_sum2 := analysis_results[StartOption][IterationCount].power_sum2 + abs(Power_x2);
            analysis_results[StartOption][IterationCount].reflected_sum := analysis_results[StartOption][IterationCount].reflected_sum + reflected_power;
          end;

          // if two oppositely charged particles, reverse the sign (charge) of one particle in order to calculate the
          // repulsion between particles (rather than attraction), then convert this (at the bottom) to a repulsion.
          // This is appropriate as the amount of attraction between oppositely charged particles is the same as the
          // amount of repulsion between particles with the same charge (see explanation above).
          if (electron and positron) then Power_x2:=-Power_x2;

          if ((Power_x1 > 0) and (Power_x2 < 0)) then begin
            if (xpos > particle1_x) and (xpos < particle2_x) then begin
              ReflectedPowerAtPoint:=ReflectedPowerAtPoint - reflected_power;
              if two_particle_analysis then begin
                analysis_results[StartOption][IterationCount].power_reflected_1_sum1 := analysis_results[StartOption][IterationCount].power_reflected_1_sum1 + 2*reflected_power;
              end;
            end
            else begin
              ReflectedPowerAtPoint:=ReflectedPowerAtPoint + reflected_power;
              if two_particle_analysis then begin
                analysis_results[StartOption][IterationCount].power_reflected_1_sum2 := analysis_results[StartOption][IterationCount].power_reflected_1_sum2 + 2*reflected_power;
              end;
            end;

            c1:=c1+ReflectedPowerAtPoint*PointArea/10000;

            if two_particle_analysis then begin
              analysis_results[StartOption][IterationCount].power_opposed_1_sum1 := analysis_results[StartOption][IterationCount].power_opposed_1_sum1 + Power_x1;
              analysis_results[StartOption][IterationCount].power_opposed_1_sum2 := analysis_results[StartOption][IterationCount].power_opposed_1_sum2 + Power_x2;
            end;
          end
          else if ((Power_x1 < 0) and (Power_x2 > 0)) then begin
            if (xpos > particle1_x) and (xpos < particle2_x) then begin
              ReflectedPowerAtPoint:=ReflectedPowerAtPoint - reflected_power;
              if two_particle_analysis then begin
                analysis_results[StartOption][IterationCount].power_reflected_2_sum1 := analysis_results[StartOption][IterationCount].power_reflected_2_sum1 + 2*reflected_power;
              end;
            end
            else begin
              ReflectedPowerAtPoint:=ReflectedPowerAtPoint + reflected_power;
              if two_particle_analysis then begin
                analysis_results[StartOption][IterationCount].power_reflected_2_sum2 := analysis_results[StartOption][IterationCount].power_reflected_2_sum2 + 2*reflected_power;
              end;
            end;

            c2:=c2+ReflectedPowerAtPoint*PointArea/10000;

            if two_particle_analysis then begin
              analysis_results[StartOption][IterationCount].power_opposed_2_sum1 := analysis_results[StartOption][IterationCount].power_opposed_2_sum1 + Power_x1;
              analysis_results[StartOption][IterationCount].power_opposed_2_sum2 := analysis_results[StartOption][IterationCount].power_opposed_2_sum2 + Power_x2;
            end;
          end
          else begin
            if (Power_x1 < Power_x2) then begin
              if two_particle_analysis then begin
                analysis_results[StartOption][IterationCount].power_aligned_1_sum1 := analysis_results[StartOption][IterationCount].power_aligned_1_sum1 + Power_x1;
                analysis_results[StartOption][IterationCount].power_aligned_1_sum2 := analysis_results[StartOption][IterationCount].power_aligned_1_sum2 + Power_x2;
              end;
            end
            else begin
              if two_particle_analysis then begin
                analysis_results[StartOption][IterationCount].power_aligned_2_sum1 := analysis_results[StartOption][IterationCount].power_aligned_2_sum1 + Power_x1;
                analysis_results[StartOption][IterationCount].power_aligned_2_sum2 := analysis_results[StartOption][IterationCount].power_aligned_2_sum2 + Power_x2;
              end;
            end;
          end;

          // if oppositely charges particles, now reverse the force, as the opposite charges were converted into
          // alike charges (see explanation above) in order to calculate the repulsion, which is then converted
          // into an attraction (as the two magnitudes are equivalent).
          if (electron and positron) then begin
            if ReflectedPowerAtPoint < 0 then begin
              Inc(PowerCount_neg);
              PowerSum_neg:=PowerSum_neg - ReflectedPowerAtPoint;
            end
            else begin
              Inc(PowerCount_pos);
              PowerSum_pos:=PowerSum_pos - ReflectedPowerAtPoint;
            end;
          end
          else begin
            if ReflectedPowerAtPoint < 0 then begin
              Inc(PowerCount_neg);
              PowerSum_neg:=PowerSum_neg + ReflectedPowerAtPoint;
            end
            else begin
              Inc(PowerCount_pos);
              PowerSum_pos:=PowerSum_pos + ReflectedPowerAtPoint;
            end;
          end;
        end;
      end;
    end;

    Application.ProcessMessages;
    if Restart then exit;

    progress:=progress + progress_inc;
    update_progress_bar(progress);

    // The amount of power coupling between the two particles (electrons) depends on the amount of reflection
    // of the waves from each particle. This amount depends on the minimum power of the two interacting waves
    // along the axis connecting the two particle centers (the x axis in this model), as the waves can only reflect
    // when equal but opposite EM wave components meet at the reflection point.
    //
    // Then there is an additional factor that determines the amount of power coupling between the two
    // particles - the relative orientations of the polarizations of the two waves & how much they align
    // and thus reflect off each other. As the interface area between the two electrons is a circle,
    // the amount of coupling between the two EM waves will vary sinusoidally (around this circle)
    // with the angle difference between the polarizations of the two waves. To get an average of this
    // sinusoid over the whole circular interface area we must use the RMS of the Electric energy density for
    // each electron, which is the maximum EM field value (when both polarizations are aligned) divided by √2.
    //
    // RMS of ue around the interface circle:
    // = ue/√2 = ((1/4)*ε0*E^2)/√2
    //
    //       sin x
    //       |
    //    1 ,|,      _....._
    //       |    ,="       "=.
    //       |  ,"             ".
    //       |,"        ,        ".,          ,          ,
    //     ""*""""""""""|""""""""""|."""""""""|""""""""".|"""">
    //       |                     π ".               ." 2π     x
    //       |                         "._         _,"
    //       |                            "-.....-"
    //   -1 ,|,
    //       |
    //
    //       RMS(sin x)
    //       |
    //    1 ,|,
    // 1/√2 ,|--------------------------------------------
    //       |
    //       |          ,          ,          ,          ,
    //     ""*""""""""""|""""""""""|""""""""""|""""""""""|"""">
    //       |                     π                     2π    x
    //       |
    //-1/√2 ,|,
    //   -1 ,|,
    //       |
    //
    // As these values are instantaneous the RMS of these values must be taken to get the actual, effective value;
    // however, when calculating the amount of reflected energy between the two wave-functions I take the Dot Product
    // of the two Electric field vectors. This process accounts for this angle variation between the two EM waves, and
    // determines the amount of reflection that occurs.
    //
    // The power values of each EM wave are calculated from the Poynting Vector (vector cross product) of the
    // instantaneous Electric and Magnetic field values of the minimum power of the two interacting waves at each point.
    //
    // Electric energy density ue=(1/2)*ε0*ε^2rms
    //
    // However, as the wave-function is sinusoidal in all three dimensions the RMS must be taken over 3 cartesian coordinate
    // dimensions (x, y, z), :
    //
    // So, when combined with the (1/2) factor seen above, the actual Electric energy density becomes:
    //
    // ∴ ue = (1/2)*ε0*(1/√2 * 1/√2 * 1/√2 * ε)^2    =   (1/16)*ε0*ε^2
    //
    // The Power value obtained is then converted into a pressure by dividing by the speed of light.
    //
    // To work out the actual force between the two particles we need to simplify the calculation by reducing each particle
    // to a point particle at its wave-function center, with an effective area of interaction of one grid point in the model.
    // The force between them is due to wave reflections at the mid-way point between them - where waves from each side are equal.
    //
    // In a similar way to the Shell Theorem for gravity, where the force between two bodies due to the mass of one spherical
    // body can be treated as all coming from a single point at that spherical body's center, the attractive/repulsive force
    // between charged particles can be treated similarly.
    //
    // If we start from the situation where both particles are together at the same point, then there is a single grid point of
    // area interacting between them. As the particles move apart, the volume of the sphere from each particle's center to the
    // mid-way point between them represents all of the contributing grid points to the total force attributed to the central point.
    // So, in order to keep the area of interaction between the particles as one grid point of area, in the calculation we must
    // divide by the rate of increase in volume (V) of the sphere with the distance from the mid-way point (R), which is dV/dR.
    // As the volume of a sphere is (4/3)πR^3, dV/dR = 4πR^2. Then expressing this in terms of the separation distance (r) between
    // the particles (r = 2R), we have 4πR^2 = 4π(r/2)^2 = πr^2
    //
    // Once this has been done, the actual force between the two particles can be determined by multiplying this pressure by the
    // area of a single grid point.

    // Total Pressure = The sum of both the Positive & Negative Power divided by speed of light
    Pressure:=(PowerSum_neg + PowerSum_pos)/SpeedOfLight;

    // The actual pressure at a single, central grid point is 1/πr^2, where r is the number of grid points between the two
    // particle centers.
    Pressure:=Pressure/(Pi*sqr(GridWidth*p1_p2_diff*dx/ActualWidth));

    // Total force is pressure * the area of 1 point
    Force:= Pressure*PointArea;

    Accel:=Force/ElectronMass; // F = m*a
    Velocity:=Velocity + Accel*TimeStep;

    // e.g.
    //
    // For num points = 220x220x220
    // ActualWidth = 3.02E-11
    //
    // r = 0.3 ActualWidth
    //
    // r = 3.02e-11 * 2.4 / 8 = 9.06E-12
    //
    // r^2 = 8.20836e-23
    //
    // q = 1.60217662e-19
    //
    // q^2 = 2.5669699216746244e-38
    //
    // q^2 / r^2 = 3.12726284138929627842833403993e-16
    //
    // k = 8.9875517873681764e9
    //
    // F = k (q^2 / r^2) = 8.9875517873681764e9 * 3.12726284138929627842833403993e-16  =  2.8106436739698451704657505254331e-6
    //
    // F = m*a
    //
    // m = 9.1093835611e-31
    //
    // a = 2.8106436739698451704657505254331e-6 / 9.1093835611e-31 = 3.0854378401324523962093223812502e24
    //

    ExpectedAccel:=0;

    if proton then begin
      ExpectedAccel := sqr(ProtonCharge)/sqr(ActualWidth*(p1_p2_diff/GridWidth));
      ExpectedAccel := ExpectedAccel * Ek/ProtonMass;
    end
    else begin
      ExpectedAccel := sqr(ElectronCharge)/sqr(ActualWidth*(p1_p2_diff/GridWidth));
      ExpectedAccel := ExpectedAccel * Ek/ElectronMass;
    end;

    // set the sign for the acceleration based on the particles being modeled
    if not (electron and positron) then ExpectedAccel := -ExpectedAccel;
    if not (ShowEnergy_CheckBox.Checked) then Energy3.Text:=FloatToStr(ExpectedAccel)
    else Energy3.Text:=FloatToStr(E_Energy_Tot+B_Energy_Tot); {display total field energy}

    // if not running a profile at the moment, update the particles' positions based on the current acceleration.
    if two_particle_accel_profile_done then begin
      particle1_x:=particle1_x + (GridWidth/ActualWidth)*Velocity*TimeStep;
      particle2_x:=particle2_x - (GridWidth/ActualWidth)*Velocity*TimeStep;
    end;

    // disable running averaqe - always show current acceleration calculation
    if false and (IterationCount >= 8) then begin
      accel_avg:=RunningAverage(min(IterationCount - 8, 108), accel_avg, Accel);
      if not (ShowEnergy_CheckBox.Checked) then Energy4.Text:=FloatToStr(accel_avg);
    end
    else begin
      if not (ShowEnergy_CheckBox.Checked) then Energy4.Text:=FloatToStr(Accel);
    end;

    if two_particle_analysis then begin
      AnalysisSaveResults(StartOption, IterationCount);
      AnalysisWriteResults(StartOption, IterationCount);
    end;

    Inc(IterationCount);
//    Energy3.Text:=IntToStr(Trunc(c1)) + '   ' + IntToStr(Trunc(c2)) + '   ' + IntToStr(Trunc(c3));

    progress:=progress + 2;
    update_progress_bar(progress);

    if profile_changed and not two_particle_accel_profile_done then begin
      // Close the currently open files
      if IsOpen(myFile) then CloseFile(myFile);
      if IsOpen(myFile2) then CloseFile(myFile2);
    end;

    if two_particle_accel_profile then begin
      if profile_changed then begin
        // Try to open the Analysis.txt file for writing to
        AssignFile(myFile, 'AccelProfile_' + FloatToStrf(PercentBetweenParticles,ffFixed,4,2) + '%_' + FloatToStrf(ActualWidth,ffExponent,5,2) + 'm_' + IntToStr(StartOption) + '.txt');
        ReWrite(myFile);
        AssignFile(myFile2, 'AccelProfile_Summary_' + FloatToStrf(PercentBetweenParticles,ffFixed,4,2) + '%_' + FloatToStrf(ActualWidth,ffExponent,5,2) + 'm_' + IntToStr(StartOption) + '.txt');
        ReWrite(myFile2);

        New_GridWidth:=100;
        New_GridHeight:=100;
        New_GridDepth:=100;
        DoUpdate:=true;
        Restart:=true;
      end
      else begin
        WriteLn(myFile, 'Grid size ' + IntToStr(GridWidth) + ', (' + FloatToStrf(PercentBetweenParticles,ffFixed,4,2) + '%)  :  Accel is ' + FloatToStr(Accel) + ' (' + FloatToStr(100*Accel/ExpectedAccel) + '% of expected accel ' + FloatToStr(ExpectedAccel) + ')');
        WriteLn(myFile, 'E Energy = ' + FloatToStrf(E_Energy_Tot,ffExponent,5,2) + ', B Energy = ' + FloatToStrf(B_Energy_Tot,ffExponent,5,2) + ', Energy Total = ' + FloatToStrf((E_Energy_Tot + B_Energy_Tot),ffExponent,5,2) + ' : ' + FloatToStr(100*(E_Energy_Tot + B_Energy_Tot)/Etotal) + ' % of ' + FloatToStrf(Etotal,ffExponent,5,2));
        WriteLn(myFile2, FloatToStr(100*Accel/ExpectedAccel));

        if GridWidth < GRID_LIMIT then begin
          New_GridWidth:=GridWidth + 1;
          New_GridHeight:=GridHeight + 1;
          New_GridDepth:=GridDepth + 1;
          DoUpdate:=true;
          Restart:=true;

  //        PercentBetweenParticles:=80;
  //        DistBetween.Text:=FloatToStrf(PercentBetweenParticles,ffFixed,4,2);
        end
        else begin
          // Close the file
          CloseFile(myFile);
          CloseFile(myFile2);

          New_GridWidth:=100;
          New_GridHeight:=100;
          New_GridDepth:=100;
          DoUpdate:=true;
          Restart:=true;

          if StartOption < 3 then begin
            New_StartOption:=StartOption + 1;
          end
          else begin
            New_StartOption:=1;
            ProfileCancel();
          end;
        end;
      end;
    end;

    if two_particle_accel_dist_profile then begin
      if profile_changed then begin
        // Try to open the Analysis.txt file for writing to
        AssignFile(myFile, 'AccelDistProfile_' + IntToStr(GridWidth) + '_' + FloatToStrf(ActualWidth,ffExponent,5,2) + 'm_' + IntToStr(StartOption) + '.txt');
        ReWrite(myFile);
        AssignFile(myFile2, 'AccelDistProfile_Summary_' + IntToStr(GridWidth) + '_' + FloatToStrf(ActualWidth,ffExponent,5,2) + 'm_' + IntToStr(StartOption) + '.txt');
        ReWrite(myFile2);

        PercentBetweenParticles:=1;
        DistBetween.Text:=FloatToStrf(PercentBetweenParticles,ffFixed,4,2);

//        New_GridWidth:=150;
//        New_GridHeight:=150;
//        New_GridDepth:=150;
        DoUpdate:=true;
        Restart:=true;
      end
      else begin
        WriteLn(myFile, 'Grid size ' + IntToStr(GridWidth) + ', (' + FloatToStrf(PercentBetweenParticles,ffFixed,4,2) + '%)  : Accel is ' + FloatToStr(Accel) + ' (' + FloatToStr(100*Accel/ExpectedAccel) + '% of expected accel ' + FloatToStr(ExpectedAccel) + ')');
        WriteLn(myFile, 'E Energy = ' + FloatToStrf(E_Energy_Tot,ffExponent,5,2) + ', B Energy = ' + FloatToStrf(B_Energy_Tot,ffExponent,5,2) + ', Energy Total = ' + FloatToStrf((E_Energy_Tot + B_Energy_Tot),ffExponent,5,2) + ' : ' + FloatToStr(100*(E_Energy_Tot + B_Energy_Tot)/Etotal) + ' % of ' + FloatToStrf(Etotal,ffExponent,5,2));
        WriteLn(myFile2, FloatToStr(100*Accel/ExpectedAccel));

        if PercentBetweenParticles < 100 then begin
          PercentBetweenParticles:= PercentBetweenParticles + 1;
          DistBetween.Text:=FloatToStrf(PercentBetweenParticles,ffFixed,4,2);
          DoUpdate:=true;
          Restart:=true;
        end
        else begin
          // Close the file
          CloseFile(myFile);
          CloseFile(myFile2);

          New_GridWidth:=100;
          New_GridHeight:=100;
          New_GridDepth:=100;
          DoUpdate:=true;
          Restart:=true;

          New_StartOption:=1;
          ProfileCancel();
        end;
      end;
    end;

    if two_particle_accel_actual_width_profile then begin
      if profile_changed then begin
        // Try to open the Analysis.txt file for writing to
        AssignFile(myFile, 'AccelActualWidthProfile_90_270_80.00%_16.67%_' + IntToStr(StartOption) + '.txt');
        AssignFile(myFile2, 'AccelActualWidthProfile_Summary_90_270_80.00%_16.67%_' + '%_' + IntToStr(StartOption) + '.txt');

        ReWrite(myFile);
        ReWrite(myFile2);

        ActualGridWidth.Text:=FloatToStrf(2.0E-11,ffExponent,5,2); {display actual size in metres that grid represents}
        ProcSetGridGlobals(Self);

        New_GridWidth:=90;
        New_GridHeight:=90;
        New_GridDepth:=90;

        PercentBetweenParticles:=80;
        DistBetween.Text:=FloatToStrf(PercentBetweenParticles,ffFixed,4,2);
        DoUpdate:=true;
        Restart:=true;
      end
      else begin
        WriteLn(myFile, 'Actual width ' + ActualGridWidth.Text + ' Grid size ' + IntToStr(GridWidth) + ', (' + FloatToStrf(PercentBetweenParticles,ffFixed,4,2) + '%)  : Accel is ' + FloatToStr(Accel) + ' (' + FloatToStr(100*Accel/ExpectedAccel) + '% of expected accel ' + FloatToStr(ExpectedAccel) + ')');
        WriteLn(myFile, 'E Energy = ' + FloatToStrf(E_Energy_Tot,ffExponent,5,2) + ', B Energy = ' + FloatToStrf(B_Energy_Tot,ffExponent,5,2) + ', Energy Total = ' + FloatToStrf((E_Energy_Tot + B_Energy_Tot),ffExponent,5,2) + ' : ' + FloatToStr(100*(E_Energy_Tot + B_Energy_Tot)/Etotal) + ' % of ' + FloatToStrf(Etotal,ffExponent,5,2));
        WriteLn(myFile2, FloatToStr(100*Accel/ExpectedAccel));

        if ActualWidth < 6E-11 then begin
          ActualWidth:=ActualWidth + 0.1E-11;
          ActualGridWidth.Text:=FloatToStrf(ActualWidth,ffExponent,5,2); {display actual size in metres that grid represents}
          ProcSetGridGlobals(Self);

          New_GridWidth:=Round(90*ActualWidth/2.0E-11);
          New_GridHeight:=Round(90*ActualWidth/2.0E-11);
          New_GridDepth:=Round(90*ActualWidth/2.0E-11);

          PercentBetweenParticles:=Round(80/(ActualWidth/2.0E-11));
          DistBetween.Text:=FloatToStrf(PercentBetweenParticles,ffFixed,4,2);
          DoUpdate:=true;
          Restart:=true;
        end
        else begin
          // Close the file
          CloseFile(myFile);
          CloseFile(myFile2);

          New_GridWidth:=100;
          New_GridHeight:=100;
          New_GridDepth:=100;
          DoUpdate:=true;
          Restart:=true;

          New_StartOption:=1;
          ProfileCancel();
        end;
      end;
    end;

    profile_changed:=false;

    if two_particle_analysis then begin
       if IterationCount >= 50 then begin
         // Close the file
         CloseFile(myFile);
         if StartOption < 17 then begin
           New_StartOption:=StartOption + 1;
           DoUpdate:=true;
           Restart:=true;
         end
         else begin
           // Try to open the Analysis.txt file for writing to
           AssignFile(myFile, 'AnalysisSummary.txt');
           ReWrite(myFile);
           AnalysisWriteHeader();
           for StartOption:=3 to 17 do begin
             WriteLn(myFile, 'StartOption: ' + IntToStr(StartOption) + '  Timestep: ' + IntToStr(IterationCount-1));
             WriteLn(myFile, '');
             AnalysisWriteResults(StartOption, IterationCount-1);
           end;
           // Close the file
           CloseFile(myFile);
           two_particle_analysis:=false;
           CheckBox12.Checked:=false;
         end;
       end;
    end;
  end
  else begin
    Energy3.Text:=FloatToStr(E_Energy_Tot+B_Energy_Tot); {display total field energy}
  end;

  progress:=100;
  update_progress_bar(progress);
end;

procedure TForm1.ProfileCancel;
begin
  Profile_RadioButton_Off.Checked:=true;
  Profile_RadioButton_ActualSize.Checked:=false;
  Profile_RadioButton_Distance.Checked:=false;
  Profile_RadioButton_GridSize.Checked:=false;

  two_particle_accel_profile_done:=true;
  two_particle_accel_actual_width_profile:=false;
  two_particle_accel_dist_profile:=false;
  two_particle_accel_profile:=false;

  profile_changed:=true;
  Restart:=true;
end;

procedure TForm1.Profile_RadioButton_ActualSizeClick(Sender: TObject);
begin
  Profile_RadioButton_Off.Checked:=false;
  Profile_RadioButton_ActualSize.Checked:=true;
  Profile_RadioButton_Distance.Checked:=false;
  Profile_RadioButton_GridSize.Checked:=false;

  two_particle_accel_profile_done:=false;
  two_particle_accel_actual_width_profile:=true;
  two_particle_accel_dist_profile:=false;
  two_particle_accel_profile:=false;
  profile_changed:=true;
  Restart:=true;
end;

procedure TForm1.Profile_RadioButton_DistanceClick(Sender: TObject);
begin
  Profile_RadioButton_Off.Checked:=false;
  Profile_RadioButton_ActualSize.Checked:=false;
  Profile_RadioButton_Distance.Checked:=true;
  Profile_RadioButton_GridSize.Checked:=false;

  two_particle_accel_profile_done:=false;
  two_particle_accel_actual_width_profile:=false;
  two_particle_accel_dist_profile:=true;
  two_particle_accel_profile:=false;
  profile_changed:=true;
  Restart:=true;
end;

procedure TForm1.Profile_RadioButton_GridSizeClick(Sender: TObject);
begin
  Profile_RadioButton_Off.Checked:=false;
  Profile_RadioButton_ActualSize.Checked:=false;
  Profile_RadioButton_Distance.Checked:=false;
  Profile_RadioButton_GridSize.Checked:=true;

  two_particle_accel_profile_done:=false;
  two_particle_accel_actual_width_profile:=false;
  two_particle_accel_dist_profile:=false;
  two_particle_accel_profile:=true;
  profile_changed:=true;
  Restart:=true;
end;

procedure TForm1.Profile_RadioButton_OffClick(Sender: TObject);
begin
  ProfileCancel();
end;

procedure TForm1.Propagate;
begin
  repeat

  Application.ProcessMessages;

  if justRestored then begin
    New_StartOption := StartOption;
    Restart:=false;
    Initialise(False);
    justRestored := false;
  end;

  if (New_StartOption<>StartOption) then StartOptionChanged:=true
  else StartOptionChanged:=false;

  if (New_StartOption<>StartOption) or Restart then begin  {Restart with new start option}
    Restart:=false;
    Time:=0;
    StartOption:=New_StartOption;

    if (StartOption >= 3) and (StartOption <= 20) then begin
//      EnergyCorrection:=true;
//      EnergyCorrectionCheckBox.Checked:=true;
      Profile_GroupBox.Enabled:=true;
      Profile_RadioButton_Off.Enabled:=true;
      Profile_RadioButton_GridSize.Enabled:=true;
      Profile_RadioButton_Distance.Enabled:=true;
      Profile_RadioButton_ActualSize.Enabled:=true;
    end
    else begin
//      EnergyCorrection:=false;
//      EnergyCorrectionCheckBox.Checked:=false;
      Profile_GroupBox.Enabled:=false;
      Profile_RadioButton_Off.Enabled:=false;
      Profile_RadioButton_GridSize.Enabled:=false;
      Profile_RadioButton_Distance.Enabled:=false;
      Profile_RadioButton_ActualSize.Enabled:=false;
    end;

    Initialise(False);
    UpdateDetails;           {ensure the screen is displaying up-to-date info}
    Auto_Scale(Screen); {determine the scaling factor required for current data}
    UpdateDetails;           {ensure the screen is displaying up-to-date info}
    UpdateBitmap(Screen); {Redraw the new data on the current screen(bitmap)}
    DisplayScreen(Screen);   {Display the current screen}
  end;

  if DoUpdate then begin
    ReDraw:=false;           {Prevent re-draw unless specifically asked to}
    UpdateDetails;           {ensure the screen is displaying up-to-date info}

    if (not FreezeTime) or Flip_YZ then begin   {if time is running}
      {Analyse the current grid & recalculate the new}
      {values for the E & H fields for the TimeStep}
      RecalcFields(Screen);

      if Screen=0 then Screen:=1 else Screen:=0;  {initiate screen swap}
      ReDraw:=true;
    end;

    {Update which Field is being shown}
    if DisplayField<>New_DisplayField then begin
      DisplayField:=New_DisplayField;
      ReDraw:=true;                      {Trigger a screen re-draw}
    end;

    UpdateDetails;          {ensure the screen is displaying up-to-date info}
    Auto_Scale(Screen);     {determine the scaling factor required for current data}
    UpdateDetails;          {ensure the screen is displaying up-to-date info}

    if ( Form1.Timesteps.Value <> 0 ) then begin
      if Redraw and (Timestep_count mod Form1.Timesteps.Value = 0) then begin
        UpdateBitmap(Screen); {Redraw the new data on the current screen(bitmap)}
        DisplayScreen(Screen);   {Display the current screen}
        Timestep_count:=0;
      end;
    end;

    DoUpdate:=false;
  end;

  if (not FreezeTime) and (StartOption<>0) and (not Flip_YZ) and ( not AllFields or ( AllFields and (DisplayField >= POWER_FLOW_FIELD))) then begin
     Time:=Time+TimeStep;  {if time is running, increase it by TimeStep}
     Inc(Timestep_count);
     Inc(FrameCount);
     DoUpdate:=true;
     ReDraw:=true;
  end;

  Flip_YZ:=false;

  if ( AllFields ) then begin
    New_DisplayField := DisplayField + 1;
    if( New_DisplayField > CHARGE_DENSITY_FIELD ) then New_DisplayField := 1;

    DoUpdate:=true;
  end;


  until Quit;
  Application.Terminate;
end;

procedure TForm1.UpdateBitmap(scr:smallint);
{Starting with a new, black, 24bit Colour bitmap, this routine takes all the }
{relevent selected display options into account and produces a complete bitmap}
{image ready to be displayed to screen. The main display options it considers }
{are: (a)which field to display. (b)Colour or Greyscale. (c)Vector arrows on/off.}
{(d)Z Plane tiling on/off. (e)Colours for each axis.}
var
  colour : longint;
  i,j,k,count :smallint;
  xyzcol: byte;
  value : double;
  VectorType : boolean;
  ArrowsX,ArrowsY,OffsetX,OffsetY: smallint;
  ArrowsOn,FirstY: boolean;
  ThisBitmap: Tbitmap;
  ActualX,ActualY: smallint;
  pointX,pointY,Xfrac,Yfrac: extended;
  Xleft,Ytop,imax,jmax,linescan: smallint;
  v1,v2,v3,v4,ArrowVect,ColVect,vect: vector;
  p1,p2,p3,p4: point;
  Xstep,Ystep,step_int: smallint;
  GridX,GridY: extended;
  JpegImage: TJpegImage;
  OutStream: TFileStream;
  path,fname,zstr: string;
  Point1,Point2,CopyPoint1,CopyPoint2: Point;
  xpos,ypos,zpos : smallint;
  pixel_count,black_count: longint;
  is_black: boolean;
  black_thres: longint;

begin

  black_thres:=80;
  black_count:=0;
  pixel_count:=0;

  if scr=0 then begin      {get a new bitmap}
    NewBitmap(@Bitmap1);
    ThisBitmap:=Bitmap1;
  end
  else begin
    NewBitmap(@Bitmap2);
    ThisBitmap:=Bitmap2;
  end;

  if TileZ then begin
    Xstep:=1;{round2(1/(TileScaleX*ScrScaleX))-1;   {Don't bother with points which map to}
    Ystep:=1; {round2(1/(TileScaleY*ScrScaleY))-1;   {the same screen pixel}
  end        {needs to be one less than theory to prevent beat freq}
  else begin
    Xstep:=1;                      {Full size picture so use every point}
    Ystep:=1;
  end;

    if (TileZ or (save_frames and save_3D)) then k:=0 else k:=Z_Plane; {set Z axis position. If Z Plane tiling,}
repeat

  Application.ProcessMessages;

  if ( save_frames and save_3D ) then begin
    if scr=0 then begin      {get a new bitmap}
      if (k = Z_Plane) then begin
        NewBitmap(@Bitmap1);
        ThisBitmap:=Bitmap1;
      end
      else begin
        NewBitmap(@Bitmap2);
        ThisBitmap:=Bitmap2;
      end;
    end
    else begin
      if (k = Z_Plane) then begin
        NewBitmap(@Bitmap2);
        ThisBitmap:=Bitmap2;
      end
      else begin
        NewBitmap(@Bitmap1);
        ThisBitmap:=Bitmap1;
      end;
    end;
  end;

  repeat                                {all Z values are drawn, one at a time }
    VectorType:=false;    {initialize working variables}
    vect:=NullVect;
    ColVect:=NullVect;
    value:=0;
    OffsetX:=0;
    OffsetY:=0;
    colour:=0;

    for j:=0 to BitmapY-1 do   {build array of bitmap line pointers}
      YLinePtrs[j]:=ThisBitmap.ScanLine[j];
    IsGrey:=not ShowColour;    {set local boolean values}
    ArrowsOn:=Arrows and (VectorX.Checked or VectorY.checked or VectorZ.checked);
    if (not TileZ) and ArrowsOn then begin {if vector arrows are required, do some calculations}
      arrow_step:=VectSpacing;    {using spacing value from control on Form}
      GridX:=(GridWidth+1)*ScrScaleX;     {width of active region in pixels}
      GridY:=(GridHeight+1)*ScrScaleY;    {height of active region in pixels}

      if Spacing_Metres.Checked then      {if spacing defined as 'n' per meter}
        arrow_step:=(GridX/(GridWidth*dx))/arrow_step; {rescale the step value}

      ArrowsX:=Trunc(GridX/arrow_step);  {determine number of arrows across screen}
      ArrowsY:=Trunc(GridY/arrow_step); {determine number of arrows up/down screen}
      OffsetX:=round2(Frac(GridX/arrow_step)*arrow_step/2);  {calc offsets for 1st arrow}
      OffsetY:=round2(Frac(GridY/arrow_step)*arrow_step/2);
      step_int:=Round2(arrow_step);
      if step_int=0 then Inc(step_int);
    end
    else step_int:=1; {prevent compiler giving 'uninitialised' warning message}

    i:=0;

    scr:=0;

    repeat    {scan through each (x,y) in Z plane of grid}
      j:=0;
      with points[scr]^[i,j,k] do repeat
       vect:=VectorProperty(DisplayField,points[scr]^[i,j,k]);

       case DisplayField of   {depending on which field is required to display}
          PSI_VECTOR_FIELD,
          ELECTRIC_FIELD,
          MAGNETIC_FIELD,
          POWER_FLOW_FIELD,
          HERTZIAN_FIELD,
          VECTOR_POTENTIAL_FIELD,
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
          PSI_CURL_VECTOR_FIELD,
          PARTICLE_POS_REFLECTED_FIELD,
          PARTICLE_NEG_REFLECTED_FIELD: begin {Show Electric, Magnetic, Power flow, Hertzian, Vector Potential or Electric Potential Fields}
{$ELSE}
          PSI_CURL_VECTOR_FIELD: begin {Show Electric, Magnetic, Power flow, Hertzian, Vector Potential or Electric Potential Fields}
{$IFEND}
                   VectorType:=true;
                 end;
          E_ELECTRIC_FIELD: value:=E_Energy(vect);   {Show energy in Electric Field}
          E_MAGNETIC_FIELD: value:=B_Energy(vect);   {Show energy in Magnetic Field}
          PSI_SCALAR_FIELD: value:=points[scr]^[i,j,k].Psi;
          ELECTRIC_POTENTIAL_FIELD: value:=points[scr]^[i,j,k].ElectricPotential;
          CHARGE_DENSITY_FIELD: value:=points[scr]^[i,j,k].ChargeDensity;
        end;

        if VectorType then begin {convert component values to colour values}
          ColVect:=VectToColours(vect,Amplification);
          with ColVect do begin   {Combine colours}

            colour:=0;
            is_black:=true;

            if ( X_RGB = GREY ) then begin
              xyzcol:=ColourRange(x/3,Amplification);   {set equal RGB colour values}
              colour:=colour + xyzcol*RED+xyzcol*GREEN+xyzcol*BLUE;    {Combine colours}
              if xyzcol >= black_thres then
                is_black:=false;
            end else begin
              colour:=colour + Round2(abs(x))*X_RGB;
              if Round2(abs(x)) >= black_thres then
                is_black:=false;
            end;

            if ( Y_RGB = GREY ) then begin
              xyzcol:=ColourRange(y/3,Amplification);   {set equal RGB colour values}
              colour:=colour + xyzcol*RED+xyzcol*GREEN+xyzcol*BLUE;    {Combine colours}
              if xyzcol >= black_thres then
                is_black:=false;
            end else begin
              colour:=colour + Round2(abs(y))*Y_RGB;
              if Round2(abs(y)) >= black_thres then
                is_black:=false;
            end;

            if ( Z_RGB = GREY ) then begin
              xyzcol:=ColourRange(z/3,Amplification);   {set equal RGB colour values}
              colour:=colour + xyzcol*RED+xyzcol*GREEN+xyzcol*BLUE;    {Combine colours}
              if xyzcol >= black_thres then
                is_black:=false;
            end else begin
              colour:=colour + Round2(abs(z))*Z_RGB;
               if Round2(abs(z)) >= black_thres then
                is_black:=false;
           end;

            SignArray[i,j,0]:=Sign(x);
            SignArray[i,j,1]:=Sign(y);
            SignArray[i,j,2]:=Sign(z);
          end;
        end;
        if (not VectorType) or IsGrey then begin {if greyscale display required}
          if VectorType then value:=VectSize(vect); {if vector use vector's size}
          xyzcol:=ColourRange(value,Amplification);   {set equal RGB colour values}
          colour:=xyzcol*RED+xyzcol*GREEN+xyzcol*BLUE;    {Combine colours}
          SignArray[i,j,0]:=Sign(xyzcol);
          SignArray[i,j,1]:=Sign(xyzcol);
          SignArray[i,j,2]:=Sign(xyzcol);
          is_black:=false;
          if xyzcol < black_thres then
            is_black:=true;
        end;
        if Rendered then begin {if colour or grey rendered display req'd}
          ColourArray[i,j]:=colour;   {save point's colour in array}
          Inc(pixel_count,1);
          if is_black then
            Inc(black_count,1);
        end;
        Inc(j,Ystep);
      until j>GridHeight-1;
      Inc(i,Xstep);
    until i>GridWidth-1;

    if pixel_count = 0 then
      Inc(pixel_count);

      ZplanePos:=k; {set global variable for current Z plane used by PlotPoint}

      i:=0;
      if Rendered then    {if colour or greyscale Rendered display req'd}
        repeat
          j:=0;
          repeat
            PlotPoint(ThisBitmap,i,j);  {plot each point onto bitmap}
            Inc(j,Ystep);
          until j>GridHeight-1;
          Inc(i,Xstep);
        until i>Gridwidth-1;

      if TileZ then                    {if Z Plane tiling required}
        TileCursor(ThisBitmap,ZplanePos,clGray);

      if VectorType and ArrowsOn and (not TileZ) then begin  {if Vector arrows required}

        if Spacing_gridpoints.Checked then begin

          if ( ScrScaleX > ScrScaleY ) then arrow_step:=VectSpacing*ScrScaleY;
          if ( ScrScaleY >= ScrScaleX ) then arrow_step:=VectSpacing*ScrScaleX;

          ArrowScale:=ArrowScaleFactor*arrow_step/$FF;    {set scaling factor for arrow size}

          i:=0;
          repeat
            j:=0;
            repeat
              ActualX:=round2(GetRealX((i+0.5)));  {the actual screen x location (on the image control)}
              ActualY:=round2(GetRealY((j+0.5)));  {the actual screen y location (on the image control)}
              p1:=points[scr]^[i,j,k];
              ArrowVect:=VectorProperty(DisplayField,p1);
              with ArrowVect do begin
                x:=x*ReScaleFactor*ArrowScale;          {re-scale raw values}
                y:=y*ReScaleFactor*ArrowScale;
                z:=z*ReScaleFactor*ArrowScale;
              end;
              DrawArrow(ThisBitmap,ActualX,ActualY,ArrowVect);    {draw the vector arrow}
              Inc(j,VectSpacing);
            until j>GridHeight-1;
            Inc(i,VectSpacing);
          until i>Gridwidth-1;

        end
        else begin

          ArrowScale:=ArrowScaleFactor*arrow_step/$FF;    {set scaling factor for arrow size}

          i:=OriginX+OffsetX;      {calc screen x coord of arrow start}
          imax:=round2(OriginX+GridWidth*ScrScaleX);   {calculate screen coords}
          jmax:=round2(OriginY+GridHeight*ScrScaleY);  {of edge of active region}
          repeat
            pointX:=(i-OriginX)/ScrScaleX;  {calc grid x coord for screen (i,j) }
            Xleft:=Trunc(pointX);    {find x coord of top left point}
            Xfrac:=pointX-Xleft;     {calc fractional distance to next point}
            j:=OriginY+OffsetY;    {calc screen y coord of arrow start}
            repeat
              pointY:=(j-OriginY)/ScrScaleY; {calc grid y coord for screen (i,j) }
              Ytop:=Trunc(pointY);   {find y coord of top left point}
              Yfrac:=pointY-Ytop;    {calc fractional distance to next point}
              p1:=points[scr]^[Xleft,Ytop,k];
              if Xleft<(GridWidth-1) then      {get relevant point vectors}
                p2:=points[scr]^[Xleft+1,Ytop,k] else p2:=NullPoint;
              if YTop<(GridHeight-1) then
                p3:=points[scr]^[Xleft,Ytop+1,k] else p3:=NullPoint;
              if (Xleft<(GridWidth-1)) and (YTop<(GridHeight-1)) then
                p4:=points[scr]^[Xleft+1,Ytop+1,k] else p4:=NullPoint;
              if not PointNull(p1, DisplayField) then
                v1:=VectorProperty(DisplayField,p1) else v1:=NullVect;
              if not PointNull(p2, DisplayField) then
                v2:=VectorProperty(DisplayField,p2) else v2:=NullVect;
              if not PointNull(p3, DisplayField) then
                v3:=VectorProperty(DisplayField,p3) else v3:=NullVect;
              if not PointNull(p4, DisplayField) then
                v4:=VectorProperty(DisplayField,p4) else v4:=NullVect;
              ArrowVect:=VectorInterpolate(v1,v2,v3,v4,Xfrac,Yfrac);
              with ArrowVect do begin
                x:=x*ReScaleFactor*ArrowScale;          {re-scale raw values}
                y:=y*ReScaleFactor*ArrowScale;
                z:=z*ReScaleFactor*ArrowScale;
              end;
              DrawArrow(ThisBitmap,i,j,ArrowVect);    {draw the vector arrow}
              Inc(j,step_int);
            until j>=jmax;     {do next arrow till done}
            Inc(i,step_int);
          until i>=imax;
        end;
      end;
      Inc(k);                {do next Z Plane}
  until (not TileZ) or (k>GridDepth-1); {only repeat if tiling req'd and Z plane in range}

  if TileZ then   {draw a red rectangle around the currently selected Z plane}
    TileCursor(ThisBitmap,Z_Plane,clRed);

  if MaintainAspect and (not TileZ) then with ThisBitmap.Canvas do begin
    Pen.Width:=1;                        {set pen to thin white line}
    Pen.Style:=psSolid;
    Pen.Color:=clGray;
    if OriginX<>0 then begin                    {Draw boundary lines for Grid within the }
      MoveTo(OriginX-2,0);          {Screen space if the Aspect ratio is being}
      LineTo(OriginX-2,BitmapY);    {preserved and onlypart of the screen space}
      MoveTo(BitmapX-OriginX,0);  {is active.}
      LineTo(BitmapX-OriginX,BitmapY);
    end;
    if OriginY<>0 then begin
      MoveTo(0,OriginY-2);
      LineTo(BitmapX,OriginY-2);
      MoveTo(0,BitmapY-OriginY);
      LineTo(BitmapX,BitmapY-OriginY);
    end;
  end;

  if ( save_frames ) then begin
    // convert to jpeg and save
    try
      JpegImage := TJpegImage.Create;
      JpegImage.Assign(ThisBitmap);

      path := '.\Frames\';

      case DisplayField of   {depending on which field is required to display}
        PSI_VECTOR_FIELD:
          fname := 'PsiVectWaveEqn';
        PSI_SCALAR_FIELD:
          fname := 'PsiWaveEqnScalar';
        ELECTRIC_POTENTIAL_FIELD:
          fname := 'ElecPotential';
        HERTZIAN_FIELD:
          fname := 'HertzianVect';
        VECTOR_POTENTIAL_FIELD:
          fname := 'VectPotential';
        ELECTRIC_FIELD:
          fname := 'Electric';
        MAGNETIC_FIELD:
          fname := 'Magnetic';
        E_ELECTRIC_FIELD:
          fname := 'E_Energy';
        E_MAGNETIC_FIELD:
          fname := 'B_Energy';
        POWER_FLOW_FIELD:
          fname := 'Power';
        CHARGE_DENSITY_FIELD:
          fname := 'ChargeDensity';
        PSI_CURL_VECTOR_FIELD:
          fname := 'PsiCurl';
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
        PARTICLE_POS_REFLECTED_FIELD:
          fname := 'Particle_pos_Reflected';
        PARTICLE_NEG_REFLECTED_FIELD:
          fname := 'Particle_neg_Reflected';
{$IFEND}
      end;

      if (FrameCount < 10) then fname:=fname+'00000'
      else if (FrameCount < 100) then fname:=fname+'0000'
      else if (FrameCount < 1000) then fname:=fname+'000'
      else if (FrameCount < 10000) then fname:=fname+'00'
      else if (FrameCount < 100000) then fname:=fname+'0';

      if (k < 10) then zstr:='00000'
      else if (k < 100) then zstr:='0000'
      else if (k < 1000) then zstr:='000'
      else if (k < 10000) then zstr:='00'
      else zstr:='0';

      if not DirectoryExists(path) then CreateDir(path);

      if ( save_3D ) then begin
        OutStream := TFileStream.Create(path+fname+IntToStr(FrameCount)+'_z'+zstr+IntToStr(k)+'.jpg',fmOpenWrite or fmCreate or fmShareDenyNone);
      end
      else begin
        OutStream := TFileStream.Create(path+fname+IntToStr(FrameCount)+'.jpg',fmOpenWrite or fmCreate);
      end;

      JpegImage.SaveToStream(OutStream);
    finally
      JpegImage.Free;
      OutStream.Free;
      OutStream:=nil;
    end;
  end;

until (not (save_frames and save_3D)) or (k>GridDepth-1); {only repeat if tiling req'd and Z plane in range}

  if (AutoScale=CONTINUAL) or (AutoScale=AVERAGE) then begin
    if (black_count/pixel_count) > 0.6 then begin
      if DisplayLevel.Position > 0 then
        DisplayLevel.Position:=2000 - ((2000 - DisplayLevel.Position)*2);
      New_DisplayLevel:=DisplayLevel.Position;
      DoUpdate:=true;
    end;
  end;

end;

procedure TForm1.DisplayScreen(scr:smallint);  {display the current bitmap}
begin
  if scr=0 then
    CurrentBitmap:= Bitmap1  {set the picture control to display bitmap1}
  else
    CurrentBitmap:= Bitmap2;  {set the picture control to display bitmap2}
  Image1.Picture.Graphic:=CurrentBitmap
end;

procedure TForm1.DistBetweenChange(Sender: TObject);
var
  newPercentage: extended;
begin
  newPercentage:=strtofloat(DistBetween.Text);
  newPercentage:=Round(newPercentage*100)/100;

  if (PercentBetweenParticles <> newPercentage) then begin
    DoUpdate:=true;
    Restart:=true;
  end;
//  if not DoUpdate then ProfileCancel();
end;

procedure TForm1.Start1Click(Sender: TObject);
{The 1st Start option has been selected}
begin
  New_StartOption:=1;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start2Click(Sender: TObject);
{The 2nd Start option has been selected}
begin
  New_StartOption:=2;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.start3Click(Sender: TObject);
{The 3rd Start option has been selected}
begin
  New_StartOption:=3;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start4Click(Sender: TObject);
{The 4th Start option has been selected}
begin
  New_StartOption:=4;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start5Click(Sender: TObject);
{The 5th Start option has been selected}
begin
  New_StartOption:=5;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start6Click(Sender: TObject);
{The 6th Start option has been selected}
begin
  New_StartOption:=6;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start7Click(Sender: TObject);
{The 7th Start option has been selected}
begin
  New_StartOption:=7;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start8Click(Sender: TObject);
{The 8th Start option has been selected}
begin
  New_StartOption:=8;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start9Click(Sender: TObject);
{The 9th Start option has been selected}
begin
  New_StartOption:=9;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start10Click(Sender: TObject);
{The 10th Start option has been selected}
begin
  New_StartOption:=10;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start11Click(Sender: TObject);
{The 11th Start option has been selected}
begin
  New_StartOption:=11;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start12Click(Sender: TObject);
{The 12th Start option has been selected}
begin
  New_StartOption:=12;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start13Click(Sender: TObject);
{The 13th Start option has been selected}
begin
  New_StartOption:=13;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start14Click(Sender: TObject);
{The 14th Start option has been selected}
begin
  New_StartOption:=14;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start15Click(Sender: TObject);
{The 15th Start option has been selected}
begin
  New_StartOption:=15;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start16Click(Sender: TObject);
{The 16th Start option has been selected}
begin
  New_StartOption:=16;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start17Click(Sender: TObject);
{The 17th Start option has been selected}
begin
  New_StartOption:=17;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start18Click(Sender: TObject);
{The 18th Start option has been selected}
begin
  New_StartOption:=18;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start19Click(Sender: TObject);
{The 19th Start option has been selected}
begin
  New_StartOption:=19;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start20Click(Sender: TObject);
{The 20th Start option has been selected}
begin
  New_StartOption:=20;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start21Click(Sender: TObject);
{The 21st Start option has been selected}
begin
  New_StartOption:=21;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start22Click(Sender: TObject);
{The 22nd Start option has been selected}
begin
  New_StartOption:=22;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start23Click(Sender: TObject);
{The 23rd Start option has been selected}
begin
  New_StartOption:=23;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start24Click(Sender: TObject);
{The 24th Start option has been selected}
begin
  New_StartOption:=24;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start25Click(Sender: TObject);
{The 25th Start option has been selected}
begin
  New_StartOption:=25;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

procedure TForm1.Start26Click(Sender: TObject);
{The 26th Start option has been selected}
begin
  New_StartOption:=26;
  if StartOption<>New_StartOption then begin
    DoUpdate:=true;
    Restart:=true;
    ProfileCancel();
  end;
end;

function TForm1.sign(number: extended): shortint;
{This function takes a real number and returns either -1 or +1 }
{If: number<0, -1 is returned }
{    number>=0, +1 is returned }
var
  signval: shortint;
begin
  if number>=0 then signval:=1
  else signval:=-1;
  Result:=signval;
end;

procedure TForm1.Field0Click(Sender: TObject);
{The Magnetic field has been selected to be displayed}
begin
  New_DisplayField:=PSI_VECTOR_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field1Click(Sender: TObject);
{The Electric field has been selected to be displayed}
begin
  New_DisplayField:=PSI_CURL_VECTOR_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field2Click(Sender: TObject);
{The Magnetic field has been selected to be displayed}
begin
  New_DisplayField:=ELECTRIC_POTENTIAL_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field3Click(Sender: TObject);
{The Psi Vector field has been selected to be displayed}
begin
  New_DisplayField:=HERTZIAN_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field4Click(Sender: TObject);
{The Magnetic field Energy has been selected to be displayed}
begin
  New_DisplayField:=VECTOR_POTENTIAL_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field5Click(Sender: TObject);
{The Power flow field has been selected to be displayed}
begin
  New_DisplayField:=ELECTRIC_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field6Click(Sender: TObject);
{The Magnetic field has been selected to be displayed}
begin
  New_DisplayField:=MAGNETIC_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field7Click(Sender: TObject);
{The Electric field Energy has been selected to be displayed}
begin
  New_DisplayField:=E_ELECTRIC_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field8Click(Sender: TObject);
{The Magnetic field has been selected to be displayed}
begin
  New_DisplayField:=E_MAGNETIC_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field9Click(Sender: TObject);
{The Magnetic field has been selected to be displayed}
begin
  New_DisplayField:=POWER_FLOW_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field10Click(Sender: TObject);
{The Magnetic field has been selected to be displayed}
begin
  New_DisplayField:=CHARGE_DENSITY_FIELD;
  DoUpdate:=true;
end;

procedure TForm1.Field11Click(Sender: TObject);
{The Magnetic field has been selected to be displayed}
begin
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
  New_DisplayField:=PARTICLE_POS_REFLECTED_FIELD;
  DoUpdate:=true;
{$IFEND}
end;

procedure TForm1.Field12Click(Sender: TObject);
{The Magnetic field has been selected to be displayed}
begin
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
  New_DisplayField:=PARTICLE_NEG_REFLECTED_FIELD;
  DoUpdate:=true;
{$IFEND}
end;

procedure TForm1.TimeFreezeClick(Sender: TObject);
{The Freeze Time control has been changed, so toggle button's text}
begin
  if FreezeTime then New_FreezeTime:=false else New_FreezeTime:=true;
  DoUpdate:=true;
end;

function TForm1.Gauss(x: extended): extended;
{return a value (between 0 and -1) corresponding to a gaussian distribution}
{based of the x value supplied. The whole curve (essentially) is defined }
{between x=-2 to x=2}
begin
  result:=Exp(-sqr(x));
end;

procedure TForm1.UpdateDetails();
var
  ReCalcTileSize,ReCalcAspectRatio: boolean;
begin
  ReCalcTileSize:=false;          {Default re-calc to Off}
  ReCalcAspectRatio:=false;       {Default re-calc to Off}

  Flip_YZ:=New_Flip_YZ;
  New_Flip_YZ:=false;

  if ViewTop<>ViewFromTop.Checked then begin
    ViewTop := ViewFromTop.Checked;
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  // If flipping Y & Z planes, need to make sure they have the same dimensions first.
  if Flip_YZ then begin
    if GridHeight > GridDepth then New_GridHeight := GridDepth;
    if GridDepth > GridHeight then New_GridDepth := GridHeight;
  end;

  {Reset the Grid Dimensions if required (retains existing data)}
  if ((New_GridWidth<>GridWidth) or (New_GridHeight<>GridHeight) or
      (New_GridDepth<>GridDepth)) or FirstPass then begin
    ReAllocGridMemory;                 {Re-allocate memory for new Grid size}
    GridWidth:=New_GridWidth;          {Adopt new Dimensions}
    GridHeight:=New_GridHeight;
    GridDepth:=New_GridDepth;

    if ( GridHeight <> GridDepth ) then ViewFromTop.Enabled := false else ViewFromTop.Enabled := true;

    GridX.Text:=IntToStr(GridWidth);   {Ensure Controls reflect Current}
    GridY.Text:=IntToStr(GridHeight);  {program settings.}
    GridZ.Text:=IntToStr(GridDepth);
    SetGridGlobals;                    {Re-Calc Globals for new Grid size}
    ReCalcAspectRatio:=true;           {Trigger an Aspect Ratio recalculation}
    ReCalcTileSize:=true;              {Trigger a Tile Size recalculation}
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  {Update Time Related Displays}
  TimeDisplay.Text:='Time (Secs) : '+FloatToStr(Time); {update time display}
  if (FreezeTime<>New_FreezeTime) or FirstPass then begin
    FreezeTime:=New_FreezeTime;
    with TimeFreeze do
      if FreezeTime then
        Caption:='Unfreeze Time'
      else
        Caption:='Freeze Time';
  end;

  {Update the Auto-Scale selection}
  if (New_AutoScale<>AutoScale) or FirstPass then begin
    if (AutoScale=CONTINUAL) or (AutoScale=AVERAGE) then begin {Re-Enable control incase it was out of}
      ReScale.Enabled:=true;          {range whilst autoscaling.}
      New_ReScale:=ReScaleFactor;     {Prevent the next update, as the control}
      New_DisplayLevel:=Display_Level;{was turned off.}
    end;
    AutoScale:=New_AutoScale;         {Adopt the new control state.}
    case AutoScale of
      START:     begin
                   if Time=0 then begin
                     AutoWarn.Top:=Auto1.Top+2; {Show Auto-scale warning indicator}
                     AutoWarn.Visible:=true;    {next to the relevant button.}
                     AutoWarnTimer.Enabled:=true;
                   end
                   else begin
                     AutoWarn.Visible:=false;
                     AutoWarnTimer.Enabled:=false;
                   end;
                 end;
      CONTINUAL: begin
                   AutoWarn.Top:=Auto2.Top+2; {Show Auto-scale warning indicator}
                   AutoWarn.Visible:=true;    {next to the relevant button.}
                   AutoWarnTimer.Enabled:=true;
                 end;
      NEVER:     begin
                   AutoWarn.Visible:=false;
                   AutoWarnTimer.Enabled:=false;
                 end;
      AVERAGE: begin
                   AutoWarn.Top:=Auto2.Top+2; {Show Auto-scale warning indicator}
                   AutoWarn.Visible:=true;    {next to the relevant button.}
                   AutoWarnTimer.Enabled:=true;
                 end;
    end;
  end;

  {Turn off Auto Scale indicator after time started if req'd}
  if (Time<>0) and (AutoScale=START) then begin
    AutoWarn.Visible:=false;
    AutoWarnTimer.Enabled:=false;
  end;

  {Update the display mode Colour/GreyScale}
  if New_ShowColour<>ShowColour then begin
    ShowColour:=New_ShowColour;
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  {Update Axis Colour Allocation}
  if UpdateColours or FirstPass then begin
    UpdateAxisColours(New_AxisColours);
    UpdateColours:=false;
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  if (New_Rendered<>Rendered) or FirstPass then begin
    Rendered:=New_Rendered;
    if Rendered then begin
      RendGroup.Enabled:=true;
      RenderOption1.Enabled:=true;
      RenderOption2.Enabled:=true;
      RenderOption3.Enabled:=true;
      ColourButton.Enabled:=true;
      GreyScaleButton.Enabled:=true;
    end
    else begin
      RendGroup.Enabled:=false;
      RenderOption1.Enabled:=false;
      RenderOption2.Enabled:=false;
      RenderOption3.Enabled:=false;
      ColourButton.Enabled:=false;
      GreyScaleButton.Enabled:=false;
    end;
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  {Update the Maintain Aspect Ratio Checkbox control}
  if (New_MaintainAspect<>MaintainAspect) or FirstPass then begin
    MaintainAspect:=New_MaintainAspect;
    ReCalcAspectRatio:=true;           {Trigger an Aspect Ratio recalculation}
    ReCalcTileSize:=true;              {Trigger a Tile Size recalculation}
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  {Update the screen rendering Option}
  if (New_Render<>Render) or FirstPass then begin
    Render:=New_Render;
    ReCalcTileSize:=true;     {Reset Tiling size for new Rendering selection}
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  {Update Z Tiling Option Variable and button display}
  if (TileZ<>New_TileZ) or FirstPass then begin
    TileZ:=New_TileZ;
    ReDraw:=true;                      {Trigger a screen re-draw}
    with Z_Tiling do
      if TileZ then
        Caption:='Single Z Plane'
      else
        Caption:='Tile Z Planes';
  end;

  {Update Currently displayed Z plane, the control's value and its display}
  if (Z_Plane<>New_ZPlane) or FirstPass then begin
    {Shift Tile Cursor if new tile selected}
    if TileZ then begin
      TileCursor(CurrentBitmap,Z_Plane,clGray);   {return old Tile's border to Grey}
      TileCursor(CurrentBitmap,New_ZPlane,clRed); {Outline new Tile's border in Red}
    end
    else ReDraw:=true;                  {Trigger a screen re-draw}
    Z_Plane:=New_ZPlane;
    ZPlane.Position:=Z_Plane+1;
    Z_Plane_Number.Text:='Z Plane :  '+IntToStr(Z_Plane+1)+'  (of '+IntToStr(GridDepth)+')';
  end;

  if ReCalcAspectRatio then SetAspectRatio;    {Re-Calc if flagged}
  if ReCalcTileSize then SetTileSize;

  {Update the Re-scaling factor value and ensure control's value agrees}
  if (ReScaleFactor<>New_ReScale) or FirstPass then begin
    ReScaleFactor:=New_ReScale;
    ReScale.Enabled:=true;
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  {Update the DisplayLevel control's position}
  if (Display_Level<>New_DisplayLevel) or FirstPass then begin
    Display_Level:=New_DisplayLevel;
    if ((AutoScale=CONTINUAL) or (AutoScale=AVERAGE) or ((AutoScale=START) and (Time=0))) then
      DisplayLevel.Position:=Display_Level;
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  if (Rate_Of_Time<>New_RateOfTime) or FirstPass then begin
    Rate_Of_Time:=New_RateOfTime;
    TimeStep:=(Rate_Of_Time/RATE_OF_TIME_DIVISOR)/SpeedOfLight; {Increment of Time per iteration - Secs }
  end;

  {Calc the Amplification factor & update its display}
//  CentrePos:=Round2(DisplayLevel.Max/2);
  Amplification:=1000*(DisplayLevel.Max - Display_Level);
  AmpDisplay.Text:='Amplification :  '+IntToStr(Trunc(Amplification))+'%';
  Amplification:=ReScaleFactor*Amplification/100;

  {Update all the Field's statistical values}
  Energy1.Text:=FloatToStr(E_Energy_Tot); {display the Electric field energy total}
  Energy2.Text:=FloatToStr(B_Energy_Tot); {display the Magnetic field energy total}
//  Energy3.Text:=FloatToStr(E_Energy_Tot+B_Energy_Tot); {display total field energy}
  if (ShowEnergy_CheckBox.Checked) then Energy4.Text:=FloatToStr(Etotal); {display total field energy}

//  ActualGridWidth.Text:=FloatToStrf(ActualWidth,ffExponent,5,2); {display actual size in metres that grid represents}

  try
    New_VectSpacing:=StrToInt(VectorSpacing.Text);
  except                       {catch any invalid integer conditions}
    on E: Exception do begin
      VectorSpacing.Text:='11';
      New_VectSpacing:=11;
    end;
  end;

  {Update the Vector Arrows' spacing value}
  if (New_VectSpacing<>VectSpacing) or FirstPass then begin
    VectSpacing:=New_VectSpacing;
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  {The X,Y or Z vector arrows have been selected/de-selected, so re-draw req'd}
  if VectorChange then begin
    VectorChange:=false;
    ReDraw:=true;
  end;

  {if the Arrows separation units have been changed, trigger a re-draw}
  if ArrowsUnitsChange then begin
    ArrowsUnitsChange:=false;
    ReDraw:=true;
  end;

  {Update Arrows variable & status of Vector Arrows controls}
  if (Arrows<>New_Arrows) or FirstPass then begin
    Arrows:=New_Arrows;
    if Arrows then begin
      VectorX.Enabled:=true;
      VectorY.Enabled:=true;
      VectorZ.Enabled:=true;
      Spacing_Text.Enabled:=true;
      VectorSpacing.Enabled:=true;
      Spacing_pixels.Enabled:=true;
      Spacing_metres.Enabled:=true;
      Spacing_gridpoints.Enabled:=true;
    end
    else begin
      VectorX.Enabled:=false;
      VectorY.Enabled:=false;
      VectorZ.Enabled:=false;
      Spacing_Text.Enabled:=false;
      VectorSpacing.Enabled:=false;
      Spacing_pixels.Enabled:=false;
      Spacing_metres.Enabled:=false;
      Spacing_gridpoints.Enabled:=false;
    end;
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  if (ArrowScaleFactor <> New_ArrowScaleFactor) or FirstPass then begin
    ArrowScaleFactor := New_ArrowScaleFactor;
    ReDraw:=true;                      {Trigger a screen re-draw}
  end;

  FirstPass:=false;
end;

procedure TForm1.ZPlaneChange(Sender: TObject);
{The Z plane control has been changed, so re-validate display values}
begin
  New_ZPlane:=ZPlane.Position-1;
  DoUpdate:=true;
end;

procedure TForm1.DisplayLevelChange(Sender: TObject);
{The displaylevel slider control has been changed, so re-validate display values}
begin
  New_DisplayLevel:=DisplayLevel.Position;
  DoUpdate:=true;
end;

procedure TForm1.ReScaleChange(Sender: TObject);
{The rescale factor control has been changed, so re-validate display values}
begin
  try
    New_ReScale:=ReScale.value;
  except                       {catch any invalid integer conditions}
    on E: Exception do
      New_ReScale:=ReScaleFactor;
  end;
  DoUpdate:=true;
end;

procedure TForm1.X_RedClick(Sender: TObject);
{The x axis display colour has been changed, so set it to new colour}
begin
  New_AxisColours:='X';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.X_GreenClick(Sender: TObject);
{The x axis display colour has been changed, so set it to new colour}
begin
  New_AxisColours:='X';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.X_BlueClick(Sender: TObject);
{The x axis display colour has been changed, so set it to new colour}
begin
  New_AxisColours:='X';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.X_greyClick(Sender: TObject);
begin
  New_AxisColours:='X';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.X_noneClick(Sender: TObject);
begin
  New_AxisColours:='X';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Y_RedClick(Sender: TObject);
{The y axis display colour has been changed, so set it to new colour}
begin
  New_AxisColours:='Y';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Y_GreenClick(Sender: TObject);
{The y axis display colour has been changed, so set it to new colour}
begin
  New_AxisColours:='Y';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Y_BlueClick(Sender: TObject);
{The y axis display colour has been changed, so set it to new colour}
begin
  New_AxisColours:='Y';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Y_greyClick(Sender: TObject);
begin
  New_AxisColours:='Y';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Y_noneClick(Sender: TObject);
begin
  New_AxisColours:='Y';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Z_RedClick(Sender: TObject);
{The z axis display colour has been changed, so set it to new colour}
begin
  New_AxisColours:='Z';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Z_GreenClick(Sender: TObject);
{The z axis display colour has been changed, so set it to new colour}
begin
  New_AxisColours:='Z';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Z_BlueClick(Sender: TObject);
{The z axis display colour has been changed, so set it to new colour}
begin
  New_AxisColours:='Z';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Z_greyClick(Sender: TObject);
begin
  New_AxisColours:='Z';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.Z_noneClick(Sender: TObject);
begin
  New_AxisColours:='Z';
  UpdateColours:=true;
  DoUpdate:=true;
end;

procedure TForm1.GreyscaleButtonClick(Sender: TObject);
{The greyscale display button has been selected, so set global variable}
begin
  if GreyscaleButton.Checked then
    New_ShowColour:=false else New_ShowColour:=true;
  DoUpdate:=true;
end;

procedure TForm1.ColourButtonClick(Sender: TObject);
{The colour gradient display button has been selected, so set global variable}
begin
  if ColourButton.Checked then
    New_ShowColour:=true else New_ShowColour:=false;
  DoUpdate:=true;
end;

procedure TForm1.UpdateAxisColours(which: string);
{Ensures that the colour rectangles showing the primary colour currently}
{being used to depict that axis, are correct. If ALL is passed as a parameter}
{all the colour bitmaps are updated. Likewise if X,Y or Z are passed then only}
{that axis colour is updated.}
begin
  if (which='ALL') or (which='X') then begin
    if X_Red.Checked then X_RGB:=RED;      {only one of these can be true}
    if X_Green.Checked then X_RGB:=GREEN;
    if X_Blue.Checked then X_RGB:=BLUE;
    if X_grey.Checked then X_RGB:=GREY;
    if X_none.Checked then X_RGB:=BLACK;
    with X_Colour.Picture do
      case X_RGB of                        {point to correct bitmap}
        RED:   Graphic:=BitmapRed;
        GREEN: Graphic:=BitmapGreen;
        BLUE:  Graphic:=BitmapBlue;
        GREY:  Graphic:=BitmapGrey;
        BLACK: Graphic:=BitmapBlack;
      end;
  end;
  if (which='ALL') or (which='Y') then begin
    if Y_Red.Checked then Y_RGB:=RED;      {only one of these can be true}
    if Y_Green.Checked then Y_RGB:=GREEN;
    if Y_Blue.Checked then Y_RGB:=BLUE;
    if Y_grey.Checked then Y_RGB:=GREY;
    if Y_none.Checked then Y_RGB:=BLACK;
    with Y_Colour.Picture do
      case Y_RGB of                        {point to correct bitmap}
        RED:   Graphic:=BitmapRed;
        GREEN: Graphic:=BitmapGreen;
        BLUE:  Graphic:=BitmapBlue;
        GREY:  Graphic:=BitmapGrey;
        BLACK: Graphic:=BitmapBlack;
      end;
  end;
  if (which='ALL') or (which='Z') then begin
    if Z_Red.Checked then Z_RGB:=RED;      {only one of these can be true}
    if Z_Green.Checked then Z_RGB:=GREEN;
    if Z_Blue.Checked then Z_RGB:=BLUE;
    if Z_grey.Checked then Z_RGB:=GREY;
    if Z_none.Checked then Z_RGB:=BLACK;
    with Z_Colour.Picture do
      case Z_RGB of                        {point to correct bitmap}
        RED:   Graphic:=BitmapRed;
        GREEN: Graphic:=BitmapGreen;
        BLUE:  Graphic:=BitmapBlue;
        GREY:  Graphic:=BitmapGrey;
        BLACK: Graphic:=BitmapBlack;
      end;
  end;
end;

procedure TForm1.Auto1Click(Sender: TObject);
{The AutoScale at Start Only button has been selected}
begin
  New_AutoScale:=START;
  DoUpdate:=true;
end;

procedure TForm1.Auto2Click(Sender: TObject);
{The AutoScale Continual button has been selected}
begin
  New_AutoScale:=CONTINUAL;
  DoUpdate:=true;
end;

procedure TForm1.Auto3Click(Sender: TObject);
{The AutoScale Never button has been selected}
begin
  New_AutoScale:=NEVER;
  DoUpdate:=true;
end;

procedure TForm1.Auto4Click(Sender: TObject);
{The AutoScale Never button has been selected}
begin
  New_AutoScale:=AVERAGE;
  DoUpdate:=true;
end;

procedure TForm1.Auto_Scale(scr: smallint);  {Calculate scaling factor for data display}
{If AutoScale is not set to NEVER, then the colours (RGB values) are scaled}
{such that the grid point of maximum absolute value for the quantity currently}
{being displayed is given the maximum colour value (255 or $FF). The other }
{points are given colours determined by a linear transition from zero to that}
{maximum value. The absolute values are used for determining the colour, so}
{that for example: -100 and +100 will be displayed as the same colour}
const
  PixMax=$FF;
begin
  if AutoScale<> NEVER then begin     {only autoscale if option selected}
    if (AutoScale=CONTINUAL) or (AutoScale=AVERAGE) or ((AutoScale=START) and (Time=0)) then begin

      if (AutoScale=AVERAGE) then
      begin
        FindAverageVal(scr,DisplayField);  {Find the Average value of the field concerned}
      end
      else begin
        FindMaxVal(scr,DisplayField);  {Find the Maximum value of the field concerned}
      end;

      if MaxVal<>0 then begin
        if not IsVectorField(DisplayField) then begin
          New_ReScale:=(PixMax/MaxVal)/3;
        end
        else begin
          New_ReScale:=PixMax/MaxVal;
        end;
      end
      else begin
        New_ReScale:=0;           {if all screen points have zero value,}
      end;                        {reset default scaling control positions}

      DoUpdate:=true;
    end;
  end;
end;

procedure TForm1.MaxCheck(element: PointPtr);
begin
  with element.Electric do          {for Electric field of current grid point}
    if Max_E<>0 then begin          {if a maximum allowable value is defined}
      if x>Max_E then x:=Max_E;     {restrict the point's values to within this}
      if y>Max_E then y:=Max_E;     {range of values}
      if z>Max_E then z:=Max_E;
      if x<-Max_E then x:=-Max_E;
      if y<-Max_E then y:=-Max_E;
      if z<-Max_E then z:=-Max_E;
    end;
  with element.Magnetic do          {for Magnetic field of current grid point}
    if Max_B<>0 then begin          {if a maximum allowable value is defined}
      if x>Max_B then x:=Max_B;     {restrict the point's values to within this}
      if y>Max_B then y:=Max_B;     {range of values}
      if z>Max_B then z:=Max_B;
      if x<-Max_B then x:=-Max_B;
      if y<-Max_B then y:=-Max_B;
      if z<-Max_B then z:=-Max_B;
    end;
end;

function TForm1.VectSize(vect: Vector): extended;
{Calculate the total vector size by combining the three component vectors}
begin
  with vect do
    Result:=sqrt(sqr(x)+sqr(y)+sqr(z));
end;

function TForm1.BtoH(Bvect: Vector): Vector;
{Convert Magnetic B vector to Magnetic H vector}
var
  Hvect: Vector;
begin

  with Hvect do begin
    x := Bvect.x/Permeability;
    y := Bvect.y/Permeability;
    z := Bvect.z/Permeability;
  end;

  Result:=Hvect;
end;

function TForm1.E_Energy(E_vect: Vector): extended;
{ calculate the energy density in the electric field at the point with instantaneous amplitude E_amp. }
{                                                                                                     }
{ Assuming a time-harmonic electric field:                                                            }
{ From : https://web.stanford.edu/group/fan/publication/Shin_JOSAB_29_1048_2012.pdf                   }
{  and : https://doubtnut.com/question-answer-physics/the-average-value-of-electric-energy-density-in-an-electromagnetic-wave-is-e0-is-peak-value-11971302 }
{  and : https://arxiv.org/pdf/1111.4354.pdf   (p12,13)                                                  }
{ Electric energy density ue=(1/2)*ε0*ε^2rms

  RMS in 1 dimension:
    Ems=E/√2
    ∴ue=(1/4)*ε0*E^2

  RMS in 3 cartesian coordinate dimensions (x, y, z), as the
  wave-function is sinusoidal in all three dimensions:

    Ems=E/(√2*√2*√2)
    ∴ue=(1/16)*ε0*E^2
}
var
  amp: Extended;
begin
  amp:= VectSize(E_vect);
  Result:=0.5*Permittivity*sqr(amp/(sqrt(2)*sqrt(2)*sqrt(2)));
end;

function TForm1.B_Energy(B_vect: Vector): extended;
{calculate the energy density in the magnetic field at the point with instantaneous amplitude B_amp.  }
{                                                                                                     }
{ Assuming a time-harmonic electromagnetic field:                                                     }
{ From: https://www.researchgate.net/publication/249341418_Electromagnetic_energy_density_in_dispersive_and_dissipative_media }
{ ue=(1/4)*(ε0*E^2 + μ*H^2)
{
{ Magnetic energy density ue=(1/2)*μ0*H^2rms
{
  RMS in 1 dimension:
    Hms=H/√2
    ∴ue=(1/4)*μ0*H^2

  RMS in 3 cartesian coordinate dimensions (x, y, z), as the
  wave-function is sinusoidal in all three dimensions:

    Hms=H/(√2*√2*√2)
  ue=(1/16)*μ0*H^2
}
var
  amp: Extended;
begin
  amp:= VectSize(BtoH(B_vect));
  Result:=0.5*Permeability*sqr(amp/(sqrt(2)*sqrt(2)*sqrt(2)));
end;

function TForm1.PowerFlow(Apoint: point): vector;
{Calculate the Power flow vector at a point in the grid by taking }
{the vector cross product of the Electric & Magnetic fields, and  }
{dividing the result by the Permeability of free space.}
var
  vect: Vector;
begin
  with Apoint do
    vect:=VectorCross(Electric,Magnetic);
  with vect do begin
    x:=x/Permeability;         {Rescale values by area of grid point}
    y:=y/Permeability;
    z:=z/Permeability;
  end;
  Result:=vect;
end;

function TForm1.RMS_PowerFlow(Apoint: point): vector;
var
  vect: Vector;
begin
  // Get instantaneous Power Flow
  vect:=PowerFlow(Apoint);

  // Calculate RMS of Power Flow (effective, actual Power Flow)
  // RMS in 3 cartesian coordinate dimensions (x, y, z), as the
  // wave-function is sinusoidal in all three dimensions:
  //
  // Ems=E/(√2*√2*√2)
  // ∴ue=(1/16)*ε0*E^2
  //
  // Hms=H/(√2*√2*√2)
  // ∴ue=(1/16)*μ0*H^2

  with vect do begin
    x:=(x/16);
    y:=(y/16);
    z:=(z/16);
  end;
  Result:=vect;
end;

procedure TForm1.Vect_ArrowsClick(Sender: TObject);
{The Vector Arrows button has been changed, so either enable or disable}
{all the vector option controls}
begin
  if Vect_Arrows.Checked then
    New_Arrows:=true
  else
    New_Arrows:=false;
  DoUpdate:=true;
end;

procedure TForm1.DrawArrow(ThisBitmap: Tbitmap;x,y: smallint;arrow: Vector);
var      {draws a vector corresponding to the relevant x,y & z values}
         {x & y vectors are depicted as lines, z as crosses or circles}
  xpos,ypos,zsize: smallint;
  size: extended;
begin
  with ThisBitmap.Canvas do begin    {using the appropriate bitmap}
    with Pen do begin
      Width:=1;                          {set pen to thin white line}
      Color:=clWhite;
      Style:=psSolid;

      size:=VectSize(arrow);

      if VectorX.Checked then begin
        if (arrow.x > arrow_step) then begin
          arrow.x := arrow_step*(arrow.x/size);
          Style:=psDot;
        end;

        if (arrow.x < -arrow_step) then begin
          arrow.x := -arrow_step*(-arrow.x/size);
          Style:=psDot;
        end;
      end;

      if VectorY.Checked then begin
        if (arrow.y > arrow_step) then begin
          arrow.y := arrow_step*(arrow.y/size);
          Style:=psDot;
        end;

        if (arrow.y < -arrow_step) then begin
          arrow.y := -arrow_step*(-arrow.y/size);
          Style:=psDot;
        end;
      end;

      if VectorZ.Checked then begin
        if (arrow.z > arrow_step) then begin
          arrow.z := arrow_step*(arrow.z/size);
          Style:=psDot;
        end;

        if (arrow.z < -arrow_step) then begin
          arrow.z := -arrow_step*(-arrow.z/size);
          Style:=psDot;
        end;
      end;
    end;

    MoveTo(x,y);                     {start the vector from the point (x,y) }
    if VectorX.Checked then          {if x axis vectors required calc xpos}
      xpos:=round2(x+(arrow.x))
    else xpos:=x;                    {else use x value of starting point}
    if VectorY.Checked then          {if y axis vectors required calc ypos}
      ypos:=round2(y+(arrow.y))
    else ypos:=y;                    {else use y value of starting point}
    LineTo(xpos,Ypos);               {draw the vector arrow for the x and/or y displacement}
    if VectorZ.Checked then begin    {if z axis vectors required,}
      zsize:=round2(arrow.z);        {calc vector size}
      if arrow.z>0 then begin        {if z>0 (coming out of the page) draw circle of appropriate size}
        MoveTo(x,y);
        brush.Style:=bsClear;        {ensure circle is not filled}
        Ellipse(x-zsize,y-zsize,x+zsize,y+zsize);
      end;
      if arrow.z<0 then begin        {if z<0 (going into the page) draw cross of appropriate size}
        MoveTo(x-zsize,y-zsize);
        LineTo(x+zsize-1,y+zsize-1); {slight correction added to fix arrow's}
        MoveTo(x-zsize,y+zsize);     {look - make both sides look even}
        LineTo(x+zsize-1,y-zsize+1);
      end;
    end;
  end;
end;

procedure TForm1.NewBitmap(BmapPtr: BitmapPtr);
{given a pointer to a bitmap, erase the bitmap it points to (if any) }
{and return the pointer pointing to a new blank 24bit bitmap with }
{width and height the same as the Image control}
begin
  if BmapPtr<>nil then BmapPtr.free;        {free memory of current bitmap if req'd}
  BmapPtr^:=TBitmap.Create;                 {create a new bitmap}
  if BmapPtr<> nil then with BmapPtr^ do begin                 {using the new bitmap's pointer}
    Height:=Image1.Height;                  {set bitmap height}
    Width:=Image1.Width;                    {set bitmap width}
    Canvas.Brush.Color:=clBlack;
    Canvas.FloodFill(1,1,clBlack,fsBorder); {ensure black filled}
    PixelFormat:=pf24bit;                   {set 24bit colour}
  end;
end;

procedure TForm1.PlotPoint(Bmap: TBitmap; x, y: smallint);
{Using the colour array built by UpdateBitmap, display the colour information}
{of the point (x,y) either as: (a) a extended pixel. (b) a circle of uniform }
{colour with diametre equal to the smallest of ScrScaleX & ScrScaleY. }
{ (c) a rectangle of width ScrScaleX and height ScrScaleY with the original }
{colour value in the centre, and a graduated change to match the other grid }
{points around it - the colour graduation is provided by VectorInterpolate }
{and uses a linear interpolation in the X and Y directions for each of the }
{three colour planes (Red Green Blue).}
var
  ScreenX,ScreenY: extended;
  Edge,PointNum: byte;
  DoQuad1,DoQuad2,DoQuad3,DoQuad4: boolean;
  TileOfsX,TileOfsY: smallint;
  newx,newy: smallint;
  Signs: array[1..9,1..3] of shortint;
  Colour: TColor;
  XCol,Yrow: Longint;
  Xtop,Ytop,Xbot,Ybot: extended;
  PixelRender: smallint;
  DrawPoint: boolean;
begin
  TileOfsX:=0;
  TileOfsY:=0;
  DrawPoint:=true;
  PixelRender:=Render;
  Colour:=ColourArray[x,y];
  begin
    if TileZ then begin      {if the Z planes are required to be tiled}
      Yrow:=ZplanePos div TileXcount;
      Xcol:=ZplanePos mod TileXcount;
      TileRect:=TileGrid.CellRect(Xcol,Yrow);
      with TileRect do begin
        TileOfsX:=Left+EdgeSize;  {add a bit bypass tile's border}
        TileOfsY:=Top+EdgeSize;
      end;
      TileHalfX:=TileScrScaleX/2;        {calc midway points}
      TileHalfY:=TileScrScaleY/2;
      ScreenX:=TileOfsX+(x*TileScrScaleX)+TileHalfX; {calc x coord for pixel}
      ScreenY:=TileOfsY+(y*TileScrScaleY)+TileHalfY; {calc y coord for pixel}
      if ((TileScrScaleX<=1) and (TileScrScaleY<=1)) then
        PixelRender:=OneToOne; {prevent uneccesary work}
     { if (GridDepth>50) and (PixelRender=Blend) then PixelRender:=Chunky;  }
        {Blend takes too long if too many Z Planes}
      if not ((ScreenX<TileRect.Right) and (ScreenY<TileRect.Bottom)) then
        DrawPoint:=false;    {Don't draw pixel if outside tile's space}
    end
    else begin
      ScreenX:=GetRealX((x+0.5));  {the actual screen x location (on the image control)}
      ScreenY:=GetRealY((y+0.5));  {the actual screen y location (on the image control)}
      if ((ScrScaleX<=1) and (ScrScaleY<=1)) then
        PixelRender:=OneToOne; {prevent uneccesary work}
    end;
  if DrawPoint then
    if (PixelRender=OneToOne) then  {Display 1 point as one pixel}
      PlotPixel(Round2(ScreenX),Round2(ScreenY),Colour)
    else if PixelRender=Chunky then with Bmap.Canvas do begin  {if 'chunky' pixels of uniform colour req'd}
      if TileZ then begin
        Xtop:=ScreenX-TileHalfX;
        Ytop:=ScreenY-TileHalfY;
        Xbot:=Xtop+TileScrScaleX+1;
        Ybot:=Ytop+TileScrScaleY+1;
        if Xtop<TileOfsX then Xtop:=TileOfsX;
        if Xbot>=TileRect.Right then Xbot:=TileRect.Right-1;
        if Ytop<TileOfsY then Ytop:=TileOfsY;
        if Ybot<=TileRect.Bottom then Ybot:=TileRect.Bottom-1;
      end
      else begin
        Ytop:=ScreenY-halfY-1;
        Xtop:=ScreenX-halfX-1;
        Xbot:=Xtop+ScrScaleX+1;
        Ybot:=Ytop+ScrScaleY+1;
      end;
      Brush.Color:=Colour;
      FillRect(rect(Round2(Xtop),Round2(Ytop),Round2(Xbot),Round2(Ybot)));
    end
    else if PixelRender=Blend then begin

{The colour graduation for the rectangle depicting the grid point in question}
{is determined by examining the 8 grid points surrounding it and noting the }
{Red, Green, and Blue values for each (and the point itself). A linear }
{interpolation is then carried out in each quadrant around the central point}
{The points are numbered as:     1   2   3                                  }
{                                4   5   6                                  }
{                                7   8   9                                  }

{Fill ColArray with combined RGB value for each point}
      Edge:=EdgeCase(x,y,0,0,GridWidth-1,GridHeight-1);  {determine point's location}
      if EdgeArray[Edge,1,1]=1 then begin             {if not at top left}
        ColArray[1]:=ColourArray[x-1,y-1];
        Signs[1,1]:=SignArray[x-1,y-1,0];
        Signs[1,2]:=SignArray[x-1,y-1,1];
        Signs[1,3]:=SignArray[x-1,y-1,2];
      end
      else ColArray[1]:=0;

      if EdgeArray[Edge,1,2]=1 then begin             {if not at top}
        ColArray[2]:=ColourArray[x,y-1];
        Signs[2,1]:=SignArray[x,y-1,0];
        Signs[2,2]:=SignArray[x,y-1,1];
        Signs[2,3]:=SignArray[x,y-1,2];
      end
      else ColArray[2]:=0;

      if EdgeArray[Edge,1,3]=1 then begin             {if not at top right}
        ColArray[3]:=ColourArray[x+1,y-1];
        Signs[3,1]:=SignArray[x+1,y-1,0];
        Signs[3,2]:=SignArray[x+1,y-1,1];
        Signs[3,3]:=SignArray[x+1,y-1,2];
      end
      else ColArray[3]:=0;

      if EdgeArray[Edge,2,1]=1 then begin             {if not at left}
        ColArray[4]:=ColourArray[x-1,y];
        Signs[4,1]:=SignArray[x-1,y,0];
        Signs[4,2]:=SignArray[x-1,y,1];
        Signs[4,3]:=SignArray[x-1,y,2];
      end
      else ColArray[4]:=0;

      ColArray[5]:=ColourArray[x,y];                {refers to point itself}
      Signs[5,1]:=SignArray[x,y,0];
      Signs[5,2]:=SignArray[x,y,1];
      Signs[5,3]:=SignArray[x,y,2];

      if EdgeArray[Edge,2,3]=1 then begin             {if not at right}
        ColArray[6]:=ColourArray[x+1,y];
        Signs[6,1]:=SignArray[x+1,y,0];
        Signs[6,2]:=SignArray[x+1,y,1];
        Signs[6,3]:=SignArray[x+1,y,2];
      end
      else ColArray[6]:=0;

      if EdgeArray[Edge,3,1]=1 then begin             {if not at bottom left}
        ColArray[7]:=ColourArray[x-1,y+1];
        Signs[7,1]:=SignArray[x-1,y+1,0];
        Signs[7,2]:=SignArray[x-1,y+1,1];
        Signs[7,3]:=SignArray[x-1,y+1,2];
      end
      else ColArray[7]:=0;

      if EdgeArray[Edge,3,2]=1 then begin             {if not at bottom}
        ColArray[8]:=ColourArray[x,y+1];
        Signs[8,1]:=SignArray[x,y+1,0];
        Signs[8,2]:=SignArray[x,y+1,1];
        Signs[8,3]:=SignArray[x,y+1,2];
      end
      else ColArray[8]:=0;

      if EdgeArray[Edge,3,3]=1 then begin             {if not at bottom right}
        ColArray[9]:=ColourArray[x+1,y+1];
        Signs[9,1]:=SignArray[x+1,y+1,0];
        Signs[9,2]:=SignArray[x+1,y+1,1];
        Signs[9,3]:=SignArray[x+1,y+1,2];
      end
      else ColArray[9]:=0;


      {Determine if it is worth doing calculation for each quadrant. If all four points}
      {which define the quadrant have a zero value, nothing need be done.}

      DoQuad1:=not ((ColArray[1]=0) and (ColArray[2]=0) and (ColArray[4]=0) and (ColArray[5]=0));
      DoQuad2:=not ((ColArray[2]=0) and (ColArray[3]=0) and (ColArray[5]=0) and (ColArray[6]=0));
      DoQuad3:=not ((ColArray[4]=0) and (ColArray[5]=0) and (ColArray[7]=0) and (ColArray[8]=0));
      DoQuad4:=not ((ColArray[5]=0) and (ColArray[6]=0) and (ColArray[8]=0) and (ColArray[9]=0));


   {   if TileZ then begin          {prevent Tile over-run}
   {     if EdgeArray[Edge,1,1]=0 then DoQuad1:=false;
        if EdgeArray[Edge,1,3]=0 then DoQuad2:=false;
        if EdgeArray[Edge,3,1]=0 then DoQuad3:=false;
        if EdgeArray[Edge,3,3]=0 then DoQuad4:=false;
      end;
{Process ColArray to provide signed R,G & B values for each point}
{each R,G or B value lies in the range -255 to +255 due to the signing. }
{Once the interpolation has been done, the results can then be turned into}
{an absolute value to give all positive values once more. The reason for }
{this process is to get the correct gradient between points of equal absolute}
{value but of different signs.}

      if (DoQuad1 or DoQuad2 or DoQuad3 or DoQuad4) then begin
        for PointNum:=1 to 9 do   {determine RGB values for each of the 9 points}
          with PntArray[PointNum] do begin
            x:=abs(Signs[PointNum,1])*RGB_Val(ColArray[PointNum],RED);    {set x to point's Red value}
            y:=abs(Signs[PointNum,2])*RGB_Val(ColArray[PointNum],GREEN);  {set y to point's Green value}
            z:=abs(Signs[PointNum,3])*RGB_Val(ColArray[PointNum],BLUE);   {set z to point's Blue value}
          end;


{Call the routine which calculates and draws to screen the graduated quadrants}
        if DoQuad1 then PlotQuadrant(Bmap,1,ScreenX,ScreenY);
        if DoQuad2 then PlotQuadrant(Bmap,2,ScreenX,ScreenY);
        if DoQuad3 then PlotQuadrant(Bmap,3,ScreenX,ScreenY);
        if DoQuad4 then PlotQuadrant(Bmap,4,ScreenX,ScreenY);
      end;
    end;
  end;
end;

function TForm1.RGB_Val(colour: Tcolor; primary: integer): byte;
{Given a combined RGB value (3 bytes of type TColor) and a parameter}
{determining which colour is required, this function returns the }
{byte value of that colour component.}
var
  Mask: integer;
begin
  Mask:=0;
  case primary of           {select appropriate mask value}
    RED:    Mask:=RedMask;
    GREEN:  Mask:=GreenMask;
    BLUE:   Mask:=BlueMask;
  end;
  if primary<>0 then
    Result:=round((colour and Mask)/primary)  {mask out unwanted colours}
  else
    Result:=0;
end;

function TForm1.EdgeCase(x, y, Xmin, Ymin, Xmax, Ymax: smallint): byte;
     {determines if the point (x,y) lies at the edge of the rectangle }
     {defined by (Xmin,Ymin) and (Xmax,Ymax), and if so, what sort of }
     {edge is it on (ie. left, right, bottom left corner etc...). This}
     {information is required during calculations which require comparisons}
     {between adjacent grid points, where such points may lie out of the }
     {grid's bounds. The case values correspond to the following locations:}
     {       (top left)  1   2   3                                         }
     {                   4   5   6                                         }
     {                   7   8   9  (bottom right)                         }
var
  Xcase,Ecase: byte;
begin
   Ecase:=0;
   if x=Xmin then Xcase:=1        {calc X coord boundary state}
   else if x=Xmax then  Xcase:=3  {1=left boundary, 3=right boundary}
   else Xcase:=2;

   if y=Ymin then        {calc overall boundary state using y and xcase}
     case Xcase of       {if y is at top boundary}
       1: Ecase:=1;        {x at left boundary}
       2: Ecase:=2;        {x not at a boundary}
       3: Ecase:=3;        {x at right boundary}
     end
   else if y=Ymax then   {if y is at bottom boundary}
     case Xcase of
       1: Ecase:=7;        {x at left boundary}
       2: Ecase:=8;        {x not at a boundary}
       3: Ecase:=9;        {x at right boundary}
     end
   else
     case Xcase of       {if y is not at a boundary}
       1: Ecase:=4;        {x at left boundary}
       2: Ecase:=5;        {x not at a boundary}
       3: Ecase:=6;        {x at right boundary}
     end;
  Result:=Ecase;         {report finding}
end;

function TForm1.VectorInterpolate(v1, v2, v3, v4: Vector; Xfrac,
  Yfrac: extended): Vector;
var
  NewVect: Vector;
begin
  NewVect.x:=Interpolate(v1.x,v2.x,v3.x,v4.x,Xfrac,Yfrac);
  NewVect.y:=Interpolate(v1.y,v2.y,v3.y,v4.y,Xfrac,Yfrac);
  NewVect.z:=Interpolate(v1.z,v2.z,v3.z,v4.z,Xfrac,Yfrac);
  Result:=NewVect;
end;

function TForm1.Interpolate(val1, val2, val3, val4, Xfrac,
  Yfrac: extended): extended;
{provide a value for a point somewhere with four other points which define}
{the corners of a rectangle. The position of the point in question is given as}
{a fraction along the x axis and a fraction along the y axis}
{The value is calculated by linear interpolation along each axis direction}
var
  Xgrad,Xgrad1,Xgrad2,Ygrad2,newval: extended;
begin
  Xgrad1:=val2-val1;   {gradient along top of rectangle}
  Xgrad2:=val4-val3;   {gradient along bottom of rectangle}
  Ygrad2:=val3-val1;   {gradient along left of rectangle}
  Xgrad:=Xgrad1+Yfrac*(Xgrad2-Xgrad1);   {how x axis gradient varies with y}
  newval:=val1+(Yfrac*Ygrad2)+(Xfrac*Xgrad); {top-left corner value plus }
  Result:=newval;      {contributions from travel down y axis and across x axis}
end;

procedure TForm1.PlotQuadrant(Bmap: TBitmap; Quadrant: byte; RealX, RealY: extended);
{Use the PntArray configured by PlotPoint and the supplied variables such as }
{Quadrant number (1,2,3 or 4) and actual (x,y) location for grid point. The }
{four points defining the quadrant are sent to VectorInterpolate to determine}
{the new RGB value for each pixel in the quadrant which is to be plotted.}
{Note: only a quarter of the area defined by the quadrant is actually }
{calculated and drawn, as adjacent points will do the other three quarters}
{when they are calculated.}
var
  xstart,ystart,xend,yend,i,j: smallint;
  v1,v2,v3,v4,pix: Vector;
  colour: Tcolor;
  Xofs,Yofs: extended;
  Rval,Gval,Bval: byte;
  Xpos,Ypos: smallint;
  Width,Height,HalfWidth,HalfHeight: extended;
begin
  Xofs:=0;
  Yofs:=0;
  xstart:=0;
  ystart:=0;
  xend:=0;
  yend:=0;
  if TileZ then begin
    HalfWidth:=TileHalfX;
    HalfHeight:=TileHalfY;
    Width:=TileScrScaleX;
    Height:=TileScrScaleX;
  end
  else begin
    HalfWidth:=halfX;
    HalfHeight:=halfY;
    Width:=ScrScaleX;
    Height:=ScrScaleY;
  end;
{Determine boundary conditions for relevant Quadrant. The origin of the four}
{Quadrants is condidered to be point (0,0) for the purposes of the calculation}
  case Quadrant of                 {Quadrant 1}
    1: begin                       {x<=0, y<=0}
      xstart:=-Trunc(HalfWidth)-1;
      ystart:=-Trunc(HalfHeight)-1;
      xend:=0;
      yend:=0;
      Xofs:=Width;
      Yofs:=Height;
    end;                           {Quadrant 2}
    2: begin                       {x>0, y<=0}
      xstart:=0;
      ystart:=-Trunc(HalfHeight)-1;
      xend:=Trunc(Width-HalfWidth)+1;
      yend:=0;
      Xofs:=0;
      Yofs:=Height;
    end;                           {Quadrant 3}
    3: begin                       {x<=0, y>0}
      xstart:=-Trunc(HalfWidth)-1;
      ystart:=0;
      xend:=0;
      yend:=Trunc(Height-HalfHeight)+1;
      Xofs:=Width;
      Yofs:=0;
    end;                           {Quadrant 4}
    4: begin                       {x>0, y>0}
      xstart:=0;
      ystart:=0;
      xend:=Trunc(Width-HalfWidth)+1;
      yend:=Trunc(Height-HalfHeight)+1;
      Xofs:=0;
      Yofs:=0;
    end;
  end;

  if TileZ then with TileRect do begin   {Trim edges, so it fits exactly}
    if (RealX+xstart)<=(Left+EdgeSize) then xstart:=Round2(Left+EdgeSize-RealX);
    if (RealX+xend)>=(Right-1) then xend:=Round2(Right-1-RealX);
    if (RealY+ystart)<=(Top+EdgeSize) then ystart:=Round2(Top+EdgeSize-RealY);
    if (RealY+yend)>=(Bottom-1) then yend:=Round2(Bottom-1-RealY);
  end;

  if Quadrant>2 then Inc(Quadrant); {Algorithm for selecting the appropriate points}
  v1:=PntArray[Quadrant];
  v2:=PntArray[Quadrant+1];
  v3:=PntArray[Quadrant+3];
  v4:=PntArray[Quadrant+4];

  for j:=ystart to yend do begin {scan each horizontal line in the Quadrant}
    Ypos:=Round2(RealY+j);       {Determine actual y coord for point in Quadrant}
    for i:=xstart to xend do begin {scan along horizontal line in Quadrant}
      {do the linear interpolation for each colour of point in Quadrant}
      pix:=VectorInterpolate(v1,v2,v3,v4,((i+Xofs)/Width),((j+Yofs)/Height));
      with pix do begin
        Rval:=byte(Round2(abs(x)));    {convert real values to integers}
        Gval:=byte(Round2(abs(y)));    {round values to nearest integer (down if 0.5)}
        Bval:=byte(Round2(abs(z)));
      end;
      {if greyscale display is required, the R,G & B values are all equalized}
      {prior to building the ColourArray and calling the PlotPoint and }
      {PlotQuadrant routines, so the resulting colour is guaranteed to also}
      {be a greyscale.}

      Colour:=Tcolor((Rval*RED) + (Gval*GREEN) + (Bval*BLUE)); {combine values to give one RGB value}
      Xpos:=Round2(RealX+i);   {calc x coord of the point on the Image control}
      PlotPixel(Xpos,Ypos,Colour);
    end;
  end;
end;

function TForm1.GetActualX(x: smallint): smallint;
{return the actual screen x coordinate (in the picture control) of the x }
{coord of a point in the grid (assumes bitmap to be displayed at full size)}
begin
  Result:=round2(GetRealX(x)); {ScrScaleX=number of pixels b/w points}
end;

function TForm1.GetActualY(y: smallint): smallint;
{return the actual screen y coordinate (in the picture control) of the y }
{coord of a point in the grid (assumes bitmap to be displayed at full size)}
begin
  Result:=round2(GetRealY(y)); {ScrScaleY=number of pixels b/w points}
end;

procedure TForm1.VectorSpacingChange(Sender: TObject);
{Redraw screen with different arrow spacing, unless Z plane tiling is }
{on in which case arrows are not shown anyhow.}
var
  step: integer;
begin
  step:=VectSpacing;

  try
    step:=StrToInt(VectorSpacing.Text);
  except                       {catch any invalid integer conditions}
    on E: Exception do
      VectorSpacing.Text:='';
  end;

  New_VectSpacing:=step;

  if not TileZ then DoUpdate:=true;
end;

procedure TForm1.SetTileSize;
{If the Z Plane tiling option is selected, each of the Z coordinate X/Y planes}
{is to be displayed simultaneously on the Image control (screen). So, as the }
{dimensions of the grid (including the number of Z planes) can vary, the }
{optimum tile size must be calculated so that all planes can be displayed }
{with their correct aspect ratios and at the largest possible tile size}
{Note: A tile is a small version of one of the X/Y planes which are normally}
{      displayed as a full screen image.}
var
  nx,ny: smallint;
  height: integer;
  TileAspect: extended;
begin
    if MaintainAspect then
      TileAspect:=Aspect
    else
      TileAspect:=ScreenAspect;

    TileX:=(BitmapX-EdgeSize*2);  {start with one tile the width of the screen}
    repeat                        {TileX will be width of tile}
      nx:=(BitmapX-EdgeSize*2) div TileX;      {nx is the number of tiles across the screen}
      TileY:=Trunc(TileAspect*TileX); {TileY will be height of tile}
      ny:=GridDepth div nx;       {ny is number of rows of tiles down the screen}
      if (GridDepth mod nx)<>0 then Inc(ny);
      height:=ny*TileY;           {total height used by tiles}
      Dec(TileX);                 {Try smaller tile size}
{height must fit screen. Don't allow vanishingly small. Don't exceed max Z plane}
    until (height<=(BitmapY-EdgeSize*2)) or (TileX<10) or (nx>GridDepth);
    Inc(TileX);       {reverse the last decrement}
    if Render=OneToOne then begin    {If one to one representation required}
      if TileX>GridWidth then begin  {restrict max tile size so that}
        TileX:=GridWidth;            {one grid point becomes one pixel}
        TileY:=Trunc(TileAspect*TileX);
      end;
      if TileY>GridHeight then begin
        TileY:=GridHeight;
        TileX:=Trunc(TileY/TileAspect);
      end;
    end;
    TileXcount:=(BitmapX-EdgeSize*2) div TileX;  {determine number across...}
    TileYcount:=GridDepth div TileXcount; {and down screen.}
    if GridDepth mod TileXcount<>0 then Inc(TileYcount); {add one for an incmplete row}
    if MaintainAspect then begin
      TileScrScaleX:=(TileX-EdgeSize)/GridWidth;  {calc scaling factors for reducing full}
      TileScrScaleY:=(TileY-EdgeSize)/GridHeight; {screen to tile size (allow for border)}
    end
    else begin
      TileScrScaleX:=((TileX-EdgeSize)/BitmapX)*ScrScaleX;  {calc scaling factors for reducing full}
      TileScrScaleY:=((TileY-EdgeSize)/BitmapY)*ScrScaleY;  {screen to tile size (allow for border)}
    end;
    with TileGrid do begin
      ColCount:=TileXcount;
      RowCount:=TileYcount;
      DefaultColWidth:=TileX;
      DefaultRowHeight:=TileY;
    end;
end;

function TForm1.Round2(realval: extended): int64;
{This function provided an equal, consistent rounding of real numbers}
{such that they are always rounded to the nearest integer, and when }
{exactly 0.5 between integers, they are rounded towards zero.}
{The standard Round function provided rounds to the EVEN integer!!}
var
  intval: int64;
  fraction: extended;
begin
  intval:=Trunc(realval);           {first round real value towards zero}
  fraction:=(realval-intval);       {subtract this result from the real}
  if fraction>0.5 then Inc(intval)  {if the fraction>0.5, add one to intval}
  else if fraction<-0.5 then Dec(intval); {cater for negative fractions too}
  Result:=intval;                   {return the integer value obtained}
end;

function TForm1.GetRealX(x: extended): extended;
{performs same function as GetActualX but returns a real value rather than }
{an integer. This is so cululative rounding errors don't occur in some calcs}
begin
  Result:=OriginX+(x*ScrScaleX);
end;

function TForm1.GetRealY(y: extended): extended;
{performs same function as GetActualY but returns a real value rather than }
{an integer. This is so cululative rounding errors don't occur in some calcs}
begin
  Result:=OriginY+(y*ScrScaleY);
end;

function TForm1.ColourRange(value: extended; ScaleFactor: extended): byte;
{Convert a real value to a colour value (between 0 and 255)}
var
  ColourVal: smallint;
begin
  ColourVal:=abs(ByteLimit(value*ScaleFactor));
  Result:=byte(ColourVal);
end;

function TForm1.VectToColours(vect: vector; ScaleFactor: extended): vector;
{Takes a vector of real numbers and converts it to a vector of colour}
{values (one for each component: x,y & z). Negative values become }
{positive colours.}
var
  ColourVect: Vector;
begin
  with ColourVect do begin
    x:=ColourRange(vect.x,ScaleFactor); {convert component values to colour values}
    y:=ColourRange(vect.y,ScaleFactor);
    z:=ColourRange(vect.z,ScaleFactor);
  end;
  Result:=ColourVect;       {return a vector of colour values}
end;


function TForm1.ByteLimit(value: extended): smallint;
{Take a real value and return it as a smallint value between the limits}
{-255 and +255}
var
  newval: smallint;
begin
  if abs(value)>$FF then        {if out of range, clip it at the limit}
    newval:=Sign(value)*$FF
  else newval:=round2(value);
  Result:=newval;               {return as a smallint}
end;

function TForm1.VectByteLimit(vect: Vector): Vector;
{Process each component vector in vect such that the resulting vector's}
{component vectors are all in the range -255 to 255}
var
  ResultVect: Vector;
begin
  with ResultVect do begin
    x:=ByteLimit(vect.x);
    y:=ByteLimit(vect.y);
    z:=ByteLimit(vect.z);
  end;
  Result:=ResultVect;
end;

function TForm1.VectorProperty(field: byte; Apoint: point): Vector;
{Return a vector quantity of the field which is required to be displayed}
{using the Electric and Magnetic field vectors at a grid point.}
var
  Vect: Vector;
begin
  Vect:=NullVect;
  with Apoint do
    case Field of   {depending on which field is required to display}
      PSI_VECTOR_FIELD: Vect:=PsiVect;
      ELECTRIC_FIELD,E_ELECTRIC_FIELD: Vect:=Electric;       {Show Electric Field}
      MAGNETIC_FIELD,E_MAGNETIC_FIELD: Vect:=Magnetic;       {Show Magnetic Field}
      POWER_FLOW_FIELD: Vect:=PowerFlow(Apoint);             {Show Power flow}
      HERTZIAN_FIELD: Vect:=Hertzian;
      VECTOR_POTENTIAL_FIELD: Vect:=VectorPotential;
      PSI_CURL_VECTOR_FIELD: Vect:=PsiCurlVect;
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
      PARTICLE_POS_REFLECTED_FIELD: Vect:=particle_pos_Reflected;
      PARTICLE_NEG_REFLECTED_FIELD: Vect:=particle_neg_Reflected;
{$IFEND}
    end;
  Result:=Vect;
end;

function TForm1.PointNull(Apoint: point; DisplayField:smallint): boolean;
{See if the point's information is all zeros}
var
  isNull: boolean;
begin
  with Apoint do begin
    case DisplayField of
      PSI_VECTOR_FIELD:       isNull:=VectorNull(PsiVect);
      ELECTRIC_FIELD:         isNull:=VectorNull(Electric);
      MAGNETIC_FIELD:         isNull:=VectorNull(Magnetic);
      POWER_FLOW_FIELD:       isNull:=VectorNull(PowerFlow(Apoint));
      HERTZIAN_FIELD:         isNull:=VectorNull(Hertzian);
      VECTOR_POTENTIAL_FIELD: isNull:=VectorNull(VectorPotential);
      PSI_CURL_VECTOR_FIELD:  isNull:=VectorNull(PsiCurlVect);
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
      PARTICLE_POS_REFLECTED_FIELD:   isNull:=VectorNull(particle_pos_Reflected);
      PARTICLE_NEG_REFLECTED_FIELD:   isNull:=VectorNull(particle_neg_Reflected);
{$IFEND}
    end;
  end;
  Result:=isNull;
end;

function TForm1.VectorNull(vect: Vector): boolean;
{Look at each component vector to see if the vector is overall a}
{Null vector.}
begin
  with vect do
    if (x=0) and (y=0) and (z=0) then
      Result:=true else Result:=false;
end;

function TForm1.ReverseTColor(input: TColor): Tcolor;
{Function reverses the byte order of a TColor type. This is required}
{prior to storing in bitmap's memory using the pointers provided by}
{the ScanLine function.}
var
  Byte1,Byte2,Byte3: byte;
begin
  if input<>0 then begin
      Byte1:=PByteArray(@input)[0];
      Byte2:=PByteArray(@input)[1];
      Byte3:=PByteArray(@input)[2];
      Result:=Byte3*RED + Byte2*Green + Byte1*Blue;
    end
    else Result:=0;
end;

procedure TForm1.Z_TilingClick(Sender: TObject);
begin
   if TileZ then New_TileZ:=false else New_TileZ:=true;
   DoUpdate:=true;
end;

function TForm1.MouseZplane: smallint;
{If Z plane tiling is being used, return the tile number which}
{the mouse cursor is over. Zero returned if not over a tile.}
var
  x,y: longint;
  Coord: TPoint;
  Coord2: TGridCoord;
  Tile: smallint;
begin
  if TileZ then  begin
    with Form1 do begin
      x:=left+MainGroup.left+TileGrid.left+3;
      y:=top+(Height-ClientHeight)+MainGroup.top+TileGrid.top-3;
    end;
    Coord:=MyMouse.CursorPos;
    Coord2:=TileGrid.MouseCoord(Coord.x-x,Coord.y-y);
    Tile:=Coord2.x+Coord2.y*TileXcount;
    if (Tile>GridDepth-1) or (Tile<0) then Tile:=-1;       {ensure in range}
    Result:=Tile;
  end
  else
    Result:=-1;
end;

procedure TForm1.Image1Click(Sender: TObject);
var
  Tile: smallint;
begin
  Tile:=MouseZplane;
  if Tile>=0 then New_ZPlane:=Tile;
  DoUpdate:=true;
end;

procedure TForm1.Image1DblClick(Sender: TObject);
var
  Tile: smallint;
begin
  Tile:=MouseZplane;
  if Tile>=0 then New_ZPlane:=Tile;
  New_TileZ:=false;
  DoUpdate:=true;
end;

procedure TForm1.VectorXClick(Sender: TObject);
begin
  VectorChange:=true;
  DoUpdate:=true;
end;

procedure TForm1.VectorYClick(Sender: TObject);
begin
  VectorChange:=true;
  DoUpdate:=true;
end;

procedure TForm1.VectorZClick(Sender: TObject);
begin
  VectorChange:=true;
  DoUpdate:=true;
end;

procedure TForm1.TileCursor(Bmap: TBitmap; Tile: smallint; colour: TColor);
{Draw a coloured rectangle around the selected Z Plane Tile}
var
  Xcol,Yrow: Longint;
begin
  Yrow:=Tile div TileXcount;
  Xcol:=Tile mod TileXcount;
  with Bmap.Canvas do begin
    brush.Color:=colour;
    FrameRect(TileGrid.CellRect(Xcol,Yrow));
  end;
end;

procedure TForm1.Spacing_pixelsClick(Sender: TObject);
{Redraw screen with different arrow spacing, unless Z plane tiling is }
{on in which case arrows are not shown anyhow.}
begin
  if not TileZ then begin
    ArrowsUnitsChange:=true;
    DoUpdate:=true;
  end;
end;

procedure TForm1.Spacing_metresClick(Sender: TObject);
{Redraw screen with different arrow spacing, unless Z plane tiling is }
{on in which case arrows are not shown anyhow.}
begin
  if not TileZ then begin
    ArrowsUnitsChange:=true;
    DoUpdate:=true;
  end;
end;

procedure TForm1.SmoothingCheckBoxClick(Sender: TObject);
begin
  smoothing := SmoothingCheckBox.Checked;
end;

procedure TForm1.EnergyCorrectionCheckBoxClick(Sender: TObject);
begin
  EnergyCorrection := EnergyCorrectionCheckBox.Checked;
end;

procedure TForm1.EFormulaCheckBoxClick(Sender: TObject);
begin
  E_useFormula := EFormulaCheckBox.Checked;
end;

procedure TForm1.HFormulaCheckBoxClick(Sender: TObject);
begin
  H_useFormula := HFormulaCheckBox.Checked;
end;

procedure TForm1.Spacing_gridpointsClick(Sender: TObject);
{Redraw screen with different arrow spacing, unless Z plane tiling is }
{on in which case arrows are not shown anyhow.}
begin
  if not TileZ then begin
    ArrowsUnitsChange:=true;
    DoUpdate:=true;
  end;
end;

procedure TForm1.PlotPixel(x, y: smallint; Colour: TColor);
{Using the current array of bitmap's horizontal line pointers, plot}
{a point of a certain 24bitr colour value into memory. The colour must}
{by reversed prior to storage as the values are stored in byte reversed}
{order.}
var
  YLine: PByteArray;
begin
  if (x>0) and (y>0) and (x<=BitmapX) and (y<=BitmapY) then begin
    Yline:=YLinePtrs[y-1];    {find array of colour values for line y in bitmap}
    TColorPtr(@Yline[3*(x-1)])^:=ReverseTColor(Colour);    {get pointer to 24bit RGB value for point (x,y) }
  end;
end;

procedure TForm1.RenderOption1Click(Sender: TObject);
begin
  if RenderOption1.Checked then begin
    New_Render:=OneToOne;
    DoUpdate:=true;
  end;
end;

procedure TForm1.RenderOption2Click(Sender: TObject);
begin
  if RenderOption2.Checked then begin
    New_Render:=Chunky;
    DoUpdate:=true;
  end;
end;

procedure TForm1.RenderOption3Click(Sender: TObject);
begin
  if RenderOption3.Checked then begin
    New_Render:=Blend;
    DoUpdate:=true;
  end;
end;

procedure TForm1.RendDisplayClick(Sender: TObject);
begin
  if RendDisplay.Checked then
    New_Rendered:=true
  else
    New_Rendered:=false;
  DoUpdate:=true;
end;

procedure TForm1.UpdateE_Energy(scr: smallint);
var
  i,j,k: smallint;
begin
  E_Energy_Tot:=0;
  for i:=0 to GridWidth-1 do
    for j:=0 to GridHeight-1 do
	    for k:=0 to GridDepth-1 do with points[scr]^[i,j,k] do
        E_Energy_Tot:=E_energy_Tot + E_Energy(Electric);

  E_Energy_Tot:=E_energy_Tot*PointVolume; {adjust for grid point volume};
end;

procedure TForm1.UpdateB_Energy(scr: smallint);
var
  i,j,k: smallint;
begin
  B_Energy_Tot:=0;
  for i:=0 to GridWidth-1 do
    for j:=0 to GridHeight-1 do
	    for k:=0 to GridDepth-1 do with points[scr]^[i,j,k] do
        B_Energy_Tot := B_Energy_Tot + B_Energy(Magnetic);

  B_Energy_Tot:=B_Energy_Tot*PointVolume; {adjust for grid point volume}
end;

procedure TForm1.AspectControlClick(Sender: TObject);
begin
  if AspectControl.Checked then New_MaintainAspect:=true
  else New_MaintainAspect:=false;
  DoUpdate:=true;
end;

procedure TForm1.SetAspectRatio;
begin
  Aspect:=GridHeight/GridWidth;   {Aspect ratio of X/Y plane in grid}
  ScrScaleX:=BitmapX/GridWidth;   {how many times does grid width fit screen?}
  ScrScaleY:=BitmapY/GridHeight;  {how many times does grid height fit screen?}
  if MaintainAspect then          {if grid aspect ratio is to be preserved,}
    if ScreenAspect>Aspect then   {then adjust scaling values to allow}
      ScrScaleY:=ScrScaleX*Aspect {the largest image with the same aspect ratio}
    else
      ScrScaleX:=ScrScaleY/Aspect;
  halfX:=ScrScaleX/2; {determine the number of pixels from one point}
  halfY:=ScrScaleY/2; {to half way to the next point (in x & y directions)}
  {Determine bitmap coord's of the Origin (top left) of the }
  {active area of the screen (picture control) where the image will start}
  OriginX:=Round2((BitmapX-(GridWidth*ScrScaleX))/2);
  OriginY:=Round2((BitmapY-(GridHeight*ScrScaleY))/2);
end;

procedure TForm1.GridXChange(Sender: TObject);
begin
  try
    StrToInt(GridX.Text);
  except                       {catch any invalid integer conditions}
    on E: Exception do
      GridX.Text:='';
  end;
end;

procedure TForm1.GridYChange(Sender: TObject);
begin
  try
    StrToInt(GridY.Text);
  except                       {catch any invalid integer conditions}
    on E: Exception do
      GridY.Text:='';
  end;
end;

procedure TForm1.GridZChange(Sender: TObject);
begin
  try
    StrToInt(GridZ.Text);
  except                       {catch any invalid integer conditions}
    on E: Exception do
      GridZ.Text:='';
  end;
end;

procedure TForm1.AcceptGridSizeClick(Sender: TObject);
{Read the new Grid dimensions and change them to their new values}
{if they are sensible.}
begin
  ProfileCancel();

  try
    New_GridWidth:=StrToInt(GridX.Text);
    if New_GridWidth<3 then begin     {Keep it in range}
      GridX.Text:='3';
      New_GridWidth:=3;
    end;
  except                     {catch any invalid integer conditions}
    on E: Exception do
      New_GridWidth:=GridWidth;
  end;
  try
    New_GridHeight:=StrToInt(GridY.Text);
    if New_GridHeight<3 then begin     {Keep it in range}
      GridY.Text:='3';
      New_GridHeight:=3;
    end;
  except                     {catch any invalid integer conditions}
    on E: Exception do
      New_GridHeight:=GridHeight;
  end;
  try
    New_GridDepth:=StrToInt(GridZ.Text);
    if New_GridDepth<3 then begin     {Keep it in range}
      GridZ.Text:='3';
      New_GridDepth:=3;
    end;
  except                     {catch any invalid integer conditions}
    on E: Exception do
      New_GridDepth:=GridDepth;
  end;

  if (New_GridWidth*New_GridHeight*New_GridDepth) > (GRID_LIMIT*GRID_LIMIT*GRID_LIMIT) then begin
    ShowMessage('Dimensions too large - reverting.');
    New_GridWidth:=GridWidth;
    New_GridHeight:=GridHeight;
    New_GridDepth:=GridDepth;
    GridX.Text:=IntToStr(GridWidth);
    GridY.Text:=IntToStr(GridHeight);
    GridZ.Text:=IntToStr(GridDepth);
  end
  else begin
    DoUpdate:=true;
    Restart:=true;
  end;
end;

procedure ProcSetGridGlobals(Form: TForm1);
{Set the values of various global variables which are dependent on the Grid}
{size chosen.}
var
  newWidth: extended;
begin
  try
    newWidth:=strtofloat(Form.ActualGridWidth.Text);

    if (newWidth=0) then
      newWidth:=ActualWidth;
  except
    on E: Exception do
      newWidth:=ActualWidth;
  end;

  PPMx:=New_GridWidth/newWidth;
  PPMy:=New_GridHeight/newWidth;
  PPMz:=New_GridDepth/newWidth;

  {size, in metres, that each point represents}
  dx:=1/PPMx;
  dy:=1/PPMy;
  dz:=1/PPMz;

  ActualWidth:=GridWidth*dx;    {Actual width the screen models - in metres}
  ActualHeight:=GridHeight*dy;  {Actual Height the screen models - in metres}
  ActualDepth:=GridDepth*dz;    {Actual Depth the screen models - in metres}
  PointArea:=dx*dy;             {Area each pixel represents}
  PointVolume:=dx*dy*dz;        {volume each pixel represents}
  Form.ZPlane.Max:=GridDepth;           {set the ZPlane control's max position}
  New_ZPlane:=round(GridDepth/2);  {default start point is mid point in Z axis}
  Form.LastZ.Caption:=IntToStr(GridDepth);  {show max Z plane value under ZPlane control}

  DoUpdate:=true;
end;

procedure TForm1.SetGridGlobals;
{Set the values of various global variables which are dependent on the Grid}
{size chosen.}
begin
  ProcSetGridGlobals(Self);
end;

function GetLargestFreeMemRegion(var AAddressOfLargest: pointer): LongWord;
var
  Si: TSystemInfo;
  P, dwRet: LongWord;
  Mbi: TMemoryBasicInformation;
begin
  Result := 0;
  AAddressOfLargest := nil;
  GetSystemInfo(Si);
  P := 0;
  while P < LongWord(Si.lpMaximumApplicationAddress) do begin
    dwRet := VirtualQuery(pointer(P), Mbi, SizeOf(Mbi));
    if (dwRet > 0) and (Mbi.State and MEM_FREE <> 0) then begin
      if Result < Mbi.RegionSize then begin
        Result := Mbi.RegionSize;
        AAddressOfLargest := Mbi.BaseAddress;
      end;
      Inc(P, Mbi.RegionSize);
    end else
      Inc(P, Si.dwPageSize);
  end;
end;

procedure TForm1.ReAllocGridMemory;
{Try and allocate memory for the Grid of data points. If successful}
{Adopt the new Dimensions. Only newly allocated memory is initialised}
var
  NewSizeOK, retried: boolean;
  scr,i,j,k,n: integer;
  Height, Width, Depth: integer;
  BaseAddr: pointer;
  MemSize: LongWord;
begin
  Width:=10;
  Height:=10;
  Depth:=10;

  n:=0;
  retried:=false;

  while n < 2 do begin
    Inc(n);

    if n = 2 then begin
      Width:=New_GridWidth;
      Height:=New_GridHeight;
      Depth:=New_GridDepth;
    end;

  //  MemSize := GetLargestFreeMemRegion(BaseAddr);
    NewSizeOK:=true;
    try
      SetLength(points1,Width,Height,Depth); {set size of Grid}
  //    SetLength(points2,Width,Height,Depth); {set size of Grid}
    except
      on E : Exception do NewSizeOK:=false;
    end;

//    if n=1 then continue;

//    if NewSizeOK then
    try
      SetLength(ColourArray,Width,Height);
    except
      on E : Exception do NewSizeOK:=false;
    end;
//    if NewSizeOK then
    try
      SetLength(SignArray,Width,Height,3);
    except
      on E : Exception do NewSizeOK:=false;
    end;
//    if NewSizeOK then
    try
      SetLength(particle1_A,Width,Height,Depth); {set size of Grid}
    except
      on E : Exception do NewSizeOK:=false;
    end;
//    if NewSizeOK then
    try
      SetLength(particle2_A,Width,Height,Depth); {set size of Grid}
    except
      on E : Exception do NewSizeOK:=false;
    end;
//    if NewSizeOK then
    try
      SetLength(particle1_E,Width,Height,Depth); {set size of Grid}
    except
      on E : Exception do NewSizeOK:=false;
    end;
//    if NewSizeOK then
    try
      SetLength(particle2_E,Width,Height,Depth); {set size of Grid}
    except
      on E : Exception do NewSizeOK:=false;
    end;
//    if NewSizeOK then
    try
      SetLength(particle_1_2_B,Width,Height,Depth); {set size of Grid}
    except
      on E : Exception do NewSizeOK:=false;
    end;
//    if NewSizeOK then
    try
      SetLength(particle1_Power,Width,Height,Depth); {set size of Grid}
    except
      on E : Exception do NewSizeOK:=false;
    end;
//    if NewSizeOK then
    try
      SetLength(particle2_Power,Width,Height,Depth); {set size of Grid}
    except
      on E : Exception do NewSizeOK:=false;
    end;

    if NewSizeOK then begin  {Ensure new space is initialised}
      scr:=0;
  //    for scr:=0 to 1 do
        for i:=0 to (Width-2) do
          for j:=0 to (Height-2) do
            for k:=0 to (Depth-2) do
              points[scr]^[i,j,k]:=NullPoint;
    end
    else begin
      if retried then exit;

      ShowMessage('Dimensions too large - reverting.');
      New_GridWidth:=GridWidth;     {Memory allocation failed, so }
      New_GridHeight:=GridHeight;   {return to previous Dimensions}
      New_GridDepth:=GridDepth;

      n:=1;
      Width:=10;
      Height:=10;
      Depth:=10;
      retried:=true;
    end;
  end; // end for
end;

procedure TForm1.FormDestroy(Sender: TObject);
{When the Form closes, De-allocate all the dynamic array memory}
{allocated during the program's execution.}
begin
  Points[0]:=nil;          {Free all memory allocated}
//  Points[1]:=nil;          {Free all memory allocated}
  ColourArray:=nil;
  SignArray:=nil;
end;

function TForm1.VectorDot(v1, v2: Vector): extended;
var
  DotProduct: extended;
begin
  DotProduct:=(v1.x*v2.x) + (v1.y*v2.y) + (v1.z*v2.z);
  Result:=DotProduct;
end;

function TForm1.Normalize(v: Vector): Vector;
var
  DotProduct, Norm: extended;
begin
  DotProduct:=VectorDot(v,v);
  Norm:=sqrt(DotProduct);

  with v do begin
    if (Norm > 0) then begin
      x:=x/Norm;
      y:=y/Norm;
      z:=z/Norm;
    end;
  end;

  Result:=v;
end;

function TForm1.ScalarGrad(ScalarGroup: ScalarGrp): Vector;
{This function is the same as delS }
{It gives the gradient vector of a Scalar field}
//
//        { VectGroup's points are assigned as follows:    P3            P5
//                                                      P1 P0 P2
//                                                         P4        P6
//
//                        Where P5 & P6 are in the Z plane  (P5 at the back and P6 at the front) }
//
// Note: the Grid (0,0,0) point is at the Top, Left & Back point of the Grid
//       So X increments to the right, Y increments downwards, & Z increments out of the screen
var
  GradVect: Vector;
begin
  with ScalarGroup do begin
    GradVect.x:=((s2-s1)/dx)/nP;
    GradVect.y:=((s4-s3)/dy)/nP;
    GradVect.z:=((s6-s5)/dz)/nP;
  end;
  Result:=GradVect;
end;

function TForm1.VectDiv(VectGroup: VectorGrp): extended;
{This function is the same as Del . Vect (Vector dot product) }
//
//        { VectGroup's points are assigned as follows:    P3            P5
//                                                      P1 P0 P2
//                                                         P4        P6
//
//                        Where P5 & P6 are in the Z plane  (P5 at the back and P6 at the front) }
//
// Note: the Grid (0,0,0) point is at the Top, Left & Back point of the Grid
//       So X increments to the right, Y increments downwards, & Z increments out of the screen

{Perform the Vector Div function on the vector group passed to it.}
{The value returned (as a vector) is for the central point of the group}
var
  dVx_dx,dVy_dy,dVz_dz: extended;
begin
  with VectGroup do begin
    dVx_dx:=((v2.x - v1.x)/dx)/nP;
    dVy_dy:=((v4.y - v3.y)/dy)/nP;
    dVz_dz:=((v6.z - v5.z)/dz)/nP;
  end;

  Result:=dVx_dx + dVy_dy + dVz_dz;
end;

function TForm1.VectorCross(v1, v2: Vector): Vector;
var
  ResultVect: Vector;
begin
  with ResultVect do begin
    x:=((v1.y)*(v2.z) - (v1.z)*(v2.y));
    y:=((v1.z)*(v2.x) - (v1.x)*(v2.z));
    z:=((v1.x)*(v2.y) - (v1.y)*(v2.x));
  end;
  Result:=ResultVect;
end;

function TForm1.VectCurl(VectGroup: VectorGrp): Vector;
// {This function is the same as Del x Vect (Vector cross product) }
//
// {Perform the Vector Curl function on the vector group passed to it.}
// {The value returned (as a vector) is for the central point of the group}
//
//        { VectGroup's points are assigned as follows:    P3            P5
//                                                      P1 P0 P2
//                                                         P4        P6
//
//                        Where P5 & P6 are in the Z plane  (P5 at the back and P6 at the front) }
//
// Note: the Grid (0,0,0) point is at the Top, Left & Back point of the Grid
//       So X increments to the right, Y increments downwards, & Z increments out of the screen
//
var
  dVz_dy,dVy_dz,dVx_dz,dVz_dx,dVy_dx,dVx_dy: extended;
  CurlVect: Vector;
begin
  with VectGroup do begin
    dVz_dy:=((v4.z - v3.z)/dy)/nP;
    dVy_dz:=((v6.y - v5.y)/dz)/nP;
    dVx_dz:=((v6.x - v5.x)/dz)/nP;
    dVz_dx:=((v2.z - v1.z)/dx)/nP;
    dVy_dx:=((v2.y - v1.y)/dx)/nP;
    dVx_dy:=((v4.x - v3.x)/dy)/nP;
  end;

  with CurlVect do begin
    x:=dVz_dy - dVy_dz;
    y:=dVx_dz - dVz_dx;
    z:=dVy_dx - dVx_dy;
  end;

  Result:=CurlVect;
end;

function TForm1.PointGroup(scr, x, y, z: smallint): PointGrp;
{Return a group of point values for the point in question and all}
{the points immediately adjacent to it. If they are out of the }
{Grid, assign them zero values.}
{Assume the starting point (x,y,z) is valid}
var
  TheGroup: PointGrp;
  xless,yless,zless: boolean;
  xmore,ymore,zmore: boolean;
begin
  if x<=0 then xless:=true else xless:=false;
  if y<=0 then yless:=true else yless:=false;
  if z<=0 then zless:=true else zless:=false;

  if x>=(GridWidth-1) then xmore:=true else xmore:=false;
  if y>=(GridHeight-1) then ymore:=true else ymore:=false;
  if z>=(GridDepth-1) then zmore:=true else zmore:=false;

  { TheGroup's points are assigned as follows:    P3            P5
                                               P1 P0 P2
                                                  P4        P6

                   Where P5 & P6 are in the Z plane (P5 at the back and P6 at the front) }
  scr:=0;

  with TheGroup do begin
    P0:=points[scr]^[x,y,z];
//    if xless then P1:=NullPoint else P1:=points[scr]^[x-1,y,z];
//    if xmore then P2:=NullPoint else P2:=points[scr]^[x+1,y,z];
//    if yless then P3:=NullPoint else P3:=points[scr]^[x,y-1,z];
//    if ymore then P4:=NullPoint else P4:=points[scr]^[x,y+1,z];
//    if zless then P5:=NullPoint else P5:=points[scr]^[x,y,z-1];
//    if zmore then P6:=NullPoint else P6:=points[scr]^[x,y,z+1];

    if xless then P1:=points[scr]^[x+1,y,z] else P1:=points[scr]^[x-1,y,z];
    if xmore then P2:=points[scr]^[x-1,y,z] else P2:=points[scr]^[x+1,y,z];
    if yless then P3:=points[scr]^[x,y+1,z] else P3:=points[scr]^[x,y-1,z];
    if ymore then P4:=points[scr]^[x,y-1,z] else P4:=points[scr]^[x,y+1,z];
    if zless then P5:=points[scr]^[x,y,z+1] else P5:=points[scr]^[x,y,z-1];
    if zmore then P6:=points[scr]^[x,y,z-1] else P6:=points[scr]^[x,y,z+1];
  end;
  Result:=TheGroup;
end;

function TForm1.VectorGroup(PntGroup: PointGrp; Field: smallint): VectorGrp;
{Return a group of vectors for a particular field at, and around the }
{point in question.}
var
  VectGroup: VectorGrp;
begin
  with PntGroup do
    case Field of
      PSI_VECTOR_FIELD: begin
           VectGroup.v0:=p0.PsiVect;
           VectGroup.v1:=p1.PsiVect;
           VectGroup.v2:=p2.PsiVect;
           VectGroup.v3:=p3.PsiVect;
           VectGroup.v4:=p4.PsiVect;
           VectGroup.v5:=p5.PsiVect;
           VectGroup.v6:=p6.PsiVect;
      end;

      ELECTRIC_FIELD: begin
           VectGroup.v0:=p0.Electric;
           VectGroup.v1:=p1.Electric;
           VectGroup.v2:=p2.Electric;
           VectGroup.v3:=p3.Electric;
           VectGroup.v4:=p4.Electric;
           VectGroup.v5:=p5.Electric;
           VectGroup.v6:=p6.Electric;
      end;

      MAGNETIC_FIELD: begin
           VectGroup.v0:=p0.Magnetic;
           VectGroup.v1:=p1.Magnetic;
           VectGroup.v2:=p2.Magnetic;
           VectGroup.v3:=p3.Magnetic;
           VectGroup.v4:=p4.Magnetic;
           VectGroup.v5:=p5.Magnetic;
           VectGroup.v6:=p6.Magnetic;
      end;

      HERTZIAN_FIELD: begin
           VectGroup.v0:=p0.Hertzian;
           VectGroup.v1:=p1.Hertzian;
           VectGroup.v2:=p2.Hertzian;
           VectGroup.v3:=p3.Hertzian;
           VectGroup.v4:=p4.Hertzian;
           VectGroup.v5:=p5.Hertzian;
           VectGroup.v6:=p6.Hertzian;
      end;

      VECTOR_POTENTIAL_FIELD: begin
           VectGroup.v0:=p0.VectorPotential;
           VectGroup.v1:=p1.VectorPotential;
           VectGroup.v2:=p2.VectorPotential;
           VectGroup.v3:=p3.VectorPotential;
           VectGroup.v4:=p4.VectorPotential;
           VectGroup.v5:=p5.VectorPotential;
           VectGroup.v6:=p6.VectorPotential;
      end;

      PSI_CURL_VECTOR_FIELD: begin
           VectGroup.v0:=p0.PsiCurlVect;
           VectGroup.v1:=p1.PsiCurlVect;
           VectGroup.v2:=p2.PsiCurlVect;
           VectGroup.v3:=p3.PsiCurlVect;
           VectGroup.v4:=p4.PsiCurlVect;
           VectGroup.v5:=p5.PsiCurlVect;
           VectGroup.v6:=p6.PsiCurlVect;
      end;

{$IF TWO_PARTICLE_REFLECTION_FIELDS}
      PARTICLE_POS_REFLECTED_FIELD: begin
           VectGroup.v0:=p0.particle_pos_Reflected;
           VectGroup.v1:=p1.particle_pos_Reflected;
           VectGroup.v2:=p2.particle_pos_Reflected;
           VectGroup.v3:=p3.particle_pos_Reflected;
           VectGroup.v4:=p4.particle_pos_Reflected;
           VectGroup.v5:=p5.particle_pos_Reflected;
           VectGroup.v6:=p6.particle_pos_Reflected;
      end;

      PARTICLE_NEG_REFLECTED_FIELD: begin
           VectGroup.v0:=p0.particle_neg_Reflected;
           VectGroup.v1:=p1.particle_neg_Reflected;
           VectGroup.v2:=p2.particle_neg_Reflected;
           VectGroup.v3:=p3.particle_neg_Reflected;
           VectGroup.v4:=p4.particle_neg_Reflected;
           VectGroup.v5:=p5.particle_neg_Reflected;
           VectGroup.v6:=p6.particle_neg_Reflected;
      end;
{$IFEND}
      else VectGroup:=NullVectGrp;
    end;
  Result:=VectGroup;
end;

function TForm1.ScalarGroup(PntGroup: PointGrp; Field: smallint): ScalarGrp;
{Return a group of vectors for a particular field at, and around the }
{point in question.}
var
  ScalarGroup: ScalarGrp;
begin
  with PntGroup do
    case Field of

      PSI_SCALAR_FIELD: begin
           ScalarGroup.s0:=p0.Psi;
           ScalarGroup.s1:=p1.Psi;
           ScalarGroup.s2:=p2.Psi;
           ScalarGroup.s3:=p3.Psi;
           ScalarGroup.s4:=p4.Psi;
           ScalarGroup.s5:=p5.Psi;
           ScalarGroup.s6:=p6.Psi;
         end;

      ELECTRIC_POTENTIAL_FIELD: begin
           ScalarGroup.s0:=p0.ElectricPotential;
           ScalarGroup.s1:=p1.ElectricPotential;
           ScalarGroup.s2:=p2.ElectricPotential;
           ScalarGroup.s3:=p3.ElectricPotential;
           ScalarGroup.s4:=p4.ElectricPotential;
           ScalarGroup.s5:=p5.ElectricPotential;
           ScalarGroup.s6:=p6.ElectricPotential;
         end;

      CHARGE_DENSITY_FIELD: begin
           ScalarGroup.s0:=p0.ChargeDensity;
           ScalarGroup.s1:=p1.ChargeDensity;
           ScalarGroup.s2:=p2.ChargeDensity;
           ScalarGroup.s3:=p3.ChargeDensity;
           ScalarGroup.s4:=p4.ChargeDensity;
           ScalarGroup.s5:=p5.ChargeDensity;
           ScalarGroup.s6:=p6.ChargeDensity;
         end;

      else ScalarGroup:=NullScalarGrp;
    end;
  Result:=ScalarGroup;
end;

function TForm1.IntegrateScalarGrp(ScalarGroup: ScalarGrp): extended;
var
  Average: extended;
begin
  Average:=(ScalarGroup.s0 + ScalarGroup.s1 + ScalarGroup.s2 +
            ScalarGroup.s3 + ScalarGroup.s4 + ScalarGroup.s5 + ScalarGroup.s6)/7;

  Result:=Average*(dx*dy*dz);
end;

function TForm1.IsVectorField(Field: smallint): boolean;
begin
    case Field of   {depending on which field is required to display}
        PSI_VECTOR_FIELD,
        ELECTRIC_FIELD,
        MAGNETIC_FIELD,
        POWER_FLOW_FIELD,
        HERTZIAN_FIELD,
        VECTOR_POTENTIAL_FIELD,
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
        PSI_CURL_VECTOR_FIELD,
        PARTICLE_POS_REFLECTED_FIELD,
        PARTICLE_NEG_REFLECTED_FIELD: begin {Show Electric, Magnetic, Power flow, Hertzian, Vector Potential or Electric Potential Fields}
{$ELSE}
        PSI_CURL_VECTOR_FIELD: begin {Show Electric, Magnetic, Power flow, Hertzian, Vector Potential or Electric Potential Fields}
{$IFEND}
            Result:=true;
        end;
    end;
    Result:=false;
end;

procedure TForm1.FindMaxVal(scr, Field: smallint);
{Find the maximum absolute value of the quantity being displayed, so}
{that the colour levels can be adjusted to give maximum brightness for}
{that value.}
var
  i,j,k: smallint;
  vect: Vector;
  VectorType: boolean;
  value: extended;
  Zstart,Zend: smallint;
begin
  VectorType:=false;
  value:=0;
  MaxVal:=0;                {Set it to zero first}
  if TileZ or scale_3D.Checked then begin    {If Z Planes are tiled find Max of whole volume}
    Zstart:=0;
    Zend:=GridDepth-1;
  end
  else begin
    Zstart:=Z_Plane;     {If not, find Max of current plane only}
    Zend:=Z_Plane;
  end;

  for i:=0 to GridWidth-1 do
    for j:=0 to GridHeight-1 do
      for k:=Zstart to Zend do begin
        case Field of   {depending on which field is required to use}
          PSI_VECTOR_FIELD,
          ELECTRIC_FIELD,
          MAGNETIC_FIELD,
          POWER_FLOW_FIELD,
          HERTZIAN_FIELD,
          VECTOR_POTENTIAL_FIELD,
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
          PSI_CURL_VECTOR_FIELD,
          PARTICLE_POS_REFLECTED_FIELD,
          PARTICLE_NEG_REFLECTED_FIELD: begin {calc Electric, Magnetic, Power flow, Hertzian, Vector Potential or Electric Potential Fields}
{$ELSE}
          PSI_CURL_VECTOR_FIELD: begin {calc Electric, Magnetic, Power flow, Hertzian, Vector Potential or Electric Potential Fields}
{$IFEND}
                   Vect:=VectorProperty(Field,points[scr]^[i,j,k]);
                   VectorType:=true;
                 end;
          E_ELECTRIC_FIELD: value:=E_Energy(points[scr]^[i,j,k].Electric);   {calc energy in Electric Field}
          E_MAGNETIC_FIELD: value:=B_Energy(points[scr]^[i,j,k].Magnetic);   {calc energy in Magnetic Field}
          PSI_SCALAR_FIELD: value:=points[scr]^[i,j,k].Psi;
          ELECTRIC_POTENTIAL_FIELD: value:=points[scr]^[i,j,k].ElectricPotential;
          CHARGE_DENSITY_FIELD: value:=points[scr]^[i,j,k].ChargeDensity;
        end;

        if VectorType then with vect do begin
          MaxVal:=Max(MaxVal,abs(x));
          MaxVal:=Max(MaxVal,abs(y));
          MaxVal:=Max(MaxVal,abs(z));
        end
        else
          MaxVal:=Max(MaxVal,abs(value));
      end;
end;

procedure TForm1.FindAverageVal(scr, Field: smallint);
{Find the maximum absolute value of the quantity being displayed, so}
{that the colour levels can be adjusted to give maximum brightness for}
{that value.}
var
  i,j,k: smallint;
  vect: Vector;
  VectorType: boolean;
  value, average: extended;
  Zstart,Zend: smallint;
  count: integer;
begin
  VectorType:=false;
  value:=0;
  count:=0;
  average:=0;

  if TileZ or scale_3D.Checked then begin    {If Z Planes are tiled find Max of whole volume}
    Zstart:=0;
    Zend:=GridDepth-1;
  end
  else begin
    Zstart:=Z_Plane;     {If not, find Max of current plane only}
    Zend:=Z_Plane;
  end;

  scr:=0;

  for i:=0 to GridWidth-1 do
    for j:=0 to GridHeight-1 do
      for k:=Zstart to Zend do begin
        case Field of   {depending on which field is required to use}
          PSI_VECTOR_FIELD,
          ELECTRIC_FIELD,
          MAGNETIC_FIELD,
          POWER_FLOW_FIELD,
          HERTZIAN_FIELD,
          VECTOR_POTENTIAL_FIELD,
{$IF TWO_PARTICLE_REFLECTION_FIELDS}
          PSI_CURL_VECTOR_FIELD,
          PARTICLE_POS_REFLECTED_FIELD,
          PARTICLE_NEG_REFLECTED_FIELD: begin {calc Electric, Magnetic, Power flow, Hertzian, Vector Potential or Electric Potential Fields}
{$ELSE}
          PSI_CURL_VECTOR_FIELD: begin {calc Electric, Magnetic, Power flow, Hertzian, Vector Potential or Electric Potential Fields}
{$IFEND}
                   Vect:=VectorProperty(Field,points[scr]^[i,j,k]);
                   VectorType:=true;
                 end;
          E_ELECTRIC_FIELD: value:=E_Energy(points[scr]^[i,j,k].Electric);   {calc energy in Electric Field}
          E_MAGNETIC_FIELD: value:=B_Energy(points[scr]^[i,j,k].Magnetic);   {calc energy in Magnetic Field}
          PSI_SCALAR_FIELD: value:=points[scr]^[i,j,k].Psi;
          ELECTRIC_POTENTIAL_FIELD: value:=points[scr]^[i,j,k].ElectricPotential;
          CHARGE_DENSITY_FIELD: value:=points[scr]^[i,j,k].ChargeDensity;
        end;

       MaxVal:=0;                {Set it to zero first}

       if VectorType then with vect do begin
          MaxVal:=Max(MaxVal,abs(x));
          MaxVal:=Max(MaxVal,abs(y));
          MaxVal:=Max(MaxVal,abs(z));
        end
        else
          MaxVal:=Max(MaxVal,abs(value));

        average:=average + MaxVal;
        Inc(count);
      end;

      MaxVal:=(average/count)*80;
end;

procedure TForm1.AutoWarnTimerTimer(Sender: TObject);
{If the auto-scale warning indicator's timer is active, toggle the}
{state of the warning indicator at each timer tick.}
begin
  AutoWarnState:=not AutoWarnState;
  if AutoWarnState then
    AutoWarn.Picture.Graphic:=BitmapRed
  else
    AutoWarn.Picture.Graphic:=BitmapBlack;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Quit:=true;
end;

procedure TForm1.RateOfTimeChange(Sender: TObject);
begin
  New_RateOfTime:=RateOfTime.Position;
  DoUpdate:=true;
end;

procedure TForm1.CheckBox12Click(Sender: TObject);
begin
  if CheckBox12.Checked then begin
    New_StartOption:=3;
    DoUpdate:=true;
    Restart:=true;
    two_particle_analysis:=true;
  end
  else begin
    two_particle_analysis:=false;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then begin
    CheckBox2.Enabled:=true;
    save_frames:=true;
    FrameCount:=1;
  end
  else begin
    CheckBox2.Enabled:=false;
    save_frames:=false;
  end;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then begin
    save_3D:=true;
  end
  else begin
    save_3D:=false;
  end;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked then begin
    AllFields:=true;
  end
  else begin
    AllFields:=false;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  New_Flip_YZ:=true;
  DoUpdate:=true;
end;

procedure TForm1.ActualGridWidthChange(Sender: TObject);
var
  newWidth: extended;
begin
  newWidth:=strtofloat(ActualGridWidth.Text);

  if (ActualWidth <> newWidth) then begin
    if not DoUpdate then ProfileCancel();
    ProcSetGridGlobals(Self);
    DoUpdate:=true;
    Restart:=true;
  end;
end;

procedure TForm1.ArrowScaleScrollChange(Sender: TObject);
begin
  New_ArrowScaleFactor := ArrowScaleScroll.Position;
  DoUpdate:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Restart:=true;
  DoUpdate:=true;
end;

procedure TForm1.ViewFromTopClick(Sender: TObject);
begin
  DoUpdate:=true;
end;

procedure TForm1.Scale_3DClick(Sender: TObject);
begin
  DoUpdate:=true;
end;

End.

