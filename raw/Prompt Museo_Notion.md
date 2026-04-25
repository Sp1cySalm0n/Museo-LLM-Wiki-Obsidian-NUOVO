Ecco il prompt completo e aggiornato in ogni suo dettaglio (struttura, API, predisposizione Luma e UI/UX design)

```markdown
# DIRETTIVA DI SISTEMA: CREAZIONE WORKSPACE NOTION "MUSEO CIUPPA TASCA"
**Strumento:** Antigravity MCP (Notion API Integration)
**Contesto:** Devi costruire l'architettura digitale su Notion per il "Museo dell'Olio e della Civiltà Contadina - Fattoria Ciuppa Tasca". L'obiettivo è un sistema "Phygital", ordinato, privo di confusione e basato sulla separazione tra Backend (dati) e Frontend (Dashboard visiva).

## FASE 1: CREAZIONE DEL BACKEND (DATABASES)
Crea una pagina principale chiamata "⚙️ BACKEND MUSEO" (nascosta dalla navigazione principale). All'interno, crea i seguenti 4 Database Master:

1. **DB_Appuntamenti (Calendar/Events - Luma Ready):**
   - *Tipo:* Database
   - *Proprietà essenziali per futura integrazione form API:* Nome Prenotazione (Title), Data e Ora (Date), Email Cliente (Email), Telefono (Phone), Tipologia (Select: Visita Guidata, Laboratorio Saponi, Evento Outdoor), Stato (Status: Nuova Prenotazione, Confermato, Concluso, Annullato), Numero Persone (Number), Link Gestione Luma (URL), Note (Text).

2. **DB_CRM_Contatti (Partnership & Clienti):**
   - *Tipo:* Database
   - *Proprietà:* Nome/Ente (Title), Categoria (Select: Scuola, Partner, Cliente, Istituzione), Email (Email), Telefono (Phone), Stato Contatto (Status: Lead, In Contatto, Acquisito), Note (Text).

3. **DB_Tasks (Operatività):**
   - *Tipo:* Database
   - *Proprietà:* Nome Task (Title), Fatto (Checkbox), Scadenza (Date), Priorità (Select: Alta, Media, Bassa), Assegnato a (Person).

4. **DB_Wiki_Appunti (Note e Documentazione):**
   - *Tipo:* Database
   - *Proprietà:* Titolo (Title), Categoria (Select: Appunti, Procedure, Marketing), Ultima Modifica (Last Edited Time).

## FASE 2: CREAZIONE DEL FRONTEND (DASHBOARD HQ)
Crea una pagina principale chiamata "🏛️ MUSEO CIUPPA TASCA - HQ". Questa sarà la pagina operativa. Usa le "Linked Views" (Viste collegate) dei database creati nella FASE 1. Struttura la pagina in questo modo:

- **Intestazione:** Aggiungi una Cover (a tema ulivi/natura) e un blocco "Callout" (💡) in alto contenente la Vision: "Unione tra uomo, natura e cultura rurale del Mediterraneo. Dashboard Operativa di Annibale e Vittorio."
- **Layout a 2 Colonne:**
  - **Colonna Sinistra (Operatività Quotidiana):**
    - Inserisci un Toggle Heading H2 chiamato "✅ Task e Appunti".
    - Dentro il toggle, inserisci una Linked View di `DB_Tasks` filtrata per "Fatto = Falso".
    - Sotto, inserisci una Linked View di `DB_Wiki_Appunti`.
  - **Colonna Destra (Clienti e Appuntamenti):**
    - Inserisci un Toggle Heading H2 chiamato "📅 Calendario Appuntamenti".
    - Dentro, inserisci una Linked View di `DB_Appuntamenti` con layout Calendario.
    - Sotto, inserisci un Toggle Heading H2 chiamato "🤝 CRM e Partnership".
    - Dentro, inserisci una Linked View di `DB_CRM_Contatti`.

## FASE 3: CREAZIONE PAGINE STATICHE (KNOWLEDGE BASE & CREDENZIALI)
All'interno della Dashboard HQ crea due pagine statiche:

1. **Pagina: "📜 Storia e Funzionamento Museo"**
   - Inserisci la storia della famiglia (dal 1700 a oggi) e la spiegazione del "Ciclo dell'Olio" (Sala Marina, Sala Francesca, Degustazione) prendendo i dati dal file di contesto.
   - Menziona l'opera di Concetto Tamburello "Il Busto dell'Arbusto".

2. **Pagina: "🔐 Accessi e Credenziali" (AZIONE API RICHIESTA)**
   - Crea un blocco Callout di Avviso di sicurezza.
   - **IMPORTANTE:** Accedi ai tuoi file di contesto, recupera le credenziali reali del Museo e scrivile in chiaro in questa pagina tramite API. Nello specifico inserisci:
     - Pannello Sito Web KM ZERO (URL e login: e7Hd6Reeh62EM,r)
     - Email Webmail (museo@fattoriaciuppatasca.it, pass: e7Hd6Reeh62EM,r)
     - Email Gmail (museofattoriaciuppatasca@gmail.com, pass: 21.06.2025)
     - Social YouTube (Pass: Museo21062025) e LinkedIn.

## FASE 4: DIRETTIVE VISIVE E UI/UX (CRITICO)
L'interfaccia deve essere visivamente eccellente, pulita e minimale. Applica rigorosamente le seguenti regole di design su tutte le pagine generate:

1. **Full Width:** Imposta la pagina "🏛️ MUSEO CIUPPA TASCA - HQ" a larghezza intera (Full width) per sfruttare tutto lo schermo.
2. **Iconografia Coerente:** Assegna icone minimaliste (non emoji complesse, usa icone monocromatiche di Notion) abbinate per significato a ogni database e pagina.
3. **Nascondi Titoli Database:** In tutte le "Linked Views" della dashboard, nascondi sempre il titolo del database per mantenere il layout pulito (impostazione: "Hide database title").
4. **Viste Ottimizzate:** 
   - Usa la vista **List (Lista)** per i Task, mostrando solo il nome e la checkbox per un look compatto.
   - Se crei menù di navigazione verso altre pagine (come la Wiki), usa la vista **Gallery (Galleria)** impostando "Card preview" su "None" per simulare dei pulsanti puliti.
5. **Formattazione Callout:** Usa i blocchi Callout per le citazioni o gli avvisi importanti (come le credenziali), impostando lo sfondo su trasparente (default background) per un design arioso.

**Esecuzione:** Esegui le API Notion necessarie tramite gli strumenti MCP. Crea prima il backend, poi popola il frontend applicando il design UI/UX richiesto. Al termine, restituiscimi il link alla pagina HQ.
```