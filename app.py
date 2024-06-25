import gradio as gr
from langchain_community.llms.huggingface_pipeline import HuggingFacePipeline
from langchain_core.prompts import PromptTemplate
from langchain.chains import LLMChain
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
import torch

# Define the Hugging Face model
model_name = "manohar02/final-Llama-2-7b-quantize"

# Load the tokenizer and quantized model
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name, quantize=True)

# Define the Hugging Face pipeline for text generation
text_gen_pipeline = pipeline(
    "text-generation",  # task
    model=model,
    tokenizer=tokenizer,
    device=-1,  # Use CPU
    max_length=20000,
    do_sample=True,
    top_k=10,
    num_return_sequences=1,
    eos_token_id=tokenizer.eos_token_id
)

# Define the LLM using the Hugging Face pipeline
llm = HuggingFacePipeline(pipeline=text_gen_pipeline, model_kwargs={'temperature': 0})

# Define the template for summarization
template = """
Write a concise summary of the following text delimited by triple backquotes.
'''{text}'''
SUMMARY:
"""

prompt = PromptTemplate(template=template, input_variables=["text"])

# Define the LLMChain for the summarization task
llm_chain = LLMChain(prompt=prompt, llm=llm)

# Function to generate summary
def generate_summary(text):
    summary = llm_chain.run(text)
    return summary.split('SUMMARY:')[-1].strip()

# Create a Gradio interface
iface = gr.Interface(fn=generate_summary, inputs="text", outputs="text", title="LLaMA2 Summarizer")
iface.launch()
