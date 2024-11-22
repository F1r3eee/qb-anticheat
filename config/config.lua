Config = {
    -- Intervallo di controllo aggiornamenti (ms)
    serverCheckInterval = 60000, 

    -- URL aggiornamenti regole
    updateUrl = "https://your-update-url.com/rules.json", 

    -- Webhook per log Discord
    logWebhook = "https://discord.com/api/webhooks/...", 

    -- Armi vietate
    armiVietate = {
        [`WEAPON_MINIGUN`] = true,
        [`WEAPON_RPG`] = true,
        [`WEAPON_GRENADE`] = true,
        [`WEAPON_GRENADELAUNCHER`] = true,
        [`WEAPON_RAILGUN`] = true,
        [`WEAPON_HOMINGLAUNCHER`] = true,
        [`WEAPON_PROXMINE`] = true,
        [`WEAPON_STICKYBOMB`] = true
    },

    -- Velocità massima consentita (km/h)
    maxVelocita = 50.0, 

    -- Distanza massima per rilevazione teletrasporto (metri)
    maxTeleportDistance = 200.0, 

    -- Lista nera di veicoli vietati
    veicoliVietati = {
        [`RHINO`] = true, 
        [`LAZER`] = true,
        [`HYDRA`] = true,
        [`INSURGENT`] = true
    },

    -- Limite di eventi per flood detection
    maxEventFrequency = 5, -- Numero massimo di eventi per secondo

    -- Tempo massimo senza aggiornamento posizione del giocatore (teleport check)
    maxPositionUpdateInterval = 5000, -- In millisecondi

    -- Coordinate vietate per rilevazione cheat (aree fuori mappa)
    areeVietate = {
        { x = 0.0, y = 0.0, z = 0.0, radius = 50.0 }, -- Esempio area vietata
        { x = -5000.0, y = -5000.0, z = -5000.0, radius = 100.0 }
    },

    -- Messaggi di avviso personalizzati per i giocatori
    messaggiAvviso = {
        velocita = "Hai superato il limite di velocità consentito!",
        armaVietata = "Stai usando un'arma vietata!",
        teleport = "Sei stato rilevato a una distanza sospetta!"
    },

    -- Log locali abilitati
    salvaLogLocale = true
}
