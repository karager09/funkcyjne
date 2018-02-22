with Ada.Text_IO, Ada.Numerics.Float_Random,Ada.Numerics.Discrete_Random;
use Ada.Text_IO, Ada.Numerics.Float_Random;

procedure Zad1 is

type Kolory is (Bialy, Zolty, Czerwony, Zielony, Niebieski, Czarny);
type DniTygodnia is (Poniedzialek, Wtorek, Sroda, Czwartek, Piatek, Sobota, Niedziela);
type TablicaLiczb is array(1..6) of Integer;


task Losuj is
entry Los(X:in out Float);
entry LosKol(Kol:in out Kolory);
entry LosDni(Dzien: in out DniTygodnia);
entry LosTablica(Table: in out TablicaLiczb);
end Losuj;



task body Losuj is
package Los_Kolor is new Ada.Numerics.Discrete_Random(Kolory);
package LosDniTygodnia is new Ada.Numerics.Discrete_Random(DniTygodnia);
package Los_Liczby is new Ada.Numerics.Discrete_Random(Integer);

Gen: Generator;
GenKol: Los_Kolor.Generator;
GenDni: LosDniTygodnia.Generator;
GenInteger: Los_Liczby.Generator;
begin
loop
select
	accept Los(X: in out Float) do
		Reset(Gen);
   		X := 5.0 * Random(Gen);
	end Los;
	
	or

	accept LosKol(Kol: in out Kolory) do
		Los_Kolor.Reset(GenKol);
		Kol := Los_Kolor.Random(GenKol);
	end LosKol;

	or
	
	accept LosDni(Dzien: in out DniTygodnia) do
		LosDniTygodnia.Reset(GenDni);
		Dzien := LosDniTygodnia.Random(GenDni);
	end LosDni;
	
	or

	accept LosTablica(Table: in out TablicaLiczb) do
		Los_Liczby.Reset(GenInteger);
		for I in TablicaLiczb'Range loop
			Table(I) := abs(Los_Liczby.Random(GenInteger)) rem 50;

		end loop;
	
	end LosTablica;

	end select;
end loop;
end Losuj;





Wylosowana : Float :=0.0;
Kol: Kolory := Zielony;
Dzien: DniTygodnia;
Table: TablicaLiczb;
begin
	--for I in 1..10 loop
	Losuj.Los(Wylosowana);
	Put_Line(Wylosowana'Img);

	Losuj.LosKol(Kol);
	Put_Line(Kol'Img);
	Losuj.LosDni(Dzien);
	Put_Line(Dzien'Img);

	Losuj.LosTablica(Table);
	Put_Line(Table(1)'Img &" ,"& Table(2)'Img&", "&Table(3)'Img &" ,"& Table(4)'Img&", "&Table(5)'Img &" ,"& Table(6)'Img);

--end loop;
	
end Zad1;
