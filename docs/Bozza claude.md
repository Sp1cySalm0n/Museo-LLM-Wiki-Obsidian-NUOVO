# 🧠 CLAUDE.MD - MASTER SYSTEM PROMPT & WORKFLOW RULES
**Progetto:** Museo dell'Olio e della Civiltà Contadina (Fattoria Ciuppa Tasca) & Ecosistema Phygital.
**Direttiva Principale:** Questo file è il motore operativo del progetto. Definisce le regole di esecuzione, l'architettura delle informazioni e il protocollo di auto-apprendimento. 
**Importante:** Per il tono di voce e la filosofia strategica, fai SEMPRE riferimento a `identity.md`.

---

## 1. Struttura e Architettura dei File
*(Questa sezione descrive a livello logico la struttura del sistema per l'IA. È la mappa del progetto).*

**Sistema di File Markdown (.md) per IA:**
Creazione e gestione di file "main" per fornire istruzioni precise agli agenti IA. I file devono essere mantenuti costantemente aggiornati:
*   **`identity.md`:** Definisce la figura professionale di Michele (Digital Marketer, visione Phygital, ottimizzazione estrema).
*   **`contesto.md`:** Contiene tutto il background del museo, la storia, la logistica e il progetto Notion/Web.
*   **`claude.md`:** (Questo file) Linee guida, protocolli, workflow operativo e "tono di voce" per gli strumenti di coding (Claude Code/Antigravity/Cursor).
*   **`guida_museo.md`:** Documento di studio sul funzionamento del frantoio e sulla storia dei reperti per le visite guidate.
*   **Cartella `docs/`:** Qualsiasi nuovo piano di implementazione, script o documento di dettaglio futuro deve essere generato e salvato qui.

---

## 2. Protocollo di "Self-Healing" e Aggiornamento Autonomo (CRITICO)
Questo è un sistema **efficiente, pulito, ordinato e autoallenante**. Come IA, sei dotata di autonomia documentale. Devi rispettare tassativamente questa regola:
*   **Aggiornamento in Totale Autonomia:** Ogni volta che nella chat discutiamo, decidiamo o modifichiamo un concetto, una strategia, una password o un pezzo di codice che ha rilevanza a lungo termine, **DEVI aggiornare automaticamente e in background i file .md corrispondenti** (`contesto.md`, `guida_museo.md`, ecc.). Non chiedermi il permesso per aggiornare la documentazione: **fallo e basta**, e poi notificami brevemente l'avvenuto aggiornamento.
*   **Prevenzione dell'Oblio (Lost in the middle):** Non fare affidamento sulla memoria della chat. Tutto ciò che è importante deve risiedere nei file fisici.

---

## 3. Workflow Operativo Standard (Il Metodo)
Per ogni nuova richiesta di implementazione (modifica sito web, automazione Notion, creazione script), applica sempre questo ciclo:

1.  **Read & Align:** Leggi `identity.md` per il mindset e `contesto.md` per i dati.
2.  **Plan (docs/):** Se il task è complesso, crea prima un file di piano in formato Markdown nella cartella `docs/` (es. `docs/piano_calendario_luma.md`).
3.  **Execute (Bypass Mode):** Una volta che il piano è approvato (o se il task è semplice), esegui il lavoro senza fermarti. Se usi Antigravity o Claude Code, sfrutta gli strumenti MCP connessi in autonomia.
4.  **Test & Fix:** Se incontri un errore (es. in locale o via API), analizza il log, autocorreggi il tiro e riprova.
5.  **Document & Clear:** A lavoro concluso con successo, aggiorna i file `.md` master con le nuove modifiche implementate. Infine, ricordami di fare un *Commit/Save* del progetto e di pulire la chat (`/clear`) per risparmiare token.

---

## 4. Regole di Scrittura e Output
*   Nessun preambolo inutile, nessuna conclusione filosofica. Genera output densi, diretti e tecnici.
*   Se ti chiedo di generare contenuti per il pubblico (es. testi sito, newsletter), usa l'agente `@Copywriter` (se disponibile) e applica la lente "Phygital" descritta in `identity.md`.
*   Mantieni il codice pulito, modulare e documentato in italiano.