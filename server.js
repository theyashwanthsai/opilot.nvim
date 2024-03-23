const express = require('express')
const app = express()
const port = 3000
const bodyparser = require('body-parser')


app.use(bodyparser.json);

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.post('/getcode', (req, res) => {
  const { code } = req.body;

})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
