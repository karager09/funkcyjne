--lab3m.adb


package Pak3 is
type Wektor is array (Integer range<>) of Float;

procedure Wypisz(X:in out Wektor);
procedure WypelnijRandomowo(X:in out Wektor);
function IsSorted(V:in Wektor) return Boolean;
procedure Sort(V:in out Wektor);
procedure ZapiszDoPliku(V:in Wektor);
	

end Pak3;
