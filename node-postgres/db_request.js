const Pool = require('pg').Pool
const pool = new Pool({
  user: process.env.POSTGRES_USER,
  host: process.env.POSTGRES_URL,
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: 5432,
});

const getBibli = () => {
    return new Promise(function(resolve, reject) {
      pool.query('SELECT * FROM select_bibli_fctn()', (error, results) => {
        if (error) {
          reject(error)
        }
        console.log('Query results:', results); // Ajout d'un log pour voir le contenu de `results` src: mickael
        if (!results || !results.rows) {
          console.error('No rows found in results');
          return reject(new Error('No rows found'));
        }
        resolve(results.rows);
      })
    }) 
  }

const getBibliTag = (tag) => {
  return new Promise(function(resolve, reject) {
    pool.query(`SELECT * FROM select_bibli_tag_fctn(\'${tag}\')`, (error, results) => {
      if (error) {
        reject(error)
      }
      resolve(results.rows);
    })
  }) 
}

const getBibliPseudo = (pseudo) => {
  return new Promise(function(resolve, reject) {
    pool.query(`SELECT * FROM select_bibli_pseudo_fctn(\'${pseudo}\')`, (error, results) => {
      if (error) {
        reject(error)
      }
      resolve(results.rows);
    })
  }) 
}

const getBibliTitre = (titre) => {
  return new Promise(function(resolve, reject) {
    pool.query(`SELECT * FROM select_bibli_titre_fctn(\'${titre}\')`, (error, results) => {
      if (error) {
        reject(error)
      }
      resolve(results.rows);
    })
  }) 
}

const getContenuStart = (id_livre) => {
  return new Promise(function(resolve, reject) {
    pool.query(`SELECT * FROM get_contenu_by_livre_start(\'${id_livre}\')`, (error, results) => {
      if (error) {
        reject(error)
      }
      resolve(results.rows);
    })
  }) 
}

const getContenuNext = (id_contenu) => {
  return new Promise(function(resolve, reject) {
    pool.query(`SELECT * FROM get_contenu_by_livre_Next(\'${id_contenu}\')`, (error, results) => {
      if (error) {
        reject(error)
      }
      resolve(results.rows);
    })
  }) 
}

const postLivre = (titre, auteur, contenu, resolution) => {
  return new Promise(function(resolve, reject) {
    pool.query(`SELECT * FROM post_livre(\'${titre}\', 0);
    SELECT * FROM post_story_contenu(array[${contenu}]::type_contenu[]);
    SELECT * FROM post_story_resolution(array[${resolution}]::type_resolution1[]);`, (error, results) => {
      if (error) {
        reject(error)
      }
      resolve(results.rows);
    })
  }) 
}

const postContenu = (contenu) => {
  return new Promise(function(resolve, reject) {
    pool.query(`SELECT * FROM post_story_contenu(array[${contenu}]::type_contenu[])`, (error, results) => {
      if (error) {
        reject(error)
      }
      resolve(results.rows);
    })
  }) 
}

const postResolution = (resolution, contenuNum) => {
  return new Promise(function(resolve, reject) {
    pool.query(`SELECT * FROM post_story_resolution(array[${resolution}]::type_resolution1[], ${contenuNum})`, (error, results) => {
      if (error) {
        reject(error)
      }
      resolve(results.rows);
    })
  }) 
}


  module.exports = {
    getBibli,
    getBibliTag,
    getBibliPseudo,
    getBibliTitre,
    getContenuStart,
    getContenuNext,
    postLivre,
    postContenu,
    postResolution,
  }