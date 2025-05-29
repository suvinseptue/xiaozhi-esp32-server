package xiaozhi.modules.security.utils;

import java.util.Random;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
public class FunnyNicknameGenerator {
    private static final Random random = new Random();

    // 主体词库（日常物品、动物、食物等）
    private static final String[] MAIN_WORDS = {
            "奶茶", "猫", "拖鞋", "手机", "袜子", "西瓜", "耳机", "马桶", "快递", "枕头",
            "狗", "冰淇淋", "键盘", "空调", "沙发", "拖把", "番茄", "牙刷", "外卖", "雨伞"
    };

    // 搞笑修饰词（夸张、反差、网络热词）
    private static final String[] MODIFIERS = {
            "会飞的", "过期的", "社恐的", "欠揍的", "话多的", "掉毛的", "酸掉牙的", "漏电的",
            "叛逆的", "躺平的", "黏人的", "爱吐槽的", "半夜抽风的", "自带BGM的", "偷外卖的",
            "怕热的", "怕冷的", "会说相声的", "沉迷追剧的", "想退休的", "有强迫症的"
    };

    // 场景/动作词（日常行为、网络梗）
    private static final String[] SCENES = {
            "蹲墙角", "爬冰箱", "偷WiFi", "追快递", "打呼", "拆快递", "踩奶", "掉毛", "溜弯",
            "啃沙发", "看剧", "吃宵夜", "玩手机", "晾袜子", "抢空调", "装高冷", "唠嗑",
            "等外卖", "挖鼻孔", "发弹幕", "翻白眼"
    };

    // 无厘头后缀（增强搞笑语气）
    private static final String[] SUFFIXES = {
            "子", "菌", "精", "星人", "选手", "大师", "王者", "专家", "爱好者", "特工",
            "冠军", "吉祥物", "代言人", "野生版", "限定款", "老艺术家"
    };

    // 谐音梗词库（字+谐音字，纯文字组合）
    private static final String[][] HOMOPHONE = {
            {"茶", "查"}, {"袜", "挖"}, {"机", "鸡"}, {"枕", "真"}, {"拖", "脱"},
            {"西", "稀"}, {"牙", "鸭"}, {"快", "筷"}, {"奶", "耐"}, {"猫", "毛"}
    };


    /**
     * 生成无符号无数字的搞笑网名
     */
    public static String generateFunnyNickname() {
        // 随机选择生成结构（5种搞笑结构）
        int structure = random.nextInt(5);
        String nickname;

        switch (structure) {
            case 0: // 结构1: 修饰词 + 主体词 + 后缀（例：欠揍的奶茶精）
                nickname = MODIFIERS[random.nextInt(MODIFIERS.length)]
                        + MAIN_WORDS[random.nextInt(MAIN_WORDS.length)]
                        + SUFFIXES[random.nextInt(SUFFIXES.length)];
                break;

            case 1: // 结构2: 主体词 + 的 + 场景 + 后缀（例：拖鞋的蹲墙角选手）
                nickname = MAIN_WORDS[random.nextInt(MAIN_WORDS.length)]
                        + "的" + SCENES[random.nextInt(SCENES.length)]
                        + SUFFIXES[random.nextInt(SUFFIXES.length)];
                break;

            case 2: // 结构3: 谐音梗（例：奶查）
                String[] homo = HOMOPHONE[random.nextInt(HOMOPHONE.length)];
                nickname = homo[0] + homo[1];
                break;

            case 3: // 结构4: 主体词 + 动作 + 意外结果（例：西瓜爬冰箱被冻哭）
                nickname = MAIN_WORDS[random.nextInt(MAIN_WORDS.length)]
                        + SCENES[random.nextInt(SCENES.length)]
                        + "被" + MODIFIERS[random.nextInt(MODIFIERS.length)];
                break;

            case 4: // 结构5: 夸张修饰 + 主体词（例：半夜抽风的耳机）
                nickname = MODIFIERS[random.nextInt(MODIFIERS.length)]
                        + MAIN_WORDS[random.nextInt(MAIN_WORDS.length)];
                break;

            default: // 备用结构
                nickname = "搞笑的" + MAIN_WORDS[random.nextInt(MAIN_WORDS.length)];
        }

        return nickname;
    }
}
