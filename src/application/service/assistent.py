from src.domain.assistent import Message
from src.domain.port.assistent import AssistentPort


class AssistentService:
    _adapter: AssistentPort

    def __init__(self, assistent_adapter: AssistentPort) -> None:
        self._adapter = assistent_adapter

    def prompt(self, message: Message) -> Message:
        return self._adapter.prompt(message)
