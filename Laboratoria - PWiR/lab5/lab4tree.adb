-- lab4tree.adb

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Numerics.Discrete_Random, Interfaces;
use Ada.Text_IO, Ada.Integer_Text_IO, Interfaces;

procedure Lab4Tree is

package Random_Num is new Ada.Numerics.Discrete_Random(Integer); 
use Random_Num;


type Element is
  record 
    Data : Integer := 0;
    Left : access Element := Null;
	Right : access Element := Null;
  end record;    
  
type Elem_Ptr is access all Element;


procedure Print(Tree : access Element) is
  --L : access Element := Tree;
begin
	if Tree /= null then
		Put_Line(">" & Tree.Data'Img & "  ");Print(Tree.Left);
		
		Print(Tree.Right);
	end if;
  
end Print;  



procedure Insert_BST(Tree : in out Elem_Ptr; D : in Integer) is 
	E : Elem_Ptr := new Element'(D, null, null); 
	--Temp : Elem_Ptr;
begin
	if Tree = Null then
	  	Tree := E;
	elsif Tree.Data = D then null;
	elsif Tree.Data > D then

		if Tree.Left /= null then
			Insert_BST(Tree.Left, D);
		else 
			Tree.Left := E;
		end if;
	else
		if Tree.Right /= null then
			Insert_BST(Tree.Right, D);
		else 
			Tree.Right := E;
		end if;

	end if;
end Insert_BST;  



procedure Generuj(N : in Integer; M: in Integer; Tree : in out Elem_Ptr) is
	G : Generator;
begin
	Reset(G);
	for I in 1 .. N loop
		Insert_BST(Tree, abs(Random(G)) rem M);
	end loop;
end Generuj;




function Search(Tree : in Elem_Ptr; X : Integer) return Boolean is
begin
	if Tree = null then return False;
	elsif Tree.Data > X then return Search(Tree.Left, X);
	elsif Tree.Data < X then return Search(Tree.Right, X);
	else return True;
	end if;
end Search;



function SearchParent(Tree : in out Elem_Ptr; X : Integer) return Elem_Ptr is
begin
	if Tree = null then return null;
	elsif Tree.Data = X then return Tree;
	elsif Tree.Left /= null and then Tree.Left.Data = X then return Tree;
	elsif Tree.Right /= null and then Tree.Right.Data = X then return Tree;
	elsif Tree.Data > X then return SearchParent(Tree.Left, X);
	else --Tree.Data < X then 
		return SearchParent(Tree.Right, X);
	end if;
end SearchParent;

function FindSucc(Tree : in out Elem_Ptr) return Integer is
	Succ : Elem_Ptr;
begin
	--if Tree = null then null;
	--elsif Tree.Right = null then null;
	if Tree.Right.Left = null then return Tree.Right.Data;
	else
		Succ := Tree.Right.Left;
		while Succ.Left /=null loop
			Succ := Succ.Left;
		end loop;
		return Succ.Data;
	end if;

end FindSucc;

procedure Delete(Tree : in out Elem_Ptr; X : Integer) is
	Parent : Elem_Ptr;
	ParentSucc : Elem_Ptr;
	Temp : Elem_Ptr;
begin
	Parent := SearchParent(Tree, X);
	if Parent = null then null; --nie ma takeigo
	elsif Parent.Left /= null and then Parent.Left.Data = X then	--w lewym potomku jest wartość do usunięcia
		if Parent.Left.Left = null and Parent.Left.Right = null then Parent.Left := null;--usuwana nie ma potomkow
		elsif Parent.Left.Left /=null and Parent.Left.Right = null then Parent.Left := Parent.Left.Left; --lewy potomek
		elsif Parent.Left.Right /=null and Parent.Left.Left = null then Parent.Left := Parent.Left.Right;--prawy potomek
		else	--jeśli ma obu potomków
			ParentSucc := SearchParent(Tree, FindSucc(Parent.Left));
			if Parent.Left = ParentSucc then
				Parent.Left.Right.Left := Parent.Left.Left;
				Parent.Left := Parent.Left.Right;
			else

			Temp := ParentSucc.Left;
			ParentSucc.Left := ParentSucc.Left.Right;

			Temp.Left := Parent.Left.Left;
			Temp.Right := Parent.Left.Right;
			Parent.Left := Temp;
			end if;

		end if;				
	elsif Parent.Right /= null and then Parent.Right.Data = X then	--w prawym potomku jest wartość do usunięcia
		if Parent.Right.Left = null and Parent.Right.Right = null then Parent.Right := null;--usuwana nie ma potomkow
		elsif Parent.Right.Left /=null and Parent.Right.Right = null then Parent.Right := Parent.Right.Left; --lewy potomek
		elsif Parent.Right.Right /=null and Parent.Right.Left = null then Parent.Right := Parent.Right.Right;--prawy potomek
		else	--jeśli ma obu potomków
			ParentSucc := SearchParent(Tree, FindSucc(Parent.Right));
			if Parent.Right = ParentSucc then
				Parent.Right.Left.Right := Parent.Right.Right;
				Parent.Right := Parent.Right.Left;
			else

			Temp := ParentSucc.Left;
			ParentSucc.Left := ParentSucc.Left.Right;

			Temp.Left := Parent.Right.Left;
			Temp.Right := Parent.Right.Right;
			Parent.Right := Temp;	
			end if;
			
		end if;
	else 	--usuwany wezeł to główny węzeł - drzewo
		if Parent.Left = null and Parent.Right = null then Tree := null;--usuwana nie ma potomkow
		elsif Parent.Left /=null and Parent.Right = null then Tree:= Parent.Left; --lewy potomek
		elsif Parent.Right /=null and Parent.Left = null then Tree := Parent.Right;--prawy potomek
		else	--jeśli ma obu potomków
			ParentSucc := SearchParent(Tree, FindSucc(Parent));
			if Parent = ParentSucc then	--jesli nastepca jest od razu ten po prawej
				Temp := Parent.Right;
				Temp.Left := Parent.Left;
				Tree := Temp;
			else
				Temp := ParentSucc.Left;
				ParentSucc.Left := ParentSucc.Left.Right;
	
				Temp.Left := Parent.Left;
				Temp.Right := Parent.Right;
				Tree := Temp;
			end if;	
		end if;

	end if;
end Delete;


procedure RotR(Drzewo: in out Elem_Ptr) is
NewRoot : Elem_Ptr;
begin
	if Drzewo = null then null;
	elsif Drzewo.Left = null then null;
	else
		NewRoot := Drzewo.Left;
		Drzewo.Left := Drzewo.Left.Right;
		NewRoot.Right := Drzewo;
		Drzewo := NewRoot;
		
	end if;
end RotR;


procedure RotL(Drzewo: in out Elem_Ptr) is
NewRoot : Elem_Ptr;
begin
	if Drzewo = null then null;
	elsif Drzewo.Right = null then null;
	else
		NewRoot := Drzewo.Right;
		Drzewo.Right := Drzewo.Right.Left;
		NewRoot.Left := Drzewo;
		Drzewo := NewRoot;
		
	end if;
end RotL;

function Wyznacz2Log(Xx : in Integer) return Integer is
y : Integer;
x : Integer;
begin
	x := Xx;	
	y := 1;
	x := x / 2;
	while x > 0 loop
		y := y * 2;
		x := x / 2;
	end loop;
	return y;
end Wyznacz2Log;

procedure Rownowaz(Drzewo: in out Elem_Ptr) is
LicznikWezlow : Integer := 0;
Temp : Elem_Ptr;
Parent : Elem_Ptr;
LiczbaLisci : Integer;
begin
	while Drzewo /= null and then Drzewo.Left /= null loop
		rotR(Drzewo);
	end loop;
	LicznikWezlow := LicznikWezlow + 1;
	Parent := Drzewo;
	Temp := Drzewo.Right;

	while Temp /= null loop	
		if Temp.Left /= null then
			rotR(Temp);
		else
			LicznikWezlow := LicznikWezlow + 1;
			Parent.Right := Temp;
			Parent := Temp;	
			Temp := Temp.Right;
		end if;
	end loop;


	LiczbaLisci := LicznikWezlow + 1 - Wyznacz2Log(LicznikWezlow + 1);


	Temp := Drzewo;
	Parent := Drzewo;
	for I in 1..LiczbaLisci loop
		if Parent = Temp then
			rotL(Temp);
			Drzewo := Temp;
		else
			Parent := Temp;
			Temp := Temp.Right.Right;
			rotL(Temp);
			Parent.Right := Temp;
		end if; 
	end loop;

	


end Rownowaz;




Drzewo : Elem_Ptr ;--:= new Element'(5,null, null);

begin

	Generuj(10, 11, Drzewo);

Print(Drzewo);

Rownowaz(Drzewo);
Put_Line("################");
Print(Drzewo);
--Put_Line(Wyznacz2Log(20)'Img);
--Put_Line(Search(Drzewo, 5)'Img);

--Delete(Drzewo, 5);
--Print(Drzewo);
--Put_Line(Search(Drzewo, 5)'Img & "\n");
--RotL(Drzewo);
--Print(Drzewo);

end Lab4Tree;
