
update ai_model_config set config_json = '{\"type\": \"doubao\", \"api_url\": \"https://openspeech.bytedance.com/api/v1/tts\", \"voice\": \"BV001_streaming\", \"output_dir\": \"tmp/\", \"authorization\": \"Bearer;\", \"appid\": \"8036145556\", \"access_token\": \"9C3I1ZVpQ6WI4EnrfSlc27q382XlQt5E\", \"cluster\": \"volcano_tts\"}' where id='TTS_DoubaoTTS';

update ai_model_config set config_json = '{\"type\": \"siliconflow\", \"model\": \"FunAudioLLM/CosyVoice2-0.5B\", \"voice\": \"FunAudioLLM/CosyVoice2-0.5B:alex\", \"output_dir\": \"tmp/\", \"access_token\": \"sk-gcjodbzlrfghtovrrbqkfqikjgagimufiicowewqwlkbddul\", \"response_format\": \"wav\"}' where id='TTS_CosyVoiceSiliconflow';

INSERT INTO `ai_tts_voice` VALUES ('TTS_CosyVoiceSiliconflow0003', 'TTS_CosyVoiceSiliconflow', 'CosyVoice慵懒女声', 'speech:ss_1:mb30kqltfb:qmtzvuswryrickyzqolj', '中文', NULL, NULL, 6, NULL, NULL, NULL, NULL);
delete from `ai_tts_voice` where id='TTS_CosyVoiceSiliconflow0007';
INSERT INTO `ai_tts_voice` VALUES ('TTS_CosyVoiceSiliconflow0007', 'TTS_CosyVoiceSiliconflow', '熊二小时候', 'speech:xionger_child:mb30kqltfb:nqapmfgnewkdjurtrafj', '中文', NULL, NULL, 6, NULL, NULL, NULL, NULL);
delete from `ai_tts_voice` where id='TTS_CosyVoiceSiliconflow0005';
INSERT INTO `ai_tts_voice` VALUES ('TTS_CosyVoiceSiliconflow0005', 'TTS_CosyVoiceSiliconflow', '太乙真人', 'speech:taiyizhenren:mb30kqltfb:sdatwdoizkjogpqijijf', '中文', NULL, NULL, 6, NULL, NULL, NULL, NULL);

delete from `ai_tts_voice` where id='TTS_CosyVoiceSiliconflow0004';
INSERT INTO `ai_tts_voice` VALUES ('TTS_CosyVoiceSiliconflow0004', 'TTS_CosyVoiceSiliconflow', '猴哥', 'speech:houge:mb30kqltfb:vjrylggmmpdhfokujrkb', '中文', NULL, NULL, 6, NULL, NULL, NULL, NULL);
delete from `ai_tts_voice` where id='TTS_CosyVoiceSiliconflow0006';
INSERT INTO `ai_tts_voice` VALUES ('TTS_CosyVoiceSiliconflow0006', 'TTS_CosyVoiceSiliconflow', '熊二', 'speech:xionger:mb30kqltfb:zydjyrujzkdkofgkidwx', '中文', NULL, NULL, 6, NULL, NULL, NULL, NULL);
delete from `ai_tts_voice` where id='TTS_CosyVoiceSiliconflow1008';
INSERT INTO `ai_tts_voice` VALUES ('TTS_CosyVoiceSiliconflow1008', 'TTS_CosyVoiceSiliconflow', '佩奇', 'speech:peiqi:mb30kqltfb:yryulxqkbkqcfxmbubti', '中文', NULL, NULL, 6, NULL, NULL, NULL, NULL);
delete from `ai_tts_voice` where id='TTS_CosyVoiceSiliconflow1009';
INSERT INTO `ai_tts_voice` VALUES ('TTS_CosyVoiceSiliconflow1009', 'TTS_CosyVoiceSiliconflow', '天才儿童','speech:tiancaiertong:mb30kqltfb:ihgpletzitogdxdinfup', '中文', NULL, NULL, 6, NULL, NULL, NULL, NULL);
delete from `ai_tts_voice` where id='TTS_CosyVoiceSiliconflow1010';
INSERT INTO `ai_tts_voice` VALUES ('TTS_CosyVoiceSiliconflow1010', 'TTS_CosyVoiceSiliconflow', '萌丫头','speech:mengyatou:mb30kqltfb:uwadvquigcosfljkxghu', '中文', NULL, NULL, 6, NULL, NULL, NULL, NULL);


update ai_model_config set config_json = '{\"type\": \"openai\", \"base_url\": \"https://dashscope.aliyuncs.com/compatible-mode/v1\", \"model_name\": \"qwen-turbo\", \"api_key\": \"sk-1642cb7d39824ae4b77602848e22ff35\", \"temperature\": 0.7, \"max_tokens\": 500, \"top_p\": 1, \"top_k\": 50, \"frequency_penalty\": 0}' where id='LLM_AliLLM';


update `ai_model_config` set config_json='{\"type\": \"openai\", \"model_name\": \"glm-4-flash\", \"base_url\": \"https://open.bigmodel.cn/api/paas/v4/\", \"api_key\": \"616f4cdca4d64f279b4ff9e6bae58470.FuYnwkCBbApJcn75\"}' where id='LLM_ChatGLMLLM';

update `ai_model_config` set config_json='{\"type\": \"openai\", \"base_url\": \"https://ark.cn-beijing.volces.com/api/v3\", \"model_name\": \"doubao-pro-32k-functioncall-241028\", \"api_key\": \"3f335a9e-ad91-48d2-bc5c-683750f7b356\"}' where id='LLM_DoubaoLLM';


delete from ai_tts_voice where `name` in ('通用女声','活泼女声', '知性姐姐', '灿灿', '炀炀', '温柔小哥');
INSERT INTO `ai_tts_voice` VALUES ('TTS_DoubaoTTS1006', 'TTS_DoubaoTTS', '活泼女声', 'BV051_streaming', '普通话', 'https://lf3-speech.bytetos.com/obj/speech-tts-external/portal/Portal_Demo_BV051.mp3', NULL, 5, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_DoubaoTTS1006', 'TTS_DoubaoTTS', '知性姐姐', 'BV051_streaming', '普通话', 'https://lf3-speech.bytetos.com/obj/speech-tts-external/portal/Portal_Demo_BV051.mp3', NULL, 5, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_DoubaoTTS1006', 'TTS_DoubaoTTS', '灿灿', 'BV051_streaming', '普通话', 'https://lf3-speech.bytetos.com/obj/speech-tts-external/portal/Portal_Demo_BV051.mp3', NULL, 5, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_DoubaoTTS1006', 'TTS_DoubaoTTS', '炀炀', 'BV051_streaming', '普通话', 'https://lf3-speech.bytetos.com/obj/speech-tts-external/portal/Portal_Demo_BV051.mp3', NULL, 5, NULL, NULL, NULL, NULL);
INSERT INTO `ai_tts_voice` VALUES ('TTS_DoubaoTTS1006', 'TTS_DoubaoTTS', '温柔小哥', 'BV051_streaming', '普通话', 'https://lf3-speech.bytetos.com/obj/speech-tts-external/portal/Portal_Demo_BV051.mp3', NULL, 5, NULL, NULL, NULL, NULL);
