-- lab3m.adb

with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Calendar, Pak3;
use Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Calendar, Pak3;



package body Pak3 is



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


procedure ZapiszDoPliku(V: in Wektor) is
	Pl : File_Type;
 	Nazwa: String := "wektor.txt";	
begin
	Create(Pl, Out_File, Nazwa); -- Open
	Put_Line(Pl,"Nasz wektor:");
	for I of V loop
		Put_Line(Pl,I'Img);
	end loop;	   
	Close(Pl);
end ZapiszDoPliku;


end Pak3;
