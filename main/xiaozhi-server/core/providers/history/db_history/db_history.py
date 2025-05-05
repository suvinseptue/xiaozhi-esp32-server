import json
from abc import ABC

from ..base import HistoryProviderBase, logger
from config.manage_api_client import init_service, save_chat_server


class DbHistoryProvider(HistoryProviderBase, ABC):

    def __init__(self, config):
        super().__init__()
        self.config = config

    def init_history(self, device_id, llm):
        super().init_history(device_id, llm)

    def save_chat_history(self, msgs):
        init_service(self.config)

        res_json = json.loads(save_chat_server(msgs, self.device_id, self.config["selected_module"]))
        if res_json["success"] != True:
            return Exception("save chat history to save has failed.")

        logger.bind(tag=TAG).info("save chat history success")
