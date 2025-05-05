from abc import ABC, abstractmethod
from config.logger import setup_logging

TAG = __name__
logger = setup_logging()


class HistoryProviderBase(ABC):
    def __init__(self, config):
        self.user_id = None
        self.agent_id = None
        self.device_id = None
        self.config = config

    @abstractmethod
    async def save_chat_history(self, msgs):
        print("this is base func", msgs)

    def init_history(self, device_id, llm):
        self.device_id = device_id
        self.llm = llm
