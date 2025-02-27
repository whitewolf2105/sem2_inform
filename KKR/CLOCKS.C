#include <stdio.h>
#include <graphics.h>
#include <conio.h>
#include <dos.h>
#include <math.h>
const int BORDER_COLOR=BLACK, // 梥� �࠭�� ��࡫��
    BG_COLOR=DARKGRAY, // 梥� 䮭�
	FG_COLOR=BLACK, // 梥� �����ᥩ
	FACE_COLOR=LIGHTGRAY, // 梥� ��࡫��
	MARG_COLOR=WHITE, // 梥� ���� � ��ࠬ� � ���堬�
	HOURHAND_COLOR=BLUE, // 梥� �ᮢ�� ��५��
	MINHAND_COLOR=GREEN, // 梥� ����⭮� ��५��
	SECHAND_COLOR=BLACK; // 梥� ᥪ㭤��� ��५��
typedef struct { //�窠
	int x, y; //���न����
} TPoint;
typedef struct time TTime; //�६�
/*
��楤�� Polar2Dec() ��ॢ���� ���न���� �窨 �� ����୮� ��⥬� � �����⮢�.
��窠 �������� 㣫�� Angle � ����ﭨ�� �� 業�� Len � ����୮� ��⥬�,
� ���न��⠬� (P.x;P.y) � �����⮢��.
����� ����୮� ��⥬� �������� ���न��⠬� (P0.x;P0.y).
��ࠬ����:
Ang - 㣮� � ����୮� ��⥬�,
Len - ����ﭨ� �� 業�� � ����୮� ��⥬�, 
P0 - 業�� ����୮� ��⥬� � �����⮢��, 
P - ���न���� �窨 � �����⮢�� ��⥬�.
������� ��६����:
����������.
*/
void Polar2Dec(double Ang, double Len, TPoint P0, TPoint *P){
	Ang -= 90;
	P->x = (int)(P0.x + Len * cos(Ang * M_PI / 180));
	P->y = (int)(P0.y + Len * sin(Ang * M_PI / 180));
};
/*
��楤�� DrawFace() ���� ��࡫�� � 業�஬ � �窥 P0.
��ࠬ����:
P0 - 業�� ��࡫��.
������� ��६����:
i - ��६�����-���稪 ��� �ᮢ���� ��� �ᮢ � ���客 �����; 
P - 業�� ����-��,
P1,P2 - ���न���� ���殢 ����; 
num - ��ப� � ��ன ��� �뢮��;
OldStyleLine,OldStyleText,
OldStyleFill, OldColor - ������� ��। ��楤�ன �⨫� � 梥�.
*/
void DrawFace(TPoint P0){
  int i; TPoint P,P1,P2; char num[5];
  struct linesettingstype OldStyleLine; struct textsettingstype OldStyleText;
  struct fillsettingstype OldStyleFill; int OldColor;
	getlinesettings(&OldStyleLine); gettextsettings(&OldStyleText);
	getfillsettings(&OldStyleFill); OldColor=getcolor();
	
	setcolor(BORDER_COLOR);
	setlinestyle(0,0,3);
	setfillstyle(SOLID_FILL,MARG_COLOR);
	fillellipse(P0.x,P0.y,P0.y-30,P0.y-30);
	
	setcolor(BORDER_COLOR);
	setlinestyle(0,0,2);
	setfillstyle(SOLID_FILL,FACE_COLOR);
	fillellipse(P0.x,P0.y,P0.y-70,P0.y-70);
	
	setcolor(BG_COLOR);
	setfillstyle(HATCH_FILL,BG_COLOR);
	fillellipse(P0.x, P0.y,3 , 3);
	
	settextstyle(GOTHIC_FONT,HORIZ_DIR,4);
	settextjustify(CENTER_TEXT,CENTER_TEXT);
	setlinestyle(0,0,2);
	setcolor(FG_COLOR);
	
	for (i = 5; i<65;i++) {
		if (!(i%5)){
			Polar2Dec(i*6, P0.y - 50,P0, &P);
			sprintf(num,"%d",i/5);
			outtextxy((int)(P.x),(int)(P.y)-7,num);
		} else {
			Polar2Dec(i * 6, P0.y - 70,P0,&P1);
			Polar2Dec(i * 6, P0.y-60,P0, &P2);
			line(P1.x,P1.y,P2.x,P2.y);
		};
	};

	setlinestyle(OldStyleLine.linestyle,OldStyleLine.upattern,OldStyleLine.thickness);
	settextstyle(OldStyleText.font,OldStyleText.direction,OldStyleText.charsize);
	settextjustify(OldStyleText.horiz,OldStyleText.vert);
	setfillstyle(OldStyleFill.pattern,OldStyleFill.color);
	setcolor(OldColor);
};
/*
��楤�� DrawHands() ���� ��५�� �ᮢ � 業�஬ ��࡫�� � �窥 P0,
��� �६��� CurrTime, 梥⠬�:
hour_color - ��� �ᮢ�� ��५��,
min_color - ��� ����⭮� ��५��,
sec_color - ��� ᥪ㭤��� ��५��.
��ࠬ����:
P0 - 業�� ��࡫��,
CurrTime - ⥪�饥 �६�,
hour_color - 梥� �ᮢ�� ��५��,
min_color - 梥� ����⭮� ��५��,
sec_color - 梥� ᥪ㭤��� ��५��.
������� ��६����:
P1,P2 - ���न���� ���殢 ᥪ㭤��� ��५��,
P3,P4 - ���न���� ���殢 ����⭮� ��५��,
P5,P6 - ���न���� ���殢 �ᮢ�� ��५��,
OldStyleLine, OldColor - ������� ��। ��楤�ன �⨫� � 梥�.
*/
void DrawHands(TPoint P0,TTime CurrTime,int hour_color,int min_color,int sec_color){
  TPoint P1,P2,P3,P4,P5,P6;
  struct linesettingstype OldStyleLine; int OldColor;
	getlinesettings(&OldStyleLine); OldColor=getcolor();
	
	setlinestyle(0,0,3);
	
	Polar2Dec((CurrTime.ti_sec + (double)CurrTime.ti_hund/100) * 6, P0.y - 72,P0, &P1);
	Polar2Dec((CurrTime.ti_sec + (double)CurrTime.ti_hund/100) * 6, 5,P0, &P2);

	Polar2Dec((CurrTime.ti_min + (double)CurrTime.ti_sec/60) * 6, P0.y - 120,P0, &P3);
	Polar2Dec((CurrTime.ti_min + (double)CurrTime.ti_sec/60) * 6, 5,P0, &P4);

	Polar2Dec((CurrTime.ti_hour +(double) CurrTime.ti_min/60) * 30, P0.y - 150,P0, &P5);
	Polar2Dec((CurrTime.ti_hour +(double) CurrTime.ti_min/60) * 30, 5,P0, &P6);

	setcolor(sec_color);
	line(P2.x, P2.y, P1.x, P1.y);

	setcolor(min_color);
	line(P4.x, P4.y, P3.x, P3.y);

	setcolor(hour_color);
	line(P6.x, P6.y, P5.x, P5.y);
	setlinestyle(OldStyleLine.linestyle,OldStyleLine.upattern,OldStyleLine.thickness);
	setcolor(OldColor);
};

/*
��楤�� Initialize() ��⠭�������� ����᪨� ०�� 
� ��室�� ��� Pcenter - 業�� ��࠭�.
��ࠬ����:
Pcenter - ���न���� 業�� ��࠭�.
������� ��६����:
GraphDriver,GraphMode - ��⠭��������� ����᪨� �ࠩ��� � ����᪨� ०��,
gr_code - ��� �訡�� ���樠����樨 ����᪮�� ०���.
*/
int Initialize(TPoint *Pcenter){
int GraphDriver,GraphMode,gr_code;
	GraphDriver=DETECT;
	initgraph(&GraphDriver, &GraphMode,"");
    gr_code=graphresult() ;
	if (gr_code==grOk) {
		cleardevice();
		setfillstyle(SOLID_FILL,BG_COLOR);
		floodfill(0,0,BG_COLOR);
		Pcenter->x = getmaxx() / 2;
		Pcenter->y = getmaxy() / 2;
		return 1;
	} else {
		printf("�訡�� ���樠����樨 ����᪮�� ०��� #%d",gr_code);
		return 0;
	}
};

/*
�ணࠬ�� - ��������� ���.
��६����:
Pcenter - ���न���� 業�� ��࠭�,
CurrTime,DrawTime - ⥪�饥 �६� � �६� ��᫥����� ����ᮢ뢠��� ��५��,
Redraw - 㪠�뢠��, �㦭� �� ����ᮢ��� ��५�� (true - �㦭�, false - ���),
ok - 䫠� ������⢨� �訡�� (1 - ��� �訡��).
*/
int main(void){
  int ok;
  TPoint Pcenter;
  int WaitEnded;
  TTime CurrTime,DrawTime;
	ok=Initialize(&Pcenter);
	if (ok)   {
		settextstyle(GOTHIC_FONT,HORIZ_DIR,4);
		settextjustify(CENTER_TEXT,CENTER_TEXT);
		setcolor(FG_COLOR);	
		outtextxy(Pcenter.x,7, "Press any key to exit");
		outtextxy(Pcenter.x,getmaxy()-21, "Press any key to exit");
		
		DrawFace(Pcenter);
		
		gettime(&DrawTime);
		DrawHands(Pcenter,DrawTime,HOURHAND_COLOR,MINHAND_COLOR,SECHAND_COLOR);
		WaitEnded=0;
		
		while (!kbhit()){
			if (WaitEnded){
               
				DrawHands(Pcenter,DrawTime,FACE_COLOR,FACE_COLOR,FACE_COLOR);
		
				gettime(&DrawTime);
				DrawHands(Pcenter,DrawTime,HOURHAND_COLOR,MINHAND_COLOR,SECHAND_COLOR);
				WaitEnded=0;
			} else {
				gettime(&CurrTime);
				WaitEnded=(CurrTime.ti_hour-DrawTime.ti_hour)||(CurrTime.ti_min-DrawTime.ti_min)
						   ||(CurrTime.ti_sec-DrawTime.ti_sec)
							 ||(abs(CurrTime.ti_hund- DrawTime.ti_hund)>4);
			};
		};
		closegraph();
	} else printf("�ணࠬ�� ��ࢠ��!");
    return 0;
}
