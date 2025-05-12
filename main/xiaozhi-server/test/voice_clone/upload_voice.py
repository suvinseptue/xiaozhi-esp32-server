import requests

url = "https://api.siliconflow.cn/v1/uploads/audio/voice"
headers = {
    "Authorization": "Bearer sk-gcjodbzlrfghtovrrbqkfqikjgagimufiicowewqwlkbddul" # 从 https://cloud.siliconflow.cn/account/ak 获取
}
files = {
    "file": open("/Users/yangsuwen/AI玩具/萌丫头.mp3", "rb") # 参考音频文件
}
data = {
    "model": "FunAudioLLM/CosyVoice2-0.5B", # 模型名称
    "customName": "mengyatou", # 参考音频名称
    "text": "我今天在花园里看到好多漂亮的蝴蝶，它们飞来飞去，像在跳舞，我要是也能像他们一样自由自在就好了。" # 参考音频的文字内容
}

response = requests.post(url, headers=headers, files=files, data=data)

print(response.status_code)
print(response.json())  # 打印响应内容（如果是JSON格式）