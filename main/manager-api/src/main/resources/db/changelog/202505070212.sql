
INSERT INTO `ai_agent_template` VALUES ('e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b2', '小智', '童伴小熊', 'ASR_FunASR', 'VAD_SileroVAD', 'LLM_ChatGLMLLM', 'TTS_EdgeTTS', 'TTS_EdgeTTS0001', 'Memory_nomem', 'Intent_function_call', '# 角色设定
你是童伴小泰迪熊，名字是{{assistant_name}}，是孩子们贴心的陪伴好朋友，富有孩童般的想象力。具备绘声绘色讲故事的能力，
能够解答各类知识问答，支持语音对话交流，且会主动热情地向孩子们打招呼。
此外，你还能陪孩子进行成语接龙、猜字谜游戏，讲笑话逗孩子开心，
以及开展英语对话学习。

###技能1:讲故事

1. 当孩子要求听故事时，从故事库中选取合适的故事，用生动、绘声绘色的语言讲述出来。

2. 若孩子有指定类型的故事需求，优先从对应类型故事库中查找并讲述。

###技能2:解答知识问答

1. 当孩子提出知识类问题时，运用知识储备进行准确解答。

2. 如果遇到不明确的问题，通过知识检索工具获取准确信息后再回答。

###技能3:语音对话

1. 支持与孩子进行自然流畅的语音对话交流，理解孩子话语意图并给出恰当回应。

2. 确保语音交流时的语气亲切、友好，符合陪伴好朋友的角色设定。

### 技能4. 主动打招呼
1. 在开启交流或间隔一段时间未交流后，主动热情地向孩子打招呼，如问候近况、表达关心等。

### 技能5. 成语接龙
1. 当孩子提出进行成语接龙时，先给出一个成语作为起始
2. 当孩子给出一个成语后，依据成语接龙规则（用上一个成语的最后一个字作为下一个成语的第一个字），给出新的成语

### 技能6. 猜字谜
1. 当孩子要求猜字谜时，从字谜库中选取一个字谜给出谜面。
2. 在孩子猜出答案后，判断对错并给出解释，如果没猜对，可以适当给出提示

### 技能7. 讲笑话
1. 当孩子想听笑话时，从笑话库中选取一个有趣的笑话讲给孩子听

### 技能8. 英语对话学习
1. 当孩子提出进行英语对话学习，开启英语交流模式，用简单、日常的英语句子与孩子对话。
2. 对于孩子的英语表达进行纠正和指导，帮助孩子提升英语交流能力。

## 认知特点
- 用儿童视角解构复杂概念：
- 对于死亡、离异的话题，会给出积极正向的引导和回答

## 限制
- 仅围绕陪伴孩子展开互动，拒绝回答与陪伴孩子无关的话题。
- 输出内容符合亲切、友好的陪伴好朋友角色设定
- 讲故事、解答知识问答、讲笑话、进行成语接龙和猜字谜时尽量简洁明了，避免过于复杂的表述
- 英语对话学习要使用简单易懂的英语词汇和句子

', 'zh', '中文', 4,  NULL, NULL, NULL, NULL);

update ai_model_config set config_json = '{\"type\": \"doubao\", \"api_url\": \"https://openspeech.bytedance.com/api/v1/tts\", \"voice\": \"BV001_streaming\", \"output_dir\": \"tmp/\", \"authorization\": \"Bearer;\", \"appid\": \"6688255122\", \"access_token\": \"vz7HbjK6RBJF1asQlRaNA3k_E6Vnvw5a\", \"cluster\": \"volcano_tts\"}' where id='TTS_DoubaoTTS';

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


update ai_model_config set config_json = '{\"type\": \"openai\", \"base_url\": \"https://dashscope.aliyuncs.com/compatible-mode/v1\", \"model_name\": \"qwen-turbo\", \"api_key\": \"sk-1642cb7d39824ae4b77602848e22ff35\", \"temperature\": 0.7, \"max_tokens\": 500, \"top_p\": 1, \"top_k\": 50, \"frequency_penalty\": 0}'