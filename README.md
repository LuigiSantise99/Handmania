# handmania

HandMania è un DDR ispirato a [StepMania](http://www.stepmania.com/) che sfrutta la posizione delle mani dell'utente per giocare. L'applicativo è stato sviluppato come progetto per l'esame di "Sviluppo di Applicazioni per Dispositivi Mobili" per l'Anno Accademico 2021/2022.


## Prerequisiti

Oltre ai tool relativi ai linguaggi di programmazione utilizzati per lo sviluppo (Python, JavaScript via NodeJS e Swift), per un corretto funzionamento è necessario installare localmente MongoDB. Quest'ultimo viene utilizzato per gestire le canzoni e la classifica.


## Descrizione dei moduli

- `app`: codice relativo al front-end dell'applicazione. Implementa le meccaniche di gioco.

- `converter`:  codice di utility per convertire un pacchetto di canzoni di StepMania in un formato accettato dal front-end e per caricare questi elementi convertiti nel database Mongo installato localmente.

- `server`: codice relativo al server utilizzato per interfacciarsi con la base di dati caricata su Mongo. L'implementazione è basica e volutamente sprovvista di meccanismi di sicurezza adeguati.


## Passi per eseguire correttamente l'applicativo.

1. Scaricare un song pack di StepMania e salvare il contenuto nella directory `converter/inout/songs`. Si definisce un pacchetto come valido se composto da una sottodirectory per canzone che contiene il simfile, la traccia audio in formato MP3, una thumbnail e un reticolo di note per la difficoltà `Beginner` single player.

2. Lanciare l'esecuzione dello script `converter/converter.py`. Questo si occuperà di effettuare la conversione e salverà i documenti JSON rappresentati le singole canzoni nella directory `converter/inout/converted`.

3. Lanciare l'esecuzione dello script `converter/uploader.py`. Questo si occuperà di caricare i documenti relativi alle canzoni convertite sul database Mongo installato localmente nella collezione `handmania/songs`.

4. Lanciare l'esecuzione dello script relativo al server `server/index.js`. Questo è possibile anche attraverso l'apposito comando `npm` definito.

5. Lanciare l'applicazione.


## Avvertenze

Per esigenze legate allo spazio di archiviazione, tutti gli asset grafici e il pacchetto di canzoni utilizzato per i test sono stati esclusi dal repository.
