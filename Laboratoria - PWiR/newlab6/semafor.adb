with Ada.Text_IO;
use Ada.Text_IO;




procedure Semafor is


task Sem is
entry CzekajAzWolny;
entry Zwolnij;
end Sem;

task type Zadanie(N: Integer := 1); 
-- parametr N <- wyróżnik

task body Sem is
czyWolny : Boolean := True;
begin
	loop
	select
		accept CzekajAzWolny do
			if czyWolny then
				czyWolny := False;
				Put_Line(czyWolny'Img);
			else
				L:
				while czyWolny = False loop
					null;
				end loop L;
				czyWolny := False;
				
			end if;
		end CzekajAzWolny;

		accept Zwolnij do
			czyWolny := True;
			Put_Line(czyWolny'Img);
		end Zwolnij;

	end select;
	end loop;
end Sem;


task body Zadanie is
begin
	Sem.CzekajAzWolny;
	for I in 1..3 loop
		Put_Line("Jestem w zadaniu " & N'Img);
	end loop;
	Sem.Zwolnij;
end Zadanie;

Z1: Zadanie(1);
Z2: Zadanie(2);
Z3: Zadanie(3);
Z4: Zadanie(4);
begin
	null;


end Semafor;
