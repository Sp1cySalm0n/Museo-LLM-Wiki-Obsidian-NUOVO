# ============================================================
# REBUILD NOTION - MUSEO CIUPPA TASCA
# Script completo per ricostruire il workspace da zero
# ============================================================

$Token = "[INSERISCI IL TUO TOKEN NOTION QUI O LEGGI DA CREDENZIALI.MD]"
$ParentPageId = "331f270b-cab3-80bc-8f86-d66e12d1d552"

$Headers = @{
    "Authorization"  = "Bearer $Token"
    "Content-Type"   = "application/json; charset=utf-8"
    "Notion-Version" = "2022-06-28"
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Notion-Post {
    param([string]$Endpoint, [string]$JsonBody)
    
    $uri = "https://api.notion.com/v1/$Endpoint"
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($JsonBody)
    
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $Headers -Body $bodyBytes
        return $response
    }
    catch {
        Write-Host "ERRORE su $Endpoint : $($_.ErrorDetails.Message)" -ForegroundColor Red
        return $null
    }
}

function Notion-Patch {
    param([string]$Endpoint, [string]$JsonBody)
    
    $uri = "https://api.notion.com/v1/$Endpoint"
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($JsonBody)
    
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Patch -Headers $Headers -Body $bodyBytes
        return $response
    }
    catch {
        Write-Host "ERRORE PATCH su $Endpoint : $($_.ErrorDetails.Message)" -ForegroundColor Red
        return $null
    }
}

function Notion-Get {
    param([string]$Endpoint)
    
    $uri = "https://api.notion.com/v1/$Endpoint"
    
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $Headers
        return $response
    }
    catch {
        Write-Host "ERRORE GET su $Endpoint : $($_.ErrorDetails.Message)" -ForegroundColor Red
        return $null
    }
}

# Helper: crea un blocco paragrafo (max 2000 caratteri per blocco API)
function Make-Paragraph {
    param([string]$Text)
    
    # Escape JSON special chars
    $escaped = $Text.Replace('\', '\\').Replace('"', '\"').Replace("`n", '\n').Replace("`r", '').Replace([char]0x0009, '    ')
    
    return @"
{
  "object": "block",
  "type": "paragraph",
  "paragraph": {
    "rich_text": [{"type": "text", "text": {"content": "$escaped"}}]
  }
}
"@
}

function Make-Heading2 {
    param([string]$Text)
    $escaped = $Text.Replace('\', '\\').Replace('"', '\"')
    return @"
{
  "object": "block",
  "type": "heading_2",
  "heading_2": {
    "rich_text": [{"type": "text", "text": {"content": "$escaped"}}]
  }
}
"@
}

function Make-Heading3 {
    param([string]$Text)
    $escaped = $Text.Replace('\', '\\').Replace('"', '\"')
    return @"
{
  "object": "block",
  "type": "heading_3",
  "heading_3": {
    "rich_text": [{"type": "text", "text": {"content": "$escaped"}}]
  }
}
"@
}

function Make-Callout {
    param([string]$Text, [string]$Emoji, [string]$Color = "gray_background")
    $escaped = $Text.Replace('\', '\\').Replace('"', '\"').Replace("`n", '\n').Replace("`r", '')
    return @"
{
  "object": "block",
  "type": "callout",
  "callout": {
    "rich_text": [{"type": "text", "text": {"content": "$escaped"}}],
    "icon": {"type": "emoji", "emoji": "$Emoji"},
    "color": "$Color"
  }
}
"@
}

function Make-Divider {
    return '{"object":"block","type":"divider","divider":{}}'
}

function Make-BulletItem {
    param([string]$Text)
    $escaped = $Text.Replace('\', '\\').Replace('"', '\"').Replace("`n", '\n').Replace("`r", '')
    return @"
{
  "object": "block",
  "type": "bulleted_list_item",
  "bulleted_list_item": {
    "rich_text": [{"type": "text", "text": {"content": "$escaped"}}]
  }
}
"@
}

function Make-NumberedItem {
    param([string]$Text)
    $escaped = $Text.Replace('\', '\\').Replace('"', '\"').Replace("`n", '\n').Replace("`r", '')
    return @"
{
  "object": "block",
  "type": "numbered_list_item",
  "numbered_list_item": {
    "rich_text": [{"type": "text", "text": {"content": "$escaped"}}]
  }
}
"@
}

function Make-Quote {
    param([string]$Text)
    $escaped = $Text.Replace('\', '\\').Replace('"', '\"').Replace("`n", '\n').Replace("`r", '')
    return @"
{
  "object": "block",
  "type": "quote",
  "quote": {
    "rich_text": [{"type": "text", "text": {"content": "$escaped"}}]
  }
}
"@
}

function Make-TOC {
    return '{"object":"block","type":"table_of_contents","table_of_contents":{"color":"default"}}'
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  REBUILD NOTION - MUSEO CIUPPA TASCA" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# FASE 0: ARCHIVIARE IL VECCHIO BACKEND
# ============================================================
Write-Host "[FASE 0] Pulizia vecchio Backend..." -ForegroundColor Yellow

$oldBackendId = "331f270b-cab3-81db-bd5a-deacdbe513f6"
$archiveJson = '{"archived": true}'
$archiveResult = Notion-Patch -Endpoint "pages/$oldBackendId" -JsonBody $archiveJson
if ($archiveResult) {
    Write-Host "  -> Vecchio Backend archiviato con successo" -ForegroundColor Green
} else {
    Write-Host "  -> Backend gia' rimosso o non trovato, proseguo" -ForegroundColor Yellow
}

Start-Sleep -Seconds 1

# ============================================================
# FASE 1: CREARE IL NUOVO BACKEND
# ============================================================
Write-Host ""
Write-Host "[FASE 1] Creazione nuovo Backend..." -ForegroundColor Yellow

$backendJson = @"
{
  "parent": {"type": "page_id", "page_id": "$ParentPageId"},
  "icon": {"type": "emoji", "emoji": "\u2699\uFE0F"},
  "properties": {
    "title": {"title": [{"text": {"content": "BACKEND MUSEO"}}]}
  },
  "children": [
    $(Make-Callout -Text "Questa pagina contiene i database master del museo. Non modificare la struttura. Per lavorare, usa la Dashboard HQ." -Emoji "⚠️" -Color "yellow_background")
  ]
}
"@

$backendRes = Notion-Post -Endpoint "pages" -JsonBody $backendJson
if (-not $backendRes) { Write-Host "FATAL: impossibile creare Backend. Esco." -ForegroundColor Red; exit }
$BackendId = $backendRes.id
Write-Host "  -> Backend creato: $BackendId" -ForegroundColor Green

Start-Sleep -Seconds 1

# ============================================================
# FASE 2: CREAZIONE DEI 4 DATABASE MASTER
# ============================================================
Write-Host ""
Write-Host "[FASE 2] Creazione Database Master..." -ForegroundColor Yellow

# --- DB 1: Appuntamenti ---
$db1Json = @"
{
  "parent": {"type": "page_id", "page_id": "$BackendId"},
  "icon": {"type": "emoji", "emoji": "\uD83D\uDCC5"},
  "title": [{"type": "text", "text": {"content": "DB Appuntamenti"}}],
  "properties": {
    "Nome Prenotazione": {"title": {}},
    "Data e Ora": {"date": {}},
    "Email Cliente": {"email": {}},
    "Telefono": {"phone_number": {}},
    "Tipologia": {"select": {"options": [
      {"name": "Visita Guidata", "color": "green"},
      {"name": "Laboratorio Saponi", "color": "orange"},
      {"name": "Evento Outdoor", "color": "blue"},
      {"name": "Scuola / Gruppo", "color": "purple"},
      {"name": "Degustazione", "color": "yellow"}
    ]}},
    "Stato": {"select": {"options": [
      {"name": "Nuova Prenotazione", "color": "blue"},
      {"name": "Confermato", "color": "green"},
      {"name": "Concluso", "color": "gray"},
      {"name": "Annullato", "color": "red"}
    ]}},
    "Numero Persone": {"number": {"format": "number"}},
    "Link Gestione Luma": {"url": {}},
    "Note": {"rich_text": {}}
  }
}
"@
$db1Res = Notion-Post -Endpoint "databases" -JsonBody $db1Json
if ($db1Res) { Write-Host "  -> DB Appuntamenti creato" -ForegroundColor Green }

Start-Sleep -Milliseconds 500

# --- DB 2: CRM Contatti ---
$db2Json = @"
{
  "parent": {"type": "page_id", "page_id": "$BackendId"},
  "icon": {"type": "emoji", "emoji": "\uD83E\uDD1D"},
  "title": [{"type": "text", "text": {"content": "DB CRM Contatti"}}],
  "properties": {
    "Nome / Ente": {"title": {}},
    "Categoria": {"select": {"options": [
      {"name": "Scuola", "color": "blue"},
      {"name": "Partner", "color": "purple"},
      {"name": "Cliente", "color": "green"},
      {"name": "Istituzione", "color": "red"},
      {"name": "Media / Stampa", "color": "orange"},
      {"name": "Tour Operator", "color": "yellow"}
    ]}},
    "Email": {"email": {}},
    "Telefono": {"phone_number": {}},
    "Stato Contatto": {"select": {"options": [
      {"name": "Lead", "color": "blue"},
      {"name": "In Contatto", "color": "yellow"},
      {"name": "Acquisito", "color": "green"},
      {"name": "Perso", "color": "red"}
    ]}},
    "Fonte": {"select": {"options": [
      {"name": "Sito Web", "color": "blue"},
      {"name": "Social", "color": "pink"},
      {"name": "Passaparola", "color": "green"},
      {"name": "Evento", "color": "orange"}
    ]}},
    "Note": {"rich_text": {}}
  }
}
"@
$db2Res = Notion-Post -Endpoint "databases" -JsonBody $db2Json
if ($db2Res) { Write-Host "  -> DB CRM Contatti creato" -ForegroundColor Green }

Start-Sleep -Milliseconds 500

# --- DB 3: Tasks ---
$db3Json = @"
{
  "parent": {"type": "page_id", "page_id": "$BackendId"},
  "icon": {"type": "emoji", "emoji": "\u2705"},
  "title": [{"type": "text", "text": {"content": "DB Tasks"}}],
  "properties": {
    "Nome Task": {"title": {}},
    "Fatto": {"checkbox": {}},
    "Scadenza": {"date": {}},
    "Priorita": {"select": {"options": [
      {"name": "Alta", "color": "red"},
      {"name": "Media", "color": "yellow"},
      {"name": "Bassa", "color": "gray"}
    ]}},
    "Area": {"select": {"options": [
      {"name": "Marketing", "color": "pink"},
      {"name": "Museo / Allestimento", "color": "brown"},
      {"name": "Digitale / IT", "color": "blue"},
      {"name": "Amministrazione", "color": "gray"},
      {"name": "Evento", "color": "orange"}
    ]}},
    "Assegnato a": {"people": {}}
  }
}
"@
$db3Res = Notion-Post -Endpoint "databases" -JsonBody $db3Json
if ($db3Res) { Write-Host "  -> DB Tasks creato" -ForegroundColor Green }

Start-Sleep -Milliseconds 500

# --- DB 4: Wiki Appunti ---
$db4Json = @"
{
  "parent": {"type": "page_id", "page_id": "$BackendId"},
  "icon": {"type": "emoji", "emoji": "\uD83D\uDCD6"},
  "title": [{"type": "text", "text": {"content": "DB Wiki e Appunti"}}],
  "properties": {
    "Titolo": {"title": {}},
    "Categoria": {"select": {"options": [
      {"name": "Appunti", "color": "yellow"},
      {"name": "Procedure", "color": "blue"},
      {"name": "Marketing", "color": "pink"},
      {"name": "Guida Museo", "color": "green"},
      {"name": "Strategia Digitale", "color": "purple"},
      {"name": "Archivio", "color": "gray"}
    ]}},
    "Ultima Modifica": {"last_edited_time": {}}
  }
}
"@
$db4Res = Notion-Post -Endpoint "databases" -JsonBody $db4Json
if ($db4Res) { 
    Write-Host "  -> DB Wiki e Appunti creato" -ForegroundColor Green
    $WikiDbId = $db4Res.id
}

Start-Sleep -Seconds 1

# ============================================================
# FASE 3: PAGINE STATICHE RICCHE
# ============================================================
Write-Host ""
Write-Host "[FASE 3] Creazione pagine statiche con contenuti completi..." -ForegroundColor Yellow

# --- PAGINA: Storia e Funzionamento Museo ---
$storiaJson = @"
{
  "parent": {"type": "page_id", "page_id": "$BackendId"},
  "icon": {"type": "emoji", "emoji": "\uD83D\uDCDC"},
  "properties": {"title": {"title": [{"text": {"content": "Storia e Funzionamento del Museo"}}]}},
  "children": [
    $(Make-Callout -Text "Documento di riferimento: storia della Fattoria Ciuppa Tasca, dall'origine al museo moderno." -Emoji "🏛️" -Color "blue_background"),
    $(Make-TOC),
    $(Make-Divider),
    $(Make-Heading2 -Text "Visione e Inquadramento Storico"),
    $(Make-Paragraph -Text "Il museo ha sede in Cozzo Parrino - Contrada Baroni, Noto (SR) ed e' stato inaugurato ufficialmente il 21 giugno 2025. Nasce dalla ricerca e dall'impegno di Annibale Bianco, imprenditore agricolo e proprietario della fattoria, per celebrare il legame tra uomo, natura e cultura rurale del Mediterraneo."),
    $(Make-BulletItem -Text "Proprietario: Annibale Bianco (Azienda Agricola con sede a Sant'Agata di Militello)"),
    $(Make-BulletItem -Text "Curatela Scientifica: Vittorio Alfieri, esperto in Beni Culturali Archeologici"),
    $(Make-BulletItem -Text "Rete Museale: Parte del Sistema Rete Museale Iblei, diretto da Cetty Bruno"),
    $(Make-BulletItem -Text "Relatori Inaugurazione: Vittorio Alfieri, Cetty Bruno, Pippo Ricciardo (agronomo), Salvo Veneziano (vicesindaco di Noto), Ernesto Tripoli (agronomo). Condotto dal giornalista Giuseppe Spignola"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Le Origini: Tre Secoli di Storia Familiare"),
    $(Make-Paragraph -Text "La narrazione inizia nel 1700, quando il latifondo apparteneva alla famiglia Tasca."),
    $(Make-BulletItem -Text "L'unione dei casati: Nel XIX secolo, un doppio matrimonio tra i fratelli Ciuppa (notabili dei Nebrodi) e le sorelle Mastrogiovanni Tasca diede origine all'attuale assetto della tenuta."),
    $(Make-BulletItem -Text "Discendenze illustri: La famiglia annovera tra i suoi membri il poeta Lucio Piccolo e lo scrittore Giuseppe Tomasi di Lampedusa, autore de Il Gattopardo."),
    $(Make-BulletItem -Text "Evoluzione produttiva: Negli anni '20, la tenuta passo' a Francesca, nipote di Pietro Ciuppa, che nel 1924 sposo' Annibale Bianco (senatore e deputato). Dagli anni '90 l'azienda si e' focalizzata sui melograni e sul recupero degli ulivi centenari."),
    $(Make-Divider),
    $(Make-Heading2 -Text "Esperienza Museale e Artistica"),
    $(Make-Paragraph -Text "Il percorso ricostruisce il ciclo di produzione dell'olio d'oliva attraverso archeologia, mitologia e arte. Sono presenti macine in pietra e antiche presse restaurate."),
    $(Make-Heading3 -Text "L'Opera di Concetto Tamburello"),
    $(Make-Paragraph -Text "Pittore e mosaicista siciliano, formatosi a Brera con esperienze a New York e in India. L'opera 'Il Busto dell'Arbusto', concessa gratuitamente al museo, raffigura figure umane in simbiosi con gli ulivi, simboleggiando la generazione della vita. Un QR Code rimanda al sito ufficiale dell'artista per approfondimenti."),
    $(Make-Heading3 -Text "Laboratori e Didattica"),
    $(Make-BulletItem -Text "Creazione di saponi artigianali a base di olio con essenze locali: zagara, ginestra, melograno, carruba e fico d'India"),
    $(Make-BulletItem -Text "Passeggiate guidate e raccolta di erbe spontanee"),
    $(Make-BulletItem -Text "Caccia al tesoro dell'olio (attivita' per bambini e famiglie)"),
    $(Make-BulletItem -Text "Degustazioni sensoriali dell'olio extravergine"),
    $(Make-BulletItem -Text "Teatro e concerti tra gli ulivi e i melograni"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Il Cuore Meccanico: L'Antico Frantoio"),
    $(Make-Paragraph -Text "Il frantoio e' un esempio di archeologia industriale degli anni '30, restaurato per scopi educativi e divulgativi."),
    $(Make-Heading3 -Text "Sala Marina: La Messa in Moto"),
    $(Make-Paragraph -Text "Il processo iniziava con l'avvio del motore Hatz Diesel (su licenza Junkers) a pistoni contrapposti:"),
    $(Make-NumberedItem -Text "Si inseriva una 'sigaretta' (innesco) nell'alloggiamento in alto a destra"),
    $(Make-NumberedItem -Text "Si spruzzava il gasolio tramite una pompa a leva"),
    $(Make-NumberedItem -Text "Si ruotava la manovella frontale per dare il via al moto"),
    $(Make-Paragraph -Text "L'energia meccanica veniva trasferita a un alternatore per generare elettricita' a 200 volt. Le due grandi ruote (gole) - una in metallo collegata al motore e una in legno collegata all'alternatore - trasmettevano la potenza."),
    $(Make-Heading3 -Text "Sala Francesca: La Fase Operativa"),
    $(Make-Paragraph -Text "In questo spazio l'illuminazione era affidata a lampade ad acetilene per non sottrarre energia ai macchinari."),
    $(Make-BulletItem -Text "Le Molazze (Macina): Le olive (circa 120 kg a ciclo) venivano pesate e riversate nella vasca. Le pietre le schiacciavano fino a creare la pasta d'olive."),
    $(Make-BulletItem -Text "Le Coffe (Fiscoli): La pasta veniva raccolta in carrelli di legno e spalmata nelle coffe a cuscino, impilate lungo le presse."),
    $(Make-BulletItem -Text "Le Presse Idrauliche: Tre presse alimentate da una pompa idraulica centrale ad acqua. Al centro la super-pressa, dotata di carrello mobile su pavimentazione in balate (pietre naturali)."),
    $(Make-BulletItem -Text "Separazione Olio/Acqua: L'olio veniva prelevato a sfioro con la lumera (piattino locale). Infine una centrifuga Alfa Laval separava definitivamente l'olio dall'acqua di vegetazione."),
    $(Make-Divider),
    $(Make-Heading2 -Text "Approfondimenti Culturali e Glossario"),
    $(Make-Quote -Text "La parola Messia deriva dall'ebraico MashTah (L'Unto). L'olio e' da oltre 4.000 anni simbolo di purezza e pace."),
    $(Make-BulletItem -Text "Cafiso: Unita' di misura locale corrispondente a circa 11-12 kg"),
    $(Make-BulletItem -Text "Munna: La pratica ciclica della potatura dell'ulivo"),
    $(Make-BulletItem -Text "Fraschi: I rametti sottili usati come legna da ardere per i forni"),
    $(Make-BulletItem -Text "Cutulari: L'azione di abbacchiare le olive con bastoni di nocciolo o salice"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Gestione Operativa e Logistica"),
    $(Make-Paragraph -Text "Le visite sono prevalentemente su prenotazione, ma il museo e' aperto al pubblico il sabato."),
    $(Make-BulletItem -Text "Orari Sabato: Mattina 09:30 - 12:30 | Pomeriggio 14:00 - 16:00"),
    $(Make-BulletItem -Text "Contatti: Tel. 376 2826539 | Email: museo@fattoriaciuppatasca.it")
  ]
}
"@
$storiaRes = Notion-Post -Endpoint "pages" -JsonBody $storiaJson
if ($storiaRes) { Write-Host "  -> Pagina Storia e Funzionamento creata (COMPLETA)" -ForegroundColor Green }

Start-Sleep -Seconds 1

# --- PAGINA: Guida Visite (il manuale completo per le guide) ---
$guidaJson = @"
{
  "parent": {"type": "page_id", "page_id": "$BackendId"},
  "icon": {"type": "emoji", "emoji": "\uD83D\uDCD6"},
  "properties": {"title": {"title": [{"text": {"content": "Manuale Guida per le Visite"}}]}},
  "children": [
    $(Make-Callout -Text "Manuale operativo per la conduzione dei percorsi museali. Usa le indicazioni come copione flessibile durante i tour." -Emoji "🎤" -Color "green_background"),
    $(Make-TOC),
    $(Make-Divider),
    $(Make-Heading2 -Text "TAPPA 1: L'Esterno e l'Accoglienza"),
    $(Make-Paragraph -Text "Dove sei: All'ingresso della masseria (Cozzo Parrino)."),
    $(Make-Quote -Text "Benvenuti alla Fattoria Ciuppa Tasca. Ci troviamo in una masseria fortificata a quadrilatero le cui origini risalgono al '1000. Oggi faremo un viaggio nel tempo per scoprire un rito millenario: la nascita dell'olio d'oliva."),
    $(Make-Heading3 -Text "La Storia Familiare (dal 1700 a oggi)"),
    $(Make-BulletItem -Text "I Tasca e i Ciuppa: Nel XIX sec., le sorelle Mastrogiovanni Tasca sposano i fratelli Ciuppa (notabili dei Nebrodi), unendo i casati. Famiglia imparentata con Giuseppe Tomasi di Lampedusa e il poeta Lucio Piccolo."),
    $(Make-BulletItem -Text "Annibale Bianco (nonno): Entra in famiglia nel 1924 sposando Francesca Ciuppa. Modernizza l'azienda (agrumi, cereali)."),
    $(Make-BulletItem -Text "Oggi (Annibale Bianco nipote): Recupero degli ulivi centenari, coltivazione del melograno, e nascita di questo museo (inaugurato Giugno 2025)."),
    $(Make-Heading3 -Text "L'Arte: Il Busto dell'Arbusto"),
    $(Make-Quote -Text "Prima di entrare nel cuore pulsante del frantoio, guardate quest'opera: Il Busto dell'Arbusto."),
    $(Make-BulletItem -Text "Autore: Concetto Tamburello (pittore formatosi a Brera)."),
    $(Make-BulletItem -Text "Significato: Figure umane che si fondono con gli ulivi. E' il manifesto del museo: l'uomo e la natura sono un'unica cosa che si rigenera."),
    $(Make-Callout -Text "TIP per i Bambini: Fai cercare loro le facce nascoste o le braccia umane dentro i rami dell'opera d'arte." -Emoji "💡" -Color "blue_background"),
    $(Make-Divider),
    $(Make-Heading2 -Text "TAPPA 2: Sala Marina (L'Energia e la Messa in Moto)"),
    $(Make-Paragraph -Text "Dove sei: Prima stanza del frantoio. Obiettivo: Spiegare da dove arrivava la forza per far muovere tutto."),
    $(Make-Quote -Text "Immaginate di essere negli anni '30. Niente prese elettriche moderne. Come facevano a muovere macchinari pesantissimi?"),
    $(Make-Heading3 -Text "Il Motore Hatz Diesel"),
    $(Make-Paragraph -Text "E' il cuore pulsante (su licenza Junkers, a pistoni contrapposti). Poteva essere avviato solo con una complessa sequenza:"),
    $(Make-NumberedItem -Text "Si inseriva una 'sigaretta' (innesco) in alto a destra"),
    $(Make-NumberedItem -Text "Si spruzzava gasolio con la pompa a leva"),
    $(Make-NumberedItem -Text "Si girava con forza la manovella frontale"),
    $(Make-Heading3 -Text "Le 'Gole' e i Pantografi"),
    $(Make-Paragraph -Text "Osservate in alto le due grandi ruote (gole). Una in metallo (collegata al motore) e una in legno (collegata all'alternatore). L'alternatore generava 200 volt di elettricita' per illuminare il resto del casale."),
    $(Make-Callout -Text "TIP per Esperti: Sottolinea l'ingegneria del sistema a 'cambi' (scambiatori): ogni macchinario poteva essere 'messo in folle' per non sprecare energia e dirottarla solo dove serviva." -Emoji "💡" -Color "blue_background"),
    $(Make-Divider),
    $(Make-Heading2 -Text "TAPPA 3: Sala Francesca (Il Cuore della Produzione)"),
    $(Make-Paragraph -Text "Dove sei: Il vero spazio operativo del frantoio. Obiettivo: Il ciclo di trasformazione dall'oliva all'olio."),
    $(Make-Quote -Text "Qui dentro si lavorava illuminati solo da lampade ad acetilene. Tutta l'energia creata di la' serviva ai macchinari di qua."),
    $(Make-Heading3 -Text "Fase 1: Preparazione e Frangitura"),
    $(Make-BulletItem -Text "Attesa e Pesatura: Le olive aspettavano in 'setti di pietra', per poi essere pesate a cicli di 120 kg."),
    $(Make-BulletItem -Text "La Macina (Molazze): Riversate nella vasca, grandi pietre le schiacciavano fino a creare la 'pasta d'olive'."),
    $(Make-BulletItem -Text "Il Trasporto: Veniva prelevata e messa in un carrellino di legno zincato."),
    $(Make-Heading3 -Text "Fase 2: La Spremitura"),
    $(Make-BulletItem -Text "Le Presse Idrauliche: La pasta veniva spalmata nelle 'coffe' a cuscino (i fiscoli), perfettamente impilate."),
    $(Make-BulletItem -Text "Attenzione tecnica: Le presse non andavano a gasolio, ma ad ACQUA! Una pompa idraulica centrale mandava acqua in pressione per sollevare i pistoni dal basso verso l'alto."),
    $(Make-BulletItem -Text "La Super-Pressa: Quella centrale era la piu' potente. Il pavimento sotto e' fatto di 'balate' (grandi blocchi di pietra spessa) per sopportare il peso."),
    $(Make-Heading3 -Text "Fase 3: La Separazione"),
    $(Make-BulletItem -Text "Dalla spremitura esce un liquido: acqua + olio. L'olio, essendo piu' leggero, galleggia."),
    $(Make-BulletItem -Text "La Lumera: I frantoiani prelevavano l'olio a sfioro usando un piattino locale detto lumera."),
    $(Make-BulletItem -Text "La Centrifuga Alfa Laval: Per la pulizia finale, un separatore a due fasi divideva definitivamente l'acqua di vegetazione dall'Olio Extravergine finito."),
    $(Make-Divider),
    $(Make-Heading2 -Text "TAPPA 4: Degustazione (Il Momento Wow)"),
    $(Make-Paragraph -Text "Dove sei: Fine percorso, area ristoro/laboratori. Obiettivo: Coinvolgere i sensi e chiudere l'esperienza."),
    $(Make-Quote -Text "Dopo aver visto quanta fatica costava produrlo, ora impariamo a rispettarlo assaggiandolo come dei veri sommelier."),
    $(Make-NumberedItem -Text "Riscaldamento: Fai tenere il bicchierino nel palmo della mano e coprirlo con l'altra per scaldarlo (l'olio sprigiona i profumi a circa 28 gradi C)."),
    $(Make-NumberedItem -Text "Esame Olfattivo: Annusare profondamente. Cerca i profumi: erba tagliata, mandorla, pomodoro."),
    $(Make-NumberedItem -Text "Lo Strippaggio (Gusto): Bere un sorso minuscolo, stringere i denti e aspirare aria dalla bocca. Serve a vaporizzare l'olio."),
    $(Make-Callout -Text "Un buon olio 'pizzica' in gola! E' segno della presenza di antiossidanti (polifenoli), un toccasana per la salute, e NON indice di acidita' (che e' inodore e insapore)." -Emoji "🫒" -Color "green_background"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Glossario e Curiosita'"),
    $(Make-BulletItem -Text "Messia: Deriva dall'ebraico MashTah (L'Unto). L'olio e' sacro da 4000 anni, simbolo di purezza e pace."),
    $(Make-BulletItem -Text "Munna: La tecnica locale di potatura dell'ulivo."),
    $(Make-BulletItem -Text "Cafiso: Unita' di misura arcaica siciliana (circa 11-12 kg)."),
    $(Make-BulletItem -Text "Cutulari: L'azione di abbacchiare, ovvero battere i rami con bastoni di nocciolo o salice."),
    $(Make-BulletItem -Text "Fraschi: I rametti sottili di scarto usati per accendere i forni."),
    $(Make-Callout -Text "Ricorda ai visitatori (specie scuole e famiglie) che si possono prenotare Laboratori di Saponi artigianali e la Caccia al Tesoro dell'Olio tra gli ulivi." -Emoji "🎯" -Color "purple_background")
  ]
}
"@
$guidaRes = Notion-Post -Endpoint "pages" -JsonBody $guidaJson
if ($guidaRes) { Write-Host "  -> Pagina Manuale Guida Visite creata (COMPLETA)" -ForegroundColor Green }

Start-Sleep -Seconds 1

# --- PAGINA: Accessi e Credenziali ---
$credsJson = @"
{
  "parent": {"type": "page_id", "page_id": "$BackendId"},
  "icon": {"type": "emoji", "emoji": "\uD83D\uDD10"},
  "properties": {"title": {"title": [{"text": {"content": "Accessi e Credenziali"}}]}},
  "children": [
    $(Make-Callout -Text "AREA RISERVATA - Credenziali sensibili di accesso alle piattaforme digitali del museo. Non condividere questo link." -Emoji "🔒" -Color "red_background"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Infrastruttura Digitale"),
    $(Make-BulletItem -Text "Agenzia Web: KM ZERO WEB MARKETING (Viterbo). Consulente: Alessia Martinelli."),
    $(Make-Divider),
    $(Make-Heading2 -Text "Sito Web"),
    $(Make-BulletItem -Text "URL: www.fattoriaciuppatasca.it"),
    $(Make-BulletItem -Text "Pannello gestione - Password: e7Hd6Reeh62EM,r"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Email"),
    $(Make-Heading3 -Text "Webmail Aziendale"),
    $(Make-BulletItem -Text "Indirizzo: museo@fattoriaciuppatasca.it"),
    $(Make-BulletItem -Text "Password: e7Hd6Reeh62EM,r"),
    $(Make-Heading3 -Text "Gmail"),
    $(Make-BulletItem -Text "Indirizzo: museofattoriaciuppatasca@gmail.com"),
    $(Make-BulletItem -Text "Password: 21.06.2025"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Social Media"),
    $(Make-Heading3 -Text "YouTube"),
    $(Make-BulletItem -Text "Password: Museo21062025"),
    $(Make-Heading3 -Text "LinkedIn"),
    $(Make-BulletItem -Text "Account attivo (credenziali da definire)"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Contatti Operativi"),
    $(Make-BulletItem -Text "Telefono Museo: 376 2826539"),
    $(Make-BulletItem -Text "Email principale: museo@fattoriaciuppatasca.it")
  ]
}
"@
$credsRes = Notion-Post -Endpoint "pages" -JsonBody $credsJson
if ($credsRes) { Write-Host "  -> Pagina Accessi e Credenziali creata" -ForegroundColor Green }

Start-Sleep -Seconds 1

# --- PAGINA: Strategia Digitale ---
$strategiaJson = @"
{
  "parent": {"type": "page_id", "page_id": "$BackendId"},
  "icon": {"type": "emoji", "emoji": "\uD83D\uDE80"},
  "properties": {"title": {"title": [{"text": {"content": "Strategia Digitale e Marketing"}}]}},
  "children": [
    $(Make-Callout -Text "Piano d'azione per il progetto Phygital del Museo. Elaborato da Michele." -Emoji "🎯" -Color "purple_background"),
    $(Make-TOC),
    $(Make-Divider),
    $(Make-Heading2 -Text "Obiettivo Generale"),
    $(Make-Paragraph -Text "Applicare un approccio 'Phygital' per creare un ecosistema organizzato e automatizzato al fine di accrescere la visibilita', le prenotazioni e le vendite del museo."),
    $(Make-Divider),
    $(Make-Heading2 -Text "1. Dashboard Notion e Automazione"),
    $(Make-BulletItem -Text "Hub Centrale: Pagina Notion strutturata per Annibale e Vittorio, dove consultare file, dati e stati di avanzamento."),
    $(Make-BulletItem -Text "Booking Online: Implementazione di un calendario digitale (es. Luma o interni a Notion) per automatizzare le prenotazioni e gestire il database contatti."),
    $(Make-Divider),
    $(Make-Heading2 -Text "2. Soluzioni Phygital"),
    $(Make-BulletItem -Text "Linktree di Impatto: Una pagina di atterraggio unica per social e info utili."),
    $(Make-BulletItem -Text "QR Code Fisico: Creazione di supporti fisici (quadri/cavalieri) con QR code per accesso rapido a social, prenotazioni e password Wi-Fi."),
    $(Make-Divider),
    $(Make-Heading2 -Text "3. Marketing e Crescita"),
    $(Make-Paragraph -Text "Sviluppo di strategie per aumentare il numero di visitatori, curando i canali social e proponendo innovazioni costanti basate sulla fiducia e l'iniziativa mostrata sul campo (es. integrazione tra artigianato locale, agricoltura e IA)."),
    $(Make-Divider),
    $(Make-Heading2 -Text "Stack Tecnologico del Progetto"),
    $(Make-BulletItem -Text "Notion - Azienda / Project HQ: Dashboard centrale, calendari, repository di strategie."),
    $(Make-BulletItem -Text "NotebookLM - Studio 'Closed-Loop': Elaborazione di fonti proprietarie. Zero allucinazioni."),
    $(Make-BulletItem -Text "Perplexity - Research Engine: Ricerca profonda in tempo reale."),
    $(Make-BulletItem -Text "Claude Code / Antigravity - Terminal IDE AI: Gestione progetti complessi, orchestrazione contesti."),
    $(Make-BulletItem -Text "NanoBanana 2 / Pro - Image Generation: Generazione e composizione avanzata di immagini."),
    $(Make-BulletItem -Text "ElevenLabs - Voice Synthesis: Generazione di asset audio ad alta fedelta'.")
  ]
}
"@
$strategiaRes = Notion-Post -Endpoint "pages" -JsonBody $strategiaJson
if ($strategiaRes) { Write-Host "  -> Pagina Strategia Digitale creata" -ForegroundColor Green }

Start-Sleep -Seconds 1

# ============================================================
# FASE 4: POPOLARE LA WIKI CON PAGINE NEL DATABASE
# ============================================================
Write-Host ""
Write-Host "[FASE 4] Popolamento Wiki Database con documenti locali..." -ForegroundColor Yellow

if ($WikiDbId) {
    # Wiki Entry 1: Contesto Progetto
    $wiki1 = @"
{
  "parent": {"type": "database_id", "database_id": "$WikiDbId"},
  "icon": {"type": "emoji", "emoji": "\uD83C\uDFDB\uFE0F"},
  "properties": {
    "Titolo": {"title": [{"text": {"content": "Contesto Progetto Museo"}}]},
    "Categoria": {"select": {"name": "Procedure"}}
  },
  "children": [
    $(Make-Callout -Text "File di contesto principale del progetto. Contiene la vision, la storia, i contatti e la strategia del Museo dell'Olio." -Emoji "📋" -Color "blue_background"),
    $(Make-Paragraph -Text "Il museo ha sede in Cozzo Parrino - Contrada Baroni, Noto (SR) ed e' stato inaugurato ufficialmente il 21 giugno 2025. Nasce dalla ricerca e dall'impegno di Annibale Bianco, imprenditore agricolo e proprietario della fattoria, per celebrare il legame tra uomo, natura e cultura rurale del Mediterraneo."),
    $(Make-Paragraph -Text "Proprietario: Annibale Bianco. Curatela Scientifica: Vittorio Alfieri. Rete Museale: Sistema Rete Museale Iblei (dir. Cetty Bruno). Orari sabato: 09:30-12:30 e 14:00-16:00. Tel: 376 2826539.")
  ]
}
"@
    $w1 = Notion-Post -Endpoint "pages" -JsonBody $wiki1
    if ($w1) { Write-Host "  -> Wiki: Contesto Progetto aggiunto" -ForegroundColor Green }

    Start-Sleep -Milliseconds 500

    # Wiki Entry 2: Identity Michele
    $wiki2 = @"
{
  "parent": {"type": "database_id", "database_id": "$WikiDbId"},
  "icon": {"type": "emoji", "emoji": "\uD83E\uDDD1\u200D\uD83D\uDCBB"},
  "properties": {
    "Titolo": {"title": [{"text": {"content": "IDENTITY - Profilo Michele"}}]},
    "Categoria": {"select": {"name": "Procedure"}}
  },
  "children": [
    $(Make-Callout -Text "Profilo professionale di Michele - Digital Marketer, Brand Strategist e AI Specialist. Filosofia Phygital Ecosystem e Omnichannel Branding." -Emoji "🧠" -Color "purple_background"),
    $(Make-Heading3 -Text "Profilo Operativo e Visione"),
    $(Make-Paragraph -Text "Michele e' un professionista ibrido specializzato nell'intersezione tra Marketing, Nuove Tecnologie e Intelligenza Artificiale. Il suo approccio trascende l'esecuzione tecnica per concentrarsi su una visione sistemica e strategica."),
    $(Make-BulletItem -Text "Core Competencies: Digital Marketing, Brand Identity, AI Prompt Engineering, Project Management, Copywriting Strategico, Process Optimization"),
    $(Make-BulletItem -Text "Filosofia Phygital: Visione del mondo fisico e digitale come un unico fluido divenire. Le due dimensioni devono comunicare costantemente e integrarsi senza frizioni."),
    $(Make-BulletItem -Text "Approccio Omnichannel: Ogni strategia e' subordinata alla Vision/Mission del Brand. La tecnologia amplifica l'identita' del progetto su ogni touchpoint.")
  ]
}
"@
    $w2 = Notion-Post -Endpoint "pages" -JsonBody $wiki2
    if ($w2) { Write-Host "  -> Wiki: Identity Michele aggiunto" -ForegroundColor Green }

    Start-Sleep -Milliseconds 500

    # Wiki Entry 3: Appunti Elementi Rimossi
    $wiki3 = @"
{
  "parent": {"type": "database_id", "database_id": "$WikiDbId"},
  "icon": {"type": "emoji", "emoji": "\uD83D\uDCDD"},
  "properties": {
    "Titolo": {"title": [{"text": {"content": "Appunti ed Elementi Rimossi"}}]},
    "Categoria": {"select": {"name": "Appunti"}}
  },
  "children": [
    $(Make-Callout -Text "Frammenti rimossi durante l'ottimizzazione del file di contesto. Salvati come base per i prossimi file." -Emoji "📝" -Color "yellow_background"),
    $(Make-Heading3 -Text "Struttura e Architettura dei File"),
    $(Make-Paragraph -Text "Sistema di File Markdown (.md) per IA: Creazione di file main per fornire istruzioni precise agli agenti IA."),
    $(Make-BulletItem -Text "identity.md: Definisce la figura professionale di Michele"),
    $(Make-BulletItem -Text "contesto.md: Background del museo e del progetto"),
    $(Make-BulletItem -Text "claude.md: Linee guida, protocolli e tono di voce per gli strumenti di coding"),
    $(Make-BulletItem -Text "guida_museo.md: Documento di studio sul funzionamento del frantoio e la storia dei reperti")
  ]
}
"@
    $w3 = Notion-Post -Endpoint "pages" -JsonBody $wiki3
    if ($w3) { Write-Host "  -> Wiki: Appunti Elementi Rimossi aggiunto" -ForegroundColor Green }
}

Start-Sleep -Seconds 1

# ============================================================
# FASE 5: CREARE LA DASHBOARD HQ SULLA PAGINA PRINCIPALE
# ============================================================
Write-Host ""
Write-Host "[FASE 5] Creazione Dashboard HQ..." -ForegroundColor Yellow

$hqJson = @"
{
  "parent": {"type": "page_id", "page_id": "$ParentPageId"},
  "icon": {"type": "emoji", "emoji": "\uD83C\uDFDB\uFE0F"},
  "properties": {"title": {"title": [{"text": {"content": "MUSEO CIUPPA TASCA - HQ"}}]}},
  "children": [
    $(Make-Callout -Text "Unione tra uomo, natura e cultura rurale del Mediterraneo.\nDashboard Operativa di Annibale e Vittorio.\nOrari Sabato: 09:30 - 12:30 | 14:00 - 16:00 | Tel: 376 2826539" -Emoji "🫒" -Color "green_background"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Navigazione Rapida"),
    $(Make-Callout -Text "Per configurare questa dashboard:\n1. Clicca i 3 puntini in alto a destra e attiva 'Full width'\n2. Usa il comando /linked per importare i database dal Backend\n3. Organizza in 2 colonne con il comando /2 columns\n4. Colonna SX: Tasks e Wiki | Colonna DX: Appuntamenti e CRM" -Emoji "⚡" -Color "yellow_background"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Link Rapidi"),
    $(Make-BulletItem -Text "Sito Web: www.fattoriaciuppatasca.it"),
    $(Make-BulletItem -Text "Email: museo@fattoriaciuppatasca.it"),
    $(Make-BulletItem -Text "Telefono: 376 2826539"),
    $(Make-Divider),
    $(Make-Heading2 -Text "Prossimi Passi"),
    $(Make-Callout -Text "Step 1: Importa qui le Linked Views dei database dal Backend (comando /linked)\nStep 2: Configura la vista Calendario per gli Appuntamenti\nStep 3: Configura la vista Lista per i Tasks\nStep 4: Aggiungi una Cover a tema ulivi/natura" -Emoji "🚀" -Color "blue_background")
  ]
}
"@
$hqRes = Notion-Post -Endpoint "pages" -JsonBody $hqJson
if ($hqRes) { 
    Write-Host "  -> Dashboard HQ creata" -ForegroundColor Green
    $hqUrl = $hqRes.url
}

# ============================================================
# FINE
# ============================================================
Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  RICOSTRUZIONE COMPLETATA CON SUCCESSO!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Riepilogo elementi creati:" -ForegroundColor Cyan
Write-Host "  - Backend Museo (con avviso)" -ForegroundColor White
Write-Host "  - DB Appuntamenti (5 tipologie, 4 stati)" -ForegroundColor White
Write-Host "  - DB CRM Contatti (6 categorie, 4 stati, 4 fonti)" -ForegroundColor White
Write-Host "  - DB Tasks (5 aree, 3 priorita')" -ForegroundColor White
Write-Host "  - DB Wiki e Appunti (6 categorie)" -ForegroundColor White
Write-Host "  - Pagina Storia e Funzionamento (35+ blocchi)" -ForegroundColor White
Write-Host "  - Pagina Manuale Guida Visite (50+ blocchi)" -ForegroundColor White
Write-Host "  - Pagina Accessi e Credenziali (strutturata)" -ForegroundColor White
Write-Host "  - Pagina Strategia Digitale e Marketing" -ForegroundColor White
Write-Host "  - 3 documenti nel DB Wiki" -ForegroundColor White
Write-Host "  - Dashboard HQ con istruzioni" -ForegroundColor White
Write-Host ""
if ($hqUrl) { Write-Host "  Dashboard HQ: $hqUrl" -ForegroundColor Cyan }
Write-Host ""
