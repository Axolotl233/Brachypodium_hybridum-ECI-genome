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

plot_bais <- function(x){
  input <- as.character(str_glue("2.fpkm_compare.",x,".txt"))
  out_plot <- as.character(str_glue(x,".pdf"))
  data <- read_delim(input,delim="\t") %>% 
    filter(Class == "Normal",Exp_class == "all")
  data$Log2FC <- as.numeric(data$Log2FC)
  mean = median(data$Log2FC)
  print(mean)
  mean2 = filter(data,Bias != "no_bias") %>%
    select(Log2FC) %>%
    as.data.frame()
  mean2 = median(mean2$Log2FC)
  print(mean2)
  p1 <- ggplot(data)+
    geom_histogram(aes(x=Log2FC,fill = Bias),binwidth = 1,colour= "white",position = "identity",boundary=0)+
    labs(x="Log2Foldchang",y="Gene count")+
    theme_classic()+
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )+
    scale_x_continuous(
      breaks = seq(-8,8,2),limits = c(-8,8)
    )+
    scale_y_continuous(
      limits = c(0,9000)
    )+
    scale_fill_manual(
    #values = c("#fb8072","grey80","#80b1d3")
    values = c("#5DD3B0","grey80","#FC923B")
    )+
    geom_vline(aes(xintercept = mean),colour="#ff7f00",size=0.6,alpha = 2/3,linetype="dashed")+
    theme(
      legend.position = "none"
    )
  ggsave(out_plot,p1,width = 5,height = 3)
}


data1 <- read.table("5.compare_repeat_between_dom_and_undom.new.txt")
data2 <- read.table("5.compare_repeat_between_dom_and_undom.new.abr113.txt")
data3 <- read.table("5.compare_repeat_between_dom_and_undom.new.bd26.txt")
data1$group <- "Bhyb-ECI"
data2$group <- "Bhyb-ABR113"
data3$group <- "Bhyb-26"
data <- bind_rows(data1,data2,data3)
colnames(data) <- c("gene","Subgenome","Bias","TEratio","Pair","Group")
data$Group <- factor(data$Group,levels = c("Bhyb-ECI","Bhyb-ABR113","Bhyb-26"))
tmp_symnum <- list(cutpoints = c(0, 0.01, 0.05, 1), symbols = c("**", "*", "ns"))

ggplot(data,aes(x=Subgenome,y=TEratio)) +
  geom_violin(aes(fill = Subgenome),width=0.5,trim=T, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(values = c("#FF425D","#00BFFF"))+
  scale_y_continuous(breaks = seq(0,1,0.2),limits = c(-0.001,1.1))+
  labs(x="",y = "TE Ratio",title = "Grouped by subgenome") +
  facet_wrap(.~Group)+
  stat_compare_means(comparisons =  list(c("D","S")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))

ggplot(data,aes(x=Bias,y=TEratio)) +
  geom_violin(aes(fill = Bias),width=0.5,trim=F, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#92c5de","#b2abd2")
  )+
  scale_y_continuous(
    breaks = seq(0,1,0.2),
    limits = c(0,1.1)
  )+labs(x="",y = "TE Ratio",title = "Grouped by HEP pattern")+
  facet_wrap(.~Group)+
  stat_compare_means(comparisons =  list(c("dominant","submissive")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))

data <- read.table("5.compare_repeat_between_dom_and_undom.new.txt")
colnames(data) <- c("gene","Subgenome","Bias","TEratio","Pair")
d1 <- data %>% filter(Subgenome == "D") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Subgenome == "S") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
wilcox.test(dd[,2],dd[,5],paired=T)

d1 <- data %>% filter(Bias == "dominant") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Bias == "submissive") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T,alternative = "less")

data <- read.table("5.compare_repeat_between_dom_and_undom.new.abr113.txt")
colnames(data) <- c("gene","Subgenome","Bias","TEratio","Pair")

d1 <- data %>% filter(Subgenome == "D") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Subgenome == "S") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
wilcox.test(dd[,2],dd[,5],paired=T)

d1 <- data %>% filter(Bias == "dominant") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Bias == "submissive") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T,alternative = "less")

data <- read.table("5.compare_repeat_between_dom_and_undom.new.bd26.txt")
colnames(data) <- c("gene","Subgenome","Bias","TEratio","Pair")

d1 <- data %>% filter(Subgenome == "D") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Subgenome == "S") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T)

d1 <- data %>% filter(Bias == "dominant") %>% select(gene,TEratio,Pair)
d2 <- data %>% filter(Bias == "submissive") %>% select(gene,TEratio,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T,alternative = "less")

data <- read.table("4.compare_kaks_between_dom_and_undom.new.filter.txt")
colnames(data) <- c("gene","Subgenome","Bias","NG86","YN00","Pair")
d1 <- data %>% filter(Subgenome == "D") %>% select(gene,YN00,Pair)
d2 <- data %>% filter(Subgenome == "S") %>% select(gene,YN00,Pair)
dd <- bind_cols(d1,d2)
wilcox.test(dd[,2],dd[,5],paired=T)

d1 <- data %>% filter(Bias == "dominant") %>% select(gene,YN00,Pair)
d2 <- data %>% filter(Bias == "submissive") %>% select(gene,YN00,Pair)
dd <- bind_cols(d1,d2)
identical(dd[,3],dd[,6])
wilcox.test(dd[,2],dd[,5],paired=T)

a <- ggplot(data,aes(x=Subgenome,y=YN00))+
  geom_violin(aes(fill = Subgenome),width=0.5,trim=T,color="white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(values = c("#FF425D","#00BFFF"))+
  labs(x="",y = "Ka/Ks",title = "Grouped by subgenome") +
  stat_compare_means(comparisons =  list(c("D","S")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))

b <- ggplot(data,aes(x=Bias,y=YN00)) +
  geom_violin(aes(fill = Bias),width=0.5,trim=T, color = "white")+
  geom_boxplot(width=0.15,position=position_dodge(0.9),fill="white")+
  theme_cowplot()+
  theme(
    legend.position = "none",
    panel.grid = element_blank()
  )+
  scale_fill_manual(
    values = c("#92c5de","#b2abd2")
  )+
  labs(x="",y = "Ka/Ks",title = "Grouped by HEP pattern")+
  stat_compare_means(comparisons =  list(c("dominant","submissive")),
                     method = "wilcox.test", label = "p.format",
                     method.args = list(paired=T))
cowplot::plot_grid(a,b) 