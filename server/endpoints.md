# Documentazione degli end point


## Lista delle canzoni

Per ottenere la lista completa delle cazoni disponibili, utilizzare il seguente end point come segue:

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
        "preview": {
            "start": "88.260",
            "length": "15.260"
        },
        "spn": "0.45"
    },
    {
        "_id": "<ID>",
        "title": "Conflicting Passions",
        "artist": "Falcom Sound Team JDK",
        "genre": "Electro",
        "preview": {
            "start": "93.960",
            "length": "18.580",
        },
        "spn": "0.35"
    }
]
```

## Reticolo delle note di una canzone

Per ottenere il reticolo delle note di una canzone, utilizzare il seguente end point come segue:

```bash
curl -H "Authorization: <MASTER_PASSWORD>" http://localhost:3000/songs/<ID>/notes
```

Per la corretta esecuzione dell'operazione richiesta, è necessario specificare la master password del server in chiaro nel campo `Authorization` della richiesta HTTP e l'identificativo della traccia.

La chiamata a questo enpoint ritorna un oggetto JSON contenente l'identificativo della canzone e il reticolo delle note ad essa associato (ogni nota si contraddistingue per il suo indice). Un esempio potrebbe essere il seguente:

```json
{
    "_id": "<ID>",
    "notes": [
        {
            "index": 0,
            "content": [0, 0, 0, 0]
        },
        {
            "index": 1,
            "content": [0, 1, 0, 0]
        }
    ]
}
```

## Audio di una canzone

Per ottenere la traccia audio in Base64 di una canzone, utilizzare il seguente end point come segue:

```bash
curl -H "Authorization: <MASTER_PASSWORD>" http://localhost:3000/songs/<ID>/audio
```

Per la corretta esecuzione dell'operazione richiesta, è necessario specificare la master password del server in chiaro nel campo `Authorization` della richiesta HTTP e l'identificativo della traccia.

La chiamata a questo enpoint ritorna un oggetto JSON contenenre l'identificativo della canzone e l'audio in Base64. Un esempio potrebbe essere il seguente:

```json
{
    "_id": "<ID>",
    "audio": "<AUDIO_BASE64>"
}
```

## Thumbnail di una canzone

Per ottenere la thumbnail in Base64 di una canzone, utilizzare il seguente end point come segue:

```bash
curl -H "Authorization: <MASTER_PASSWORD>" http://localhost:3000/songs/<ID>/thumbnail
```

Per la corretta esecuzione dell'operazione richiesta, è necessario specificare la master password del server in chiaro nel campo `Authorization` della richiesta HTTP e l'identificativo della traccia.

La chiamata a questo enpoint ritorna un oggetto JSON contenenre l'identificativo della canzone e la thumbnail in Base64. Un esempio potrebbe essere il seguente:

```json
{
    "_id": "<ID>",
    "thumbnail": "<THUMBNAIL_BASE64>"
}
```

## Top 50 di una canzone

Per ottenere la classifica top 50 di una canzone, utilizzare il seguente end point come segue:

```bash
curl -H "Authorization: <MASTER_PASSWORD>" http://localhost:3000/chart/<ID>
```

Per la corretta esecuzione dell'operazione richiesta, è necessario specificare la master password del server in chiaro nel campo `Authorization` della richiesta HTTP e l'identificativo della traccia.

La chiamata a questo enpoint ritorna un oggetto JSON contenenre l'identificativo della canzone e la thumbnail in Base64. Un esempio potrebbe essere il seguente:

```json
[
    {
        "_id": "<ID>",
        "name": "SNK",
        "score":3,
        "song_id":"<SONG_ID>"
    }
]
```

## Aggiunta di un record alla classifica di una canzone

Per aggiungere un record alla classifica di una canzone, utilizzare il seguente end point come segue:

```bash
curl -X POST -H "Authorization: <MASTER_PASSWORD>" -H "Content-Type: application/json" http://localhost:3000/chart/<ID> -d "<BODY>"
```

Per la corretta esecuzione dell'operazione richiesta, è necessario specificare la master password del server in chiaro nel campo `Authorization` della richiesta HTTP e l'identificativo della traccia. Inoltre, è necessario specificare il `Content-Type`.

Un esempio di corpo della richiesta è il seguente:

```json
{
    "name": "SNK",
    "score": 3
}
```

La chiamata a questo enpoint non restituisce nessun oggetto, solo codici HTTP.
