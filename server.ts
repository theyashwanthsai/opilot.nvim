import express, { Request, Response } from 'express';
import bodyParser from 'body-parser';
import fetch from 'node-fetch';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const port: number = 3000;


app.use(bodyParser.json());

async function query(data: { inputs: string }): Promise<any> {
  const response = await fetch(
    "https://api-inference.huggingface.co/models/codellama/CodeLlama-13b-hf",
    {
      headers: {
        Authorization: `Bearer ${process.env.API}`,
        'Content-Type': 'application/json'
      },
      method: 'POST',
      body:JSON.stringify(data),
    }
  );
  const result = await response.json();
  return result;
}


// recieve code from nvim plugin, use this code, send it to huggingface
// get the output. 
// Use this output and perform operations (todo) and send back to nvim

let reqcode: string = "";
app.post('/getcode', async (req: Request, res: Response) => {
  const code: { code: string } = req.body;
  console.log(code)
  try{
    console.log("/getcode endpoint hit!");
    reqcode = code.code;
    res.send(reqcode);
  } catch(error: any){
    res.send(error.message);
  }
})


// Todo - Figure out a way to send this response to my plugin, 
// ans variable contains the code (proper format) i need to send this to lua plugin. 
// And from there i need to append to the current buffer.

let rescode: string;
app.get('/apires', async (req: Request, res: Response) => {
  try{
    if(reqcode){
      console.log("/apires endpoint hit!");
      const response = await query({ "inputs": reqcode });
      let ans: string = response[0].generated_text;
      // console.log(ans);
      rescode = ans;
      if (rescode.startsWith(reqcode)) {
        rescode = rescode.slice(reqcode.length).trim();
      }
      console.log(rescode)
      res.send(rescode);
    }
    else{
      res.send("No code provided, Please press undo (U)")
    }
  } catch(error: any){
    res.send(error.code)
  }
})


app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
})
