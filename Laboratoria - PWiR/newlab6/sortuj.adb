with Ada.Text_IO,Ada.Numerics.Discrete_Random;
use Ada.Text_IO;


procedure Sortuj is

package Los_Liczby is new Ada.Numerics.Discrete_Random(Integer);
  use Los_Liczby;

type TablicaLiczb is array(Integer range <>) of Integer;
type Wsk_TablicaLiczb is access TablicaLiczb;

task type SortujCzesc(Table: access TablicaLiczb);
type Wsk_Sortuj is access SortujCzesc;

task body SortujCzesc is
Temp : Integer;
begin

	for i in Table.all'First .. Table.all'Last - 1 loop
		for j in Table.all'First .. Table.all'Last - i loop
			if Table.all(j) > Table.all(j +1) then
				Temp := Table.all(j);
				Table.all(j) := Table.all(j+1);
				Table.all(j+1) := Temp; 
			end if;
		end loop;

	end loop;
end SortujCzesc;


procedure Wypisz(X: in out TablicaLiczb) is
begin
	for element of X
	loop
		Put_Line(element'Img);
	end loop;
end Wypisz;
	

procedure WypelnijRandomowo(X: in out TablicaLiczb) is
	Gen: Generator;
begin
	Reset(Gen);
	for element of X loop
		element := abs(Random(Gen)) rem 10000 ;
	end loop;
end WypelnijRandomowo;


type PodzTablice_typ is array(Integer range<>) of access TablicaLiczb;


function Merge(Pierwsza: access TablicaLiczb; Druga: access TablicaLiczb) return access TablicaLiczb is
Zlaczona: access TablicaLiczb;
A,B:Integer :=1;
begin
	Zlaczona := new TablicaLiczb(1..Pierwsza.all'Length+Druga.all'Length);
	
	
	for I in 1..Zlaczona.all'Last loop
		if Pierwsza.all'Last < A  then
			Zlaczona.all(I) := Druga.all(B);
			B:=B+1;
		elsif Druga.all'Last < B then
			Zlaczona.all(I) := Pierwsza.all(A);
			A := A+1;
		elsif Pierwsza.all(A) > Druga.all(B) then
			Zlaczona.all(I) := Druga.all(B);
			B:=B+1;
		else 
			Zlaczona.all(I) := Pierwsza.all(A);
			A := A+1;
		end if;
	end loop;

	return Zlaczona;
end Merge;


function MergeAll(PodzieloneTablice: in out PodzTablice_typ) return access TablicaLiczb is
Zlaczona: access TablicaLiczb;
begin
	Zlaczona := PodzieloneTablice(1);
	for I in PodzieloneTablice'First+1..PodzieloneTablice'Last loop
		Zlaczona := Merge(Zlaczona,PodzieloneTablice(I));

	end loop;
return Zlaczona;
end MergeAll;



Table: access TablicaLiczb;
--Z1: Wsk_Sortuj;
IloscPodzialow: Integer := 100;
Zadania: array(1..IloscPodzialow) of Wsk_Sortuj;
DlugoscTablicy: Integer := 10000;
TempTablica: access TablicaLiczb;
PodzieloneTablice: PodzTablice_typ(1..IloscPodzialow);
Temp: Integer;
begin

	Table := new TablicaLiczb(1..DlugoscTablicy);
	WypelnijRandomowo(Table.all);
	Wypisz(Table.all);
	Put_Line("");
	
	--dziele tablice na ilestam czesci, w zaleznosci od N
	for I in 1..IloscPodzialow loop
		Temp := 1 + (DlugoscTablicy*I/IloscPodzialow) - (DlugoscTablicy*(I-1)/IloscPodzialow+1);
		PodzieloneTablice(I) := new TablicaLiczb(1..Temp);
		PodzieloneTablice(I).all(1..Temp) := Table.all((DlugoscTablicy*(I-1)/IloscPodzialow+1)..(DlugoscTablicy*I/IloscPodzialow));

	end loop; 

	--dla kazdej tablicy wywoluje funkcje sortujaca
	for I in 1..IloscPodzialow loop
		Zadania(I) := new SortujCzesc(PodzieloneTablice(I));
	end loop;

	TempTablica := MergeAll(PodzieloneTablice);
	Wypisz(TempTablica.all);

end Sortuj;
