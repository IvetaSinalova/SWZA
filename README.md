# Startup Weekend Zilina

Staticka Astro stranka podla Figma navrhu. Obsah je oddeleny od komponentov, aby sa dal menit bez zasahu do layoutu.

## Kde menit obsah

### Spolocne texty

Texty, ktore zostavaju rovnake pre vsetky rocniky, su v:

```text
src/content/common/
```

Patria sem:

- `hero.yaml` - titulok, texty vo Welcome sekcii a stavove hlasky
- `about.yaml` - About sekcia
- `essence.yaml` - hlavny text a doplnkovy text v Essence
- `benefits.yaml` - Benefits / What we provide
- `statement.yaml` - zaverecny text

### Udaje konkretneho rocnika

Udaje, ktore sa menia kazdy rok, su v:

```text
src/content/events/2026/
```

- `location.yaml` - mesto, rok, datum zaciatku a konca eventu
- `tickets.yaml` - ticket / registracny odkaz
- `mentors.yaml` - mentori
- `kids-mentors.yaml` - kids mentori
- `judges.yaml` - judges
- `facilitator.yaml` - facilitator
- `schedule.yaml` - detailny program podla dni a casov

Aktualny rocnik sa nastavuje v:

```text
src/content/site.yaml
```

```yaml
activeYear: 2026
```

Vsetky zobrazene roky na stranke sa odvadzaju z tejto hodnoty a z priecinka aktualneho rocnika. Ked je `activeYear: 2026`, stranka nacita data zo `src/content/events/2026/` a automaticky zobrazi napriklad `MENTORS (2026)`, `JUDGES (2026)`, `FACILITATOR (2026)` a `SCHEDULE 2026`. Rok preto netreba pisat do jednotlivych YAML suborov.

## Pridanie noveho rocnika

1. Vytvor priecinok `src/content/events/2027/`.
2. Vytvor priecinok `public/images/events/2027/` s podpriecinkami pre fotky ludi noveho rocnika.
3. Skopiruj do noveho content priecinka `location.yaml`, `tickets.yaml`, `mentors.yaml`, `kids-mentors.yaml`, `judges.yaml`, `facilitator.yaml` a `schedule.yaml`.
4. V `location.yaml` nastav nove datumy, mesto a rok.
5. V `tickets.yaml` vloz novy ticket link.
6. Aktualizuj ludi v prislusnych YAML suboroch.
7. Aktualizuj program v `schedule.yaml`.
8. V `src/content/site.yaml` zmen `activeYear` na `2027`.

Komponenty a dizajn sa nemenia. Spolocne texty v `src/content/common/` netreba kopirovat.

## Oznamy pri ludoch

V YAML subore mozes nastavit:

```yaml
announcementStatus: partial
announcementText: MORE ANNOUNCEMENTS SOON.
```

Pouzivane hodnoty:

- `partial` - niektori ludia uz su zadani, dalsi budu doplneni; zobrazi sa `MORE ANNOUNCEMENTS SOON.`
- `partial` bez ludi - zobrazi sa `ANNOUNCING SOON.`
- `upcoming` - zatial nie su zadani ziadni ludia; oznam sa nezobrazi
- `complete` - zoznam je kompletny a oznam sa nezobrazi

Po skonceni eventu sa oznamy automaticky skryju a zobrazia sa ludia z posledneho rocnika spolu s hlaskou `SEE YOU NEXT YEAR!`.

## Datum a countdown

Datum nastav v `src/content/events/2026/location.yaml`:

```yaml
start: "2026-10-09T16:00:00+02:00"
end: "2026-10-11T22:00:00+02:00"
```

Countdown sa aktualizuje automaticky. Po zaciatku eventu zostane vynulovany a zobrazi sa live hlaska s odkazom na schedule. Po skonceni eventu sa zobrazi podakovanie.

## Ako upravit Schedule

Program aktualneho rocnika sa upravuje v:

```text
src/content/events/2026/schedule.yaml
```

Pre iny rocnik pouzi rovnaky subor v jeho priecinku, napriklad `src/content/events/2027/schedule.yaml`.

Zakladne polia suboru:

- `heading` - hlavny nadpis sekcie
- `intro` - maly text vpravo hore
- `utcOffset` - casove pasmo eventu, pre Slovensko pocas letneho casu `+02:00`
- `days` - zoznam jednotlivych dni programu

Rok pri nadpise sa odvodi automaticky z priecinka aktualneho rocnika, napriklad zo `src/content/events/2026/`. Netreba ho pisat do `schedule.yaml`.

Kazdy den obsahuje:

- `name` - nazov dna, napriklad `FRIDAY`
- `items` - aktivity daneho dna

Datum a zobrazovany label dna sa odvodi automaticky zo `start` v `location.yaml` a poradia dni v `schedule.yaml`. Prvy den programu pouzije datum zaciatku eventu, druhy den je +1 den, treti den +2 dni. Preto pri zmene terminu eventu aktualizuj datum v `location.yaml`, nie v `schedule.yaml`.

Priklad jednej aktivity:

```yaml
- time: "17:00"
  end: "17:45"
  title: WELCOME
  location: MAIN HALL
  access: OPEN TO PUBLIC
```

Vyznam poli aktivity:

- `time` - cas zaciatku
- `end` - cas konca; stranka pomocou `time` a `end` automaticky zvyrazni prave prebiehajucu aktivitu
- `title` - nazov aktivity
- `location` - miesto konania; pole je volitelne
- `access` - volitelny zeleny stitok, napriklad `OPEN TO PUBLIC`

Pri zmene datumov programu aktualizuj `start` a `end` v `location.yaml`, aby spravne fungoval countdown, live stav celeho eventu a datumy dni v schedule.

## Welcome sekcia

Welcome sekcia obsahuje navbar, titulok, kolaz fotografii, odpočet a automaticke hlasky pre upcoming, live a past stav eventu. Waitlist formular, avatary, pocet prihlasenych ani calendar link sa na stranke nepouzivaju.

## Fotografie

Aktualne obrazky su v:

```text
public/images/home/welcome/
public/images/home/about/
public/images/home/about/gallery/
public/images/events/2026/mentors/
public/images/events/2026/judges/
public/images/events/2026/facilitator/
```

`welcome`, `about` a `about/gallery` su spolocne pre viac rocnikov, preto zostavaju v `public/images/home/`. Pri mentoroch, judgoch a facilitatorovi sa fotka nastavuje v ich YAML subore v poli `image`. Do YAML staci napisat nazov suboru, rok a spravny priecinok doplni stranka automaticky podla `activeYear`. Galeria v About automaticky nacita vsetky obrazky z `public/images/home/about/gallery/` a na stranke zobrazi prve styri.

Pre ludi v novom rocniku pouzi rovnaku strukturu s novym rokom:

```text
public/images/events/2027/mentors/
public/images/events/2027/judges/
public/images/events/2027/facilitator/
```

Welcome a hlavne About fotky sa zdielaju medzi rocnikmi. Ak ich chces zmenit globalne, zachovaj tieto nazvy suborov:

```text
public/images/home/welcome/speaker.jpg
public/images/home/welcome/collaboration.jpg
public/images/home/welcome/team.jpg
public/images/home/welcome/workshop.jpg
public/images/home/about/participant.jpg
public/images/home/about/audience.jpg
```

### Fotky mentorov

Fotky mentorov ukladaj do:

```text
public/images/events/2026/mentors/
```

V `src/content/events/2026/mentors.yaml` potom pri konkretnom mentorovi nastav cestu v poli `image` takto:

```yaml
- name: Martin Nemecek
  country: Yes Hi Hello
  role: Fractional Innovation Manager
  image: Martin-Nemecek.jpg
  text: Tech and business consultant focused on practical AI solutions and turning ideas into real operations.
```

Dolezite je, aby nazov suboru v priecinku presne sedel s hodnotou v YAML. Ak je fotka ulozena ako `public/images/events/2026/mentors/Martin-Nemecek.jpg`, v YAML sa zapisuje iba `Martin-Nemecek.jpg`.

Rovnaky princip plati aj pre judges a facilitator:

```text
src/content/events/2026/judges.yaml       -> public/images/events/2026/judges/
src/content/events/2026/facilitator.yaml  -> public/images/events/2026/facilitator/
```

## Lokalne spustenie

V terminali otvor priecinok projektu:

```powershell
cd C:\Users\GLOBESY\Desktop\SWZA
npm install
npm run dev
```

Potom otvor `http://localhost:4321`.

Produkčný build a lokálny preview:

```powershell
npm run build
npm run preview
```

## Nasadenie

GitHub Actions je nastavene bezpecne iba na kontrolu buildu. Pri kazdom pushi do branche `main` sa spusti:

```powershell
npm ci
npm run build
```

Samotne nahratie na Websupport sa spusta lokalne z tvojho PC. Je to bezpecnejsie ako self-hosted runner v public GitHub repozitari a zaroven to obchadza problem, ze Websupport FTP odmieta GitHub hosted runnery.

### Lokalny deploy na Websupport

V terminali otvor projekt:

```powershell
cd C:\Users\GLOBESY\Desktop\SWZA
```

Spusti:

```powershell
npm run deploy
```

Skript sa spyta na:

- `FTP server` - napriklad `startupweekendzilina.sk`
- `FTP username` - FTP prihlasovacie meno z Websupportu
- `FTP password` - aktualne FTP heslo
- `FTP target directory` - cielovy priecinok na hostingu

Pre preview pouzi cielovy priecinok:

```text
/startupweekendzilina.sk/web/preview/
```

Pre produkciu pouzi:

```text
/startupweekendzilina.sk/web/
```

Skript najprv spusti `npm run build`, potom overi FTP prihlasenie a nahra obsah priecinka `dist/` na Websupport.

Ak nechces zadavat udaje pri kazdom spusteni, mozes ich pred deployom nastavit iba v aktualnom terminali:

```powershell
$env:FTP_SERVER = "startupweekendzilina.sk"
$env:FTP_USERNAME = "tvoje-ftp-meno"
$env:FTP_PASSWORD = "tvoje-ftp-heslo"
$env:FTP_SERVER_DIR = "/startupweekendzilina.sk/web/preview/"
npm run deploy
```

Tieto hodnoty sa ulozia iba pre otvorene terminalove okno, nie do projektu.
