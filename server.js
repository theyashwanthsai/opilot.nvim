const express = require('express')
const app = express()
const port = 3000
const bodyparser = require('body-parser')


app.use(bodyparser.json);

app.get('/', async (req, res) => {
  res.send('Hello World!')
})

let reqcode;

app.post('/getcode', async (req, res) => {
  const { code } = req.body;
  reqcode= code;
  res.send('Got it!');
})

app.get('/apires', async (req, res) => {

})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
