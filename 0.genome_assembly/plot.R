rm(list=ls())

library(tidyverse)
library(RColorBrewer)
library(viridis)
library(gg.gap)
library(patchwork)
library(ggridges)
library(cowplot)
library(geneRal)
library(ggpubr)
library(ggrepel)
library(ggstatsplot)
library(pheatmap)

## Gap
data1 <- matrix(ncol=2,nrow=3)
data1[,1] <- as.numeric(c(38,29,10748))
data1[,2] <- c("Bhyb-EC","Bhyb-Bd26","Bhyb-ABR113")
data1 <- as.data.frame(data1)
data1$V1 <- as.numeric(data1$V1)
data1$V2 <- factor(data1$V2,levels = c("Bhyb-EC","Bhyb-Bd26","Bhyb-ABR113"))
colnames(data1) <- c("Gap","Assembly")
ggplot(data1)+
  geom_col(aes(x=Assembly,y=Gap,fill=Assembly))+
  theme_bw()+
  theme(
    panel.grid = element_blank()
  )+
  scale_y_log10()+
  scale_fill_manual(
    values = c("#91A4B3","#68B9A6","#7075A1")
  )
## NG
rm(list = ls())
data2 <- read.table("1.NG.txt")
colnames(data2) <- c("length","percent","cum_percent","pos","species")
data2$species <- factor(data2$species,levels = c("Bhyb-EC","Bhyb-bd26","Bhyb-jgi"))
ggplot(data2)+
  geom_line(aes(x=pos,y=length,color=species))+
  scale_y_continuous(
    trans = "log10",
    breaks = c(seq(0,100,10),seq(100,1000,100),seq(1000,10000,1000),seq(1e4,1e5,1e4),
               seq(1e5,1e6,1e5),seq(1e6,1e7,1e6),seq(1e7,1e8,1e7))
  )+
  scale_x_continuous(
    breaks = seq(0,100,20)
  )+
  scale_color_manual(
    values = c("#91A4B3","#68B9A6","#7075A1")
  )+
  theme_bw()+
  theme(
    panel.grid = element_blank()
  )+
  labs(x = "NG(X)%", y = "Contig NG(x) lenghth")+
  geom_vline(aes(xintercept=50),color="grey70",linetype = "dashed")
## LAI
rm(list = ls())

data <- read.table("1.LAI.txt")
colnames(data) <- c("Assembly","raw_LAI","LAI")
data$Assembly <- factor(data$Assembly,levels = c("Bhyb-EC","Bhyb-Bd26","Bhyb-ABR113"))
data <- data %>% filter(LAI > 0)

tmp_symnum <- list(cutpoints = c(0, 0.01, 0.05, 1), symbols = c("**", "*", "ns"))
ggplot(data, aes(x=Assembly, y=LAI))+
  geom_flat_violin(aes(fill=Assembly),position = position_nudge(x=0.13))+
  geom_jitter(aes(color=Assembly),width = 0.06,size=0.5)+
  geom_boxplot(width=.1,position = position_nudge(0.13))+
  scale_fill_manual(
    values = c("#91A4B3","#68B9A6","#7075A1")
  )+
  scale_color_manual(
    values = c("#91A4B3","#68B9A6","#7075A1")
  )+
  theme_bw()+
  theme(
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )+
  stat_compare_means(comparisons =  list(c("Bhyb-EC","Bhyb-Bd26"),
                                         c("Bhyb-ABR113","Bhyb-Bd26"),
                                         c("Bhyb-EC","Bhyb-ABR113")
                                         ) ,
                     method = "wilcox.test", label = "p.signif", symnum.args = tmp_symnum)