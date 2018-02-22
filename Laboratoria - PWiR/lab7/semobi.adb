with Ada.Text_IO;
use Ada.Text_IO;

procedure semObi is

protected SB is
	entry Czekaj;
	procedure Sygnalizuj;
private
	Sem: Boolean := True;
end SB;


protected body SB is
entry Czekaj when Sem is
begin
	Sem := False;
end Czekaj;
procedure Sygnalizuj is
begin
	Sem := True;
end Sygnalizuj;
end SB;


task type Zadanie(N: Integer := 1);

task body Zadanie is
begin
	SB.Czekaj;
	for I in 1..10 loop
		Put_Line("Jestem w zadaniu " & N'Img);
	end loop;
	SB.Sygnalizuj;
end Zadanie;

Z1: Zadanie(1);
Z2: Zadanie(2);
Z3: Zadanie(3);
Z4: Zadanie(4);


begin
	null;
end semObi;
