//+------------------------------------------------------------------+
//|                            Ricardo Júnior changes on Volumes.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp. / Changes By Ricardo José Alves Júnior"
#property link      "ricardo.junior@gmail.com"
#property version   "1.00"


//---- indicator settings
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   1
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_color1  Green,Red
#property indicator_style1  0
#property indicator_width1  5
#property indicator_minimum 0.0
//--- input data
input ENUM_APPLIED_VOLUME InpVolumeType=VOLUME_REAL; // Volumes
//---- indicator buffers
double                    ExtVolumesBuffer[];
double                    ExtColorsBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//---- buffers   
   SetIndexBuffer(0,ExtVolumesBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtColorsBuffer,INDICATOR_COLOR_INDEX);
//---- name for DataWindow and indicator subwindow label
   IndicatorSetString(INDICATOR_SHORTNAME,"Volumes");
//---- indicator digits
   IndicatorSetInteger(INDICATOR_DIGITS,0);
//----
  }
//+------------------------------------------------------------------+
//|  Volumes                                                         |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---check for rates total
   if(rates_total<2)
      return(0);
//--- starting work
   int start=prev_calculated-1;
//--- correct position
   if(start<1) start=1;
//--- main cycle
   if(InpVolumeType==VOLUME_TICK)
      CalculateVolume(start,rates_total,tick_volume,open,close);
   else
      CalculateVolume(start,rates_total,volume,open,close);
//--- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateVolume(const int nPosition,
                     const int nRatesCount,
                     const long &SrcBuffer[],
                     const double &OpenBuffer[],
                     const double &CloseBuffer[])
  {
   ExtVolumesBuffer[0]=(double)SrcBuffer[0];
   ExtColorsBuffer[0]=0.0;
//---
   for(int i=nPosition;i<nRatesCount && !IsStopped();i++)
     {
      //--- get some data from src buffer
      double dOpenValue=(double)OpenBuffer[i];
      double dCloseValue=(double)CloseBuffer[i];
      //--- calculate indicator
      ExtVolumesBuffer[i]=(double)SrcBuffer[i];
      if(dOpenValue<=dCloseValue)
         ExtColorsBuffer[i]=0.0;
      else
         ExtColorsBuffer[i]=1.0;
         
               
     }
//---
  }
//+------------------------------------------------------------------+
