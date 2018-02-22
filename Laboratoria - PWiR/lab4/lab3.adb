-- lab3.adb

with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Calendar;
use Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Calendar;

procedure Lab3 is
	T1, T2: Time; -- czasy bezwzgledne
  	D: Duration;  -- czas względny, 
	type Wektor is array (Integer range<>) of Float;
	W1: Wektor(1 .. 10) := (others => 4.0) ;
	
	
procedure Wypisz(X: in out Wektor) is
begin
	for element of X
	loop
		Put_Line(element'Img);
	end loop;
end Wypisz;
	

procedure WypelnijRandomowo(X: in out Wektor) is
	Gen: Generator;
begin
	Reset(Gen);
	for element of X loop
		element := Random(Gen);
	end loop;
end WypelnijRandomowo;
	

function IsSorted(V: in Wektor) return Boolean is
	(for all i in V'First .. (V'Last - 1) => V(i) <= V(i+1));

procedure Sort(V: in out Wektor) is
Temp : Float;
begin
	for i in V'First .. V'Last - 1 loop
		for j in V'First .. V'Last - i loop
			if V(j) > V(j +1) then
				Temp := V(j);
				V(j) := V(j+1);
				V(j+1) := Temp; 
			end if;
		end loop;

	end loop;
end Sort;


procedure ZapiszDoPliku(V1: in Wektor) is
	Pl : File_Type;
 	Nazwa: String := "wektor.txt";	
begin
	Create(Pl, Out_File, Nazwa); -- Open
	Put_Line(Pl,"Nasz wektor:");
	for I of V1 loop
		Put_Line(Pl,I'Img);
	end loop;	   
	Close(Pl);
end ZapiszDoPliku;
	
begin
	T1 := Clock;
	
	WypelnijRandomowo(W1);

	Sort(W1);
	Wypisz(W1);
	if IsSorted(W1) then
		Put_Line("Tablica jest posortowana");
	else 
		Put_Line("Tablica NIE jest posortowana");
	end if;

	ZapiszDoPliku(W1);
	

	T2 := Clock;
	D := T2 - T1;
	Put_Line("Czas obliczen = " & D'Img & "[s]");
	
end Lab3;
