from io import StringIO

rm = set([
  'piny',   #拼音
  'pinyin', #拼音
  'leix',   #类型
  'dingy',  #定义
  'tong',   #同
  'tongs',  #同时

  # 专有名词
  'ip',
  'ios',
])

ins = [
  ('bytes', 'bytes', 16400000),
]
ins.sort(key=lambda x: x[1])

buf = StringIO()
cur = 0
occur = {}
with open('easy_en.dict.yaml', 'r') as f:
  for line in f:
    if not line.strip():
      buf.write(line)
      continue

    parts = line.split('\t')
    if len(parts) < 2:
      buf.write(line)
      continue

    occur[parts[1]] = True
    while cur < len(ins) and ins[cur][1] < parts[1]:
      if ins[cur][1] not in occur:
        buf.write('%s\t%s\t%d\n' % ins[cur])
      cur += 1

    if parts[1] not in rm:
      buf.write(line)

with open('easy_en.dict.yaml', 'w') as f:
  f.write(buf.getvalue())
