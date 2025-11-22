#!/bin/bash
source activate biomni_e1
uvicorn main:app --reload --host 0.0.0.0 --port 4991
