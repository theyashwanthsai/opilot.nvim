const express = require('express')
const app = express()
const port = 3000
const bodyparser = require('body-parser')
require('dotenv').config()

app.use(bodyparser.json);

async function query(data) {
	const response = await fetch(
		"https://api-inference.huggingface.co/models/codellama/CodeLlama-13b-hf",
		{
			headers: { Authorization: `${process.env.API}` },
			method: "POST",
			body: JSON.stringify(data),
		}
	);
	const result = await response.json();
	return result;
}




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
  // let rescode;
  try{
    const respone = await query({"inputs": "def sum(a, b): "})	  
    console.log("Hit the endpoint")
	  console.log(JSON.stringify(response));
	  res.send(response)
  } catch (error){
    res.send('error')
  } 
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
