# Documentazione degli end point


## Lista delle canzoni

Per ottenre la lista completa delle cazoni disponibili, utilizzare il seguente end point come segue:

```bash
curl -H "Authorization: <MASTER_PASSWORD>" http://localhost:3000/songs
```

Per la corretta esecuzione dell'operazione richiesta, è necessario specificare la master password del server in chiaro nel campo `Authorization` della richiesta HTTP.

La chiamata a questo enpoint ritorna un oggetto JSON contenente i dati delle canzoni disponibili. Un esempio potrebbe essere il seguente:

```json
[
    {
        "_id": "<ID>",
        "title": "Trance in Heaven",
        "artist": "Lagoona",
        "genre": "Trance",
        "start": "88.260",
        "length": "15.260",
        "bpms": "0.000=144.970"
    },
    {
        "_id": "<ID>",
        "title": "Conflicting Passions",
        "artist": "Falcom Sound Team JDK",
        "genre": "Electro",
        "start": "93.960",
        "length": "18.580",
        "bpms":"0.000=205.001"
    }
]
```

## Audio di una canzone

Per ottenre la traccia audio in Base64 di una canzone, utilizzare il seguente end point come segue:

```bash
curl -H "Authorization: <MASTER_PASSWORD>" http://localhost:3000/song/<ID>/audio
```

Per la corretta esecuzione dell'operazione richiesta, è necessario specificare la master password del server in chiaro nel campo `Authorization` della richiesta HTTP e l'identificativo della traccia.

La chiamata a questo enpoint ritorna un oggetto JSON contenenre l'identificativo della canzone e l'audio in Base64. Un esempio potrebbe essere il seguente:

```json
{
    "_id": "<ID>",
    "b64": "<AUDIO_BASE64>"
}
```


## Reticolo delle note di una canzone

Per ottenre il reticolo delle note di una canzone, utilizzare il seguente end point come segue:

```bash
curl -H "Authorization: <MASTER_PASSWORD>" http://localhost:3000/song/<ID>/notes
```

Per la corretta esecuzione dell'operazione richiesta, è necessario specificare la master password del server in chiaro nel campo `Authorization` della richiesta HTTP e l'identificativo della traccia.

La chiamata a questo enpoint ritorna un oggetto JSON contenente l'identificativo della canzone e il reticolo delle note ad essa associato. Un esempio potrebbe essere il seguente:

```json
{
    "_id": "<ID>",
    "notes": [
        ["0000", "0000", "0000", "0000"],
        ["1100", "0000", "0000", "0000"],
        ["0001", "0000", "0000", "0000"],
        ["1000", "0000", "0000", "0000"]
    ]
}
```
