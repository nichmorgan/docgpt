from fastapi import FastAPI

__all__ = ("run_app",)


def _run_development(app: FastAPI, port: int):
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=port)


def run_app(app: FastAPI, port: int):
    _run_development(app, port)
