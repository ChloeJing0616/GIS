---
title: "homework"
output: html_document
date: "2025-11-03"
---
  ## load library
  ##三根反引号在 Markdown 里标记代码块
```{r}
install.packages("sf")
install.packages("tidyverse")
library(sf)
library(tidyverse) 
```
## Data loading

```{r}
shape <- st_read("/Users/GIS/WK1/practical/statsnz-territorial-authority-2018-generalised-SHP/territorial-authority-2018-generalised.shp")
##check crs
st_crs(shape)
# dTolerance is the distance in which any “wiggles” will be straightened
shape_simple <- st_simplify(shape, dTolerance = 1000)

employed_2018 <- read_csv("/Users/GIS/WK1/practical/status_edited.csv")


# added test to last row to make character for example
# 检查shape_simple的数据结构
Datatypelist <- shape_simple %>% 
  ##summarise_all()是dplyer函数中，对所有列执行同一个操作；class()是Rstudio中挤出函数，查看列的分类
  ##换了sapply()函数，因为summarise_all()函数十分介意空间数据，不能对空间数据class
  Datatypelist <- sapply(st_drop_geometry(shape_simple), class)
Datatypelist


# Datatypelist2 <- employed_2018_2 %>% 
#   summarise_all(class)
# Datatypelist

summary(shape_simple)
##绘制shape图，st_geometry()是提取空间几何信息
shape_simple %>%
  st_geometry()%>%
  plot()
```
## Data manipulation 

```{r}
# join on the description 
#检查一下shape_simple和employed_2018都有什么列
names(shape_simple)
names(employed_2018)
shape2 <- shape_simple%>%
  merge(.,
        employed_2018,
        by.x="TA2018_V_1", 
        by.y="...2")
```

##Join on the ID by making the column numeric
```{r}

###y在excel中叫Table 5
shape3 <- shape_simple %>%
##mutate()是在文本框中添加新的列，as.numeric()是将文本类型转化为数字类型
  mutate(TA2018_V1_=(as.numeric(TA2018_V1_)))%>%
  merge(.,
        employed_2018,
        by.x="TA2018_V1_", 
        by.y="Table 5")

#or 

# shape3 <- shape %>%
#   transform(., TA2018_V1_ = as.numeric(TA2018_V1_))%>%
#   merge(.,
#         employed_2018,
#         by.x="TA2018_V1_", 
#         by.y="Area_Code")

# or also 
#shape$TA2018_V1_ = as.numeric(shape$TA2018_V1_)
```

## Data mapping

```{r}
library(tmap)
shape2$`...3` <- as.numeric(shape2$`...3`)
tmap_mode("plot")
# change the fill to your column name if different
#看看shape2到底什么名字
names(shape2)
my_map<-shape2 %>%
  qtm(.,fill = "...3")

my_map
```

