-- AUTOR :: PIOTR KARAŚ
-- grupa 3a, czw 11:00
-----------------____GOMOKU____-----------------

import Data.Matrix
import Data.Tree
import Data.List
import System.Environment
import Control.Monad.Trans.State.Lazy
import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Number
import Text.ParserCombinators.Parsec.Char
import Text.ParserCombinators.Parsec.Error
import System.IO
import Data.Maybe
import Control.Monad.IO.Class
import Data.Char
import Data.Maybe
import System.Exit

data Komorka = Kolko | Krzyzyk | Nic deriving (Eq,Ord) 

instance Show Komorka where
     show Kolko = "O"
     show Krzyzyk = "X"
     show Nic = "."


pusta = matrix 15 15 $ \ (a,b) -> Nic --początkowa, pusta plansza

---------------funkcje służące do pokazywania planszy

dodajPrzerwy [] = []
dodajPrzerwy (a:as) = show a ++" "++ (dodajPrzerwy as)

pokazKolumny :: Show a => Int -> Matrix a -> [Char] --dodaje znaki z lewej i prawej kolumny
pokazKolumny a board = if (a+1) < 10 then  "\t " ++ show (a+1) ++ "  "++dodajPrzerwy ((toLists board)!!a) ++ " "++show (a+1) ++"\n" ++ pokazKolumny (a+1) board else if a < (length (toLists board)) then  "\t" ++ show (a+1) ++ "  "++dodajPrzerwy ((toLists board)!!a) ++ " "++show (a+1) ++"\n" ++ pokazKolumny (a+1) board else []

pokazOpis = "\t    a b c d e f g h i j k l m n o \n"

pokazJakoString board = pokazOpis++"\n" ++ pokazKolumny 0 board ++"\n"++ pokazOpis

pokaz board = putStrLn ( pokazOpis++"\n" ++ pokazKolumny 0 board ++"\n"++ pokazOpis) --pokazuje plansze do gry w ładnej postaci


----------------------- tworzenie nowych hipotetycznych plansz

--możemy wstawić w miejsce obok którego znajdują się już jakieś wypełnione komórki, dzięki temu nie będzie tworzyć ogromnego drzewa przeszukiwań, tylko troszkę mniejsze

coZawieraKomorka n m board = if (n < 1) || (n > 15) || (m < 1) || (m > 15) then Nic else getElem n m board -- zwraca co zawiera komorka, jak wspolzedne poza plansza to pokazuje ze Nic

czyMaSasiada n m board 
        | ((n >= 1) && (n <= 15) && (m >= 1) && (m <= 15) && ((coZawieraKomorka (n+1) m board) /= Nic) || ((coZawieraKomorka (n+1) (m+1) board) /= Nic) || ((coZawieraKomorka (n+1) (m-1) board) /= Nic) || ((coZawieraKomorka n (m+1) board) /= Nic) || ((coZawieraKomorka n (m-1) board) /= Nic) || ((coZawieraKomorka (n-1) m board) /= Nic) || ((coZawieraKomorka (n-1) (m+1) board) /= Nic) || ((coZawieraKomorka (n-1) (m-1) board) /= Nic)) = True
        | otherwise = False   --sprawdza czy komorka ma jakiegokolwiek sasiada


czyMoznaWstawic n m board          --sprawdza czy komorka jest pusta
        | (getElem n m board == Nic) = True
        | otherwise = False

zrobListeMozliwosci board = [ (n,m) | n <- [1..15], m <- [1..15], czyMoznaWstawic n m board, czyMaSasiada n m board]--tworzy krotki wspolzednych gdzie mozna wstawic



zrobPlansze board typ lista = map (\x -> setElem typ ((fst x),(snd x)) board) lista  --robi nowe hipotetyczne plansze 

tworzMozliwePlansze board typ = zrobPlansze board typ (zrobListeMozliwosci board)    --robi nowe hipotetyczne plansze w postaci lisy


---------------------------- funkcje oceniające plansze

--działanie: funkcja oceniająca przechodzi po wszystkich komórkach w planszy i sprawdza pod kierunkami 4 wektorów ile pod rzą mamy kółek lub krzyżyków. Następnie podnosimy 15^(ile pod rząd). Jeżeli oceniamy plansze dla krzyżyków to wartości dla nich sumujemy, natomiast jeżeli trafimy na kółka to odejmujemy

ilePodRzad typ (x,y) (a,b) board = if ((coZawieraKomorka x y board) == typ) then 1 + ilePodRzad typ (x-b,y+a) (a,b) board else 0  --funkcja licząca ile znaków typu "typ" pod rząd, (a,b) to wektor po którym sprawdzamy

policzIlePodRzad typ (x,y) (a,b) board = 15 ^ (ilePodRzad typ (x,y) (a,b) board) -- do funkcji oceniającej dodajemy 15 ^ (ile znaków pod rząd)


przejdzPoWszystkichISumuj _ (15,15) _ suma = suma
przejdzPoWszystkichISumuj typ (x,y) board suma
     | coZawieraKomorka x y board == Nic = if (x < 15) then (przejdzPoWszystkichISumuj typ (x+1,y) board suma) else (przejdzPoWszystkichISumuj typ (1,y+1) board suma)
     | (x < 15) &&  (coZawieraKomorka x y board == typ) = przejdzPoWszystkichISumuj typ (x+1,y) board (suma + (policzIlePodRzad typ (x,y) (1,0) board) + (policzIlePodRzad typ (x,y) (1,-1) board) + (policzIlePodRzad typ (x,y) (0,-1) board) + (policzIlePodRzad typ (x,y) (-1,-1) board))
     | (x < 15) && (coZawieraKomorka x y board == (zmienTyp typ)) = przejdzPoWszystkichISumuj typ (x+1,y) board (suma - (policzIlePodRzad (zmienTyp typ) (x,y) (1,0) board) - (policzIlePodRzad (zmienTyp typ) (x,y) (1,-1) board) - (policzIlePodRzad (zmienTyp typ) (x,y) (0,-1) board) - (policzIlePodRzad (zmienTyp typ) (x,y) (-1,-1) board))
     | (coZawieraKomorka x y board == typ) = przejdzPoWszystkichISumuj typ (1,y+1) board (suma +   (policzIlePodRzad typ (x,y) (0,-1) board) + (policzIlePodRzad typ (x,y) (-1,-1) board))
     | otherwise = przejdzPoWszystkichISumuj typ (1,y+1) board (suma -   (policzIlePodRzad (zmienTyp typ) (x,y) (0,-1) board) + (policzIlePodRzad (zmienTyp typ) (x,y) (-1,-1) board))
--przechodzi i wyszukuje wzorców, sprawdza wektory (1,0), (1,-1), (0,-1), (-1,-1) dzieki czemu przechodzi po wszystkich mozliwosciach


ocenPlanszeCalosc typ board = przejdzPoWszystkichISumuj typ (1,1) board 0 --funkcja oceniająca, która sumuje liczbę naszych z odpowiednimi wagami i odemuje liczbe przeciwnika (z odowiednimi wagami)


--------------------- generowanie drzewa gry

zmienTyp typ --zmienia kolko na krzyzyk i odwrotnie, żeby w drzewie też szło na przemian
     | typ == Kolko = Krzyzyk
     | typ == Krzyzyk = Kolko
     | otherwise = Nic

tworzNody typ [] = []
--tworzNody (b:bs) = (Node b []):(tworzNody bs)

tworzNody typ (b:bs) = (Node b (tworzNody (zmienTyp typ) (tworzMozliwePlansze b (zmienTyp typ) ))):(tworzNody typ bs)


tworzDrzewo typ board = Node board $ tworzNody typ (tworzMozliwePlansze board typ)--tworzy NIESKONCZONE drzewo przeszukiwania


-------------- funkcje do przeszukiwania

wezRoota (Node root _) = root

wezRootaZListy [] = []
wezRootaZListy ((Node root _):reszta) = root:(wezRootaZListy reszta)

wezDzieci (Node _ []) = []
wezDzieci (Node root listaDzieci) = wezRootaZListy listaDzieci--lista dzieci

wezDzieciDrzewa (Node root listaDzieci) = listaDzieci -- zwraca liste drzew


funkcjaOceniajacaDzieci typ drzewo = map (\x -> (ocenPlanszeCalosc typ x)) (wezDzieci drzewo) -- funkcja biorąca z drzewa jego dzieci i zwracająca liste ocen tych plansz


---------------------- poprzednia wersja MINMAXa, gdzie poziom wyżej zwracana była krotka: plansza z ostaniego zagłębienia i wartość (min albo max) dla drzewa jej odpowiadającego, działała podobnie, a aktualna wygląda dużo lepiej

--minmax typ n drzewo
--     | n == 1 = ((wezMinZDrzewa typ drzewo),(wezRoota drzewo))
--     | mod n 2 == 0 = (maximum (minmaxWListe typ (n-1) (wezDzieciDrzewa drzewo)) , (wezRoota drzewo))
--     | otherwise = (minimum (minmaxWListe typ (n-1) (wezDzieciDrzewa drzewo)) , (wezRoota drzewo))

--wybierzMax typ drzewo = przeszukajListeKrotek (map (\x -> (minmax typ 3 x)) (wezDzieciDrzewa drzewo)) (-1000000,wezRoota drzewo)

--przeszukajListeKrotek [] akumulator = snd akumulator
--przeszukajListeKrotek (krotka:reszta) akumulator = if (fst krotka) > (fst akumulator) then przeszukajListeKrotek reszta krotka else przeszukajListeKrotek reszta akumulator -- wybiera największą wartość krotki i zwraca plansze dla której ona występuje
  

--minmaxWListe typ n lista = map (\x -> fst (minmax typ n x)) lista --zbiera wyniki dzieci i zamienia je w listę, z której później wybierzemy min albo max


--wezMinZDrzewa typ drzewo = minimum (funkcjaOceniajacaDzieci typ drzewo)
--wezMaksaZDrzewa typ drzewo = maximum (funkcjaOceniajacaDzieci typ drzewo)  --ocenia i zwraca największą wartość jaką udało mu się uzyskać dla dziecka
----------------------------


-----------------------   MINMAX
--

minmax typ n drzewo
     | n == 1 = maximum (funkcjaOceniajacaDzieci typ drzewo)
     | mod n 2 == 0 = minimum (map (\x -> minmax typ (n-1) x) (wezDzieciDrzewa drzewo)) 
     | otherwise = maximum (map (\x -> minmax typ (n-1) x) (wezDzieciDrzewa drzewo))
     


wywolajMinMax typ drzewo = (wezDzieci drzewo)!!(fromJust $ elemIndex (maximum lista) lista) 
     where lista = (map (\x -> (minmax typ 2 x)) (wezDzieciDrzewa drzewo))
--w liście mamy wartości z wywołanego minmaxa dla dzieci, wybieramy z nich maxa i sprawdzamy na którym miejscu on występuje, z tego miejsca pobieramy plansze i ją zwracamy
-- dla głębokości 3: wywołujemy max, min, max
--dla głębokości 4: wywołujemy max, min, max, min
--tutaj wersja z głębokością 3

------------------------------------------------------------------------

-- funkcje do parsowania wprowadzonych współrzędnych

parsePosI :: Parser Int
parsePosI = do
            x <- int
            if (x<1 || x>15) then
              unexpected "Tylko liczby od 1-15"
            else
              return x

parsePosC :: Parser Int
parsePosC = do
            x <- lower
            if (x<'a' || x>'t') then
              unexpected "Tylko znaki od a-o"
            else
              return $ (ord x) - (ord 'a') + 1

parseSinglePos =  choice [parsePosI,parsePosC]
parsePos = do
              x <- parseSinglePos
              spaces
              y <- parseSinglePos
              return (x,y)


--printHistory :: Show a => [a] -> IO ()
printHistory h =  do
  hPutStrLn stderr "Historia gry:"
  mapM_ (hPutStrLn stderr.show) $  h

type Play a = StateT [Matrix Komorka] IO a
playS :: String -> Play ()
playS i = do
  history <- get
  case parse parsePos "Parse error" i of
    Right  pos->
              let newHistory = (wywolajMinMax Kolko $ tworzDrzewo Kolko $ wstaw Krzyzyk pos (head history)):(wstaw Krzyzyk pos $ head history):history
              in (liftIO $ hPutStrLn stderr $ "ruch = " ++ (show pos) ++"\n" ++(pokazJakoString $ wstaw Krzyzyk pos $ head history))   >> (czyWygrana ( wstaw Krzyzyk pos $ head history) history) >> (liftIO $ hPutStrLn stderr (pokazJakoString $ head newHistory)) >> (czyPrzegrana (head newHistory) newHistory)
                 >> put newHistory
    Left _ -> liftIO (printHistory $ reverse history) >>= fail ("Podales zla wartosc")
-- główna pętla gry
  


doPlayS = do
     liftIO $ putStrLn "\nZaczynamy grę!! \nWygrywasz gdy będziesz miał 5 Krzyżyków pod rząd, jeśli dopuścisz do sytuacji, w której przeciwnik (kółko) będzie miał 5 pod rząd - przegrasz.\nAby wykonać ruch wpisz numer wiersza i numer kolumny oddzielając je spacjami, następnie zatwierdź klikając Enter.\nMożesz podawać wartości  1-15 lub \'a\'-\'o\'.\nPo zakończeniu gry lub wprowadzeniu nieprawidłowej wawrtości zostanie wyświetlona historia gry. \nGrasz krzyżykiem. Powodzenia. \nTwój ruch!\n"
     liftIO getContents >>= (mapM_ playS) . lines

main = evalStateT doPlayS [pusta]  --zacyznamy od pustej planszy


--------------------------------

wstaw typ (x,y) board = if getElem x y board /= Nic then wstaw typ (x,y+1) board else setElem typ (x,y) board -- jak pole w które próbowaliśmy wstawić jest zajęte to wstawia w najbliższe wolne w poziomie, bo pewnie o nie nam chodziło


--funkcje które sprawdzają czy nastąpił koniec gry, jak tak to wyświetlają odpowiednie komunikaty, pokazują historię gry i kończą program
czyWygrana board history = if sprawdzWygrana Krzyzyk board == True then (liftIO $ hPutStrLn stderr "WYGRALES!!") >> liftIO (printHistory $ reverse history) >> (liftIO $ hPutStrLn stderr "WYGRALES!!") >>= fail("brawo") else (liftIO $ hPutStrLn stderr "")

czyPrzegrana board history = if sprawdzWygrana Kolko board == True then (liftIO $ hPutStrLn stderr "PRZEGRALES!!") >> liftIO (printHistory $ reverse history) >> (liftIO $ hPutStrLn stderr "PRZEGRALES!!") >>= fail("może następnym razem się uda..") else (liftIO $ hPutStrLn stderr "")


sprawdzWygrana typ board = przejdzPoWszystkichISprawdzWygrana typ (1,1) board -- sprawdza czy "typ" już wygrał całą grę ( czy gdzieś ma 5 pod rząd)

przejdzPoWszystkichISprawdzWygrana _ (15,15) _  = False
przejdzPoWszystkichISprawdzWygrana typ (x,y) board 
     | (coZawieraKomorka x y board /= typ) = if (x < 15) then (przejdzPoWszystkichISprawdzWygrana typ (x+1,y) board) else (przejdzPoWszystkichISprawdzWygrana typ (1,y+1) board)
     | (x < 15) &&  (coZawieraKomorka x y board == typ) = if (ilePodRzad  typ (x,y) (1,0) board == 5) || (ilePodRzad typ (x,y) (1,-1) board == 5) || (ilePodRzad typ (x,y) (0,-1) board == 5) || (ilePodRzad typ (x,y) (-1,-1) board == 5) then True else (przejdzPoWszystkichISprawdzWygrana typ (x+1,y) board)
     | (coZawieraKomorka x y board == typ) = if (ilePodRzad  typ (x,y) (1,0) board == 5) || (ilePodRzad typ (x,y) (1,-1) board == 5) || (ilePodRzad typ (x,y) (0,-1) board == 5) || (ilePodRzad typ (x,y) (-1,-1) board == 5) then True else (przejdzPoWszystkichISprawdzWygrana typ (x,y+1) board)             --funkcja pomocnicza do sprawdzania czy nastąpił koniec gry



