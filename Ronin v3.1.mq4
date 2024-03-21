//+------------------------------------------------------------------+
//|                                             RONIN V2.7 FINAL.mq4 |
//|                                 Copyright 2023, BITCOIN-SPAIN.ES |
//|                                        https://bitcoin-spain.es/ |
//+------------------------------------------------------------------+

#property copyright "TELEGRAM : @bitcoinspain_es"
#property version "2.1"
#property description "Bot creado por Ángel J. / Alex GF / Yannick C."
#property description "https://bitcoin-spain.es/"
#property strict

//#resource "\\Images\\main_logo.bmp"
//#resource "\\Images\\info_logo.bmp"
//#resource "\\Images\\sub_logo.bmp"

#include<ChartObjects/ChartObjectsArrows.mqh>
#include<ChartObjects/ChartObjectsLines.mqh>

//---
enum ENUM_LOT_MODE
  {
   LOT_MODE_FIXED = 1,   // Fixed Lot
   LOT_MODE_PERCENT = 2, // Percent Lot
  };

enum ENUM_TYPE_GRID_LOT
  {
   fix_lot = 0,    // Fixed Start Lot 0.01 / 0.01 / 0.01 / 0.01 / 0.01 /.............
   Summ_lot = 1,   // Summ Sart Lot   0.01 / 0.02 / 0.03 / 0.04 / 0.05 /.............
   Martingale = 2, // Martingale Lot  0.01 / 0.02 / 0.04 / 0.08 / 0.16 /.............
   Step_lot = 3    // Step Lot        0.01 / 0.01 / 0.01 / 0.02 / 0.02 / 0.02 / 0.03 / 0.03 / 0.03 / 0.04 / 0.04 / 0.04 /............
  };

// v.2.1 - add news filter

enum ENUM_SOURCE
  {
   ForexFactory,  //Forex Factory
   EnergyExch,    //Energy Exch
   MetalsMine     //Metals Mine
  };

//+--------------------------MTLicense Block1------------------------+
// Title on the information display
string MTlic_info_caption = "Bitcoin-Spain";

// footer note on the information display
string MTlic_info_footer = "https://bitcoin-spain.es/";

// Information display
int    MTLic_DrawLabel_Ygap = 0;
int    MTLic_DrawLabel_Xgap = 0;
int    MTLic_DrawLabel_corner_anchor_right = 0;
int    MTLic_DrawLabel_draw_background = 0;

// customers serial key will be here. keep this blank
input string LicenseKey = "";
//+--------------------------MTLicense Block1------------------------+

//+--------------------------MTLicense Block2------------------------+
struct MTLicenseInfo { bool IsValid; string AllowedAccounts; string AllowedCurrencyPairs; string ExpireDate; string AllowedTimeFrames; int MinimumBalance; int DisableLiveTrading; int DisableDemoTrading; int DisableBacktesting; int ShowLicenseInfo; string ValidationKey; string LicenseKey; };
//#import "BitcoinSpainLib.ex4"
//void CheckLicense(MTLicenseInfo & LicInfo);
//#import
string MTLic_customer_uid = "nHR2s8rejoqTbJT9yVPuCGtjZ5bRxGZF";
string ArrayToBASE64(uchar&src[]) {uchar dst[]; if(CryptEncode(CRYPT_BASE64, src, src, dst) > 0) {return CharArrayToString(dst, 0, WHOLE_ARRAY, CP_UTF8);} else {Print("The license key is not valid. (Error: " + (string)GetLastError() + ")"); return"";}}
void BASE64ToArray(string BASE64Str, uchar&dst[]) {uchar src[]; StrToCharArray(BASE64Str, src); if(CryptDecode(CRYPT_BASE64, src, src, dst) <= 0) {Print("The license key is not valid. (Error: " + (string)GetLastError() + ")");}}
int MTLic_RemainingDays = 0;
string MTLic_LicLableStr;
MTLicenseInfo MTLic;
int MTLic_DrawLabel_corner = CORNER_LEFT_LOWER;
int MTLic_DrawLabel_anchor = ANCHOR_LEFT_LOWER;
void MTLic_DrawLabel()
  {
   MTLic_DrawLabel_corner = CORNER_LEFT_LOWER;
   MTLic_DrawLabel_anchor = ANCHOR_LEFT_LOWER;
   if(MTLic_DrawLabel_corner_anchor_right == 1)
     {
      MTLic_DrawLabel_corner = CORNER_RIGHT_LOWER;
      MTLic_DrawLabel_anchor = ANCHOR_RIGHT_LOWER;
     }
   string MTLicLblname = "MTlic_title";
   if(MQLInfoInteger(MQL_PROGRAM_TYPE) == PROGRAM_INDICATOR)
     {
      if(ObjectFind(MTLicLblname) < 0)
         ObjectCreate(MTLicLblname, OBJ_LABEL, MTLic_ChartWindow(), 0, 0, 0);
     }
   else
     {
      if(ObjectFind(MTLicLblname) < 0)
         ObjectCreate(MTLicLblname, OBJ_LABEL, 0, 0, 0, 0);
     }
   ObjectSetInteger(0, MTLicLblname, OBJPROP_COLOR, clrWhiteSmoke);
   if(MTlic_info_footer == "")
     {
      ObjectSetInteger(0, MTLicLblname, OBJPROP_XDISTANCE, 13 + MTLic_DrawLabel_Xgap);
      ObjectSetInteger(0, MTLicLblname, OBJPROP_YDISTANCE, 23 + MTLic_DrawLabel_Ygap);
     }
   else
     {
      ObjectSetInteger(0, MTLicLblname, OBJPROP_XDISTANCE, 13 + MTLic_DrawLabel_Xgap);
      ObjectSetInteger(0, MTLicLblname, OBJPROP_YDISTANCE, 32 + MTLic_DrawLabel_Ygap);
     }
   ObjectSetString(0, MTLicLblname, OBJPROP_TEXT, MTlic_info_caption);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_FONTSIZE, 11);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_ZORDER, 30);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_CORNER, MTLic_DrawLabel_corner);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_ANCHOR, MTLic_DrawLabel_anchor);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_SELECTABLE, false);
   MTLicLblname = "MTlic_line2";
   if(MQLInfoInteger(MQL_PROGRAM_TYPE) == PROGRAM_INDICATOR)
     {
      if(ObjectFind(MTLicLblname) < 0)
         ObjectCreate(MTLicLblname, OBJ_LABEL, MTLic_ChartWindow(), 0, 0, 0);
     }
   else
     {
      if(ObjectFind(MTLicLblname) < 0)
         ObjectCreate(MTLicLblname, OBJ_LABEL, 0, 0, 0, 0);
     }
   ObjectSetInteger(0, MTLicLblname, OBJPROP_COLOR, clrWhiteSmoke);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_XDISTANCE, 13 + MTLic_DrawLabel_Xgap);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_YDISTANCE, 8 + MTLic_DrawLabel_Ygap);
   ObjectSetString(0, MTLicLblname, OBJPROP_TEXT, "calculating remaining days...");
   ObjectSetInteger(0, MTLicLblname, OBJPROP_FONTSIZE, 7);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_ZORDER, 30);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_CORNER, MTLic_DrawLabel_corner);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_ANCHOR, MTLic_DrawLabel_anchor);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_SELECTABLE, false);
   ObjectSetString(0, MTLicLblname, OBJPROP_TEXT, MTLic_LicLableStr);
   MTLicLblname = "MTlic_line1";
   if(MQLInfoInteger(MQL_PROGRAM_TYPE) == PROGRAM_INDICATOR)
     {
      if(ObjectFind(MTLicLblname) < 0)
         ObjectCreate(MTLicLblname, OBJ_LABEL, MTLic_ChartWindow(), 0, 0, 0);
     }
   else
     {
      if(ObjectFind(MTLicLblname) < 0)
         ObjectCreate(MTLicLblname, OBJ_LABEL, 0, 0, 0, 0);
     }
   ObjectSetInteger(0, MTLicLblname, OBJPROP_COLOR, clrWhiteSmoke);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_XDISTANCE, 13 + MTLic_DrawLabel_Xgap);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_YDISTANCE, 20 + MTLic_DrawLabel_Ygap);
   ObjectSetString(0, MTLicLblname, OBJPROP_TEXT, MTlic_info_footer);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_FONTSIZE, 7);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_ZORDER, 30);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_CORNER, MTLic_DrawLabel_corner);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_ANCHOR, MTLic_DrawLabel_anchor);
   ObjectSetInteger(0, MTLicLblname, OBJPROP_SELECTABLE, false);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MTLic_ChartWindow() {return ChartWindowFind();}
//int TerminateApp(string msg = "") {int MTLic_PType = MQLInfoInteger(MQL_PROGRAM_TYPE); if(msg != "")Print(msg); if(MTLic_PType == PROGRAM_EXPERT) {int MTLic_err_buff[1]; MTLic_err_buff[23] = 1; ExpertRemove(); return(INIT_FAILED);} else if(MTLic_PType == PROGRAM_INDICATOR) {IndicatorSetString(INDICATOR_SHORTNAME, "MTLicPendingRemove"); for(int MTLic__y = 0; MTLic__y <= CHART_WINDOWS_TOTAL - 1; MTLic__y++) {ChartIndicatorDelete(0, MTLic__y, "MTLicPendingRemove");} int MTLic_err_buff2[1]; MTLic_err_buff2[23] = 1; return(INIT_FAILED);} else {return(INIT_FAILED);}}
string MD5(string text) {string md5 = "51B61CDFCD343A6A7645AB0DCF491408"; uchar src[], dst[]; StrToCharArray(text, src); if(CryptEncode(CRYPT_HASH_MD5, src, src, dst) > 0) {string res = ""; int count = ArraySize(dst); for(int i = 0; i < count; i++)res += StringFormat("%.2X", dst[i]); md5 = res;} return md5;}
int StrToCharArray(string source, uchar&dest[]) {ArrayResize(dest, StringLen(source)); for(int i = 0; i < StringLen(source); i++) {dest[i] = (uchar)StringGetCharacter(source, i);} return 0;}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTLic_OnTick()
  {
   if(IsTesting() == true)
     {
      HideTestIndicators(true);
      // if(MTLic.DisableBacktesting == true)
      // {TerminateApp("");}
     }
   if(MTLic.ExpireDate == "")
     {
      MTLic_LicLableStr = "fully-licensed version";
     }
   else
      if(MTLic_RemainingDays < 0 && MTLic.ExpireDate != "")
        {
         //TerminateApp("=== Your license has expired. Program will be unloaded ===");
         return;
        }
      else
        {
         datetime MTLic_ExpDate = StringToTime(MTLic.ExpireDate);
         datetime MTLic_dtgap = MTLic_ExpDate - TimeCurrent();
         MTLic_RemainingDays = (int)MathRound((MTLic_ExpDate - TimeCurrent()) / 3600 / 24);
         MTLic_LicLableStr = StringFormat("%02d Days %02d:%02d Hrs remaining", MTLic_RemainingDays, TimeHour(MTLic_dtgap), TimeMinute(MTLic_dtgap));
        }
   if(MTLic.ShowLicenseInfo > 0)
     {
      MTLic_DrawLabel();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MTLic_OnInit()
  {
   HideTestIndicators(true);
   if(LicenseKey == "")
     {
      MessageBox("Empty serial string. please enter serial key in your inputs window.", "License", MB_ICONERROR);
      //TerminateApp("Empty serial string. please enter serial key in your inputs window.");
     }
   ObjectsDeleteAll(0, "MTlic_");
   MTLic.IsValid = false;
   MTLic.LicenseKey = LicenseKey;
   ResetLastError();
   string validation_str = (string)GetTickCount() + (string)TerminalInfoInteger(TERMINAL_MEMORY_TOTAL) + MTLic_customer_uid + (string)AccountInfoInteger(ACCOUNT_LOGIN) + (string)TerminalInfoInteger(TERMINAL_BUILD) + (string)GetMicrosecondCount();
   uchar uniqid[];
   uchar ValidationKey[];
   StrToCharArray(validation_str, uniqid);
   uchar keyenc[];
   string enc_key = MD5((string)MQLInfoInteger(MQL_PROGRAM_TYPE) + (string)MQLInfoInteger(MQL_PROGRAM_TYPE) + (string)TerminalInfoInteger(TERMINAL_BUILD) + (string)TerminalInfoInteger(TERMINAL_MAXBARS) + (string)TerminalInfoInteger(TERMINAL_CODEPAGE) + (string)TerminalInfoInteger(TERMINAL_CPU_CORES) + (string)TerminalInfoInteger(TERMINAL_DISK_SPACE) + (string)TerminalInfoInteger(TERMINAL_MEMORY_TOTAL));
   StrToCharArray(enc_key, keyenc);
   uchar keydec[];
   string dec_key = MD5((string)TerminalInfoInteger(TERMINAL_MAXBARS) + (string)TerminalInfoInteger(TERMINAL_MEMORY_TOTAL) + (string)MQLInfoInteger(MQL_PROGRAM_TYPE) + (string)TerminalInfoInteger(TERMINAL_DISK_SPACE) + (string)TerminalInfoInteger(TERMINAL_CODEPAGE) + (string)MQLInfoInteger(MQL_PROGRAM_TYPE) + (string)TerminalInfoInteger(TERMINAL_CPU_CORES) + (string)TerminalInfoInteger(TERMINAL_BUILD));
   StrToCharArray(dec_key, keydec);
   if(CryptEncode(CRYPT_AES256, uniqid, keyenc, ValidationKey) > 0)
     {
      MTLic.ValidationKey = ArrayToBASE64(ValidationKey);
      //CheckLicense(MTLic);
      if(MTLic.IsValid == true)
        {
         uchar uniqid_r[];
         uchar result[];
         BASE64ToArray(MTLic.ValidationKey, uniqid_r);
         if(CryptDecode(CRYPT_AES256, uniqid_r, keydec, result) > 0)
           {
            if(MTLic.ShowLicenseInfo > 0)
              {
               MTLic_DrawLabel();
              }
            MTLic_OnTick();
           }
         else
           {
            //TerminateApp();
           }
        }
      else
        {
         //TerminateApp();
        }
     }
   else
     {
      //TerminateApp();
     }
   int MTLic_Lst_Err = GetLastError();
   if(MTLic_Lst_Err > 0)
     {
      //TerminateApp("Application Terminated. ERR: " + (string)MTLic_Lst_Err);
     }
   if(MTLic.DisableBacktesting == false)
     {
      HideTestIndicators(false);
     }
  }
//+--------------------------MTLicense Block2------------------------+




//--- input parameters
extern string Version__ = "----------------------------------------------------------------";
extern string Version1__ = "----------------- RONIN EA V2.0 --------------------------------";
extern string Version2__ = "----------------------------------------------------------------";
input bool              ShowInfo                      = true;           // Show dashboard:

input string            NewsFilterSettings            = "--------- News Filter Settings --------------"; // News Filter Settings

input ENUM_SOURCE       NewsFilterSource              = ForexFactory;   // Source:
input int               NewsGMTOffset                 = 0;              // GMT Offset (hours):
input bool              DisplayCalendar               = true;           // Show News Markers:
input bool              SymbolRelatedNews             = true;           // Use Only Symbol Related News (false = all Symbol):
input string            NewsRegion                    = "USD,EUR";      // And Specific Currency/Country:
input bool              HighImpact                    = true;           // Use High Impact News:
input bool              MediumImpact                  = false;          // Use Medium Impact News:
input bool              LowImpact                     = false;          // Use Low High Impact News:
input int               NewsFilterStopBefore          = 60;             // Stop Trade Minutes Before News:
input int               NewsFilterResumeAfter         = 60;             // Resume Trade Minutes After News:
input bool              DisplayBacktestCalendar       = true;           // Show News Markers in Backtest:
input string            BacktestURL = "https://pixeldrain.com/api/file/m4gBdVqi?download";   // News file for backtest

int LastNewsIndex = 0;

string            obj_prefix                    = "news_";
datetime          CWeek;

string            FFURL = "https://nfs.faireconomy.media/ff_calendar_thisweek.csv";
string            EEURL = "https://nfs.faireconomy.media/ee_calendar_thisweek.csv";
string            MMURL = "https://nfs.faireconomy.media/mm_calendar_thisweek.csv";


input string   hint2       = "--------- Max Trades & Hard SL --------------";       //Max Trades and hard SL
input int      MaxBuy      = 10;    //Max buy trades (0 disabled)
input int      MaxSell     = 10;    //Max sell trades (0 disabled)
input int      HardSL      = 10000; //Hard SL (in points)

extern string Switches = "--------------------------- Switches --------------------------- ";
extern bool InpManualInitGrid = FALSE; // Start MANUAL Order  Grid  (Only if A / B Enable)
extern bool InpOpenNewOrders = TRUE;  // Open New Orders ?
extern bool OpenNewOrdersGrid = TRUE; // Enable Grid ?
extern bool InpCloseAllNow = false;   // closes all orders now
extern string Magic = "--------Magic Number Engine---------";
extern string Magic_ = "--------If all the engines are disabled runs a motor in buy and sell ---------";
input bool InpEnableEngineA = TRUE; // Enable Engine A   [BUY]
input int InpMagic = 1111;           // Magic Number  A
input bool InpEnableEngineB = TRUE; // Enable Engine B   [SELL]
input int InpMagic2 = 2222;          // Magic Number  B
extern string ConfigLOTE__ = "---------------------------Config Lot INIT--------------------------------------";
input ENUM_LOT_MODE InpLotMode = LOT_MODE_PERCENT; // Lot Mode
input double InpFixedLot = 0.1;                   // Fixed Lot
input double InpPercentLot = 0.1;                 // Percent Lot
input int InpTakeProfit = 6000;                    // Take Profit in Pips

extern string Ronin_ConfigGrid__ = "---------------------------Config Grid--------------------------------------";
input ENUM_TYPE_GRID_LOT TypeGridLot = Martingale; // Type Grid Lot
input int InpGridSize = 3;                         // Step Size in Pips
input double InpGridFactor = 2;                    // Grid Increment Factor (If Martingale)
input int InpGridStepLot = 4;                      // STEP LOT (If  Step Lot)
input double InpMaxLot = 99;                       // Max Lot
input int InpHedgex = 2;                           // After Level Change Lot A to B (Necessari all Engine Enable)
input bool GridAllDirect = false;                  // Enable Grid Dual Side
input bool Use_Exponential_Distance = false;        // Use Exponential Distance
input double Exponential_Grid_Distance_Percent = 10;  // Exponential Grid Distance in Percent

extern string TrailingStop__ = "--------------------Trailling Stop--------------";
extern bool InpUseTrailingStop = true; // Use Trailling Stop´?
extern int InpTrailStart = 20;          //   TraillingStart
extern int InpTrailStop = 20;           // Size Trailling stop

extern string BreakEven = "--------------------Break Even--------------";
extern bool InpUseBreakEven = true; // Use Break Even ?
extern int InpBreakEvenStart = 15;   //   Break Even Start
extern int InpBreakEvenStep = 3;    //  Break Even Step

extern string TakeEquitySTOP__ = "------------------------Take  Equity STOP ---------------";
extern bool InpUseTakeEquityStop = true;   // Usar Take EquityStop?
extern double InpProfitCloseandSTOP = 50.0; // Closes all orders once Float hits this $ amount
extern double inpDailyTarget = 2;  // Daily Target in %
extern double inpWeeklyTarget = 5; // Weekly Target in %
extern double inpMonthlyTarget = 10; // Monthly Target in %

extern string FilterSpread__ = "----------------------------Filter Max Spread--------------------";
input int InpMaxSpread = 24; // Max Spread in Pips

extern string EquityCaution__ = "------------------------Filter Caution of Equity ---------------";
extern bool InpUseEquityCaution = TRUE;                       //  EquityCaution?
extern double InpTotalEquityRiskCaution = 20;                 // Total % Risk to EquityCaution
extern ENUM_TIMEFRAMES InpTimeframeEquityCaution = PERIOD_D1; // Timeframe as EquityCaution


extern string EquitySTOP__ = "------------------------Filter  Equity STOP ---------------";
extern bool InpUseEquityStop = true;        // Use EquityStop?
extern double InpTotalEquityRisk = 60.0;    // Total % Risk to EquityStop
extern int inpHoursToWait = 0;              // Hours To Wait Before Relaunch
extern bool InpAlertPushEquityLoss = false; //Send Alert to Celular
extern bool InpCloseAllEquityLoss = false;  // Close all orders in TotalEquityRisk
extern bool  InpCloseRemoveEA        = true;  //Remove EA and close chart after Equity stop closes trades

extern string FilterOpenOneCandle__ = "--------------------Filter One Order by Candle--------------";
input bool InpOpenOneCandle = true;                         // Open one order by candle
input ENUM_TIMEFRAMES InpTimeframeBarOpen = PERIOD_CURRENT; // Timeframe OpenOneCandle

extern string MinimalProfitClose__ = "--------------------Minimal Profit Close/ Protect Grid --------------";
input bool InpEnableMinProfit = true;  // Enable  Minimal Profit Close
input bool ProtectGridLastFist = true; // Enable Protect Grid Last save Firsts
input double MinProfit = 10.00;        // Minimal Profit Close /Protect Grid
input int QtdTradesMinProfit = 10;      // Qtd Trades to Minimal Profit Close/ Protect Grid
extern string Config__ = "---------------------------Config--------------------------------------";
input bool inpTimeControl = true; // Use Timer Control ?
input int inpTimeHour = 19; // Hour To Close
input int inpTimeMinute = 0; // Minute To Close
input int InpHedge = 0;        // Hedge After Level
input int InpDailyTarget = 50; // Daily Target in Money
input string InpComment = "Ronin EA v3.0 ";  // Order Comment
extern string MovingAverageConfig__ = "-----------------------------Moving Average-----------------------";
input ENUM_TIMEFRAMES InpMaFrame = PERIOD_CURRENT; // Moving Average TimeFrame
input int InpMaPeriod = 34;                         // Moving Average Period
input ENUM_MA_METHOD InpMaMethod = MODE_EMA;       // Moving Average Method
input ENUM_APPLIED_PRICE InpMaPrice = PRICE_OPEN;  // Moving Average Price
input int InpMaShift = 0;                          // Moving Average Shift

extern string HILOConfig__ = "-----------------------------HILO--------------------";
input bool EnableSinalHILO = true;                   //Enable Sinal  HILO
input bool InpHILOFilterInverter = false;            // If True Invert Filter
input ENUM_TIMEFRAMES InpHILOFrame = PERIOD_CURRENT; // HILO TimeFrame
input int InpHILOPeriod = 3;                         // HILO Period
input ENUM_MA_METHOD InpHILOMethod = MODE_EMA;       // HILO Method
input int InpHILOShift = 0;                          // HILO Shift

double indicator_low;
double indicator_high;
double diff_highlow;
bool isbidgreaterthanima;


///////////////////////////////////////////////
extern string TimeFilter__ = "-------------------------Filter DateTime---------------------------";
extern bool InpUtilizeTimeFilter = true;
extern bool InpTrade_in_Monday = true;
extern bool InpTrade_in_Tuesday = true;
extern bool InpTrade_in_Wednesday = true;
extern bool InpTrade_in_Thursday = true;
extern bool InpTrade_in_Friday = true;

extern string InpStartHour = "00:00";
extern string InpEndHour = "23:59";


extern string Broker = "-----------------------------BROKER--------------------";
extern double inpBrokerMaxLot = 40; // Maximum Lot Allowed by Broker
extern double inpSubLot = 10; // Volume of Multiple lot

extern string TrendFilter__ = "-----------------------------Trend Filter--------------------";
input bool inpUseHighLowTrendFilter = true;     // Use High / Low Trend Filter ?
input int inpXCandles = 5;                      // Length
input bool inpFilter1 = true;
input color inpHighArrowColor1 = clrGreen;
input color inpLowArrowColor1 = clrYellow;
input ENUM_TIMEFRAMES inpTimeFrameFilter1 = PERIOD_M15;
input bool inpFilter2 = true;
input color inpHighArrowColor2 = clrBlue;
input color inpLowArrowColor2 = clrPink;
input ENUM_TIMEFRAMES inpTimeFrameFilter2 = PERIOD_M30;
input bool inpFilter3 = true;
input color inpHighArrowColor3 = clrRed;
input color inpLowArrowColor3 = clrOrange;
input ENUM_TIMEFRAMES inpTimeFrameFilter3 = PERIOD_H1;
input bool inpCloseTradeOnTrendSwitch = true;   // Close Trades On Opposite Signal

color Visor1_FontColor = Black;

int Visor1_Sinal = 0;

//LOT_MODE_FIXED
//---
int SlipPage = 3;
bool GridAll = false;

//---
int lastDay = 100;

bool m_hedging1, m_target_filter1;
int m_direction1, m_current_day1, m_previous_day1;
double m_level1, m_buyer1, m_seller1, m_target1, m_profit1;
double m_pip1, m_size1, m_take1;
datetime m_datetime_ultcandleopen1;
datetime m_time_equityrisk1;
double m_mediaprice1, profit1;
int m_orders_count1;
double m_lastlot1;

bool m_hedging2, m_target_filter2;
int m_direction2, m_current_day2, m_previous_day2;
double m_level2, m_buyer2, m_seller2, m_target2, m_profit2;
double m_pip2, m_size2, m_take2;
datetime m_datetime_ultcandleopen2;
datetime m_time_equityrisk2;
double m_mediaprice2;
int m_orders_count2;
double m_lastlot2, profit2;

string m_symbol;
double m_spreadX;
double Spread;
bool m_initpainel;
string m_filters_on;
double m_profit_all;
datetime m_time_equityriskstopall;

string TLS;
string ES;
string BWT;
string DT;
string LM;
string monday, tuesday, wednesday, thursday, friday;

bool flag_minimize = false;
bool flag_week = true;

datetime today;
datetime this_month;

int ndays;

double today_start_equity ;
double weekly_start_equity;
double monthly_start_equity;
double today_profit;
double total_profit_daily;
double average_profit;
double daily_profit;
double weekly_profit;
double monthly_profit;
double dailyAccountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
double weeklyAccountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
double monthlyAccountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
bool dailyTargetFlag = false;
bool weeklyTargetFlag = false;
bool monthlyTargetFlag = false;
int currentDay = -1;
int currentWeek = -1;
int currentMonth = -1;
datetime equityStopLaunchTime = TimeCurrent();
double bars = 0;
int highArrowI = 0,
    lowArrowI = 0,
    brokenHighI = 0,
    brokenLowI = 0,
    highIndex = 0,
    lowIndex = 0;
ENUM_TIMEFRAMES filterTimeFrames[3];
color highArrowsColor[3];
color lowArrowsColor[3];
CChartObjectArrowDown highArrows[3];
CChartObjectArrowUp  lowArrows[3];
CChartObjectTrend highBrokens[3];
CChartObjectTrend lowBrokens[3];

bool highBrokenFlags[3],  lowBrokenFlags[3] ;
CChartObjectArrowDown HighArrow1;
CChartObjectArrowDown HighArrow2;
CChartObjectArrowDown HighArrow3;
CChartObjectArrowUp LowArrow1;
CChartObjectArrowUp LowArrow2;
CChartObjectArrowUp LowArrow3;
CChartObjectTrend HighBroken1;
CChartObjectTrend HighBroken2;
CChartObjectTrend HighBroken3;
CChartObjectTrend LowBroken1;
CChartObjectTrend LowBroken2;
CChartObjectTrend LowBroken3;
bool isBearish = false;
bool isBullish = false;
struct News
  {
   string            title;
   string            country;
   datetime          time;
   string            impact;
  } news[];


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(inpFilter1)
     {
      ArrayResize(filterTimeFrames, 1);
      ArrayResize(highArrowsColor, 1);
      ArrayResize(lowArrowsColor, 1);
      ArrayResize(highArrows, 1);
      ArrayResize(lowArrows, 1);
      ArrayResize(highBrokens, 1);
      ArrayResize(lowBrokens, 1);
      ArrayResize(lowBrokenFlags, 1);
      ArrayResize(highBrokenFlags, 1);

      highBrokenFlags[0] = false;
      lowBrokenFlags[0] = false;
      filterTimeFrames[0] = inpTimeFrameFilter1;
      highArrowsColor[0] = inpHighArrowColor1;
      lowArrowsColor[0] = inpLowArrowColor1;
      highArrows[0] = HighArrow1;
      lowArrows[0] = LowArrow1;
      highBrokens[0] = HighBroken1;
      lowBrokens[0] = LowBroken1;
     }
   if(inpFilter2)
     {
      ArrayResize(filterTimeFrames, 2);
      ArrayResize(highArrowsColor, 2);
      ArrayResize(lowArrowsColor, 2);
      ArrayResize(highArrows, 2);
      ArrayResize(lowArrows, 2);
      ArrayResize(highBrokens, 2);
      ArrayResize(lowBrokens, 2);
      ArrayResize(lowBrokenFlags, 2);
      ArrayResize(highBrokenFlags, 2);

      highBrokenFlags[0] = false;
      lowBrokenFlags[0] = false;
      highBrokenFlags[1] = false;
      lowBrokenFlags[1] = false;
      filterTimeFrames[1] = inpTimeFrameFilter2;
      highArrowsColor[1] = inpHighArrowColor2;
      lowArrowsColor[1] = inpLowArrowColor2;
      highArrows[1] = HighArrow2;
      lowArrows[1] = LowArrow2;
      highBrokens[1] = HighBroken2;
      lowBrokens[1] = LowBroken2;
     }
   if(inpFilter3)
     {
      ArrayResize(filterTimeFrames, 3);
      ArrayResize(highArrowsColor, 3);
      ArrayResize(lowArrowsColor, 3);
      ArrayResize(highArrows, 3);
      ArrayResize(lowArrows, 3);
      ArrayResize(highBrokens, 3);
      ArrayResize(lowBrokens, 3);
      ArrayResize(lowBrokenFlags, 3);
      ArrayResize(highBrokenFlags, 3);

      highBrokenFlags[0] = false;
      lowBrokenFlags[0] = false;
      highBrokenFlags[1] = false;
      lowBrokenFlags[1] = false;
      highBrokenFlags[2] = false;
      lowBrokenFlags[2] = false;
      filterTimeFrames[2] = inpTimeFrameFilter3;
      highArrowsColor[2] = inpHighArrowColor3;
      lowArrowsColor[2] = inpLowArrowColor3;
      highArrows[2] = HighArrow3;
      lowArrows[2] = LowArrow3;
      highBrokens[2] = HighBroken3;
      lowBrokens[2] = LowBroken3;
     };
   InitializeHiloIndicator();
   Settings_Initialize();
   if(ShowInfo)
      Design_Create();
   today = TimeDayOfYear(TimeCurrent());
   today_start_equity = AccountEquity();
//+--------------------------MTLicense Block3------------------------+
   HideTestIndicators(true);
   MTLic_OnInit();
//+--------------------------MTLicense Block3------------------------+

   if(!IsTradeAllowed())
      Alert("Not TradeAllowed");

   Spread = 2.0;
   if(InpManualInitGrid)
     {

      DrawRects(250, 15, Gray, 80, 50, "SELL");
      DrawRects(420, 15, Gray, 80, 50, "BUY");
      DrawRects(600, 15, Gray, 80, 50, "CLOSE ALL BUY");
      DrawRects(770, 15, Gray, 80, 50, "CLOSE ALL SELL");
     }

//---
   m_symbol = Symbol();

   if(Digits == 3 || Digits == 5)
      m_pip1 = 10.0 * Point;
   else
      m_pip1 = Point;
   m_size1 = InpGridSize * m_pip1;
   m_take1 = InpTakeProfit * m_pip1;
   m_hedging1 = false;
   m_target_filter1 = false;
   m_direction1 = 0;

   m_datetime_ultcandleopen1 = -1;
   m_time_equityrisk1 = -1;
   m_orders_count1 = 0;
   m_lastlot1 = 0;

   if(Digits == 3 || Digits == 5)
      m_pip2 = 10.0 * Point;
   else
      m_pip2 = Point;
   m_size2 = InpGridSize * m_pip2;
   m_take2 = InpTakeProfit * m_pip2;
   m_hedging2 = false;
   m_target_filter2 = false;
   m_direction2 = 0;

   m_datetime_ultcandleopen2 = -1;
   m_time_equityrisk2 = -1;
   m_orders_count2 = 0;
   m_lastlot2 = 0;

   m_filters_on = "";
   m_initpainel = true;
   HideTestIndicators(True);

//---
   printf("RONIN EA V2.0");

   CWeek = iTime(_Symbol, PERIOD_W1, 0);

   if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED))
     {
      Alert("Error. DLL using disabled. Please enable using DLL. Expert stopped");
      return(INIT_FAILED);
     }

   ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, true);
   if(IsTesting())
     {
      bool success = ReadBacktestNews(BacktestURL, "ffc1.csv");

      if(success)
        {
         DisplayBacktestNews();
        }
     }
   else
     {
      if(NewsFilterSource == ForexFactory)
         GetForexFactoryCalendar(FFURL);
      else
         if(NewsFilterSource == EnergyExch)
            GetForexFactoryCalendar(EEURL);
         else
            if(NewsFilterSource == MetalsMine)
               GetForexFactoryCalendar(MMURL);
     }
   return (INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Design_Delete();
//+--------------------------MTLicense Block4------------------------+
   ObjectsDeleteAll(0, "MTlic_");
   Comment("");
//+--------------------------MTLicense Block4------------------------+

   ObjectDelete("Market_Price_Label");
   ObjectDelete("Time_Label");
   ObjectDelete("Porcent_Price_Label");
   ObjectDelete("Spread_Price_Label");
   ObjectDelete("Simbol_Price_Label");
   HideTestIndicators(False);
//---
   if(!IsTesting())
      ObjectsDeleteAll(0, obj_prefix);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(inpUseHighLowTrendFilter)
     {
      if(IsNewBar())
        {
         for(int j = 0; j < ArraySize(filterTimeFrames); j++)
           {
            if(highArrows[j].Price(0) != GetHighOnXLastCandles(filterTimeFrames[j]) && GetHighOnXLastCandles(filterTimeFrames[j]) != 0)
              {
               highBrokenFlags[j] = false;
               datetime highOpenTimeOnDiffTF = GetOpenTimeOfXcandleHighOnTheCurrentTF(highIndex, filterTimeFrames[j]);
               CreateHighArrow(GetHighOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, inpXCandles + 1, filterTimeFrames[j]), highOpenTimeOnDiffTF, j);
              }
            if(lowArrows[j].Price(0) != GetLowOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, inpXCandles + 1, filterTimeFrames[j]) && GetLowOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, inpXCandles + 1, filterTimeFrames[j]) != 0)
              {
               lowBrokenFlags[j] = false;
               datetime lowOpenTimeOnDiffTF = GetOpenTimeOfXcandleLowOnTheCurrentTF(lowIndex, filterTimeFrames[j]);
               CreateLowArrow(GetLowOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, inpXCandles + 1, filterTimeFrames[j]), lowOpenTimeOnDiffTF, j);
              }

           }
        }
      for(int k = 0; k < ArraySize(filterTimeFrames); k++)
        {
         if(IsLastHighBroken(Ask, k) && !highBrokenFlags[k])
           {
            CreateHighBrokenTrendLine(iTime(_Symbol, filterTimeFrames[k], 0), highArrowsColor[k], k);
            highBrokenFlags[k] = true;
           }
         if(IsLastLowBroken(Bid, k) && !lowBrokenFlags[k])
           {
            CreateLowBrokenTrendLine(iTime(_Symbol, filterTimeFrames[k], 0), lowArrowsColor[k], k);
            lowBrokenFlags[k] = true;
           }
        }
      CheckIsBullish();
      CheckIsBearish();
      if(inpCloseTradeOnTrendSwitch)
        {
         if(isBullish && GetNumberOfOrderByType(ORDER_TYPE_SELL) > 0)
            CloseAllByType(ORDER_TYPE_SELL);
         if(isBearish && GetNumberOfOrderByType(ORDER_TYPE_BUY) > 0)
            CloseAllByType(ORDER_TYPE_BUY);
        }
     }
   HasTimerBeenReached();
   CheckAllTimeTarget();
   SetPeriodOfTimeEquity();
   if(!IsTesting())
     {
      if(CWeek != iTime(_Symbol, PERIOD_W1, 0))
        {
         CWeek = iTime(_Symbol, PERIOD_W1, 0);

         if(NewsFilterSource == ForexFactory)
            GetForexFactoryCalendar(FFURL);
         else
            if(NewsFilterSource == EnergyExch)
               GetForexFactoryCalendar(EEURL);
            else
               if(NewsFilterSource == MetalsMine)
                  GetForexFactoryCalendar(MMURL);
        }
     }
   Daily_Profit();
   Is_New_Day();
   weekly_profit = Weekly_Profit();
   monthly_profit = Monthly_Profit();
   Update_Values();
//+---------------------------MTLicense Block5-----------------------+
   MTLic_OnTick();
//+---------------------------MTLicense Block5-----------------------+

   bool TradeNow = true;
   if(m_orders_count1 == 0)
      ObjectDelete("AvgA");

   if(m_orders_count2 == 0)
      ObjectDelete("AvgB");

   m_profit_all = CalculateProfit();

   if(InpCloseAllNow)
     {
      CloseThisSymbolAll(InpMagic);
      CloseThisSymbolAll(InpMagic2);
      InpManualInitGrid = true;
     }

   if(InpUseTakeEquityStop == true && m_profit_all >= InpProfitCloseandSTOP)
     {
      CloseThisSymbolAll(InpMagic);
      CloseThisSymbolAll(InpMagic2);
     }

   m_lastlot2 = FindLastSellLot(InpMagic2);
   m_lastlot1 = FindLastBuyLot(InpMagic);

   if(InpManualInitGrid)
     {
      if(m_lastlot1 > 0 || !InpEnableEngineA)
        {
         ObjectSetInteger(0, "_lBUY", OBJPROP_BGCOLOR, Gray);
         ObjectSetInteger(0, "_lCLOSE ALL BUY", OBJPROP_BGCOLOR, Green);
        }
      else
        {
         ObjectSetInteger(0, "_lBUY", OBJPROP_BGCOLOR, Blue);
         ObjectSetInteger(0, "_lCLOSE ALL BUY", OBJPROP_BGCOLOR, Gray);
        }

      if(m_lastlot2 > 0 || !InpEnableEngineB)
        {
         ObjectSetInteger(0, "_lSELL", OBJPROP_BGCOLOR, Gray);
         ObjectSetInteger(0, "_lCLOSE ALL SELL", OBJPROP_BGCOLOR, Green);
        }
      else
        {
         ObjectSetInteger(0, "_lSELL", OBJPROP_BGCOLOR, Red);
         ObjectSetInteger(0, "_lCLOSE ALL SELL", OBJPROP_BGCOLOR, Gray);
        }

      if(ObjectGetInteger(0, "_lBUY", OBJPROP_STATE) && !(m_orders_count1 > 0 || !InpEnableEngineA))
        {
         ronin("A", 1, 0, true, InpMagic, m_orders_count1, m_mediaprice1, m_hedging1, m_target_filter1,
               m_direction1, m_current_day1, m_previous_day1, m_level1, m_buyer1, m_seller1,
               m_target1, m_profit1, m_pip1, m_size1, m_take1, m_datetime_ultcandleopen1,
               m_time_equityrisk1, profit1);
         //  Alert("BUY");
         ObjectSetInteger(0, "_lBUY", OBJPROP_STATE, false);
        }

      if(ObjectGetInteger(0, "_lSELL", OBJPROP_STATE) && !(m_orders_count2 > 0 || !InpEnableEngineA))
        {
         ronin("B", -1, 0, true, InpMagic2, m_orders_count2, m_mediaprice2, m_hedging2,
               m_target_filter2, m_direction2, m_current_day2, m_previous_day2,
               m_level2, m_buyer2, m_seller2, m_target2, m_profit2, m_pip2,
               m_size2, m_take2, m_datetime_ultcandleopen2,
               m_time_equityrisk2, profit2);
         // Alert("SELL");
         ObjectSetInteger(0, "_lSELL", OBJPROP_STATE, false);
        }

      if(ObjectGetInteger(0, "_lCLOSE ALL SELL", OBJPROP_STATE))
        {
         // Alert("CLOSE ALL SELL");
         CloseThisSymbolAll(InpMagic2);
         ObjectSetInteger(0, "_lCLOSE ALL SELL", OBJPROP_STATE, false);
        }

      if(ObjectGetInteger(0, "_lCLOSE ALL BUY", OBJPROP_STATE))
        {
         //  Alert("CLOSE ALL BUY");
         CloseThisSymbolAll(InpMagic);
         ObjectSetInteger(0, "_lCLOSE ALL BUY", OBJPROP_STATE, false);
        }
     }

   if(CountTrades() == 0 && GetLastError() == ERR_NOT_ENOUGH_MONEY)
     {
      if(InpCloseRemoveEA)
        {
         ExpertRemove();
         ChartClose();
         return;
        }
     }

   if(InpUseEquityStop)
     {
      if(m_profit_all < 0.0 && MathAbs(m_profit_all) > InpTotalEquityRisk / 100.0 * AccountEquity())
        {
         if(InpCloseAllEquityLoss)
           {
            CloseThisSymbolAll(InpMagic);
            CloseThisSymbolAll(InpMagic2);
            equityStopLaunchTime = TimeCurrent() + inpHoursToWait * 60 * 60;
            Alert("Closed All to Stop Out - EA Will wait ", inpHoursToWait, " Before Relaunch");

            if(InpCloseRemoveEA)
              {
               ExpertRemove();
               ChartClose();
               return;
              }
           }
         if(InpAlertPushEquityLoss)
            SendNotification("EquityLoss Alert " + (string)m_profit_all);
         m_time_equityriskstopall = iTime(NULL, PERIOD_MN1, 0);
         m_filters_on += "Filter UseEquityStop ON \n";
         return;
        }
      else
        {
         m_time_equityriskstopall = -1;
        }
     }


   RefreshRates();

   m_filters_on = "";

   if(m_time_equityriskstopall == iTime(NULL, PERIOD_MN1, 0) && (m_profit_all < 0.0 && MathAbs(m_profit_all) > InpTotalEquityRisk / 100.0 * AccountEquity()))
     {
      m_filters_on += "Filter EquitySTOP  ON \n";
      TradeNow = false;
     }


//FILTER SPREAD
   m_spreadX = (double)MarketInfo(Symbol(), MODE_SPREAD) * m_pip2;
   if((int)MarketInfo(Symbol(), MODE_SPREAD) > InpMaxSpread)
     {
      m_filters_on += "Filter InpMaxSpread ON \n";
      TradeNow = false;
     }

//FILTER NEWS
//if (InpUseFFCall)
//  NewsHandling();

//FILTER DATETIME
   if(InpUtilizeTimeFilter && !TimeFilter())
     {
      m_filters_on += "Filter TimeFilter ON \n";
      TradeNow = false;
     }

   int Sinal = 0;

   int SinalMA = 0;
   int SinalHilo = 0;

   if(iClose(NULL, 0, 0) > iMA(NULL, InpMaFrame, InpMaPeriod, 0, InpMaMethod, InpMaPrice, InpMaShift))
      SinalMA = 1;
   if(iClose(NULL, 0, 0) < iMA(NULL, InpMaFrame, InpMaPeriod, 0, InpMaMethod, InpMaPrice, InpMaShift))
      SinalMA = -1;

   SinalHilo = GetSinalHILO();

   Sinal = (SinalHilo + SinalMA) / (1 + DivSinalHILO());

   double LotsHedge = 0;

//FILTER EquityCaution
   if(m_orders_count1 == 0)
      m_time_equityrisk1 = -1;

//Se todos Motores estiverem desabilitados
   if(!InpEnableEngineB && !InpEnableEngineA)
     {
      if(m_time_equityrisk1 == iTime(NULL, InpTimeframeEquityCaution, 0))
        {
         m_filters_on += "Filter EquityCaution S ON \n";
         TradeNow = false;
        }

      ronin("S", Sinal, TradeNow, LotsHedge, InpMagic, m_orders_count1, m_mediaprice1, m_hedging1, m_target_filter1,
            m_direction1, m_current_day1, m_previous_day1, m_level1, m_buyer1, m_seller1,
            m_target1, m_profit1, m_pip1, m_size1, m_take1, m_datetime_ultcandleopen1,
            m_time_equityrisk1, profit1);
     }
   else
     {
      if(!InpManualInitGrid)
        {
         if(m_time_equityrisk1 == iTime(NULL, InpTimeframeEquityCaution, 0) && m_time_equityrisk2 != iTime(NULL, InpTimeframeEquityCaution, 0))
           {
            m_filters_on += "Filter EquityCaution A ON \n";
            TradeNow = false;
           }

         // if(m_time_equityrisk2 == iTime(NULL, InpTimeframeEquityCaution, 0)) {
         if(m_orders_count2 > InpHedgex && InpHedgex != 0)
           {
            LotsHedge = m_lastlot2 / InpGridFactor;
           }

         if(Sinal == 1 && InpEnableEngineA)
            ronin("A", 1, TradeNow, LotsHedge, InpMagic, m_orders_count1, m_mediaprice1, m_hedging1, m_target_filter1,
                  m_direction1, m_current_day1, m_previous_day1, m_level1, m_buyer1, m_seller1,
                  m_target1, m_profit1, m_pip1, m_size1, m_take1, m_datetime_ultcandleopen1,
                  m_time_equityrisk1, profit1);

         if(m_orders_count2 == 0)
            m_time_equityrisk2 = -1;

         if(m_time_equityrisk2 == iTime(NULL, InpTimeframeEquityCaution, 0) && m_time_equityrisk1 != iTime(NULL, InpTimeframeEquityCaution, 0))
           {
            m_filters_on += "Filter EquityCaution B ON \n";
            TradeNow = false;
           }

         // if(m_time_equityrisk1 == iTime(NULL, InpTimeframeEquityCaution, 0)) {
         if(m_orders_count1 > InpHedgex && InpHedgex != 0)
           {
            LotsHedge = m_lastlot1 / InpGridFactor;
           }

         if(Sinal == -1 && InpEnableEngineB)
            ronin("B", -1, TradeNow, LotsHedge, InpMagic2, m_orders_count2, m_mediaprice2, m_hedging2,
                  m_target_filter2, m_direction2, m_current_day2, m_previous_day2,
                  m_level2, m_buyer2, m_seller2, m_target2, m_profit2, m_pip2,
                  m_size2, m_take2, m_datetime_ultcandleopen2,
                  m_time_equityrisk2, profit2);
        }
      else
        {

         ronin("A", 0, TradeNow, LotsHedge, InpMagic, m_orders_count1, m_mediaprice1, m_hedging1, m_target_filter1,
               m_direction1, m_current_day1, m_previous_day1, m_level1, m_buyer1, m_seller1,
               m_target1, m_profit1, m_pip1, m_size1, m_take1, m_datetime_ultcandleopen1,
               m_time_equityrisk1, profit1);

         ronin("B", 0, TradeNow, LotsHedge, InpMagic2, m_orders_count2, m_mediaprice2, m_hedging2,
               m_target_filter2, m_direction2, m_current_day2, m_previous_day2,
               m_level2, m_buyer2, m_seller2, m_target2, m_profit2, m_pip2,
               m_size2, m_take2, m_datetime_ultcandleopen2,
               m_time_equityrisk2, profit2);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   if(id == CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam == "Button_Close_All")
        {
         Close_All_Order();
         Sleep(100);
         ObjectSetInteger(0, "Button_Close_All", OBJPROP_STATE, false);
        }
      if(sparam == "Button_Close_Profit")
        {
         Close_Profit_Order();
         Sleep(100);
         ObjectSetInteger(0, "Button_Close_Profit", OBJPROP_STATE, false);
        }
      if(sparam == "Button_Close_Loss")
        {
         Close_Loss_Order();
         Sleep(100);
         ObjectSetInteger(0, "Button_Close_Loss", OBJPROP_STATE, false);
        }
      if(sparam == "Button_Minimize")
        {
         Minimize();
         Sleep(100);
         ObjectSetInteger(0, "Button_Minimize", OBJPROP_STATE, false);
        }
      if(sparam == "Button_Maximize")
        {
         Maximize();
         Sleep(100);
         ObjectSetInteger(0, "Button_Maximize", OBJPROP_STATE, false);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ronin(string Id, int Sinal, bool TradeNow, double LotsHedge, int vInpMagic, int &m_orders_count, double &m_mediaprice, bool &m_hedging, bool &m_target_filter,
           int &m_direction, int &m_current_day, int &m_previous_day,
           double &m_level, double &m_buyer, double &m_seller, double &m_target, double &m_profit,
           double &m_pip, double &m_size, double &m_take, datetime &vDatetimeUltCandleOpen,
           datetime &m_time_equityrisk, double &profit)
  {

//--- Variable Declaration
   int index, orders_total, order_ticket, order_type, ticket=0, hour;
   double volume_min, volume_max, volume_step, lots;
   double account_balance, margin_required, risk_balance;
   double order_open_price, order_lots;

//--- Variable Initialization
   int buy_ticket = 0, sell_ticket = 0, orders_count = 0, buy_ticket2 = 0, sell_ticket2 = 0;
   int buyer_counter = 0, seller_counter = 0;
   bool was_trade = false, close_filter = false;
   bool long_condition = false, short_condition = false;
   double orders_profit = 0.0, level = 0.0;
   double buyer_lots = 0.0, seller_lots = 0.0;
   double buyer_sum = 0.0, seller_sum = 0.0, sell_lot = 0, buy_lot = 0;
   ;
   double buy_price = 0.0, sell_price = 0.0;
   double bid_price = Bid, ask_price = Ask;
   double close_price = iClose(NULL, 0, 0);
   double open_price = iOpen(NULL, 0, 0);
   datetime time_current = TimeCurrent();
   bool res = false;
   m_spreadX = 2.0 * m_pip;

//--- Base Lot Size
   account_balance = AccountBalance();
   volume_min = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
   volume_max = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MAX);
   volume_step = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);
   lots = volume_min;

   if(InpLotMode == LOT_MODE_FIXED)
      lots = InpFixedLot;
   else
      if(InpLotMode == LOT_MODE_PERCENT)
        {
         risk_balance = InpPercentLot * AccountBalance() / 100.0;
         margin_required = MarketInfo(m_symbol, MODE_MARGINREQUIRED);
         lots = MathRound(risk_balance / margin_required, volume_step);
         if(lots < volume_min)
            lots = volume_min;
         if(lots > volume_max)
            lots = volume_max;
        }

//--- Daily Calc
   m_current_day = TimeDayOfWeek(time_current);
   if(m_current_day != m_previous_day)
     {
      m_target_filter = false;
      m_target = 0.0;
     }
   m_previous_day = m_current_day;

//--- Calculation Loop
   orders_total = OrdersTotal();
   m_mediaprice = 0;
   double BuyProfit = 0;
   double SellProfit = 0;
   int countFirts = 0;
   double Firts2SellProfit = 0;
   double Firts2BuyProfit = 0;
   int Firtsticket[50];
   double LastSellProfit = 0;
   double LastBuyProfit = 0;
   int Lastticket = 0;

   for(index = orders_total - 1; index >= 0; index--)
     {
      if(!OrderSelect(index, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderMagicNumber() != vInpMagic || OrderSymbol() != m_symbol)
         continue;
      order_open_price = OrderOpenPrice();
      order_ticket = OrderTicket();
      order_type = OrderType();
      order_lots = OrderLots();

      //---
      if(order_type == OP_BUY)
        {

         //--- Set Last Buy Order
         if(order_ticket > buy_ticket)
           {

            buy_price = order_open_price;
            buy_ticket = order_ticket;
            LastBuyProfit = OrderProfit() + OrderCommission() + OrderSwap();
            Lastticket = order_ticket;
            buy_lot = order_lots;
           }

         buyer_sum += (order_open_price - m_spreadX) * order_lots;

         buyer_lots += order_lots;
         buyer_counter++;
         orders_count++;
         m_mediaprice += order_open_price * order_lots;
         if(OrderProfit() > 0)
            BuyProfit += OrderProfit() + OrderCommission() + OrderSwap();
        }

      //---
      if(order_type == OP_SELL)
        {


         //--- Set Last Sell Order
         if(order_ticket > sell_ticket)
           {

            sell_price = order_open_price;
            sell_ticket = order_ticket;
            LastSellProfit = OrderProfit() + OrderCommission() + OrderSwap();
            Lastticket = order_ticket;
            sell_lot = order_lots;
           }

         seller_sum += (order_open_price + m_spreadX) * order_lots;

         seller_lots += order_lots;
         seller_counter++;
         orders_count++;
         m_mediaprice += order_open_price * order_lots;
         if(OrderProfit() > 0)
            SellProfit += OrderProfit() + OrderCommission() + OrderSwap();
        }

      //---
      orders_profit += OrderProfit();
     }

//Close
   if(ProtectGridLastFist && orders_count > QtdTradesMinProfit)
     {
      int ordticket[100];

      Firts2BuyProfit  = FindFirstOrderTicket(vInpMagic, Symbol(), OP_BUY, QtdTradesMinProfit,  ordticket);


      if(LastBuyProfit > (Firts2BuyProfit * -1) + MinProfit)
        {
         CloseAllTicket(OP_BUY, Lastticket, vInpMagic);

         for(int i = 0; i < QtdTradesMinProfit; i++)
           {
            CloseAllTicket(OP_BUY, ordticket[i], vInpMagic);
           }
        }

      Firts2SellProfit = FindFirstOrderTicket(vInpMagic, Symbol(), OP_SELL, QtdTradesMinProfit,  ordticket);


      if(LastSellProfit > (Firts2SellProfit * -1) + MinProfit)
        {

         CloseAllTicket(OP_SELL, Lastticket, vInpMagic);

         for(int i = 0; i < QtdTradesMinProfit; i++)
           {
            CloseAllTicket(OP_SELL, ordticket[i], vInpMagic);
           }
        }
     }

   m_orders_count = orders_count;
   m_profit = orders_profit;
   if((seller_counter + buyer_counter) > 0)
      m_mediaprice = NormalizeDouble(m_mediaprice / (buyer_lots + seller_lots), Digits);

   color avgLine = Blue;
   if(seller_lots > 0)
      avgLine = Red;

   if(buyer_lots > 0 || seller_lots > 0)
      SetHLine(avgLine, "Avg" + Id, m_mediaprice, 0, 3);
   else
      ObjectDelete("Avg" + Id);

   if(InpUseTrailingStop)
      TrailingAlls(InpTrailStart, InpTrailStop, m_mediaprice, vInpMagic);

   if(InpUseBreakEven)
      BreakEvenAlls(InpBreakEvenStart, InpBreakEvenStep, m_mediaprice, vInpMagic);

//--- Calc
   if(orders_count == 0)
     {
      m_target += m_profit;
      m_hedging = false;
     }
   profit = m_target + orders_profit;

//--- Close Conditions
   if(InpDailyTarget > 0 && m_target + orders_profit >= InpDailyTarget)
      m_target_filter = true;
//--- This ensure that buy and sell positions close at the same time when hedging is enabled
   if(m_hedging && ((m_direction > 0 && bid_price >= m_level) || (m_direction < 0 && ask_price <= m_level)))
      close_filter = true;

//--- Close All Orders on Conditions
   if(m_target_filter || close_filter)
     {

      CloseThisSymbolAll(vInpMagic);

      // m_spread=0.0;
      return;
     }

//--- Open Trade Conditions
   if(!m_hedging)
     {
      if(orders_count > 0 && !GridAll)
        {
         if(OpenNewOrdersGrid == true && TradeNow)
           {
            if(m_time_equityrisk1 != iTime(NULL, InpTimeframeEquityCaution, 0))
              {
               if(GridAllDirect)
                 {
                  if(buyer_counter > 0 && ask_price - buy_price >= m_size)
                     long_condition = true;
                  if(seller_counter > 0 && sell_price - bid_price >= m_size)
                     short_condition = true;
                 }
               if(buyer_counter > 0 && buy_price - ask_price >= m_size)
                  long_condition = true;
               if(seller_counter > 0 && bid_price - sell_price >= m_size)
                  short_condition = true;
              }
           }
        }
      else
        {

         if(InpOpenNewOrders && TradeNow)
           {
            hour = TimeHour(time_current);
            if(InpManualInitGrid || (!InpUtilizeTimeFilter || (InpUtilizeTimeFilter && TimeFilter())))
              {

               if(Sinal == 1)
                  short_condition = true;
               if(Sinal == -1)
                  long_condition = true;
              }
           }
        }
     }
   else
     {
      if(m_direction > 0 && bid_price <= m_seller)
         long_condition = true;
      if(m_direction < 0 && ask_price >= m_buyer)
         short_condition = true;
     }

// CONTROL DRAWDOWN
   double vProfit = CalculateProfit(vInpMagic);

   if(vProfit < 0.0 && MathAbs(vProfit) > InpTotalEquityRiskCaution / 100.0 * AccountEquity())
     {
      m_time_equityrisk = iTime(NULL, InpTimeframeEquityCaution, 0);
     }
   else
     {
      m_time_equityrisk = -1;
     }

//--- Hedging
   if(InpHedge > 0 && !m_hedging)
     {
      if(long_condition && buyer_counter == InpHedge)
        {
         // m_spread = Spread * m_pip;
         m_seller = bid_price;
         m_hedging = true;
         return;
        }
      if(short_condition && seller_counter == InpHedge)
        {
         // m_spread= Spread * m_pip;
         m_buyer = ask_price;
         m_hedging = true;
         return;
        }
     }

//--- Lot Size
   if(LotsHedge != 0 && orders_count == 0)
     {
      lots = LotsHedge;
     }
   else
     {
      //lots = MathRound(lots * MathPow(InpGridFactor, orders_count), volume_step);

      double qtdLots = (sell_lot + buy_lot);
      if(long_condition)

         lots = MathRound(CalcLot(TypeGridLot, OP_BUY, orders_count, qtdLots, lots, InpGridFactor, InpGridStepLot), volume_step);
      if(short_condition)

         lots = MathRound(CalcLot(TypeGridLot, OP_SELL, orders_count, qtdLots, lots, InpGridFactor, InpGridStepLot), volume_step);

      if(m_hedging)
        {
         if(long_condition)
            lots = MathRound(seller_lots * 3, volume_step) - buyer_lots;
         if(short_condition)
            lots = MathRound(buyer_lots * 3, volume_step) - seller_lots;
        }
     }
   if(lots < volume_min)
      lots = volume_min;
   if(lots > volume_max)
      lots = volume_max;
   if(lots > InpMaxLot)
      lots = InpMaxLot;

//--- Open Trades Based on Conditions
   if((InpManualInitGrid && orders_count == 0) || (!InpOpenOneCandle || (InpOpenOneCandle && vDatetimeUltCandleOpen != iTime(NULL, InpTimeframeBarOpen, 0))))
     {
      vDatetimeUltCandleOpen = iTime(NULL, InpTimeframeBarOpen, 0);

      if(long_condition && !IsMaxTrade(OP_BUY))
        {
         if(buyer_lots + lots == seller_lots)
            lots = seller_lots + volume_min;
         //---
         double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT),
                sl = (HardSL > 0) ? ask_price - (HardSL * point) : 0;

         if(CheckNewsFilter())
           {
            if(LotAdjustment(lots) == true  && ((isBullish && !isBearish) || !inpUseHighLowTrendFilter))
              {
               MultipleOrderPlaced(OP_BUY, ask_price, vInpMagic, sl, lots, inpSubLot);
              }
            if(LotAdjustment(lots) == false && ((isBullish && !isBearish) || !inpUseHighLowTrendFilter))
              {
               ticket = OpenTrade(OP_BUY, lots, ask_price, vInpMagic, "Ronin EA " + string(vInpMagic), sl);
              }

            if(ticket > 0)
              {
               if(HardSL > 0)
                  UpdateSL(OP_BUY, vInpMagic, sl);
               res = OrderSelect(ticket, SELECT_BY_TICKET);
               order_open_price = OrderOpenPrice();
               buyer_sum += order_open_price * lots;
               buyer_lots += lots;
               m_level = NormalizeDouble((buyer_sum - seller_sum) / (buyer_lots - seller_lots), Digits) + m_take;
               if(!m_hedging)
                  level = m_level;
               else
                  level = m_level + m_take;
               if(buyer_counter == 0)
                  m_buyer = order_open_price;
               m_direction = 1;
               was_trade = true;
              }
           }
        }

      if(short_condition && !IsMaxTrade(OP_SELL))
        {
         if(seller_lots + lots == buyer_lots)
            lots = buyer_lots + volume_min;
         //---
         double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT),
                sl = (HardSL > 0) ? bid_price + (HardSL * point) : 0;

         if(CheckNewsFilter())
           {
            if(LotAdjustment(lots) == true && ((isBearish && !isBullish) || !inpUseHighLowTrendFilter))
              {
               MultipleOrderPlaced(OP_SELL, bid_price, vInpMagic, sl, lots, inpSubLot);
              }
            if(LotAdjustment(lots) == false && ((isBearish && !isBullish) || !inpUseHighLowTrendFilter))
              {
               ticket = OpenTrade(OP_SELL, lots, bid_price, vInpMagic, "Ronin EA " + string(vInpMagic), sl);
              }

            if(ticket > 0)
              {
               if(HardSL > 0)
                  UpdateSL(OP_SELL, vInpMagic, sl);
               res = OrderSelect(ticket, SELECT_BY_TICKET);
               order_open_price = OrderOpenPrice();
               seller_sum += order_open_price * lots;
               seller_lots += lots;
               m_level = NormalizeDouble((seller_sum - buyer_sum) / (seller_lots - buyer_lots), Digits) - m_take;
               if(!m_hedging)
                  level = m_level;
               else
                  level = m_level - m_take;
               if(seller_counter == 0)
                  m_seller = order_open_price;
               m_direction = -1;
               was_trade = true;
              }
           }
        }
     }

   if(InpEnableMinProfit && !ProtectGridLastFist)
     {
      if(BuyProfit >= MinProfit && buyer_counter >= QtdTradesMinProfit)
         CloseAllTicket(OP_BUY, buy_ticket, vInpMagic);

      if(SellProfit >= MinProfit && seller_counter >= QtdTradesMinProfit)
         CloseAllTicket(OP_SELL, sell_ticket, vInpMagic);
     }

//--- Setup Global Take Profit
   if(was_trade)
     {
      orders_total = OrdersTotal();
      for(index = orders_total - 1; index >= 0; index--)
        {
         if(!OrderSelect(index, SELECT_BY_POS, MODE_TRADES))
            continue;
         if(OrderMagicNumber() != vInpMagic || OrderSymbol() != m_symbol)
            continue;
         order_type = OrderType();
         if(m_direction > 0)
           {
            if(order_type == OP_BUY)
               res = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), level, 0);
            if(order_type == OP_SELL)
               res = OrderModify(OrderTicket(), OrderOpenPrice(), level, 0.0, 0);
           }
         if(m_direction < 0)
           {
            if(order_type == OP_BUY)
               res = OrderModify(OrderTicket(), OrderOpenPrice(), level, 0.0, 0);
            if(order_type == OP_SELL)
               res = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), level, 0);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateSL(int type, int magic, double sl)
  {
   const int retries_max = 10;
   int ord_total = OrdersTotal();
   for(int i = ord_total - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS) && OrderMagicNumber() == magic)
        {
         if(OrderType() == type && OrderSymbol() == m_symbol)
           {
            if(fabs(OrderStopLoss() - sl) > SymbolInfoDouble(m_symbol, SYMBOL_POINT))
              {
               int retry = 0;
               bool mod = false;
               while(retry < retries_max && !mod)
                 {
                  mod = OrderModify(OrderTicket(), OrderOpenPrice(), sl, OrderTakeProfit(), 0);
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsMaxTrade(int signal)
  {
   if(signal == OP_BUY)
     {
      if(MaxBuy <= 0)
         return false;
      //---
      int buy = CountTradesBuy(InpMagic) + CountTradesBuy(InpMagic2);
      if(buy >= MaxBuy)
         return true;
     }
   else //OP_SELL
     {
      if(MaxSell <= 0)
         return false;
      //---
      int sell = CountTradesSell(InpMagic) + CountTradesSell(InpMagic2);
      if(sell >= MaxSell)
         return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
int OpenTrade(int cmd, double volume, double price, int vInpMagic, string coment, double stop = 0.0, double take = 0.0)
  {
   string comment;
   if(cmd == OP_BUY)
      comment = InpComment + (string)InpMagic;
   if(cmd == OP_SELL)
      comment = InpComment + (string)InpMagic2;
   if(!CheckAllTimeTarget() && HasEquityStopLaunchTimeBeenReached())
      return OrderSend(m_symbol, cmd, volume, price, SlipPage, stop, take, comment, vInpMagic, 0);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MathRound(double x, double m) { return m * MathRound(x / m); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MathFloor(double x, double m) { return m * MathFloor(x / m); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MathCeil(double x, double m) { return m * MathCeil(x / m); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountTrades()
  {
   int l_count_0 = 0;
   for(int l_pos_4 = OrdersTotal() - 1; l_pos_4 >= 0; l_pos_4--)
     {
      if(!OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() != Symbol() || (OrderMagicNumber() != InpMagic && OrderMagicNumber() != InpMagic2))
         continue;
      if(OrderSymbol() == Symbol() && (OrderMagicNumber() == InpMagic || OrderMagicNumber() == InpMagic2))
         if(OrderType() == OP_SELL || OrderType() == OP_BUY)
            l_count_0++;
     }
   return (l_count_0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountTrades(int vInpMagic)
  {
   int l_count_0 = 0;
   for(int l_pos_4 = OrdersTotal() - 1; l_pos_4 >= 0; l_pos_4--)
     {
      if(!OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() != Symbol() || (OrderMagicNumber() != vInpMagic))
         continue;
      if(OrderSymbol() == Symbol() && (OrderMagicNumber() == vInpMagic))
         if(OrderType() == OP_SELL || OrderType() == OP_BUY)
            l_count_0++;
     }
   return (l_count_0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountTradesSell(int vInpMagic)
  {
   int l_count_0 = 0;
   for(int l_pos_4 = OrdersTotal() - 1; l_pos_4 >= 0; l_pos_4--)
     {
      if(!OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() != Symbol() || (OrderMagicNumber() != vInpMagic))
         continue;
      if(OrderSymbol() == Symbol() && (OrderMagicNumber() == vInpMagic))
         if(OrderType() == OP_SELL)
            l_count_0++;
     }
   return (l_count_0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountTradesBuy(int vInpMagic)
  {
   int l_count_0 = 0;
   for(int l_pos_4 = OrdersTotal() - 1; l_pos_4 >= 0; l_pos_4--)
     {
      if(!OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() != Symbol() || (OrderMagicNumber() != vInpMagic))
         continue;
      if(OrderSymbol() == Symbol() && (OrderMagicNumber() == vInpMagic))
         if(OrderType() == OP_BUY)
            l_count_0++;
     }
   return (l_count_0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateProfit()
  {
   double ld_ret_0 = 0;
   for(int g_pos_344 = OrdersTotal() - 1; g_pos_344 >= 0; g_pos_344--)
     {
      if(!OrderSelect(g_pos_344, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() != Symbol() || (OrderMagicNumber() != InpMagic && OrderMagicNumber() != InpMagic2))
         continue;
      if(OrderSymbol() == Symbol() && (OrderMagicNumber() == InpMagic || OrderMagicNumber() == InpMagic2))
         if(OrderType() == OP_BUY || OrderType() == OP_SELL)
            ld_ret_0 += OrderProfit();
     }
   return (ld_ret_0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateProfit(int vInpMagic)
  {
   double ld_ret_0 = 0;
   for(int g_pos_344 = OrdersTotal() - 1; g_pos_344 >= 0; g_pos_344--)
     {
      if(!OrderSelect(g_pos_344, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() != Symbol() || (OrderMagicNumber() != vInpMagic))
         continue;
      if(OrderSymbol() == Symbol() && (OrderMagicNumber() == vInpMagic))
         if(OrderType() == OP_BUY || OrderType() == OP_SELL)
            ld_ret_0 += OrderProfit();
     }
   return (ld_ret_0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TimeFilter()
  {

   bool _res = false;
   datetime _time_curent = TimeCurrent();
   datetime _time_start = StrToTime(DoubleToStr(Year(), 0) + "." + DoubleToStr(Month(), 0) + "." + DoubleToStr(Day(), 0) + " " + InpStartHour);
   datetime _time_stop = StrToTime(DoubleToStr(Year(), 0) + "." + DoubleToStr(Month(), 0) + "." + DoubleToStr(Day(), 0) + " " + InpEndHour);
   if(((InpTrade_in_Monday == true) && (TimeDayOfWeek(Time[0]) == 1)) ||
      ((InpTrade_in_Tuesday == true) && (TimeDayOfWeek(Time[0]) == 2)) ||
      ((InpTrade_in_Wednesday == true) && (TimeDayOfWeek(Time[0]) == 3)) ||
      ((InpTrade_in_Thursday == true) && (TimeDayOfWeek(Time[0]) == 4)) ||
      ((InpTrade_in_Friday == true) && (TimeDayOfWeek(Time[0]) == 5)))

      if(_time_start > _time_stop)
        {
         if(_time_curent >= _time_start || _time_curent <= _time_stop)
            _res = true;
        }
      else
         if(_time_curent >= _time_start && _time_curent <= _time_stop)
            _res = true;

   return (_res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isCloseLastOrderNotProfit(int MagicNumber)
  {
   datetime t = 0;
   double ocp, osl, otp;
   int i, j = -1, k = OrdersHistoryTotal();
   for(i = 0; i < k; i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
         if(OrderType() == OP_BUY || OrderType() == OP_SELL)
           {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
              {
               if(t < OrderCloseTime())
                 {
                  t = OrderCloseTime();
                  j = i;
                 }
              }
           }
        }
     }
   if(OrderSelect(j, SELECT_BY_POS, MODE_HISTORY))
     {
      ocp = NormalizeDouble(OrderClosePrice(), Digits);
      osl = NormalizeDouble(OrderStopLoss(), Digits);
      otp = NormalizeDouble(OrderTakeProfit(), Digits);
      if(OrderProfit() < 0)
         return (true);
     }
   return (false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FindLastSellLot(int MagicNumber)
  {
   double l_lastLote = 0;
   int l_ticket_8;
//double ld_unused_12 = 0;
   int l_ticket_20 = 0;
   for(int l_pos_24 = OrdersTotal() - 1; l_pos_24 >= 0; l_pos_24--)
     {
      if(!OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL)
        {
         l_ticket_8 = OrderTicket();
         if(l_ticket_8 > l_ticket_20)
           {
            l_lastLote += OrderLots();
            //ld_unused_12 = l_ord_open_price_0;
            l_ticket_20 = l_ticket_8;
           }
        }
     }
   return (l_lastLote);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FindLastBuyLot(int MagicNumber)
  {
   double l_lastorder = 0;
   int l_ticket_8;
//double ld_unused_12 = 0;
   int l_ticket_20 = 0;
   for(int l_pos_24 = OrdersTotal() - 1; l_pos_24 >= 0; l_pos_24--)
     {
      if(!OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY)
        {
         l_ticket_8 = OrderTicket();
         if(l_ticket_8 > l_ticket_20)
           {
            l_lastorder += OrderLots();
            //ld_unused_12 = l_ord_open_price_0;
            l_ticket_20 = l_ticket_8;
           }
        }
     }
   return (l_lastorder);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ShowError(int error, string complement)
  {

   if(error == 1 || error == 130)
     {
      return;
     }

//string ErrorText=ErrorDescription(error);
// StringToUpper(ErrorText);
   Print(complement, ": Ordem: ", OrderTicket(), ". Falha ao tentar alterar ordem: ", error, " ");
   ResetLastError();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrailingAlls(int ai_0, int ai_4, double a_price_8, int MagicNumber)
  {
   int li_16;

   double m_pip = 1.0 / MathPow(10, Digits - 1);
   if(Digits == 3 || Digits == 5)
      m_pip = 1.0 / MathPow(10, Digits - 1);
   else
      m_pip = Point;

   double l_ord_stoploss_20;
   double l_price_28;
   bool foo = false;
   if(ai_4 != 0)
     {
      for(int l_pos_36 = OrdersTotal() - 1; l_pos_36 >= 0; l_pos_36--)
        {
         if(OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
               continue;
            if(OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber)
              {
               if(OrderType() == OP_BUY)
                 {
                  li_16 = (int)NormalizeDouble((Bid - a_price_8) / Point, 0);
                  if(li_16 < (ai_0 * m_pip))
                     continue;
                  l_ord_stoploss_20 = OrderStopLoss();
                  l_price_28 = Bid - (ai_4 * m_pip);
                  l_price_28 = ValidStopLoss(OP_BUY, Bid, l_price_28);
                  if(l_ord_stoploss_20 == 0.0 || (l_ord_stoploss_20 != 0.0 && l_price_28 > l_ord_stoploss_20))
                    {
                     // Somente ajustar a ordem se ela estiver aberta
                     if(CanModify(OrderTicket()) && a_price_8 < l_price_28)
                       {
                        ResetLastError();
                        foo = OrderModify(OrderTicket(), a_price_8, l_price_28, OrderTakeProfit(), 0, Aqua);
                        if(!foo)
                          {
                           ShowError(GetLastError(), "Normal");
                          }
                       }
                    }
                 }
               if(OrderType() == OP_SELL)
                 {
                  li_16 = (int)NormalizeDouble((a_price_8 - Ask) / Point, 0);
                  if(li_16 < (ai_0 * m_pip))
                     continue;
                  l_ord_stoploss_20 = OrderStopLoss();
                  l_price_28 = Ask + (ai_4 * m_pip);
                  l_price_28 = ValidStopLoss(OP_SELL, Ask, l_price_28);
                  if(l_ord_stoploss_20 == 0.0 || (l_ord_stoploss_20 != 0.0 && l_price_28 < l_ord_stoploss_20))
                    {
                     // Somente ajustar a ordem se ela estiver aberta
                     if(CanModify(OrderTicket()) && a_price_8 > l_price_28)
                       {
                        ResetLastError();
                        foo = OrderModify(OrderTicket(), a_price_8, l_price_28, OrderTakeProfit(), 0, Red);
                        if(!foo)
                          {
                           ShowError(GetLastError(), "Normal");
                          }
                       }
                    }
                 }
              }
            Sleep(1000);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseThisSymbolAll(int vInpMagic)
  {
   bool foo = false;
   for(int l_pos_0 = OrdersTotal() - 1; l_pos_0 >= 0; l_pos_0--)
     {
      if(!OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() == Symbol())
        {
         if(OrderSymbol() == Symbol() && (OrderMagicNumber() == vInpMagic))
           {
            if(OrderType() == OP_BUY)
               foo = OrderClose(OrderTicket(), OrderLots(), Bid, SlipPage, Blue);

            if(OrderType() == OP_SELL)
               foo = OrderClose(OrderTicket(), OrderLots(), Ask, SlipPage, Red);
           }
         Sleep(1000);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseThisSymbolAll()
  {
   bool foo = false;
   for(int l_pos_0 = OrdersTotal() - 1; l_pos_0 >= 0; l_pos_0--)
     {
      if(!OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES))
        {
         continue;
        }
      if(OrderSymbol() == Symbol())
        {
         if(OrderSymbol() == Symbol() && (OrderMagicNumber() == InpMagic || OrderMagicNumber() == InpMagic2))
           {
            if(OrderType() == OP_BUY)
               foo = OrderClose(OrderTicket(), OrderLots(), Bid, SlipPage, Blue);

            if(OrderType() == OP_SELL)
               foo = OrderClose(OrderTicket(), OrderLots(), Ask, SlipPage, Red);
           }
         Sleep(1000);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllByType(ENUM_ORDER_TYPE ptype)
  {
   double price = 0;
   if(ptype == ORDER_TYPE_BUY)
      price = Ask;
   else
      price = Bid;

   for(int i = 0; i <  OrdersTotal(); i++)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() == Symbol())
         if(OrderMagicNumber() == InpMagic || OrderMagicNumber() == InpMagic2)
            if(OrderType() == ptype)
               if(!OrderClose(OrderTicket(), OrderLots(), Bid, SlipPage, Blue))
                  Print("Unable to close Order : ", OrderTicket());
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetNumberOfOrderByType(ENUM_ORDER_TYPE ptype)
  {
   int count = 0;
   for(int i = 0; i <  OrdersTotal(); i++)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() == Symbol())
         if(OrderMagicNumber() == InpMagic || OrderMagicNumber() == InpMagic2)
            if(OrderType() == ptype)
               count += 1;
     }
   return count;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CanModify(int ticket)
  {

   return OrdersTotal() > 0;
   /*
     if( OrderType() == OP_BUY || OrderType() == OP_SELL)
        return OrderCloseTime() == 0;

     return false;

     /*
     bool result = false;

     OrderSelect(ticket, SELECT_BY_TICKET
     for(int i=OrdersHistoryTotal()-1;i>=0;i--){
        if( !OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) ){ continue; }
        if(OrderTicket()==ticket){
           result=true;
           break;
        }
     }

     return result;
     */
  }
// Function to check if it is news time
/*void NewsHandling()
  {
   static int PrevMinute = -1;

   if(Minute() != PrevMinute)
     {
      PrevMinute = Minute();

      // Use this call to get ONLY impact of previous event
      int impactOfPrevEvent =
         (int)iCustom(NULL, 0, "FFCal", true, true, false, true, true, 2, 0);

      // Use this call to get ONLY impact of nexy event
      int impactOfNextEvent =
         (int)iCustom(NULL, 0, "FFCal", true, true, false, true, true, 2, 1);

      int minutesSincePrevEvent =
         (int)iCustom(NULL, 0, "FFCal", true, true, false, true, false, 1, 0);

      int minutesUntilNextEvent =
         (int)iCustom(NULL, 0, "FFCal", true, true, false, true, false, 1, 1);

      m_news_time = false;
      if((minutesUntilNextEvent <= InpMinsBeforeNews) ||
         (minutesSincePrevEvent <= InpMinsAfterNews))
        {
         m_news_time = true;
        }
     }
  } //newshandling*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllTicket(int aType, int ticket, int MagicN)
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
      if(OrderSelect(i, SELECT_BY_POS))
         if(OrderSymbol() == Symbol())
            if(OrderMagicNumber() == MagicN)
              {
               if(OrderType() == aType && OrderType() == OP_BUY)
                  if(OrderProfit() > 0 || OrderTicket() == ticket)
                     if(!OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits()), SlipPage, clrRed))
                        Print(" OrderClose OP_BUY Error N", GetLastError());

               if(OrderType() == aType && OrderType() == OP_SELL)
                  if(OrderProfit() > 0 || OrderTicket() == ticket)
                     if(!OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits()), SlipPage, clrRed))
                        Print(" OrderClose OP_SELL Error N", GetLastError());
              }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawRects(int xPos, int yPos, color clr, int width = 150, int height = 17, string Texto = "")
  {

   string id = "_l" + Texto;

   ObjectDelete(0, id);

   ObjectCreate(0, id, OBJ_BUTTON, 0, 100, 100);
   ObjectSetInteger(0, id, OBJPROP_XDISTANCE, xPos);
   ObjectSetInteger(0, id, OBJPROP_YDISTANCE, yPos);
   ObjectSetInteger(0, id, OBJPROP_BGCOLOR, clr);
   ObjectSetInteger(0, id, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, id, OBJPROP_XSIZE, 150);
   ObjectSetInteger(0, id, OBJPROP_YSIZE, 35);

   ObjectSetInteger(0, id, OBJPROP_WIDTH, 0);
   ObjectSetString(0, id, OBJPROP_FONT, "Arial");
   ObjectSetString(0, id, OBJPROP_TEXT, Texto);
   ObjectSetInteger(0, id, OBJPROP_SELECTABLE, 0);

   ObjectSetInteger(0, id, OBJPROP_BACK, 0);
   ObjectSetInteger(0, id, OBJPROP_SELECTED, 0);
   ObjectSetInteger(0, id, OBJPROP_HIDDEN, 1);
   ObjectSetInteger(0, id, OBJPROP_ZORDER, 1);

   ObjectSetInteger(0, id, OBJPROP_STATE, false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetHLine(color vColorSetHLine, string vNomeSetHLine = "", double vBidSetHLine = 0.0, int vStyleSetHLine = 0, int vTamanhoSetHLine = 1)
  {
   if(vNomeSetHLine == "")
      vNomeSetHLine = DoubleToStr(Time[0], 0);
   if(vBidSetHLine <= 0.0)
      vBidSetHLine = Bid;
   if(ObjectFind(vNomeSetHLine) < 0)
      ObjectCreate(vNomeSetHLine, OBJ_HLINE, 0, 0, 0);
   ObjectSet(vNomeSetHLine, OBJPROP_PRICE1, vBidSetHLine);
   ObjectSet(vNomeSetHLine, OBJPROP_COLOR, vColorSetHLine);
   ObjectSet(vNomeSetHLine, OBJPROP_STYLE, vStyleSetHLine);
   ObjectSet(vNomeSetHLine, OBJPROP_WIDTH, vTamanhoSetHLine);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ValidStopLoss(int type, double price, double SL)
  {

   double mySL;
   double minstop;

   minstop = MarketInfo(Symbol(), MODE_STOPLEVEL);
   if(Digits == 3 || Digits == 5)
      minstop = minstop / 10;

   mySL = SL;
   if(type == OP_BUY)
     {
      if((price - mySL) < minstop * Point)
         // mySL = price - minstop * Point;
         mySL = 0;
     }
   if(type == OP_SELL)
     {
      if((mySL - price) < minstop * Point)
         //mySL = price + minstop * Point;
         mySL = 0;
     }

   return (NormalizeDouble(mySL, (int)MarketInfo(Symbol(), MODE_DIGITS)));
  }
/*
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{

  //sparam: Name of the graphical object, on which the event occurred

  // did user click on the chart ?
  if (id == CHARTEVENT_OBJECT_CLICK)
  {
    // and did he click on on of our objects
    if (StringSubstr(sparam, 0, 2) == "_l")
    {

      // did user click on the name of a pair ?
      int len = StringLen(sparam);
      // Alert(sparam);
      //
      if (StringSubstr(sparam, len - 3, 3) == "BUY" || StringSubstr(sparam, len - 3, 3) == "ELL")
      {
        if (InpManualInitGrid)
        {

          //Aciona 1ª Ordem do Grid
          if (StringSubstr(sparam, len - 3, 3) == "sBUY" && !(m_orders_count1 > 0 || !InpEnableEngineA))
          {
            //BUY
            ronin("A", 1, 0, InpMagic, m_orders_count1, m_mediaprice1, m_hedging1, m_target_filter1,
                  m_direction1, m_current_day1, m_previous_day1, m_level1, m_buyer1, m_seller1,
                  m_target1, m_profit1, m_pip1, m_size1, m_take1, m_datetime_ultcandleopen1,
                  m_time_equityrisk1);
            //  Alert("BUY");
          }
          if (StringSubstr(sparam, len - 3, 3) == "sELL" && !(m_orders_count2 > 0 || !InpEnableEngineA))
          {
            //SELL
            ronin("B", -1, 0, InpMagic2, m_orders_count2, m_mediaprice2, m_hedging2,
                  m_target_filter2, m_direction2, m_current_day2, m_previous_day2,
                  m_level2, m_buyer2, m_seller2, m_target2, m_profit2, m_pip2,
                  m_size2, m_take2, m_datetime_ultcandleopen2,
                  m_time_equityrisk2);
            //  Alert("SELL");
          }
        }
      }
    }
  }
} */
//-----------------------------------------------
int DivSinalHILO()
  {
   if(!EnableSinalHILO)
      return (0);
   else
      return (1);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetSinalHILO()
  {
   int vRet = 0;

   if(!EnableSinalHILO)
      vRet = 0;

   indicator_low = iMA(NULL, InpHILOFrame, InpHILOPeriod, 0, InpHILOMethod, PRICE_LOW, InpHILOShift);
   indicator_high = iMA(NULL, InpHILOFrame, InpHILOPeriod, 0, InpHILOMethod, PRICE_HIGH, InpHILOShift);

   diff_highlow = indicator_high - indicator_low;
   isbidgreaterthanima = Bid >= indicator_low + diff_highlow / 2.0;

   if(Bid < indicator_low)
      vRet = -1;
   else
      if(Bid > indicator_high)
         vRet = 1;

   if(InpHILOFilterInverter)
      vRet = vRet * -1;

   return vRet;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ToStr(double ad_0, int ai_8)
  {
   return (DoubleToStr(ad_0, ai_8));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BreakEvenAlls(int ai_0, int ai_4, double MediaPrice, int MagicNumber)
  {
   int PipsDiffMedia;

   double m_pip = 1.0 / MathPow(10, Digits - 1);
   if(Digits == 3 || Digits == 5)
      m_pip = 1.0 / MathPow(10, Digits - 1);
   else
      m_pip = Point;

   double l_ord_stoploss_20;
   double l_price_28;
   bool foo = false;
   if(ai_0 != 0)
     {
      for(int l_pos_36 = OrdersTotal() - 1; l_pos_36 >= 0; l_pos_36--)
        {
         if(OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
               continue;
            if(OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber)
              {
               if(OrderType() == OP_BUY)
                 {
                  PipsDiffMedia = (int)NormalizeDouble((Bid - MediaPrice) / Point, 0);
                  // Comment(PipsDiffMedia);
                  if(PipsDiffMedia <= (ai_0 * m_pip))
                     continue;
                  l_ord_stoploss_20 = OrderStopLoss();
                  l_price_28 = MediaPrice + (ai_4 * m_pip);
                  l_price_28 = ValidStopLoss(OP_BUY, Bid, l_price_28);
                  if(Bid >= (MediaPrice + (ai_4 * m_pip)) && (l_ord_stoploss_20 == 0.0 || (l_ord_stoploss_20 != 0.0 && l_price_28 > l_ord_stoploss_20)))
                    {
                     // Somente ajustar a ordem se ela estiver aberta
                     if(CanModify(OrderTicket()))
                       {
                        ResetLastError();
                        foo = OrderModify(OrderTicket(), MediaPrice, l_price_28, OrderTakeProfit(), 0, Aqua);
                        if(!foo)
                          {
                           ShowError(GetLastError(), "Normal");
                          }
                       }
                    }
                 }
               if(OrderType() == OP_SELL)
                 {
                  PipsDiffMedia = (int)NormalizeDouble((MediaPrice - Ask) / Point, 0);
                  if(PipsDiffMedia <= (ai_0 * m_pip))
                     continue;
                  l_ord_stoploss_20 = OrderStopLoss();
                  l_price_28 = MediaPrice - (ai_4 * m_pip);
                  l_price_28 = ValidStopLoss(OP_SELL, Ask, l_price_28);
                  if(Ask <= (MediaPrice - (ai_4 * m_pip)) && (l_ord_stoploss_20 == 0.0 || (l_ord_stoploss_20 != 0.0 && l_price_28 < l_ord_stoploss_20)))
                    {
                     // Somente ajustar a ordem se ela estiver aberta
                     if(CanModify(OrderTicket()))
                       {
                        ResetLastError();
                        foo = OrderModify(OrderTicket(), MediaPrice, l_price_28, OrderTakeProfit(), 0, Red);
                        if(!foo)
                          {
                           ShowError(GetLastError(), "Normal");
                          }
                       }
                    }
                 }
              }
            Sleep(1000);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalcLot(int TypeLot, int TypeOrder, int vQtdTrades, double LastLot, double StartLot, double GridFactor, int GridStepLot)
  {
   double rezult = 0;
   switch(TypeLot)
     {
      case 0: // Standart lot
         if(TypeOrder == OP_BUY || TypeOrder == OP_SELL)
            rezult = StartLot;
         break;

      case 1: // Summ lot
         rezult = StartLot * vQtdTrades;

         break;

      case 2: // Martingale lot
         // rezult = StartLot * MathPow(GridFactor, vQtdTrades);
         rezult = MathRound(StartLot * MathPow(InpGridFactor, vQtdTrades), SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP));
         break;

      case 3: // Step lot
         if(vQtdTrades == 0)
            rezult = StartLot;
         if(vQtdTrades % GridStepLot == 0)
            rezult = LastLot + StartLot;
         else
            rezult = LastLot;

         break;
     }
   return rezult;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FindFirstOrderTicket(int magic, string Symb, int Type, int QtdProfit, int &tickets[])
  {
   int Ticket = 0;
   double profit = 0;
   datetime EarliestOrder = D'2099/12/31';
   int c = 0;
   double ordprofit[100];
   ArrayInitialize(ordprofit, 0);
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderType() == Type && OrderSymbol() == Symb && OrderMagicNumber() == magic)
           {
            if(EarliestOrder > OrderOpenTime())
              {
               EarliestOrder = OrderOpenTime();
               Ticket = OrderTicket();
               profit = OrderProfit() + OrderCommission() + OrderSwap();
               if(profit < 0)
                 {
                  tickets[c] = Ticket;
                  ordprofit[c] = profit;
                  c++;
                 }
              }
           }
        }
     }

   for(int i = 0; i < QtdProfit; i++)
     {
      profit += ordprofit[i];
     }

   return profit; // Returns 0 if no matching orders
  }
//+------------------------------------------------------------------+
//| Create rectangle label                                           |
//+------------------------------------------------------------------+
bool RectLabelCreate(const long             chart_ID = 0,             // chart's ID
                     const string           name = "RectLabel",       // label name
                     const int              sub_window = 0,           // subwindow index
                     const int              x = 0,                    // X coordinate
                     const int              y = 0,                    // Y coordinate
                     const int              width = 580,               // width
                     const int              height = 350,              // height
                     const color            back_clr = C'69,69,69', // background color
                     const ENUM_BORDER_TYPE border = BORDER_FLAT,   // border type
                     const ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                     const color            clr = C'0, 190, 255',             // flat border color (Flat)
                     const ENUM_LINE_STYLE  style = STYLE_SOLID,      // flat border style
                     const int              line_width = 5,           // flat border width
                     const bool             back = false,             // in the background
                     const bool             selection = false,        // highlight to move
                     const bool             hidden = true,            // hidden in the object list
                     const long             z_order = 0)              // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a rectangle label
   if(!ObjectCreate(chart_ID, name, OBJ_RECTANGLE_LABEL, sub_window, 0, 0))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle label! Error code = ", GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
//--- set label size
   ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
//--- set background color
   ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
//--- set border type
   ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_TYPE, border);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set flat border line style
   ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
//--- set flat border width
   ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, line_width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete the rectangle label                                       |
//+------------------------------------------------------------------+
bool RectLabelDelete(const long   chart_ID = 0,     // chart's ID
                     const string name = "RectLabel") // label name
  {
//--- reset the error value
   ResetLastError();
//--- delete the label
   if(ObjectFind(0, name) != -1)
     {
      if(!ObjectDelete(chart_ID, name))
        {
         Print(__FUNCTION__,
               ": failed to delete a rectangle label! Error code = ", GetLastError());
         return(false);
        }
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change the size of the rectangle label                           |
//+------------------------------------------------------------------+
bool RectLabelChangeSize(const long   chart_ID = 0,     // chart's ID
                         const string name = "RectLabel", // label name
                         const int    width = 50,       // label width
                         const int    height = 18)      // label height
  {
//--- reset the error value
   ResetLastError();
//--- change label size
   if(!ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width))
     {
      Print(__FUNCTION__,
            ": failed to change the label's width! Error code = ", GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height))
     {
      Print(__FUNCTION__,
            ": failed to change the label's height! Error code = ", GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|BITMAP CREATE                                                     |
//+------------------------------------------------------------------+
bool BitmapLabelCreate(const long              chart_ID = 0,             // chart's ID
                       const string            name = "BmpLabel",        // label name
                       const int               sub_window = 0,           // subwindow index
                       const int               x = 50,                    // X coordinate
                       const int               y = 50,                    // Y coordinate
                       const string            file_on = "\\Images\\main_logo.bmp",             // image in On mode
                       const string            file_off = "\\Images\\main_logo.bmp",            // image in Off mode
                       const int               width = 250,                // visibility scope X coordinate
                       const int               height = 250,               // visibility scope Y coordinate
                       const int               x_offset = 0,            // visibility scope shift by X axis
                       const int               y_offset = 0,            // visibility scope shift by Y axis
                       const bool              state = false,            // pressed/released
                       const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                       const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // anchor type
                       const color             clr = clrRed,             // border color when highlighted
                       const ENUM_LINE_STYLE   style = STYLE_SOLID,      // line style when highlighted
                       const int               point_width = 1,          // move point size
                       const bool              back = false,             // in the background
                       const bool              selection = false,        // highlight to move
                       const bool              hidden = true,            // hidden in the object list
                       const long              z_order = 0)              // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a bitmap label
   if(!ObjectCreate(chart_ID, name, OBJ_BITMAP_LABEL, sub_window, 0, 0))
     {
      Print(__FUNCTION__,
            ": failed to create \"Bitmap Label\" object! Error code = ", GetLastError());
      return(false);
     }
//--- set the images for On and Off modes
   if(!ObjectSetString(chart_ID, name, OBJPROP_BMPFILE, 0, file_on))
     {
      Print(__FUNCTION__,
            ": failed to load the image for On mode! Error code = ", GetLastError());
      return(false);
     }
   if(!ObjectSetString(chart_ID, name, OBJPROP_BMPFILE, 1, file_off))
     {
      Print(__FUNCTION__,
            ": failed to load the image for Off mode! Error code = ", GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
//--- set visibility scope for the image; if width or height values
//--- exceed the width and height (respectively) of a source image,
//--- it is not drawn; in the opposite case,
//--- only the part corresponding to these values is drawn
   ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
//--- set the part of an image that is to be displayed in the visibility scope
//--- the default part is the upper left area of an image; the values allow
//--- performing a shift from this area displaying another part of the image
   ObjectSetInteger(chart_ID, name, OBJPROP_XOFFSET, x_offset);
   ObjectSetInteger(chart_ID, name, OBJPROP_YOFFSET, y_offset);
//--- define the label's status (pressed or released)
   ObjectSetInteger(chart_ID, name, OBJPROP_STATE, state);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set anchor type
   ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor);
//--- set the border color when object highlighting mode is enabled
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set the border line style when object highlighting mode is enabled
   ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
//--- set a size of the anchor point for moving an object
   ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, point_width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move Bitmap Label object                                         |
//+------------------------------------------------------------------+
bool BitmapLabelMove(const long   chart_ID = 0,    // chart's ID
                     const string name = "BmpLabel", // label name
                     const int    x = 0,           // X coordinate
                     const int    y = 0)           // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the object
   if(!ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the object! Error code = ", GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the object! Error code = ", GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|BITMAP DELETE                                                     |
//+------------------------------------------------------------------+
bool BitmapLabelDelete(const long   chart_ID = 0,    // chart's ID
                       const string name = "BmpLabel") // label name
  {
//--- reset the error value
   ResetLastError();
//--- delete the label
   if(ObjectFind(0, name) != -1)
     {
      if(!ObjectDelete(chart_ID, name))
        {
         Print(__FUNCTION__,
               ": failed to delete \"Bitmap label\" object! Error code = ", GetLastError());
         return(false);
        }
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|LABEL CREATE                                                      |
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID = 0,             // chart's ID
                 const string            name = "Label",           // label name
                 const int               sub_window = 0,           // subwindow index
                 const int               x = 0,                    // X coordinate
                 const int               y = 0,                    // Y coordinate
                 const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string            text = "Label",           // text
                 const string            font = "Ninja Rush",           // font
                 const int               font_size = 10,           // font size
                 const color             clr = clrRed,             // color
                 const double            angle = 0.0,              // text slope
                 const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // anchor type
                 const bool              back = false,             // in the background
                 const bool              selection = false,        // highlight to move
                 const bool              hidden = true,            // hidden in the object list
                 const long              z_order = 0)              // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a text label
   if(!ObjectCreate(chart_ID, name, OBJ_LABEL, sub_window, 0, 0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ", GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set the text
   ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
//--- set text font
   ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
//--- set font size
   ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID, name, OBJPROP_ANGLE, angle);
//--- set anchor type
   ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor);
//--- set color
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|CHANGE TEXT LABEL                                                 |
//+------------------------------------------------------------------+
bool LabelTextChange(const long   chart_ID = 0, // chart's ID
                     const string name = "Label", // object name
                     const string text = "Text") // text
  {
//--- reset the error value
   ResetLastError();
//--- change object text
   if(!ObjectSetString(chart_ID, name, OBJPROP_TEXT, text))
     {
      Print(__FUNCTION__,
            ": failed to change the text! Error code = ", GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|LABEL DELETE                                                      |
//+------------------------------------------------------------------+
bool LabelDelete(const long   chart_ID = 0, // chart's ID
                 const string name = "Label") // label name
  {
//--- reset the error value
   ResetLastError();
//--- delete the label
   if(ObjectFind(0, name) != -1)
     {
      if(!ObjectDelete(chart_ID, name))
        {
         Print(__FUNCTION__,
               ": failed to delete a text label! Error code = ", GetLastError());
         return(false);
        }
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|BUTTON CREATE                                                     |
//+------------------------------------------------------------------+
bool Create_Button(const long              chart_ID = 0,             // chart's ID
                   const string            name = "Button",    // button name
                   const int               sub_window = 0,           // subwindow index
                   const int               x = 250, // X coordinate
                   const int               y = 20, // Y coordinate
                   const int               width = 100,               // button width
                   const int               height = 20,              // button height
                   const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                   const string            text = "Close All",           // text
                   const string            font = "Courier New",     // font
                   const int               font_size = 10,           // font size
                   const color             clr = clrBlack,           // text color
                   const color             back_clr = C'71,71,71',       // background color
                   const bool              back = false              // in the background
                  )
  {
//--- reset the error value
   ResetLastError();
//--- create the button
   ObjectCreate(chart_ID, name, OBJ_BUTTON, sub_window, 0, 0);
   ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
   ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
   ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
   ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|BUTTON DELETE                                                     |
//+------------------------------------------------------------------+
bool ButtonDelete(const long   chart_ID = 0,  // chart's ID
                  const string name = "Button") // button name
  {
//--- reset the error value
   ResetLastError();
//--- delete the button
   if(ObjectFind(0, name) != -1)
     {
      if(!ObjectDelete(chart_ID, name))
        {
         Print(__FUNCTION__,
               ": failed to delete the button! Error code = ", GetLastError());
         return(false);
        }
     }
//--- successful execution
   return(true);
  }

//-----------------------------------------------------------------------+
#import "wininet.dll"
int InternetAttemptConnect(int x);
int InternetOpenW(string sAgent, int lAccessType, string sProxyName = "", string sProxyBypass = "", int lFlags = 0);
int InternetOpenUrlW(int hInternetSession, string sUrl, string sHeaders = "", int lHeadersLength = 0, int lFlags = 0, int lContext = 0);
int InternetReadFile(int hFile, uchar &sBuffer[], int lNumBytesToRead, int &lNumberOfBytesRead[]);
int HttpQueryInfoW(int hRequest, int dwInfoLevel, uchar &lpvBuffer[], int &lpdwBufferLength, int &lpdwIndex);
int InternetCloseHandle(int hInet);
#import

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ReadWebNews(string addr, string filename)
  {
   bool result = false;
   string browser = "Microsoft Internet Explorer";

   int rv = InternetAttemptConnect(0);
   if(rv != 0)
     {
      Print("InternetAttemptConnect() error");
      return(false);
     }

   int hInternetSession = InternetOpenW(browser, 0, "", "", 0);
   if(hInternetSession <= 0)
     {
      Print("InternetOpenW() error");
      return(false);
     }

   int hURL = InternetOpenUrlW(hInternetSession, addr, "", 0, 0, 0);
   if(hURL <= 0)
     {
      Print("InternetOpenUrlW() error");
      InternetCloseHandle(hInternetSession);
      return(false);
     }

   int dwBytesRead[1];
   bool flagret = true;
   uchar buffer[1024];
   int cnt = 0;

   int h = FileOpen(filename, FILE_BIN | FILE_WRITE | FILE_SHARE_WRITE);
   if(h == INVALID_HANDLE)
     {
      Print("FileOpen() error, filename ", filename, " error ", GetLastError());
      InternetCloseHandle(hInternetSession);
      return(false);
     }

   while(!IsStopped())
     {
      bool bResult = InternetReadFile(hURL, buffer, 1024, dwBytesRead);
      cnt += dwBytesRead[0];
      if(dwBytesRead[0] == 0)
         break;
      FileWriteArray(h, buffer, 0, dwBytesRead[0]);
     }

   if(h > 0)
      FileClose(h);

   InternetCloseHandle(hInternetSession);

   if(cnt > 0)
     {
      string temp_string;
      int handle = FileOpen(filename, FILE_CSV | FILE_READ | FILE_SHARE_READ);
      if(handle == INVALID_HANDLE)
        {
         Print("File read error: ", GetLastError());
         return(false);
        }

      ArrayFree(news);

      while(!FileIsEnding(handle))
        {
         temp_string = FileReadString(handle);

         if(StringFind(temp_string, "Title") >= 0)
            continue;

         string split_res[];
         if(StringSplit(temp_string, ',', split_res) > 4)
           {
            int as = ArraySize(news);
            ArrayResize(news, as + 1);
            news[as].title = split_res[0];
            news[as].time = ParseTime(split_res[2], split_res[3]) + NewsGMTOffset * PERIOD_H1 * 60;
            news[as].country = split_res[1];
            news[as].impact = split_res[4];
            StringToUpper(news[as].impact);
           }
        }

      FileClose(handle);
      result = true;
     }

   return(result);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ReadBacktestNews(string addr, string filename)
  {
   bool result = false;
   string browser = "Microsoft Internet Explorer";

   int rv = InternetAttemptConnect(0);
   if(rv != 0)
     {
      Print("InternetAttemptConnect() error");
      return(false);
     }

   int hInternetSession = InternetOpenW(browser, 0, "", "", 0);
   if(hInternetSession <= 0)
     {
      Print("InternetOpenW() error");
      return(false);
     }

   int hURL = InternetOpenUrlW(hInternetSession, addr, "", 0, 0, 0);
   if(hURL <= 0)
     {
      Print("InternetOpenUrlW() error");
      InternetCloseHandle(hInternetSession);
      return(false);
     }

   int dwBytesRead[1];
   bool flagret = true;
   uchar buffer[1024];
   int cnt = 0;

   int h = FileOpen(filename, FILE_BIN | FILE_WRITE | FILE_SHARE_WRITE);
   if(h == INVALID_HANDLE)
     {
      Print("FileOpen() error, filename ", filename, " error ", GetLastError());
      InternetCloseHandle(hInternetSession);
      return(false);
     }

   while(!IsStopped())
     {
      bool bResult = InternetReadFile(hURL, buffer, 1024, dwBytesRead);
      cnt += dwBytesRead[0];
      if(dwBytesRead[0] == 0)
         break;
      FileWriteArray(h, buffer, 0, dwBytesRead[0]);
     }

   if(h > 0)
      FileClose(h);

   InternetCloseHandle(hInternetSession);

   if(cnt > 0)
     {
      string temp_string;
      int handle = FileOpen(filename, FILE_CSV | FILE_READ | FILE_SHARE_READ);
      if(handle == INVALID_HANDLE)
        {
         Print("File read error: ", GetLastError());
         return(false);
        }

      ArrayFree(news);

      while(!FileIsEnding(handle))
        {
         temp_string = FileReadString(handle);

         if(StringFind(temp_string, "Title") >= 0)
            continue;

         string split_res[];
         if(StringSplit(temp_string, ',', split_res) > 4)
           {
            datetime dtime = ParseTimeForBacktest(split_res[2], split_res[3]) + NewsGMTOffset * PERIOD_H1 * 60;

            if(dtime < TimeCurrent())
               continue;
            //Alert(dtime);
            int as = ArraySize(news);
            ArrayResize(news, as + 1);
            news[as].title = split_res[0];
            news[as].time = dtime;
            news[as].country = split_res[1];
            news[as].impact = split_res[4];
            StringToUpper(news[as].impact);
           }
        }

      FileClose(handle);
      result = true;
     }

   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisplayBacktestNews()
  {
   if(DisplayBacktestCalendar)
     {
      string calendar = "news: \n";
      for(int i = 0; i < ArraySize(news); i++)
        {
         if(!CheckNewsRegion(news[i].country))
            continue;
         if(!HighImpact && news[i].impact == "HIGH")
            continue;
         if(!MediumImpact && news[i].impact == "MEDIUM")
            continue;
         if(!LowImpact && news[i].impact == "LOW")
            continue;
         if(news[i].impact == "NONE")
            continue;
         if(news[i].impact == "HOLIDAY")
            continue;

         string news_line = StringConcatenate(news[i].time, " : ", news[i].country, " : ", news[i].impact, " : ", news[i].title);
         calendar += news_line + "\n";

         DrawVLine("news_" + IntegerToString((int)news[i].time), news_line, news[i].time, clrAqua, STYLE_DASHDOT, 1);

        }
      Comment("\n" + "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n",  "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n",
              "\n", "\n", calendar);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetForexFactoryCalendar(string url)
  {
   if(ReadWebNews(url, "ffc.csv"))
     {
      if(DisplayCalendar)
        {
         string calendar = "news: \n";
         for(int i = 0; i < ArraySize(news); i++)
           {
            if(!CheckNewsRegion(news[i].country))
               continue;
            if(!HighImpact && news[i].impact == "HIGH")
               continue;
            if(!MediumImpact && news[i].impact == "MEDIUM")
               continue;
            if(!LowImpact && news[i].impact == "LOW")
               continue;
            if(news[i].impact == "HOLIDAY")
               continue;

            string news_line = StringConcatenate(news[i].time, " : ", news[i].country, " : ", news[i].impact, " : ", news[i].title);
            calendar += news_line + "\n";

            DrawVLine("news_" + IntegerToString((int)news[i].time), news_line, news[i].time, clrAqua, STYLE_DASHDOT, 1);
           }
         Comment("\n" + "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n",  "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n",
                 "\n", "\n", calendar);
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime ParseTimeForBacktest(string date, string time)
  {
   string split_res[];
   if(StringSplit(date, '/', split_res) > 2)
      date = StringConcatenate(split_res[2], ".", split_res[0], ".", split_res[1]);

   datetime result = StringToTime(date + " " + time);
   if(StringFind(time, "pm") > 0 && StringFind(time, "12") != 0)
      result += 12 * PERIOD_H1 * 60;

   return(result);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime ParseTime(string date, string time)
  {
   string split_res[];
   if(StringSplit(date, '-', split_res) > 2)
      date = StringConcatenate(split_res[2], ".", split_res[0], ".", split_res[1]);

   datetime result = StringToTime(date + " " + time);
   if(StringFind(time, "pm") > 0 && StringFind(time, "12") != 0)
      result += 12 * PERIOD_H1 * 60;

   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckNewsFilter()
  {
   if(!IsTesting())
     {
      for(int i = 0; i < ArraySize(news); i++)
        {
         if(!CheckNewsRegion(news[i].country))
            continue;
         if(!HighImpact && news[i].impact == "HIGH")
            continue;
         if(!MediumImpact && news[i].impact == "MEDIUM")
            continue;
         if(!LowImpact && news[i].impact == "LOW")
            continue;
         if(news[i].impact == "HOLIDAY")
            continue;

         if(TimeCurrent() >= news[i].time - NewsFilterStopBefore * 60 && TimeCurrent() < news[i].time + NewsFilterResumeAfter * 60)
            return(false);
        }
     }
   else
     {
      for(int i = LastNewsIndex; i < ArraySize(news); i++)
        {
         if(!CheckNewsRegion(news[i].country))
            continue;
         if(!HighImpact && news[i].impact == "HIGH")
            continue;
         if(!MediumImpact && news[i].impact == "MEDIUM")
            continue;
         if(!LowImpact && news[i].impact == "LOW")
            continue;
         if(news[i].impact == "HOLIDAY")
            continue;

         if(TimeCurrent() >= news[i].time - NewsFilterStopBefore * 60 && TimeCurrent() < news[i].time + NewsFilterResumeAfter * 60)
           {
            LastNewsIndex = i;
            Alert("Avoid news "+(string)news[i].time+" "+news[i].title);
            return(false);
           }
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckNewsRegion(string country)
  {
   if(!SymbolRelatedNews)
      return(true);

   if(StringFind(_Symbol, country) >= 0)
      return(true);

   if(StringLen(NewsRegion) > 0)
     {
      string split_res[];
      if(StringSplit(NewsRegion, ',', split_res) > 0)
        {
         for(int i = 0; i < ArraySize(split_res); i++)
           {
            if(country == split_res[i])
               return(true);
           }
        }
     }

   if(NewsFilterSource == EnergyExch || NewsFilterSource == MetalsMine)
      return(true);

   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawVLine(string name, string descr, datetime time, color clr, ENUM_LINE_STYLE style = STYLE_DASHDOT, int width = 1)
  {
   name = obj_prefix + name;

   ObjectCreate(0, name, OBJ_VLINE, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_TIME, time);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_STYLE, style);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetString(0, name, OBJPROP_TEXT, descr);
  }
//-----------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|CLOSE ALL POSITIONS IN PROFIT                                    |
//+------------------------------------------------------------------+
void Close_Profit_Order()
  {
   bool flag_profit = false;
   if(OrdersTotal() == 0)
     {
      Alert("No opened order to close.");
      return;
     }
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         if(OrderType() == OP_BUY)
           {
            //-------------------------------------------------------------------------------------------------
            double profit = OrderProfit() + OrderCommission() + OrderSwap();
            double bid = SymbolInfoDouble(OrderSymbol(), SYMBOL_BID);
            if(profit > 0)
              {
               double CloseBuy = OrderClose(OrderTicket(), OrderLots(), bid, 0);
               flag_profit = true;
              }
            //-------------------------------------------------------------------------------------------------
           }
      if(OrderType() == OP_SELL)
        {
         //-------------------------------------------------------------------------------------------------
         double profit = OrderProfit() + OrderCommission() + OrderSwap();
         double ask = SymbolInfoDouble(OrderSymbol(), SYMBOL_ASK);
         if(profit > 0)
           {
            double CloseSell = OrderClose(OrderTicket(), OrderLots(), ask, 0);
            flag_profit = true;
           }
         //-------------------------------------------------------------------------------------------------
        }
     }
   if(flag_profit == false)
     {
      Alert("No orders with profit to close.");
     }
   else
     {
      Alert("All orders with profit sucessfully closed.");
     }
  }
//+------------------------------------------------------------------+
//|CLOSE ALL POSITIONS IN LOSS                                       |
//+------------------------------------------------------------------+
void Close_Loss_Order()
  {
   bool flag_Loss = false;
   if(OrdersTotal() == 0)
     {
      Alert("No opened order to close.");
      return;
     }
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         if(OrderType() == OP_BUY)
           {
            //-------------------------------------------------------------------------------------------------
            double profit = OrderProfit() + OrderCommission() + OrderSwap();
            double bid = SymbolInfoDouble(OrderSymbol(), SYMBOL_BID);
            if(profit < 0)
              {
               double CloseBuy = OrderClose(OrderTicket(), OrderLots(), bid, 0);
               flag_Loss = true;
              }
            //-------------------------------------------------------------------------------------------------
           }
      if(OrderType() == OP_SELL)
        {
         //-------------------------------------------------------------------------------------------------
         double profit = OrderProfit() + OrderCommission() + OrderSwap();
         double ask = SymbolInfoDouble(OrderSymbol(), SYMBOL_ASK);
         if(profit < 0)
           {
            double CloseSell = OrderClose(OrderTicket(), OrderLots(), ask, 0);
            flag_Loss = true;
           }
         //-------------------------------------------------------------------------------------------------
        }
     }
   if(flag_Loss == false)
     {
      Alert("No orders with loss to close.");
     }
   else
     {
      Alert("All orders with loss sucessfully closed.");
     }
  }
//+------------------------------------------------------------------+
//|CLOSE ALL OPENED POSITIONS                                        |
//+------------------------------------------------------------------+
void Close_All_Order()
  {
   for(int i = (OrdersTotal() - 1); i >= 0; i--)
     {
      // If the order cannot be selected, throw and log an error.
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false)
         break;

      bool res = false;

      // Allowed Slippage - the difference between current price and close price.
      int Slippage = 100;

      // Bid and Ask prices for the instrument of the order.
      double BidPrice = MarketInfo(OrderSymbol(), MODE_BID);
      double AskPrice = MarketInfo(OrderSymbol(), MODE_ASK);

      // Closing the order using the correct price depending on the type of order.
      if(OrderType() == OP_BUY)
        {
         res = OrderClose(OrderTicket(), OrderLots(), BidPrice, Slippage);
        }
      else
         if(OrderType() == OP_SELL)
           {
            res = OrderClose(OrderTicket(), OrderLots(), AskPrice, Slippage);
           }

      // If there was an error, log it.
      if(res == false)
         Print("ERROR - Unable to close the order - ", OrderTicket(), " - ", GetLastError());
     }
  }
//+------------------------------------------------------------------+
//|ROUND A STRING TO 2 DIGITS                                        |
//+------------------------------------------------------------------+
string RoundToNearest(string number_to_round)
  {
   string numbers[];
   if(StringFind(number_to_round, ".") != -1)
     {
      ushort u_sep = StringGetCharacter(".", 0);
      StringSplit(number_to_round, u_sep, numbers);
      string sub_decimals = StringSubstr(numbers[1], 0, 2);
      number_to_round = numbers[0] + "." + sub_decimals;
     }
   return number_to_round;
  }
//+------------------------------------------------------------------+
//|INITIALIZE THE SETTINGS TO PRINT IN TERMINAL                      |
//+------------------------------------------------------------------+
void Settings_Initialize()
  {
   if(TypeGridLot == 0)
     {
      LM = "Fixed start";
     }
   if(TypeGridLot == 1)
     {
      LM = "Summ Start Lot";
     }
   if(TypeGridLot == 2)
     {
      LM = "Martingale Lot";
     }
   if(TypeGridLot == 3)
     {
      LM = "Step Lot";
     }
   if(InpDailyTarget != 0)
     {
      DT = (string)InpDailyTarget + " $";
     }
   else
     {
      DT = "OFF";
     }
   if(InpUseEquityStop == true)
     {
      ES = (string)InpTotalEquityRisk + " %";
     }
   else
     {
      ES = "OFF";
     }
   if(InpUseTrailingStop == true)
     {
      TLS = "ON";
     }
   else
     {
      TLS = "OFF";
     }
   if(InpUtilizeTimeFilter == true)
     {
      BWT = "ON";
     }
   else
     {
      BWT = "OFF";
     }
   if(InpTrade_in_Monday == true)
     {
      monday = "Mon";
     }
   else
     {
      monday = "";
     }
   if(InpTrade_in_Tuesday == true)
     {
      tuesday = "Tues";
     }
   else
     {
      tuesday = "";
     }
   if(InpTrade_in_Wednesday == true)
     {
      wednesday = "Wed";
     }
   else
     {
      wednesday = "";
     }
   if(InpTrade_in_Thursday == true)
     {
      thursday = "Thur";
     }
   else
     {
      thursday = "";
     }
   if(InpTrade_in_Friday == true)
     {
      friday = "Fri";
     }
   else
     {
      friday = "";
     }
  }
//+------------------------------------------------------------------+
//|CREATE THE DESIGNED WINDOW                                        |
//+------------------------------------------------------------------+
void Design_Create()
  {
//+------------------------------------------------------------------+
//| Buttons & Dashboard                                              |
//+------------------------------------------------------------------+
   bool rectangle = RectLabelCreate();
   bool Create_Button_All = Create_Button(0, "Button_Close_All", 0, 250, 320, 100, 20, 0, "Close All", "Ninja Rush", 10, clrWhite, C'0, 190, 255');
   bool Create_Button_Profit = Create_Button(0, "Button_Close_Profit", 0, 360, 320, 100, 20, 0, "Close Profit", "Ninja Rush", 10, clrWhite, clrGreen);
   bool Create_Button_Loss = Create_Button(0, "Button_Close_Loss", 0, 470, 320, 100, 20, 0, "Close Loss", "Ninja Rush", 10, clrWhite, clrRed);
   bool Create_Button_Minimize = Create_Button(0, "Button_Minimize", 0, 550, 10, 20, 20, 0, "-", "Ninja Rush", 10, clrWhite, C'0, 190, 255');
//+------------------------------------------------------------------+
//| Logos                                                            |
//+------------------------------------------------------------------+
   bool main_logo_create = BitmapLabelCreate(0, "main_logo", 0, 20, 10, "::Images\\main_logo.bmp", "::Images\\main_logo.bmp", 130, 143);
   bool info_logo_create = BitmapLabelCreate(0, "info_logo", 0, 150, 30, "::Images\\info_logo.bmp", "::Images\\info_logo.bmp", 230, 80);
   bool sub_logo_create = BitmapLabelCreate(0, "sub_logo", 0, 400, 20, "::Images\\sub_logo.bmp", "::Images\\sub_logo.bmp", 150, 124);
//+------------------------------------------------------------------+
//| First Row                                                        |
//+------------------------------------------------------------------+
   bool symbol_text = LabelCreate(0, "symbol_text", 0, 20, 160, 0, _Symbol, "Ninja Rush", 10, clrWhite);
   bool grid_text = LabelCreate(0, "Grid_text", 0, 20, 180, 0, "GRID SIZE:" + " " + (string)InpGridSize + " Pips ", "Ninja Rush", 7, clrWhite);
   bool tp_text = LabelCreate(0, "tp_text", 0, 20, 200, 0, "TAKE PROFIT:" + " " + (string)InpTakeProfit + " Pips", "Ninja Rush", 7, clrWhite);
   bool max_lot_text = LabelCreate(0, "max_lot_text", 0, 20, 220, 0, "MAX LOT:" + " " + (string)InpMaxLot, "Ninja Rush", 7, clrWhite);
   bool daily_target_text = LabelCreate(0, "daily_target_text", 0, 20, 240, 0, "DAILY $ TARGET:" + " " + DT, "Ninja Rush", 7, clrWhite);
   bool broker_time_text = LabelCreate(0, "broker_time_text", 0, 20, 320, 0, "TIME OF BROKER:" + " " + TimeToStr(TimeCurrent(), TIME_DATE | TIME_SECONDS), "Ninja Rush", 7, clrWhite);
//+------------------------------------------------------------------+
//| Second Row                                                        |
//+------------------------------------------------------------------+
   bool lot_mode_text = LabelCreate(0, "lot_mode_text", 0, 170, 160, 0, "LOT MODE:" + " " + LM, "Ninja Rush", 7, clrWhite);
   bool multiplier_text = LabelCreate(0, "multiplier_text", 0, 170, 180, 0, "MULTIPLIER:" + " " + (string)InpGridFactor, "Ninja Rush", 7, clrWhite);
   bool trailing_text = LabelCreate(0, "trailing_text", 0, 170, 200, 0, "TRAILING STOP:" + " " + TLS, "Ninja Rush", 7, clrWhite);
   bool equity_text = LabelCreate(0, "equity_text", 0, 170, 220, 0, "EQUITY:" + " " + RoundToNearest((string)AccountEquity()), "Ninja Rush", 7, clrWhite);
   bool last_lot_text = LabelCreate(0, "last_lot_text", 0, 170, 240, 0, "LAST LOT:" + " " + (string)m_lastlot1, "Ninja Rush", 7, clrWhite);
   bool total_equity_text = LabelCreate(0, "total_equity_text", 0, 170, 260, 0, "TOTAL EQUITY RISK:" + " " + ES, "Ninja Rush", 7, clrWhite);
//+------------------------------------------------------------------+
//| third Row                                                        |
//+------------------------------------------------------------------+
   bool daily_profit_text = LabelCreate(0, "daily_profit_text", 0, 350, 120, 0, "DAILY PROFIT:" + " " + (string)daily_profit, "Ninja Rush", 7, clrWhite);
   bool weekly_profit_text = LabelCreate(0, "weekly_profit_text", 0, 350, 140, 0, "WEEKLY PROFIT:" + " " + (string)weekly_profit, "Ninja Rush", 7, clrWhite);
   bool monthly_profit_text = LabelCreate(0, "monthly_profit_text", 0, 350, 160, 0, "MONTHLY PROFIT:" + " " + (string)monthly_profit, "Ninja Rush", 7, clrWhite);
   bool average_daily_text = LabelCreate(0, "average_daily_text", 0, 350, 180, 0, "AVERAGE DAILY PROFIT:" + " " + (string)average_profit, "Ninja Rush", 7, clrWhite);
   bool working_time_text = LabelCreate(0, "working_time_text", 0, 350, 240, 0, "BOT WORKING TIME:" + " " + BWT, "Ninja Rush", 7, clrWhite);
   bool working_day_text = LabelCreate(0, "working_day_text", 0, 350, 260, 0, monday + " " + tuesday + " " + wednesday + " " + thursday + " " + friday, "Ninja Rush", 7, clrWhite);
   bool from_time_text = LabelCreate(0, "from_time_text", 0, 350, 280, 0, "From: " + " " + InpStartHour, "Ninja Rush", 7, clrWhite);
   bool to_time_text = LabelCreate(0, "to_time_text", 0, 350, 300, 0, "To: " + " " + InpEndHour, "Ninja Rush", 7, clrWhite);
  }
//+------------------------------------------------------------------+
void Design_Delete()
  {
//+------------------------------------------------------------------+
//| Button & Dashboard                                               |
//+------------------------------------------------------------------+
   RectLabelDelete(0, "RectLabel");
   ButtonDelete(0, "Button_Close_All");
   ButtonDelete(0, "Button_Close_Profit");
   ButtonDelete(0, "Button_Close_Loss");
   ButtonDelete(0, "Button_Minimize");
   ButtonDelete(0, "Button_Maximize");
//+------------------------------------------------------------------+
//| Logos                                                            |
//+------------------------------------------------------------------+
   bool main_logo_delete = BitmapLabelDelete(0, "main_logo");
   bool info_logo_delete = BitmapLabelDelete(0, "info_logo");
   bool sub_logo_delete = BitmapLabelDelete(0, "sub_logo");
//+------------------------------------------------------------------+
//| First Row                                                        |
//+------------------------------------------------------------------+
   bool symbol_text_delete = LabelDelete(0, "symbol_text");
   bool grid_text_delete = LabelDelete(0, "Grid_text");
   bool tp_text_delete = LabelDelete(0, "tp_text");
   bool max_lot_delete = LabelDelete(0, "max_lot_text");
   bool daily_target_text = LabelDelete(0, "daily_target_text");
   bool broker_time_text = LabelDelete(0, "broker_time_text");
//+------------------------------------------------------------------+
//| Second Row                                                       |
//+------------------------------------------------------------------+
   bool lot_mode_text = LabelDelete(0, "lot_mode_text");
   bool multiplier_text = LabelDelete(0, "multiplier_text");
   bool be_text = LabelDelete(0, "be_text");
   bool trailing_text = LabelDelete(0, "trailing_text");
   bool equity_text = LabelDelete(0, "equity_text");
   bool last_lot_text = LabelDelete(0, "last_lot_text");
   bool total_equity_text = LabelDelete(0, "total_equity_text");
   bool equity_filter_text = LabelDelete(0, "equity_filter_text");
//+------------------------------------------------------------------+
//| third Row                                                        |
//+------------------------------------------------------------------+
   bool working_time_text = LabelDelete(0, "working_time_text");
   bool working_day_text = LabelDelete(0, "working_day_text");
   bool from_time_text = LabelDelete(0, "from_time_text");
   bool to_time_text = LabelDelete(0, "to_time_text");
   bool daily_profit_text = LabelDelete(0, "daily_profit_text");
   bool weekly_profit_text = LabelDelete(0, "weekly_profit_text");
   bool monthly_profit_text = LabelDelete(0, "monthly_profit_text");
   bool average_daily_text = LabelDelete(0, "average_daily_text");
  }
//+------------------------------------------------------------------+
//|MINIMIZE THE DESIGNED WINDOW                                      |
//+------------------------------------------------------------------+
void Minimize()
  {
//+------------------------------------------------------------------+
//| Logos & Dashboard                                                |
//+------------------------------------------------------------------+
   bool sub_logo_delete = BitmapLabelDelete(0, "sub_logo");
   bool info_logo_move = BitmapLabelDelete(0, "info_logo");
   bool main_logo_move = BitmapLabelMove(0, "main_logo", 20, 10);
   bool rectangle_size_change = RectLabelChangeSize(0, "RectLabel", 180, 180);
   bool Create_Button_Maximize = Create_Button(0, "Button_Maximize", 0, 150, 10, 20, 20, 0, "+", "Ninja Rush", 10, clrWhite, C'0,190,255');
//+------------------------------------------------------------------+
//| First Row                                                        |
//+------------------------------------------------------------------+
   bool symbol_text_delete = LabelDelete(0, "symbol_text");
   bool grid_text_delete = LabelDelete(0, "Grid_text");
   bool tp_text_delete = LabelDelete(0, "tp_text");
   bool sl_text_delete = LabelDelete(0, "sl_text");
   bool max_lot_delete = LabelDelete(0, "max_lot_text");
   bool daily_target_text = LabelDelete(0, "daily_target_text");
   bool broker_time_text = LabelDelete(0, "broker_time_text");
//+------------------------------------------------------------------+
//| Second Row                                                       |
//+------------------------------------------------------------------+
   bool lot_mode_text = LabelDelete(0, "lot_mode_text");
   bool multiplier_text = LabelDelete(0, "multiplier_text");
   bool be_text = LabelDelete(0, "be_text");
   bool trailing_text = LabelDelete(0, "trailing_text");
   bool equity_text = LabelDelete(0, "equity_text");
   bool last_lot_text = LabelDelete(0, "last_lot_text");
   bool total_equity_text = LabelDelete(0, "total_equity_text");
//+------------------------------------------------------------------+
//| third Row                                                        |
//+------------------------------------------------------------------+
   bool daily_profit_text = LabelDelete(0, "daily_profit_text");
   bool weekly_profit_text = LabelDelete(0, "weekly_profit_text");
   bool monthly_profit_text = LabelDelete(0, "monthly_profit_text");
   bool average_daily_text = LabelDelete(0, "average_daily_text");
   bool working_time_text = LabelDelete(0, "working_time_text");
   bool working_day_text = LabelDelete(0, "working_day_text");
   bool from_time_text = LabelDelete(0, "from_time_text");
   bool to_time_text = LabelDelete(0, "to_time_text");
//+------------------------------------------------------------------+
//| Button                                                           |
//+------------------------------------------------------------------+
   ButtonDelete(0, "Button_Close_All");
   ButtonDelete(0, "Button_Close_Profit");
   ButtonDelete(0, "Button_Close_Loss");
   ButtonDelete(0, "Button_Minimize");
   flag_minimize = true;
  }
//+------------------------------------------------------------------+
//|Maximize the designed window                                      |
//+------------------------------------------------------------------+
void Maximize()
  {
//+------------------------------------------------------------------+
//| Buttons & Dashboard                                              |
//+------------------------------------------------------------------+
   bool rectangle_size_change = RectLabelChangeSize(0, "RectLabel", 580, 350);
   bool Create_Button_Minimize = Create_Button(0, "Button_Minimize", 0, 550, 10, 20, 20, 0, "-", "Ninja Rush", 10, clrWhite, C'0,190,255');
   bool Create_Button_All = Create_Button(0, "Button_Close_All", 0, 250, 320, 100, 20, 0, "Close All", "Ninja Rush", 10, clrWhite, C'0,190,255');
   bool Create_Button_Profit = Create_Button(0, "Button_Close_Profit", 0, 360, 320, 100, 20, 0, "Close Profit", "Ninja Rush", 10, clrWhite, clrGreen);
   bool Create_Button_Loss = Create_Button(0, "Button_Close_Loss", 0, 470, 320, 100, 20, 0, "Close Loss", "Ninja Rush", 10, clrWhite, clrRed);
   ButtonDelete(0, "Button_Maximize");
//+------------------------------------------------------------------+
//| Logos                                                            |
//+------------------------------------------------------------------+
   bool info_logo_create = BitmapLabelCreate(0, "info_logo", 0, 150, 30, "::Images\\info_logo.bmp", "::Images\\info_logo.bmp", 230, 80);
   bool sub_logo_create = BitmapLabelCreate(0, "sub_logo", 0, 400, 20, "::Images\\sub_logo.bmp", "::Images\\sub_logo.bmp", 150, 124);
   bool main_logo_move = BitmapLabelMove(0, "main_logo", 20, 10);
//+------------------------------------------------------------------+
//| First Row                                                        |
//+------------------------------------------------------------------+
   bool symbol_text = LabelCreate(0, "symbol_text", 0, 20, 160, 0, _Symbol, "Ninja Rush", 10, clrWhite);
   bool grid_text = LabelCreate(0, "Grid_text", 0, 20, 180, 0, "GRID SIZE:" + " " + (string)InpGridSize + " Pips ", "Ninja Rush", 7, clrWhite);
   bool tp_text = LabelCreate(0, "tp_text", 0, 20, 200, 0, "TAKE PROFIT:" + " " + (string)InpTakeProfit + " Pips", "Ninja Rush", 7, clrWhite);
   bool max_lot_text = LabelCreate(0, "max_lot_text", 0, 20, 220, 0, "MAX LOT:" + " " + (string)InpMaxLot, "Ninja Rush", 7, clrWhite);
   bool daily_target_text = LabelCreate(0, "daily_target_text", 0, 20, 240, 0, "DAILY $ TARGET:" + " " + DT, "Ninja Rush", 7, clrWhite);
   bool broker_time_text = LabelCreate(0, "broker_time_text", 0, 20, 320, 0, "TIME OF BROKER:" + " " + TimeToStr(TimeCurrent(), TIME_DATE | TIME_SECONDS), "Ninja Rush", 7, clrWhite);
//+------------------------------------------------------------------+
//| Second Row                                                        |
//+------------------------------------------------------------------+
   bool lot_mode_text = LabelCreate(0, "lot_mode_text", 0, 170, 160, 0, "LOT MODE:" + " " + LM, "Ninja Rush", 7, clrWhite);
   bool multiplier_text = LabelCreate(0, "multiplier_text", 0, 170, 180, 0, "MULTIPLIER:" + " " + (string)InpGridFactor, "Ninja Rush", 7, clrWhite);
   bool trailing_text = LabelCreate(0, "trailing_text", 0, 170, 200, 0, "TRAILING STOP:" + " " + TLS, "Ninja Rush", 7, clrWhite);
   bool equity_text = LabelCreate(0, "equity_text", 0, 170, 220, 0, "EQUITY:" + " " + RoundToNearest((string)AccountEquity()), "Ninja Rush", 7, clrWhite);
   bool last_lot_text = LabelCreate(0, "last_lot_text", 0, 170, 240, 0, "LAST LOT:" + " " + (string)m_lastlot1, "Ninja Rush", 7, clrWhite);
   bool total_equity_text = LabelCreate(0, "total_equity_text", 0, 170, 260, 0, "TOTAL EQUITY RISK:" + " " + ES, "Ninja Rush", 7, clrWhite);
//+------------------------------------------------------------------+
//| third Row                                                        |
//+------------------------------------------------------------------+
   bool daily_profit_text = LabelCreate(0, "daily_profit_text", 0, 350, 120, 0, "DAILY PROFIT:" + " " + (string)daily_profit, "Ninja Rush", 7, clrWhite);
   bool weekly_profit_text = LabelCreate(0, "weekly_profit_text", 0, 350, 140, 0, "WEEKLY PROFIT:" + " " + (string)weekly_profit, "Ninja Rush", 7, clrWhite);
   bool monthly_profit_text = LabelCreate(0, "monthly_profit_text", 0, 350, 160, 0, "MONTHLY PROFIT:" + " " + (string)monthly_profit, "Ninja Rush", 7, clrWhite);
   bool average_daily_text = LabelCreate(0, "average_daily_text", 0, 350, 180, 0, "AVERAGE DAILY PROFIT:" + " " + (string)average_profit, "Ninja Rush", 7, clrWhite);
   bool working_time_text = LabelCreate(0, "working_time_text", 0, 350, 240, 0, "BOT WORKING TIME:" + " " + BWT, "Ninja Rush", 7, clrWhite);
   bool working_day_text = LabelCreate(0, "working_day_text", 0, 350, 260, 0, monday + " " + tuesday + " " + wednesday + " " + thursday + " " + friday, "Ninja Rush", 7, clrWhite);
   bool from_time_text = LabelCreate(0, "from_time_text", 0, 350, 280, 0, "From: " + " " + InpStartHour, "Ninja Rush", 7, clrWhite);
   bool to_time_text = LabelCreate(0, "to_time_text", 0, 350, 300, 0, "To: " + " " + InpEndHour, "Ninja Rush", 7, clrWhite);
   flag_minimize = false;
  }
//+------------------------------------------------------------------+
//| UPDATE VALUES OF THE DESIGNED WINDOW                             |
//+------------------------------------------------------------------+
void Update_Values()
  {
   if(flag_minimize == false)
     {
      if(ShowInfo == true)
        {
         bool broker_time_change = LabelTextChange(0, "broker_time_text", "TIME OF BROKER:" + " " + TimeToStr(TimeCurrent(), TIME_DATE | TIME_SECONDS));
         bool equity_change = LabelTextChange(0, "equity_text", "EQUITY:" + " " + RoundToNearest((string)AccountEquity()));
         bool last_lot_change = LabelTextChange(0, "last_lot_text", "LAST LOT:" + " " + (string)m_lastlot1);
         bool daily_profit_change = LabelTextChange(0, "daily_profit_text", "DAILY PROFIT:" + " " +  RoundToNearest((string)daily_profit));
         bool weekly_profit_change = LabelTextChange(0, "weekly_profit_text", "WEEKLY PROFIT:" + " " +  RoundToNearest((string)weekly_profit));
         bool monthly_profit_change = LabelTextChange(0, "monthly_profit_text", "MONTHLY PROFIT:" + " " +  RoundToNearest((string)(monthly_profit)));
         bool average_daily_change = LabelTextChange(0, "average_daily_text", "AVERAGE DAILY PROFIT:" + " " +  RoundToNearest((string)(average_profit)));
        }
     }
  }
//+------------------------------------------------------------------+
//| CHECK IF ITS A NEW DAY                                           |
//+------------------------------------------------------------------+
bool Is_New_Day()
  {
   if(today != TimeDayOfYear(TimeCurrent())) // IS NEW DAY
     {
      today_profit = daily_profit;
      today_start_equity = AccountEquity();
      average_profit = Average_Daily_Profit();
      today = TimeDayOfYear(TimeCurrent());
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//| CHECK IF ITS A NEW WEEK                                          |
//+------------------------------------------------------------------+
bool Is_New_Week()
  {
   if(flag_week == true)
     {
      if(TimeDayOfWeek(TimeCurrent()) == 1) // IS NEW WEEK
        {
         flag_week = false;
         return true;
        }
     }
   if((TimeDayOfWeek(TimeCurrent()) != 1))
     {
      flag_week = true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//| CHECK IF ITS A NEW MONTH                                         |
//+------------------------------------------------------------------+
bool Is_New_Month()
  {
   if(this_month != TimeMonth(TimeCurrent())) // IS NEW DAY
     {
      this_month = TimeMonth(TimeCurrent());
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|CALCULATE DAILY PROFIT                                            |
//+------------------------------------------------------------------+
double Daily_Profit()
  {
   daily_profit = AccountEquity() - today_start_equity;
   return daily_profit;
  }
//+------------------------------------------------------------------+
//|CALCULATE WEEKLY PROFIT                                           |
//+------------------------------------------------------------------+
double Weekly_Profit()
  {
   if(Is_New_Week())
     {
      weekly_start_equity = AccountEquity();
     }
   weekly_profit = AccountEquity() - weekly_start_equity;
   return weekly_profit;
  }
//+------------------------------------------------------------------+
//|CALCULATE MONTHLY PROFIT                                          |
//+------------------------------------------------------------------+
double Monthly_Profit()
  {
   if(Is_New_Month())
     {
      monthly_start_equity = AccountEquity();
     }
   monthly_profit = AccountEquity() - monthly_start_equity;
   return monthly_profit;
  }
//+------------------------------------------------------------------+
//|CALCULATE AVERAGE DAILY PROFIT                                    |
//+------------------------------------------------------------------+
double Average_Daily_Profit()
  {
   total_profit_daily = total_profit_daily + today_profit;
   ndays = ndays + 1;
   average_profit = total_profit_daily / ndays;
   return average_profit;
  }
//+------------------------------------------------------------------+
//|LOT ADJUSTMENT                                                    |
//+------------------------------------------------------------------+
bool LotAdjustment(double pInitialLot)
  {
   if(pInitialLot > inpBrokerMaxLot)
     {
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|REMAINDER CHECK                                                   |
//+------------------------------------------------------------------+
bool HasRemainder(double pInitialLot, double pSubLot)
  {
   if(MathMod(pInitialLot, pSubLot) == 0)
     {
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//MULTIPLE ORDER PLACEMENT                                           |
//+------------------------------------------------------------------+
void MultipleOrderPlaced(int pCmd, double pAsk_price, int pvInpMagic, double pSl, double pInitialLot, double pSubLot)
  {
   double numberOfOrderToPlace = MathFloor(pInitialLot / pSubLot);

   if(HasRemainder(pInitialLot, pSubLot) == true)
     {
      double first_lot = NormalizeDouble(MathMod(pInitialLot, pSubLot), 2);
      OpenTrade(pCmd, first_lot, pAsk_price, pvInpMagic, "Ronin EA " + string(pvInpMagic), pSl);

      for(double i = numberOfOrderToPlace; i > 0; i--)
        {
         OpenTrade(pCmd, pSubLot, pAsk_price, pvInpMagic, "Ronin EA " + string(pvInpMagic), pSl);
        }
     }

   if(HasRemainder(pInitialLot, pSubLot) == false)
     {
      for(double i = numberOfOrderToPlace; i > 0; i--)
        {
         OpenTrade(pCmd, pSubLot, pAsk_price, pvInpMagic, "Ronin EA " + string(pvInpMagic), pSl);
        }
     }
  }
//+------------------------------------------------------------------+
//|TIMER CHECK                                                       |
//+------------------------------------------------------------------+
bool HasTimerBeenReached()
  {
   if(inpTimeControl == false)
      return(false);
   MqlDateTime STimeCurrent;
   datetime time_current = TimeCurrent();
   TimeToStruct(time_current, STimeCurrent);
   if(STimeCurrent.day * 60 * 60 * 60 + STimeCurrent.hour * 60 * 60 + STimeCurrent.min * 60 >= STimeCurrent.day * 60 * 60 * 60 + inpTimeHour * 60 * 60 + inpTimeMinute * 60)
     {
      if(lastDay != STimeCurrent.day)
        {
         Close_All_Order();
         lastDay = STimeCurrent.day;
         Alert("Timer reached - All orders will be now closed");
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Check All Time Target                                            |
//+------------------------------------------------------------------+
bool CheckAllTimeTarget()
  {
   if(IsTimeTargetReached("day") || IsTimeTargetReached("week") || IsTimeTargetReached("month"))
      return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Is time target reached                                           |
//+------------------------------------------------------------------+
bool IsTimeTargetReached(string timePeriod)
  {
   double accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   if(timePeriod == "day")
      if(accountEquity > dailyAccountEquity + dailyAccountEquity * (inpDailyTarget / 100) && !dailyTargetFlag && inpDailyTarget != 0)
        {
         dailyTargetFlag = true;
         Close_All_Order();
         Print("Daily target reached - All positions will be paused until the next trading day.");
        }
   if(timePeriod == "week")
      if(accountEquity > weeklyAccountEquity + weeklyAccountEquity * (inpWeeklyTarget / 100) && !weeklyTargetFlag && inpWeeklyTarget != 0)
        {
         weeklyTargetFlag = true;
         Close_All_Order();
         Print("Weekly target reached - All positions will be paused until next week.");
        }
   if(timePeriod == "month")
      if(accountEquity > monthlyAccountEquity + monthlyAccountEquity * (inpMonthlyTarget / 100) && !monthlyTargetFlag && inpMonthlyTarget != 0)
        {
         monthlyTargetFlag = true;
         Close_All_Order();
         Print("Monthly target reached - All positions will be paused until next month.");
        }
   if(dailyTargetFlag || weeklyTargetFlag || monthlyTargetFlag)
      return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Set new equity and target/loss flags on period of time           |
//+------------------------------------------------------------------+
void SetPeriodOfTimeEquity()
  {
   if(IsNewPeriodOfTime("day") && CountTrades() == 0)
     {
      dailyAccountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      dailyTargetFlag = false;
     }
   if(IsNewPeriodOfTime("week") && CountTrades() == 0)
     {
      weeklyAccountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      weeklyTargetFlag = false;
     }
   if(IsNewPeriodOfTime("month") && CountTrades() == 0)
     {
      monthlyAccountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      monthlyTargetFlag = false;
     }
  }
//+------------------------------------------------------------------+
//| Is new period of time                                            |
//+------------------------------------------------------------------+
bool IsNewPeriodOfTime(string timePeriod)
  {
   MqlDateTime timeCurrent;
   TimeToStruct(TimeCurrent(), timeCurrent);
   if(timePeriod == "day")
     {
      if(currentDay == timeCurrent.day)
         return false;
      else
        {
         currentDay = timeCurrent.day;
         return true;
        }
     }
   if(timePeriod == "week")
     {
      if(currentWeek == timeCurrent.day_of_week)
         return false;
      else
        {
         currentWeek = timeCurrent.day_of_week;
         if(currentWeek == 1)
           {
            return true;
           }
        }
     }
   if(timePeriod == "month")
     {
      if(currentMonth == timeCurrent.mon)
         return false;
      else
        {
         currentMonth = timeCurrent.mon;
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Equity Stop Launh Time Check                                     |
//+------------------------------------------------------------------+
bool HasEquityStopLaunchTimeBeenReached()
  {
   if(TimeCurrent() >= equityStopLaunchTime)
      return true;
   return false;
  }

//+------------------------------------------------------------------+
//| Check if it is a new candle                                      |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   if(bars != Bars(_Symbol, PERIOD_CURRENT))
     {
      bars =  Bars(_Symbol, PERIOD_CURRENT);
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Return the high of x last candles                                |
//+------------------------------------------------------------------+
double GetHighOnXLastCandles(ENUM_TIMEFRAMES tf)
  {
   if(CheckIfLastXHighsAreBelowYHigh(inpXCandles, inpXCandles + 1, tf))
      if(CheckIfNextXHighsAreBelowYHigh(inpXCandles, inpXCandles + 1, tf))
        {
         highIndex = inpXCandles + 1;
         return iHigh(_Symbol, tf, inpXCandles + 1);
        }
   return 0;
  }
//+------------------------------------------------------------------+
//| Check if next x highs are below y high                           |
//+------------------------------------------------------------------+
bool CheckIfNextXHighsAreBelowYHigh(int x, int y, ENUM_TIMEFRAMES tf)
  {
   for(int i = 1; i <= x; i++)
     {
      if(iHigh(_Symbol, tf, y - i) > iHigh(_Symbol, tf, y))
         return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Check if last x highs are below y high                           |
//+------------------------------------------------------------------+
bool CheckIfLastXHighsAreBelowYHigh(int x, int y, ENUM_TIMEFRAMES tf)
  {
   for(int i = 1; i <= x; i++)
     {
      if(iHigh(_Symbol, tf, y + i) > iHigh(_Symbol, tf, y))
         return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Create high arrow                                                |
//+------------------------------------------------------------------+
void CreateHighArrow(double price, datetime time, int i)
  {
   highArrowI += 1;
   highArrows[i].Create(0, "HighArrow" + IntegerToString(highArrowI), 0, time, price);
   highArrows[i].Anchor(ANCHOR_BOTTOM);
   highArrows[i].Color(highArrowsColor[i]);
  }
//+------------------------------------------------------------------+
//| Create low arrow                                                 |
//+------------------------------------------------------------------+
void CreateLowArrow(double price, datetime time, int i)
  {
   lowArrowI += 1;
   lowArrows[i].Create(0, "LowArrow" + IntegerToString(lowArrowI), 0, time, price);
   lowArrows[i].Anchor(ANCHOR_TOP);
   lowArrows[i].Color(lowArrowsColor[i]);
  }
//+------------------------------------------------------------------+
//| Is last high broken                                              |
//+------------------------------------------------------------------+
bool IsLastHighBroken(double price, int i)
  {
   if(price > highArrows[i].GetDouble(OBJPROP_PRICE, 0))
      return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Is last low broken                                              |
//+------------------------------------------------------------------+
bool IsLastLowBroken(double price, int i)
  {
   if(price < lowArrows[i].GetDouble(OBJPROP_PRICE, 0))
      return true;
   return false;
  }
//+------------------------------------------------------------------+
//| Create high broken trend line                                    |
//+------------------------------------------------------------------+
void CreateHighBrokenTrendLine(datetime time, color arrowColor, int i)
  {
   brokenHighI += 1;
   highBrokens[i].Create(0, "HighBroken" + IntegerToString(brokenHighI), 0, highArrows[i].GetInteger(OBJPROP_TIME, 0), highArrows[i].GetDouble(OBJPROP_PRICE, 0), time, highArrows[i].GetDouble(OBJPROP_PRICE, 0));
   highBrokens[i].RayRight(false);
   highBrokens[i].Color(arrowColor);
  }
//+------------------------------------------------------------------+
//| Create low broken trend line                                     |
//+------------------------------------------------------------------+
void CreateLowBrokenTrendLine(datetime time, color arrowColor, int i)
  {
   brokenLowI += 1;
   lowBrokens[i].Create(0, "LowBroken" + IntegerToString(brokenLowI), 0, lowArrows[i].GetInteger(OBJPROP_TIME, 0), lowArrows[i].GetDouble(OBJPROP_PRICE, 0), time, lowArrows[i].GetDouble(OBJPROP_PRICE, 0));
   lowBrokens[i].RayRight(false);
   lowBrokens[i].Color(arrowColor);
  }

//+------------------------------------------------------------------+
//| Initialize Hilo indicator                                        |
//+------------------------------------------------------------------+
void InitializeHiloIndicator()
  {

   for(int j = 0; j < ArraySize(filterTimeFrames); j++)
     {
      bool newHighArrowHasFormed = false;
      bool newLowArrowHasFormed = false;
      ENUM_TIMEFRAMES tf = filterTimeFrames[j];
      for(int i = iBars(_Symbol, tf) - inpXCandles + 1; i >= inpXCandles + 1 ; i--)
        {
         if(GetHighOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, i, tf) != 0 && highArrows[j].Price(0) != GetHighOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, i, tf))
           {
            highBrokenFlags[j] = false;
            newHighArrowHasFormed = true;
            datetime highOpenTimeOnDiffTF = GetOpenTimeOfXcandleHighOnTheCurrentTF(highIndex, tf);
            CreateHighArrow(GetHighOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, i, tf), highOpenTimeOnDiffTF, j);
           }
         if(GetLowOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, i, tf) != 0 && lowArrows[j].Price(0) != GetLowOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, i, tf))
           {
            lowBrokenFlags[j] = false;
            newLowArrowHasFormed = true;
            datetime lowOpenTimeOnDiffTF = GetOpenTimeOfXcandleLowOnTheCurrentTF(lowIndex, tf);
            CreateLowArrow(GetLowOnXLastCandlesAtYIndexOnSpecificTF(inpXCandles, i, tf), lowOpenTimeOnDiffTF, j);
           }
         if(IsLastHighBroken(iHigh(_Symbol, tf, i - inpXCandles), j) && !highBrokenFlags[j] && newHighArrowHasFormed)
           {
            CreateHighBrokenTrendLine(iTime(_Symbol, tf, i - inpXCandles), highArrowsColor[j], j);
            highBrokenFlags[j] = true;
           }
         if(IsLastLowBroken(iLow(_Symbol, tf, i - inpXCandles), j) && !lowBrokenFlags[j] && newLowArrowHasFormed)
           {
            CreateLowBrokenTrendLine(iTime(_Symbol, tf, i - inpXCandles), lowArrowsColor[j], j);
            lowBrokenFlags[j] = true;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Get open time of x candle high                                   |
//+------------------------------------------------------------------+
datetime GetOpenTimeOfXcandleHighOnTheCurrentTF(int x, ENUM_TIMEFRAMES tf)
  {
   double otherTFHigh = iHigh(_Symbol, tf, highIndex);
   int barShift = iBarShift(_Symbol, PERIOD_CURRENT, iTime(_Symbol, tf, x), false);
   return iTime(_Symbol, PERIOD_CURRENT, barShift);
  }
//+------------------------------------------------------------------+
//| Get open time of x candle low                                    |
//+------------------------------------------------------------------+
datetime GetOpenTimeOfXcandleLowOnTheCurrentTF(int x, ENUM_TIMEFRAMES tf)
  {
   double otherTFLow = iLow(_Symbol, tf, lowIndex);
   int barShift = iBarShift(_Symbol, PERIOD_CURRENT, iTime(_Symbol, tf, x), false);
   return iTime(_Symbol, PERIOD_CURRENT, barShift);
  }
//+------------------------------------------------------------------+
//| Return the high of x last candles at y index                     |
//+------------------------------------------------------------------+
double GetHighOnXLastCandlesAtYIndexOnSpecificTF(int x, int y, ENUM_TIMEFRAMES tf)
  {
   if(CheckIfLastXHighsAreBelowYHighOnSpecificTF(x, y, tf))
      if(CheckIfNextXHighsAreBelowYHighOnSpecificTF(x, y, tf))
        {
         highIndex = y;
         return iHigh(_Symbol, tf, y);
        }
   return 0;
  }
//+------------------------------------------------------------------+
//| Check if next x highs are below y high                           |
//+------------------------------------------------------------------+
bool CheckIfNextXHighsAreBelowYHighOnSpecificTF(int x, int y, ENUM_TIMEFRAMES tf)
  {
   for(int i = 1; i <= x; i++)
     {
      if(iHigh(_Symbol, tf, y - i) > iHigh(_Symbol, tf, y))
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Check if last x highs are below y high                           |
//+------------------------------------------------------------------+
bool CheckIfLastXHighsAreBelowYHighOnSpecificTF(int x, int y, ENUM_TIMEFRAMES tf)
  {
   for(int i = 1; i <= x; i++)
     {
      if(iHigh(_Symbol, tf, y + i) > iHigh(_Symbol, tf, y))
         return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Return the low of x last candles at y index                      |
//+------------------------------------------------------------------+
double GetLowOnXLastCandlesAtYIndexOnSpecificTF(int x, int y, ENUM_TIMEFRAMES tf)
  {
   if(CheckIfLastXLowsAreAboveYHighOnSpecificTF(x, y, tf))
      if(CheckIfNextXLowsAreAboveYHighOnSpecificTF(x, y, tf))
        {
         lowIndex = y;
         return iLow(_Symbol, tf, y);
        }
   return 0;
  }
//+------------------------------------------------------------------+
//| Check if next x lows are above y high                            |
//+------------------------------------------------------------------+
bool CheckIfNextXLowsAreAboveYHighOnSpecificTF(int x, int y, ENUM_TIMEFRAMES tf)
  {
   for(int i = 1; i <= x; i++)
     {
      if(iLow(_Symbol, tf, y - i) < iLow(_Symbol, tf, y))
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Check if last x lows are above y high                            |
//+------------------------------------------------------------------+
bool CheckIfLastXLowsAreAboveYHighOnSpecificTF(int x, int y, ENUM_TIMEFRAMES tf)
  {
   for(int i = 1; i <= x; i++)
     {
      if(iLow(_Symbol, tf, y + i) < iLow(_Symbol, tf, y))
         return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckIsBullish()
  {
   for(int i = 0; i < ArraySize(highBrokenFlags); i++)
     {
      if(!highBrokenFlags[i])
        {
         isBullish = false;
         return ;
        }
     }
   isBullish = true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckIsBearish()
  {
   for(int i = 0; i < ArraySize(lowBrokenFlags); i++)
     {
      if(!lowBrokenFlags[i])
        {
         isBearish = false;
         return;
        }
     }
   isBearish = true;
  }
//+------------------------------------------------------------------+
