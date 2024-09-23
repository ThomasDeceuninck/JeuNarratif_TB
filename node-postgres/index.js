const express = require('express')
const bodyParser = require('body-parser');
const app = express()
const port = 3001

const db_request = require('./db_request')

app.use(express.json())
app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', 'http://localhost:19006');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Access-Control-Allow-Headers');
  next();
});
app.use(bodyParser.json());

app.get('/bibli', (req, res) => {
  db_request.getBibli()
  .then(response => {
    res.status(200).send(response);
  })
  .catch(error => {
    res.status(500).send(error);
  })
})

app.get(`/biblitag/:tag`, (req, res) => {
    db_request.getBibliTag(req.params.tag)
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(500).send(error);
    })
})

app.get(`/biblipseudo/:pseudo`, (req, res) => {
    db_request.getBibliPseudo(req.params.pseudo)
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(500).send(error);
    })
})

app.get(`/biblititre/:titre`, (req, res) => {
    db_request.getBibliTitre(req.params.titre)
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(500).send(error);
    })
})

app.get(`/getContenuStart/:id`, (req, res) => {
    db_request.getContenuStart(req.params.id)
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(500).send(error);
    })
})

app.get(`/getContenuNext/:id`, (req, res) => {
    db_request.getContenuNext(req.params.id)
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(500).send(error);
    })
})

app.post(`/postLivre`, (req, res) => {
  db_request.postLivre(req.body.titre, req.body.auteur, req.body.contenu, req.body.resolution)
  .then(response => {
    res.status(200).send(response);
  })
  .catch(error => {
    res.status(500).send(error);
  })
})

app.post(`/postContenu`, (req, res) => {
  db_request.postContenu(req.body.contenu)
  .then(response => {
    res.status(200).send(response);
  })
  .catch(error => {
    res.status(500).send(error);
  })
})

app.post(`/postResolution`, (req, res) => {
  db_request.postResolution(req.body.resolution, req.body.num)
  .then(response => {
    res.status(200).send(response);
  })
  .catch(error => {
    res.status(500).send(error);
  })
})



app.listen(port, () => {
  console.log(`App running on port ${port}.`)
})
