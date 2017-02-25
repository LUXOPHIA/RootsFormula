unit FrameGraph;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  LUX.D2;

type
  TGraphFrame = class(TFrame)
  private
    _Path :TPathData;
    { private 宣言 }
  protected
    _Range :TSingleArea2D;
    _DivN   :Integer;
    ///// メソッド
    procedure Paint; override;
  public
    type TDrawFunc = reference to function ( const X_:Single ) :Single;
  public
    { public 宣言 }
    constructor Create( Owner_:TComponent ); override;
    destructor Destroy; override;
    ///// メソッド
    function ScrToPos( const S_:TPointF ) :TSingle2D;
    function PosToScr( const P_:TSingle2D ) :TPointF;
    procedure DrawPoin( const P_:TSingle2D; const Color_:TAlphaColor );
    procedure DrawLine( const P0_,P1_:TSingle2D; const Size_:Single; const Color_:TAlphaColor );
    procedure DrawScaleX( const Gap_:Single; const Size_:Single; const Color_:TAlphaColor );
    procedure DrawScaleY( const Gap_:Single; const Size_:Single; const Color_:TAlphaColor );
    procedure DrawScaleXs( const Color_:TAlphaColor );
    procedure DrawScaleYs( const Color_:TAlphaColor );
    procedure DrawFunc( const Func_:TDrawFunc; const Size_:Single; const Color_:TAlphaColor );
  end;

implementation //############################################################### ■

{$R *.fmx}

uses System.Math;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGraphFrame.Paint;
begin
     inherited;

     with Canvas do
     begin
          Clear( TAlphaColors.White );

          Stroke.Kind := TBrushKind.Solid;

          DrawScaleXs( TAlphaColors.Black );
          DrawScaleYs( TAlphaColors.Black );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGraphFrame.Create( Owner_:TComponent );
begin
     inherited;

     _Path := TPathData.Create;

     _Range := TSingleArea2D.Create( -1.5, -1, +1.5, +1 );

     _DivN := 200;
end;

destructor TGraphFrame.Destroy;
begin
     _Path.Free;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TGraphFrame.ScrToPos( const S_:TPointF ) :TSingle2D;
begin
     Result.X :=                S_.X / Width  * _Range.SizeX + _Range.Min.X;
     Result.Y := _Range.Max.Y - S_.Y / Height * _Range.SizeY               ;
end;

function TGraphFrame.PosToScr( const P_:TSingle2D ) :TPointF;
begin
     Result.X := ( P_.X - _Range.Min.X        ) / _Range.SizeX * Width ;
     Result.Y := (        _Range.Max.Y - P_.Y ) / _Range.SizeY * Height;
end;

//------------------------------------------------------------------------------

procedure TGraphFrame.DrawPoin( const P_:TSingle2D; const Color_:TAlphaColor );
var
   R, R1, R2 :TRectF;
begin
     R := TRectF.Create( PosToScr( P_ ) );

     R1 := R;  R1.Inflate( 4, 4 );
     R2 := R;  R2.Inflate( 8, 8 );

     with Canvas do
     begin
          Fill.Color := Color_;

          FillEllipse( R2, 1 );

          Fill.Color := TAlphaColors.White;

          FillEllipse( R1, 1 );
     end;
end;

procedure TGraphFrame.DrawLine( const P0_,P1_:TSingle2D; const Size_:Single; const Color_:TAlphaColor );
begin
     with Canvas do
     begin
          with Stroke do
          begin
               Thickness := Size_ ;
               Color     := Color_;
          end;

          DrawLine( PosToScr( P0_ ), PosToScr( P1_ ), 1 );
     end;
end;

//------------------------------------------------------------------------------

procedure TGraphFrame.DrawScaleX( const Gap_:Single; const Size_:Single; const Color_:TAlphaColor );
var
   I :Integer;
   X :Single;
   P0, P1 :TSingle2D;
begin
     for I := Ceil( _Range.Min.X / Gap_ ) to Floor( _Range.Max.X / Gap_ ) do
     begin
          X := Gap_ * I;

          P0.X := X;  P0.Y := _Range.Min.Y;
          P1.X := X;  P1.Y := _Range.Max.Y;

          DrawLine( P0, P1, Size_, Color_ );
     end;
end;

procedure TGraphFrame.DrawScaleY( const Gap_:Single; const Size_:Single; const Color_:TAlphaColor );
var
   I :Integer;
   Y :Single;
   P0, P1 :TSingle2D;
begin
     for I := Ceil( _Range.Min.Y / Gap_ ) to Floor( _Range.Max.Y / Gap_ ) do
     begin
          Y := Gap_ * I;

          P0.X := _Range.Min.X;  P0.Y := Y;
          P1.X := _Range.Max.X;  P1.Y := Y;

          DrawLine( P0, P1, Size_, Color_ );
     end;
end;

//------------------------------------------------------------------------------

procedure TGraphFrame.DrawScaleXs( const Color_:TAlphaColor );
var
   P0, P1 :TSingle2D;
begin
     DrawScaleX( 0.1, 0.125, Color_ );
     DrawScaleX( 0.5, 0.25 , Color_ );
     DrawScaleX( 1.0, 0.5  , Color_ );

     P0.X := 0;  P0.Y := _Range.Min.Y;
     P1.X := 0;  P1.Y := _Range.Max.Y;

     DrawLine( P0, P1, 1, Color_ );
end;

procedure TGraphFrame.DrawScaleYs( const Color_:TAlphaColor );
var
   P0, P1 :TSingle2D;
begin
     DrawScaleY( 0.1, 0.125, Color_ );
     DrawScaleY( 0.5, 0.25 , Color_ );
     DrawScaleY( 1.0, 0.5  , Color_ );

     P0.X := _Range.Min.X;  P0.Y := 0;
     P1.X := _Range.Max.X;  P1.Y := 0;

     DrawLine( P0, P1, 1, Color_ );
end;

//------------------------------------------------------------------------------

procedure TGraphFrame.DrawFunc( const Func_:TDrawFunc; const Size_:Single; const Color_:TAlphaColor );
var
   I :Integer;
   P :TSingle2D;
begin
     _Path.Clear;

     with P do
     begin
          X := _Range.Min.X;
          Y := Func_( X );
     end;

     _Path.MoveTo( PosToScr( P ) );

     for I := 1 to _DivN do
     begin
          with P do
          begin
               X := _Range.SizeX * I / _DivN + _Range.Min.X;
               Y := Func_( X );
          end;

          _Path.LineTo( PosToScr( P ) );
     end;

     with Canvas do
     begin
          Stroke.Thickness := Size_ ;
          Stroke.Color     := Color_;

          DrawPath( _Path, 1 );
     end;
end;

end. //######################################################################### ■
