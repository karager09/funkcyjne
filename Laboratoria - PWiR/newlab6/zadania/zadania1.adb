-- zadania1.adb

with Ada.Text_IO;
use Ada.Text_IO;

procedure Zadania1 is
	
task Zadanie_A;  
  
task type Zadanie_B is
end Zadanie_B;

Z1 : Zadanie_B;

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

begin
  Put("P_PG ");
  for I in 1..10 loop
  	Put("Z_PG ");  			
  end loop;
  Put("K_PG ");  
end Zadania1;
	  	