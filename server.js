const express = require('express')
const app = express()
const port = 3000
const bodyparser = require('body-parser')
require('dotenv').config()

app.use(bodyparser.json());

async function query(data) {
	const response = await fetch(
		"https://api-inference.huggingface.co/models/codellama/CodeLlama-13b-hf",
		{
			headers: { 
          Authorization: `Bearer ${process.env.API}`, 
          'Content-Type': 'application/json',
      },
			method: "POST",
			body: JSON.stringify(data),
		}
	);
	const result = await response.json();
	return result;
}

app.get('/', (req, res) => {
  res.send('Hello World!')
})

let reqcode = "#include<stdio.h>\nint sum(int a, int b){";
app.post('/getcode', async (req, res) => {
  const code = req.body;  
  console.log(code)
  try{
    console.log("/getcode endpoint hit!")
    reqcode= code;
    // console.log(reqcode)
    res.send(reqcode);
  } catch(error){
      res.send(error.message)
  }
})

let rescode;
// Todo - Figure out a way to send this response to my plugin, 
// ans variable contains the code (proper format) i need to send this to lua plugin. 
// And from there i need to append to the current buffer.
app.get('/apires', async (req, res) => {
  try{
    if (reqcode) {
      console.log("/apires endpoint hit!");
      const response = await query({"inputs": reqcode.code});
      let ans = response[0].generated_text;
      console.log(ans);
      rescode = ans;
      res.send(rescode)
    } else {
      res.send("No code provided, please press undo (U)");
    }	  
    // console.log(JSON.stringify(response));
	  // res.send(response);
  } catch (error){
      res.send(error.code);
  } 
})




app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
