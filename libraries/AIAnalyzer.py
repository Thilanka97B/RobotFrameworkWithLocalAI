import requests


class AIAnalyzer:
    def analyze_failure(self, error_message):
        prompt = f"""
        You are a QA automation expert.

        Analyze this Robot Framework automation failure.
        Use only the error message below. Do not invent tools, services,
        dependencies, scripts, or project names that are not mentioned.
        If the error says execution was terminated by signal, explain that
        the run was likely interrupted manually or stopped by the environment.

        Failure message:

        {error_message}

        Provide:
        1. Root cause
        2. Fix suggestion
        3. Severity (Low/Medium/High)
        """

        try:
            response = requests.post(
                "http://localhost:11434/api/generate",
                json={
                    "model": "qwen2.5:1.5b",
                    "prompt": prompt,
                    "stream": False,
                },
                timeout=60,
            )
            response.raise_for_status()
            return response.json()["response"]
        except requests.RequestException as error:
            return f"AI Failure Analyzer could not reach Ollama: {error}"
        except (KeyError, ValueError):
            return f"AI Failure Analyzer received an unexpected Ollama response: {response.text}"
