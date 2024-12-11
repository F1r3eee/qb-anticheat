# QBCore Anti-Cheat

**QBCore Anti-Cheat** è un potente sistema anti-cheat progettato per server FiveM basati su QBCore. Fornisce protezione avanzata contro exploit, cheat e altre attività sospette, con aggiornamenti automatici per rimanere sempre al passo con le ultime minacce.

---

## **Caratteristiche**
- **Rilevamento dinamico degli exploit**: Blocca eventi sospetti e attività non autorizzate.
- **Protezione avanzata contro armi vietate**: Rimuove automaticamente le armi proibite dai giocatori.
- **Blacklist remota degli exploit**: Si aggiorna automaticamente tramite un file JSON remoto.
- **Log centralizzato**: Ogni rilevamento viene registrato in tempo reale su un webhook Discord.
- **Aggiornamenti automatici**: Scarica nuove firme di exploit senza bisogno di riavviare il server.
- **Configurazione personalizzabile**: Adattabile alle esigenze specifiche del server.

---

## **Struttura del Progetto**

```plaintext
qb-anticheat/
├── fxmanifest.lua
├── server/
│   ├── anticheat.lua       # Script principale lato server
│   ├── updater.lua         # Sistema di aggiornamento
├── client/
│   ├── detection.lua       # Script di rilevamento lato client
│   └── monitor.lua         # Monitoraggio processi sospetti
├── config/
│   └── config.lua          # Configurazione globale
├── logs/
│   └── logs.json           # Log locali (se abilitati)
└── README.md               # Documentazione

## **Installazione**

1. Scarica i file: Estrai la cartella **qb-anticheat** nella cartella **resources** del tuo server FiveM.

2. Aggiungi al **server.cfg:**

```start qb-anticheat```

3. Configura il file **config/config.lua:**

    - Modifica i valori del file di configurazione secondo le tue necessità (distanza di teletrasporto, velocità massima, armi vietate, ecc.).
4. Imposta il Webhook Discord:

     -Puoi impostare un webhook Discord per inviare log di violazioni. Aggiungi il tuo URL del webhook nel campo logWebhook nel file di configurazione.

## **Configurazione**
Il sistema anticheat è altamente personalizzabile tramite il file **config/config.lua.** Ecco una panoramica delle opzioni di configurazione disponibili:

## **Parametri di configurazione:**

```Config = {
    serverCheckInterval = 60000, -- Intervallo di controllo aggiornamenti (ms)
    updateUrl = "https://your-update-url.com/rules.json", -- URL aggiornamenti regole
    logWebhook = "https://discord.com/api/webhooks/...", -- Webhook per log Discord
    armiVietate = {
        [`WEAPON_MINIGUN`] = true,
        [`WEAPON_RPG`] = true
    },
    maxVelocita = 50.0, -- Velocità massima consentita (km/h)
    maxTeleportDistance = 200.0, -- Distanza massima per rilevazione teletrasporto (metri)
    veicoliVietati = {
        [`RHINO`] = true, 
        [`LAZER`] = true
    },
    maxEventFrequency = 5, -- Numero massimo di eventi per secondo
    maxPositionUpdateInterval = 5000, -- Tempo massimo senza aggiornamento posizione
    areeVietate = {
        { x = 0.0, y = 0.0, z = 0.0, radius = 50.0 }, -- Esempio area vietata
    },
    messaggiAvviso = {
        velocita = "Hai superato il limite di velocità consentito!",
        armaVietata = "Stai usando un'arma vietata!",
        teleport = "Sei stato rilevato a una distanza sospetta!"
    },
    salvaLogLocale = true
}```

## **Descrizione delle impostazioni:**
- **serverCheckInterval:** Intervallo (in millisecondi) in cui il server verifica gli aggiornamenti delle regole.
- **updateUrl:** URL dal quale il server scarica le regole aggiornate.
- **logWebhook:** Webhook Discord dove verranno inviati i log delle violazioni.
- **armiVietate:** Lista delle armi vietate. Puoi aggiungere altre armi utilizzando il nome dell'arma (ad esempio, WEAPON_MINIGUN).
- **maxVelocita:** La velocità massima consentita in km/h.
- **maxTeleportDistance:** La distanza massima tra due aggiornamenti di posizione per evitare il teletrasporto.
- **veicoliVietati:** Lista di veicoli vietati. Se un giocatore usa uno di questi veicoli, verrà registrata una violazione.
- **maxEventFrequency:** Limite di eventi per secondo per prevenire il flood degli eventi.
- **maxPositionUpdateInterval:** Limite di tempo tra due aggiornamenti di posizione per rilevare teleport.
- **areeVietate:** Definisce delle aree vietate, se un giocatore entra in queste zone, verrà registrata una violazione.
- **messaggiAvviso:** Messaggi di avviso personalizzati per velocità e altri comportamenti illeciti.
- **salvaLogLocale:** Abilita o disabilita il salvataggio dei log localmente.

## **Funzionalità**

## Controlli Client

- **Velocità:** Se un giocatore supera il limite di velocità definito (in km/h), verrà loggata una violazione.

- **Posizione:** Controllo delle distanze tra i teletrasporti per prevenire l'uso di teletrasporti illeciti.

- **Armi Vietate:** Se un giocatore equipaggia un'arma vietata, questa verrà rimossa automaticamente e verrà registrata una violazione.
## Controlli Server

- **Armi vietate:** Verifica e rimuove le armi vietate dai giocatori.

- **Teletrasporti sospetti:** Se un giocatore si sposta troppo velocemente tra due punti, verrà registrata una violazione.

- **Flood di eventi:** Controlla che i giocatori non inviino troppi eventi in un breve periodo (prevenzione di exploit come il flood).

- **Log delle violazioni:** Le violazioni vengono inviate a un webhook Discord per una gestione centralizzata.

## Aggiornamento Automatico delle Regole
Il sistema è progettato per verificare periodicamente gli aggiornamenti delle regole tramite un URL specificato. Se le regole vengono aggiornate, il sistema le applicherà automaticamente.

## **Monitoraggio e Log**
Tutte le violazioni vengono inviate a un webhook Discord, che ti consente di monitorare in tempo reale le attività sospette sul tuo server. Inoltre, se abilitato, il sistema salva i log localmente in un file JSON.

## Codice per il Monitoraggio dei Log

```function LogViolation(playerId, playerName, reason)
    -- Log su Discord
    if Config.logWebhook then
        PerformHttpRequest(Config.logWebhook, function() end, 'POST', json.encode({
            username = "QBCore Anti-Cheat",
            embeds = {{
                title = "Violazione rilevata",
                description = ("Giocatore: %s\nID: %s\nMotivo: %s"):format(playerName, playerId, reason),
                color = 16711680
            }}
        }), {['Content-Type'] = 'application/json'})
    end
end```
## Esempio di Controllo Server
```RegisterServerEvent('qb-anticheat:checkPlayer')
AddEventHandler('qb-anticheat:checkPlayer', function()
    local src = source
    local playerName = GetPlayerName(src)

    -- Controllo delle armi vietate
    local weapons = GetPlayerWeapons(src)
    for _, weapon in ipairs(weapons) do
        if Config.armiVietate[weapon] then
            TriggerClientEvent('qb-anticheat:removeWeapon', src, weapon)
            LogViolation(src, playerName, "Uso di arma vietata: " .. weapon)
        end
    end
end)```
## Controllo e Aggiornamento Automatico delle Regole
Il server esegue controlli periodici per aggiornare le regole in tempo reale. Ogni volta che vengono scaricate nuove regole, vengono applicate automaticamente.

## Codice di Aggiornamento Automatico
```CreateThread(function()
    while true do
        Wait(Config.serverCheckInterval)

        PerformHttpRequest(Config.updateUrl, function(statusCode, response, headers)
            if statusCode == 200 then
                local rules = json.decode(response)
                -- Applica le regole aggiornate
                UpdateRules(rules)
            end
        end)
    end
end)

function UpdateRules(rules)
    -- Aggiorna le regole del server
    Config.regole = rules
end```
## **Supporto**
Per qualsiasi problema o domanda, apri una issue su GitHub o contattami via Discord (f1r3ee).

## **Conclusione** 
Questo sistema anticheat è progettato per essere altamente configurabile e per proteggere il tuo server da numerosi tipi di exploit. Aggiorna regolarmente il sistema per rimanere al passo con le nuove minacce e mantenere il tuo server sicuro e stabile.

Assicurati che tutte le configurazioni siano impostate correttamente prima di avviare il server. Buon divertimento nel mantenere il tuo server sicuro!

