-- lab3m.adb

--with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Calendar, Pak3;
--use Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Calendar, Pak3;

with Ada.Text_IO, Ada.Calendar, Pak3;
use Ada.Text_IO, Ada.Calendar, Pak3;

procedure Lab3m is
	T1, T2: Time; -- czasy bezwzgledne
  	D: Duration;  -- czas względny, 
--	type Wektor is array (Integer range<>) of Float;
	W1: Wektor(1 .. 10) := (others => 4.0) ;
	
	

	
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
	
end Lab3m;
