from io import StringIO

rm = set([
  'piny',   #拼音
  'pinyin', #拼音
  'leix',   #类型
  'dingy',  #定义

  # 专有名词
  'ip',
  'ios',
])

buf = StringIO()
with open('easy_en.dict.yaml', 'r') as f:
  for line in f:
    if not line.strip():
      buf.write(line)
      continue

    parts = line.split('\t')
    if len(parts) < 2:
      buf.write(line)
      continue

    if parts[1] not in rm:
      buf.write(line)

with open('easy_en.dict.yaml', 'w') as f:
  f.write(buf.getvalue())
