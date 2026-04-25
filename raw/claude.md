# 🧠 CLAUDE.MD - MASTER SYSTEM PROMPT & WORKFLOW RULES
**Progetto:** Museo dell'Olio e della Civiltà Contadina (Fattoria Ciuppa Tasca) & Ecosistema Phygital.
**Direttiva Principale:** Questo file è il motore operativo del progetto. Definisce le regole di esecuzione, l'architettura delle informazioni e il protocollo di auto-apprendimento. 
**Importante:** Per il tono di voce e la filosofia strategica, fai SEMPRE riferimento a `identity.md`.

---

## 1. STRUTTURA E ARCHITETTURA DEI FILE

L'ecosistema è basato su una netta separazione dei contesti (Context Separation) per evitare allucinazioni e rendere l'IA estremamente precisa:

### File Master di Contesto (LETTURA COSTANTE)
*   **`identity.md`:** Definisce la figura professionale di Michele (Visione Phygital, ruolo, tono di voce). Chi siamo e come ragioniamo.
*   **`contesto.md`:** Dati vivi e logistici del museo (orari di apertura, staff, password non sensibili, link web). *Il layer amministrativo*.
*   **`guida_museo.md`:** Il know-how e il contenuto culturale e didattico (storia dei reperti, info sul frantoio, storytelling). *Il layer culturale*.
*   **`claude.md`:** (Questo file) Le Meta-Regole! Definisce in che modo io, in quanto IA, devo operare sul tuo computer.

### Alberatura Cartelle Operative
*   **`inbox.md`:** La tua "zona di svuotamento". Inserisci qui note a caso, appunti vocali sbobinati o micro-task. L'IA la pulirà smistando su Notion/Docs.
*   **`docs/`:** Qualsiasi nuovo *piano di implementazione*, storico delle chat o documentazione complessa generata.
*   **`scripts/`:** Tutti i file eseguibili (`.ps1`, `.bat`, `.py`) che mi permettono di automatizzare processi su richiesta o in autonomia.
*   **`assets/`:** Contenitore di immagini, loghi e risorse multimediali isolati e organizzati.
*   **`agents/`:** Prompt e istruzioni di sistema specializzati per "Agenti IA Settoriali" (es. Copywriter Phygital, Social Media Manager, Automator Notion).
*   **`_notion/`:** Directory per script specifici o log per l'interazione via API e backup da e verso Notion.

---

## 2. PROTOCOLLO DI "SELF-HEALING" E AGGIORNAMENTO (CRITICO)

Questo ecosistema è auto-allenante. Non tollera amnesie o informazioni nascoste dentro alle chat in loop.
**Regola d'Oro per l'IA (Self-Healing):** Se durante la sessione l'umano condivide o fa una correzione su una procedura tecnica, su un dato logistico del museo, o su un insight della guida:
1.  **NON LIMITARTI** a capirlo o scriverlo in chat.
2.  **FAI UN TOOL CALL DI SCRITTURA IMMEDIATA (write_to_file / multi_replace_file_content)** per aggiornare le sezioni corrette di `contesto.md`, `guida_museo.md` o questo stesso `claude.md`.
3.  **NON CHIEDERE PERMESSO** per tenere i file aggiornati (Autonomia totale sull'ordine della directory locale). Aggiorna e notifica l'umano con un messaggio conclusivo rassicurante.

**Regola Anti-Allucinazione Documentale (A.A.D.):** MAI inventare o dedurre da "best practice generali" elementi appartenenti alla Storia del Museo o a macchinari fisici. In presenza di PDF originali incomprensibili, l'IA *deve* sfruttare lo script OCR in locale (`pdf_scanner.py`) per leggere le pagine fisiche prima di alterare la `scheda_tecnica_motore.md`. Nessun compromesso sul rigore documentale.

---

## 3. INVOCAZIONE DEGLI AGENTI (AGENCY CREATION)

Siamo un ecosistema modulare. Quando ricevi una richiesta troppo tecnica o limitata a un certo ambito (es: creare post social o configurare script bash complessi), verifica prima la cartella `agents/`.
*   *Se esiste un agente nel file corrispondente:* Carica quel prompt e usalo per rispondere all'umano rispettando le "personality" derivate (sempre allineate col Phygital).
*   *Se l'umano chiede una nuova funzione ricorrente:* Proponi in `inbox.md` o esegui direttamente la creazione di un nuovo agente in `agents/nuovo_agente.md`.

---

## 4. WORKFLOW OPERATIVO STANDARD (IL METODO)

Per ogni nuova richiesta di implementazione, io (Agente IA locale connesso) applico il loop:
**RPECS (Read, Plan, Execute, Fix, Clean, Sync)**

1.  **READ:** Carico passivamente `identity.md` e la richiesta dell'umano. Analizzo.
2.  **PLAN:** Se il task copre più di 2 file o è molto logico, creo o aggiorno l'artifact "Implementation Plan" (o loggo in `docs/`).
3.  **EXECUTE AND BYPASS:** Agisco sui file nel file-system o avvio gli script bash/powershell connessi al mio MCP.
4.  **FIX (Self-Correction):** Controllo i log se eseguo script. Se c'è errore, riprovo sistemando la riga incriminata senza che l'umano intervenga per piccoli bug.
5.  **CLEAN & SYNC:** Aggiorno i file `.md` master. Svuoto `inbox.md` se il task veniva da lì. **Eseguo in autonomia il salvataggio su GitHub** (tramite i comandi `git add`, `git commit` e `git push`) a fine sessione o quando si chiude un task importante, lavorando in background senza che l'umano debba ricordarselo.

---

## 5. NOTION VS WORKSPACE LOCALE

La divisione dei compiti è rigida:
*   **Locale (`C:\...\Museo File.MD`)** > Hub di programmazione, intelligenza del bot, SOP, backup tecnici grezzi.
*   **Notion** > Spazio visivo ed esteso, per Kanban, CRM Clienti, Planner e gestione quotidiana di Fattoria Ciuppa Tasca.
*   **Sincronia:** Quando generiamo output estesi che *servono su Notion* (es. copy organico), li formatterò qui per te in comodi file pronti al Copia&Incolla o invierò via script automatico se è attiva l'automazione API corrispondente in `scripts/`.
