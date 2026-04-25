# Progetto: Workspace Notion Museo Ciuppa Tasca

**Tipo:** Ecosistema IT / Frontend Operativo
**Fonti collegate:** [Prompt Museo_Notion.md](../raw/Prompt Museo_Notion.md), [Sistema_Operativo_AI.md](Sistema_Operativo_AI.md)

L'architettura del workspace Notion funge da CRM e interfaccia visiva ("Frontend") dell'intero museo, differenziandosi dai file locali sorgente. E' progettato per unire gestione eventi, attività e procedure in un unico ambiente "Phygital".

## Architettura a due livelli

### 1. Backend (Databases Master)
Punto di raccolta dati invisibile all'uso quotidiano, si compone di quattro master database:
- **DB_Appuntamenti (Luma Ready):** Gestione prenotazioni. Traccia data, tipologia evento (Visita, Laboratorio Saponi, Outdoor), contatti e stato (Confermato/Annullato).
- **DB_CRM_Contatti:** Raccoglitore contatti istituzionali, scuole e partnership B2B organizzati in funnel (Lead -> Acquisito).
- **DB_Tasks:** Gestione scadenze e operatività del team.
- **DB_Wiki_Appunti:** Per appunti veloci e logiche di marketing a uso umano.

### 2. Frontend (Dashboard HQ "🏛️ MUSEO CIUPPA TASCA - HQ")
Il cruscotto operativo usato quotidianamente (Annibale e Vittorio):
- Estetica **minimale, ariosa e full-width**. Icone monocromatiche Notion.
- **Colonna Sinistra:** Operatività pura (Linked Views su Task Aperti in layout "Lista" ristretta, e Appunti in "Galleria" senza preview).
- **Colonna Destra:** Relazioni e clienti (Linked Views in formato Calendario per gli appuntamenti e tabella per il CRM).

## Pagine Statiche Fondamentali
Ospitata direttamente nella Dashboard HQ:
1. **Storia e Funzionamento Museo:** Generata aggregando la storia della famiglia e il "Ciclo dell'Olio" dalle fonti locali, includendo la menzione a sculture chiave (Il Busto dell'Arbusto).
2. **Accessi e Credenziali:** Callout di massima sicurezza per tenere unificate le credenziali critiche di accesso via web (KM ZERO, Webmail, Gmail, Social vari).

> [!tip] Regola Visuale UI/UX
> Per prevenire confusione mentale o accavallamenti testuali, le viste di database (Linked Views) in Frontend devono **sempre** nascondere l'header col nome del database originale, operando a puro impatto visivo. I callout usano sfondi trasparenti.
