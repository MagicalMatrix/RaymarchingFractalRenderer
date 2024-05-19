Projekt

Kod zrodlowy znajduje sie w folderze RayMarching (jego czesc po stronie c++)
czesc po stronie glsl znajduje sie dalej w wew. folderze Shaders

Program sklada sie z 2 glownych funkcjonalnosci

Renderowanie fractali:
Program jest w stanie renderowac dowolny fraktal, 
ktorego znamy poprawnie zdefiniowany estymator dystansu
Dzieje sie to ze wzgledu na to, ze jako argument program przyjmuje plik zawierajacy
fragment kodu obliczajacy funkcje pola dystansu szukanego ksztaltu,
dziala to wiec na zasadzie wywolania.

Pisany kod musi byc w jezyku glsl
I koniecznie musi zawierac funkcje o podanej syntaxie:
"
float CustomShape(vec3 p, vec4 s)
{
//tutaj kod fractala
}
"

Mozna tworzyc dodatkowe funkcje pomocnicze zgodne ze skladnia glsl

Jezeli program pokazuje czarne okno, oznacza to, ze shader sie nie skompilowal,
czyli prawdopodobnie uzyty blok zawiera bledy lub brakuje w nim wspomnianej funkcji

Program posiada rowniez przykladowy plik wejsciowy "mandelbulb.glsl",
pokazujacy coz.. mandelbulb'a

Prosty renderer:
gdy uruchomimy program bez argumentow uruchomi on prosta (i dostatecznie brzydka)
scene testowa z paroma prymitywnymi obiektami.
Jest to wprawdzie calkowicie oddzielny renderer posiadajacy pelna funkcjonalnosc
(dodawanie obiektow, transformacja, zmiana textur etc.)
i obsluguje do 100 obiektow
Modyfikacja wspomnianego renderera jest jednak trudna, trzeba by modyfikowac kod bezposrednio,
jest to wiec raczej zrobione na pokaz podczas prezentacji z kodem.

Obydwa elementy wykorzystuja do renderowania algorytm zwany "raymarching"
jest to technika bardzo podobna do raytracingu, aczkolwiek roznaca sie w zastosowaniu.
W raymarchingu wszystkie obiekty sa funkcjami (wspomnianymi wczesniej polami dystansu)
o takiej zaleznosci, ze w kazdym punkcie przestrzeni wynikiem funkcji jest najmniejszy
mozliwy dystans do szukanego ksztaltu

Program wysylany jest w formie calego projektu visual studio ze wzgledu na wykorzystanie bibliotek wymaganych
do uzywania opengl, w resji w jakiej byl pisany i testowany