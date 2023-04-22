from io import StringIO

rm = set(
    [
        "piny",  # 拼音
        "pinyin",  # 拼音
        "leix",  # 类型
        "dingy",  # 定义
        "tong",  # 同
        "tongs",  # 同时
        "cain",  # 才能
        "gain",  # 概念
        "chaos",  # 超时
        "shul",  # 数量
        "went",  # 问题
        "conger",  # 从而
        "like",  # 立刻
        "hans",  # 函数
        "shashi",  # 啥事
        "zhengzhou",  # 郑州
        "wangle",  # 忘了
        "banyan",  # 扮演
        "wuxian",  # 无限
        "wuxi",  # 无锡
        # 专有名词
        "ip",
        "ios",
        "ui",
    ]
)

ins = [
    ("bytes", "bytes", 16400000),
    ("timestamp", "timestamp", 361000000),
]
ins.sort(key=lambda x: x[1])

buf = StringIO()
cur = 0
occur = {}
with open("easy_en.dict.yaml", "r") as f:
    for line in f:
        s = line.strip()
        if not s:
            buf.write(line)
            continue

        parts = s.split("\t")
        if len(parts) < 2:
            buf.write(line)
            continue

        occur[parts[1]] = True
        while cur < len(ins) and ins[cur][1] < parts[1]:
            if ins[cur][1] not in occur:
                buf.write("%s\t%s\t%d\n" % ins[cur])
            cur += 1

        if parts[1] not in rm:
            buf.write(s)
            buf.write("\n")

with open("easy_en.dict.yaml", "w") as f:
    f.write(buf.getvalue())
