from pyecharts import options as opts
from pyecharts.charts import Map
from pyecharts.faker import Faker
import os

# 基础数据
value = [1,2,2,1,1,9,2,1,1,1,23]
attr = ["Italy","India","Germany","Romania","Bulgaria","China","Poland","Spain","Canada","New Zealand","United States"]

data = []
for index in range(len(attr)):
    city_ionfo=[attr[index],value[index]]
    data.append(city_ionfo)

c = (
    Map()
    .add("世界地图",data, "world")
    .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
    .set_global_opts(
        visualmap_opts=opts.VisualMapOpts(max_=30),

    )
    .render()
)

# 打开html
os.system("render.html")