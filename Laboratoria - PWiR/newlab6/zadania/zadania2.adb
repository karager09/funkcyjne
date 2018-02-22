-- zadania2.adb
-- trzy sposoby uruchamiania zadań
-- 1 przez specyfikację
-- 2 przez typ i deklarację zmiennej
-- 3 dynamicznie przez wskaźnik

with Ada.Text_IO;
use Ada.Text_IO;

procedure Zadania2 is
	
task Zadanie_A;

task type Zadanie_B;

Z1 : Zadanie_B;

task type Zadanie_C;
type Wsk_Zadanie_C is access Zadanie_C;

WZ2 : Wsk_Zadanie_C;

task body Zadanie_A is	
begin
  Put("P_A ");
  for I in 1..10 loop
	  Put("Z_A ");  			
  end loop;
  Put("K_A ");
end Zadanie_A;

task body Zadanie_B is
begin
  Put("P_B ");
  for I in 1..10 loop
	  Put("Z_B ");  			
  end loop;
  Put("K_B ");
end Zadanie_B;

task body Zadanie_C is
begin
  Put("P_C ");
  for I in 1..10 loop
	  Put("Z_C ");  			
  end loop;
  Put("K_C ");
end Zadanie_C;

begin
  Put("P_PG ");
  for I in 1..10 loop
  	Put("Z_PG ");  			
  end loop;
   WZ2 := new Zadanie_C;
  Put("K_PG "); 
end Zadania2;
	  	