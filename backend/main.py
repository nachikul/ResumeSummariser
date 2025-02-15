from fastapi import FastAPI, File, UploadFile
import aiofiles

app = FastAPI()

@app.post("/summarize")
async def summarize(file: UploadFile = File(...)):
    content = await file.read()
    summary = f"Summary of the resume: {len(content)} characters long."
    return {"summary": summary}