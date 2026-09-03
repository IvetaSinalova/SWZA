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
- `mentors.yaml` - spolocny bocny text pre sekciu Mentors
- `announcements.yaml` - spolocne texty pre stavy `upcoming` a `partial`
- `statement.yaml` - zaverecny text
- `memories.yaml` - pametne YouTube videa z predchadzajucich rocnikov
- `faq.yaml` - otazky a odpovede v sekcii FAQ

### Udaje konkretneho rocnika

Udaje, ktore sa menia kazdy rok, su v:

```text
src/content/events/2026/
```

- `location.yaml` - mesto, nazov venuu (`venue`), text sekcie Location (`description`), datum zaciatku a konca eventu, link na mapu (`mapUrl`)
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
4. V `location.yaml` nastav nove datumy, mesto, `venue`, `description` a `mapUrl`.
5. V `tickets.yaml` vloz novy ticket link.
6. Aktualizuj ludi v prislusnych YAML suboroch.
7. Aktualizuj program v `schedule.yaml`.
8. Pridaj loga partnerov do `public/images/events/2027/partners/` podla kategorií nizsie.
9. V `src/content/site.yaml` zmen `activeYear` na `2027`.

Komponenty a dizajn sa nemenia. Spolocne texty v `src/content/common/` netreba kopirovat.

## Oznamy pri ludoch

V YAML subore pri ludoch nastavuj iba:

```yaml
announcementStatus: partial
```

Pouzivane hodnoty:

- `upcoming` - zatial nie su zadani ziadni ludia; zobrazi sa `ANNOUNCING SOON.`
- `partial` - niektori ludia uz su zadani, dalsi budu doplneni; zobrazi sa `MORE ANNOUNCEMENTS SOON.`
- `complete` - zoznam je kompletny a oznam sa nezobrazi

Texty pre tieto stavy su spolocne pre vsetky people sekcie a menia sa v:

```text
src/content/common/announcements.yaml
```

Po skonceni eventu sa oznamy automaticky skryju a zobrazia sa ludia z posledneho rocnika spolu s hlaskou `SEE YOU NEXT YEAR!`.

## Datum a countdown

Datum nastav v `src/content/events/2026/location.yaml`:

```yaml
start: "2026-10-09T16:00:00+02:00"
end: "2026-10-11T22:00:00+02:00"
```

Countdown sa aktualizuje automaticky. Po zaciatku eventu zostane vynulovany a zobrazi sa live hlaska s odkazom na schedule. Po skonceni eventu sa zobrazi podakovanie.

Text sekcie `LOCATION` sa tiez meni v `src/content/events/2026/location.yaml`, konkretne cez:

```yaml
venue: AT Park
description: "Event will take place in AT Park, a modern venue located just outside Žilina city center."
```

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

## FAQ

Otazky a odpovede v sekcii FAQ sa menia v spolocnom subore:

```text
src/content/common/faq.yaml
```

Kazda polozka ma `question` a `answerHtml`:

```yaml
items:
  - question: Example question?
    answerHtml: |
      <p>Example answer.</p>
```

Pre dlhsie odpovede mozes v `answerHtml` pouzit viac odsekov, zoznamy alebo zvyraznenie cez HTML tagy.

## Pametne videa

Pametne videa z predchadzajucich rocnikov sa menia v spolocnom subore:

```text
src/content/common/memories.yaml
```

Kazdy rocnik pridaj do pola `years`:

```yaml
years:
  - year: 2025
    url: https://www.youtube.com/watch?v=...
```

Stranka automaticky vytvori prepinatele rokov a pri kliknuti zobrazi iba jedno aktivne video.

## Partneri

Partneri sa nenastavuju v YAML. Stranka automaticky nacita vsetky obrazky z priecinkov aktualneho rocnika:

```text
public/images/events/2026/partners/main/
public/images/events/2026/partners/platinum/
public/images/events/2026/partners/gold/
public/images/events/2026/partners/silver/
public/images/events/2026/partners/price/
```

Loga sa zobrazia v tomto poradi:

- `main` - hlavny partner
- `platinum` - platinum partneri, zobrazia sa hned po `main`
- `gold` alebo `golden` - gold partneri
- `silver` - silver partneri
- `price` - price partneri
- ine priecinky - ostatni partneri, vzdy az za prioritnymi kategoriami

Priecinok `prize` funguje rovnako ako `price`. V ramci jednej kategorie sa loga zoradia podla nazvu suboru. Mozes pouzit `png`, `jpg`, `jpeg`, `webp`, `avif` alebo `gif`; dizajn ich automaticky zobrazi cierobielo a pri nepriehladnom obrazku vizualne potlaci biele pozadie.

Preklik na web partnera sa nastavuje v `src/pages/index.astro` v poli `partnerLinkRules`. Pravidlo sa sparuje podla casti nazvu suboru loga, napriklad `inovia`, `kros`, `goodrequest`, `aceon` alebo `tootoot`. Ak partner nema nastavenu URL, logo sa zobrazi ako neklikatelna dlazdica.

Pre novy rocnik vytvor rovnaku strukturu, napriklad:

```text
public/images/events/2027/partners/main/
public/images/events/2027/partners/platinum/
public/images/events/2027/partners/gold/
public/images/events/2027/partners/silver/
public/images/events/2027/partners/price/
```

Hviezdicka pri nadpise partnerov je spolocna pre vsetky rocniky a nachadza sa v `public/star-sponsor.png`.

### Rocna obnova partnerskeho formulara

Partnersky Google Formular a jeho odpovede treba pripravit nanovo pre kazdy rocnik. Pri prechode na novy rocnik, napriklad na 2027:

1. V Google Forms vytvor kopiu formulara z predchadzajuceho roka alebo vytvor novy formular.
2. V nazve a popise formulara zmen rok na `2027`.
3. Skontroluj, ze formular obsahuje aktualne typy partnerstva a kontaktny suhlas.
4. V zalozke `Responses` pripoj formular k novej Google Sheets tabulke, napriklad `SWZA 2027 - Partneri`.
5. Nepripajaj novy formular k tabulke z roku 2026. Kazdy rocnik ma mat vlastnu tabulku, aby sa odpovede partnerov nemiesali medzi rokmi.
6. Zapni e-mailove upozornenia na nove odpovede a otestuj formular v anonymnom okne prehliadaca.
7. Verejny odkaz na novy formular vloz do `partnerFormUrl` v `src/content/site.yaml`. Button v `src/pages/index.astro` tuto hodnotu nacita automaticky.
8. V `src/content/site.yaml` zmen `activeYear` na `2027`, aby sa rok na stranke a v partnerskom CTA aktualizoval automaticky.

Aktualny odkaz formulara je ulozeny v `src/content/site.yaml`:

```yaml
partnerFormUrl: https://docs.google.com/forms/d/e/...
```

Po vytvoreni formulara pre novy rok treba vymenit iba tuto URL; text `LET'S BUILD SWZA 2027 TOGETHER` sa na stranke vytvori automaticky z hodnoty `activeYear`.

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

Hlavna cesta nasadenia je:

```text
git push -> GitHub Actions -> Websupport
```

Workflow je v:

```text
.github/workflows/deploy.yml
```

Po pushi do branche `main` GitHub Actions spravi:

```text
npm ci
ASTRO_BASE_PATH=/preview/ npm run build
nahratie dist/ na Websupport cez FTPS
```

Pouzity deploy action:

```text
SamKirkland/FTP-Deploy-Action@v4.4.0
```

Potrebne GitHub secrets:

```text
FTP_SERVER
FTP_USERNAME
FTP_PASSWORD
FTP_SERVER_DIR
```

Pre preview ma byt `FTP_SERVER_DIR` nastavene na:

```text
startupweekendzilina.sk/web/preview
```

Preview URL:

```text
https://www.startupweekendzilina.sk/preview/
```

Astro je pripravene na deploy pod `/preview/` takto:

```text
ASTRO_BASE_PATH=/preview/
base: process.env.ASTRO_BASE_PATH || '/'
```

Ak workflow padne po FTP prihlaseni alebo tesne po `PASS`, skontroluj vo Websupporte pri FTP ucte `Geo ochrana`. GitHub runner nemusi bezat zo Slovenska, preto musi byt Geo ochrana vypnuta alebo povolena pre krajinu runnera. `IP ochrana` bola vypnuta.

Lokalny deploy cez WinSCP alebo manualne nahravanie uz nie je odporucana hlavna cesta. Cielovy flow pre tento projekt je vzdy `git push` a nasledny deploy cez GitHub Actions.
