# Sistema: Operatività AI e Regole Piattaforma

**Tipo:** Ecosistema IT / Direttive
**Fonti collegate:** [claude.md](../raw/claude.md)

## Architettura dei Contesti (Separation of Concerns)
Per evitare il *context drift*, i file operativi si spartiscono la sovranità in modo gerarchico:
- **Il Chi (Stile e Strategia):** Dettato dalle regole in [Identity_Michele](Identity_Michele.md).
- **Il Come (Regole tech di progetto):** Dettate da questa stessa mappa di sistema e dai prompt specifici. Le direttive di task vincono SEMPRE sulle istruzioni di stile se sono in conflitto.
- **I Fatti Storici (Il Cosa):** Preservati intatti nelle fonti originali in `raw/` e filtrati in `wiki/`. *Mai inventare best practice industriali dove non previste*.

## Hub Operativi
La distinzione netta tra le interfacce è la seguente:
1. **Locale (Workspace Markdown):** La "sala server" o "IDE". Qui io e l'intelligenza artificiale automatizziamo, programmiamo codice (`scripts/`), generiamo copy e lavoriamo di struttura tramite Wiki (questa cartella).
2. **Notion:** L'hub "visivo" e la dashboard finale. Funge da CRM per gestire la fattoria e per esporre la strategia a persone reali.

## Il Metodo RPECS
L'agente AI su terminale opera secondo un ciclo standard:
1. **R (Read):** Lettura dei contesti e analisi.
2. **P (Plan):** Sviluppo logico se tocca più file (es. creazione *Implementation Plan*).
3. **E (Execute):** Azione sui file/uso MCP.
4. **C (Fix/Correct):** Auto-riparazione immediata e invisibile di eventuali bug minori post esecuzione.
5. **S (Sync):** Pulizia task, aggiornamento file `.md` master e auto-commit ritmico su server (es. Github).

## Automazione e Self-Healing
Qualora cambino procedure o nozioni storiche del museo, l'IA aggiornerà i propri file core usando file I/O (es. `write_to_file`), in modo silente, assicurandosi che il sistema "risani se stesso". Quando si fa riferimento ad Agenti specializzati, questi vanno codificati nella root degli script o degli agenti.
