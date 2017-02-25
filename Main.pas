unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation,
  LUX, LUX.D1, LUX.D2, LUX.D3, LUX.D4, LUX.D5, LUX.M3, LUX.M4, LUX.Curve.T1.D1,
  FrameGraph;

type
  TForm1 = class(TForm)
    GraphFrame1: TGraphFrame;
    Panel1: TPanel;
      CheckBox1: TCheckBox;
      CheckBox2: TCheckBox;
      CheckBox3: TCheckBox;
      CheckBox4: TCheckBox;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure GraphFrame1Paint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure Timer1Timer(Sender: TObject);
  private
    { private 宣言 }
    ///// メソッド
    procedure DrawPoly1( const Color_:TAlphaColor );
    procedure DrawPoly2( const Color_:TAlphaColor );
    procedure DrawPoly3( const Color_:TAlphaColor );
    procedure DrawPoly4( const Color_:TAlphaColor );
  public
    { public 宣言 }
    _PolyKs :array [ 0..3 ] of TDouble5D;
    _PolyK  :TDouble5D;
    _FrameI :Cardinal;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TForm1.DrawPoly1( const Color_:TAlphaColor );
var
   Ks :TDouble2D;
   X1 :Double;
begin
     Ks := TDouble2D( _PolyK );

     GraphFrame1.DrawFunc(
          function ( const X_:Single ) :Single
          begin
               Result := Poly( X_, Ks );
          end,
          4,
          Color_ );

     if PolySolveReal( Ks, X1 ) = 1 then GraphFrame1.DrawPoin( TSingle2D.Create( X1, 0 ), Color_ );
end;

procedure TForm1.DrawPoly2( const Color_:TAlphaColor );
var
   Ks :TDouble3D;
   Xs :TDouble2D;
   I :Integer;
begin
     Ks := TDouble3D( _PolyK );

     GraphFrame1.DrawFunc(
          function ( const X_:Single ) :Single
          begin
               Result := Poly( X_, Ks );
          end,
          4,
          Color_ );

     for I := 1 to PolySolveReal( Ks, Xs ) do GraphFrame1.DrawPoin( TSingle2D.Create( Xs[ I ], 0 ), Color_ );
end;

procedure TForm1.DrawPoly3( const Color_:TAlphaColor );
var
   Ks :TDouble4D;
   Xs :TDouble3D;
   I :Integer;
begin
     Ks := TDouble4D( _PolyK );

     GraphFrame1.DrawFunc(
          function ( const X_:Single ) :Single
          begin
               Result := Poly( X_, Ks );
          end,
          4,
          Color_ );

     for I := 1 to PolySolveReal( Ks, Xs ) do GraphFrame1.DrawPoin( TSingle2D.Create( Xs[ I ], 0 ), Color_ );
end;

procedure TForm1.DrawPoly4( const Color_:TAlphaColor );
var
   Xs :TDouble4D;
   I :Integer;
begin
     GraphFrame1.DrawFunc(
          function ( const X_:Single ) :Single
          begin
               Result := Poly( X_, _PolyK );
          end,
          4,
          Color_ );

     for I := 1 to PolySolveReal( _PolyK, Xs ) do GraphFrame1.DrawPoin( TSingle2D.Create( Xs[ I ], 0 ), Color_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _PolyKs[ 1 ] := TDouble5D.Create( 0 );
     _PolyKs[ 2 ] := TDouble5D.Create( 0 );
     _PolyKs[ 3 ] := TDouble5D.Create( 0 );

     _FrameI := 0;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.GraphFrame1Paint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
     with Canvas do
     begin
          if CheckBox1.IsChecked then DrawPoly1( $FFDCA4F6 );
          if CheckBox2.IsChecked then DrawPoly2( $FFFBA180 );
          if CheckBox3.IsChecked then DrawPoly3( $FF87C97B );
          if CheckBox4.IsChecked then DrawPoly4( $FF00CBF4 );
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.Timer1Timer(Sender: TObject);
const
     KeyW :Cardinal = 100{F};
var
   Id :Integer;
   Bs :TDouble4D;
begin
     Id := _FrameI mod KeyW;

     if Id = 0 then
     begin
          _PolyKs[ 0 ] := _PolyKs[ 1 ];
          _PolyKs[ 1 ] := _PolyKs[ 2 ];
          _PolyKs[ 2 ] := _PolyKs[ 3 ];

          RandPoly( _PolyKs[ 3 ] );
     end;

     BSplin4( Id / KeyW, Bs );

     _PolyK := Bs._1 * _PolyKs[ 0 ]
             + Bs._2 * _PolyKs[ 1 ]
             + Bs._3 * _PolyKs[ 2 ]
             + Bs._4 * _PolyKs[ 3 ];

     GraphFrame1.Repaint;

     Inc( _FrameI );
end;

end. //######################################################################### ■
