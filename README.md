# SolveFormula
"解の公式"によって、１～４次方程式の解を計算。

![](https://github.com/LUXOPHIA/SolveFormula/raw/master/--------/_SCREENSHOT/SolveFormula.png)

### １次方程式
```
Ks1[2] * X + Ks1[1] = 0
```
```Pascal
var
   Ks  :TDouble2D;  //多項式の係数
   X1  :Double;     //解
   XsN :Byte;       //解の個数 = 0～1

Ks[1] := 1;  // 1
Ks[2] := 2;  // X

XsN := PolySolveReal( Ks, X1 );
```
### ２次方程式
```
Ks1[3] * X^2 + Ks1[2] * X + Ks1[1] = 0
```
```Pascal
var
   Ks  :TDouble2D;  //多項式の係数
   Xs  :Double;     //解の配列
   XsN :Byte;       //解の個数 = 0～2

Ks[1] := 1;  // 1
Ks[2] := 2;  // X
Ks[3] := 3;  // X^2

XsN := PolySolveReal( Ks, Xs );
```
### ３次方程式
```
Ks1[4] * X^3 + Ks1[3] * X^2 + Ks1[2] * X + Ks1[1] = 0
```
```Pascal
var
   Ks  :TDouble2D;  //多項式の係数
   Xs  :Double;     //解の配列
   XsN :Byte;       //解の個数 = 1 or 3

Ks[1] := 1;  // 1
Ks[2] := 2;  // X
Ks[3] := 3;  // X^2
Ks[4] := 4;  // X^3

XsN := PolySolveReal( Ks, Xs );
```
### ４次方程式
```
Ks1[5] * X^4 + Ks1[4] * X^3 + Ks1[3] * X^2 + Ks1[2] * X + Ks1[1] = 0
```
```Pascal
var
   Ks  :TDouble2D;  //多項式の係数
   Xs  :Double;     //解の配列
   XsN :Byte;       //解の個数 = 0～4

Ks[1] := 1;  // 1
Ks[2] := 2;  // X
Ks[3] := 3;  // X^2
Ks[4] := 4;  // X^3
Ks[5] := 5;  // X^4

XsN := PolySolveReal( Ks, Xs );
```

----
* [Wikiwand](https://www.wikiwand.com/)
    * [一次方程式](https://www.wikiwand.com/ja/%E4%B8%80%E6%AC%A1%E6%96%B9%E7%A8%8B%E5%BC%8F)
    * [二次方程式](https://www.wikiwand.com/ja/%E4%BA%8C%E6%AC%A1%E6%96%B9%E7%A8%8B%E5%BC%8F)
    * [三次方程式](https://www.wikiwand.com/ja/%E4%B8%89%E6%AC%A1%E6%96%B9%E7%A8%8B%E5%BC%8F)
    * [四次方程式](https://www.wikiwand.com/ja/%E5%9B%9B%E6%AC%A1%E6%96%B9%E7%A8%8B%E5%BC%8F)
* [初歩からのＦＦＴ](http://na-inet.jp/fft/)
    * [第7章 代数方程式の解法･･･2から4次までの代数的解法](http://na-inet.jp/fft/chap07.pdf)

[![Delphi Starter](http://img.en25.com/EloquaImages/clients/Embarcadero/%7B063f1eec-64a6-4c19-840f-9b59d407c914%7D_dx-starter-bn159.png)](https://www.embarcadero.com/jp/products/delphi/starter)
